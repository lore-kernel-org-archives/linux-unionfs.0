From: Vito Caputo <vito.caputo@coreos.com>
Subject: Re: Stable inode numbers
Date: Fri, 22 Jul 2016 13:55:56 -0700
Message-ID: <CAKp8XJ4Lfx06of5D4aVkg2up77xESZ9cy0z2PGn1g6-AoHvE8g@mail.gmail.com>
References: <CAKp8XJ41QeG03E_AW4cxsuyp4-uxrPWAkhKc60OMp3vK2YAADA@mail.gmail.com>
 <20160722121503.GC20504@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33498 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbcGVUz5 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 22 Jul 2016 16:55:57 -0400
Received: by mail-io0-f176.google.com with SMTP id 38so115759413iol.0
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Jul 2016 13:55:57 -0700 (PDT)
In-Reply-To: <20160722121503.GC20504@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On Fri, Jul 22, 2016 at 5:15 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jul 21, 2016 at 04:33:38PM -0700, Vito Caputo wrote:
>> Hello list,
>>
>> We're receiving bug reports from users simply untarring archives onto overlayfs
>> mounts (docker + overlayfs) where tar fails with "Directory renamed before its
>> status could be extracted" errors.
>>
>> This is triggered in GNU tar when the inode number of an ancestor directory
>> changes unexpectedly in the deferred application of ancestral metadata.
>>
>> It's not consistently reproducible, but in a slightly memory-constrained vm it
>> is very easy to reproduce.
>>
>> What appears to be happening is the tar extraction activity is churning through
>> the kernel's cache so a subsequent lookup of the directory in question returns
>> a new inode number.  One can easily simulate this using `stat` and `echo 2 >
>> /proc/sys/vm/drop_caches` to observe the overlayfs inode number change across
>> the cache drop.
>>
>> The seemingly erratic nature of this failure is particularly frustrating for
>> users, as it gives the impression things _should_ work and just randomly aren't
>> due to a bug.  Scrutiny of the overlayfs implementation reveals that unstable
>> inode numbers is intentional, and spurious failures of applications which
>> notice intersecting relevant cache evictions should be expected.
>>
>> Are there any plans or strategies for changing this situation in overlayfs?
>>
>> I can think of a few potential solutions, but they all tend to revolve around
>> persistently allocating inode numbers on first lookup, which of course requires
>> both space and time overlayfs currently elides.
>
> Hmm, I haven't thought about this problem yet.
>
> Maybe we are better off returning the underlying dev/ino in stat (which is
> persistent long term, but not persistent during copy-up).  This would be
> cheating a bit, since stat would then return the same numbers for the overlay
> directory and the underlying directory, which can be different (unlike
> non-directories, which overlayfs returns verbatim).
>
> Can you please try the following patch.  It passes unionmount-testsuite with the
> layering check disabled.
>

The patch eliminates the errors from tar in the test I've been using
to reproduce the user-reported issues.  However, I'm doubtful of it
being a satisfactory general solution because the inode number of a
pre-existing directory which undergoes copy-up spuriously changes.

There's probably a scenario where this still upsets tar when
extracting over an partial tree pre-existing in the lower layer,
adding names to existing directories, causing their inode numbers to
change.

The relevant code where tar detects these shenanigans may be seen here:
http://git.savannah.gnu.org/cgit/tar.git/tree/src/extract.c#n867

Perhaps we can come up with a better, more general solution without
adding substantial complexity or overhead?

Thanks,
Vito Caputo

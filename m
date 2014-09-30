From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PULL for 3.18] overlay filesystem v24
Date: Tue, 30 Sep 2014 09:31:24 +0200
Message-ID: <CAJfpeguWkWOeWYS1o2gW4P1DJhXn=enBGukPcfscd-guas7h8w@mail.gmail.com>
References: <20140929141457.GB5011@tucsk.piliscsaba.szeredi.hu>
	<26822.1412028003@warthog.procyon.org.uk>
	<27645.1412052879@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57660 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaI3HbY (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 30 Sep 2014 03:31:24 -0400
Received: by mail-qa0-f46.google.com with SMTP id cs9so3176933qab.33
        for <linux-unionfs@vger.kernel.org>; Tue, 30 Sep 2014 00:31:24 -0700 (PDT)
In-Reply-To: <27645.1412052879@jrobl>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-unionfs@vger.kernel.org

On Tue, Sep 30, 2014 at 6:54 AM, J. R. Okajima <hooanon05g@gmail.com> wrote:
>
> David Howells:
>> Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> > I'd like to propose overlayfs for inclusion into 3.18.
>> >
>> > Al, would you mind giving it a review?
>> >
>> > Git tree is here:
>> >
>> >   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.current
>>
>> Tested-by: David Howells <dhowells@redhat.com>
>
> Does it mean overlayfs passed all your unionmount-testsuite? And does
> the test suite contain tests for "inode-based" union? For example,
> - read(2) may get the obsoleted filedata (fstat(2) for metadata too).
> - fcntl(F_SETLK) may be broken by copy-up.
> - inotify may not work when it refers to the file before being
>   copied-up.
> - unnecessary copy-up may happen, for example mmap(MAP_PRIVATE) after
>   open(O_RDWR).
> - exporting via NFS and fhandle systemcalls will not work.

Most of this is explicitly documented.

>
> A few releases ago, OFD file-lock was introduced to improve the
> behaviour of POSIX lock. POSIX lock has made users confused and I am
> afraid that the similar story will come up because of the "name-based"
> union behaviour. Of course the story is not limited to the file-lock.
>
> If I remember correctly, are you the one who consitunes the development
> of UnionMount? Is the development totally stopped?
> Next paragraph is what I wrote several times.
>         AUFS is an "inode-based" stackable filesystem and solved them many years
>         ago. But I have to admit that AUFS is big. Yes it is grown up.
>         I don't stop including overlayfs into mainline, but if the development
>         of UnionMount is really stopped, then I'd ask people to consider merging
>         aufs as well as overlayfs.

Union-mounts are namespace based as well.  There's little semantic
difference between overlayfs and union-mounts.  The difference is
mostly in the implementation.

It would be good to have an inode based union as well.  I suggest (as
I suggested many times) to try slimming aufs to a bare minimum and
submit that.  It may be easier to just start from scratch instead
trying to drop features from the existing codebase.   I'd be happy to
review and generally help with such an effort.

Thanks,
Miklos

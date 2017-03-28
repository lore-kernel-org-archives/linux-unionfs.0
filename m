From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [REGRESSION 4.11] Commit d8514d8edb5b ("ovl: copy up regular file
 using O_TMPFILE") breaks ubifs
Date: Tue, 28 Mar 2017 06:43:07 -0400
Message-ID: <CAOQ4uxgpFBFEk9h9eowQmeaC60xTFno0RsvA7MhkN9a=AeHhCg@mail.gmail.com>
References: <20170328100107.25095af6@gmail.com> <CAOQ4uxisw5vWYsdMTNemw=MqNyS2nxfAUkg+UfoGmbE3-he1Ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36176 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754572AbdC1KnX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Mar 2017 06:43:23 -0400
In-Reply-To: <CAOQ4uxisw5vWYsdMTNemw=MqNyS2nxfAUkg+UfoGmbE3-he1Ug@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org, regressions@leemhuis.info, Richard Weinberger <richard@nod.at>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>

On Tue, Mar 28, 2017 at 5:27 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Mar 28, 2017 at 4:01 AM, Ralph Sennhauser
> <ralph.sennhauser@gmail.com> wrote:
>> Hi Amir
>>
>> Commit d8514d8edb5b ("ovl: copy up regular file using O_TMPFILE")
>> breaks squashfs with an ubifs overlay (both ubi volumes of the same
>> container).
>>
>
> Hi Ralph,
>
> I am confused by the description above. Which are the 'both ubi volumes'?
>
> Can you provide exact command of overlayfs mount, preferably
> also a script to generate the lower/upper images and mount them
> to remove any mkfs option doubts from test setup.
>
>> Renaming a file results in an error "UBIFS error (ubi0:1 pid 1394):
>> ubifs_add_orphan: orphaned twice". This corrupts the the filesystem and
>> the next attempt to mount the overlay will fail.
>>

Looking at the ubifs code, it does not appear that ubifs_link() ever calls
ubifs_delete_orphan() for the case of linking a temp file (nlink == 0),
so this looks like a ubifs bug.

Is ubifs being tested with xfstests? This should have been caught by test
generic/004 (link tempfile then delete it).

A quick fix for ubifs+overlayfs would be to disable ubifs O_TMPFILE
support (because it is broken) and then overlayfs won't try to copy up
using tmpfile.

Amir.

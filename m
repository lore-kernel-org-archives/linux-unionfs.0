From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [WIP][RFC] questions about overlay index dir design
Date: Thu, 18 May 2017 10:47:06 +0300
Message-ID: <CAOQ4uxiDz1ko7On_B7RFsfnsU5xWweWzoO46MuwADYpzBcdF7g@mail.gmail.com>
References: <CAOQ4uxgTG5JhmAb2hQF0ZoyFAfdOCSPDcScNL=8y7xJ1sXiHJg@mail.gmail.com>
 <5981.1495091489@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35158 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755051AbdERHrI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 May 2017 03:47:08 -0400
Received: by mail-oi0-f47.google.com with SMTP id l18so44203529oig.2
        for <linux-unionfs@vger.kernel.org>; Thu, 18 May 2017 00:47:07 -0700 (PDT)
In-Reply-To: <5981.1495091489@jrobl>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>

On Thu, May 18, 2017 at 10:11 AM, J. R. Okajima <hooanon05g@gmail.com> wrote:
> Amir Goldstein:
>> WIP is at https://github.com/amir73il/linux/commits/ovl-index-dir.
>> I could post patches, but I rather not spam you now unless asked.
>>
>> So far it does the job of creating the non-dir upper hardlinks in index
>> dir and unbreaking hardlinks on copy up (ignoring concurrent copy up
>> of 2 lower hardlinks for now).
>
> The very basic design (as a first step) is close to aufs' "pseudo-link".

Thanks for taking the time to review the design!

I am half ashamed that I did not study the prior art, half proud
that we reached a similar design independently. This is a strong
indication for getting something right ;)

>
> (from linux/Documentation/filesystems/aufs/design/0strcut.txt)
> ----------------------------------------
> Pseudo-link
> ----------------------------------------------------------------------
> Assume "fileA" exists on the lower readonly branch only and it is
> hardlinked to "fileB" on the branch. When you write something to fileA,
> aufs copies-up it to the upper writable branch. Additionally aufs
> creates a hardlink under the Pseudo-link Directory of the writable
> branch. The inode of a pseudo-link is kept in aufs super_block as a
> simple list. If fileB is read after unlinking fileA, aufs returns
> filedata from the pseudo-link instead of the lower readonly
> branch. Because the pseudo-link is based upon the inode, to keep the
> inode number by xino (see above) is essentially necessary.
>
> All the hardlinks under the Pseudo-link Directory of the writable branch
> should be restored in a proper location later. Aufs provides a utility
> to do this. The userspace helpers executed at remounting and unmounting
> aufs by default.
> During this utility is running, it puts aufs into the pseudo-link
> maintenance mode. In this mode, only the process which began the
> maintenance mode (and its child processes) is allowed to operate in
> aufs. Some other processes which are not related to the pseudo-link will
> be allowed to run too, but the rest have to return an error or wait
> until the maintenance mode ends. If a process already acquires an inode
> mutex (in VFS), it has to return an error.
> ----------------------------------------
>
> How do you think about the lifetime of the entries under ovl-index-dir?
> Aufs has a user-space utility to restore/reproduce all hardlinks on the
> upper writable layer, and it removes the entries under Pseudo-link
> Directory.
>

Good question.
At first glance, my plan was to keep the indexed entries forever (*).
We need those entries, as well as similar entries for lower directories,
for mapping lower file handle to overlay inode in order to implement
NFS export of overlayfs.

I don't see an immediate need to restore all upper hardlinks.
Instead I plan to find the index entry lazily at overlay dentry lookup
time and store it in the overlay dentry for lower hardlinks that have not
been copied up yet (i.e. as __roupperdentry) as link the upper hardlink
on attempt to copy it up. Something along the lines of this WIP:
https://github.com/amir73il/linux/commits/ovl-rocopyup

(*) The only problem I have with this design is knowing when the index
entry has become 'orphan', meaning that all lower hardlinks have been
whited out, no new upper hardlinks remain and no open file descriptors
to upper inode remain that may still be linked.
It is easy to handle some of the simpler cases (lower nlink=1 or isdir),
but for the lower hardlink case, I guess we will have to keep negative
nlink count in the upper inode, increment it on whiteout of lower hardlinks
and check when negative nlink reaches lower nlink.
This can also help sort out the value of nlink returned by stat(2).

Let me know if the above sounds sane to you.

Thanks,
Amir.

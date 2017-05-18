From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [WIP][RFC] questions about overlay index dir design
Date: Thu, 18 May 2017 16:11:29 +0900
Message-ID: <5981.1495091489@jrobl>
References: <CAOQ4uxgTG5JhmAb2hQF0ZoyFAfdOCSPDcScNL=8y7xJ1sXiHJg@mail.gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail05-md.ns.itscom.net ([175.177.155.115]:47638 "EHLO
        mail05-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752898AbdERHLb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 May 2017 03:11:31 -0400
In-Reply-To: <CAOQ4uxgTG5JhmAb2hQF0ZoyFAfdOCSPDcScNL=8y7xJ1sXiHJg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>

Amir Goldstein:
> WIP is at https://github.com/amir73il/linux/commits/ovl-index-dir.
> I could post patches, but I rather not spam you now unless asked.
>
> So far it does the job of creating the non-dir upper hardlinks in index
> dir and unbreaking hardlinks on copy up (ignoring concurrent copy up
> of 2 lower hardlinks for now).

The very basic design (as a first step) is close to aufs' "pseudo-link".

(from linux/Documentation/filesystems/aufs/design/0strcut.txt)
----------------------------------------
Pseudo-link
----------------------------------------------------------------------
Assume "fileA" exists on the lower readonly branch only and it is
hardlinked to "fileB" on the branch. When you write something to fileA,
aufs copies-up it to the upper writable branch. Additionally aufs
creates a hardlink under the Pseudo-link Directory of the writable
branch. The inode of a pseudo-link is kept in aufs super_block as a
simple list. If fileB is read after unlinking fileA, aufs returns
filedata from the pseudo-link instead of the lower readonly
branch. Because the pseudo-link is based upon the inode, to keep the
inode number by xino (see above) is essentially necessary.

All the hardlinks under the Pseudo-link Directory of the writable branch
should be restored in a proper location later. Aufs provides a utility
to do this. The userspace helpers executed at remounting and unmounting
aufs by default.
During this utility is running, it puts aufs into the pseudo-link
maintenance mode. In this mode, only the process which began the
maintenance mode (and its child processes) is allowed to operate in
aufs. Some other processes which are not related to the pseudo-link will
be allowed to run too, but the rest have to return an error or wait
until the maintenance mode ends. If a process already acquires an inode
mutex (in VFS), it has to return an error.
----------------------------------------

How do you think about the lifetime of the entries under ovl-index-dir?
Aufs has a user-space utility to restore/reproduce all hardlinks on the
upper writable layer, and it removes the entries under Pseudo-link
Directory.


J. R. Okajima

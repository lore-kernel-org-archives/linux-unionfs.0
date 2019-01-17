Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34375 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfAQPoa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Jan 2019 10:44:30 -0500
MIME-Version: 1.0
References: <20190116173945.mmnwsw5bglk6yryj@merlin> <CAOQ4uxgDi38dX0VLfHZ8R_fesN=0rBQB7Cw0ObRqy5fUqFepTQ@mail.gmail.com>
 <20190117150212.t4snb6jynran2dvn@merlin>
In-Reply-To: <20190117150212.t4snb6jynran2dvn@merlin>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 17 Jan 2019 17:44:17 +0200
Message-ID: <CAOQ4uxiO491WYPBAf1zZCfL-nzEz0kzPNRBcXr5MrexWNjZb7Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: IMA Call ima_post_mknod_path() on copy_up'd dentry
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, zohar@linux.ibm.com, iforster@suse.de, linux-integrity@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Jan 17, 2019 at 5:02 PM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
> On  8:57 17/01, Amir Goldstein wrote:
> > On Thu, Jan 17, 2019 at 1:22 AM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> > >
> > > Since copy_up() happens when you are modifying a file on overlay,
> > > it is still a new file for the underlying filesystem. Mark it
> > > in IMA for re-evaluating as a new file.
> > >
> > > Putting ima calls within overlayfs may not be the best method, but this is
> > > the only one which I thought would work.
> > >
> >
> > Doesn't look right.
> > Overlayfs creates the new inode with vfs_tmpfile() and I think that is
> > where you should plug the IMA hook.
> >
> > > Here is a test case:
> > > mount /dev/vdb /lower
> > > mount /dev/vdc /upper
> > > echo "Original contents" > /lower/existingfile.txt
> > > mount -t overlay overlay /mnt -o upperdir=/upper/upper,workdir=/upper/workdir,lowerdir=/lower
> > > echo "New contents" > /mnt/existingfile.txt
> > >
> >
> > I bet you can reproduce that same issue without overlayfs
> > by creating an O_TMPFILE from userspace.
> >
> > The ima_file_check() hook in do_last() does not cover the O_TMPFILE
> > case.
> >
>
> The problem you mention was resolved by https://lkml.org/lkml/2018/12/18/809
> which I have in my tree.
>

The proposed hook ima_post_create_tmpfile() inside do_tmpfile()
takes a file argument, uses only file_inode() and sets IMA_NEW_FILE.

Now because that hook does not get called from vfs_tmpfile()
you want to add more ima hook inside overlayfs code after calling
vfs_tmpfile().

If you move the IMA hook inside vfs_tmpfile() and pass the dentry
or inode, you will get the same result and you won't need to change
overlayfs code.

Is there a problem with that proposal?

Thanks,
Amir.

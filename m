Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34472 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728033AbfAQPCQ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Jan 2019 10:02:16 -0500
Date: Thu, 17 Jan 2019 09:02:12 -0600
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH] ovl: IMA Call ima_post_mknod_path() on copy_up'd dentry
Message-ID: <20190117150212.t4snb6jynran2dvn@merlin>
References: <20190116173945.mmnwsw5bglk6yryj@merlin>
 <CAOQ4uxgDi38dX0VLfHZ8R_fesN=0rBQB7Cw0ObRqy5fUqFepTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgDi38dX0VLfHZ8R_fesN=0rBQB7Cw0ObRqy5fUqFepTQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, zohar@linux.ibm.com, iforster@suse.de, linux-integrity@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On  8:57 17/01, Amir Goldstein wrote:
> On Thu, Jan 17, 2019 at 1:22 AM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> >
> > Since copy_up() happens when you are modifying a file on overlay,
> > it is still a new file for the underlying filesystem. Mark it
> > in IMA for re-evaluating as a new file.
> >
> > Putting ima calls within overlayfs may not be the best method, but this is
> > the only one which I thought would work.
> >
> 
> Doesn't look right.
> Overlayfs creates the new inode with vfs_tmpfile() and I think that is
> where you should plug the IMA hook.
> 
> > Here is a test case:
> > mount /dev/vdb /lower
> > mount /dev/vdc /upper
> > echo "Original contents" > /lower/existingfile.txt
> > mount -t overlay overlay /mnt -o upperdir=/upper/upper,workdir=/upper/workdir,lowerdir=/lower
> > echo "New contents" > /mnt/existingfile.txt
> >
> 
> I bet you can reproduce that same issue without overlayfs
> by creating an O_TMPFILE from userspace.
> 
> The ima_file_check() hook in do_last() does not cover the O_TMPFILE
> case.
> 

The problem you mention was resolved by https://lkml.org/lkml/2018/12/18/809
which I have in my tree.

The current patch is on top of that.

-- 
Goldwyn

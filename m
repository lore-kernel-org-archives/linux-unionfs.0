Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36812 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727601AbfAQG5S (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Jan 2019 01:57:18 -0500
MIME-Version: 1.0
References: <20190116173945.mmnwsw5bglk6yryj@merlin>
In-Reply-To: <20190116173945.mmnwsw5bglk6yryj@merlin>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 17 Jan 2019 08:57:06 +0200
Message-ID: <CAOQ4uxgDi38dX0VLfHZ8R_fesN=0rBQB7Cw0ObRqy5fUqFepTQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: IMA Call ima_post_mknod_path() on copy_up'd dentry
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, zohar@linux.ibm.com, iforster@suse.de, linux-integrity@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Jan 17, 2019 at 1:22 AM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
> Since copy_up() happens when you are modifying a file on overlay,
> it is still a new file for the underlying filesystem. Mark it
> in IMA for re-evaluating as a new file.
>
> Putting ima calls within overlayfs may not be the best method, but this is
> the only one which I thought would work.
>

Doesn't look right.
Overlayfs creates the new inode with vfs_tmpfile() and I think that is
where you should plug the IMA hook.

> Here is a test case:
> mount /dev/vdb /lower
> mount /dev/vdc /upper
> echo "Original contents" > /lower/existingfile.txt
> mount -t overlay overlay /mnt -o upperdir=/upper/upper,workdir=/upper/workdir,lowerdir=/lower
> echo "New contents" > /mnt/existingfile.txt
>

I bet you can reproduce that same issue without overlayfs
by creating an O_TMPFILE from userspace.

The ima_file_check() hook in do_last() does not cover the O_TMPFILE
case.

Thanks,
Amir.

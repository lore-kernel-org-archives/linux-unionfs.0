From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] vfs: fix vfs_clone_file_range() for overlayfs files
Date: Fri, 28 Oct 2016 16:25:28 +0200
Message-ID: <CAJfpegtfa5fBozu7GFFtB+eEHKxdmsg6byysVcLGiWuXHtfL2w@mail.gmail.com>
References: <1477510441-24861-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33465 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752143AbcJ1OZ3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Oct 2016 10:25:29 -0400
Received: by mail-oi0-f42.google.com with SMTP id y2so124556860oie.0
        for <linux-unionfs@vger.kernel.org>; Fri, 28 Oct 2016 07:25:29 -0700 (PDT)
In-Reply-To: <1477510441-24861-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Wed, Oct 26, 2016 at 9:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> With overlayfs, it is wrong to compare file_inode(inode)->i_sb
> of regular files with those of non-regular files, because the
> former reference the real (upper/lower) sb and the latter reference
> the overlayfs sb.
>
> Move the test for same super block after the sanity tests for
> clone range of directory and non-regular file.

Better:  compare ->f_path.dentry->d_sb instead of file_inode()->i_sb.
We don't want to be mixing files that come from overlayfs and ones
that come from the underlying layers.

BTW, would it be worthwhile adding clone_file_range() support to overlayfs?

Thanks,
Miklos

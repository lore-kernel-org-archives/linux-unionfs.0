Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:34729 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753107AbeEIFpA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 9 May 2018 01:45:00 -0400
MIME-Version: 1.0
In-Reply-To: <20180508212405.15297-3-rgoldwyn@suse.de>
References: <20180508212405.15297-1-rgoldwyn@suse.de> <20180508212405.15297-3-rgoldwyn@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 9 May 2018 08:44:59 +0300
Message-ID: <CAOQ4uxgjBDesX_S-ut7aU1nfgjzDp2qiE6e7XjAYpaJuWsQaqg@mail.gmail.com>
Subject: Re: [PATCH 2/4] copy_file_range: Perform splice if in/out SB are not same
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Steve French <smfrench@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, May 9, 2018 at 12:24 AM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> While performing copy_file_range(), if superblocks of file_in and
> file_out don't match, instead of returning -EXDEV, perform
> splice for a faster copy.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/read_write.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 7d9dfb62ba7d..2c9e7a5ea806 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1546,6 +1546,8 @@ ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
>                             size_t len, unsigned int flags,
>                             unsigned int splice_flags)
>  {
> +       struct inode *inode_in = file_inode(file_in);
> +       struct inode *inode_out = file_inode(file_out);
>         ssize_t ret = 0;
>
>         if (flags != 0)
> @@ -1554,6 +1556,9 @@ ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
>         if (len == 0)
>                 return 0;
>
> +       if (inode_in->i_sb != inode_out->i_sb)
> +               goto splice;
> +
>         /*
>          * Try cloning first, this is supported by more file systems, and
>          * more efficient if both clone and copy are supported (e.g. NFS).
> @@ -1571,7 +1576,7 @@ ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
>                 if (ret != -EOPNOTSUPP)
>                         return ret;
>         }
> -
> +splice:
>         ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
>                         len > MAX_RW_COUNT ? MAX_RW_COUNT : len, splice_flags);
>         return ret;
> @@ -1608,10 +1613,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>             (file_out->f_flags & O_APPEND))
>                 return -EBADF;
>
> -       /* this could be relaxed once a method supports cross-fs copies */
> -       if (inode_in->i_sb != inode_out->i_sb)
> -               return -EXDEV;
> -
>         file_start_write(file_out);
>
>         ret = do_copy_file_range(file_in, pos_in,
> --
> 2.16.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

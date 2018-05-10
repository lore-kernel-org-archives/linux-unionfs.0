Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:34221 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbeEJEZz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 May 2018 00:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <20180510015820.17700-2-rgoldwyn@suse.de>
References: <20180510015820.17700-1-rgoldwyn@suse.de> <20180510015820.17700-2-rgoldwyn@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 10 May 2018 07:25:53 +0300
Message-ID: <CAOQ4uxjjx2=viLhxFAdvUWYiu5zRoqjW-62Uh1RoCLZhqCBf0A@mail.gmail.com>
Subject: Re: [PATCH 1/4] copy_file_range: refactor vfs_copy_file_range
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, overlayfs <linux-unionfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 10, 2018 at 4:58 AM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> Preparatory patch to carve out do_copy_file_range() from
> vfs_copy_file_range
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/read_write.c | 60 ++++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 34 insertions(+), 26 deletions(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index c4eabbfc90df..525f2a67e15a 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1541,6 +1541,38 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
>  }
>  #endif
>
> +static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
> +                           struct file *file_out, loff_t pos_out,
> +                           size_t len, unsigned int flags)
> +{
> +       ssize_t ret = 0;
> +
> +       if (len == 0)
> +               return 0;
> +
> +       /*
> +        * Try cloning first, this is supported by more file systems, and
> +        * more efficient if both clone and copy are supported (e.g. NFS).
> +        */
> +       if (file_in->f_op->clone_file_range) {
> +               ret = file_in->f_op->clone_file_range(file_in, pos_in,
> +                               file_out, pos_out, len);
> +               if (ret == 0)
> +                       return len;
> +       }
> +
> +       if (file_out->f_op->copy_file_range) {
> +               ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
> +                                                     pos_out, len, flags);
> +               if (ret != -EOPNOTSUPP)
> +                       return ret;
> +       }
> +
> +       ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
> +                       len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
> +       return ret;
> +}
> +
>  /*
>   * copy_file_range() differs from regular file read and write in that it
>   * specifically allows return partial success.  When it does so is up to
> @@ -1579,35 +1611,11 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>         if (inode_in->i_sb != inode_out->i_sb)
>                 return -EXDEV;
>
> -       if (len == 0)
> -               return 0;
> -
>         file_start_write(file_out);
>
> -       /*
> -        * Try cloning first, this is supported by more file systems, and
> -        * more efficient if both clone and copy are supported (e.g. NFS).
> -        */
> -       if (file_in->f_op->clone_file_range) {
> -               ret = file_in->f_op->clone_file_range(file_in, pos_in,
> -                               file_out, pos_out, len);
> -               if (ret == 0) {
> -                       ret = len;
> -                       goto done;
> -               }
> -       }
> -
> -       if (file_out->f_op->copy_file_range) {
> -               ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
> -                                                     pos_out, len, flags);
> -               if (ret != -EOPNOTSUPP)
> -                       goto done;
> -       }
> -
> -       ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
> -                       len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
> +       ret = do_copy_file_range(file_in, pos_in,
> +                       file_out, pos_out, len, flags);
>
> -done:
>         if (ret > 0) {
>                 fsnotify_access(file_in);
>                 add_rchar(current, ret);
> --
> 2.16.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

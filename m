From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: Sync upper dirty data when sync overlayfs
Date: Tue, 28 Nov 2017 08:47:33 +0200
Message-ID: <CAOQ4uxiL8vdkcTSGnqGKtH1AVaZ+W0LcaTaoi6mifGjhq48Ljg@mail.gmail.com>
References: <1511844026-12765-1-git-send-email-cgxu@mykernel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:33072 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdK1Gre (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 01:47:34 -0500
Received: by mail-yw0-f196.google.com with SMTP id z125so11446947ywb.0
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Nov 2017 22:47:34 -0800 (PST)
In-Reply-To: <1511844026-12765-1-git-send-email-cgxu@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu@mykernel.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Suyue <suyue@meili-inc.com>

On Tue, Nov 28, 2017 at 6:40 AM, Chengguang Xu <cgxu@mykernel.net> wrote:
> Executes filesystem sync or umount on overlayfs, dirty data does not be synced as expected on upper filesystem.
> This patch fixes sync filesystem method to keep data consistency for overlayfs.
>
> Signed-off-by: Chengguang Xu <cgxu@mykernel.net>
> ---
>  fs/overlayfs/super.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index f5738e9..9c54345 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -17,6 +17,7 @@
>  #include <linux/statfs.h>
>  #include <linux/seq_file.h>
>  #include <linux/posix_acl_xattr.h>
> +#include <linux/writeback.h>
>  #include "overlayfs.h"
>  #include "ovl_entry.h"
>
> @@ -231,6 +232,7 @@ static void ovl_put_super(struct super_block *sb)
>         kfree(ufs);
>  }
>
> +/* Sync real dirty inodes in upper filesystem (if it exists) */
>  static int ovl_sync_fs(struct super_block *sb, int wait)
>  {
>         struct ovl_fs *ufs = sb->s_fs_info;
> @@ -240,12 +242,26 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
>         if (!ufs->upper_mnt)
>                 return 0;
>         upper_sb = ufs->upper_mnt->mnt_sb;
> -       if (!upper_sb->s_op->sync_fs)
> -               return 0;
>
> -       /* real inodes have already been synced by sync_filesystem(ovl_sb) */
>         down_read(&upper_sb->s_umount);
> -       ret = upper_sb->s_op->sync_fs(upper_sb, wait);
> +       if (wait)
> +               sync_inodes_sb(upper_sb);
> +       else
> +               writeback_inodes_sb(upper_sb, WB_REASON_SYNC);
> +
> +       if (upper_sb->s_op->sync_fs)
> +               upper_sb->s_op->sync_fs(upper_sb, wait);
> +
> +       if (!upper_sb->s_bdev) {
> +               up_read(&upper_sb->s_umount);
> +               return 0;
> +       }
> +
> +       if (wait)
> +               ret = filemap_write_and_wait(upper_sb->s_bdev->bd_inode->i_mapping);
> +       else
> +               ret = filemap_flush(upper_sb->s_bdev->bd_inode->i_mapping);
> +
>         up_read(&upper_sb->s_umount);
>         return ret;
>  }


Unless I am missing something subtle here, you should export vfs
__sync_filesystem and call it from here instead of duplicating it.
Any technical reason not to do it?

Amir.

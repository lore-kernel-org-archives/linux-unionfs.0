From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: Improving syncfs efficiency
Date: Mon, 8 Jan 2018 14:10:28 +0200
Message-ID: <CAOQ4uxgxv=7tj97Krui2XBxiVh8-xjuxqSoq+KSxYYKwXGNQaw@mail.gmail.com>
References: <1515400885-16622-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:37479 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756482AbeAHMK3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Jan 2018 07:10:29 -0500
Received: by mail-yw0-f196.google.com with SMTP id v139so1190802ywg.4
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Jan 2018 04:10:29 -0800 (PST)
In-Reply-To: <1515400885-16622-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 8, 2018 at 10:41 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> Currently syncfs(2) call on overlayfs just simply call sync_filesystem()
> on upper_sb to synchronize whole dirty inodes in upper filesystem
> regardless of the overlay ownership of the inode. It has obvious
> shortcomings as below.
>
> (1) Performance
> Synchronization is probably heavy in most cases, especially when upper
> filesystem is not dedicated to target overlayfs.
>
> (2) Interference
> Unplanned synchronization will probably impact IO performance of the
> processes which use other overlayfs on same upper filesystem or directly
> use upper filesystem.
>
> This patch iterates overlay inodes to only sync target dirty inodes in
> upper filesystem and wait on temporary waiting list to avoid waiting on
> inodes that have started writeback afterwards. By doing this,
> it is able to reduce cost of synchronization and will not seriously impact
> IO performance of irrelative processes.

This looks like a very good improvement!

>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
>  fs/overlayfs/ovl_entry.h |   4 ++
>  fs/overlayfs/super.c     | 101 +++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 102 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 9d0bc03..e92c425 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -52,6 +52,8 @@ struct ovl_fs {
>         /* Did we take the inuse lock? */
>         bool upperdir_locked;
>         bool workdir_locked;
> +       /* ovl inode sync list lock */
> +       spinlock_t  ovl_sync_list_lock;
>  };
>
>  /* private information held for every overlayfs dentry */
> @@ -80,6 +82,8 @@ struct ovl_inode {
>
>         /* synchronize copy up and more */
>         struct mutex lock;
> +       /* ovl inode sync list */
> +       struct list_head sync_list;
>  };
>
>  static inline struct ovl_inode *OVL_I(struct inode *inode)
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 76440fe..17f1406 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -17,6 +17,8 @@
>  #include <linux/statfs.h>
>  #include <linux/seq_file.h>
>  #include <linux/posix_acl_xattr.h>
> +#include <linux/writeback.h>
> +#include <linux/blkdev.h>
>  #include "overlayfs.h"
>
>  MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
> @@ -195,6 +197,7 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
>         oi->__upperdentry = NULL;
>         oi->lower = NULL;
>         mutex_init(&oi->lock);
> +       INIT_LIST_HEAD(&oi->sync_list);
>
>         return &oi->vfs_inode;
>  }
> @@ -252,6 +255,96 @@ static void ovl_put_super(struct super_block *sb)
>         ovl_free_fs(ofs);
>  }
>
> +/**
> + * ovl_sync_filesystem
> + * @sb: The overlayfs super block
> + *
> + * Sync underlying dirty inodes in upper filesystem and wait for completion.
> + * Use temporary wait list to avoid waiting on inodes that have started
> + * writeback after this point.
> + */
> +static int ovl_sync_filesystem(struct super_block *sb)
> +{
> +       struct ovl_fs *ofs = sb->s_fs_info;
> +       struct super_block *upper_sb = ofs->upper_mnt->mnt_sb;
> +       struct ovl_inode *oi, *oi_next;
> +       struct inode *inode, *i_next;
> +       struct inode *upper_inode;
> +       struct blk_plug plug;
> +       LIST_HEAD(ovl_sync_list);
> +
> +       struct writeback_control wbc = {
> +               .sync_mode              = WB_SYNC_ALL,

Shouldn't this be WB_SYNC_NONE? We are explicitly waiting
inodes on the list afterwards...

> +               .for_sync               = 1,
> +               .range_start            = 0,
> +               .range_end              = LLONG_MAX,
> +               .nr_to_write            = LONG_MAX,
> +       };
> +
> +       blk_start_plug(&plug);
> +       spin_lock(&sb->s_inode_list_lock);
> +       list_for_each_entry_safe(inode, i_next, &sb->s_inodes, i_sb_list) {
> +               upper_inode = ovl_inode_upper(inode);
> +               if (!upper_inode)
> +                       continue;
> +
> +               spin_lock(&upper_inode->i_lock);
> +               if (upper_inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE) ||
> +                       list_empty(&upper_inode->i_io_list)) {
> +                       spin_unlock(&upper_inode->i_lock);
> +                       continue;
> +               }
> +               spin_unlock(&upper_inode->i_lock);
> +
> +               if (!igrab(inode))
> +                       continue;
> +
> +               if (!igrab(upper_inode)) {
> +                       iput(inode);
> +                       continue;
> +               }
> +               spin_unlock(&sb->s_inode_list_lock);
> +
> +               sync_inode(upper_inode, &wbc);

Maybe allowed to call sync_inode() under s_inode_list_lock
if using WB_SYNC_NONE???
Do we not need to check return value from sync_inode()?
I bet it could be EROFS if upper fs was remounted readonly
and we did not check for that before starting to sync...

> +               spin_lock(&ofs->ovl_sync_list_lock);
> +               if (list_empty(&OVL_I(inode)->sync_list))
> +                       list_add(&OVL_I(inode)->sync_list, &ovl_sync_list);
> +               else {
> +                       iput(upper_inode);
> +                       iput(inode);
> +               }
> +               spin_unlock(&ofs->ovl_sync_list_lock);
> +
> +               if (need_resched()) {
> +                       blk_finish_plug(&plug);
> +                       cond_resched();
> +                       blk_start_plug(&plug);
> +               }
> +               spin_lock(&sb->s_inode_list_lock);
> +       }
> +       spin_unlock(&sb->s_inode_list_lock);
> +       blk_finish_plug(&plug);
> +
> +       mutex_lock(&upper_sb->s_sync_lock);

I suppose mutex_lock_interruptible() is in order.

> +       list_for_each_entry_safe(oi, oi_next, &ovl_sync_list, sync_list) {
> +               upper_inode = ovl_inode_upper(&oi->vfs_inode);
> +
> +               filemap_fdatawait_keep_errors(upper_inode->i_mapping);
> +               list_del_init(&oi->sync_list);
> +               iput(upper_inode);
> +               iput(&oi->vfs_inode);
> +
> +               if (need_resched())
> +                       cond_resched();
> +       }
> +       mutex_unlock(&upper_sb->s_sync_lock);
> +
> +       if (upper_sb->s_op->sync_fs)
> +               upper_sb->s_op->sync_fs(upper_sb, 1);
> +
> +       return sync_blockdev(upper_sb->s_bdev);
> +}
> +
>  /* Sync real dirty inodes in upper filesystem (if it exists) */
>  static int ovl_sync_fs(struct super_block *sb, int wait)
>  {
> @@ -266,8 +359,8 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
>          * If this is a sync(2) call or an emergency sync, all the super blocks
>          * will be iterated, including upper_sb, so no need to do anything.
>          *
> -        * If this is a syncfs(2) call, then we do need to call
> -        * sync_filesystem() on upper_sb, but enough if we do it when being
> +        * If this is a syncfs(2) call, then we do need to call sync_inode()
> +        * on underlying dirty upper_inode, but enough if we do it when being
>          * called with wait == 1.
>          */
>         if (!wait)
> @@ -276,7 +369,7 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
>         upper_sb = ofs->upper_mnt->mnt_sb;
>
>         down_read(&upper_sb->s_umount);
> -       ret = sync_filesystem(upper_sb);
> +       ret = ovl_sync_filesystem(sb);

Note that with this change, we are skipping the test sb_rdonly(upper_sb)
(inside sync_filesystem()). We should probably skip syncing in that case.

Thanks,
Amir.

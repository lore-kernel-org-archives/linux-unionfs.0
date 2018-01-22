From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6] ovl: Improving syncfs efficiency
Date: Mon, 22 Jan 2018 13:27:12 +0200
Message-ID: <CAOQ4uxio56Lg+yNPxVNP4gN7jv5P01h9Y-PARH_forC3cmnv7w@mail.gmail.com>
References: <1516614465-134755-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:34279 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbeAVL1O (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 06:27:14 -0500
Received: by mail-yb0-f194.google.com with SMTP id u35so3089810ybi.1
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2018 03:27:14 -0800 (PST)
In-Reply-To: <1516614465-134755-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 22, 2018 at 11:47 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> Currently syncfs(2) call on overlayfs just simply call sync_filesystem()
> on upper_sb to synchronize whole dirty inodes in upper filesystem
> regardless of the overlay ownership of the inode. In the use case of
> container, when multiple containers using the same underlying upper
> filesystem, it has some shortcomings as below.
>
> (1) Performance
> Synchronization is probably heavy because it actually syncs unnecessary
> inodes for target overlayfs.
>
> (2) Interference
> Unplanned synchronization will probably impact IO performance of
> unrelated container processes on the other overlayfs.
>
> This patch iterates upper inode list in overlayfs to only sync target
> dirty inodes and wait for completion. By doing this, It is able to reduce
> cost of synchronization and will not seriously impact IO performance of
> unrelated processes. In special case, when having very few dirty inodes
> and a lot of clean upper inodes in overlayfs, then iteration may waste
> time so that synchronization is slower than before, but we think the
> potential for performance improvement far surpass the potential for
> performance regression in most cases.
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
> Changes since v5:
> - Move sync related functions to new file sync.c.
> - Introduce OVL_EVICT_PENDING flag to avoid race conditions.
> - If ovl indoe flag is I_WILL_FREE or I_FREEING then syncfs

typo 'indo' and in comment below as well.

> will wait until OVL_EVICT_PENDING to be cleared.
> - Move inode sync operation into evict_inode from drop_inode.
> - Call upper_sb->sync_fs with no-wait after sync dirty upper
> inodes.
> - Hold s_inode_wblist_lock until deleting item from list.
> - Remove write_inode fuction because no more used.
>
> Changes since v4:
> - Add syncing operation and deleting from upper_inodes list
> during ovl inode destruction.
> - Export symbol of inode_wait_for_writeback() for waiting
> writeback on ovl inode.
> - Reuse I_SYNC flag to avoid race conditions between syncfs
> and drop_inode.
>
> Changes since v3:
> - Introduce upper_inode list to organize ovl indoe which has upper inode.
> - Avoid iput operation inside spin lock.
> - Change list iteration method for safety.
> - Reuse inode->i_wb_list and sb->s_inodes_wb to save memory.
> - Modify commit log and add more comments to the code.
>
> Changes since v2:
> - Decoupling with syncfs of upper fs by taking sb->s_sync_lock of
> overlayfs.
> - Factoring out sync operation to different helpers for easy understanding.
>
> Changes since v1:
> - If upper filesystem is readonly mode then skip synchronization.
> - Introduce global wait list to replace temporary wait list for
> concurrent synchronization.
>
>  fs/overlayfs/Makefile    |   2 +-
>  fs/overlayfs/overlayfs.h |   8 ++
>  fs/overlayfs/ovl_entry.h |   5 +
>  fs/overlayfs/super.c     |  44 +++-----
>  fs/overlayfs/sync.c      | 256 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/overlayfs/util.c      |  23 ++++-
>  6 files changed, 305 insertions(+), 33 deletions(-)
>  create mode 100644 fs/overlayfs/sync.c
>
> diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
> index 99373bb..6e92c0e 100644
> --- a/fs/overlayfs/Makefile
> +++ b/fs/overlayfs/Makefile
> @@ -4,4 +4,4 @@
>
>  obj-$(CONFIG_OVERLAY_FS) += overlay.o
>
> -overlay-objs := super.o namei.o util.o inode.o dir.o readdir.o copy_up.o
> +overlay-objs := super.o namei.o util.o inode.o dir.o readdir.o copy_up.o sync.o
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index b489099..c6a9ecd 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -34,6 +34,8 @@ enum ovl_flag {
>         /* Non-merge dir that may contain whiteout entries */
>         OVL_WHITEOUTS,
>         OVL_INDEX,
> +       /* Set when ovl inode is about to be freed */
> +       OVL_EVICT_PENDING,
>  };
>
>  /*
> @@ -241,6 +243,7 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
>  int ovl_nlink_start(struct dentry *dentry, bool *locked);
>  void ovl_nlink_end(struct dentry *dentry, bool locked);
>  int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
> +void ovl_detach_upper_inodes_list(struct inode *inode);
>
>  static inline bool ovl_is_impuredir(struct dentry *dentry)
>  {
> @@ -322,3 +325,8 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
>  int ovl_copy_xattr(struct dentry *old, struct dentry *new);
>  int ovl_set_attr(struct dentry *upper, struct kstat *stat);
>  struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper);
> +
> +/* sync.c */
> +int ovl_write_inode(struct inode *inode, struct writeback_control *wbc);

leftover

> +void ovl_evict_inode(struct inode *inode);
> +int ovl_sync_fs(struct super_block *sb, int wait);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 9d0bc03..53909ba 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -52,6 +52,9 @@ struct ovl_fs {
>         /* Did we take the inuse lock? */
>         bool upperdir_locked;
>         bool workdir_locked;
> +       /* upper inode list and lock */
> +       spinlock_t upper_inodes_lock;
> +       struct list_head upper_inodes;
>  };
>
>  /* private information held for every overlayfs dentry */
> @@ -80,6 +83,8 @@ struct ovl_inode {
>
>         /* synchronize copy up and more */
>         struct mutex lock;
> +       /* upper inodes list */
> +       struct list_head upper_inodes_list;
>  };
>
>  static inline struct ovl_inode *OVL_I(struct inode *inode)
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 76440fe..9315155 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -195,6 +195,7 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
>         oi->__upperdentry = NULL;
>         oi->lower = NULL;
>         mutex_init(&oi->lock);
> +       INIT_LIST_HEAD(&oi->upper_inodes_list);
>
>         return &oi->vfs_inode;
>  }
> @@ -252,36 +253,6 @@ static void ovl_put_super(struct super_block *sb)
>         ovl_free_fs(ofs);
>  }
>
> -/* Sync real dirty inodes in upper filesystem (if it exists) */
> -static int ovl_sync_fs(struct super_block *sb, int wait)
> -{
> -       struct ovl_fs *ofs = sb->s_fs_info;
> -       struct super_block *upper_sb;
> -       int ret;
> -
> -       if (!ofs->upper_mnt)
> -               return 0;
> -
> -       /*
> -        * If this is a sync(2) call or an emergency sync, all the super blocks
> -        * will be iterated, including upper_sb, so no need to do anything.
> -        *
> -        * If this is a syncfs(2) call, then we do need to call
> -        * sync_filesystem() on upper_sb, but enough if we do it when being
> -        * called with wait == 1.
> -        */
> -       if (!wait)
> -               return 0;
> -
> -       upper_sb = ofs->upper_mnt->mnt_sb;
> -
> -       down_read(&upper_sb->s_umount);
> -       ret = sync_filesystem(upper_sb);
> -       up_read(&upper_sb->s_umount);
> -
> -       return ret;
> -}
> -
>  /**
>   * ovl_statfs
>   * @sb: The overlayfs super block
> @@ -354,10 +325,18 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
>         return 0;
>  }
>
> +static int ovl_drop_inode(struct inode *inode)
> +{
> +       if (ovl_inode_upper(inode))
> +               ovl_set_flag(OVL_EVICT_PENDING, inode);
> +       return 1;
> +}
> +
>  static const struct super_operations ovl_super_operations = {
>         .alloc_inode    = ovl_alloc_inode,
>         .destroy_inode  = ovl_destroy_inode,
> -       .drop_inode     = generic_delete_inode,
> +       .drop_inode     = ovl_drop_inode,
> +       .evict_inode    = ovl_evict_inode,
>         .put_super      = ovl_put_super,
>         .sync_fs        = ovl_sync_fs,
>         .statfs         = ovl_statfs,
> @@ -1202,6 +1181,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         if (!ofs)
>                 goto out;
>
> +       spin_lock_init(&ofs->upper_inodes_lock);
> +       INIT_LIST_HEAD(&ofs->upper_inodes);
> +
>         ofs->creator_cred = cred = prepare_creds();
>         if (!cred)
>                 goto out_err;
> diff --git a/fs/overlayfs/sync.c b/fs/overlayfs/sync.c
> new file mode 100644
> index 0000000..e239b0a
> --- /dev/null
> +++ b/fs/overlayfs/sync.c
> @@ -0,0 +1,256 @@
> +/*
> + * Copyright (C) 2018 Meili Inc.
> + * Author Chengguang Xu <cgxu519@icloud.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/xattr.h>
> +#include <linux/mount.h>
> +#include <linux/writeback.h>
> +#include <linux/blkdev.h>
> +#include "overlayfs.h"
> +
> +void ovl_evict_inode(struct inode *inode)
> +{
> +       if (ovl_inode_upper(inode)) {
> +               write_inode_now(ovl_inode_upper(inode), 1);
> +               ovl_detach_upper_inodes_list(inode);
> +
> +               /*
> +                * ovl_sync_inodes() may wait until
> +                * flag OVL_EVICT_PENDING to be cleared.
> +                */
> +               spin_lock(&inode->i_lock);
> +               ovl_clear_flag(OVL_EVICT_PENDING, inode);
> +               /* See also atomic_bitops.txt */
> +               smp_mb__after_atomic();
> +               wake_up_bit(&OVL_I(inode)->flags, OVL_EVICT_PENDING);
> +               spin_unlock(&inode->i_lock);
> +               clear_inode(inode);
> +       }
> +}
> +
> +/**
> + * ovl_sync_inodes
> + * @sb: The overlayfs super block
> + *
> + * upper_inodes list is used for organizing ovl inode which has upper inode,
> + * by iterating the list to looking for and syncing dirty upper inode.
> + *
> + * When starting syncing inode, we add the inode to wait list explicitly,
> + * in order to save memory we reuse inode->i_wb_list and sb->s_inodes_wb,
> + * so those fields have slightly differnt meanings in overlayfs.
> + */
> +static void ovl_sync_inodes(struct super_block *sb)
> +{
> +       struct ovl_fs *ofs = sb->s_fs_info;
> +       struct ovl_inode *oi, *oi_prev;
> +       struct inode *inode, *iput_inode = NULL;
> +       struct inode *upper_inode;
> +       struct blk_plug plug;
> +
> +       struct writeback_control wbc_for_sync = {
> +               .sync_mode              = WB_SYNC_ALL,
> +               .for_sync               = 1,
> +               .range_start            = 0,
> +               .range_end              = LLONG_MAX,
> +               .nr_to_write            = LONG_MAX,
> +       };
> +
> +       blk_start_plug(&plug);
> +       spin_lock(&ofs->upper_inodes_lock);
> +       list_for_each_entry(oi, &ofs->upper_inodes, upper_inodes_list) {
> +               inode = &oi->vfs_inode;
> +               spin_lock(&inode->i_lock);
> +
> +               if (inode->i_state & I_NEW) {
> +                       spin_unlock(&inode->i_lock);
> +                       continue;
> +               }
> +
> +               /*
> +                * If ovl indoe state is I_WILL_FREE or I_FREEING,
> +                * sync operation will be done in the ovl_evict_inode(),
> +                * so wait here until OVL_EVICT_PENDING flag to be cleared.
> +                */
> +               if (inode->i_state & (I_WILL_FREE | I_FREEING)) {
> +                       oi_prev = list_entry(oi->upper_inodes_list.prev,
> +                                       struct ovl_inode, upper_inodes_list);
> +
> +                       if (ovl_test_flag(OVL_EVICT_PENDING, inode)) {
> +                               DEFINE_WAIT_BIT(wait, &oi->flags, OVL_EVICT_PENDING);
> +                               wait_queue_head_t *wqh;
> +                               bool sleep;
> +
> +                               wqh = bit_waitqueue(&oi->flags, OVL_EVICT_PENDING);
> +                               prepare_to_wait(wqh, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
> +                               sleep = ovl_test_flag(OVL_EVICT_PENDING, inode);
> +                               spin_unlock(&inode->i_lock);
> +                               spin_unlock(&ofs->upper_inodes_lock);
> +                               if (sleep)
> +                                       schedule();
> +                               finish_wait(wqh, &wait.wq_entry);

Please move all this to helper ovl_wait_evict_pending()



> +                               /* We need to do this as 'inode' can be freed by now */

Could oi_prev have been freed or removed from upper_inodes list?
I don't see why not.
You could try to continue iteration from iput_inode if it is not NULL,
but what if it is NULL?
Maybe instead of iput_inode = NULL when adding to inodes_wb list
get another reference to inode and always store iput_inode = inode
to use as prev in this case?

It would be good if you wrote the "life cycle" of ovl_inode in a
header comment to
this file because it has become non-trivial to follow.
An explicit mention of locking order is also very good to have in
header comment.



> +                               oi = oi_prev;
> +                               goto next;
> +                       }
> +               }
> +
> +               ihold(inode);
> +               upper_inode = ovl_inode_upper(inode);
> +               spin_unlock(&inode->i_lock);
> +               spin_unlock(&ofs->upper_inodes_lock);
> +
> +               if (iput_inode)
> +                       iput(iput_inode);
> +
> +               if (!(upper_inode->i_state & I_DIRTY_ALL)) {
> +                       if (!mapping_tagged(upper_inode->i_mapping,
> +                                               PAGECACHE_TAG_WRITEBACK)) {
> +                               iput_inode = inode;
> +                               goto next;
> +                       }
> +               } else {
> +                       sync_inode(upper_inode, &wbc_for_sync);
> +               }
> +
> +               /*
> +                * If ovl inode is not in sb->s_inodes_wb list, add to the
> +                * list and keep inode referece until IO to be completed on
> +                * the inode.
> +                */
> +               spin_lock(&sb->s_inode_wblist_lock);
> +               if (list_empty(&inode->i_wb_list)) {
> +                       list_add_tail(&inode->i_wb_list, &sb->s_inodes_wb);
> +                       iput_inode = NULL;
> +               } else {
> +                       iput_inode = inode;
> +               }
> +               spin_unlock(&sb->s_inode_wblist_lock);
> +
> +next:
> +               if (need_resched()) {
> +                       blk_finish_plug(&plug);
> +                       cond_resched();
> +                       blk_start_plug(&plug);
> +               }
> +               spin_lock(&ofs->upper_inodes_lock);
> +       }
> +       spin_unlock(&ofs->upper_inodes_lock);
> +       blk_finish_plug(&plug);
> +
> +       if (iput_inode)
> +               iput(iput_inode);
> +}
> +
> +/**
> + * ovl_wait_inodes
> + * @sb: The overlayfs super block
> + *
> + * Waiting writeback inodes which are in s_inodes_wb list,
> + * all the IO that has been issued up to the time this
> + * function is enter is guaranteed to be completed.
> + */
> +static void ovl_wait_inodes(struct super_block *sb)
> +{
> +       LIST_HEAD(sync_wait_list);
> +       struct inode *inode;
> +       struct inode *upper_inode;
> +
> +       /*
> +        * s_sync_lock is used for serialising concurrent wait operations.
> +        * s_inode_wblist_lock is used for protecting wait list against with
> +        * ovl_sync_indoes().
> +        *
> +        * ovl inode in sb->s_inodes_wb list has already got inode reference,
> +        * this will avoid silent inode droping during waiting on it.
> +        *
> +        * Splice the sync wait list onto a temporary list to avoid waiting on
> +        * inodes that have started writeback after this point.
> +        */
> +       mutex_lock(&sb->s_sync_lock);
> +       spin_lock(&sb->s_inode_wblist_lock);
> +       list_splice_init(&sb->s_inodes_wb, &sync_wait_list);
> +
> +       while (!list_empty(&sync_wait_list)) {
> +               inode = list_first_entry(&sync_wait_list, struct inode, i_wb_list);
> +               list_del_init(&inode->i_wb_list);
> +               upper_inode = ovl_inode_upper(inode);
> +               spin_unlock(&sb->s_inode_wblist_lock);
> +
> +               if (!mapping_tagged(upper_inode->i_mapping,
> +                               PAGECACHE_TAG_WRITEBACK)) {
> +                       goto next;
> +               }
> +
> +               filemap_fdatawait_keep_errors(upper_inode->i_mapping);
> +
> +               if (need_resched())
> +                       cond_resched();
> +
> +next:
> +               iput(inode);
> +               spin_lock(&sb->s_inode_wblist_lock);
> +       }
> +       spin_unlock(&sb->s_inode_wblist_lock);
> +       mutex_unlock(&sb->s_sync_lock);
> +}
> +
> +/**
> + * ovl_sync_filesystem
> + * @sb: The overlayfs super block
> + *
> + * Sync underlying dirty inodes in upper filesystem and
> + * wait for completion.
> + */
> +static int ovl_sync_filesystem(struct super_block *sb)
> +{
> +       struct ovl_fs *ofs = sb->s_fs_info;
> +       struct super_block *upper_sb = ofs->upper_mnt->mnt_sb;
> +       int ret = 0;
> +
> +       down_read(&upper_sb->s_umount);
> +       if (!sb_rdonly(upper_sb)) {
> +
> +               ovl_sync_inodes(sb);
> +               /* Calling sync_fs with no-wait for better performance. */
> +               if (upper_sb->s_op->sync_fs)
> +                       upper_sb->s_op->sync_fs(upper_sb, 0);
> +
> +               ovl_wait_inodes(sb);
> +               if (upper_sb->s_op->sync_fs)
> +                       upper_sb->s_op->sync_fs(upper_sb, 1);
> +
> +               ret = sync_blockdev(upper_sb->s_bdev);
> +       }
> +       up_read(&upper_sb->s_umount);
> +       return ret;
> +}
> +
> +/**
> + * ovl_sync_fs
> + * @sb: The overlayfs super block
> + * @wait: Wait for I/O to complete
> + *
> + * Sync real dirty inodes in upper filesystem (if it exists)
> + */
> +int ovl_sync_fs(struct super_block *sb, int wait)
> +{
> +       /*
> +        * If this is a sync(2) call or an emergency sync,
> +        * all the super blocks will be iterated, including
> +        * upper_sb, so no need to do anything.
> +        *
> +        * If this is a syncfs(2) call, then we do need to
> +        * call sync_inode() on underlying dirty upper inode,
> +        * but enough if we do it when being called with wait == 1.
> +        */
> +       if (!wait)
> +               return 0;
> +
> +       return ovl_sync_filesystem(sb);
> +}
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index d6bb1c9..621d5d4 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -251,11 +251,31 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
>         oi->redirect = redirect;
>  }
>
> +void ovl_attach_upper_inodes_list(struct inode *inode)
> +{
> +       struct ovl_fs *ofs = inode->i_sb->s_fs_info;
> +
> +       spin_lock(&ofs->upper_inodes_lock);
> +       list_add(&OVL_I(inode)->upper_inodes_list, &ofs->upper_inodes);
> +       spin_unlock(&ofs->upper_inodes_lock);
> +}
> +
> +void ovl_detach_upper_inodes_list(struct inode *inode)
> +{
> +       struct ovl_fs *ofs = inode->i_sb->s_fs_info;
> +
> +       spin_lock(&ofs->upper_inodes_lock);
> +       list_del_init(&OVL_I(inode)->upper_inodes_list);
> +       spin_unlock(&ofs->upper_inodes_lock);
> +}
> +
>  void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
>                     struct dentry *lowerdentry)
>  {
> -       if (upperdentry)
> +       if (upperdentry) {
>                 OVL_I(inode)->__upperdentry = upperdentry;
> +               ovl_attach_upper_inodes_list(inode);
> +       }
>         if (lowerdentry)
>                 OVL_I(inode)->lower = d_inode(lowerdentry);
>
> @@ -277,6 +297,7 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
>                 inode->i_private = upperinode;
>                 __insert_inode_hash(inode, (unsigned long) upperinode);
>         }
> +       ovl_attach_upper_inodes_list(inode);
>  }
>
>  void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
> --
> 1.8.3.1
>

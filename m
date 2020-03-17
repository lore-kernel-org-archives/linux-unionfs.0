Return-Path: <SRS0=axgb=5C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88400C10F29
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Mar 2020 04:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0754E206EC
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Mar 2020 04:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="J7r+HgrA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgCQEmD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 00:42:03 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25328 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgCQEmD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Mar 2020 00:42:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1584420079;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=j5yT51y2w1kakFmjd0edMt9Ce0xAldc5qxO53CYnoMo=;
        b=J7r+HgrA0GKA+lvKPF5qASPqOMdrSzBAYLUsL2Ua76Q9v7cIKJ1HnAMjqiEtXisk
        fiUUnKPOu1K++sR4cvhQ/CYUh7QO3ekPll/hfbmqMCrvaXK+JDxmcxQ4CTwLriab0DB
        31dmK0LtbIan9Eu4alnP4pzVHlJrO+lKR42X05oE=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1584420077685824.9342605520085; Tue, 17 Mar 2020 12:41:17 +0800 (CST)
Date:   Tue, 17 Mar 2020 12:41:17 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Chengguang Xu" <cgxu519@mykernel.net>
Cc:     "miklos" <miklos@szeredi.hu>, "amir73il" <amir73il@gmail.com>,
        "jack" <jack@suse.cz>,
        "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-ID: <170e6cbc06e.d92f059210735.6409036322143087221@mykernel.net>
In-Reply-To: <20200210031009.61086-1-cgxu519@mykernel.net>
References: <20200210031009.61086-1-cgxu519@mykernel.net>
Subject: =?UTF-8?Q?=E5=9B=9E=E5=A4=8D:[PATCH_v11]_ovl:_Improving_syncfs_efficiency?=
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Priority: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=80, 2020-02-10 11:10:09 Chengguang=
 Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
 > Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
 > on upper_sb to synchronize whole dirty inodes in upper filesystem
 > regardless of the overlay ownership of the inode. In the use case of
 > container, when multiple containers using the same underlying upper
 > filesystem, it has some shortcomings as below.
 >=20
 > (1) Performance
 > Synchronization is probably heavy because it actually syncs unnecessary
 > inodes for target overlayfs.
 >=20
 > (2) Interference
 > Unplanned synchronization will probably impact IO performance of
 > unrelated container processes on the other overlayfs.
 >=20
 > This patch iterates upper inode list in overlayfs to only sync target
 > dirty inodes and wait for completion. By doing this, It is able to
 > reduce cost of synchronization and will not seriously impact IO performa=
nce
 > of unrelated processes. In special case, when having very few dirty inod=
es
 > and a lot of clean upper inodes in overlayfs, then iteration may waste
 > time so that synchronization is slower than before, but we think the
 > potential for performance improvement far surpass the potential for
 > performance regression in most cases.
 >=20
 > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > ---

Hi Miklos,

Have you get time to review this patch?
I tested xfstest overlay part (and generic/427 which is testcase for syncfs=
) and heavy untar + syncfs test and I found no problem.

Thanks,
cgxu

 > Changes since v10:
 > - Add special handling in ovl_evict_inode() for inode eviction trigered
 > by kswapd memory reclamation(with PF_MEMALLOC flag).
 > - Rebase on current latest overlayfs-next tree.
 > - Slightly modify license information.
 >=20
 > Changes since v9:
 > - Rebase on current latest overlayfs-next tree.
 > - Calling clear_inode() regardless of having upper inode.
 >=20
 > Changes since v8:
 > - Remove unnecessary blk_start_plug() call in ovl_sync_inodes().
 >=20
 > Changes since v7:
 > - Check OVL_EVICT_PENDING flag instead of I_FREEING to recognize
 > inode which is in eviction process.
 > - Do not move ovl_inode back to ofs->upper_inodes when inode is in
 > eviction process.
 > - Delete unnecessary memory barrier in ovl_evict_inode().
 >=20
 > Changes since v6:
 > - Take/release sb->s_sync_lock bofore/after sync_fs to serialize
 > concurrent syncfs.
 > - Change list iterating method to improve code readability.
 > - Fix typo in commit log and comments.
 > - Add header comment to sync.c.
 >=20
 > Changes since v5:
 > - Move sync related functions to new file sync.c.
 > - Introduce OVL_EVICT_PENDING flag to avoid race conditions.
 > - If ovl inode flag is I_WILL_FREE or I_FREEING then syncfs
 > will wait until OVL_EVICT_PENDING to be cleared.
 > - Move inode sync operation into evict_inode from drop_inode.
 > - Call upper_sb->sync_fs with no-wait after sync dirty upper
 > inodes.
 > - Hold s_inode_wblist_lock until deleting item from list.
 > - Remove write_inode fuction because no more used.
 >=20
 > Changes since v4:
 > - Add syncing operation and deleting from upper_inodes list
 > during ovl inode destruction.
 > - Export symbol of inode_wait_for_writeback() for waiting
 > writeback on ovl inode.
 > - Reuse I_SYNC flag to avoid race conditions between syncfs
 > and drop_inode.
 >=20
 > Changes since v3:
 > - Introduce upper_inode list to organize ovl inode which has upper
 >   inode.
 > - Avoid iput operation inside spin lock.
 > - Change list iteration method for safety.
 > - Reuse inode->i_wb_list and sb->s_inodes_wb to save memory.
 > - Modify commit log and add more comments to the code.
 >=20
 > Changes since v2:
 > - Decoupling with syncfs of upper fs by taking sb->s_sync_lock of
 > overlayfs.
 > - Factoring out sync operation to different helpers for easy
 >   understanding.
 >=20
 > Changes since v1:
 > - If upper filesystem is readonly mode then skip synchronization.
 > - Introduce global wait list to replace temporary wait list for
 > concurrent synchronization.
 >=20
 >  fs/overlayfs/Makefile    |   2 +-
 >  fs/overlayfs/overlayfs.h |   9 ++
 >  fs/overlayfs/ovl_entry.h |   5 +
 >  fs/overlayfs/super.c     |  44 ++----
 >  fs/overlayfs/sync.c      | 331 +++++++++++++++++++++++++++++++++++++++
 >  fs/overlayfs/util.c      |  23 ++-
 >  6 files changed, 381 insertions(+), 33 deletions(-)
 >  create mode 100644 fs/overlayfs/sync.c
 >=20
 > diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
 > index 9164c585eb2f..0c4e53fcf4ef 100644
 > --- a/fs/overlayfs/Makefile
 > +++ b/fs/overlayfs/Makefile
 > @@ -6,4 +6,4 @@
 >  obj-$(CONFIG_OVERLAY_FS) +=3D overlay.o
 > =20
 >  overlay-objs :=3D super.o namei.o util.o inode.o file.o dir.o readdir.o=
 \
 > -        copy_up.o export.o
 > +        copy_up.o export.o sync.o
 > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
 > index 3623d28aa4fa..3cdb06e206a3 100644
 > --- a/fs/overlayfs/overlayfs.h
 > +++ b/fs/overlayfs/overlayfs.h
 > @@ -40,6 +40,10 @@ enum ovl_inode_flag {
 >      OVL_UPPERDATA,
 >      /* Inode number will remain constant over copy up. */
 >      OVL_CONST_INO,
 > +    /* Set when ovl inode is about to be freed */
 > +    OVL_EVICT_PENDING,
 > +    /* Set when sync upper inode in workqueue work */
 > +    OVL_WRITE_INODE_PENDING,
 >  };
 > =20
 >  enum ovl_entry_flag {
 > @@ -295,6 +299,7 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry);
 >  char *ovl_get_redirect_xattr(struct dentry *dentry, int padding);
 >  ssize_t ovl_getxattr(struct dentry *dentry, char *name, char **value,
 >               size_t padding);
 > +void ovl_detach_upper_inodes_list(struct inode *inode);
 > =20
 >  static inline bool ovl_is_impuredir(struct dentry *dentry)
 >  {
 > @@ -466,3 +471,7 @@ int ovl_set_origin(struct dentry *dentry, struct den=
try *lower,
 > =20
 >  /* export.c */
 >  extern const struct export_operations ovl_export_operations;
 > +
 > +/* sync.c */
 > +void ovl_evict_inode(struct inode *inode);
 > +int ovl_sync_fs(struct super_block *sb, int wait);
 > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
 > index 89015ea822e7..42e092e8cd61 100644
 > --- a/fs/overlayfs/ovl_entry.h
 > +++ b/fs/overlayfs/ovl_entry.h
 > @@ -75,6 +75,9 @@ struct ovl_fs {
 >      struct inode *indexdir_trap;
 >      /* -1: disabled, 0: same fs, 1..32: number of unused ino bits */
 >      int xino_mode;
 > +    /* Upper inode list and lock */
 > +    spinlock_t upper_inodes_lock;
 > +    struct list_head upper_inodes;
 >  };
 > =20
 >  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 > @@ -115,6 +118,8 @@ struct ovl_inode {
 > =20
 >      /* synchronize copy up and more */
 >      struct mutex lock;
 > +    /* Upper inodes list */
 > +    struct list_head upper_inodes_list;
 >  };
 > =20
 >  static inline struct ovl_inode *OVL_I(struct inode *inode)
 > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
 > index 319fe0d355b0..3e6871e1a7ba 100644
 > --- a/fs/overlayfs/super.c
 > +++ b/fs/overlayfs/super.c
 > @@ -183,6 +183,7 @@ static struct inode *ovl_alloc_inode(struct super_bl=
ock *sb)
 >      oi->lower =3D NULL;
 >      oi->lowerdata =3D NULL;
 >      mutex_init(&oi->lock);
 > +    INIT_LIST_HEAD(&oi->upper_inodes_list);
 > =20
 >      return &oi->vfs_inode;
 >  }
 > @@ -249,36 +250,6 @@ static void ovl_put_super(struct super_block *sb)
 >      ovl_free_fs(ofs);
 >  }
 > =20
 > -/* Sync real dirty inodes in upper filesystem (if it exists) */
 > -static int ovl_sync_fs(struct super_block *sb, int wait)
 > -{
 > -    struct ovl_fs *ofs =3D sb->s_fs_info;
 > -    struct super_block *upper_sb;
 > -    int ret;
 > -
 > -    if (!ofs->upper_mnt)
 > -        return 0;
 > -
 > -    /*
 > -     * If this is a sync(2) call or an emergency sync, all the super bl=
ocks
 > -     * will be iterated, including upper_sb, so no need to do anything.
 > -     *
 > -     * If this is a syncfs(2) call, then we do need to call
 > -     * sync_filesystem() on upper_sb, but enough if we do it when being
 > -     * called with wait =3D=3D 1.
 > -     */
 > -    if (!wait)
 > -        return 0;
 > -
 > -    upper_sb =3D ofs->upper_mnt->mnt_sb;
 > -
 > -    down_read(&upper_sb->s_umount);
 > -    ret =3D sync_filesystem(upper_sb);
 > -    up_read(&upper_sb->s_umount);
 > -
 > -    return ret;
 > -}
 > -
 >  /**
 >   * ovl_statfs
 >   * @sb: The overlayfs super block
 > @@ -376,11 +347,19 @@ static int ovl_remount(struct super_block *sb, int=
 *flags, char *data)
 >      return 0;
 >  }
 > =20
 > +static int ovl_drop_inode(struct inode *inode)
 > +{
 > +    if (ovl_inode_upper(inode))
 > +        ovl_set_flag(OVL_EVICT_PENDING, inode);
 > +    return 1;
 > +}
 > +
 >  static const struct super_operations ovl_super_operations =3D {
 >      .alloc_inode    =3D ovl_alloc_inode,
 >      .free_inode    =3D ovl_free_inode,
 >      .destroy_inode    =3D ovl_destroy_inode,
 > -    .drop_inode    =3D generic_delete_inode,
 > +    .drop_inode    =3D ovl_drop_inode,
 > +    .evict_inode    =3D ovl_evict_inode,
 >      .put_super    =3D ovl_put_super,
 >      .sync_fs    =3D ovl_sync_fs,
 >      .statfs        =3D ovl_statfs,
 > @@ -1601,6 +1580,9 @@ static int ovl_fill_super(struct super_block *sb, =
void *data, int silent)
 >      if (!ofs)
 >          goto out;
 > =20
 > +    spin_lock_init(&ofs->upper_inodes_lock);
 > +    INIT_LIST_HEAD(&ofs->upper_inodes);
 > +
 >      ofs->creator_cred =3D cred =3D prepare_creds();
 >      if (!cred)
 >          goto out_err;
 > diff --git a/fs/overlayfs/sync.c b/fs/overlayfs/sync.c
 > new file mode 100644
 > index 000000000000..aecd312ec851
 > --- /dev/null
 > +++ b/fs/overlayfs/sync.c
 > @@ -0,0 +1,331 @@
 > +// SPDX-License-Identifier: GPL-2.0-only
 > +/*
 > + * Copyright (C) 2020 All Rights Reserved.
 > + * Author Chengguang Xu <cgxu519@mykernel.net>
 > + */
 > +
 > +#include <linux/fs.h>
 > +#include <linux/xattr.h>
 > +#include <linux/mount.h>
 > +#include <linux/writeback.h>
 > +#include <linux/blkdev.h>
 > +#include "overlayfs.h"
 > +
 > +/**
 > + * upper_inodes list is used for organizing potential target of syncfs,
 > + * ovl inode which has upper inode will be added to this list while
 > + * initializing or updating and will be deleted from this list while
 > + * evicting.
 > + *
 > + * Introduce ovl_inode flag "OVL_EVICT_PENDING" to indicate the ovl ino=
de
 > + * is in eviction process, syncfs(actually ovl_sync_inodes()) will wait=
 on
 > + * evicting inode until the IO to be completed in evict_inode().
 > + *
 > + * inode state/ovl_inode flags cycle in syncfs context will be as below=
.
 > + * OVL_EVICT_PENDING (ovl_inode->flags) is only marked when inode havin=
g
 > + * upper inode.
 > + *
 > + * (allocation)
 > + *   |
 > + * I_NEW (inode->i_state)
 > + *   |
 > + * NONE  (inode->i_state)
 > + *   |
 > + * OVL_EVICT_PENDING (ovl_inode->flags)
 > + *   |
 > + * I_FREEING (inode->i_state) | OVL_EVICT_PENDING (ovl_inode->flags)
 > + *   |
 > + * I_FREEING (inode->i_state) | I_CLEAR (inode->i_state)
 > + *   |
 > + * (destruction)
 > + *
 > + *
 > + * There are five locks in in syncfs contexts:
 > + *
 > + * upper_sb->s_umount(semaphore)    : avoiding r/o to r/w or vice versa
 > + * sb->s_sync_lock(mutex)           : avoiding concorrent syncfs runnin=
g
 > + * ofs->upper_inodes_lock(spinlock) : protecting upper_inodes list
 > + * sb->s_inode_wblist_lock(spinlock): protecting s_inodes_wb(sync waiti=
ng) list
 > + * inode->i_lock(spinlock)          : protecting inode fields
 > + *
 > + * Lock dependencies in syncfs contexts:
 > + *
 > + * upper_sb->s_umount
 > + *    sb->s_sync_lock
 > + *        ofs->upper_inodes_lock
 > + *            inode->i_lock
 > + *
 > + * upper_sb->s_umount
 > + *    sb->s_sync_lock
 > + *        sb->s_inode_wblist_lock
 > + *
 > + */
 > +
 > +struct ovl_write_inode_work {
 > +    struct work_struct work;
 > +    struct inode *inode;
 > +};
 > +
 > +static void ovl_write_inode_work_fn(struct work_struct *work)
 > +{
 > +    struct ovl_write_inode_work *ovl_wiw;
 > +    struct inode *inode;
 > +
 > +    ovl_wiw =3D container_of(work, struct ovl_write_inode_work, work);
 > +    inode =3D ovl_wiw->inode;
 > +    write_inode_now(ovl_inode_upper(inode), 1);
 > +
 > +    spin_lock(&inode->i_lock);
 > +    ovl_clear_flag(OVL_WRITE_INODE_PENDING, inode);
 > +    wake_up_bit(&OVL_I(inode)->flags, OVL_WRITE_INODE_PENDING);
 > +    spin_unlock(&inode->i_lock);
 > +}
 > +
 > +void ovl_evict_inode(struct inode *inode)
 > +{
 > +    struct ovl_inode *oi =3D OVL_I(inode);
 > +    struct ovl_write_inode_work ovl_wiw;
 > +    DEFINE_WAIT_BIT(wait, &oi->flags, OVL_WRITE_INODE_PENDING);
 > +    wait_queue_head_t *wqh;
 > +
 > +    if (ovl_inode_upper(inode)) {
 > +        if (current->flags & PF_MEMALLOC) {
 > +            spin_lock(&inode->i_lock);
 > +            ovl_set_flag(OVL_WRITE_INODE_PENDING, inode);
 > +            wqh =3D bit_waitqueue(&oi->flags,
 > +                    OVL_WRITE_INODE_PENDING);
 > +            prepare_to_wait(wqh, &wait.wq_entry,
 > +                    TASK_UNINTERRUPTIBLE);
 > +            spin_unlock(&inode->i_lock);
 > +
 > +            ovl_wiw.inode =3D inode;
 > +            INIT_WORK(&ovl_wiw.work, ovl_write_inode_work_fn);
 > +            schedule_work(&ovl_wiw.work);
 > +
 > +            schedule();
 > +            finish_wait(wqh, &wait.wq_entry);
 > +        } else {
 > +            write_inode_now(ovl_inode_upper(inode), 1);
 > +        }
 > +        ovl_detach_upper_inodes_list(inode);
 > +
 > +        /*
 > +         * ovl_sync_inodes() may wait until
 > +         * flag OVL_EVICT_PENDING to be cleared.
 > +         */
 > +        spin_lock(&inode->i_lock);
 > +        ovl_clear_flag(OVL_EVICT_PENDING, inode);
 > +        wake_up_bit(&OVL_I(inode)->flags, OVL_EVICT_PENDING);
 > +        spin_unlock(&inode->i_lock);
 > +    }
 > +    clear_inode(inode);
 > +}
 > +
 > +void ovl_wait_evict_pending(struct inode *inode)
 > +{
 > +    struct ovl_fs *ofs =3D inode->i_sb->s_fs_info;
 > +    struct ovl_inode *oi =3D OVL_I(inode);
 > +    DEFINE_WAIT_BIT(wait, &oi->flags, OVL_EVICT_PENDING);
 > +    wait_queue_head_t *wqh;
 > +
 > +    wqh =3D bit_waitqueue(&oi->flags, OVL_EVICT_PENDING);
 > +    prepare_to_wait(wqh, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
 > +    spin_unlock(&inode->i_lock);
 > +    spin_unlock(&ofs->upper_inodes_lock);
 > +    schedule();
 > +    finish_wait(wqh, &wait.wq_entry);
 > +}
 > +
 > +/**
 > + * ovl_sync_inodes
 > + * @sb: The overlayfs super block
 > + *
 > + * upper_inodes list is used for organizing ovl inode which has upper i=
node,
 > + * by iterating the list to looking for and syncing dirty upper inode.
 > + *
 > + * When starting syncing inode, we add the inode to wait list explicitl=
y,
 > + * in order to save memory we reuse inode->i_wb_list and sb->s_inodes_w=
b,
 > + * so those fields have slightly differnt meanings in overlayfs.
 > + */
 > +static void ovl_sync_inodes(struct super_block *sb)
 > +{
 > +    struct ovl_fs *ofs =3D sb->s_fs_info;
 > +    struct ovl_inode *oi;
 > +    struct inode *inode;
 > +    struct inode *upper_inode;
 > +    struct blk_plug plug;
 > +    LIST_HEAD(sync_tmp_list);
 > +
 > +    struct writeback_control wbc_for_sync =3D {
 > +        .sync_mode        =3D WB_SYNC_ALL,
 > +        .for_sync        =3D 1,
 > +        .range_start        =3D 0,
 > +        .range_end        =3D LLONG_MAX,
 > +        .nr_to_write        =3D LONG_MAX,
 > +    };
 > +
 > +    blk_start_plug(&plug);
 > +    spin_lock(&ofs->upper_inodes_lock);
 > +    list_splice_init(&ofs->upper_inodes, &sync_tmp_list);
 > +
 > +    while (!list_empty(&sync_tmp_list)) {
 > +        oi =3D list_first_entry(&sync_tmp_list, struct ovl_inode,
 > +                        upper_inodes_list);
 > +        inode =3D &oi->vfs_inode;
 > +        spin_lock(&inode->i_lock);
 > +
 > +        if (inode->i_state & I_NEW) {
 > +            list_move_tail(&oi->upper_inodes_list,
 > +                    &ofs->upper_inodes);
 > +            spin_unlock(&inode->i_lock);
 > +            continue;
 > +        }
 > +
 > +        /*
 > +         * If ovl_inode flags is OVL_EVICT_PENDING,
 > +         * left sync operation to the ovl_evict_inode(),
 > +         * so wait here until OVL_EVICT_PENDING flag to be cleared.
 > +         */
 > +        if (ovl_test_flag(OVL_EVICT_PENDING, inode)) {
 > +            ovl_wait_evict_pending(inode);
 > +            goto next;
 > +        }
 > +
 > +        list_move_tail(&oi->upper_inodes_list,
 > +                &ofs->upper_inodes);
 > +        ihold(inode);
 > +        upper_inode =3D ovl_inode_upper(inode);
 > +        spin_unlock(&inode->i_lock);
 > +        spin_unlock(&ofs->upper_inodes_lock);
 > +
 > +        if (!(upper_inode->i_state & I_DIRTY_ALL)) {
 > +            if (!mapping_tagged(upper_inode->i_mapping,
 > +                        PAGECACHE_TAG_WRITEBACK)) {
 > +                iput(inode);
 > +                goto next;
 > +            }
 > +        } else {
 > +            sync_inode(upper_inode, &wbc_for_sync);
 > +        }
 > +
 > +        spin_lock(&sb->s_inode_wblist_lock);
 > +        list_add_tail(&inode->i_wb_list, &sb->s_inodes_wb);
 > +        spin_unlock(&sb->s_inode_wblist_lock);
 > +
 > +next:
 > +        cond_resched();
 > +        spin_lock(&ofs->upper_inodes_lock);
 > +    }
 > +    spin_unlock(&ofs->upper_inodes_lock);
 > +    blk_finish_plug(&plug);
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
 > +    LIST_HEAD(sync_wait_list);
 > +    struct inode *inode;
 > +    struct inode *upper_inode;
 > +
 > +    /*
 > +     * ovl inode in sb->s_inodes_wb list has already got inode referenc=
e,
 > +     * this will avoid silent inode droping during waiting on it.
 > +     *
 > +     * Splice the sync wait list onto a temporary list to avoid waiting=
 on
 > +     * inodes that have started writeback after this point.
 > +     */
 > +    spin_lock(&sb->s_inode_wblist_lock);
 > +    list_splice_init(&sb->s_inodes_wb, &sync_wait_list);
 > +
 > +    while (!list_empty(&sync_wait_list)) {
 > +        inode =3D list_first_entry(&sync_wait_list, struct inode,
 > +                            i_wb_list);
 > +        list_del_init(&inode->i_wb_list);
 > +        upper_inode =3D ovl_inode_upper(inode);
 > +        spin_unlock(&sb->s_inode_wblist_lock);
 > +
 > +        if (!mapping_tagged(upper_inode->i_mapping,
 > +                PAGECACHE_TAG_WRITEBACK)) {
 > +            goto next;
 > +        }
 > +
 > +        filemap_fdatawait_keep_errors(upper_inode->i_mapping);
 > +        cond_resched();
 > +
 > +next:
 > +        iput(inode);
 > +        spin_lock(&sb->s_inode_wblist_lock);
 > +    }
 > +    spin_unlock(&sb->s_inode_wblist_lock);
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
 > +    struct ovl_fs *ofs =3D sb->s_fs_info;
 > +    struct super_block *upper_sb =3D ofs->upper_mnt->mnt_sb;
 > +    int ret =3D 0;
 > +
 > +    down_read(&upper_sb->s_umount);
 > +    if (!sb_rdonly(upper_sb)) {
 > +        /*
 > +         * s_sync_lock is used for serializing concurrent
 > +         * syncfs operations.
 > +         */
 > +        mutex_lock(&sb->s_sync_lock);
 > +        ovl_sync_inodes(sb);
 > +        /* Calling sync_fs with no-wait for better performance. */
 > +        if (upper_sb->s_op->sync_fs)
 > +            upper_sb->s_op->sync_fs(upper_sb, 0);
 > +
 > +        ovl_wait_inodes(sb);
 > +        if (upper_sb->s_op->sync_fs)
 > +            upper_sb->s_op->sync_fs(upper_sb, 1);
 > +
 > +        ret =3D sync_blockdev(upper_sb->s_bdev);
 > +        mutex_unlock(&sb->s_sync_lock);
 > +    }
 > +    up_read(&upper_sb->s_umount);
 > +    return ret;
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
 > +    struct ovl_fs *ofs =3D sb->s_fs_info;
 > +
 > +    if (!ofs->upper_mnt)
 > +        return 0;
 > +
 > +    /*
 > +     * If this is a sync(2) call or an emergency sync, all the super bl=
ocks
 > +     * will be iterated, including upper_sb, so no need to do anything.
 > +     *
 > +     * If this is a syncfs(2) call, then we do need to call
 > +     * sync_filesystem() on upper_sb, but enough if we do it when being
 > +     * called with wait =3D=3D 1.
 > +     */
 > +    if (!wait)
 > +        return 0;
 > +
 > +    return ovl_sync_filesystem(sb);
 > +}
 > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
 > index ea005085803f..73ef195d9aef 100644
 > --- a/fs/overlayfs/util.c
 > +++ b/fs/overlayfs/util.c
 > @@ -386,13 +386,33 @@ void ovl_dentry_set_redirect(struct dentry *dentry=
, const char *redirect)
 >      oi->redirect =3D redirect;
 >  }
 > =20
 > +void ovl_attach_upper_inodes_list(struct inode *inode)
 > +{
 > +    struct ovl_fs *ofs =3D inode->i_sb->s_fs_info;
 > +
 > +    spin_lock(&ofs->upper_inodes_lock);
 > +    list_add(&OVL_I(inode)->upper_inodes_list, &ofs->upper_inodes);
 > +    spin_unlock(&ofs->upper_inodes_lock);
 > +}
 > +
 > +void ovl_detach_upper_inodes_list(struct inode *inode)
 > +{
 > +    struct ovl_fs *ofs =3D inode->i_sb->s_fs_info;
 > +
 > +    spin_lock(&ofs->upper_inodes_lock);
 > +    list_del_init(&OVL_I(inode)->upper_inodes_list);
 > +    spin_unlock(&ofs->upper_inodes_lock);
 > +}
 > +
 >  void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 >              struct dentry *lowerdentry, struct dentry *lowerdata)
 >  {
 >      struct inode *realinode =3D d_inode(upperdentry ?: lowerdentry);
 > =20
 > -    if (upperdentry)
 > +    if (upperdentry) {
 >          OVL_I(inode)->__upperdentry =3D upperdentry;
 > +        ovl_attach_upper_inodes_list(inode);
 > +    }
 >      if (lowerdentry)
 >          OVL_I(inode)->lower =3D igrab(d_inode(lowerdentry));
 >      if (lowerdata)
 > @@ -421,6 +441,7 @@ void ovl_inode_update(struct inode *inode, struct de=
ntry *upperdentry)
 >          inode->i_private =3D upperinode;
 >          __insert_inode_hash(inode, (unsigned long) upperinode);
 >      }
 > +    ovl_attach_upper_inodes_list(inode);
 >  }
 > =20
 >  static void ovl_dentry_version_inc(struct dentry *dentry, bool impurity=
)
 > --=20
 > 2.21.1
 >=20
 >=20
 >

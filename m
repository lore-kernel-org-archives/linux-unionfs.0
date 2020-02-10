Return-Path: <SRS0=hil1=36=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9129EC35254
	for <linux-unionfs@archiver.kernel.org>; Mon, 10 Feb 2020 03:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20A1120714
	for <linux-unionfs@archiver.kernel.org>; Mon, 10 Feb 2020 03:25:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="I0e9GEj6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgBJDZy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 9 Feb 2020 22:25:54 -0500
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21133 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726944AbgBJDZy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 9 Feb 2020 22:25:54 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2020 22:25:51 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1581304219;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=GxVBp23NwPXypBTu22ag9y3f/QCG8A2o8wCtzYhq94Y=;
        b=I0e9GEj6p7bszd4pJUdUT1ZbyxeuIg9+wlg3fVw4IakYHiCTQXyVSAcnkuQrBTD9
        m+A1TW3LwIMkA0EF77vNF6I5HMGHTy23eVG+Zu6yi9lFU6/XilClOukjXv5v4KCZK5A
        Zf1PS0FYXeM/nhb6QLQ4LF/wSqUor7v6tPYCbaVQ=
Received: from localhost.localdomain.localdomain (113.88.132.74 [113.88.132.74]) by mx.zoho.com.cn
        with SMTPS id 1581304214969636.6594847850239; Mon, 10 Feb 2020 11:10:14 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, amir73il@gmail.com, jack@suse.cz
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200210031009.61086-1-cgxu519@mykernel.net>
Subject: [PATCH v11] ovl: Improving syncfs efficiency
Date:   Mon, 10 Feb 2020 11:10:09 +0800
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
on upper_sb to synchronize whole dirty inodes in upper filesystem
regardless of the overlay ownership of the inode. In the use case of
container, when multiple containers using the same underlying upper
filesystem, it has some shortcomings as below.

(1) Performance
Synchronization is probably heavy because it actually syncs unnecessary
inodes for target overlayfs.

(2) Interference
Unplanned synchronization will probably impact IO performance of
unrelated container processes on the other overlayfs.

This patch iterates upper inode list in overlayfs to only sync target
dirty inodes and wait for completion. By doing this, It is able to
reduce cost of synchronization and will not seriously impact IO performance
of unrelated processes. In special case, when having very few dirty inodes
and a lot of clean upper inodes in overlayfs, then iteration may waste
time so that synchronization is slower than before, but we think the
potential for performance improvement far surpass the potential for
performance regression in most cases.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
Changes since v10:
- Add special handling in ovl_evict_inode() for inode eviction trigered
by kswapd memory reclamation(with PF_MEMALLOC flag).
- Rebase on current latest overlayfs-next tree.
- Slightly modify license information.

Changes since v9:
- Rebase on current latest overlayfs-next tree.
- Calling clear_inode() regardless of having upper inode.

Changes since v8:
- Remove unnecessary blk_start_plug() call in ovl_sync_inodes().

Changes since v7:
- Check OVL_EVICT_PENDING flag instead of I_FREEING to recognize
inode which is in eviction process.
- Do not move ovl_inode back to ofs->upper_inodes when inode is in
eviction process.
- Delete unnecessary memory barrier in ovl_evict_inode().

Changes since v6:
- Take/release sb->s_sync_lock bofore/after sync_fs to serialize
concurrent syncfs.
- Change list iterating method to improve code readability.
- Fix typo in commit log and comments.
- Add header comment to sync.c.

Changes since v5:
- Move sync related functions to new file sync.c.
- Introduce OVL_EVICT_PENDING flag to avoid race conditions.
- If ovl inode flag is I_WILL_FREE or I_FREEING then syncfs
will wait until OVL_EVICT_PENDING to be cleared.
- Move inode sync operation into evict_inode from drop_inode.
- Call upper_sb->sync_fs with no-wait after sync dirty upper
inodes.
- Hold s_inode_wblist_lock until deleting item from list.
- Remove write_inode fuction because no more used.

Changes since v4:
- Add syncing operation and deleting from upper_inodes list
during ovl inode destruction.
- Export symbol of inode_wait_for_writeback() for waiting
writeback on ovl inode.
- Reuse I_SYNC flag to avoid race conditions between syncfs
and drop_inode.

Changes since v3:
- Introduce upper_inode list to organize ovl inode which has upper
  inode.
- Avoid iput operation inside spin lock.
- Change list iteration method for safety.
- Reuse inode->i_wb_list and sb->s_inodes_wb to save memory.
- Modify commit log and add more comments to the code.

Changes since v2:
- Decoupling with syncfs of upper fs by taking sb->s_sync_lock of
overlayfs.
- Factoring out sync operation to different helpers for easy
  understanding.

Changes since v1:
- If upper filesystem is readonly mode then skip synchronization.
- Introduce global wait list to replace temporary wait list for
concurrent synchronization.

 fs/overlayfs/Makefile    |   2 +-
 fs/overlayfs/overlayfs.h |   9 ++
 fs/overlayfs/ovl_entry.h |   5 +
 fs/overlayfs/super.c     |  44 ++----
 fs/overlayfs/sync.c      | 331 +++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/util.c      |  23 ++-
 6 files changed, 381 insertions(+), 33 deletions(-)
 create mode 100644 fs/overlayfs/sync.c

diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
index 9164c585eb2f..0c4e53fcf4ef 100644
--- a/fs/overlayfs/Makefile
+++ b/fs/overlayfs/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_OVERLAY_FS) +=3D overlay.o
=20
 overlay-objs :=3D super.o namei.o util.o inode.o file.o dir.o readdir.o \
-=09=09copy_up.o export.o
+=09=09copy_up.o export.o sync.o
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 3623d28aa4fa..3cdb06e206a3 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -40,6 +40,10 @@ enum ovl_inode_flag {
 =09OVL_UPPERDATA,
 =09/* Inode number will remain constant over copy up. */
 =09OVL_CONST_INO,
+=09/* Set when ovl inode is about to be freed */
+=09OVL_EVICT_PENDING,
+=09/* Set when sync upper inode in workqueue work */
+=09OVL_WRITE_INODE_PENDING,
 };
=20
 enum ovl_entry_flag {
@@ -295,6 +299,7 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry);
 char *ovl_get_redirect_xattr(struct dentry *dentry, int padding);
 ssize_t ovl_getxattr(struct dentry *dentry, char *name, char **value,
 =09=09     size_t padding);
+void ovl_detach_upper_inodes_list(struct inode *inode);
=20
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
@@ -466,3 +471,7 @@ int ovl_set_origin(struct dentry *dentry, struct dentry=
 *lower,
=20
 /* export.c */
 extern const struct export_operations ovl_export_operations;
+
+/* sync.c */
+void ovl_evict_inode(struct inode *inode);
+int ovl_sync_fs(struct super_block *sb, int wait);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 89015ea822e7..42e092e8cd61 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -75,6 +75,9 @@ struct ovl_fs {
 =09struct inode *indexdir_trap;
 =09/* -1: disabled, 0: same fs, 1..32: number of unused ino bits */
 =09int xino_mode;
+=09/* Upper inode list and lock */
+=09spinlock_t upper_inodes_lock;
+=09struct list_head upper_inodes;
 };
=20
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
@@ -115,6 +118,8 @@ struct ovl_inode {
=20
 =09/* synchronize copy up and more */
 =09struct mutex lock;
+=09/* Upper inodes list */
+=09struct list_head upper_inodes_list;
 };
=20
 static inline struct ovl_inode *OVL_I(struct inode *inode)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 319fe0d355b0..3e6871e1a7ba 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -183,6 +183,7 @@ static struct inode *ovl_alloc_inode(struct super_block=
 *sb)
 =09oi->lower =3D NULL;
 =09oi->lowerdata =3D NULL;
 =09mutex_init(&oi->lock);
+=09INIT_LIST_HEAD(&oi->upper_inodes_list);
=20
 =09return &oi->vfs_inode;
 }
@@ -249,36 +250,6 @@ static void ovl_put_super(struct super_block *sb)
 =09ovl_free_fs(ofs);
 }
=20
-/* Sync real dirty inodes in upper filesystem (if it exists) */
-static int ovl_sync_fs(struct super_block *sb, int wait)
-{
-=09struct ovl_fs *ofs =3D sb->s_fs_info;
-=09struct super_block *upper_sb;
-=09int ret;
-
-=09if (!ofs->upper_mnt)
-=09=09return 0;
-
-=09/*
-=09 * If this is a sync(2) call or an emergency sync, all the super blocks
-=09 * will be iterated, including upper_sb, so no need to do anything.
-=09 *
-=09 * If this is a syncfs(2) call, then we do need to call
-=09 * sync_filesystem() on upper_sb, but enough if we do it when being
-=09 * called with wait =3D=3D 1.
-=09 */
-=09if (!wait)
-=09=09return 0;
-
-=09upper_sb =3D ofs->upper_mnt->mnt_sb;
-
-=09down_read(&upper_sb->s_umount);
-=09ret =3D sync_filesystem(upper_sb);
-=09up_read(&upper_sb->s_umount);
-
-=09return ret;
-}
-
 /**
  * ovl_statfs
  * @sb: The overlayfs super block
@@ -376,11 +347,19 @@ static int ovl_remount(struct super_block *sb, int *f=
lags, char *data)
 =09return 0;
 }
=20
+static int ovl_drop_inode(struct inode *inode)
+{
+=09if (ovl_inode_upper(inode))
+=09=09ovl_set_flag(OVL_EVICT_PENDING, inode);
+=09return 1;
+}
+
 static const struct super_operations ovl_super_operations =3D {
 =09.alloc_inode=09=3D ovl_alloc_inode,
 =09.free_inode=09=3D ovl_free_inode,
 =09.destroy_inode=09=3D ovl_destroy_inode,
-=09.drop_inode=09=3D generic_delete_inode,
+=09.drop_inode=09=3D ovl_drop_inode,
+=09.evict_inode=09=3D ovl_evict_inode,
 =09.put_super=09=3D ovl_put_super,
 =09.sync_fs=09=3D ovl_sync_fs,
 =09.statfs=09=09=3D ovl_statfs,
@@ -1601,6 +1580,9 @@ static int ovl_fill_super(struct super_block *sb, voi=
d *data, int silent)
 =09if (!ofs)
 =09=09goto out;
=20
+=09spin_lock_init(&ofs->upper_inodes_lock);
+=09INIT_LIST_HEAD(&ofs->upper_inodes);
+
 =09ofs->creator_cred =3D cred =3D prepare_creds();
 =09if (!cred)
 =09=09goto out_err;
diff --git a/fs/overlayfs/sync.c b/fs/overlayfs/sync.c
new file mode 100644
index 000000000000..aecd312ec851
--- /dev/null
+++ b/fs/overlayfs/sync.c
@@ -0,0 +1,331 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 All Rights Reserved.
+ * Author Chengguang Xu <cgxu519@mykernel.net>
+ */
+
+#include <linux/fs.h>
+#include <linux/xattr.h>
+#include <linux/mount.h>
+#include <linux/writeback.h>
+#include <linux/blkdev.h>
+#include "overlayfs.h"
+
+/**
+ * upper_inodes list is used for organizing potential target of syncfs,
+ * ovl inode which has upper inode will be added to this list while
+ * initializing or updating and will be deleted from this list while
+ * evicting.
+ *
+ * Introduce ovl_inode flag "OVL_EVICT_PENDING" to indicate the ovl inode
+ * is in eviction process, syncfs(actually ovl_sync_inodes()) will wait on
+ * evicting inode until the IO to be completed in evict_inode().
+ *
+ * inode state/ovl_inode flags cycle in syncfs context will be as below.
+ * OVL_EVICT_PENDING (ovl_inode->flags) is only marked when inode having
+ * upper inode.
+ *
+ * (allocation)
+ *   |
+ * I_NEW (inode->i_state)
+ *   |
+ * NONE  (inode->i_state)
+ *   |
+ * OVL_EVICT_PENDING (ovl_inode->flags)
+ *   |
+ * I_FREEING (inode->i_state) | OVL_EVICT_PENDING (ovl_inode->flags)
+ *   |
+ * I_FREEING (inode->i_state) | I_CLEAR (inode->i_state)
+ *   |
+ * (destruction)
+ *
+ *
+ * There are five locks in in syncfs contexts:
+ *
+ * upper_sb->s_umount(semaphore)    : avoiding r/o to r/w or vice versa
+ * sb->s_sync_lock(mutex)           : avoiding concorrent syncfs running
+ * ofs->upper_inodes_lock(spinlock) : protecting upper_inodes list
+ * sb->s_inode_wblist_lock(spinlock): protecting s_inodes_wb(sync waiting)=
 list
+ * inode->i_lock(spinlock)          : protecting inode fields
+ *
+ * Lock dependencies in syncfs contexts:
+ *
+ * upper_sb->s_umount
+ *=09sb->s_sync_lock
+ *=09=09ofs->upper_inodes_lock
+ *=09=09=09inode->i_lock
+ *
+ * upper_sb->s_umount
+ *=09sb->s_sync_lock
+ *=09=09sb->s_inode_wblist_lock
+ *
+ */
+
+struct ovl_write_inode_work {
+=09struct work_struct work;
+=09struct inode *inode;
+};
+
+static void ovl_write_inode_work_fn(struct work_struct *work)
+{
+=09struct ovl_write_inode_work *ovl_wiw;
+=09struct inode *inode;
+
+=09ovl_wiw =3D container_of(work, struct ovl_write_inode_work, work);
+=09inode =3D ovl_wiw->inode;
+=09write_inode_now(ovl_inode_upper(inode), 1);
+
+=09spin_lock(&inode->i_lock);
+=09ovl_clear_flag(OVL_WRITE_INODE_PENDING, inode);
+=09wake_up_bit(&OVL_I(inode)->flags, OVL_WRITE_INODE_PENDING);
+=09spin_unlock(&inode->i_lock);
+}
+
+void ovl_evict_inode(struct inode *inode)
+{
+=09struct ovl_inode *oi =3D OVL_I(inode);
+=09struct ovl_write_inode_work ovl_wiw;
+=09DEFINE_WAIT_BIT(wait, &oi->flags, OVL_WRITE_INODE_PENDING);
+=09wait_queue_head_t *wqh;
+
+=09if (ovl_inode_upper(inode)) {
+=09=09if (current->flags & PF_MEMALLOC) {
+=09=09=09spin_lock(&inode->i_lock);
+=09=09=09ovl_set_flag(OVL_WRITE_INODE_PENDING, inode);
+=09=09=09wqh =3D bit_waitqueue(&oi->flags,
+=09=09=09=09=09OVL_WRITE_INODE_PENDING);
+=09=09=09prepare_to_wait(wqh, &wait.wq_entry,
+=09=09=09=09=09TASK_UNINTERRUPTIBLE);
+=09=09=09spin_unlock(&inode->i_lock);
+
+=09=09=09ovl_wiw.inode =3D inode;
+=09=09=09INIT_WORK(&ovl_wiw.work, ovl_write_inode_work_fn);
+=09=09=09schedule_work(&ovl_wiw.work);
+
+=09=09=09schedule();
+=09=09=09finish_wait(wqh, &wait.wq_entry);
+=09=09} else {
+=09=09=09write_inode_now(ovl_inode_upper(inode), 1);
+=09=09}
+=09=09ovl_detach_upper_inodes_list(inode);
+
+=09=09/*
+=09=09 * ovl_sync_inodes() may wait until
+=09=09 * flag OVL_EVICT_PENDING to be cleared.
+=09=09 */
+=09=09spin_lock(&inode->i_lock);
+=09=09ovl_clear_flag(OVL_EVICT_PENDING, inode);
+=09=09wake_up_bit(&OVL_I(inode)->flags, OVL_EVICT_PENDING);
+=09=09spin_unlock(&inode->i_lock);
+=09}
+=09clear_inode(inode);
+}
+
+void ovl_wait_evict_pending(struct inode *inode)
+{
+=09struct ovl_fs *ofs =3D inode->i_sb->s_fs_info;
+=09struct ovl_inode *oi =3D OVL_I(inode);
+=09DEFINE_WAIT_BIT(wait, &oi->flags, OVL_EVICT_PENDING);
+=09wait_queue_head_t *wqh;
+
+=09wqh =3D bit_waitqueue(&oi->flags, OVL_EVICT_PENDING);
+=09prepare_to_wait(wqh, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
+=09spin_unlock(&inode->i_lock);
+=09spin_unlock(&ofs->upper_inodes_lock);
+=09schedule();
+=09finish_wait(wqh, &wait.wq_entry);
+}
+
+/**
+ * ovl_sync_inodes
+ * @sb: The overlayfs super block
+ *
+ * upper_inodes list is used for organizing ovl inode which has upper inod=
e,
+ * by iterating the list to looking for and syncing dirty upper inode.
+ *
+ * When starting syncing inode, we add the inode to wait list explicitly,
+ * in order to save memory we reuse inode->i_wb_list and sb->s_inodes_wb,
+ * so those fields have slightly differnt meanings in overlayfs.
+ */
+static void ovl_sync_inodes(struct super_block *sb)
+{
+=09struct ovl_fs *ofs =3D sb->s_fs_info;
+=09struct ovl_inode *oi;
+=09struct inode *inode;
+=09struct inode *upper_inode;
+=09struct blk_plug plug;
+=09LIST_HEAD(sync_tmp_list);
+
+=09struct writeback_control wbc_for_sync =3D {
+=09=09.sync_mode=09=09=3D WB_SYNC_ALL,
+=09=09.for_sync=09=09=3D 1,
+=09=09.range_start=09=09=3D 0,
+=09=09.range_end=09=09=3D LLONG_MAX,
+=09=09.nr_to_write=09=09=3D LONG_MAX,
+=09};
+
+=09blk_start_plug(&plug);
+=09spin_lock(&ofs->upper_inodes_lock);
+=09list_splice_init(&ofs->upper_inodes, &sync_tmp_list);
+
+=09while (!list_empty(&sync_tmp_list)) {
+=09=09oi =3D list_first_entry(&sync_tmp_list, struct ovl_inode,
+=09=09=09=09=09=09upper_inodes_list);
+=09=09inode =3D &oi->vfs_inode;
+=09=09spin_lock(&inode->i_lock);
+
+=09=09if (inode->i_state & I_NEW) {
+=09=09=09list_move_tail(&oi->upper_inodes_list,
+=09=09=09=09=09&ofs->upper_inodes);
+=09=09=09spin_unlock(&inode->i_lock);
+=09=09=09continue;
+=09=09}
+
+=09=09/*
+=09=09 * If ovl_inode flags is OVL_EVICT_PENDING,
+=09=09 * left sync operation to the ovl_evict_inode(),
+=09=09 * so wait here until OVL_EVICT_PENDING flag to be cleared.
+=09=09 */
+=09=09if (ovl_test_flag(OVL_EVICT_PENDING, inode)) {
+=09=09=09ovl_wait_evict_pending(inode);
+=09=09=09goto next;
+=09=09}
+
+=09=09list_move_tail(&oi->upper_inodes_list,
+=09=09=09=09&ofs->upper_inodes);
+=09=09ihold(inode);
+=09=09upper_inode =3D ovl_inode_upper(inode);
+=09=09spin_unlock(&inode->i_lock);
+=09=09spin_unlock(&ofs->upper_inodes_lock);
+
+=09=09if (!(upper_inode->i_state & I_DIRTY_ALL)) {
+=09=09=09if (!mapping_tagged(upper_inode->i_mapping,
+=09=09=09=09=09=09PAGECACHE_TAG_WRITEBACK)) {
+=09=09=09=09iput(inode);
+=09=09=09=09goto next;
+=09=09=09}
+=09=09} else {
+=09=09=09sync_inode(upper_inode, &wbc_for_sync);
+=09=09}
+
+=09=09spin_lock(&sb->s_inode_wblist_lock);
+=09=09list_add_tail(&inode->i_wb_list, &sb->s_inodes_wb);
+=09=09spin_unlock(&sb->s_inode_wblist_lock);
+
+next:
+=09=09cond_resched();
+=09=09spin_lock(&ofs->upper_inodes_lock);
+=09}
+=09spin_unlock(&ofs->upper_inodes_lock);
+=09blk_finish_plug(&plug);
+}
+
+/**
+ * ovl_wait_inodes
+ * @sb: The overlayfs super block
+ *
+ * Waiting writeback inodes which are in s_inodes_wb list,
+ * all the IO that has been issued up to the time this
+ * function is enter is guaranteed to be completed.
+ */
+static void ovl_wait_inodes(struct super_block *sb)
+{
+=09LIST_HEAD(sync_wait_list);
+=09struct inode *inode;
+=09struct inode *upper_inode;
+
+=09/*
+=09 * ovl inode in sb->s_inodes_wb list has already got inode reference,
+=09 * this will avoid silent inode droping during waiting on it.
+=09 *
+=09 * Splice the sync wait list onto a temporary list to avoid waiting on
+=09 * inodes that have started writeback after this point.
+=09 */
+=09spin_lock(&sb->s_inode_wblist_lock);
+=09list_splice_init(&sb->s_inodes_wb, &sync_wait_list);
+
+=09while (!list_empty(&sync_wait_list)) {
+=09=09inode =3D list_first_entry(&sync_wait_list, struct inode,
+=09=09=09=09=09=09=09i_wb_list);
+=09=09list_del_init(&inode->i_wb_list);
+=09=09upper_inode =3D ovl_inode_upper(inode);
+=09=09spin_unlock(&sb->s_inode_wblist_lock);
+
+=09=09if (!mapping_tagged(upper_inode->i_mapping,
+=09=09=09=09PAGECACHE_TAG_WRITEBACK)) {
+=09=09=09goto next;
+=09=09}
+
+=09=09filemap_fdatawait_keep_errors(upper_inode->i_mapping);
+=09=09cond_resched();
+
+next:
+=09=09iput(inode);
+=09=09spin_lock(&sb->s_inode_wblist_lock);
+=09}
+=09spin_unlock(&sb->s_inode_wblist_lock);
+}
+
+/**
+ * ovl_sync_filesystem
+ * @sb: The overlayfs super block
+ *
+ * Sync underlying dirty inodes in upper filesystem and
+ * wait for completion.
+ */
+static int ovl_sync_filesystem(struct super_block *sb)
+{
+=09struct ovl_fs *ofs =3D sb->s_fs_info;
+=09struct super_block *upper_sb =3D ofs->upper_mnt->mnt_sb;
+=09int ret =3D 0;
+
+=09down_read(&upper_sb->s_umount);
+=09if (!sb_rdonly(upper_sb)) {
+=09=09/*
+=09=09 * s_sync_lock is used for serializing concurrent
+=09=09 * syncfs operations.
+=09=09 */
+=09=09mutex_lock(&sb->s_sync_lock);
+=09=09ovl_sync_inodes(sb);
+=09=09/* Calling sync_fs with no-wait for better performance. */
+=09=09if (upper_sb->s_op->sync_fs)
+=09=09=09upper_sb->s_op->sync_fs(upper_sb, 0);
+
+=09=09ovl_wait_inodes(sb);
+=09=09if (upper_sb->s_op->sync_fs)
+=09=09=09upper_sb->s_op->sync_fs(upper_sb, 1);
+
+=09=09ret =3D sync_blockdev(upper_sb->s_bdev);
+=09=09mutex_unlock(&sb->s_sync_lock);
+=09}
+=09up_read(&upper_sb->s_umount);
+=09return ret;
+}
+
+/**
+ * ovl_sync_fs
+ * @sb: The overlayfs super block
+ * @wait: Wait for I/O to complete
+ *
+ * Sync real dirty inodes in upper filesystem (if it exists)
+ */
+int ovl_sync_fs(struct super_block *sb, int wait)
+{
+=09struct ovl_fs *ofs =3D sb->s_fs_info;
+
+=09if (!ofs->upper_mnt)
+=09=09return 0;
+
+=09/*
+=09 * If this is a sync(2) call or an emergency sync, all the super blocks
+=09 * will be iterated, including upper_sb, so no need to do anything.
+=09 *
+=09 * If this is a syncfs(2) call, then we do need to call
+=09 * sync_filesystem() on upper_sb, but enough if we do it when being
+=09 * called with wait =3D=3D 1.
+=09 */
+=09if (!wait)
+=09=09return 0;
+
+=09return ovl_sync_filesystem(sb);
+}
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index ea005085803f..73ef195d9aef 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -386,13 +386,33 @@ void ovl_dentry_set_redirect(struct dentry *dentry, c=
onst char *redirect)
 =09oi->redirect =3D redirect;
 }
=20
+void ovl_attach_upper_inodes_list(struct inode *inode)
+{
+=09struct ovl_fs *ofs =3D inode->i_sb->s_fs_info;
+
+=09spin_lock(&ofs->upper_inodes_lock);
+=09list_add(&OVL_I(inode)->upper_inodes_list, &ofs->upper_inodes);
+=09spin_unlock(&ofs->upper_inodes_lock);
+}
+
+void ovl_detach_upper_inodes_list(struct inode *inode)
+{
+=09struct ovl_fs *ofs =3D inode->i_sb->s_fs_info;
+
+=09spin_lock(&ofs->upper_inodes_lock);
+=09list_del_init(&OVL_I(inode)->upper_inodes_list);
+=09spin_unlock(&ofs->upper_inodes_lock);
+}
+
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 =09=09    struct dentry *lowerdentry, struct dentry *lowerdata)
 {
 =09struct inode *realinode =3D d_inode(upperdentry ?: lowerdentry);
=20
-=09if (upperdentry)
+=09if (upperdentry) {
 =09=09OVL_I(inode)->__upperdentry =3D upperdentry;
+=09=09ovl_attach_upper_inodes_list(inode);
+=09}
 =09if (lowerdentry)
 =09=09OVL_I(inode)->lower =3D igrab(d_inode(lowerdentry));
 =09if (lowerdata)
@@ -421,6 +441,7 @@ void ovl_inode_update(struct inode *inode, struct dentr=
y *upperdentry)
 =09=09inode->i_private =3D upperinode;
 =09=09__insert_inode_hash(inode, (unsigned long) upperinode);
 =09}
+=09ovl_attach_upper_inodes_list(inode);
 }
=20
 static void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
--=20
2.21.1




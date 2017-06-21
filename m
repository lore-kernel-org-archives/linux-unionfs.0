From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 12/25] ovl: allocate an ovl_inode struct
Date: Wed, 21 Jun 2017 15:28:43 +0300
Message-ID: <1498048136-28218-13-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33609 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdFUM3B (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:29:01 -0400
Received: by mail-wr0-f196.google.com with SMTP id x23so26118127wrb.0
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 05:29:01 -0700 (PDT)
In-Reply-To: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

We need some more space to store overlay inode data in memory,
so allocate overlay inodes from a slab of struct ovl_inode.

The ovl_inode struct includes a mutex that is going to be used
for synchronizing copy up of lower hardlinks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/ovl_entry.h | 12 ++++++++++
 fs/overlayfs/super.c     | 62 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 6de8725cc38a..6c36fa70abe4 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -65,3 +65,15 @@ static inline struct dentry *ovl_upperdentry_dereference(struct ovl_entry *oe)
 {
 	return lockless_dereference(oe->__upperdentry);
 }
+
+struct ovl_inode {
+	/* keep this first */
+	struct inode vfs_inode;
+	/* synchronize copy up and more */
+	struct mutex oi_lock;
+};
+
+static inline struct ovl_inode *OVL_I(struct inode *inode)
+{
+	return (struct ovl_inode *) inode;
+}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b3ac406654bd..d32ae4c00f9c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -170,6 +170,34 @@ static const struct dentry_operations ovl_reval_dentry_operations = {
 	.d_weak_revalidate = ovl_dentry_weak_revalidate,
 };
 
+static struct kmem_cache *ovl_inode_cachep;
+
+static struct inode *ovl_alloc_inode(struct super_block *sb)
+{
+	struct inode *inode;
+
+	inode = kmem_cache_alloc(ovl_inode_cachep, GFP_KERNEL);
+	if (!inode)
+		return NULL;
+
+	mutex_init(&OVL_I(inode)->oi_lock);
+
+	return inode;
+}
+
+static void ovl_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+
+	kmem_cache_free(ovl_inode_cachep, inode);
+}
+
+static void ovl_destroy_inode(struct inode *inode)
+{
+	mutex_destroy(&OVL_I(inode)->oi_lock);
+	call_rcu(&inode->i_rcu, ovl_i_callback);
+}
+
 /* Get exclusive ownership on upper/work dir among overlay mounts */
 static bool ovl_dir_lock(struct dentry *dentry)
 {
@@ -294,12 +322,14 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 }
 
 static const struct super_operations ovl_super_operations = {
+	.alloc_inode	= ovl_alloc_inode,
+	.destroy_inode	= ovl_destroy_inode,
+	.drop_inode	= generic_delete_inode,
 	.put_super	= ovl_put_super,
 	.sync_fs	= ovl_sync_fs,
 	.statfs		= ovl_statfs,
 	.show_options	= ovl_show_options,
 	.remount_fs	= ovl_remount,
-	.drop_inode	= generic_delete_inode,
 };
 
 enum {
@@ -1171,14 +1201,42 @@ static struct file_system_type ovl_fs_type = {
 };
 MODULE_ALIAS_FS("overlay");
 
+static void ovl_inode_init_once(void *foo)
+{
+	struct inode *inode = foo;
+
+	inode_init_once(inode);
+}
+
 static int __init ovl_init(void)
 {
-	return register_filesystem(&ovl_fs_type);
+	int err;
+
+	ovl_inode_cachep = kmem_cache_create("ovl_inode",
+					     sizeof(struct ovl_inode), 0,
+					     SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT,
+					     ovl_inode_init_once);
+	if (ovl_inode_cachep == NULL)
+		return -ENOMEM;
+
+	err = register_filesystem(&ovl_fs_type);
+	if (err)
+		kmem_cache_destroy(ovl_inode_cachep);
+
+	return err;
 }
 
 static void __exit ovl_exit(void)
 {
 	unregister_filesystem(&ovl_fs_type);
+
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
+	kmem_cache_destroy(ovl_inode_cachep);
+
 }
 
 module_init(ovl_init);
-- 
2.7.4

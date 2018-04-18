Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v2] ovl: introduce a dedicated cache pool for ovl_entry
Date: Wed, 18 Apr 2018 12:11:26 +0800
Message-Id: <1524024686-1354-1-git-send-email-cgxu519@gmx.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

Introduce a dedicated cache pool for ovl_entry which only has
one lowerpath to optimize memory allocation and deallocation.
For multi-lowerpath ovl_entry, using kzalloc/kfree as usual.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
Changes since v1:
- Using lowerstack[1] array statement to replace union statement in ovl_entry,
so that we can avoid unnecessary modification in many calling places.

 fs/overlayfs/namei.c     |  2 +-
 fs/overlayfs/overlayfs.h |  4 ++++
 fs/overlayfs/ovl_entry.h |  6 ++----
 fs/overlayfs/super.c     | 23 ++++++++++++++++++-----
 fs/overlayfs/util.c      | 19 +++++++++++++++++--
 5 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 2dba29e..bee559a6 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1026,7 +1026,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 out_free_oe:
 	dentry->d_fsdata = NULL;
-	kfree(oe);
+	ovl_free_entry(oe);
 out_put:
 	dput(index);
 	for (i = 0; i < ctr; i++)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e0b7de7..4057e5b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -207,6 +207,7 @@ static inline struct dentry *ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
 bool ovl_index_all(struct super_block *sb);
 bool ovl_verify_lower(struct super_block *sb);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
+void ovl_free_entry(struct ovl_entry *oe);
 bool ovl_dentry_remote(struct dentry *dentry);
 bool ovl_dentry_weird(struct dentry *dentry);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
@@ -376,3 +377,6 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 
 /* export.c */
 extern const struct export_operations ovl_export_operations;
+
+/* super.c */
+extern struct kmem_cache *ovl_entry_cachep;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 41655a7..b274181 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -71,13 +71,11 @@ struct ovl_fs {
 /* private information held for every overlayfs dentry */
 struct ovl_entry {
 	union {
-		struct {
-			unsigned long flags;
-		};
+		unsigned long flags;
 		struct rcu_head rcu;
 	};
 	unsigned numlower;
-	struct ovl_path lowerstack[];
+	struct ovl_path lowerstack[1];
 };
 
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e8551c9..b28fe3d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -191,6 +191,7 @@ static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
 };
 
 static struct kmem_cache *ovl_inode_cachep;
+struct kmem_cache *ovl_entry_cachep;
 
 static struct inode *ovl_alloc_inode(struct super_block *sb)
 {
@@ -1484,7 +1485,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 out_free_oe:
 	ovl_entry_stack_free(oe);
-	kfree(oe);
+	ovl_free_entry(oe);
 out_err:
 	path_put(&upperpath);
 	ovl_free_fs(ofs);
@@ -1515,19 +1516,31 @@ static void ovl_inode_init_once(void *foo)
 
 static int __init ovl_init(void)
 {
-	int err;
+	int err = -ENOMEM;
 
 	ovl_inode_cachep = kmem_cache_create("ovl_inode",
 					     sizeof(struct ovl_inode), 0,
 					     (SLAB_RECLAIM_ACCOUNT|
 					      SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     ovl_inode_init_once);
-	if (ovl_inode_cachep == NULL)
+	if (!ovl_inode_cachep)
 		return -ENOMEM;
 
+	ovl_entry_cachep = KMEM_CACHE(ovl_entry,
+				SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
+	if (!ovl_entry_cachep)
+		goto bad_entry_cachep;
+
 	err = register_filesystem(&ovl_fs_type);
 	if (err)
-		kmem_cache_destroy(ovl_inode_cachep);
+		goto out_err;
+
+	return 0;
+
+out_err:
+	kmem_cache_destroy(ovl_entry_cachep);
+bad_entry_cachep:
+	kmem_cache_destroy(ovl_inode_cachep);
 
 	return err;
 }
@@ -1541,8 +1554,8 @@ static void __exit ovl_exit(void)
 	 * destroy cache.
 	 */
 	rcu_barrier();
+	kmem_cache_destroy(ovl_entry_cachep);
 	kmem_cache_destroy(ovl_inode_cachep);
-
 }
 
 module_init(ovl_init);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 6f10780..8c4968f 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -95,10 +95,25 @@ bool ovl_verify_lower(struct super_block *sb)
 	return ofs->config.nfs_export && ofs->config.index;
 }
 
+void ovl_free_entry(struct ovl_entry *oe)
+{
+	if (oe->numlower > 1)
+		kfree(oe);
+	else
+		kmem_cache_free(ovl_entry_cachep, oe);
+}
+
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 {
-	size_t size = offsetof(struct ovl_entry, lowerstack[numlower]);
-	struct ovl_entry *oe = kzalloc(size, GFP_KERNEL);
+	size_t size;
+	struct ovl_entry *oe;
+
+	if (numlower > 1) {
+		size = offsetof(struct ovl_entry, lowerstack[numlower]);
+		oe = kzalloc(size, GFP_KERNEL);
+	} else {
+		oe = kmem_cache_zalloc(ovl_entry_cachep, GFP_KERNEL);
+	}
 
 	if (oe)
 		oe->numlower = numlower;
-- 
1.8.3.1

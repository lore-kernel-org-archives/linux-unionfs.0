From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH] ovl: Using slab allocation for frequently used struct
Date: Thu, 18 Jan 2018 23:56:17 +0800
Message-ID: <1516290977-130583-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mr11p00im-asmtp002.me.com ([17.110.69.253]:25021 "EHLO
        mr11p00im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933204AbeARP5E (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jan 2018 10:57:04 -0500
Received: from process-dkim-sign-daemon.mr11p00im-asmtp002.me.com by
 mr11p00im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2R00B00CH0H600@mr11p00im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Thu, 18 Jan 2018 15:57:03 +0000 (GMT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

Introducing slab allocation to replace kmalloc/kfree for
frequently used struct ovl_dir_file and ovl_dir_cache.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
 fs/overlayfs/overlayfs.h |  4 ++++
 fs/overlayfs/ovl_entry.h | 16 ++++++++++++++++
 fs/overlayfs/readdir.c   | 36 ++++++++++--------------------------
 fs/overlayfs/super.c     | 36 ++++++++++++++++++++++++++++++++----
 4 files changed, 62 insertions(+), 30 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b489099..f407882 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -322,3 +322,7 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper);
+
+/* super.c */
+extern struct kmem_cache *ovl_dir_file_cachep;
+extern struct kmem_cache *ovl_dir_cache_cachep;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 9d0bc03..a5d241d 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -91,3 +91,19 @@ static inline struct dentry *ovl_upperdentry_dereference(struct ovl_inode *oi)
 {
 	return READ_ONCE(oi->__upperdentry);
 }
+
+struct ovl_dir_cache {
+	long refcount;
+	u64 version;
+	struct list_head entries;
+	struct rb_root root;
+};
+
+struct ovl_dir_file {
+	bool is_real;
+	bool is_upper;
+	struct ovl_dir_cache *cache;
+	struct list_head *cursor;
+	struct file *realfile;
+	struct file *upperfile;
+};
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 8c98578..cb0e3fb 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -31,13 +31,6 @@ struct ovl_cache_entry {
 	char name[];
 };
 
-struct ovl_dir_cache {
-	long refcount;
-	u64 version;
-	struct list_head entries;
-	struct rb_root root;
-};
-
 struct ovl_readdir_data {
 	struct dir_context ctx;
 	struct dentry *dentry;
@@ -52,15 +45,6 @@ struct ovl_readdir_data {
 	bool d_type_supported;
 };
 
-struct ovl_dir_file {
-	bool is_real;
-	bool is_upper;
-	struct ovl_dir_cache *cache;
-	struct list_head *cursor;
-	struct file *realfile;
-	struct file *upperfile;
-};
-
 static struct ovl_cache_entry *ovl_cache_entry_from_node(struct rb_node *n)
 {
 	return rb_entry(n, struct ovl_cache_entry, node);
@@ -230,7 +214,7 @@ void ovl_dir_cache_free(struct inode *inode)
 
 	if (cache) {
 		ovl_cache_free(&cache->entries);
-		kfree(cache);
+		kmem_cache_free(ovl_dir_cache_cachep, cache);
 	}
 }
 
@@ -245,7 +229,7 @@ static void ovl_cache_put(struct ovl_dir_file *od, struct dentry *dentry)
 			ovl_set_dir_cache(d_inode(dentry), NULL);
 
 		ovl_cache_free(&cache->entries);
-		kfree(cache);
+		kmem_cache_free(ovl_dir_cache_cachep, cache);
 	}
 }
 
@@ -414,7 +398,7 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	}
 	ovl_set_dir_cache(d_inode(dentry), NULL);
 
-	cache = kzalloc(sizeof(struct ovl_dir_cache), GFP_KERNEL);
+	cache = kmem_cache_zalloc(ovl_dir_cache_cachep, GFP_KERNEL);
 	if (!cache)
 		return ERR_PTR(-ENOMEM);
 
@@ -425,7 +409,7 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	res = ovl_dir_read_merged(dentry, &cache->entries, &cache->root);
 	if (res) {
 		ovl_cache_free(&cache->entries);
-		kfree(cache);
+		kmem_cache_free(ovl_dir_cache_cachep, cache);
 		return ERR_PTR(res);
 	}
 
@@ -582,21 +566,21 @@ static struct ovl_dir_cache *ovl_cache_get_impure(struct path *path)
 	ovl_dir_cache_free(d_inode(dentry));
 	ovl_set_dir_cache(d_inode(dentry), NULL);
 
-	cache = kzalloc(sizeof(struct ovl_dir_cache), GFP_KERNEL);
+	cache = kmem_cache_zalloc(ovl_dir_cache_cachep, GFP_KERNEL);
 	if (!cache)
 		return ERR_PTR(-ENOMEM);
 
 	res = ovl_dir_read_impure(path, &cache->entries, &cache->root);
 	if (res) {
 		ovl_cache_free(&cache->entries);
-		kfree(cache);
+		kmem_cache_free(ovl_dir_cache_cachep, cache);
 		return ERR_PTR(res);
 	}
 	if (list_empty(&cache->entries)) {
 		/* Good oportunity to get rid of an unnecessary "impure" flag */
 		ovl_do_removexattr(ovl_dentry_upper(dentry), OVL_XATTR_IMPURE);
 		ovl_clear_flag(OVL_IMPURE, d_inode(dentry));
-		kfree(cache);
+		kmem_cache_free(ovl_dir_cache_cachep, cache);
 		return NULL;
 	}
 
@@ -814,7 +798,7 @@ static int ovl_dir_release(struct inode *inode, struct file *file)
 	fput(od->realfile);
 	if (od->upperfile)
 		fput(od->upperfile);
-	kfree(od);
+	kmem_cache_free(ovl_dir_file_cachep, od);
 
 	return 0;
 }
@@ -826,14 +810,14 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 	struct ovl_dir_file *od;
 	enum ovl_path_type type;
 
-	od = kzalloc(sizeof(struct ovl_dir_file), GFP_KERNEL);
+	od = kmem_cache_zalloc(ovl_dir_file_cachep, GFP_KERNEL);
 	if (!od)
 		return -ENOMEM;
 
 	type = ovl_path_real(file->f_path.dentry, &realpath);
 	realfile = ovl_path_open(&realpath, file->f_flags);
 	if (IS_ERR(realfile)) {
-		kfree(od);
+		kmem_cache_free(ovl_dir_file_cachep, od);
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 76440fe..0128b64 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -180,6 +180,8 @@ static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
 };
 
 static struct kmem_cache *ovl_inode_cachep;
+struct kmem_cache *ovl_dir_file_cachep;
+struct kmem_cache *ovl_dir_cache_cachep;
 
 static struct inode *ovl_alloc_inode(struct super_block *sb)
 {
@@ -1332,17 +1334,41 @@ static int __init ovl_init(void)
 {
 	int err;
 
+	err = -ENOMEM;
 	ovl_inode_cachep = kmem_cache_create("ovl_inode",
 					     sizeof(struct ovl_inode), 0,
 					     (SLAB_RECLAIM_ACCOUNT|
 					      SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     ovl_inode_init_once);
-	if (ovl_inode_cachep == NULL)
-		return -ENOMEM;
+	if (!ovl_inode_cachep)
+		return err;
+
+	ovl_dir_file_cachep = kmem_cache_create("ovl_dir_file",
+						sizeof(struct ovl_dir_file), 0,
+						(SLAB_RECLAIM_ACCOUNT|
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
+						NULL);
+	if (!ovl_dir_file_cachep)
+		goto bad_ovl_dir_file_cachep;
+
+	ovl_dir_cache_cachep = kmem_cache_create("ovl_dir_cache",
+						sizeof(struct ovl_dir_cache), 0,
+						(SLAB_RECLAIM_ACCOUNT|
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
+						NULL);
+
+	if (!ovl_dir_cache_cachep)
+		goto bad_ovl_dir_cache_cachep;
 
 	err = register_filesystem(&ovl_fs_type);
-	if (err)
-		kmem_cache_destroy(ovl_inode_cachep);
+	if (!err)
+		return err;
+
+	kmem_cache_destroy(ovl_dir_cache_cachep);
+bad_ovl_dir_cache_cachep:
+	kmem_cache_destroy(ovl_dir_file_cachep);
+bad_ovl_dir_file_cachep:
+	kmem_cache_destroy(ovl_inode_cachep);
 
 	return err;
 }
@@ -1356,6 +1382,8 @@ static void __exit ovl_exit(void)
 	 * destroy cache.
 	 */
 	rcu_barrier();
+	kmem_cache_destroy(ovl_dir_cache_cachep);
+	kmem_cache_destroy(ovl_dir_file_cachep);
 	kmem_cache_destroy(ovl_inode_cachep);
 
 }
-- 
1.8.3.1

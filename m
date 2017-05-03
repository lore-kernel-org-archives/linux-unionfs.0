From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH] ovl: fix visible whiteout on not merged dir
Date: Wed, 3 May 2017 15:39:15 +0800
Message-ID: <1493797155-43637-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:5821 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbdECHgq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2017 03:36:46 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: yi.zhang@huawei.com, linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, miaoxie@huawei.com, zhaohongjiang@huawei.com, amir73il@gmail.com

When we mount overlayfs which have whiteout on the directory that
are not merged(single lower or upper layer only), the whiteout will
be visible on the merge layer, because of readdir on this directory
is simply handled by the underlying directory.

Reproducer:

mkdir -p low/dir up work merge
mknod low/dir/test c 0 0

mount -t overlay -o lowerdir=low,upperdir=up,workdir=work overlayfs merge

ls -l merge/dir

The out put will be:

  ls: cannot access merge/dir/test: No such file or directory
  total 0
  c????????? ? ? ? ?            ? test

It is same that have whiteout on the not merged upper directory or 
the opaque directory.

This patch fix this by add a flag and check whiteout, if the directory
don't have whiteout, it handled by theunderlying directory later,
otherwise the same to merged directories.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/readdir.c   | 21 ++++++++++++++++++---
 fs/overlayfs/util.c      | 15 +++++++++++++++
 4 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 741dc0b..2ffb7ec 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -161,6 +161,8 @@ static inline struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
+void ovl_set_dir_pure(struct dentry *dentry, bool pure);
+bool ovl_dir_pure(struct dentry *dentry);
 struct ovl_dir_cache *ovl_dir_cache(struct dentry *dentry);
 void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache);
 bool ovl_dentry_is_opaque(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 59614fa..8c32d9d 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -41,6 +41,7 @@ struct ovl_entry {
 			const char *redirect;
 			bool opaque;
 			bool copying;
+			bool pure;
 		};
 		struct rcu_head rcu;
 	};
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index f241b4e..ca97e46 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -45,11 +45,13 @@ struct ovl_readdir_data {
 	int count;
 	int err;
 	bool d_type_supported;
+	bool have_whiteout;
 };
 
 struct ovl_dir_file {
 	bool is_real;
 	bool is_upper;
+	bool is_pure;
 	struct ovl_dir_cache *cache;
 	struct list_head *cursor;
 	struct file *realfile;
@@ -218,6 +220,8 @@ static int ovl_check_whiteouts(struct dentry *dir, struct ovl_readdir_data *rdd)
 			dentry = lookup_one_len(p->name, dir, p->len);
 			if (!IS_ERR(dentry)) {
 				p->is_whiteout = ovl_is_whiteout(dentry);
+				if (p->is_whiteout)
+					rdd->have_whiteout = true;
 				dput(dentry);
 			}
 		}
@@ -271,6 +275,9 @@ static void ovl_dir_reset(struct file *file)
 	WARN_ON(!od->is_real && !OVL_TYPE_MERGE(type));
 	if (od->is_real && OVL_TYPE_MERGE(type))
 		od->is_real = false;
+
+	if (od->is_real)
+		od->is_pure = ovl_dir_pure(dentry);
 }
 
 static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
@@ -283,6 +290,7 @@ static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
 		.list = list,
 		.root = RB_ROOT,
 		.is_lowest = false,
+		.have_whiteout = false,
 	};
 	int idx, next;
 
@@ -304,6 +312,10 @@ static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
 			list_del(&rdd.middle);
 		}
 	}
+
+	if (!OVL_TYPE_MERGE(ovl_path_type(dentry)))
+		ovl_set_dir_pure(dentry, !rdd.have_whiteout);
+
 	return err;
 }
 
@@ -362,7 +374,7 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 	if (!ctx->pos)
 		ovl_dir_reset(file);
 
-	if (od->is_real)
+	if (od->is_real && likely(od->is_pure))
 		return iterate_dir(od->realfile, ctx);
 
 	if (!od->cache) {
@@ -396,7 +408,7 @@ static loff_t ovl_dir_llseek(struct file *file, loff_t offset, int origin)
 	if (!file->f_pos)
 		ovl_dir_reset(file);
 
-	if (od->is_real) {
+	if (od->is_real && likely(od->is_pure)) {
 		res = vfs_llseek(od->realfile, offset, origin);
 		file->f_pos = od->realfile->f_pos;
 	} else {
@@ -490,12 +502,14 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 	struct file *realfile;
 	struct ovl_dir_file *od;
 	enum ovl_path_type type;
+	struct dentry *dentry;
 
 	od = kzalloc(sizeof(struct ovl_dir_file), GFP_KERNEL);
 	if (!od)
 		return -ENOMEM;
 
-	type = ovl_path_real(file->f_path.dentry, &realpath);
+	dentry = file->f_path.dentry;
+	type = ovl_path_real(dentry, &realpath);
 	realfile = ovl_path_open(&realpath, file->f_flags);
 	if (IS_ERR(realfile)) {
 		kfree(od);
@@ -504,6 +518,7 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 	od->realfile = realfile;
 	od->is_real = !OVL_TYPE_MERGE(type);
 	od->is_upper = OVL_TYPE_UPPER(type);
+	od->is_pure = ovl_dir_pure(dentry);
 	file->private_data = od;
 
 	return 0;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 6e610a2..1638913 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -146,6 +146,21 @@ struct dentry *ovl_dentry_real(struct dentry *dentry)
 	return realdentry;
 }
 
+void ovl_set_dir_pure(struct dentry *dentry, bool pure)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	if (d_is_dir(dentry))
+		oe->pure = pure;
+}
+
+bool ovl_dir_pure(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	return oe->pure;
+}
+
 struct ovl_dir_cache *ovl_dir_cache(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
-- 
1.8.3.1

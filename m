From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 15/23] ovl: index directories on copy up with 'verify=on'
Date: Thu,  4 Jan 2018 18:40:10 +0200
Message-ID: <1515084018-25134-16-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:46203 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753310AbeADQjq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:46 -0500
Received: by mail-wr0-f193.google.com with SMTP id g17so2008267wrd.13
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:45 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

With the 'verify' feature enabled, all dirs are indexed on copy up.
Non-dir files are copied up directly to indexdir and then hardlinked
to upper dir.

Directories are copied up to indexdir, then an index entry is created
in indexdir with origin xattr pointing to the copied up dir and then
the copied up dir is moved to upper dir.

This is going to be used for NFS export.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 123 +++++++++++++++++++++++++++++++++++++++++------
 fs/overlayfs/namei.c     |   2 +-
 fs/overlayfs/overlayfs.h |   6 +--
 fs/overlayfs/util.c      |   4 +-
 4 files changed, 115 insertions(+), 20 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 27856663c8c7..275a08ab0dd3 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -232,13 +232,13 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
-struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper)
+struct ovl_fh *ovl_encode_fh(struct dentry *origin, bool is_upper)
 {
 	struct ovl_fh *fh;
 	int fh_type, fh_len, dwords;
 	void *buf;
 	int buflen = MAX_HANDLE_SZ;
-	uuid_t *uuid = &lower->d_sb->s_uuid;
+	uuid_t *uuid = &origin->d_sb->s_uuid;
 
 	buf = kmalloc(buflen, GFP_KERNEL);
 	if (!buf)
@@ -250,7 +250,7 @@ struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper)
 	 * the price or reconnecting the dentry.
 	 */
 	dwords = buflen >> 2;
-	fh_type = exportfs_encode_fh(lower, buf, &dwords, 0);
+	fh_type = exportfs_encode_fh(origin, buf, &dwords, 0);
 	buflen = (dwords << 2);
 
 	fh = ERR_PTR(-EIO);
@@ -288,8 +288,8 @@ struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper)
 	return fh;
 }
 
-int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
-		   struct dentry *upper)
+int ovl_set_origin(struct dentry *dentry, struct dentry *origin,
+		   struct dentry *upper, bool is_upper)
 {
 	const struct ovl_fh *fh = NULL;
 	int err;
@@ -299,8 +299,8 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 	 * so we can use the overlay.origin xattr to distignuish between a copy
 	 * up and a pure upper inode.
 	 */
-	if (ovl_can_decode_fh(lower->d_sb)) {
-		fh = ovl_encode_fh(lower, false);
+	if (ovl_can_decode_fh(origin->d_sb)) {
+		fh = ovl_encode_fh(origin, is_upper);
 		if (IS_ERR(fh))
 			return PTR_ERR(fh);
 	}
@@ -315,6 +315,78 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 	return err;
 }
 
+/*
+ * Create and install index entry.
+ *
+ * Caller must hold i_mutex on indexdir.
+ */
+static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
+			    struct dentry *upper)
+{
+	struct dentry *indexdir = ovl_indexdir(dentry->d_sb);
+	struct inode *dir = d_inode(indexdir);
+	struct dentry *index = NULL;
+	struct dentry *temp = NULL;
+	struct qstr name = { };
+	int err;
+
+	/*
+	 * For now this is only used for creating index entry for directories,
+	 * because non-dir are copied up directly to index and then hardlinked
+	 * to upper dir.
+	 *
+	 * TODO: implement create index for non-dir, so we can call it when
+	 * encoding file handle for non-dir in case index does not exist.
+	 */
+	if (WARN_ON(!d_is_dir(dentry)))
+		return -EIO;
+
+	/* Directory not expected to be indexed before copy up */
+	if (WARN_ON(ovl_test_flag(OVL_INDEX, d_inode(dentry))))
+		return -EIO;
+
+	err = ovl_get_index_name(origin, &name);
+	if (err)
+		return err;
+
+	temp = ovl_lookup_temp(indexdir);
+	if (IS_ERR(temp))
+		goto temp_err;
+
+	err = ovl_do_mkdir(dir, temp, S_IFDIR, true);
+	if (err)
+		goto out;
+
+	err = ovl_set_origin(dentry, upper, temp, true);
+	if (err)
+		goto out_cleanup;
+
+	index = lookup_one_len(name.name, indexdir, name.len);
+	if (IS_ERR(index)) {
+		err = PTR_ERR(index);
+	} else {
+		err = ovl_do_rename(dir, temp, dir, index, 0);
+		dput(index);
+	}
+
+	if (err)
+		goto out_cleanup;
+
+out:
+	dput(temp);
+	kfree(name.name);
+	return err;
+
+temp_err:
+	err = PTR_ERR(temp);
+	temp = NULL;
+	goto out;
+
+out_cleanup:
+	ovl_cleanup(dir, temp);
+	goto out;
+}
+
 struct ovl_copy_up_ctx {
 	struct dentry *parent;
 	struct dentry *dentry;
@@ -327,6 +399,7 @@ struct ovl_copy_up_ctx {
 	struct dentry *workdir;
 	bool tmpfile;
 	bool origin;
+	bool indexed;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -474,7 +547,8 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	 * hard link.
 	 */
 	if (c->origin) {
-		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
+		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp,
+				     false);
 		if (err)
 			return err;
 	}
@@ -498,6 +572,12 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
 	if (err)
 		goto out_cleanup;
 
+	if (S_ISDIR(c->stat.mode) && c->indexed) {
+		err = ovl_create_index(c->dentry, c->lowerpath.dentry, temp);
+		if (err)
+			goto out_cleanup;
+	}
+
 	if (c->tmpfile) {
 		inode_lock_nested(udir, I_MUTEX_PARENT);
 		err = ovl_install_temp(c, temp, &newdentry);
@@ -536,12 +616,26 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 {
 	int err;
 	struct ovl_fs *ofs = c->dentry->d_sb->s_fs_info;
-	bool indexed = ovl_need_index(c->dentry);
+	bool to_index = false;
+
+	/*
+	 * Indexed non-dir is copied up directly to the index entry and then
+	 * hardlinked to upper dir. Indexed dir is copied up to indexdir,
+	 * then index entry is created and then copied up dir installed.
+	 * Copying dir up to indexdir instead of workdir simplifies locking.
+	 */
+	if (ovl_need_index(c->dentry)) {
+		c->indexed = true;
+		if (S_ISDIR(c->stat.mode))
+			c->workdir = ovl_indexdir(c->dentry->d_sb);
+		else
+			to_index = true;
+	}
 
-	if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || indexed)
+	if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || to_index)
 		c->origin = true;
 
-	if (indexed) {
+	if (to_index) {
 		c->destdir = ovl_indexdir(c->dentry->d_sb);
 		err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
 		if (err)
@@ -568,9 +662,10 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		}
 	}
 
-	if (indexed) {
-		if (!err)
-			ovl_set_flag(OVL_INDEX, d_inode(c->dentry));
+	if (!err && c->indexed)
+		ovl_set_flag(OVL_INDEX, d_inode(c->dentry));
+
+	if (to_index) {
 		kfree(c->destname.name);
 	} else if (!err) {
 		struct inode *udir = d_inode(c->destdir);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 4987d7df1581..7cab6071c916 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -719,7 +719,7 @@ static int ovl_fix_origin(struct dentry *dentry, struct dentry *lower,
 	if (err)
 		return err;
 
-	err = ovl_set_origin(dentry, lower, upper);
+	err = ovl_set_origin(dentry, lower, upper, false);
 	if (!err)
 		err = ovl_set_impure(dentry->d_parent, upper->d_parent);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 86767b71e485..759cb3a465b4 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -326,6 +326,6 @@ int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
-struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper);
-int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
-		   struct dentry *upper);
+struct ovl_fh *ovl_encode_fh(struct dentry *origin, bool is_upper);
+int ovl_set_origin(struct dentry *dentry, struct dentry *origin,
+		   struct dentry *upper, bool is_upper);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f40351dcea7b..35a49a1fe3e7 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -491,8 +491,8 @@ bool ovl_need_index(struct dentry *dentry)
 	if (!lower || !ovl_indexdir(dentry->d_sb))
 		return false;
 
-	/* Index all files for unique origin verification */
-	if (!d_is_dir(lower) && ovl_verify(dentry->d_sb))
+	/* Index all files and dirs for unique origin verification */
+	if (ovl_verify(dentry->d_sb))
 		return true;
 
 	/* Index only lower hardlinks on copy up */
-- 
2.7.4

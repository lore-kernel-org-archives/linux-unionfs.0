From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 07/11] ovl: index directories on copy up
Date: Tue, 17 Oct 2017 19:00:18 +0300
Message-ID: <1508256022-10267-8-git-send-email-amir73il@gmail.com>
References: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:53893 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936666AbdJQP76 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:59:58 -0400
Received: by mail-wm0-f66.google.com with SMTP id q132so4922401wmd.2
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:59:57 -0700 (PDT)
In-Reply-To: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

With mount option index=all, all files are indexed on copy up.
Non-dir files are copied up directly to indexdir and then hardlinked
to upper dir.

Directories are copied up to workdir, then an index entry is created
in indexdir with origin xattr pointing to the copied up dir and then
the copied up dir is moved to upper dir.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 128 ++++++++++++++++++++++++++++++++++++++++++++-----
 fs/overlayfs/util.c    |   2 +-
 2 files changed, 118 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 6729ea2a5a1c..df1ce2d5a20e 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -289,8 +289,8 @@ struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper)
 	return fh;
 }
 
-static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
-			  struct dentry *upper)
+static int ovl_set_origin(struct dentry *dentry, struct dentry *origin,
+			  struct dentry *upper, bool is_upper)
 {
 	const struct ovl_fh *fh = NULL;
 	int err;
@@ -300,8 +300,8 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
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
@@ -316,6 +316,95 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 	return err;
 }
 
+/*
+ * Create and install index entry.
+ *
+ * With mount option index=all, this function is called for every dir copy up.
+ * Otherwise, it should be called before exporting an overlay file handle.
+ *
+ * Caller must hold 'lock_rename' on workdir+upperdir.
+ */
+static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
+			    struct dentry *upper)
+{
+	struct dentry *workdir = ovl_workdir(dentry);
+	struct dentry *indexdir = ovl_indexdir(dentry->d_sb);
+	struct inode *wdir = d_inode(workdir);
+	struct inode *idir = d_inode(indexdir);
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
+	temp = ovl_lookup_temp(workdir);
+	if (IS_ERR(temp))
+		goto temp_err;
+
+	err = ovl_do_mkdir(wdir, temp, S_IFDIR, true);
+	if (err)
+		goto out;
+
+	err = ovl_set_origin(dentry, upper, temp, true);
+	if (err)
+		goto out_cleanup;
+
+	/*
+	 * vfs_rename_mutex is held and so are workdir and upperdir inode mutex.
+	 * Because workdir and upperdir are sibling directories,
+	 * lock_rename(workdir, upperdir) used lockedp classes I_MUTEX_PARENT
+	 * and I_MUTEX_PARENT2, so it is safe to 'promote' the rename lock
+	 * to workdir+upperdir+indexdir (yet another sibling) using lockdep
+	 * class I_MUTEX_CHILD without releasing workdir+upperdir rename lock.
+	 */
+	inode_lock_nested(idir, I_MUTEX_CHILD);
+
+	index = lookup_one_len(name.name, indexdir, name.len);
+	if (IS_ERR(index)) {
+		err = PTR_ERR(index);
+	} else {
+		err = ovl_do_rename(wdir, temp, idir, index, 0);
+		dput(index);
+	}
+
+	inode_unlock(idir);
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
+	ovl_cleanup(wdir, temp);
+	goto out;
+}
+
 struct ovl_copy_up_ctx {
 	struct dentry *parent;
 	struct dentry *dentry;
@@ -328,6 +417,7 @@ struct ovl_copy_up_ctx {
 	struct dentry *workdir;
 	bool tmpfile;
 	bool origin;
+	bool indexed;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -475,7 +565,8 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	 * hard link.
 	 */
 	if (c->origin) {
-		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
+		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp,
+				     false);
 		if (err)
 			return err;
 	}
@@ -498,6 +589,12 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
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
@@ -532,12 +629,20 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 {
 	int err;
 	struct ovl_fs *ofs = c->dentry->d_sb->s_fs_info;
-	bool indexed = ovl_need_index(c->dentry);
+	bool to_index;
+
+	/*
+	 * Indexed non-dir is copied up directly to indexdir and then
+	 * hardlinked to upper dir. Indexed dir is copied up to workdir,
+	 * then index created in indexdir and then copied up dir installed.
+	 */
+	c->indexed = ovl_need_index(c->dentry);
+	to_index = c->indexed && !S_ISDIR(c->stat.mode);
 
-	if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || indexed)
+	if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || to_index)
 		c->origin = true;
 
-	if (indexed) {
+	if (to_index) {
 		c->destdir = ovl_indexdir(c->dentry->d_sb);
 		err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
 		if (err)
@@ -564,9 +669,10 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
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
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index fb501eb5e75c..3cd16bc20fcd 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -516,7 +516,7 @@ bool ovl_need_index(struct dentry *dentry)
 	if (!lower || !ofs->indexdir)
 		return false;
 
-	if (!d_is_dir(lower) && ofs->config.index == OVL_INDEX_ALL)
+	if (ofs->config.index == OVL_INDEX_ALL)
 		return true;
 
 	/* Index only lower hardlinks on copy up */
-- 
2.7.4

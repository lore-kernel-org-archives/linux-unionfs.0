From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 11/14] ovl: decode non-pure-upper non-connectable file handles
Date: Tue, 17 Oct 2017 19:44:28 +0300
Message-ID: <1508258671-10800-12-git-send-email-amir73il@gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

When decoding an overlay inode that was encoded by real lower file
handle, we first decode the lower file handle, then we check if that
lower inode has been copied up and indexed.

If index is not found, we try to obtain a non-upper overlay dentry.
If index is found, we get the upper inode from index and try to obtain
an upper overlay dentry with lower origin.
If a whiteout index is found, overlay file handle is treated as stale.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    | 83 ++++++++++++++++++++++++++++++++++++++++--------
 fs/overlayfs/namei.c     | 21 ++++++++----
 fs/overlayfs/overlayfs.h |  6 +++-
 3 files changed, 88 insertions(+), 22 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 476e2a74aca7..f97f68e92eba 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -241,25 +241,14 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 
 }
 
-static struct dentry *ovl_fh_to_d(struct super_block *sb, struct fid *fid,
-				  int fh_len, int fh_type, bool to_parent)
+static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
+					struct ovl_fh *fh, bool to_parent)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
 	struct vfsmount *mnt = ofs->upper_mnt;
 	struct dentry *upper;
-	struct ovl_fh *fh = (struct ovl_fh *) fid;
-	int err;
-
-	/* TODO: handle file handle with parent from different layer */
-	if (fh_type != OVL_FILEID_WITHOUT_PARENT)
-		return ERR_PTR(-EINVAL);
-
-	err = ovl_check_fh_len(fh, fh_len << 2);
-	if (err)
-		return ERR_PTR(err);
 
-	/* TODO: handle decoding of non pure upper */
-	if (!mnt || !(fh->flags & OVL_FH_FLAG_PATH_UPPER))
+	if (!mnt)
 		return NULL;
 
 	upper = ovl_decode_fh(fh, mnt);
@@ -288,6 +277,72 @@ static struct dentry *ovl_fh_to_d(struct super_block *sb, struct fid *fid,
 	return ovl_obtain_alias(sb, upper, NULL);
 }
 
+static struct dentry *ovl_fh_to_d(struct super_block *sb, struct fid *fid,
+				  int fh_len, int fh_type, bool to_parent)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct dentry *upper = NULL;
+	struct dentry *index = NULL;
+	struct dentry *origin = NULL;
+	struct dentry *dentry = NULL;
+	struct ovl_fh *fh = (struct ovl_fh *) fid;
+	int err, i;
+
+	/* TODO: handle file handle with parent from different layer */
+	if (fh_type != OVL_FILEID_WITHOUT_PARENT)
+		return ERR_PTR(-EINVAL);
+
+	err = ovl_check_fh_len(fh, fh_len << 2);
+	if (err)
+		return ERR_PTR(err);
+
+	if (fh->flags & OVL_FH_FLAG_PATH_UPPER)
+		return ovl_upper_fh_to_d(sb, fh, to_parent);
+
+	/* TODO: decode parent from fh_type OVL_FILEID_WITH_PARENT */
+	if (to_parent)
+		return ERR_PTR(-EINVAL);
+
+	/* Find lower layer by UUID and decode */
+	for (i = 0; i < ofs->numlower; i++) {
+		origin = ovl_decode_fh(fh, ofs->lower_mnt[i]);
+		if (origin)
+			break;
+	}
+
+	if (IS_ERR_OR_NULL(origin))
+		return origin;
+
+	/* Lookup index by decoded origin */
+	index = ovl_lookup_index(ofs->indexdir, NULL, origin);
+	if (IS_ERR(index)) {
+		dput(origin);
+		return index;
+	}
+	if (index) {
+		/* Get upper dentry from index */
+		upper = ovl_index_upper(index, ofs->upper_mnt);
+		err = PTR_ERR(upper);
+		if (IS_ERR(upper))
+			goto out_err;
+
+		err = ovl_verify_origin(upper, origin, false, false);
+		if (err)
+			goto out_err;
+	}
+
+	dentry = ovl_obtain_alias(sb, upper, origin);
+
+out:
+	dput(index);
+	dput(origin);
+	return dentry;
+
+out_err:
+	dentry = ERR_PTR(err);
+	goto out;
+}
+
 static struct dentry *ovl_fh_to_dentry(struct super_block *sb, struct fid *fid,
 				       int fh_len, int fh_type)
 {
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 796c869559a9..0f19c2cf43fc 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -609,11 +609,9 @@ int ovl_get_index_name(struct dentry *origin, struct qstr *name)
 
 }
 
-static struct dentry *ovl_lookup_index(struct dentry *dentry,
-				       struct dentry *upper,
-				       struct dentry *origin)
+struct dentry *ovl_lookup_index(struct dentry *indexdir, struct dentry *upper,
+				struct dentry *origin)
 {
-	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct dentry *index;
 	struct inode *inode;
 	struct qstr name;
@@ -624,7 +622,7 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 	if (err)
 		return ERR_PTR(err);
 
-	index = lookup_one_len_unlocked(name.name, ofs->indexdir, name.len);
+	index = lookup_one_len_unlocked(name.name, indexdir, name.len);
 	if (IS_ERR(index)) {
 		err = PTR_ERR(index);
 		if (err == -ENOENT) {
@@ -645,6 +643,15 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 					    upper);
 		}
 		goto out_dput;
+	} else if (ovl_is_whiteout(index) && !upper) {
+		/*
+		 * When index lookup is called with no upper for decoding an
+		 * overlay file handle, a whiteout index implies that decode
+		 * should treat file handle as stale.
+		 */
+		dput(index);
+		index = ERR_PTR(-ESTALE);
+		goto out;
 	} else if (ovl_dentry_weird(index) || ovl_is_whiteout(index) ||
 		   ((inode->i_mode ^ d_inode(origin)->i_mode) & S_IFMT)) {
 		/*
@@ -870,8 +877,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	 * TODO: update origin and index in case lower dir has changed and
 	 *       store new generation number xattr in index for NFS export.
 	 */
-	if (ctr && ovl_indexdir(dentry->d_sb) && origin) {
-		index = ovl_lookup_index(dentry, upperdentry, origin);
+	if (ctr && ofs->indexdir && origin) {
+		index = ovl_lookup_index(ofs->indexdir, upperdentry, origin);
 		if (IS_ERR(index)) {
 			err = PTR_ERR(index);
 			index = NULL;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index ffc5a955478e..3a801511d163 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -279,11 +279,15 @@ int ovl_check_origin(struct dentry *upperdentry, struct path *lowerstack,
 		     unsigned int *ctrp);
 int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 		      bool is_upper, bool set);
+struct dentry *ovl_index_upper(struct dentry *index, struct vfsmount *mnt);
 int ovl_verify_index(struct dentry *index, struct vfsmount *mnt,
 		     struct path *lowerstack, unsigned int numlower);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
+struct dentry *ovl_lookup_index(struct dentry *indexdir, struct dentry *upper,
+				struct dentry *origin);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
-struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
+struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
+			  unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
 
 /* readdir.c */
-- 
2.7.4

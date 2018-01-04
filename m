From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 15/17] ovl: lookup indexed ancestor of lower dir
Date: Thu,  4 Jan 2018 19:20:47 +0200
Message-ID: <1515086449-26563-16-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

ovl_lookup_real(is_upper=false) walks back lower parents to find the
topmost indexed parent. If an indexed ancestor is found before reaching
lower layer root, ovl_lookup_real(is_upper=true) is called recursively
to walk back from indexed upper to the topmost connected/hashed upper
parent (or up to root).

ovl_lookup_real(is_upper=true) then walks forward to connect the topmost
upper overlay dir dentry and ovl_lookup_real(is_upper=false) continues to
walk forward to connect the decoded lower overlay dir dentry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    | 39 ++++++++++++++++++++++++++++++++++++++-
 fs/overlayfs/namei.c     | 20 ++++++++++++++------
 fs/overlayfs/overlayfs.h |  2 ++
 3 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 01c4e3f733c1..147d9061cc40 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -257,15 +257,24 @@ static struct dentry *ovl_lookup_real_one(struct dentry *parent,
 	return ERR_PTR(err);
 }
 
+static struct dentry *ovl_lookup_real(struct super_block *sb,
+				      struct dentry *real, bool is_upper);
+
 /*
  * Lookup an indexed or hashed overlay dentry by real inode.
  */
 static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
 					    struct dentry *real, bool is_upper)
 {
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct dentry *index = NULL;
 	struct dentry *this = NULL;
 	struct inode *inode;
 
+	/*
+	 * Decoding upper dir from index is expensive, so first try to lookup
+	 * overlay dentry in inode/dcache.
+	 */
 	inode = ovl_lookup_inode(sb, real, is_upper);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
@@ -274,7 +283,35 @@ static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
 		iput(inode);
 	}
 
-	/* TODO: use index when looking up by origin inode */
+	/*
+	 * For decoded lower dir file handle, lookup index by origin to check
+	 * if lower dir was copied up and and/or removed.
+	 */
+	if (!this && !is_upper && !WARN_ON(!d_is_dir(real))) {
+		index = ovl_lookup_index(ofs, NULL, real, false);
+		if (IS_ERR(index))
+			return index;
+	}
+
+	/* Get connected upper overlay dir from index */
+	if (index) {
+		struct dentry *upper = ovl_index_upper(ofs, index);
+
+		dput(index);
+		if (IS_ERR_OR_NULL(upper))
+			return upper;
+
+		/*
+		 * ovl_lookup_real(is_upper=false) may call recursively once to
+		 * ovl_lookup_real(is_upper=true). The first level call walks
+		 * back lower parents to the topmost indexed parent. The second
+		 * recursive call walks back from indexed upper to the topmost
+		 * connected/hashed upper parent (or up to root).
+		 */
+		this = ovl_lookup_real(sb, upper, true);
+		dput(upper);
+	}
+
 	if (!this)
 		return NULL;
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 13869108dc32..f728942a5a1f 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -665,11 +665,9 @@ struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh)
 	return ERR_PTR(err);
 }
 
-static struct dentry *ovl_lookup_index(struct dentry *dentry,
-				       struct dentry *upper,
-				       struct dentry *origin)
+struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
+				struct dentry *origin, bool verify)
 {
-	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct dentry *index;
 	struct inode *inode;
 	struct qstr name;
@@ -697,6 +695,16 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 	inode = d_inode(index);
 	if (d_is_negative(index)) {
 		goto out_dput;
+	} else if (ovl_is_whiteout(index) && !verify) {
+		/*
+		 * When index lookup is called with !verify for decoding an
+		 * overlay file handle, a whiteout index implies that decode
+		 * should treat file handle as stale and no need to print a
+		 * warning about it.
+		 */
+		dput(index);
+		index = ERR_PTR(-ESTALE);
+		goto out;
 	} else if (ovl_dentry_weird(index) || ovl_is_whiteout(index) ||
 		   ((inode->i_mode ^ d_inode(origin)->i_mode) & S_IFMT)) {
 		/*
@@ -710,7 +718,7 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 				    index, d_inode(index)->i_mode & S_IFMT,
 				    d_inode(origin)->i_mode & S_IFMT);
 		goto fail;
-	} else if (is_dir) {
+	} else if (is_dir && verify) {
 		if (!upper) {
 			pr_warn_ratelimited("overlayfs: suspected uncovered redirected dir found (origin=%pd2, index=%pd2).\n",
 					    origin, index);
@@ -948,7 +956,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (origin && ovl_indexdir(dentry->d_sb) &&
 	    (!d.is_dir || ovl_verify(dentry->d_sb))) {
-		index = ovl_lookup_index(dentry, upperdentry, origin);
+		index = ovl_lookup_index(ofs, upperdentry, origin, true);
 		if (IS_ERR(index)) {
 			err = PTR_ERR(index);
 			index = NULL;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d06299b27ec3..661f33bd9793 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -269,6 +269,8 @@ struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index);
 int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
 struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
+struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
+				struct dentry *origin, bool verify);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags);
-- 
2.7.4

Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/7] ovl: simplify i_ino initialization
Date: Wed,  1 Jan 2020 19:58:11 +0200
Message-Id: <20200101175814.14144-5-amir73il@gmail.com>
In-Reply-To: <20200101175814.14144-1-amir73il@gmail.com>
References: <20200101175814.14144-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Move i_ino initialization to ovl_inode_init() to avoid the dance
of setting i_ino in ovl_fill_inode() sometimes on the first call
and sometimes on the seconds call.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 35 ++++++++++++++++++++++++++---------
 fs/overlayfs/overlayfs.h |  4 ++--
 fs/overlayfs/super.c     | 13 +++++++++++--
 fs/overlayfs/util.c      | 18 ------------------
 4 files changed, 39 insertions(+), 31 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 9ed94c70e3cb..04e8e8de2012 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -561,8 +561,7 @@ static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
 #endif
 }
 
-static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev,
-			   unsigned long ino, int fsid)
+static void ovl_map_ino(struct inode *inode, unsigned long ino, int fsid)
 {
 	int xinobits = ovl_xino_bits(inode->i_sb);
 
@@ -572,10 +571,6 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev,
 	 * so inode number exposed via /proc/locks and a like will be
 	 * consistent with d_ino and st_ino values. An i_ino value inconsistent
 	 * with d_ino also causes nfsd readdirplus to fail.
-	 *
-	 * When called from ovl_create_object() => ovl_new_inode(), with
-	 * ino = 0, i_ino will be updated to consistent value later on in
-	 * ovl_get_inode() => ovl_fill_inode().
 	 */
 	if (ovl_same_dev(inode->i_sb)) {
 		inode->i_ino = ino;
@@ -584,6 +579,28 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev,
 	} else {
 		inode->i_ino = get_next_ino();
 	}
+}
+
+void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
+		    unsigned long ino, int fsid)
+{
+	struct inode *realinode;
+
+	if (oip->upperdentry)
+		OVL_I(inode)->__upperdentry = oip->upperdentry;
+	if (oip->lowerpath && oip->lowerpath->dentry)
+		OVL_I(inode)->lower = igrab(d_inode(oip->lowerpath->dentry));
+	if (oip->lowerdata)
+		OVL_I(inode)->lowerdata = igrab(d_inode(oip->lowerdata));
+
+	realinode = ovl_inode_real(inode);
+	ovl_copyattr(realinode, inode);
+	ovl_copyflags(realinode, inode);
+	ovl_map_ino(inode, ino, fsid);
+}
+
+static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
+{
 	inode->i_mode = mode;
 	inode->i_flags |= S_NOCMTIME;
 #ifdef CONFIG_FS_POSIX_ACL
@@ -721,7 +738,7 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
 
 	inode = new_inode(sb);
 	if (inode)
-		ovl_fill_inode(inode, mode, rdev, 0, 0);
+		ovl_fill_inode(inode, mode, rdev);
 
 	return inode;
 }
@@ -946,8 +963,8 @@ struct inode *ovl_get_inode(struct super_block *sb,
 		ino = realinode->i_ino;
 		fsid = lowerpath->layer->fsid;
 	}
-	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
-	ovl_inode_init(inode, upperdentry, lowerdentry, oip->lowerdata);
+	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
+	ovl_inode_init(inode, oip, ino, fsid);
 
 	if (upperdentry && ovl_is_impuredir(upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f7d01c06cdaf..140510d24d9f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -269,8 +269,6 @@ void ovl_set_upperdata(struct inode *inode);
 bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
-void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
-		    struct dentry *lowerdentry, struct dentry *lowerdata);
 void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
 void ovl_dir_modified(struct dentry *dentry, bool impurity);
 u64 ovl_dentry_version_get(struct dentry *dentry);
@@ -412,6 +410,8 @@ struct ovl_inode_params {
 	char *redirect;
 	struct dentry *lowerdata;
 };
+void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
+		    unsigned long ino, int fsid);
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 18db065d73b3..d072f982d3de 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1586,6 +1586,13 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 				   struct ovl_entry *oe)
 {
 	struct dentry *root;
+	struct ovl_path *lowerpath = &oe->lowerstack[0];
+	unsigned long ino = d_inode(lowerpath->dentry)->i_ino;
+	int fsid = lowerpath->layer->fsid;
+	struct ovl_inode_params oip = {
+		.upperdentry = upperdentry,
+		.lowerpath = lowerpath,
+	};
 
 	root = d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
 	if (!root)
@@ -1594,6 +1601,9 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	root->d_fsdata = oe;
 
 	if (upperdentry) {
+		/* Root inode uses upper st_ino/i_ino */
+		ino = d_inode(upperdentry)->i_ino;
+		fsid = 0;
 		ovl_dentry_set_upper_alias(root);
 		if (ovl_is_impuredir(upperdentry))
 			ovl_set_flag(OVL_IMPURE, d_inode(root));
@@ -1603,8 +1613,7 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	ovl_set_flag(OVL_WHITEOUTS, d_inode(root));
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
 	ovl_set_upperdata(d_inode(root));
-	ovl_inode_init(d_inode(root), upperdentry, ovl_dentry_lower(root),
-		       NULL);
+	ovl_inode_init(d_inode(root), &oip, ino, fsid);
 
 	return root;
 }
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index b28ccede1da9..d6e3f8f42647 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -388,24 +388,6 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
 	oi->redirect = redirect;
 }
 
-void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
-		    struct dentry *lowerdentry, struct dentry *lowerdata)
-{
-	struct inode *realinode = d_inode(upperdentry ?: lowerdentry);
-
-	if (upperdentry)
-		OVL_I(inode)->__upperdentry = upperdentry;
-	if (lowerdentry)
-		OVL_I(inode)->lower = igrab(d_inode(lowerdentry));
-	if (lowerdata)
-		OVL_I(inode)->lowerdata = igrab(d_inode(lowerdata));
-
-	ovl_copyattr(realinode, inode);
-	ovl_copyflags(realinode, inode);
-	if (!inode->i_ino)
-		inode->i_ino = realinode->i_ino;
-}
-
 void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 {
 	struct inode *upperinode = d_inode(upperdentry);
-- 
2.17.1

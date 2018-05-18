Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 8/9] ovl: Pass argument to ovl_get_inode() in a structure
Date: Fri, 18 May 2018 11:29:36 +0300
Message-Id: <1526632177-28832-9-git-send-email-amir73il@gmail.com>
In-Reply-To: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Vivek Goyal <vgoyal@redhat.com>

ovl_get_inode() right now has 5 parameters. Soon this patch series will
add 2 more and suddenly argument list starts looking too long.

Hence pass arguments to ovl_get_inode() in a structure and it looks
little cleaner.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    |  8 +++++++-
 fs/overlayfs/inode.c     | 20 +++++++++++---------
 fs/overlayfs/namei.c     | 10 ++++++++--
 fs/overlayfs/overlayfs.h | 11 ++++++++---
 4 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 425a94672300..9941ece61a14 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -300,12 +300,18 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	struct dentry *dentry;
 	struct inode *inode;
 	struct ovl_entry *oe;
+	struct ovl_inode_params oip = {
+		.lowerpath = lowerpath,
+		.index = index,
+		.numlower = !!lower
+	};
 
 	/* We get overlay directory dentries with ovl_lookup_real() */
 	if (d_is_dir(upper ?: lower))
 		return ERR_PTR(-EIO);
 
-	inode = ovl_get_inode(sb, dget(upper), lowerpath, index, !!lower);
+	oip.upperdentry = dget(upper);
+	inode = ovl_get_inode(sb, &oip);
 	if (IS_ERR(inode)) {
 		dput(upper);
 		return ERR_CAST(inode);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7abcf96e94fc..3aa2ea447436 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -792,15 +792,17 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
 	return true;
 }
 
-struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
-			    struct ovl_path *lowerpath, struct dentry *index,
-			    unsigned int numlower)
+struct inode *ovl_get_inode(struct super_block *sb,
+			    struct ovl_inode_params *oip)
 {
+	struct dentry *upperdentry = oip->upperdentry;
+	struct ovl_path *lowerpath = oip->lowerpath;
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
 	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
-	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
-	int fsid = bylower ? lowerpath->layer->fsid : 0;
+	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry,
+					oip->index);
+	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
 	bool is_dir;
 	unsigned long ino = 0;
 
@@ -817,8 +819,8 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 						      upperdentry);
 		unsigned int nlink = is_dir ? 1 : realinode->i_nlink;
 
-		inode = iget5_locked(sb, (unsigned long) key,
-				     ovl_inode_test, ovl_inode_set, key);
+		inode = iget5_locked(sb, (unsigned long) key, ovl_inode_test,
+				     ovl_inode_set, key);
 		if (!inode)
 			goto out_nomem;
 		if (!(inode->i_state & I_NEW)) {
@@ -854,12 +856,12 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	if (upperdentry && ovl_is_impuredir(upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
 
-	if (index)
+	if (oip->index)
 		ovl_set_flag(OVL_INDEX, inode);
 
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
-		if (((upperdentry && lowerdentry) || numlower > 1) ||
+		if (((upperdentry && lowerdentry) || oip->numlower > 1) ||
 		    ovl_check_origin_xattr(upperdentry ?: lowerdentry)) {
 			ovl_set_flag(OVL_WHITEOUTS, inode);
 		}
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 2dba29eadde6..08801b45df00 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1004,8 +1004,14 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		upperdentry = dget(index);
 
 	if (upperdentry || ctr) {
-		inode = ovl_get_inode(dentry->d_sb, upperdentry, stack, index,
-				      ctr);
+		struct ovl_inode_params oip = {
+			.upperdentry = upperdentry,
+			.lowerpath = stack,
+			.index = index,
+			.numlower = ctr,
+		};
+
+		inode = ovl_get_inode(dentry->d_sb, &oip);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 4eb04da240b4..dfb25b9b26a8 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -334,12 +334,17 @@ int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
+struct ovl_inode_params {
+	struct dentry *upperdentry;
+	struct ovl_path *lowerpath;
+	struct dentry *index;
+	unsigned int numlower;
+};
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper);
-struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
-			    struct ovl_path *lowerpath, struct dentry *index,
-			    unsigned int numlower);
+struct inode *ovl_get_inode(struct super_block *sb,
+			    struct ovl_inode_params *oip);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
-- 
2.7.4

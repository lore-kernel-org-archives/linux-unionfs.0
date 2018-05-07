Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 01/30] ovl: Pass argument to ovl_get_inode() in a structure
Date: Mon,  7 May 2018 13:40:33 -0400
Message-Id: <20180507174102.24086-2-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

ovl_get_inode() right now has 5 parameters. Soon this patch series will
add 2 more and suddenly argument list starts looking too long.

Hence pass arguments to ovl_get_inode() in a structure and it looks
little cleaner.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/export.c    |  4 +++-
 fs/overlayfs/inode.c     | 19 ++++++++++---------
 fs/overlayfs/namei.c     |  6 ++++--
 fs/overlayfs/overlayfs.h |  4 +---
 fs/overlayfs/ovl_entry.h |  8 ++++++++
 5 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 425a94672300..867946adcbc5 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -300,12 +300,14 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	struct dentry *dentry;
 	struct inode *inode;
 	struct ovl_entry *oe;
+	struct ovl_inode_params oip = {sb, NULL, lowerpath, index, !!lower};
 
 	/* We get overlay directory dentries with ovl_lookup_real() */
 	if (d_is_dir(upper ?: lower))
 		return ERR_PTR(-EIO);
 
-	inode = ovl_get_inode(sb, dget(upper), lowerpath, index, !!lower);
+	oip.upperdentry = dget(upper);
+	inode = ovl_get_inode(&oip);
 	if (IS_ERR(inode)) {
 		dput(upper);
 		return ERR_CAST(inode);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7abcf96e94fc..2fe9538fffc9 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -792,15 +792,16 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
 	return true;
 }
 
-struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
-			    struct ovl_path *lowerpath, struct dentry *index,
-			    unsigned int numlower)
+struct inode *ovl_get_inode(struct ovl_inode_params *oip)
 {
+	struct dentry *upperdentry = oip->upperdentry;
+	struct ovl_path *lowerpath = oip->lowerpath;
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
 	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
-	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
-	int fsid = bylower ? lowerpath->layer->fsid : 0;
+	bool bylower = ovl_hash_bylower(oip->sb, upperdentry, lowerdentry,
+					oip->index);
+	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
 	bool is_dir;
 	unsigned long ino = 0;
 
@@ -817,7 +818,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 						      upperdentry);
 		unsigned int nlink = is_dir ? 1 : realinode->i_nlink;
 
-		inode = iget5_locked(sb, (unsigned long) key,
+		inode = iget5_locked(oip->sb, (unsigned long) key,
 				     ovl_inode_test, ovl_inode_set, key);
 		if (!inode)
 			goto out_nomem;
@@ -844,7 +845,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 		ino = key->i_ino;
 	} else {
 		/* Lower hardlink that will be broken on copy up */
-		inode = new_inode(sb);
+		inode = new_inode(oip->sb);
 		if (!inode)
 			goto out_nomem;
 	}
@@ -854,12 +855,12 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
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
index 2dba29eadde6..1ab68454bfb6 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1004,8 +1004,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		upperdentry = dget(index);
 
 	if (upperdentry || ctr) {
-		inode = ovl_get_inode(dentry->d_sb, upperdentry, stack, index,
-				      ctr);
+		struct ovl_inode_params oip = {dentry->d_sb, upperdentry,
+					       stack, index, ctr};
+
+		inode = ovl_get_inode(&oip);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index caaa47cea2aa..4b6c90a0aa2c 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -345,9 +345,7 @@ bool ovl_is_private_xattr(const char *name);
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper);
-struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
-			    struct ovl_path *lowerpath, struct dentry *index,
-			    unsigned int numlower);
+struct inode *ovl_get_inode(struct ovl_inode_params *oip);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 3bea47c63fd9..11e9abe7e381 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -101,6 +101,14 @@ struct ovl_inode {
 	struct mutex lock;
 };
 
+struct ovl_inode_params {
+	struct super_block *sb;
+	struct dentry *upperdentry;
+	struct ovl_path *lowerpath;
+	struct dentry *index;
+	unsigned int numlower;
+};
+
 static inline struct ovl_inode *OVL_I(struct inode *inode)
 {
 	return container_of(inode, struct ovl_inode, vfs_inode);
-- 
2.13.6

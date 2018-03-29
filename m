Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v9 4/7] ovl: consistent i_ino for non-samefs with xino
Date: Thu, 29 Mar 2018 17:18:50 +0300
Message-Id: <1522333133-24772-5-git-send-email-amir73il@gmail.com>
In-Reply-To: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

When overlay layers are not all on the same fs, but all inode numbers
of underlying fs do not use the high 'xino' bits, overlay st_ino values
are constant and persistent.

In that case, set i_ino value to the same value as st_ino for nfsd
readdirplus validator.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    |  2 +-
 fs/overlayfs/inode.c     | 27 ++++++++++++++++++---------
 fs/overlayfs/namei.c     |  4 +---
 fs/overlayfs/overlayfs.h |  2 +-
 4 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 87bd4148f4fb..e53c1f58aef1 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -305,7 +305,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	if (d_is_dir(upper ?: lower))
 		return ERR_PTR(-EIO);
 
-	inode = ovl_get_inode(sb, dget(upper), lower, index, !!lower);
+	inode = ovl_get_inode(sb, dget(upper), lowerpath, index, !!lower);
 	if (IS_ERR(inode)) {
 		dput(upper);
 		return ERR_CAST(inode);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7fc9c83bf2ff..71bf6650b284 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -493,19 +493,26 @@ static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
 }
 
 static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev,
-			   unsigned long ino)
+			   unsigned long ino, int fsid)
 {
+	int xinobits = ovl_xino_bits(inode->i_sb);
+
 	/*
 	 * When NFS export is enabled and d_ino is consistent with st_ino
-	 * (samefs), set the same value to i_ino, because nfsd readdirplus
-	 * compares d_ino values to i_ino values of child entries. When called
-	 * from ovl_new_inode(), ino arg is 0, so i_ino will be updated to real
+	 * (samefs or i_ino has enough bits to encode layer), set the same
+	 * value used for d_ino to i_ino, because nfsd readdirplus compares
+	 * d_ino values to i_ino values of child entries. When called from
+	 * ovl_new_inode(), ino arg is 0, so i_ino will be updated to real
 	 * upper inode i_ino on ovl_inode_init() or ovl_inode_update().
 	 */
-	if (inode->i_sb->s_export_op && ovl_same_sb(inode->i_sb))
+	if (inode->i_sb->s_export_op &&
+	    (ovl_same_sb(inode->i_sb) || xinobits)) {
 		inode->i_ino = ino;
-	else
+		if (xinobits && fsid && !(ino >> (64 - xinobits)))
+			inode->i_ino |= (unsigned long)fsid << (64 - xinobits);
+	} else {
 		inode->i_ino = get_next_ino();
+	}
 	inode->i_mode = mode;
 	inode->i_flags |= S_NOCMTIME;
 #ifdef CONFIG_FS_POSIX_ACL
@@ -641,7 +648,7 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
 
 	inode = new_inode(sb);
 	if (inode)
-		ovl_fill_inode(inode, mode, rdev, 0);
+		ovl_fill_inode(inode, mode, rdev, 0, 0);
 
 	return inode;
 }
@@ -747,12 +754,14 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
 }
 
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
-			    struct dentry *lowerdentry, struct dentry *index,
+			    struct ovl_path *lowerpath, struct dentry *index,
 			    unsigned int numlower)
 {
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
+	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
+	int fsid = bylower ? lowerpath->layer->fsid : 0;
 	bool is_dir;
 	unsigned long ino = 0;
 
@@ -800,7 +809,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 		if (!inode)
 			goto out_nomem;
 	}
-	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino);
+	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
 	ovl_inode_init(inode, upperdentry, lowerdentry);
 
 	if (upperdentry && ovl_is_impuredir(upperdentry))
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 87d8bf2c09c6..d33f6213eb8f 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -986,9 +986,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		upperdentry = dget(index);
 
 	if (upperdentry || ctr) {
-		if (ctr)
-			origin = stack[0].dentry;
-		inode = ovl_get_inode(dentry->d_sb, upperdentry, origin, index,
+		inode = ovl_get_inode(dentry->d_sb, upperdentry, stack, index,
 				      ctr);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 09f5b8ce70aa..023e35ca6b5f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -331,7 +331,7 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper);
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
-			    struct dentry *lowerdentry, struct dentry *index,
+			    struct ovl_path *lowerpath, struct dentry *index,
 			    unsigned int numlower);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
-- 
2.7.4

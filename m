Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 01/31] ovl: Initialize ovl_inode->redirect in ovl_get_inode()
Date: Thu, 26 Apr 2018 15:09:43 -0400
Message-Id: <20180426191013.13219-2-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

ovl_inode->redirect is an inode property and should be initialized
in ovl_get_inode() only when we are adding a new inode to cache. If
inode is already in cache, it is already initialized and we should
not be touching ovl_inode->redirect field.

As of now this is not a problem as redirects are used only for directories
which don't share inode. But soon I want to use redirects for regular files
also and there it can become an issue.

Hence, move ->redirect initialization in ovl_get_inode().

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/export.c    | 2 +-
 fs/overlayfs/inode.c     | 5 ++++-
 fs/overlayfs/namei.c     | 9 +--------
 fs/overlayfs/overlayfs.h | 2 +-
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 425a94672300..5b7fee1a81ec 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -305,7 +305,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	if (d_is_dir(upper ?: lower))
 		return ERR_PTR(-EIO);
 
-	inode = ovl_get_inode(sb, dget(upper), lowerpath, index, !!lower);
+	inode = ovl_get_inode(sb, dget(upper), lowerpath, index, !!lower, NULL);
 	if (IS_ERR(inode)) {
 		dput(upper);
 		return ERR_CAST(inode);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b723327501f7..a3b9124f95d6 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -801,7 +801,7 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
 
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			    struct ovl_path *lowerpath, struct dentry *index,
-			    unsigned int numlower)
+			    unsigned int numlower, char *redirect)
 {
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
@@ -841,6 +841,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			}
 
 			dput(upperdentry);
+			kfree(redirect);
 			goto out;
 		}
 
@@ -864,6 +865,8 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	if (index)
 		ovl_set_flag(OVL_INDEX, inode);
 
+	OVL_I(inode)->redirect = redirect;
+
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
 		if (((upperdentry && lowerdentry) || numlower > 1) ||
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 2dba29eadde6..ac81e2c2c976 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1005,17 +1005,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (upperdentry || ctr) {
 		inode = ovl_get_inode(dentry->d_sb, upperdentry, stack, index,
-				      ctr);
+				      ctr, upperredirect);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
-
-		/*
-		 * NB: handle redirected hard links when non-dir redirects
-		 * become possible
-		 */
-		WARN_ON(OVL_I(inode)->redirect);
-		OVL_I(inode)->redirect = upperredirect;
 	}
 
 	revert_creds(old_cred);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index dad54bc8de7d..2b68175f7400 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -354,7 +354,7 @@ struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper);
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			    struct ovl_path *lowerpath, struct dentry *index,
-			    unsigned int numlower);
+			    unsigned int numlower, char *redirect);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
-- 
2.13.6

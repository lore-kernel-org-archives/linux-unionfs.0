Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 02/30] ovl: Initialize ovl_inode->redirect in ovl_get_inode()
Date: Mon,  7 May 2018 13:40:34 -0400
Message-Id: <20180507174102.24086-3-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
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
 fs/overlayfs/export.c    |  3 ++-
 fs/overlayfs/inode.c     |  3 +++
 fs/overlayfs/namei.c     | 10 ++--------
 fs/overlayfs/ovl_entry.h |  1 +
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 867946adcbc5..0549286cc55e 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -300,7 +300,8 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	struct dentry *dentry;
 	struct inode *inode;
 	struct ovl_entry *oe;
-	struct ovl_inode_params oip = {sb, NULL, lowerpath, index, !!lower};
+	struct ovl_inode_params oip = {sb, NULL, lowerpath, index, !!lower,
+				       NULL};
 
 	/* We get overlay directory dentries with ovl_lookup_real() */
 	if (d_is_dir(upper ?: lower))
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 2fe9538fffc9..d85d753f23fc 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -835,6 +835,7 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
 			}
 
 			dput(upperdentry);
+			kfree(oip->redirect);
 			goto out;
 		}
 
@@ -858,6 +859,8 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
 	if (oip->index)
 		ovl_set_flag(OVL_INDEX, inode);
 
+	OVL_I(inode)->redirect = oip->redirect;
+
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
 		if (((upperdentry && lowerdentry) || oip->numlower > 1) ||
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 1ab68454bfb6..8fd817bf5529 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1005,19 +1005,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (upperdentry || ctr) {
 		struct ovl_inode_params oip = {dentry->d_sb, upperdentry,
-					       stack, index, ctr};
+					       stack, index, ctr,
+					       upperredirect};
 
 		inode = ovl_get_inode(&oip);
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
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 11e9abe7e381..07b8cb2785c8 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -107,6 +107,7 @@ struct ovl_inode_params {
 	struct ovl_path *lowerpath;
 	struct dentry *index;
 	unsigned int numlower;
+	char *redirect;
 };
 
 static inline struct ovl_inode *OVL_I(struct inode *inode)
-- 
2.13.6

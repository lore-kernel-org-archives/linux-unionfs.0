From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 01/28] ovl: Initialize ovl_inode->redirect in ovl_get_inode()
Date: Tue, 29 May 2018 16:45:45 +0200
Message-ID: <20180529144612.16675-2-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

ovl_inode->redirect is an inode property and should be initialized in
ovl_get_inode() only when we are adding a new inode to cache.  If inode is
already in cache, it is already initialized and we should not be touching
ovl_inode->redirect field.

As of now this is not a problem as redirects are used only for directories
which don't share inode.  But soon I want to use redirects for regular
files also and there it can become an issue.

Hence, move ->redirect initialization in ovl_get_inode().

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c     | 3 +++
 fs/overlayfs/namei.c     | 8 +-------
 fs/overlayfs/overlayfs.h | 1 +
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index cd46dd8e7e54..c365b94fa158 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -844,6 +844,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 			}
 
 			dput(upperdentry);
+			kfree(oip->redirect);
 			goto out;
 		}
 
@@ -867,6 +868,8 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	if (oip->index)
 		ovl_set_flag(OVL_INDEX, inode);
 
+	OVL_I(inode)->redirect = oip->redirect;
+
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
 		if (((upperdentry && lowerdentry) || oip->numlower > 1) ||
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 08801b45df00..54f206485ab8 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1009,19 +1009,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			.lowerpath = stack,
 			.index = index,
 			.numlower = ctr,
+			.redirect = upperredirect,
 		};
 
 		inode = ovl_get_inode(dentry->d_sb, &oip);
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
index be4f1664f662..1948e38c3c95 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -342,6 +342,7 @@ struct ovl_inode_params {
 	struct ovl_path *lowerpath;
 	struct dentry *index;
 	unsigned int numlower;
+	char *redirect;
 };
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
-- 
2.14.3

Return-Path: <vgoyal@redhat.com>
Date: Tue, 8 May 2018 09:56:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 02/30] ovl: Initialize ovl_inode->redirect in
 ovl_get_inode()
Message-ID: <20180508135642.GF3501@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
 <20180507174102.24086-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507174102.24086-3-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>

Subject: ovl: Initialize ovl_inode->redirect in ovl_get_inode()

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
 fs/overlayfs/inode.c     |    3 +++
 fs/overlayfs/namei.c     |    8 +-------
 fs/overlayfs/ovl_entry.h |    1 +
 3 files changed, 5 insertions(+), 7 deletions(-)

Index: rhvgoyal-linux/fs/overlayfs/inode.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/inode.c	2018-05-07 16:42:22.395350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/inode.c	2018-05-07 16:42:24.825350785 -0400
@@ -836,6 +836,7 @@ struct inode *ovl_get_inode(struct super
 			}
 
 			dput(upperdentry);
+			kfree(oip->redirect);
 			goto out;
 		}
 
@@ -859,6 +860,8 @@ struct inode *ovl_get_inode(struct super
 	if (oip->index)
 		ovl_set_flag(OVL_INDEX, inode);
 
+	OVL_I(inode)->redirect = oip->redirect;
+
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
 		if (((upperdentry && lowerdentry) || oip->numlower > 1) ||
Index: rhvgoyal-linux/fs/overlayfs/ovl_entry.h
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/ovl_entry.h	2018-05-07 16:42:22.396350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/ovl_entry.h	2018-05-07 16:42:24.826350785 -0400
@@ -106,6 +106,7 @@ struct ovl_inode_params {
 	struct ovl_path *lowerpath;
 	struct dentry *index;
 	unsigned int numlower;
+	char *redirect;
 };
 
 static inline struct ovl_inode *OVL_I(struct inode *inode)
Index: rhvgoyal-linux/fs/overlayfs/namei.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/namei.c	2018-05-07 16:42:24.827350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/namei.c	2018-05-07 16:42:56.609350785 -0400
@@ -1009,19 +1009,13 @@ struct dentry *ovl_lookup(struct inode *
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

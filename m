From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 20/23] ovl: do not pass overlay dentry to ovl_get_inode()
Date: Thu,  4 Jan 2018 18:40:15 +0200
Message-ID: <1515084018-25134-21-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:44366 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753310AbeADQjv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:51 -0500
Received: by mail-wm0-f68.google.com with SMTP id t8so4543858wmc.3
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:50 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

This is needed for using ovl_get_inode() for decoding file handles
for NFS export.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 16 +++++++---------
 fs/overlayfs/namei.c     |  3 ++-
 fs/overlayfs/overlayfs.h |  5 +++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1b53755bd86c..fb436d66da7c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -635,14 +635,14 @@ static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
 	return true;
 }
 
-struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
-			    struct dentry *index)
+struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
+			    struct dentry *lowerdentry, struct dentry *index,
+			    unsigned int numlower)
 {
-	struct dentry *lowerdentry = ovl_dentry_lower(dentry);
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
 	/* Already indexed or could be indexed on copy up? */
-	bool indexed = (index || (ovl_indexdir(dentry->d_sb) && !upperdentry));
+	bool indexed = (index || (ovl_indexdir(sb) && !upperdentry));
 
 	if (WARN_ON(upperdentry && indexed && !lowerdentry))
 		return ERR_PTR(-EIO);
@@ -661,7 +661,7 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
 						      upperdentry);
 		unsigned int nlink;
 
-		inode = iget5_locked(dentry->d_sb, (unsigned long) key,
+		inode = iget5_locked(sb, (unsigned long) key,
 				     ovl_inode_test, ovl_inode_set, key);
 		if (!inode)
 			goto out_nomem;
@@ -684,7 +684,7 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
 				      realinode->i_nlink);
 		set_nlink(inode, nlink);
 	} else {
-		inode = new_inode(dentry->d_sb);
+		inode = new_inode(sb);
 		if (!inode)
 			goto out_nomem;
 	}
@@ -696,9 +696,7 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
 
 	/* Check for non-merge dir that may have whiteouts */
 	if (S_ISDIR(realinode->i_mode)) {
-		struct ovl_entry *oe = dentry->d_fsdata;
-
-		if (((upperdentry && lowerdentry) || oe->numlower > 1) ||
+		if (((upperdentry && lowerdentry) || numlower > 1) ||
 		    ovl_check_origin_xattr(upperdentry ?: lowerdentry)) {
 			ovl_set_flag(OVL_WHITEOUTS, inode);
 		}
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index ac902fa7c5e2..80233d5587b7 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -971,7 +971,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		upperdentry = dget(index);
 
 	if (upperdentry || ctr) {
-		inode = ovl_get_inode(dentry, upperdentry, index);
+		inode = ovl_get_inode(dentry->d_sb, upperdentry, origin, index,
+				      ctr);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d9467eab8514..f4b064023826 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -297,8 +297,9 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
-struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
-			    struct dentry *index);
+struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
+			    struct dentry *lowerdentry, struct dentry *index,
+			    unsigned int numlower);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
-- 
2.7.4

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 14/25] ovl: use ovl_inode_init() for initializing new inode
Date: Wed, 21 Jun 2017 15:28:45 +0300
Message-ID: <1498048136-28218-15-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36719 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751938AbdFUM3E (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:29:04 -0400
Received: by mail-wr0-f195.google.com with SMTP id 77so26086051wrb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 05:29:04 -0700 (PDT)
In-Reply-To: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

In preparation for hashing all overlay inodes, modify the helper
ovl_inode_init() to hash a new non-dir upper overlay inode.

Use this helper for initializing new upper inode in ovl_instantiate()
instead of ovl_inode_update(), because the implementations for new inode
case and copy up case are going to diverge.

Also move ovl_copyattr() into ovl_inode_init() and ovl_inode_get(),
so attributes will be copied only for new inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c   |  3 +--
 fs/overlayfs/inode.c |  1 +
 fs/overlayfs/namei.c |  1 -
 fs/overlayfs/util.c  | 11 ++++++++++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 822be8647d88..7bcb5a19e514 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -158,8 +158,7 @@ static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
 	ovl_dentry_version_inc(dentry->d_parent);
 	ovl_dentry_update(dentry, newdentry);
 	if (!hardlink) {
-		ovl_inode_update(inode, d_inode(newdentry));
-		ovl_copyattr(newdentry->d_inode, inode);
+		ovl_inode_init(inode, d_inode(newdentry), true);
 	} else {
 		WARN_ON(ovl_inode_real(inode, NULL) != d_inode(newdentry));
 		inc_nlink(inode);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 49492b982726..6f0ec691d8d5 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -477,6 +477,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode)
 	if (inode && inode->i_state & I_NEW) {
 		ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
 		set_nlink(inode, realinode->i_nlink);
+		ovl_copyattr(realinode, inode);
 		unlock_new_inode(inode);
 	}
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 261ea51199c6..29f57fe6d921 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -697,7 +697,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 		if (!inode)
 			goto out_free_oe;
-		ovl_copyattr(realdentry->d_inode, inode);
 	}
 
 	revert_creds(old_cred);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 916d4e5719a8..1769cc81a50f 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -267,6 +267,12 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 	ovl_update_type(dentry, d_is_dir(dentry));
 }
 
+static void ovl_insert_inode_hash(struct inode *inode, struct inode *realinode)
+{
+	WARN_ON(!inode_unhashed(inode));
+	__insert_inode_hash(inode, (unsigned long) realinode);
+}
+
 void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
 {
 	struct ovl_inode_info *oi = OVL_I_INFO(inode);
@@ -274,10 +280,13 @@ void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
 	if (is_upper) {
 		oi->__upperinode = realinode;
 		oi->lowerinode = NULL;
+		if (!S_ISDIR(realinode->i_mode))
+			ovl_insert_inode_hash(inode, realinode);
 	} else {
 		oi->__upperinode = NULL;
 		oi->lowerinode = realinode;
 	}
+	ovl_copyattr(realinode, inode);
 }
 
 struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
@@ -300,7 +309,7 @@ void ovl_inode_update(struct inode *inode, struct inode *upperinode)
 	WARN_ON(!inode_unhashed(inode));
 	WRITE_ONCE(OVL_I_INFO(inode)->__upperinode, upperinode);
 	if (!S_ISDIR(upperinode->i_mode))
-		__insert_inode_hash(inode, (unsigned long) upperinode);
+		ovl_insert_inode_hash(inode, upperinode);
 }
 
 void ovl_dentry_version_inc(struct dentry *dentry)
-- 
2.7.4

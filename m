From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 08/25] ovl: store path type in dentry
Date: Wed, 21 Jun 2017 15:28:39 +0300
Message-ID: <1498048136-28218-9-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36554 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdFUM2z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:28:55 -0400
Received: by mail-wr0-f193.google.com with SMTP id 77so26084999wrb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 05:28:54 -0700 (PDT)
In-Reply-To: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

We would like to be able to set type flags during lookup (i.e. INDEX)
instead of deducing them from other state information.

Store the type value in ovl_entry and update the UPPER/MERGE/ORIGIN
flags when needed, so ovl_path_type() just returns the stored value.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     |  1 +
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/ovl_entry.h |  3 +++
 fs/overlayfs/super.c     |  1 +
 fs/overlayfs/util.c      | 20 +++++++++++++++++---
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 400ad20ceb15..6e827a2b1cf0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -548,6 +548,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	kfree(stack);
 	kfree(d.redirect);
 	dentry->d_fsdata = oe;
+	ovl_update_type(dentry, d.is_dir);
 	d_add(dentry, inode);
 
 	return NULL;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 612b6e45c64b..09852c879046 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -199,6 +199,7 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
 bool ovl_dentry_weird(struct dentry *dentry);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
+void ovl_update_type(struct dentry *dentry, bool is_dir);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index ddd4b0a874a9..e94fa2638faf 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -40,6 +40,8 @@ struct ovl_fs {
 	struct super_block *same_sb;
 };
 
+enum ovl_path_type;
+
 /* private information held for every overlayfs dentry */
 struct ovl_entry {
 	struct dentry *__upperdentry;
@@ -54,6 +56,7 @@ struct ovl_entry {
 		};
 		struct rcu_head rcu;
 	};
+	enum ovl_path_type __type;
 	unsigned numlower;
 	struct path lowerstack[];
 };
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a9de7d1893e2..c72d79749652 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1105,6 +1105,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(stack);
 
 	root_dentry->d_fsdata = oe;
+	ovl_update_type(root_dentry, true);
 
 	realinode = d_inode(ovl_dentry_real(root_dentry));
 	ovl_inode_init(d_inode(root_dentry), realinode, !!upperpath.dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 8e2f308056f1..8e743c76aa03 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -91,24 +91,37 @@ bool ovl_dentry_weird(struct dentry *dentry)
 enum ovl_path_type ovl_path_type(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
+
+	return READ_ONCE(oe->__type);
+}
+
+void ovl_update_type(struct dentry *dentry, bool is_dir)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
 	enum ovl_path_type type = 0;
 
+	spin_lock(&dentry->d_lock);
 	if (oe->__upperdentry) {
 		type = __OVL_PATH_UPPER;
-
 		/*
 		 * Non-dir dentry can hold lower dentry of its copy up origin.
 		 */
 		if (oe->numlower) {
 			type |= __OVL_PATH_ORIGIN;
-			if (d_is_dir(dentry))
+			if (is_dir)
 				type |= __OVL_PATH_MERGE;
 		}
 	} else {
 		if (oe->numlower > 1)
 			type |= __OVL_PATH_MERGE;
 	}
-	return type;
+
+	/*
+	 * The UPPER/MERGE/ORIGIN flags can never be cleared during the
+	 * lifetime of a dentry, so don't bother masking them out first.
+	 */
+	oe->__type |= type;
+	spin_unlock(&dentry->d_lock);
 }
 
 void ovl_path_upper(struct dentry *dentry, struct path *path)
@@ -243,6 +256,7 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 	 */
 	smp_wmb();
 	oe->__upperdentry = upperdentry;
+	ovl_update_type(dentry, d_is_dir(dentry));
 }
 
 void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
-- 
2.7.4

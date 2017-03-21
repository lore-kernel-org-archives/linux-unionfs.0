From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 1/2] ovl: store path type in dentry
Date: Tue, 21 Mar 2017 12:16:44 -0400
Message-ID: <1490113005-28787-2-git-send-email-amir73il@gmail.com>
References: <1490113005-28787-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36401 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757195AbdCUQQr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Mar 2017 12:16:47 -0400
Received: by mail-qt0-f196.google.com with SMTP id n37so21981785qtb.3
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Mar 2017 09:16:46 -0700 (PDT)
In-Reply-To: <1490113005-28787-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

ovl_path_type() is called quite often (e.g.: on every file open)
to calculate the path type flags of overlay dentry.  Those flags
are rarely changed after dentry instantiation  and when changed,
flags can only be added. (e.g.: on copyup, rename and create).

Store the type value in ovl_entry and update the flags when
needed, so ovl_path_type() just returns the stored value.

The old ovl_path_type() took care of clearing OVL_TYPE_MERGE
for a non-dir entry.  It did so for a reason that seem obsolete.
In any case, the code never checks OVL_TYPE_MERGE on non-dir entry,
so merge flag for non-dir is harmless.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     |  1 +
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/ovl_entry.h |  3 +++
 fs/overlayfs/super.c     |  1 +
 fs/overlayfs/util.c      | 20 ++++++++++++--------
 5 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 70a6b64..c230ee1 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -481,6 +481,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	kfree(stack);
 	kfree(d.redirect);
 	dentry->d_fsdata = oe;
+	ovl_update_type(dentry);
 	d_add(dentry, inode);
 
 	return NULL;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 2ef53f0..d37ec4c 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -168,6 +168,7 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
 bool ovl_dentry_weird(struct dentry *dentry);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
+enum ovl_path_type ovl_update_type(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 85c886d..b07c29f 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -33,6 +33,8 @@ struct ovl_fs {
 	wait_queue_head_t copyup_wq;
 };
 
+enum ovl_path_type;
+
 /* private information held for every overlayfs dentry */
 struct ovl_entry {
 	struct dentry *__upperdentry;
@@ -46,6 +48,7 @@ struct ovl_entry {
 		};
 		struct rcu_head rcu;
 	};
+	enum ovl_path_type type;
 	unsigned numlower;
 	struct path lowerstack[];
 };
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f771366..bdbed27 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -977,6 +977,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(stack);
 
 	root_dentry->d_fsdata = oe;
+	ovl_update_type(root_dentry);
 
 	realinode = d_inode(ovl_dentry_real(root_dentry));
 	ovl_inode_init(d_inode(root_dentry), realinode, !!upperpath.dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index aaac1ac..f9693a8 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -70,21 +70,24 @@ bool ovl_dentry_weird(struct dentry *dentry)
 enum ovl_path_type ovl_path_type(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
-	enum ovl_path_type type = 0;
 
-	if (oe->__upperdentry) {
-		type = __OVL_PATH_UPPER;
+	return oe->type;
+}
+
+enum ovl_path_type ovl_update_type(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+	enum ovl_path_type type = oe->type;
 
-		/*
-		 * Non-dir dentry can hold lower dentry from previous
-		 * location.
-		 */
-		if (oe->numlower && d_is_dir(dentry))
+	if (oe->__upperdentry) {
+		type |= __OVL_PATH_UPPER;
+		if (oe->numlower)
 			type |= __OVL_PATH_MERGE;
 	} else {
 		if (oe->numlower > 1)
 			type |= __OVL_PATH_MERGE;
 	}
+	oe->type = type;
 	return type;
 }
 
@@ -248,6 +251,7 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 	 */
 	smp_wmb();
 	oe->__upperdentry = upperdentry;
+	ovl_update_type(dentry);
 }
 
 void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
-- 
2.7.4

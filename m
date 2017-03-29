From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/6] ovl: store path type in dentry
Date: Wed, 29 Mar 2017 17:36:01 +0300
Message-ID: <1490798166-22310-2-git-send-email-amir73il@gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33616 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbdC2OgE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Mar 2017 10:36:04 -0400
Received: by mail-wr0-f195.google.com with SMTP id u18so3564385wrc.0
        for <linux-unionfs@vger.kernel.org>; Wed, 29 Mar 2017 07:36:03 -0700 (PDT)
In-Reply-To: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

ovl_path_type() is called quite often (e.g.: on every file open)
to calculate the path type flags of overlay dentry.  Those flags
are rarely changed after dentry instantiation and when changed,
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
 fs/overlayfs/util.c      | 32 ++++++++++++++++++++++++--------
 5 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b8b0778..9d7884d 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -338,6 +338,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	kfree(stack);
 	kfree(d.redirect);
 	dentry->d_fsdata = oe;
+	ovl_update_type(dentry);
 	d_add(dentry, inode);
 
 	return NULL;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 741dc0b..51419b5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -155,6 +155,7 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
 bool ovl_dentry_weird(struct dentry *dentry);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
+enum ovl_path_type ovl_update_type(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 59614fa..293be5f 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -31,6 +31,8 @@ struct ovl_fs {
 	wait_queue_head_t copyup_wq;
 };
 
+enum ovl_path_type;
+
 /* private information held for every overlayfs dentry */
 struct ovl_entry {
 	struct dentry *__upperdentry;
@@ -44,6 +46,7 @@ struct ovl_entry {
 		};
 		struct rcu_head rcu;
 	};
+	enum ovl_path_type __type;
 	unsigned numlower;
 	struct path lowerstack[];
 };
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c9e70d3..6d9766f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -939,6 +939,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(stack);
 
 	root_dentry->d_fsdata = oe;
+	ovl_update_type(root_dentry);
 
 	realinode = d_inode(ovl_dentry_real(root_dentry));
 	ovl_inode_init(d_inode(root_dentry), realinode, !!upperpath.dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 1953986..aaef2e28 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -70,21 +70,36 @@ bool ovl_dentry_weird(struct dentry *dentry)
 enum ovl_path_type ovl_path_type(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
-	enum ovl_path_type type = 0;
+	enum ovl_path_type type = oe->__type;
 
-	if (oe->__upperdentry) {
-		type = __OVL_PATH_UPPER;
+	/* Matches smp_wmb() in ovl_update_type() */
+	smp_rmb();
+	return type;
+}
+
+enum ovl_path_type ovl_update_type(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+	enum ovl_path_type type = oe->__type;
 
-		/*
-		 * Non-dir dentry can hold lower dentry from previous
-		 * location.
-		 */
-		if (oe->numlower && d_is_dir(dentry))
+	/*
+	 * During the lifetime of an overlay dentry, those flags can
+	 * only be set, never cleared.
+	 */
+	if (oe->__upperdentry) {
+		type |= __OVL_PATH_UPPER;
+		if (oe->numlower)
 			type |= __OVL_PATH_MERGE;
 	} else {
 		if (oe->numlower > 1)
 			type |= __OVL_PATH_MERGE;
 	}
+	/*
+	 * Make sure type is consistent with __upperdentry before making it
+	 * visible to ovl_path_type().
+	 */
+	smp_wmb();
+	oe->__type = type;
 	return type;
 }
 
@@ -220,6 +235,7 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 	 */
 	smp_wmb();
 	oe->__upperdentry = upperdentry;
+	ovl_update_type(dentry);
 }
 
 void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
-- 
2.7.4

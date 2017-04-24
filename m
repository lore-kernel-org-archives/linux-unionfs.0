From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 01/11] ovl: store path type in dentry
Date: Mon, 24 Apr 2017 12:14:06 +0300
Message-ID: <1493025256-27188-2-git-send-email-amir73il@gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34537 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167621AbdDXJOK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Apr 2017 05:14:10 -0400
In-Reply-To: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

We would like to add more state info to ovl_entry soon (for const ino)
and this state info would be added as type flags.

Store the type value in ovl_entry and update the UPPER and MERGE type
flags when needed, so ovl_path_type() just returns the stored value.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     |  1 +
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/ovl_entry.h |  3 +++
 fs/overlayfs/super.c     |  1 +
 fs/overlayfs/util.c      | 30 ++++++++++++++++++++++++------
 5 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b8b0778..8788fd7 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -338,6 +338,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	kfree(stack);
 	kfree(d.redirect);
 	dentry->d_fsdata = oe;
+	ovl_update_type(dentry, d.is_dir);
 	d_add(dentry, inode);
 
 	return NULL;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 741dc0b..e90a548 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -155,6 +155,7 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
 bool ovl_dentry_weird(struct dentry *dentry);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
+enum ovl_path_type ovl_update_type(struct dentry *dentry, bool is_dir);
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
index c072a0c..671bac0 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -961,6 +961,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(stack);
 
 	root_dentry->d_fsdata = oe;
+	ovl_update_type(root_dentry, true);
 
 	realinode = d_inode(ovl_dentry_real(root_dentry));
 	ovl_inode_init(d_inode(root_dentry), realinode, !!upperpath.dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 1953986..6a857fb 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -70,21 +70,38 @@ bool ovl_dentry_weird(struct dentry *dentry)
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
+enum ovl_path_type ovl_update_type(struct dentry *dentry, bool is_dir)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+	enum ovl_path_type type = oe->__type;
 
+	/* Update UPPER/MERGE flags and preserve the rest */
+	type &= ~(__OVL_PATH_UPPER | __OVL_PATH_MERGE);
+	if (oe->__upperdentry) {
+		type |= __OVL_PATH_UPPER;
 		/*
-		 * Non-dir dentry can hold lower dentry from previous
-		 * location.
+		 * Non-dir dentry can hold lower dentry from before
+		 * copy-up.
 		 */
-		if (oe->numlower && d_is_dir(dentry))
+		if (oe->numlower && is_dir)
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
 
@@ -220,6 +237,7 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 	 */
 	smp_wmb();
 	oe->__upperdentry = upperdentry;
+	ovl_update_type(dentry, d_is_dir(dentry));
 }
 
 void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
-- 
2.7.4

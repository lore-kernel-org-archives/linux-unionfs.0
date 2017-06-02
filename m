From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 11/17] ovl: hash overlay non-dir inodes by copy up origin inode
Date: Fri,  2 Jun 2017 17:04:38 +0300
Message-ID: <1496412284-4113-12-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35143 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdFBOEt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:49 -0400
Received: by mail-wm0-f66.google.com with SMTP id g15so19167756wmc.2
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:48 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Non-dir pure upper overlay inodes are hashed by the address of the
upper real inode.  When inodes index feature is enabled, hash all non-dir
inodes by the address of the copy up origin inode if we know it.

This is going to be used to prevent breaking lower hardlinks on copy up.

Because overlay dentries of lower hardlink aliases have the same overlay
inode, copy up of those lower aliases can result is conflict when setting
the real upper inode of a broken hardlink. Copy up of an alias that lost
in this conflict will return -EEXIST and drop the overlay dentry.

This conflict is going to be handled more gracefully by following patches.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  6 +++++-
 fs/overlayfs/inode.c     | 40 ++++++++++++++++++++++++++++++++++++----
 fs/overlayfs/namei.c     | 20 ++++++++++++++++----
 fs/overlayfs/overlayfs.h |  2 +-
 4 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 95568ec4f1d0..0fff3b7cb3e2 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -424,7 +424,11 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 
 	newdentry = dget(tmpfile ? upper : temp);
 	ovl_dentry_update(dentry, newdentry);
-	ovl_inode_update(d_inode(dentry), d_inode(newdentry));
+	err = ovl_inode_update(d_inode(dentry), d_inode(newdentry));
+	if (err) {
+		/* Broken hardlink - drop cache and return error */
+		d_drop(dentry);
+	}
 
 	/* Restore timestamps on parent (best effort) */
 	ovl_set_timestamps(upperdir, pstat);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1e89885d5304..95746b228a0c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -471,17 +471,49 @@ void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
 		ovl_insert_inode_hash(inode, realinode);
 }
 
-void ovl_inode_update(struct inode *inode, struct inode *upperinode)
+/*
+ * When inodes index is enabled, we hash all non-dir inodes by the address
+ * of the lower origin inode. We need to take care on concurrent copy up of
+ * different lower hardlinks, that only one alias can set the upper real inode.
+ * Copy up of an alias that lost the ovl_inode_update() race will get -EEXIST
+ * and needs to d_drop() the overlay dentry of that alias, so the next
+ * ovl_lookup() will initialize a new overlay inode for the broken hardlink.
+ */
+int ovl_inode_update(struct inode *inode, struct inode *upperinode)
 {
+	bool is_upper;
+	struct inode *realinode;
+
 	WARN_ON(!upperinode);
-	WRITE_ONCE(inode->i_private, ovl_inode_data(upperinode, true));
-	if (!S_ISDIR(upperinode->i_mode))
+	spin_lock(&inode->i_lock);
+	realinode = ovl_inode_real(inode, &is_upper);
+	if (!is_upper)
+		inode->i_private = ovl_inode_data(upperinode, true);
+	spin_unlock(&inode->i_lock);
+	if (is_upper && realinode != upperinode)
+		return -EEXIST;
+	/* When inodes index is enabled, inode is hashed before copy up */
+	if (!S_ISDIR(upperinode->i_mode) && !ovl_indexdir(inode->i_sb))
 		ovl_insert_inode_hash(inode, upperinode);
+	return 0;
 }
 
 static int ovl_inode_test(struct inode *inode, void *data)
 {
-	return READ_ONCE(inode->i_private) == data;
+	void *this = READ_ONCE(inode->i_private);
+
+	if (this == data)
+		return true;
+
+	/*
+	 * Overlay inodes hash key is the address of the lower origin inode.
+	 * Return same overlay inode when looking up by lower real inode, but
+	 * an existing overlay inode, that is hashed by the same lower origin
+	 * inode, has already been updated on copy up to a real upper inode.
+	 */
+	return ovl_indexdir(inode->i_sb) &&
+		ovl_inode_data_is_upper(this) &&
+		!ovl_inode_data_is_upper(data);
 }
 
 static int ovl_inode_set(struct inode *inode, void *data)
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 615fb23fcba5..b6f9870ba13a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -519,15 +519,27 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	if (upperdentry || ctr) {
 		struct dentry *realdentry;
 		struct inode *realinode;
+		unsigned long hashval = 0;
 
 		realdentry = upperdentry ? upperdentry : stack[0].dentry;
 		realinode = d_inode(realdentry);
+		/*
+		 * When inodes index is enabled, we hash all non-dir inodes
+		 * by the address of the lower origin inode.
+		 * When inodes index is disabled, or if entry is pure upper, we
+		 * hash upper non-dir inodes by the addess of the upper inode.
+		 * Regardless of the hash key we use, we always pass the real
+		 * inode (upper most) to iget5_locked() test/set callbacks.
+		 */
+		if (ofs->indexdir && !d.is_dir && ctr)
+			hashval = (unsigned long) d_inode(stack[0].dentry);
+		else if (upperdentry && !d_is_dir(upperdentry))
+			hashval = (unsigned long) realinode;
 
 		err = -ENOMEM;
-		if (upperdentry && !d_is_dir(upperdentry)) {
-			inode = ovl_get_inode(dentry->d_sb,
-					      (unsigned long) realinode,
-					      realinode, true);
+		if (hashval) {
+			inode = ovl_get_inode(dentry->d_sb, hashval,
+					      realinode, !!upperdentry);
 		} else {
 			inode = ovl_new_inode(dentry->d_sb, realinode->i_mode,
 					      realinode->i_rdev);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index db3c7641efe6..33d596337044 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -298,7 +298,7 @@ bool ovl_is_private_xattr(const char *name);
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
-void ovl_inode_update(struct inode *inode, struct inode *upperinode);
+int ovl_inode_update(struct inode *inode, struct inode *upperinode);
 struct inode *ovl_get_inode(struct super_block *sb, unsigned long hashval,
 			    struct inode *realinode, bool is_upper);
 
-- 
2.7.4

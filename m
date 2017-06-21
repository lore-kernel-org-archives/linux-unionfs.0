From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 15/25] ovl: hash overlay non-dir inodes by copy up origin inode
Date: Wed, 21 Jun 2017 15:28:46 +0300
Message-ID: <1498048136-28218-16-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36770 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdFUM3G (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:29:06 -0400
Received: by mail-wr0-f194.google.com with SMTP id 77so26086364wrb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 05:29:05 -0700 (PDT)
In-Reply-To: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

When inodes index feature is enabled, hash all non-dir inodes by the
address of the copy up origin inode if origin inode is indexed.

Non-upper overlay inodes are hashed by the lower real inode, which is
the copy up origin to be.

This change makes all lower hardlinks and their indexed copy ups be
represented by a single overlay inode and is needed for vfs inode
consistency after hardlinks are no longer broken on copy up.

Because overlay dentries of lower hardlink aliases have the same overlay
inode, a non indexed copy up of those lower aliases will cause a conflict
when trying to update the realinode to the broken upper hardlink.
A non indexed copy up of an alias that lost in this conflict will return
-EEXIST and drop the overlay dentry. The next lookup of that broken
upper hardlink will return as upper entry with a new overlay inode.

This conflict is going to be handled more gracefully by following patches.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  6 +++++-
 fs/overlayfs/inode.c     | 49 ++++++++++++++++++++++++++++++++++++++++++------
 fs/overlayfs/namei.c     | 22 ++++++++++++++++++++--
 fs/overlayfs/overlayfs.h |  7 +++++--
 fs/overlayfs/util.c      | 33 ++++++++++++++++++++++++++++----
 5 files changed, 102 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index eedc26e15dad..ae18824c7944 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -418,7 +418,11 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 
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
index 6f0ec691d8d5..28f9a8cc0f61 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -458,22 +458,59 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
 
 static int ovl_inode_test(struct inode *inode, void *data)
 {
-	return OVL_I_INFO(inode)->__upperinode == data;
+	struct ovl_inode_info *oi = OVL_I_INFO(inode);
+	struct ovl_inode_info *info = data;
+	bool indexed = ovl_indexdir(inode->i_sb);
+
+	if (indexed && info->lowerinode != oi->lowerinode)
+		return false;
+
+	if (info->__upperinode == oi->__upperinode)
+		return true;
+
+	/*
+	 * Return same overlay inode when looking up by lower real inode, but
+	 * an indexed overlay inode, that is hashed by the same lower origin
+	 * inode, has already been updated on copy up to a real upper inode.
+	 */
+	return indexed && !info->__upperinode;
 }
 
 static int ovl_inode_set(struct inode *inode, void *data)
 {
-	OVL_I_INFO(inode)->__upperinode = data;
+	struct ovl_inode_info *oi = OVL_I_INFO(inode);
+	struct ovl_inode_info *info = data;
+
+	oi->__upperinode = info->__upperinode;
+	oi->lowerinode = info->lowerinode;
+
 	return 0;
 }
 
-struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode)
-
+struct inode *ovl_get_inode(struct super_block *sb, struct ovl_inode_info *info)
 {
+	struct inode *realinode = info->__upperinode;
+	unsigned long hashval = (unsigned long) realinode;
 	struct inode *inode;
 
-	inode = iget5_locked(sb, (unsigned long) realinode,
-			     ovl_inode_test, ovl_inode_set, realinode);
+	/*
+	 * With inodes index feature enabled, overlay inodes hash key is the
+	 * address of the copy up origin lower inode if it is indexed.
+	 * When hashing a non-upper overlay inode, origin has to be set to
+	 * the real lower inode, which is the copy up origin inode to be.
+	 * Regardless of the inode we use as hash key, we always use the
+	 * uppermost real inode to initialize ovl_inode.
+	 */
+	if (info->lowerinode) {
+		WARN_ON(!ovl_indexdir(sb));
+		hashval = (unsigned long) info->lowerinode;
+		if (!realinode)
+			realinode = info->lowerinode;
+	} else if (WARN_ON(!realinode)) {
+		return NULL;
+	}
+
+	inode = iget5_locked(sb, hashval, ovl_inode_test, ovl_inode_set, info);
 	if (inode && inode->i_state & I_NEW) {
 		ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
 		set_nlink(inode, realinode->i_nlink);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 29f57fe6d921..08154dad725e 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -682,13 +682,31 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	if (upperdentry || ctr) {
 		struct dentry *realdentry;
 		struct inode *realinode;
+		struct ovl_inode_info info = { };
 
 		realdentry = upperdentry ? upperdentry : stack[0].dentry;
 		realinode = d_inode(realdentry);
+		/*
+		 * When inodes index is enabled, we hash upper non-dir inodes
+		 * by the address of the copy up origin inode if origin inode
+		 * is indexed (positive index) and we hash non-upper non-dir
+		 * inodes by the address of the lower inode (negative index).
+		 *
+		 * When inodes index is disabled, or if origin is not indexed,
+		 * we hash non-dir upper inodes by the address of upper inode.
+		 */
+		if (upperdentry) {
+			BUG_ON(index && realinode != d_inode(index));
+			info.__upperinode = realinode;
+		}
+		if (index) {
+			BUG_ON(!ctr);
+			info.lowerinode = d_inode(stack[0].dentry);
+		}
 
 		err = -ENOMEM;
-		if (upperdentry && !d_is_dir(upperdentry)) {
-			inode = ovl_get_inode(dentry->d_sb, realinode);
+		if ((upperdentry || index) && !d.is_dir) {
+			inode = ovl_get_inode(dentry->d_sb, &info);
 		} else {
 			inode = ovl_new_inode(dentry->d_sb, realinode->i_mode,
 					      realinode->i_rdev);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 35cefa9e9de6..79cee43eb84d 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -213,7 +213,7 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
 struct inode *ovl_inode_real(struct inode *inode, bool *is_upper);
-void ovl_inode_update(struct inode *inode, struct inode *upperinode);
+int ovl_inode_update(struct inode *inode, struct inode *upperinode);
 void ovl_dentry_version_inc(struct dentry *dentry);
 u64 ovl_dentry_version_get(struct dentry *dentry);
 bool ovl_is_whiteout(struct dentry *dentry);
@@ -270,7 +270,10 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
-struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode);
+struct ovl_inode_info;
+struct inode *ovl_get_inode(struct super_block *sb,
+			    struct ovl_inode_info *info);
+
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 1769cc81a50f..f3a22566eaa1 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -303,13 +303,38 @@ struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
 	return realinode;
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
+	struct ovl_inode_info *oi = OVL_I_INFO(inode);
+	struct inode *realinode;
+	bool indexed = ovl_indexdir(inode->i_sb);
+
 	WARN_ON(!upperinode);
-	WARN_ON(!inode_unhashed(inode));
-	WRITE_ONCE(OVL_I_INFO(inode)->__upperinode, upperinode);
-	if (!S_ISDIR(upperinode->i_mode))
+
+	spin_lock(&inode->i_lock);
+	realinode = oi->__upperinode;
+	if (!realinode)
+		oi->__upperinode = upperinode;
+	spin_unlock(&inode->i_lock);
+
+	if (realinode && realinode != upperinode) {
+		WARN_ON(!indexed);
+		return -EEXIST;
+	}
+
+	/* When inodes index is enabled, inode is hashed before copy up */
+	if (!S_ISDIR(upperinode->i_mode) && !indexed)
 		ovl_insert_inode_hash(inode, upperinode);
+
+	return 0;
 }
 
 void ovl_dentry_version_inc(struct dentry *dentry)
-- 
2.7.4

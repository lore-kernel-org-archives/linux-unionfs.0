From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 11/20] ovl: hash overlay non-dir inodes by copy up origin inode
Date: Wed,  7 Jun 2017 10:51:15 +0300
Message-ID: <1496821884-5178-12-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36001 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751472AbdFGHv3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 03:51:29 -0400
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When inodes index feature is enabled, hash all non-dir inodes by the
address of the copy up origin inode if it is indexed.

Non-upper overlay inodes are hashed by the lower real inode, which is
the copy up origin to be. The lower (copy up origin) inode in stored in
the unused field i_data.private_data of the overlay inode.

This change makes all lower hardlinks and their indexed copy ups be
represented by a single overlay inode and is needed for vfs inode
consistency after hardlinks are no longer broken on copy up.

When hashing a non-upper overlay inode and an index entry already exists
from another lower alias copy up, set the overlay realinode to the indexed
upper inode. This is needed to make the overlay realinode invariant to
the order of lookup between two lower aliases, when only one fo them was
copied up.

Because overlay dentries of lower hardlink aliases have the same overlay
inode, a non indexed copy up of those lower aliases will cause a conflict
when trying to update the realinode to the broken upper hardlink.
A non indexed copy up of an alias that lost in this conflict will return
-EEXIST and drop the overlay dentry. The next lookup of that broken
upper hardlink will return as upper entry with a new overlay inode.

This conflict is going to be handled more gracefully by following patches.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  6 +++-
 fs/overlayfs/inode.c     | 84 ++++++++++++++++++++++++++++++++++++++++++------
 fs/overlayfs/namei.c     | 25 ++++++++++++--
 fs/overlayfs/overlayfs.h | 13 ++++++--
 4 files changed, 114 insertions(+), 14 deletions(-)

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
index 55f4df8c3cf1..1f8276d7df32 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -471,32 +471,98 @@ void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
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
-	ovl_inode_set_real(inode, upperinode, true);
-	if (!S_ISDIR(upperinode->i_mode))
+	spin_lock(&inode->i_lock);
+	realinode = ovl_inode_real(inode, &is_upper);
+	if (!is_upper)
+		ovl_inode_set_real(inode, upperinode, true);
+	spin_unlock(&inode->i_lock);
+	if (is_upper && realinode != upperinode)
+		return -EEXIST;
+	/* When inodes index is enabled, inode is hashed before copy up */
+	if (!S_ISDIR(upperinode->i_mode) && !ovl_indexdir(inode->i_sb))
 		ovl_insert_inode_hash(inode, upperinode);
+	return 0;
+}
+
+/* Store copy up origin inode in unused field i_data.private_data */
+static void ovl_inode_set_orig(struct inode *inode, struct inode *originode)
+{
+	inode->i_data.private_data = originode;
+}
+
+static struct inode *ovl_inode_orig(struct inode *inode)
+{
+	return (struct inode *) inode->i_data.private_data;
 }
 
 static int ovl_inode_test(struct inode *inode, void *data)
 {
-	return ovl_inode_real(inode, NULL) == data;
+	struct ovl_inode_info *oi = data;
+	bool is_upper;
+	struct inode *realinode = ovl_inode_real(inode, &is_upper);
+
+	if (realinode == oi->realinode) {
+		WARN_ON(is_upper != oi->is_upper);
+		return true;
+	}
+
+	/*
+	 * Return same overlay inode when looking up by lower real inode, but
+	 * an existing overlay inode, that is hashed by the same lower origin
+	 * inode, has already been updated on copy up to a real upper inode.
+	 */
+	return ovl_indexdir(inode->i_sb) && !oi->is_upper &&
+		is_upper && ovl_inode_orig(inode) == oi->realinode;
 }
 
 static int ovl_inode_set(struct inode *inode, void *data)
 {
-	inode->i_private = (void *) (((unsigned long) data) | OVL_ISUPPER_MASK);
+	struct ovl_inode_info *oi = data;
+
+	ovl_inode_set_real(inode, oi->realinode, oi->is_upper);
+	ovl_inode_set_orig(inode, oi->originode);
 	return 0;
 }
 
-struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode)
-
+struct inode *ovl_get_inode(struct super_block *sb, struct ovl_inode_info *oi)
 {
+	struct inode *realinode = oi->realinode;
+	unsigned long hashval = (unsigned long) realinode;
 	struct inode *inode;
 
-	inode = iget5_locked(sb, (unsigned long) realinode,
-			     ovl_inode_test, ovl_inode_set, realinode);
+	/*
+	 * With inodes index feature enabled, overlay inodes hash key is the
+	 * address of the copy up origin inode if it is indexed.
+	 * When hashing a non-upper overlay inode, origin has to be set to
+	 * the real lower inode, which is the copy up origin inode to be.
+	 * When hashing a non-upper overlay inode and index points to an upper
+	 * inode (from another lower alias copy up), set the real inode to the
+	 * indexed upper inode.
+	 */
+	if (oi->originode && oi->originode != realinode) {
+		WARN_ON(!ovl_indexdir(sb) || !oi->is_upper);
+		hashval = (unsigned long) oi->originode;
+	}
+	if (oi->index && d_inode(oi->index)) {
+		WARN_ON(oi->is_upper && d_inode(oi->index) != realinode);
+		realinode = d_inode(oi->index);
+	}
+
+	inode = iget5_locked(sb, hashval, ovl_inode_test, ovl_inode_set, oi);
 	if (inode && inode->i_state & I_NEW) {
 		ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
 		set_nlink(inode, realinode->i_nlink);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index d204488bf23c..3f0f429798ef 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -595,13 +595,34 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	if (upperdentry || ctr) {
 		struct dentry *realdentry;
 		struct inode *realinode;
+		struct inode *originode = NULL;
 
 		realdentry = upperdentry ? upperdentry : stack[0].dentry;
 		realinode = d_inode(realdentry);
+		/*
+		 * When inodes index is enabled, we hash all non-dir inodes
+		 * by the address of the copy up origin inode if it is indexed
+		 * or by the address of the non-upper real inode.
+		 * When inodes index is disabled, or if origin is not indexed,
+		 * we hash non-dir upper inodes by the addess of the real inode.
+		 * Regardless of the inode we use as hash key, we always store
+		 * the real (upper most) inode in i_private field.
+		 */
+		if (indexdentry) {
+			BUG_ON(!ctr);
+			originode = d_inode(stack[0].dentry);
+		}
 
 		err = -ENOMEM;
-		if (upperdentry && !d_is_dir(upperdentry)) {
-			inode = ovl_get_inode(dentry->d_sb, realinode);
+		if (!d.is_dir && (upperdentry || originode)) {
+			struct ovl_inode_info info = {
+				.realinode = realinode,
+				.originode = originode,
+				.index = indexdentry,
+				.is_upper = !!upperdentry,
+			};
+
+			inode = ovl_get_inode(dentry->d_sb, &info);
 		} else {
 			inode = ovl_new_inode(dentry->d_sb, realinode->i_mode,
 					      realinode->i_rdev);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index c4669b6b0e20..beac2d858689 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -258,8 +258,17 @@ bool ovl_is_private_xattr(const char *name);
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
-void ovl_inode_update(struct inode *inode, struct inode *upperinode);
-struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode);
+int ovl_inode_update(struct inode *inode, struct inode *upperinode);
+
+/* information used to lookup an overlayfs inode */
+struct ovl_inode_info {
+	struct inode *realinode;
+	struct inode *originode;
+	struct dentry *index;
+	bool is_upper;
+};
+
+struct inode *ovl_get_inode(struct super_block *sb, struct ovl_inode_info *oi);
 
 #define OVL_ISUPPER_MASK 1UL
 
-- 
2.7.4

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/4] ovl: hash inodes by lower file handle for NFS export
Date: Tue,  6 Feb 2018 14:21:39 +0200
Message-ID: <1517919700-29182-5-git-send-email-amir73il@gmail.com>
References: <1517919700-29182-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41938 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752954AbeBFMUt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Feb 2018 07:20:49 -0500
Received: by mail-wr0-f194.google.com with SMTP id v15so1689945wrb.8
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Feb 2018 04:20:48 -0800 (PST)
In-Reply-To: <1517919700-29182-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

An overlay file handle contains a real underlying filesystem file handle
and decoding an overlay file handle typically starts by decoding the real
file handle.

Decoding a real directory file handle can be expensive, and it could be
avoided in some cases by looking in the overlay inode cache before
decoding a lower overlay file handle.

In order to be able to do that, we store a copy of the lower file handle
in overlay inode i_private field and hash the overlay inode by the value
of lower file handle instead of by the lower inode pointer.

A helper ovl_lookup_inode_fh() is introduced to lookup overlay inode by
lower file handle. A followup patch will use this helper to optimize
overlay lower file handle decode for the hot inode cache case.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 80 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/overlayfs/namei.c     |  2 +-
 fs/overlayfs/overlayfs.h |  9 ++++++
 fs/overlayfs/super.c     |  2 ++
 4 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b6b44cf9ec26..5fef29e2f80f 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -651,12 +651,65 @@ static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
 	return true;
 }
 
+/*
+ * Overlay inodes are hashed by lower file handle for NFS export, so decode can
+ * lookup inode cache before doing index lookup and decoding real file handles.
+ * For pure upper or non-indexed upper or without NFS export, we hash by real
+ * inode pointer as before NFS export. i_private holds a copy of lower file
+ * handle or the real inode pointer respectively.
+ */
+static int ovl_inode_test_fh(struct inode *inode, void *data)
+{
+	return ovl_test_flag(OVL_I_PRIVATE_FH, inode) &&
+	       ovl_fs_equal(inode->i_private, data);
+}
+
+/* Compute hash from real fs uuid and real fs file handle */
+static unsigned long ovl_fh_hash(struct ovl_fh *fh)
+{
+	/*
+	 * Mixing the uuid with the real file handle is needed for an
+	 * overlay configuration of many lower layers on different fs.
+	 * Other ovl_fh header values are not likely to add random bits.
+	 */
+	return full_name_long_hash(NULL, (const char *)&fh->uuid,
+				   fh->len - offsetof(struct ovl_fh, uuid));
+}
+
+static struct ovl_fh *ovl_real_fh_hash(struct dentry *real, bool is_upper,
+				       unsigned long *pkey)
+{
+	struct ovl_fh *fh = ovl_encode_real_fh(real, is_upper);
+
+	if (!IS_ERR(fh))
+		*pkey = ovl_fh_hash(fh);
+
+	return fh;
+}
+
+/* Lookup overlay inode by real inode file handle */
+struct inode *ovl_lookup_inode_fh(struct super_block *sb, struct ovl_fh *fh)
+{
+	return ilookup5(sb, ovl_fh_hash(fh), ovl_inode_test_fh, fh);
+}
+
+/* Lookup overlay inode by real upper inode or by lower inode file handle */
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper)
 {
 	struct inode *inode, *key = d_inode(real);
+	struct ovl_fh *fh;
 
-	inode = ilookup5(sb, (unsigned long) key, ovl_inode_test, key);
+	if (is_upper) {
+		inode = ilookup5(sb, (unsigned long) key, ovl_inode_test, key);
+	} else {
+		fh = ovl_encode_real_fh(real, false);
+		if (IS_ERR(fh))
+			return ERR_CAST(fh);
+
+		inode = ovl_lookup_inode_fh(sb, fh);
+		kfree(fh);
+	}
 	if (!inode)
 		return NULL;
 
@@ -709,23 +762,35 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
+	struct ovl_fh *fh = NULL;
+	unsigned long key;
 	bool is_dir;
 
 	if (!realinode)
 		realinode = d_inode(lowerdentry);
 
+	/* Hash non-upper and indexed by origin fh for NFS export */
+	if (sb->s_export_op && bylower) {
+		fh = ovl_real_fh_hash(lowerdentry, false, &key);
+		if (IS_ERR(fh))
+			return ERR_CAST(fh);
+	} else if (bylower) {
+		key = (unsigned long) d_inode(lowerdentry);
+	} else if (upperdentry) {
+		key = (unsigned long) d_inode(upperdentry);
+	}
+
 	/*
 	 * Copy up origin (lower) may exist for non-indexed upper, but we must
 	 * not use lower as hash key if this is a broken hardlink.
 	 */
 	is_dir = S_ISDIR(realinode->i_mode);
 	if (upperdentry || bylower) {
-		struct inode *key = d_inode(bylower ? lowerdentry :
-						      upperdentry);
 		unsigned int nlink = is_dir ? 1 : realinode->i_nlink;
 
-		inode = iget5_locked(sb, (unsigned long) key,
-				     ovl_inode_test, ovl_inode_set, key);
+		inode = iget5_locked(sb, key, fh ? ovl_inode_test_fh :
+						   ovl_inode_test,
+				     ovl_inode_set, fh ?: (void *)key);
 		if (!inode)
 			goto out_nomem;
 		if (!(inode->i_state & I_NEW)) {
@@ -742,6 +807,10 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 
 			dput(upperdentry);
 			goto out;
+		} else if (fh) {
+			/* i_private keeps the reference to fh */
+			ovl_set_flag(OVL_I_PRIVATE_FH, inode);
+			fh = NULL;
 		}
 
 		/* Recalculate nlink for non-dir due to indexing */
@@ -771,6 +840,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	if (inode->i_state & I_NEW)
 		unlock_new_inode(inode);
 out:
+	kfree(fh);
 	return inode;
 
 out_nomem:
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 287938911abe..74ccbe0813cd 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -393,7 +393,7 @@ static int ovl_verify_fh(struct dentry *dentry, const char *name,
 	if (IS_ERR(ofh))
 		return PTR_ERR(ofh);
 
-	if (fh->len != ofh->len || memcmp(fh, ofh, fh->len))
+	if (!ovl_fs_equal(fh, ofh))
 		err = -ESTALE;
 
 	kfree(ofh);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index dd6c10e5a7db..b94db3f6f4ae 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -35,6 +35,8 @@ enum ovl_inode_flag {
 	/* Non-merge dir that may contain whiteout entries */
 	OVL_WHITEOUTS,
 	OVL_INDEX,
+	/* inode->i_priavte is a file handle copy */
+	OVL_I_PRIVATE_FH,
 };
 
 enum ovl_entry_flag {
@@ -83,6 +85,12 @@ struct ovl_fh {
 	u8 fid[0];	/* file identifier */
 } __packed;
 
+static inline bool ovl_fs_equal(const struct ovl_fh *fh1,
+				const struct ovl_fh *fh2)
+{
+	return fh1->len == fh2->len && !memcmp(fh1, fh2, fh1->len);
+}
+
 static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int err = vfs_rmdir(dir, dentry);
@@ -326,6 +334,7 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
+struct inode *ovl_lookup_inode_fh(struct super_block *sb, struct ovl_fh *fh);
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper);
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7c24619ae7fc..d17dffc611cc 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -220,6 +220,8 @@ static void ovl_destroy_inode(struct inode *inode)
 	kfree(oi->redirect);
 	ovl_dir_cache_free(inode);
 	mutex_destroy(&oi->lock);
+	if (ovl_test_flag(OVL_I_PRIVATE_FH, inode))
+		kfree(inode->i_private);
 
 	call_rcu(&inode->i_rcu, ovl_i_callback);
 }
-- 
2.7.4

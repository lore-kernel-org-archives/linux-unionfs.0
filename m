From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/3] vfs: factor out lookup_one_len_init()
Date: Fri, 19 May 2017 18:27:19 +0300
Message-ID: <1495207641-11213-2-git-send-email-amir73il@gmail.com>
References: <1495207641-11213-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35733 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdESP1X (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 19 May 2017 11:27:23 -0400
Received: by mail-wm0-f67.google.com with SMTP id v4so19014171wmb.2
        for <linux-unionfs@vger.kernel.org>; Fri, 19 May 2017 08:27:22 -0700 (PDT)
In-Reply-To: <1495207641-11213-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

In preparation of adding a new helper lookup_one_len_noperm(),
factor out the common bits of lookup_one_len{,_unlocked}().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/namei.c | 88 +++++++++++++++++++++++++++-----------------------------------
 1 file changed, 38 insertions(+), 50 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 6571a5f..263caf0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2446,50 +2446,61 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
 }
 EXPORT_SYMBOL(vfs_path_lookup);
 
-/**
- * lookup_one_len - filesystem helper to lookup single pathname component
- * @name:	pathname component to lookup
- * @base:	base directory to lookup from
- * @len:	maximum length @len should be interpreted to
- *
- * Note that this routine is purely a helper for filesystem usage and should
- * not be called by generic code.
- *
- * The caller must hold base->i_mutex.
- */
-struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
+static int lookup_one_len_init(struct qstr *this, struct dentry *base,
+			       const char *name, int len)
 {
-	struct qstr this;
 	unsigned int c;
-	int err;
-
-	WARN_ON_ONCE(!inode_is_locked(base->d_inode));
 
-	this.name = name;
-	this.len = len;
-	this.hash = full_name_hash(base, name, len);
+	this->name = name;
+	this->len = len;
+	this->hash = full_name_hash(base, name, len);
 	if (!len)
-		return ERR_PTR(-EACCES);
+		return -EACCES;
 
 	if (unlikely(name[0] == '.')) {
 		if (len < 2 || (len == 2 && name[1] == '.'))
-			return ERR_PTR(-EACCES);
+			return -EACCES;
 	}
 
 	while (len--) {
 		c = *(const unsigned char *)name++;
 		if (c == '/' || c == '\0')
-			return ERR_PTR(-EACCES);
+			return -EACCES;
 	}
 	/*
 	 * See if the low-level filesystem might want
 	 * to use its own hash..
 	 */
 	if (base->d_flags & DCACHE_OP_HASH) {
-		int err = base->d_op->d_hash(base, &this);
+		int err = base->d_op->d_hash(base, this);
+
 		if (err < 0)
-			return ERR_PTR(err);
+			return err;
 	}
+	return 0;
+}
+
+/**
+ * lookup_one_len - filesystem helper to lookup single pathname component
+ * @name:	pathname component to lookup
+ * @base:	base directory to lookup from
+ * @len:	maximum length @len should be interpreted to
+ *
+ * Note that this routine is purely a helper for filesystem usage and should
+ * not be called by generic code.
+ *
+ * The caller must hold base->i_mutex.
+ */
+struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
+{
+	struct qstr this;
+	int err;
+
+	WARN_ON_ONCE(!inode_is_locked(base->d_inode));
+
+	err = lookup_one_len_init(&this, base, name, len);
+	if (err)
+		return ERR_PTR(err);
 
 	err = inode_permission(base->d_inode, MAY_EXEC);
 	if (err)
@@ -2515,35 +2526,12 @@ struct dentry *lookup_one_len_unlocked(const char *name,
 				       struct dentry *base, int len)
 {
 	struct qstr this;
-	unsigned int c;
 	int err;
 	struct dentry *ret;
 
-	this.name = name;
-	this.len = len;
-	this.hash = full_name_hash(base, name, len);
-	if (!len)
-		return ERR_PTR(-EACCES);
-
-	if (unlikely(name[0] == '.')) {
-		if (len < 2 || (len == 2 && name[1] == '.'))
-			return ERR_PTR(-EACCES);
-	}
-
-	while (len--) {
-		c = *(const unsigned char *)name++;
-		if (c == '/' || c == '\0')
-			return ERR_PTR(-EACCES);
-	}
-	/*
-	 * See if the low-level filesystem might want
-	 * to use its own hash..
-	 */
-	if (base->d_flags & DCACHE_OP_HASH) {
-		int err = base->d_op->d_hash(base, &this);
-		if (err < 0)
-			return ERR_PTR(err);
-	}
+	err = lookup_one_len_init(&this, base, name, len);
+	if (err)
+		return ERR_PTR(err);
 
 	err = inode_permission(base->d_inode, MAY_EXEC);
 	if (err)
-- 
2.7.4

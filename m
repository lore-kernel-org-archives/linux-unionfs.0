From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 7/9] ovl: constant st_ino for non-samefs with xino
Date: Tue,  7 Nov 2017 18:58:07 +0200
Message-ID: <1510073889-11657-8-git-send-email-amir73il@gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54313 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754954AbdKGQ5l (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 11:57:41 -0500
Received: by mail-wm0-f66.google.com with SMTP id r68so5339922wmr.3
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 08:57:40 -0800 (PST)
In-Reply-To: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

When overlay layers are not all on the same fs, but all inode numbers
of underlying fs are not using 'xino' high bits, use the high bits to
partition the overlay st_ino address space.  The high bits hold the
layer index (upper is 0).  This way overlay inode numbers are unique
and all inodes use overlay st_dev.  Inode numbers are also persistent
for a given layer configuration.

Currently, our only indication for available high ino bits is from a
filesystem that supports file handles and uses the default encode_fh()
operation, which encodes a 32bit inode number.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 23 ++++++++++++++++++++++-
 fs/overlayfs/overlayfs.h |  3 ++-
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/super.c     | 30 +++++++++++++++++++++++-------
 fs/overlayfs/util.c      | 24 +++++++++++++++++++++---
 5 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 80a4b61a1149..521c4d21eb7b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -63,6 +63,7 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat)
 {
 	struct ovl_layer *lower_layer = ovl_layer_lower(dentry);
 	bool samefs = ovl_same_sb(dentry->d_sb);
+	int xinobits = ovl_xino_bits(dentry->d_sb);
 
 	if (samefs) {
 		/*
@@ -71,6 +72,24 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat)
 		 * which is friendly to du -x.
 		 */
 		stat->dev = dentry->d_sb->s_dev;
+	} else if (xinobits) {
+		/*
+		 * All inode numbers of underlying fs should not be using the
+		 * high xinobits, so we use high xinobits to partition the
+		 * overlay st_ino address space. The high bits holds the layer
+		 * index (upper is 0). This way overlay inode numbers are unique
+		 * and all inodes use overlay st_dev. Inode numbers are also
+		 * persistent for a given layer configuration.
+		 */
+		if (stat->ino >> (64 - xinobits)) {
+			pr_warn_ratelimited("overlayfs: inode number too big (%pd2, ino=%llu, xinobits=%d)\n",
+					    dentry, stat->ino, xinobits);
+			return -EOVERFLOW;
+		}
+
+		if (lower_layer)
+			stat->ino |= ((u64)lower_layer->idx) << (64 - xinobits);
+		stat->dev = dentry->d_sb->s_dev;
 	} else if (S_ISDIR(dentry->d_inode->i_mode)) {
 		/*
 		 * Always use the overlay st_dev for directories, so 'find
@@ -116,11 +135,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	/*
 	 * For non-dir or same fs, we use st_ino of the copy up origin.
 	 * This guaranties constant st_dev/st_ino across copy up.
+	 * With xino feature and non-samefs, we use st_ino of the copy up
+	 * origin masked with high bits that represent the layer id.
 	 *
 	 * If lower filesystem supports NFS file handles, this also guaranties
 	 * persistent st_ino across mount cycle.
 	 */
-	if (!is_dir || samefs) {
+	if (!is_dir || samefs || ovl_xino_bits(dentry->d_sb)) {
 		if (OVL_TYPE_ORIGIN(type)) {
 			struct kstat lowerstat;
 			u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6d43e0f3d6f5..29569bf1cc6e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -192,7 +192,8 @@ void ovl_drop_write(struct dentry *dentry);
 struct dentry *ovl_workdir(struct dentry *dentry);
 const struct cred *ovl_override_creds(struct super_block *sb);
 struct super_block *ovl_same_sb(struct super_block *sb);
-bool ovl_can_decode_fh(struct super_block *sb);
+int ovl_xino_bits(struct super_block *sb);
+int ovl_can_decode_fh(struct super_block *sb);
 struct dentry *ovl_indexdir(struct super_block *sb);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 63ef5ae9275b..226cf94838a3 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -52,6 +52,8 @@ struct ovl_fs {
 	/* Did we take the inuse lock? */
 	bool upperdir_locked;
 	bool workdir_locked;
+	/* Inode numbers in all layers do not use the high xino_bits */
+	int xino_bits;
 };
 
 /* private information held for every overlayfs dentry */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0b8fe8dca187..ddedfca9305c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -17,6 +17,7 @@
 #include <linux/statfs.h>
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/exportfs.h>
 #include "overlayfs.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
@@ -629,6 +630,7 @@ static int ovl_check_namelen(struct path *path, struct ovl_fs *ofs,
 static int ovl_lower_dir(const char *name, struct path *path,
 			 struct ovl_fs *ofs, int *stack_depth, bool *remote)
 {
+	int fh_type;
 	int err;
 
 	err = ovl_mount_dir_noesc(name, path);
@@ -648,10 +650,14 @@ static int ovl_lower_dir(const char *name, struct path *path,
 	 * The inodes index feature needs to encode and decode file
 	 * handles, so it requires that all layers support them.
 	 */
-	if (ofs->config.index && !ovl_can_decode_fh(path->dentry->d_sb)) {
+	fh_type = ovl_can_decode_fh(path->dentry->d_sb);
+	if (ofs->config.index && !fh_type) {
 		ofs->config.index = false;
 		pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off.\n", name);
 	}
+	/* Check if lower fs has 32bit inode numbers */
+	if (fh_type != FILEID_INO32_GEN)
+		ofs->xino_bits = 0;
 
 	return 0;
 
@@ -842,6 +848,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned int i;
 	bool remote = false;
 	struct cred *cred;
+	int fh_type;
 	int err;
 
 	err = -ENOMEM;
@@ -961,6 +968,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_put_lowerpath;
 	}
 
+	/* Assume underlaying fs uses 32bit inodes unless proven otherwise */
+	ufs->xino_bits = 32;
 	if (ufs->config.upperdir) {
 		ufs->upper_mnt = clone_private_mount(&upperpath);
 		err = PTR_ERR(ufs->upper_mnt);
@@ -1017,14 +1026,17 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			} else {
 				vfs_removexattr(ufs->workdir, OVL_XATTR_OPAQUE);
 			}
+		}
 
-			/* Check if upper/work fs supports file handles */
-			if (ufs->config.index &&
-			    !ovl_can_decode_fh(ufs->workdir->d_sb)) {
-				ufs->config.index = false;
-				pr_warn("overlayfs: upper fs does not support file handles, falling back to index=off.\n");
-			}
+		/* Check if upper fs supports file handles */
+		fh_type = ovl_can_decode_fh(ufs->upper_mnt->mnt_sb);
+		if (ufs->config.index && !fh_type) {
+			ufs->config.index = false;
+			pr_warn("overlayfs: upper fs does not support file handles, falling back to index=off.\n");
 		}
+		/* Check if upper fs has 32bit inode numbers */
+		if (fh_type != FILEID_INO32_GEN)
+			ufs->xino_bits = 0;
 	}
 
 	err = -ENOMEM;
@@ -1073,6 +1085,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
 		ufs->same_sb = NULL;
 
+	/* When all layers on same fs, overlay can use real inode numbers */
+	if (ufs->same_sb)
+		ufs->xino_bits = 0;
+
 	err = -ENOMEM;
 	oe = ovl_alloc_entry(numlower);
 	if (!oe)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 3c3b026c189b..255ae337fc46 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -50,10 +50,28 @@ struct super_block *ovl_same_sb(struct super_block *sb)
 	return ofs->same_sb;
 }
 
-bool ovl_can_decode_fh(struct super_block *sb)
+int ovl_xino_bits(struct super_block *sb)
 {
-	return (sb->s_export_op && sb->s_export_op->fh_to_dentry &&
-		!uuid_is_null(&sb->s_uuid));
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->xino_bits;
+}
+
+/*
+ * Check if underlying fs supports file handles and try to determine encoding
+ * type, in order to deduce maximum inode number used by fs.
+ *
+ * Return 0 if file handles are not supported.
+ * Return 1 (FILEID_INO32_GEN) if fs uses the default 32bit inode encoding.
+ * Return -1 if fs uses a non default encoding with unknown inode size.
+ */
+int ovl_can_decode_fh(struct super_block *sb)
+{
+	if (!sb->s_export_op || !sb->s_export_op->fh_to_dentry ||
+	    uuid_is_null(&sb->s_uuid))
+		return 0;
+
+	return sb->s_export_op->encode_fh ? -1 : FILEID_INO32_GEN;
 }
 
 struct dentry *ovl_indexdir(struct super_block *sb)
-- 
2.7.4

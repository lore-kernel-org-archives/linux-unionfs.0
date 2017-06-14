From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 10/23] ovl: lookup index entry for copy up origin
Date: Wed, 14 Jun 2017 10:26:29 +0300
Message-ID: <1497425202-16270-11-git-send-email-amir73il@gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34748 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754352AbdFNH0r (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:26:47 -0400
Received: by mail-wr0-f196.google.com with SMTP id u101so37035602wrc.1
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 00:26:46 -0700 (PDT)
In-Reply-To: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

When inodes index feature is enabled, lookup in indexdir for the index
entry of lower real inode or copy up origin inode. The index entry name
is the hex representation of the lower inode file handle.

If the index dentry in negative, then either no lower aliases have been
copied up yet, or aliases have been copied up in older kernels and are
not indexed.

If the index dentry for a copy up origin inode is positive, but points
to an inode different than the upper inode, then either the upper inode
has been copied up and not indexed or it was indexed, but since then
index dir was cleared. Either way, that index cannot be used to indentify
the overlay inode.

If a positive dentry that matches the upper inode was found, then it is
safe to use the copy up origin st_ino for upper hardlinks, because all
indexed upper hardlinks are represented by the same overlay inode as the
copy up origin.

Set the INDEX type flag on an indexed dentry. A non-upper overlay dentry
may also have a positive index from copy up of another lower hardlink.
This situation can be tested with the path type macros
OVL_TYPE_INDEX(type) && !OVL_TYPE_UPPER(type).

This is going to be used to prevent breaking hardlinks on copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     |   8 +++-
 fs/overlayfs/namei.c     | 102 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |   2 +
 3 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index d613e2c41242..b78993abdeea 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -96,11 +96,15 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 
 			WARN_ON_ONCE(stat->dev != lowerstat.dev);
 			/*
-			 * Lower hardlinks are broken on copy up to different
+			 * Lower hardlinks may be broken on copy up to different
 			 * upper files, so we cannot use the lower origin st_ino
 			 * for those different files, even for the same fs case.
+			 * With inodes index enabled, it is safe to use st_ino
+			 * of an indexed hardlinked origin. The index validates
+			 * that the upper hardlink is not broken.
 			 */
-			if (is_dir || lowerstat.nlink == 1)
+			if (is_dir || lowerstat.nlink == 1 ||
+			    OVL_TYPE_INDEX(type))
 				stat->ino = lowerstat.ino;
 		}
 		stat->dev = dentry->d_sb->s_dev;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 402e52a98c1a..fe84e482d926 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -367,6 +367,84 @@ int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
 }
 
 /*
+ * Lookup in indexdir for the index entry of a lower real inode or a copy up
+ * origin inode. The index entry name is the hex representation of the lower
+ * inode file handle.
+ *
+ * If the index dentry in negative, then either no lower aliases have been
+ * copied up yet, or aliases have been copied up in older kernels and are
+ * not indexed.
+ *
+ * If the index dentry for a copy up origin inode is positive, but points
+ * to an inode different than the upper inode, then either the upper inode
+ * has been copied up and not indexed or it was indexed, but since then
+ * index dir was cleared. Either way, that index cannot be used to indentify
+ * the overlay inode.
+ */
+static int ovl_lookup_index(struct dentry *dentry, struct dentry *upper,
+			    struct dentry *lower, struct dentry **indexp)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct ovl_fh *fh;
+	struct dentry *index = NULL;
+	struct inode *inode;
+	char *s, *name = NULL;
+	long namelen = 0;
+	int err;
+
+	if (WARN_ON(!ofs->indexdir))
+		return -ENOENT;
+
+	fh = ovl_encode_fh(lower, false);
+	if (IS_ERR(fh)) {
+		err = PTR_ERR(fh);
+		fh = NULL;
+		goto fail;
+	}
+
+	err = -ENAMETOOLONG;
+	namelen = fh->len * 2;
+	if (namelen > ofs->namelen)
+		goto fail;
+
+	err = -ENOMEM;
+	name = kzalloc(namelen + 1, GFP_TEMPORARY);
+	if (!name)
+		goto fail;
+
+	s  = bin2hex(name, fh, fh->len);
+	namelen = s - name;
+
+	index = lookup_one_len_unlocked(name, ofs->indexdir, namelen);
+	if (IS_ERR(index)) {
+		err = PTR_ERR(index);
+		goto fail;
+	}
+
+	if (upper && d_inode(index) != d_inode(upper)) {
+		inode = d_inode(index);
+		pr_debug("ovl_lookup_index: upper with origin not indexed (%pd2, ino=%lu)\n",
+			 upper, inode ? inode->i_ino : 0);
+		dput(index);
+		index = NULL;
+	}
+
+	*indexp = index;
+	err = 0;
+
+out:
+	kfree(fh);
+	kfree(name);
+	return err;
+
+fail:
+	inode = d_inode(lower);
+	pr_warn_ratelimited("overlayfs: failed inode index lookup (ino=%lu, key=%*s, err=%i); mount with '-o index=off' to disable inodes index.\n",
+			    inode ? inode->i_ino : 0, (int)namelen, name, err);
+	goto out;
+}
+
+/*
  * Returns next layer in stack starting from top.
  * Returns -1 if this is the last layer.
  */
@@ -400,6 +478,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
 	struct path *stack = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
+	struct dentry *index = NULL;
 	unsigned int ctr = 0;
 	struct inode *inode = NULL;
 	enum ovl_path_type type = 0;
@@ -500,6 +579,27 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
+	/* Lookup index by lower inode and verify it matches upper inode */
+	if (ctr && !d.is_dir && ovl_indexdir(dentry->d_sb)) {
+		struct dentry *origin = stack[0].dentry;
+
+		err = ovl_lookup_index(dentry, upperdentry, origin, &index);
+		if (err)
+			goto out_put;
+
+		if (index && d_inode(index)) {
+			type |= __OVL_PATH_INDEX;
+		} else if (upperdentry && d_inode(origin)->i_nlink > 1) {
+			/*
+			 * Non-indexed upper of lower hardlink is a broken
+			 * hardlink - disown origin, because we cannot use
+			 * origin st_ino for a broken hardlink.
+			 */
+			dput(origin);
+			ctr = 0;
+		}
+	}
+
 	oe = ovl_alloc_entry(ctr);
 	err = -ENOMEM;
 	if (!oe)
@@ -531,6 +631,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	oe->redirect = upperredirect;
 	oe->__upperdentry = upperdentry;
 	memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
+	dput(index);
 	kfree(stack);
 	kfree(d.redirect);
 	dentry->d_fsdata = oe;
@@ -542,6 +643,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 out_free_oe:
 	kfree(oe);
 out_put:
+	dput(index);
 	for (i = 0; i < ctr; i++)
 		dput(stack[i].dentry);
 	kfree(stack);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index c4bc1c3ea4e2..191a41f61839 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -16,6 +16,7 @@ enum ovl_path_type {
 	__OVL_PATH_ORIGIN	= (1 << 2),
 	__OVL_PATH_OPAQUE	= (1 << 3),
 	__OVL_PATH_IMPURE	= (1 << 4),
+	__OVL_PATH_INDEX	= (1 << 5),
 };
 
 #define OVL_TYPE_UPPER(type)	((type) & __OVL_PATH_UPPER)
@@ -23,6 +24,7 @@ enum ovl_path_type {
 #define OVL_TYPE_ORIGIN(type)	((type) & __OVL_PATH_ORIGIN)
 #define OVL_TYPE_OPAQUE(type)	((type) & __OVL_PATH_OPAQUE)
 #define OVL_TYPE_IMPURE(type)	((type) & __OVL_PATH_IMPURE)
+#define OVL_TYPE_INDEX(type)	((type) & __OVL_PATH_INDEX)
 
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
-- 
2.7.4

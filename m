From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 08/20] ovl: lookup index entry for non-dir
Date: Wed,  7 Jun 2017 10:51:12 +0300
Message-ID: <1496821884-5178-9-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36598 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdFGHvY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 03:51:24 -0400
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

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

If a negative index dentry is found or a positive dentry that matches the
upper inode, store it in the overlay dentry to be used later. A non-upper
overlay dentry may still have a positive index from copy up of another
lower hardlink. This situation can be tested with the path type macros
OVL_TYPE_INDEX(type) && !OVL_TYPE_UPPER(type).

This is going to be used to prevent breaking hardlinks on copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 89 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  3 ++
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     |  1 +
 fs/overlayfs/util.c      | 11 ++++++
 5 files changed, 105 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 61f4988527f4..d204488bf23c 100644
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
+	struct dentry *indexdentry = NULL;
 	unsigned int ctr = 0;
 	struct inode *inode = NULL;
 	bool upperopaque = false;
@@ -500,6 +579,14 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
+	/* Lookup index by lower inode and verify it matches upper inode */
+	if (ctr && !d.is_dir && ovl_indexdir(dentry->d_sb)) {
+		err = ovl_lookup_index(dentry, upperdentry, stack[0].dentry,
+				       &indexdentry);
+		if (err)
+			goto out_put;
+	}
+
 	oe = ovl_alloc_entry(ctr);
 	err = -ENOMEM;
 	if (!oe)
@@ -531,6 +618,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	oe->impure = upperimpure;
 	oe->redirect = upperredirect;
 	oe->__upperdentry = upperdentry;
+	oe->indexdentry = indexdentry;
 	memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
 	kfree(stack);
 	kfree(d.redirect);
@@ -542,6 +630,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 out_free_oe:
 	kfree(oe);
 out_put:
+	dput(indexdentry);
 	for (i = 0; i < ctr; i++)
 		dput(stack[i].dentry);
 	kfree(stack);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6fd7c9e748c1..47d62c585c96 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -14,11 +14,13 @@ enum ovl_path_type {
 	__OVL_PATH_UPPER	= (1 << 0),
 	__OVL_PATH_MERGE	= (1 << 1),
 	__OVL_PATH_ORIGIN	= (1 << 2),
+	__OVL_PATH_INDEX	= (1 << 3),
 };
 
 #define OVL_TYPE_UPPER(type)	((type) & __OVL_PATH_UPPER)
 #define OVL_TYPE_MERGE(type)	((type) & __OVL_PATH_MERGE)
 #define OVL_TYPE_ORIGIN(type)	((type) & __OVL_PATH_ORIGIN)
+#define OVL_TYPE_INDEX(type)	((type) & __OVL_PATH_INDEX)
 
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
@@ -204,6 +206,7 @@ void ovl_path_lower(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
+struct dentry *ovl_dentry_index(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct ovl_dir_cache *ovl_dir_cache(struct dentry *dentry);
 void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index ddd4b0a874a9..dc08ce5c4ac0 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -43,6 +43,7 @@ struct ovl_fs {
 /* private information held for every overlayfs dentry */
 struct ovl_entry {
 	struct dentry *__upperdentry;
+	struct dentry *indexdentry;
 	struct ovl_dir_cache *cache;
 	union {
 		struct {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b411b6d5f7b1..b53c08f70b1a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -47,6 +47,7 @@ static void ovl_dentry_release(struct dentry *dentry)
 		unsigned int i;
 
 		dput(oe->__upperdentry);
+		dput(oe->indexdentry);
 		kfree(oe->redirect);
 		for (i = 0; i < oe->numlower; i++)
 			dput(oe->lowerstack[i].dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 8e2f308056f1..6048f204be07 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -108,6 +108,10 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
 		if (oe->numlower > 1)
 			type |= __OVL_PATH_MERGE;
 	}
+	/* Non-upper can have a positive index dentry from another hardlink */
+	if (oe->indexdentry && d_inode(oe->indexdentry))
+		type |= __OVL_PATH_INDEX;
+
 	return type;
 }
 
@@ -158,6 +162,13 @@ struct dentry *ovl_dentry_lower(struct dentry *dentry)
 	return __ovl_dentry_lower(oe);
 }
 
+struct dentry *ovl_dentry_index(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	return oe->indexdentry;
+}
+
 struct dentry *ovl_dentry_real(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
-- 
2.7.4

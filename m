From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 05/17] ovl: create helper ovl_lookup_index()
Date: Fri,  2 Jun 2017 17:04:32 +0300
Message-ID: <1496412284-4113-6-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33232 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdFBOEu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:50 -0400
Received: by mail-wr0-f196.google.com with SMTP id v104so1344924wrb.0
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:50 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

The index dir should contain an entry for each upper inode with a known
lower origin inode. The index entry name is the hex representation of the
lower inode file handle.

Given a lower dentry, the helper encodes the lower file handle and looks
up the index dentry in the index dir.

This is going to be used to prevent breaking hardlinks on copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  1 +
 2 files changed, 49 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index f5b49533c0e3..b50918b283e7 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -565,6 +565,54 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	return ERR_PTR(err);
 }
 
+/*
+ * Given a lower dentry, find the dentry for the upper inode in the index dir.
+ * If the index dentry in negative, then either no lower alias has been copied
+ * up yet, or aliases have been copied up in older kernels and are not indexed.
+ */
+struct dentry *ovl_lookup_index(struct super_block *sb, struct dentry *lower)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct ovl_fh *fh;
+	struct dentry *temp;
+	char *s, *name = NULL;
+	long namelen;
+	int err;
+
+	if (!ofs->indexdir)
+		return ERR_PTR(-ENOENT);
+
+	fh = ovl_encode_fh(lower, false);
+	if (IS_ERR(fh))
+		return (struct dentry *) fh;
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
+	temp = lookup_one_len_unlocked(name, ofs->indexdir, namelen);
+
+out:
+	kfree(fh);
+	kfree(name);
+	return temp;
+
+fail:
+	pr_warn_ratelimited("overlayfs: failed lookup index (key=%*s, err=%i)\n",
+			    (int)namelen, name, err);
+	temp = ERR_PTR(err);
+	goto out;
+}
+
 bool ovl_lower_positive(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 31920a649a1c..7ddb3a26a3da 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -254,6 +254,7 @@ int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
 		      struct dentry *origin, bool is_upper);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
+struct dentry *ovl_lookup_index(struct super_block *sb, struct dentry *lower);
 bool ovl_lower_positive(struct dentry *dentry);
 
 /* readdir.c */
-- 
2.7.4

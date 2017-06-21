From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 11/25] ovl: cleanup bad and stale index entries on mount
Date: Wed, 21 Jun 2017 15:28:42 +0300
Message-ID: <1498048136-28218-12-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33577 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdFUM3A (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:29:00 -0400
Received: by mail-wr0-f196.google.com with SMTP id x23so26117965wrb.0
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 05:28:59 -0700 (PDT)
In-Reply-To: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Bad index entries are entries whose name does not match the
origin file handle stored in trusted.overlay.origin xattr.
Bad index entries could be a result of a system power off in
the middle of copy up.

Stale index entries are entries whose origin file handle is
stale. Stale index entries could be a result of copying layers
or removing lower entries while the overlay is not mounted.
The case of copying layers should be detected earlier by the
verification of upper root dir origin and index dir origin.

Both bad and stale index entries are detected and removed
on mount.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       |  4 ++-
 fs/overlayfs/namei.c     | 74 ++++++++++++++++++++++++++++++++++++++++++------
 fs/overlayfs/overlayfs.h |  6 +++-
 fs/overlayfs/readdir.c   | 50 ++++++++++++++++++++++++++++++++
 fs/overlayfs/super.c     |  6 ++++
 5 files changed, 130 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index a63a71656e9b..822be8647d88 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -24,7 +24,7 @@ module_param_named(redirect_max, ovl_redirect_max, ushort, 0644);
 MODULE_PARM_DESC(ovl_redirect_max,
 		 "Maximum length of absolute redirect xattr value");
 
-void ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
+int ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
 {
 	int err;
 
@@ -39,6 +39,8 @@ void ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
 		pr_err("overlayfs: cleanup of '%pd2' failed (%i)\n",
 		       wdentry, err);
 	}
+
+	return err;
 }
 
 struct dentry *ovl_lookup_temp(struct dentry *workdir)
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index debe489fbb47..261ea51199c6 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -285,17 +285,17 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 }
 
 
-static int ovl_check_origin(struct dentry *dentry, struct dentry *upperdentry,
+static int ovl_check_origin(struct dentry *upperdentry,
+			    struct path *lowerstack, unsigned int numlower,
 			    struct path **stackp, unsigned int *ctrp)
 {
-	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
 	struct vfsmount *mnt;
 	struct dentry *origin = NULL;
 	int i;
 
 
-	for (i = 0; i < roe->numlower; i++) {
-		mnt = roe->lowerstack[i].mnt;
+	for (i = 0; i < numlower; i++) {
+		mnt = lowerstack[i].mnt;
 		origin = ovl_get_origin(upperdentry, mnt);
 		if (IS_ERR(origin))
 			return PTR_ERR(origin);
@@ -307,8 +307,9 @@ static int ovl_check_origin(struct dentry *dentry, struct dentry *upperdentry,
 	if (!origin)
 		return 0;
 
-	BUG_ON(*stackp || *ctrp);
-	*stackp = kmalloc(sizeof(struct path), GFP_TEMPORARY);
+	BUG_ON(*ctrp);
+	if (!*stackp)
+		*stackp = kmalloc(sizeof(struct path), GFP_TEMPORARY);
 	if (!*stackp) {
 		dput(origin);
 		return -ENOMEM;
@@ -380,6 +381,63 @@ int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
 }
 
 /*
+ * Verify that an index entry name matches the origin file handle stored in
+ * OVL_XATTR_ORIGIN and that origin file handle can be decoded to lower path.
+ * Return 0 on match, -ESTALE on mismatch or stale origin, < 0 on error.
+ */
+int ovl_verify_index(struct dentry *index, struct path *lowerstack,
+		     unsigned int numlower)
+{
+	struct ovl_fh *fh = NULL;
+	size_t len;
+	struct path origin = { };
+	struct path *stack = &origin;
+	unsigned int ctr = 0;
+	int err;
+
+	if (!d_inode(index))
+		return 0;
+
+	err = -EISDIR;
+	if (d_is_dir(index))
+		goto fail;
+
+	err = -EINVAL;
+	if (index->d_name.len < sizeof(struct ovl_fh)*2)
+		goto fail;
+
+	err = -ENOMEM;
+	len = index->d_name.len / 2;
+	fh = kzalloc(len, GFP_TEMPORARY);
+	if (!fh)
+		goto fail;
+
+	err = -EINVAL;
+	if (hex2bin((u8 *)fh, index->d_name.name, len) || len != fh->len)
+		goto fail;
+
+	err = ovl_verify_origin_fh(index, fh);
+	if (err)
+		goto fail;
+
+	err = ovl_check_origin(index, lowerstack, numlower, &stack, &ctr);
+	if (!err && !ctr)
+		err = -ESTALE;
+	if (err)
+		goto fail;
+
+	dput(origin.dentry);
+out:
+	kfree(fh);
+	return err;
+
+fail:
+	pr_warn_ratelimited("overlayfs: failed to verify index (%pd2, err=%i)\n",
+			    index, err);
+	goto out;
+}
+
+/*
  * Lookup in indexdir for the index entry of a lower real inode or a copy up
  * origin inode. The index entry name is the hex representation of the lower
  * inode file handle.
@@ -535,8 +593,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			 * number - it's the same as if we held a reference
 			 * to a dentry in lower layer that was moved under us.
 			 */
-			err = ovl_check_origin(dentry, upperdentry,
-					       &stack, &ctr);
+			err = ovl_check_origin(upperdentry, roe->lowerstack,
+					       roe->numlower, &stack, &ctr);
 			if (err)
 				goto out;
 		}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 596b728f394c..a92af10fd369 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -246,6 +246,8 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 /* namei.c */
 int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
 		      struct dentry *origin, bool is_upper, bool set);
+int ovl_verify_index(struct dentry *index, struct path *lowerstack,
+		     unsigned int numlower);
 int ovl_lookup_index(struct dentry *dentry, struct dentry *upper,
 		     struct dentry *lower, struct dentry **indexp);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
@@ -260,6 +262,8 @@ void ovl_cache_free(struct list_head *list);
 int ovl_check_d_type_supported(struct path *realpath);
 void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 			 struct dentry *dentry, int level);
+int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
+			 struct path *lowerstack, unsigned int numlower);
 
 /* inode.c */
 int ovl_setattr(struct dentry *dentry, struct iattr *attr);
@@ -299,7 +303,7 @@ struct cattr {
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct cattr *attr,
 		    struct dentry *hardlink, bool debug);
-void ovl_cleanup(struct inode *dir, struct dentry *dentry);
+int ovl_cleanup(struct inode *dir, struct dentry *dentry);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 3de5ebe7e7b9..e59d3e1c9173 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -786,3 +786,53 @@ void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 		ovl_cleanup(dir, dentry);
 	}
 }
+
+int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
+			 struct path *lowerstack, unsigned int numlower)
+{
+	int err;
+	struct inode *dir = dentry->d_inode;
+	struct path path = { .mnt = mnt, .dentry = dentry };
+	LIST_HEAD(list);
+	struct ovl_cache_entry *p;
+	struct ovl_readdir_data rdd = {
+		.ctx.actor = ovl_fill_merge,
+		.dentry = NULL,
+		.list = &list,
+		.root = RB_ROOT,
+		.is_lowest = false,
+	};
+
+	err = ovl_dir_read(&path, &rdd);
+	if (err)
+		goto out;
+
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+	list_for_each_entry(p, &list, l_node) {
+		struct dentry *index;
+
+		if (p->name[0] == '.') {
+			if (p->len == 1)
+				continue;
+			if (p->len == 2 && p->name[1] == '.')
+				continue;
+		}
+		index = lookup_one_len(p->name, dentry, p->len);
+		if (IS_ERR(index)) {
+			err = PTR_ERR(index);
+			break;
+		}
+		if (ovl_verify_index(index, lowerstack, numlower)) {
+			err = ovl_cleanup(dir, index);
+			if (err)
+				break;
+		}
+		dput(index);
+	}
+	inode_unlock(dir);
+out:
+	ovl_cache_free(&list);
+	if (err)
+		pr_err("overlayfs: failed index dir cleanup (%i)\n", err);
+	return err;
+}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 2e6062a073d4..b3ac406654bd 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1050,6 +1050,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 						upperpath.dentry, true, true);
 			if (err)
 				pr_err("overlayfs: failed to verify index dir origin\n");
+
+			/* Cleanup bad/stale index entries */
+			if (!err)
+				err = ovl_indexdir_cleanup(ufs->indexdir,
+							   ufs->upper_mnt,
+							   stack, numlower);
 		}
 		if (err || !ufs->indexdir)
 			pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
-- 
2.7.4

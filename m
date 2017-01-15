From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/6] ovl: check if upperdir fs supports O_TMPFILE
Date: Sun, 15 Jan 2017 15:57:28 +0200
Message-ID: <1484488652-611-3-git-send-email-amir73il@gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33002 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdAON5x (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 15 Jan 2017 08:57:53 -0500
In-Reply-To: <1484488652-611-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

This is needed for choosing between concurrent copyup
using O_TMPFILE and legacy copyup using workdir+rename.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  9 +++++++++
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 10 ++++++++++
 fs/overlayfs/util.c      | 18 ++++++++++++++++++
 4 files changed, 38 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8af450b..190b03f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -127,6 +127,14 @@ static inline int ovl_do_whiteout(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
+static inline int ovl_do_tmpfile(struct inode *dir, struct dentry *dentry,
+				 umode_t mode)
+{
+	int err = vfs_tmpfile(dir, dentry, mode);
+	pr_debug("tmpfile(%pd2, 0%o) = %i\n", dentry, mode, err);
+	return err;
+}
+
 static inline struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
 {
 	unsigned long x = (unsigned long) READ_ONCE(inode->i_private);
@@ -169,6 +177,7 @@ void ovl_dentry_version_inc(struct dentry *dentry);
 u64 ovl_dentry_version_get(struct dentry *dentry);
 bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
+struct dentry *ovl_alloc_tmpfile(struct dentry *parent, umode_t mode);
 
 /* namei.c */
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index d14bca1..65f24000 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -27,6 +27,7 @@ struct ovl_fs {
 	struct ovl_config config;
 	/* creds of process who forced instantiation of super block */
 	const struct cred *creator_cred;
+	bool tmpfile;
 };
 
 /* private information held for every overlayfs dentry */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 20f48ab..a6c42f5 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -825,6 +825,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		 * creation of workdir in previous step.
 		 */
 		if (ufs->workdir) {
+			struct dentry *temp;
+
 			err = ovl_check_d_type_supported(&workpath);
 			if (err < 0)
 				goto out_put_workdir;
@@ -836,6 +838,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			 */
 			if (!err)
 				pr_warn("overlayfs: upper fs needs to support d_type.\n");
+
+			/* Check if upper/work fs supports O_TMPFILE */
+			temp = ovl_alloc_tmpfile(ufs->workdir, S_IFREG | 0);
+			ufs->tmpfile = !IS_ERR(temp);
+			if (ufs->tmpfile)
+				dput(temp);
+			else
+				pr_warn("overlayfs: upper fs does not support tmpfile.\n");
 		}
 	}
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 952286f..e6facb1 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -263,3 +263,21 @@ struct file *ovl_path_open(struct path *path, int flags)
 {
 	return dentry_open(path, flags | O_NOATIME, current_cred());
 }
+
+struct dentry *ovl_alloc_tmpfile(struct dentry *parent, umode_t mode)
+{
+	static const struct qstr name = QSTR_INIT("/", 1);
+	struct dentry *temp;
+	struct inode *dir = parent->d_inode;
+	int err;
+
+	temp = d_alloc(parent, &name);
+	if (unlikely(!temp))
+		return ERR_PTR(-ENOMEM);
+
+	err = ovl_do_tmpfile(dir, temp, mode);
+	if (unlikely(err))
+		return ERR_PTR(err);
+
+	return temp;
+}
-- 
2.7.4

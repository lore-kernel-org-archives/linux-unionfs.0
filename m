From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Tue, 17 Jan 2017 06:34:52 +0200
Message-ID: <1484627697-17262-2-git-send-email-amir73il@gmail.com>
References: <1484627697-17262-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34483 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdAQEg0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Jan 2017 23:36:26 -0500
In-Reply-To: <1484627697-17262-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Factor out some common vfs bits from do_tmpfile()
to be used by overlayfs for concurrent copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c         | 68 ++++++++++++++++++++++++++++++++++--------------------
 include/linux/fs.h |  3 +++
 2 files changed, 46 insertions(+), 25 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ad74877..7d87699 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3353,13 +3353,50 @@ static int do_last(struct nameidata *nd,
 	return error;
 }
 
+struct dentry *vfs_tmpfile(struct dentry *dentry, umode_t mode, int open_flag)
+{
+	static const struct qstr name = QSTR_INIT("/", 1);
+	struct dentry *child = NULL;
+	struct inode *dir = dentry->d_inode;
+	struct inode *inode;
+	int error;
+
+	/* we want directory to be writable */
+	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	if (error)
+		goto out_err;
+	error = -EOPNOTSUPP;
+	if (!dir->i_op->tmpfile)
+		goto out_err;
+	error = -ENOMEM;
+	child = d_alloc(dentry, &name);
+	if (unlikely(!child))
+		goto out_err;
+	error = dir->i_op->tmpfile(dir, child, mode);
+	if (error)
+		goto out_err;
+	error = -ENOENT;
+	inode = child->d_inode;
+	if (unlikely(!inode))
+		goto out_err;
+	if (!(open_flag & O_EXCL)) {
+		spin_lock(&inode->i_lock);
+		inode->i_state |= I_LINKABLE;
+		spin_unlock(&inode->i_lock);
+	}
+	return child;
+
+out_err:
+	dput(child);
+	return ERR_PTR(error);
+}
+EXPORT_SYMBOL(vfs_tmpfile);
+
 static int do_tmpfile(struct nameidata *nd, unsigned flags,
 		const struct open_flags *op,
 		struct file *file, int *opened)
 {
-	static const struct qstr name = QSTR_INIT("/", 1);
 	struct dentry *child;
-	struct inode *dir;
 	struct path path;
 	int error = path_lookupat(nd, flags | LOOKUP_DIRECTORY, &path);
 	if (unlikely(error))
@@ -3367,25 +3404,12 @@ static int do_tmpfile(struct nameidata *nd, unsigned flags,
 	error = mnt_want_write(path.mnt);
 	if (unlikely(error))
 		goto out;
-	dir = path.dentry->d_inode;
-	/* we want directory to be writable */
-	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
-	if (error)
-		goto out2;
-	if (!dir->i_op->tmpfile) {
-		error = -EOPNOTSUPP;
-		goto out2;
-	}
-	child = d_alloc(path.dentry, &name);
-	if (unlikely(!child)) {
-		error = -ENOMEM;
+	child = vfs_tmpfile(path.dentry, op->mode, op->open_flag);
+	error = PTR_ERR(child);
+	if (unlikely(IS_ERR(child)))
 		goto out2;
-	}
 	dput(path.dentry);
 	path.dentry = child;
-	error = dir->i_op->tmpfile(dir, child, op->mode);
-	if (error)
-		goto out2;
 	audit_inode(nd->name, child, 0);
 	/* Don't check for other permissions, the inode was just created */
 	error = may_open(&path, 0, op->open_flag);
@@ -3396,14 +3420,8 @@ static int do_tmpfile(struct nameidata *nd, unsigned flags,
 	if (error)
 		goto out2;
 	error = open_check_o_direct(file);
-	if (error) {
+	if (error)
 		fput(file);
-	} else if (!(op->open_flag & O_EXCL)) {
-		struct inode *inode = file_inode(file);
-		spin_lock(&inode->i_lock);
-		inode->i_state |= I_LINKABLE;
-		spin_unlock(&inode->i_lock);
-	}
 out2:
 	mnt_drop_write(path.mnt);
 out:
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2ba0743..4a7f3cc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1561,6 +1561,9 @@ extern int vfs_unlink(struct inode *, struct dentry *, struct inode **);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
 extern int vfs_whiteout(struct inode *, struct dentry *);
 
+extern struct dentry *vfs_tmpfile(struct dentry *dentry, umode_t mode,
+				  int open_flag);
+
 /*
  * VFS file helper functions.
  */
-- 
2.7.4

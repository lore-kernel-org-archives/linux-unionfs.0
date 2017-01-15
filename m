From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Sun, 15 Jan 2017 15:57:27 +0200
Message-ID: <1484488652-611-2-git-send-email-amir73il@gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1484488652-611-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Factor out some common vfs bits from do_tmpfile()
to be used by overlayfs for concurrent copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/namei.c         | 26 ++++++++++++++++----------
 include/linux/fs.h |  1 +
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ad74877..4cbaf54 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3353,6 +3353,20 @@ static int do_last(struct nameidata *nd,
 	return error;
 }
 
+int vfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
+{
+	int error;
+
+	/* we want directory to be writable */
+	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	if (error)
+		return error;
+	if (!dir->i_op->tmpfile)
+		return -EOPNOTSUPP;
+	return dir->i_op->tmpfile(dir, dentry, mode);
+}
+EXPORT_SYMBOL(vfs_tmpfile);
+
 static int do_tmpfile(struct nameidata *nd, unsigned flags,
 		const struct open_flags *op,
 		struct file *file, int *opened)
@@ -3368,14 +3382,6 @@ static int do_tmpfile(struct nameidata *nd, unsigned flags,
 	if (unlikely(error))
 		goto out;
 	dir = path.dentry->d_inode;
-	/* we want directory to be writable */
-	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
-	if (error)
-		goto out2;
-	if (!dir->i_op->tmpfile) {
-		error = -EOPNOTSUPP;
-		goto out2;
-	}
 	child = d_alloc(path.dentry, &name);
 	if (unlikely(!child)) {
 		error = -ENOMEM;
@@ -3383,8 +3389,8 @@ static int do_tmpfile(struct nameidata *nd, unsigned flags,
 	}
 	dput(path.dentry);
 	path.dentry = child;
-	error = dir->i_op->tmpfile(dir, child, op->mode);
-	if (error)
+	error = vfs_tmpfile(dir, child, op->mode);
+	if (unlikely(error))
 		goto out2;
 	audit_inode(nd->name, child, 0);
 	/* Don't check for other permissions, the inode was just created */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2ba0743..13f56f1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1560,6 +1560,7 @@ extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *, struct inode **);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
 extern int vfs_whiteout(struct inode *, struct dentry *);
+extern int vfs_tmpfile(struct inode *, struct dentry *, umode_t);
 
 /*
  * VFS file helper functions.
-- 
2.7.4


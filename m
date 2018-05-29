From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 04/39] vfs: add path_open()
Date: Tue, 29 May 2018 16:43:04 +0200
Message-ID: <20180529144339.16538-5-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Currently opening an overlay file results in:

 - the real file on the underlying layer being opened
 - f_path being set to the overlay {mount, dentry} pair

This patch adds a new helper that allows the above to be explicitly
performed.  I.e. it's the same as dentry_open(), except the underlying
inode to open is given as a separate argument.

This is in preparation for stacking I/O operations on overlay files.

Later, when implicit opening is removed, dentry_open() can be implemented
by just calling path_open().

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/open.c          | 31 +++++++++++++++++++++++++++++++
 include/linux/fs.h |  2 ++
 2 files changed, 33 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index c5ee7cd60424..d0bf7f061a1a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -906,6 +906,37 @@ int vfs_open(const struct path *path, struct file *file,
 	return do_dentry_open(file, d_backing_inode(dentry), NULL, cred);
 }
 
+/**
+ * path_open() - Open an inode by a particular name.
+ * @path: The name of the file.
+ * @flags: The O_ flags used to open this file.
+ * @inode: The inode to open.
+ * @cred: The task's credentials used when opening this file.
+ *
+ * Context: Process context.
+ * Return: A pointer to a struct file or an IS_ERR pointer.  Cannot return NULL.
+ */
+struct file *path_open(const struct path *path, int flags, struct inode *inode,
+		       const struct cred *cred)
+{
+	struct file *file;
+	int retval;
+
+	file = get_empty_filp();
+	if (IS_ERR(file))
+		return file;
+
+	file->f_flags = flags;
+	file->f_path = *path;
+	retval = do_dentry_open(file, inode, NULL, cred);
+	if (retval) {
+		put_filp(file);
+		return ERR_PTR(retval);
+	}
+	return file;
+}
+EXPORT_SYMBOL(path_open);
+
 struct file *dentry_open(const struct path *path, int flags,
 			 const struct cred *cred)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b0f290944220..9473e68280d0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2401,6 +2401,8 @@ extern struct file *filp_open(const char *, int, umode_t);
 extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int, umode_t);
 extern struct file * dentry_open(const struct path *, int, const struct cred *);
+extern struct file *path_open(const struct path *, int, struct inode *,
+			      const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
 
 extern struct filename *getname_flags(const char __user *, int, int *);
-- 
2.14.3

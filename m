From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 02/35] vfs: add path_open()
Date: Thu, 12 Apr 2018 17:07:53 +0200
Message-ID: <20180412150826.20988-3-mszeredi@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
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
 fs/open.c          | 27 +++++++++++++++++++++++++++
 include/linux/fs.h |  2 ++
 2 files changed, 29 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index 7ea118471dce..8c315f9ec2f6 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -866,6 +866,33 @@ int vfs_open(const struct path *path, struct file *file,
 	return do_dentry_open(file, d_backing_inode(dentry), NULL, cred);
 }
 
+struct file *path_open(const struct path *path, int flags, struct inode *inode,
+		       const struct cred *cred)
+{
+	struct file *file;
+	int retval;
+
+	file = get_empty_filp();
+	if (!IS_ERR(file)) {
+		file->f_flags = flags;
+		file->f_path = *path;
+		retval = do_dentry_open(file, inode, NULL, cred);
+		if (retval) {
+			put_filp(file);
+			file = ERR_PTR(retval);
+		} else {
+			retval = open_check_o_direct(file);
+			if (retval) {
+				fput(file);
+				file = ERR_PTR(retval);
+			}
+		}
+	}
+
+	return file;
+}
+EXPORT_SYMBOL(path_open);
+
 struct file *dentry_open(const struct path *path, int flags,
 			 const struct cred *cred)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f0f87f2beb79..c6d7e3b00163 100644
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

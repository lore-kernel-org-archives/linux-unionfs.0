From: Mark Salyzyn <salyzyn@android.com>
Subject: [PATCH v10 2/5] Add optional __get xattr method paired to __vfs_getxattr
Date: Wed, 24 Jul 2019 12:57:13 -0700
Message-ID: <20190724195719.218307-3-salyzyn@android.com>
References: <20190724195719.218307-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190724195719.218307-1-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-team@android.com, Mark Salyzyn <salyzyn@android.com>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Amir Goldstein <amir73il@gmail.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Mark Salyzyn <salyzyn@google.com>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Add an optional __get xattr method that would be called, if set, only
in __vfs_getxattr instead of the regular get xattr method.

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-unionfs@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
---
v10 - added to patch series
---
 fs/xattr.c            | 11 ++++++++++-
 include/linux/xattr.h |  7 +++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 90dd78f0eb27..b8f4734e222f 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -306,6 +306,9 @@ __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
 	handler = xattr_resolve_name(inode, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
+	if (unlikely(handler->__get))
+		return handler->__get(handler, dentry, inode, name, value,
+				      size);
 	if (!handler->get)
 		return -EOPNOTSUPP;
 	return handler->get(handler, dentry, inode, name, value, size);
@@ -317,6 +320,7 @@ vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
+	const struct xattr_handler *handler;
 
 	error = xattr_permission(inode, name, MAY_READ);
 	if (error)
@@ -339,7 +343,12 @@ vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
 		return ret;
 	}
 nolsm:
-	return __vfs_getxattr(dentry, inode, name, value, size);
+	handler = xattr_resolve_name(inode, &name);
+	if (IS_ERR(handler))
+		return PTR_ERR(handler);
+	if (!handler->get)
+		return -EOPNOTSUPP;
+	return handler->get(handler, dentry, inode, name, value, size);
 }
 EXPORT_SYMBOL_GPL(vfs_getxattr);
 
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 6dad031be3c2..30f25e1ac571 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -30,10 +30,13 @@ struct xattr_handler {
 	const char *prefix;
 	int flags;      /* fs private flags */
 	bool (*list)(struct dentry *dentry);
-	int (*get)(const struct xattr_handler *, struct dentry *dentry,
+	int (*get)(const struct xattr_handler *handler, struct dentry *dentry,
 		   struct inode *inode, const char *name, void *buffer,
 		   size_t size);
-	int (*set)(const struct xattr_handler *, struct dentry *dentry,
+	int (*__get)(const struct xattr_handler *handler, struct dentry *dentry,
+		     struct inode *inode, const char *name, void *buffer,
+		     size_t size);
+	int (*set)(const struct xattr_handler *handler, struct dentry *dentry,
 		   struct inode *inode, const char *name, const void *buffer,
 		   size_t size, int flags);
 };
-- 
2.22.0.657.g960e92d24f-goog

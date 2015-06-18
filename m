From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/8] Security: Provide copy-up security hooks for unioned
 files
Date: Thu, 18 Jun 2015 14:32:40 +0100
Message-ID: <20150618133239.12722.24971.stgit@warthog.procyon.org.uk>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: sds@tycho.nsa.gov, viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Provide two new security hooks for use with security files that are used when
a file is copied up between layers:

 (1) security_inode_copy_up().  This is called so that the security label on
     the destination file can be set appropriately.

 (2) security_inode_copy_up_xattr().  This is called so that each xattr being
     copied up can be vetted - including modification and discard.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/security.h |   36 ++++++++++++++++++++++++++++++++++++
 security/capability.c    |   13 +++++++++++++
 security/security.c      |   13 +++++++++++++
 3 files changed, 62 insertions(+)

diff --git a/include/linux/security.h b/include/linux/security.h
index 52febde52479..537c77b4cd5e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -562,6 +562,25 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@inode contains a pointer to the inode.
  *	@secid contains a pointer to the location where result will be saved.
  *	In case of failure, @secid will be set to zero.
+ * @inode_copy_up:
+ *	Appropriately label the destination inode when a unioned file is copied
+ *	up from a lower layer to the union/overlay layer.
+ *	@src indicates the file that is being copied up.
+ *	@dst indicates the file that has being created by the copy up.
+ *	Returns 0 on success or a negative error code on error.
+ * @inode_copy_up_xattr:
+ *	Filter/modify the xattrs being copied up when a unioned file is copied
+ *	up from a lower layer to the union/overlay layer.
+ *	@src indicates the file that is being copied up.
+ *	@dst indicates the file that has being created by the copy up.
+ *	@name indicates the name of the xattr.
+ *	@value, *@size indicate the payload of the xattr.
+ *	Returns 0 to accept the xattr, 1 to discard the xattr or a negative
+ *	error code to abort the copy up.  The xattr buffer must be at least
+ *	XATTR_SIZE_MAX in capacity and the contents may be modified and *@size
+ *	changed appropriately.  Note that the caller is responsible for reading
+ *	and writing the xattrs as this hook is merely a filter.
+ *
  *
  * Security hooks for file operations
  *
@@ -1571,6 +1590,9 @@ struct security_operations {
 	int (*inode_setsecurity) (struct inode *inode, const char *name, const void *value, size_t size, int flags);
 	int (*inode_listsecurity) (struct inode *inode, char *buffer, size_t buffer_size);
 	void (*inode_getsecid) (const struct inode *inode, u32 *secid);
+	int (*inode_copy_up) (struct dentry *src, struct dentry *dst);
+	int (*inode_copy_up_xattr) (struct dentry *src, struct dentry *dst,
+				    const char *name, void *value, size_t *size);
 
 	int (*file_permission) (struct file *file, int mask);
 	int (*file_alloc_security) (struct file *file);
@@ -1858,6 +1880,10 @@ int security_inode_getsecurity(const struct inode *inode, const char *name, void
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
 void security_inode_getsecid(const struct inode *inode, u32 *secid);
+int security_inode_copy_up(struct dentry *src, struct dentry *dst);
+int security_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
+				 const char *name, void *value, size_t *size);
+
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -2323,6 +2349,16 @@ static inline void security_inode_getsecid(const struct inode *inode, u32 *secid
 	*secid = 0;
 }
 
+static inline int security_inode_copy_up(struct dentry *src, struct dentry *dst)
+{
+	return 0;
+}
+static inline int security_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
+					       const char *name, const void *value, size_t *size)
+{
+	return 0;
+}
+
 static inline int security_file_permission(struct file *file, int mask)
 {
 	return 0;
diff --git a/security/capability.c b/security/capability.c
index 7d3f38fe02ba..c59f7c548c7a 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -268,6 +268,17 @@ static void cap_inode_getsecid(const struct inode *inode, u32 *secid)
 	*secid = 0;
 }
 
+static int cap_inode_copy_up(struct dentry *src, struct dentry *dst)
+{
+	return 0;
+}
+
+static int cap_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
+				   const char *name, void *value, size_t *size)
+{
+	return 0;
+}
+
 #ifdef CONFIG_SECURITY_PATH
 static int cap_path_mknod(struct path *dir, struct dentry *dentry, umode_t mode,
 			  unsigned int dev)
@@ -1008,6 +1019,8 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, inode_setsecurity);
 	set_to_cap_if_null(ops, inode_listsecurity);
 	set_to_cap_if_null(ops, inode_getsecid);
+	set_to_cap_if_null(ops, inode_copy_up);
+	set_to_cap_if_null(ops, inode_copy_up_xattr);
 #ifdef CONFIG_SECURITY_PATH
 	set_to_cap_if_null(ops, path_mknod);
 	set_to_cap_if_null(ops, path_mkdir);
diff --git a/security/security.c b/security/security.c
index 04c8feca081a..cb3563013ef5 100644
--- a/security/security.c
+++ b/security/security.c
@@ -707,6 +707,19 @@ void security_inode_getsecid(const struct inode *inode, u32 *secid)
 	security_ops->inode_getsecid(inode, secid);
 }
 
+int security_inode_copy_up(struct dentry *src, struct dentry *dst)
+{
+	return security_ops->inode_copy_up(src, dst);
+}
+EXPORT_SYMBOL(security_inode_copy_up);
+
+int security_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
+				 const char *name, void *value, size_t *size)
+{
+	return security_ops->inode_copy_up_xattr(src, dst, name, value, size);
+}
+EXPORT_SYMBOL(security_inode_copy_up_xattr);
+
 int security_file_permission(struct file *file, int mask)
 {
 	int ret;


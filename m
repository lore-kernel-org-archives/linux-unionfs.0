From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v3 06/17] sockfs: Get rid of getxattr iop
Date: Mon, 30 May 2016 10:57:22 +0200
Message-ID: <1464598653-3656-7-git-send-email-agruenba@redhat.com>
References: <1464598653-3656-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360AbcE3I63 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 30 May 2016 04:58:29 -0400
In-Reply-To: <1464598653-3656-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

If we allow pseudo-filesystems created with mount_pseudo to have xattr
handlers, we can replace sockfs_getxattr with a sockfs_xattr_get handler
to use the xattr handler name parsing.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 arch/ia64/kernel/perfmon.c   |  4 ++--
 drivers/gpu/drm/drm_drv.c    |  1 +
 fs/aio.c                     |  2 +-
 fs/anon_inodes.c             |  2 +-
 fs/block_dev.c               |  2 +-
 fs/btrfs/tests/btrfs-tests.c |  2 +-
 fs/libfs.c                   |  3 ++-
 fs/nsfs.c                    |  2 +-
 fs/pipe.c                    |  2 +-
 include/linux/fs.h           |  1 +
 net/socket.c                 | 48 ++++++++++++++++++++++++++------------------
 11 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 2436ad5..4cef6a6 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -611,8 +611,8 @@ static const struct dentry_operations pfmfs_dentry_operations;
 static struct dentry *
 pfmfs_mount(struct file_system_type *fs_type, int flags, const char *dev_name, void *data)
 {
-	return mount_pseudo(fs_type, "pfm:", NULL, &pfmfs_dentry_operations,
-			PFMFS_MAGIC);
+	return mount_pseudo(fs_type, "pfm:", NULL, NULL,
+			    &pfmfs_dentry_operations, PFMFS_MAGIC);
 }
 
 static struct file_system_type pfm_fs_type = {
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index bff8922..118658a 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -511,6 +511,7 @@ static struct dentry *drm_fs_mount(struct file_system_type *fs_type, int flags,
 	return mount_pseudo(fs_type,
 			    "drm:",
 			    &drm_fs_sops,
+			    NULL,
 			    &drm_fs_dops,
 			    0x010203ff);
 }
diff --git a/fs/aio.c b/fs/aio.c
index fb8e45b..5003cb8 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -239,7 +239,7 @@ static struct dentry *aio_mount(struct file_system_type *fs_type,
 	static const struct dentry_operations ops = {
 		.d_dname	= simple_dname,
 	};
-	return mount_pseudo(fs_type, "aio:", NULL, &ops, AIO_RING_MAGIC);
+	return mount_pseudo(fs_type, "aio:", NULL, NULL, &ops, AIO_RING_MAGIC);
 }
 
 /* aio_setup
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 80ef38c..5e1aeea1 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -41,7 +41,7 @@ static const struct dentry_operations anon_inodefs_dentry_operations = {
 static struct dentry *anon_inodefs_mount(struct file_system_type *fs_type,
 				int flags, const char *dev_name, void *data)
 {
-	return mount_pseudo(fs_type, "anon_inode:", NULL,
+	return mount_pseudo(fs_type, "anon_inode:", NULL, NULL,
 			&anon_inodefs_dentry_operations, ANON_INODE_FS_MAGIC);
 }
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 71ccab1..acabeaa 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -658,7 +658,7 @@ static struct dentry *bd_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
 	struct dentry *dent;
-	dent = mount_pseudo(fs_type, "bdev:", &bdev_sops, NULL, BDEVFS_MAGIC);
+	dent = mount_pseudo(fs_type, "bdev:", &bdev_sops, NULL, NULL, BDEVFS_MAGIC);
 	if (dent)
 		dent->d_sb->s_iflags |= SB_I_CGROUPWB;
 	return dent;
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index f54bf45..ebecf33 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -40,7 +40,7 @@ static struct dentry *btrfs_test_mount(struct file_system_type *fs_type,
 				       void *data)
 {
 	return mount_pseudo(fs_type, "btrfs_test:", &btrfs_test_super_ops,
-			    NULL, BTRFS_TEST_MAGIC);
+			    NULL, NULL, BTRFS_TEST_MAGIC);
 }
 
 static struct file_system_type test_type = {
diff --git a/fs/libfs.c b/fs/libfs.c
index 3db2721..89341ad 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -206,7 +206,7 @@ static const struct super_operations simple_super_operations = {
  * will never be mountable)
  */
 struct dentry *mount_pseudo(struct file_system_type *fs_type, char *name,
-	const struct super_operations *ops,
+	const struct super_operations *ops, const struct xattr_handler **xattr,
 	const struct dentry_operations *dops, unsigned long magic)
 {
 	struct super_block *s;
@@ -223,6 +223,7 @@ struct dentry *mount_pseudo(struct file_system_type *fs_type, char *name,
 	s->s_blocksize_bits = PAGE_SHIFT;
 	s->s_magic = magic;
 	s->s_op = ops ? ops : &simple_super_operations;
+	s->s_xattr = xattr;
 	s->s_time_gran = 1;
 	root = new_inode(s);
 	if (!root)
diff --git a/fs/nsfs.c b/fs/nsfs.c
index 8f20d60..e151cc3 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -154,7 +154,7 @@ static const struct super_operations nsfs_ops = {
 static struct dentry *nsfs_mount(struct file_system_type *fs_type,
 			int flags, const char *dev_name, void *data)
 {
-	return mount_pseudo(fs_type, "nsfs:", &nsfs_ops,
+	return mount_pseudo(fs_type, "nsfs:", &nsfs_ops, NULL,
 			&ns_dentry_operations, NSFS_MAGIC);
 }
 static struct file_system_type nsfs = {
diff --git a/fs/pipe.c b/fs/pipe.c
index 0d3f516..035fa6f 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1143,7 +1143,7 @@ static const struct super_operations pipefs_ops = {
 static struct dentry *pipefs_mount(struct file_system_type *fs_type,
 			 int flags, const char *dev_name, void *data)
 {
-	return mount_pseudo(fs_type, "pipe:", &pipefs_ops,
+	return mount_pseudo(fs_type, "pipe:", &pipefs_ops, NULL,
 			&pipefs_dentry_operations, PIPEFS_MAGIC);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dd28814..a1f69bd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2059,6 +2059,7 @@ struct super_block *sget(struct file_system_type *type,
 			int flags, void *data);
 extern struct dentry *mount_pseudo(struct file_system_type *, char *,
 	const struct super_operations *ops,
+	const struct xattr_handler **xattr,
 	const struct dentry_operations *dops,
 	unsigned long);
 
diff --git a/net/socket.c b/net/socket.c
index 9b3dca6..be5463f 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -320,11 +320,38 @@ static const struct dentry_operations sockfs_dentry_operations = {
 	.d_dname  = sockfs_dname,
 };
 
+static int sockfs_xattr_get(const struct xattr_handler *handler,
+			    struct dentry *dentry, struct inode *inode,
+			    const char *suffix, void *value, size_t size)
+{
+	if (value) {
+		if (dentry->d_name.len + 1 > size)
+			return -ERANGE;
+		memcpy(value, dentry->d_name.name, dentry->d_name.len + 1);
+	}
+	return dentry->d_name.len + 1;
+}
+
+#define XATTR_SOCKPROTONAME_SUFFIX "sockprotoname"
+#define XATTR_NAME_SOCKPROTONAME (XATTR_SYSTEM_PREFIX XATTR_SOCKPROTONAME_SUFFIX)
+#define XATTR_NAME_SOCKPROTONAME_LEN (sizeof(XATTR_NAME_SOCKPROTONAME)-1)
+
+static const struct xattr_handler sockfs_xattr_handler = {
+	.name = XATTR_NAME_SOCKPROTONAME,
+	.get = sockfs_xattr_get,
+};
+
+static const struct xattr_handler *sockfs_xattr_handlers[] = {
+	&sockfs_xattr_handler,
+	NULL
+};
+
 static struct dentry *sockfs_mount(struct file_system_type *fs_type,
 			 int flags, const char *dev_name, void *data)
 {
 	return mount_pseudo(fs_type, "socket:", &sockfs_ops,
-		&sockfs_dentry_operations, SOCKFS_MAGIC);
+			    sockfs_xattr_handlers,
+			    &sockfs_dentry_operations, SOCKFS_MAGIC);
 }
 
 static struct vfsmount *sock_mnt __read_mostly;
@@ -463,23 +490,6 @@ static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
 	return NULL;
 }
 
-#define XATTR_SOCKPROTONAME_SUFFIX "sockprotoname"
-#define XATTR_NAME_SOCKPROTONAME (XATTR_SYSTEM_PREFIX XATTR_SOCKPROTONAME_SUFFIX)
-#define XATTR_NAME_SOCKPROTONAME_LEN (sizeof(XATTR_NAME_SOCKPROTONAME)-1)
-static ssize_t sockfs_getxattr(struct dentry *dentry, struct inode *inode,
-			       const char *name, void *value, size_t size)
-{
-	if (!strcmp(name, XATTR_NAME_SOCKPROTONAME)) {
-		if (value) {
-			if (dentry->d_name.len + 1 > size)
-				return -ERANGE;
-			memcpy(value, dentry->d_name.name, dentry->d_name.len + 1);
-		}
-		return dentry->d_name.len + 1;
-	}
-	return -EOPNOTSUPP;
-}
-
 static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
 				size_t size)
 {
@@ -509,7 +519,7 @@ static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
 }
 
 static const struct inode_operations sockfs_inode_ops = {
-	.getxattr = sockfs_getxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = sockfs_listxattr,
 };
 
-- 
2.5.5

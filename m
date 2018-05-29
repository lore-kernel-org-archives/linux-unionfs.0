From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 22/39] ovl: add ovl_fiemap()
Date: Tue, 29 May 2018 16:43:22 +0200
Message-ID: <20180529144339.16538-23-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Implement stacked fiemap().

Need to split inode operations for regular file (which has fiemap) and
special file (which doesn't have fiemap).

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index d6a13da0740f..cd46dd8e7e54 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -448,6 +448,23 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags)
 	return 0;
 }
 
+static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		      u64 start, u64 len)
+{
+	int err;
+	struct inode *realinode = ovl_inode_real(inode);
+	const struct cred *old_cred;
+
+	if (!realinode->i_op->fiemap)
+		return -EOPNOTSUPP;
+
+	old_cred = ovl_override_creds(inode->i_sb);
+	err = realinode->i_op->fiemap(realinode, fieinfo, start, len);
+	revert_creds(old_cred);
+
+	return err;
+}
+
 static const struct inode_operations ovl_file_inode_operations = {
 	.setattr	= ovl_setattr,
 	.permission	= ovl_permission,
@@ -455,6 +472,7 @@ static const struct inode_operations ovl_file_inode_operations = {
 	.listxattr	= ovl_listxattr,
 	.get_acl	= ovl_get_acl,
 	.update_time	= ovl_update_time,
+	.fiemap		= ovl_fiemap,
 };
 
 static const struct inode_operations ovl_symlink_inode_operations = {
@@ -465,6 +483,15 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 	.update_time	= ovl_update_time,
 };
 
+static const struct inode_operations ovl_special_inode_operations = {
+	.setattr	= ovl_setattr,
+	.permission	= ovl_permission,
+	.getattr	= ovl_getattr,
+	.listxattr	= ovl_listxattr,
+	.get_acl	= ovl_get_acl,
+	.update_time	= ovl_update_time,
+};
+
 /*
  * It is possible to stack overlayfs instance on top of another
  * overlayfs instance as lower layer. We need to annonate the
@@ -548,7 +575,7 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev,
 		break;
 
 	default:
-		inode->i_op = &ovl_file_inode_operations;
+		inode->i_op = &ovl_special_inode_operations;
 		init_special_inode(inode, mode, rdev);
 		break;
 	}
-- 
2.14.3

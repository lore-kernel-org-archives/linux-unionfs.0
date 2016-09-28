From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v5 13/17] libfs: Use IOP_XATTR flag for empty directory handling
Date: Wed, 28 Sep 2016 16:57:59 +0200
Message-ID: <1475074683-26971-14-git-send-email-agruenba@redhat.com>
References: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

Instead of special xattr inode operations, use the IOP_XATTR inode
operations flag for the special libfs empty directories.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/libfs.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index cfa9576..b322d75 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1150,24 +1150,6 @@ static int empty_dir_setattr(struct dentry *dentry, struct iattr *attr)
 	return -EPERM;
 }
 
-static int empty_dir_setxattr(struct dentry *dentry, struct inode *inode,
-			      const char *name, const void *value,
-			      size_t size, int flags)
-{
-	return -EOPNOTSUPP;
-}
-
-static ssize_t empty_dir_getxattr(struct dentry *dentry, struct inode *inode,
-				  const char *name, void *value, size_t size)
-{
-	return -EOPNOTSUPP;
-}
-
-static int empty_dir_removexattr(struct dentry *dentry, const char *name)
-{
-	return -EOPNOTSUPP;
-}
-
 static ssize_t empty_dir_listxattr(struct dentry *dentry, char *list, size_t size)
 {
 	return -EOPNOTSUPP;
@@ -1178,9 +1160,6 @@ static const struct inode_operations empty_dir_inode_operations = {
 	.permission	= generic_permission,
 	.setattr	= empty_dir_setattr,
 	.getattr	= empty_dir_getattr,
-	.setxattr	= empty_dir_setxattr,
-	.getxattr	= empty_dir_getxattr,
-	.removexattr	= empty_dir_removexattr,
 	.listxattr	= empty_dir_listxattr,
 };
 
@@ -1216,6 +1195,7 @@ void make_empty_dir_inode(struct inode *inode)
 	inode->i_blocks = 0;
 
 	inode->i_op = &empty_dir_inode_operations;
+	inode->i_opflags &= ~IOP_XATTR;
 	inode->i_fop = &empty_dir_operations;
 }
 
-- 
2.7.4


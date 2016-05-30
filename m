From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v3 15/17] vfs: Check for the IOP_XATTR flag in listxattr
Date: Mon, 30 May 2016 10:57:31 +0200
Message-ID: <1464598653-3656-16-git-send-email-agruenba@redhat.com>
References: <1464598653-3656-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1464598653-3656-1-git-send-email-agruenba@redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

When an inode doesn't support xattrs, turn listxattr off as well.

(When xattrs are "turned off", the VFS still passes security xattr
operations through to security modules, which can still expose inode
security labels that way.)

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xattr.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index a947cb5..8ffc93e 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -319,18 +319,19 @@ nolsm:
 EXPORT_SYMBOL_GPL(vfs_getxattr);
 
 ssize_t
-vfs_listxattr(struct dentry *d, char *list, size_t size)
+vfs_listxattr(struct dentry *dentry, char *list, size_t size)
 {
+	struct inode *inode = d_inode(dentry);
 	ssize_t error;
 
-	error = security_inode_listxattr(d);
+	error = security_inode_listxattr(dentry);
 	if (error)
 		return error;
-	error = -EOPNOTSUPP;
-	if (d->d_inode->i_op->listxattr) {
-		error = d->d_inode->i_op->listxattr(d, list, size);
+	if (inode->i_op->listxattr && (inode->i_opflags & IOP_XATTR)) {
+		error = -EOPNOTSUPP;
+		error = inode->i_op->listxattr(dentry, list, size);
 	} else {
-		error = security_inode_listsecurity(d->d_inode, list, size);
+		error = security_inode_listsecurity(inode, list, size);
 		if (size && error > size)
 			error = -ERANGE;
 	}
-- 
2.5.5


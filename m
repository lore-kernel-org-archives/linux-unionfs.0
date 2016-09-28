From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v5 15/17] vfs: Check for the IOP_XATTR flag in listxattr
Date: Wed, 28 Sep 2016 16:58:01 +0200
Message-ID: <1475074683-26971-16-git-send-email-agruenba@redhat.com>
References: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932396AbcI1O7Y (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Sep 2016 10:59:24 -0400
In-Reply-To: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

When an inode doesn't support xattrs, turn listxattr off as well.

(When xattrs are "turned off", the VFS still passes security xattr
operations through to security modules, which can still expose inode
security labels that way.)

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xattr.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 54a4115..e1ccf2b 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -326,18 +326,19 @@ nolsm:
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
2.7.4

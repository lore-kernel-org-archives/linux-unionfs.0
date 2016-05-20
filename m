From: Krisztian Litkey <kli@iki.fi>
Subject: [PATCH v3 1/1] ovl: setxattr: don't deadlock when called from ima_fix_xattr.
Date: Fri, 20 May 2016 02:28:38 -0400
Message-ID: <1463725718-2461-1-git-send-email-kli@iki.fi>
References: <1463611500.2465.22.camel@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36701 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbcETG26 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 20 May 2016 02:28:58 -0400
Received: by mail-lf0-f68.google.com with SMTP id y84so7284648lfc.3
        for <linux-unionfs@vger.kernel.org>; Thu, 19 May 2016 23:28:57 -0700 (PDT)
In-Reply-To: <1463611500.2465.22.camel@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: zohar@linux.vnet.ibm.com, Krisztian Litkey <kli@iki.fi>, Krisztian Litkey <krisztian.litkey@intel.com>

IMA tracks the integrity of files by hashing the file content
and storing the hash in an IMA-specific extended attribute
(security.ima). When a file opened for writing is closed by
the last writer, IMA recalculates the hash and updates the
extended attribute. Updating the attribute happens by locking
the inode mutex and calling  __vfs_setxattr_noperm.

For a file on an overlayfs mount, this causes ovl_setxattr
being eventually called (from __vfs_setxattr_noperm via
inode->i_op->setxattr) with the inode already locked. In this
case we cannot do the xattr setting by calling vfs_setxattr
since that will try to lock the inode mutex again. To avoid
a deadlock, we check if the mutex is already locked and call
__vfs_setxattr_noperm or vfs_setxattr accordingly.

Signed-off-by: Krisztian Litkey <krisztian.litkey@intel.com>
---
 fs/overlayfs/inode.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b29036a..25bfeeb 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -223,25 +223,28 @@ int ovl_setxattr(struct dentry *dentry, const char *name,
 		 const void *value, size_t size, int flags)
 {
 	int err;
-	struct dentry *upperdentry;
+	struct dentry *upper;
+
+	if (ovl_is_private_xattr(name))
+		return -EPERM;
 
 	err = ovl_want_write(dentry);
 	if (err)
 		goto out;
 
-	err = -EPERM;
-	if (ovl_is_private_xattr(name))
-		goto out_drop_write;
-
 	err = ovl_copy_up(dentry);
-	if (err)
-		goto out_drop_write;
+	if (!err)
+		upper = ovl_dentry_upper(dentry);
 
-	upperdentry = ovl_dentry_upper(dentry);
-	err = vfs_setxattr(upperdentry, name, value, size, flags);
-
-out_drop_write:
 	ovl_drop_write(dentry);
+
+	if (err)
+		goto out;
+
+	if (mutex_is_locked(&upper->d_inode->i_mutex))
+		err = __vfs_setxattr_noperm(upper, name, value, size, flags);
+	else
+		err = vfs_setxattr(upper, name, value, size, flags);
 out:
 	return err;
 }
-- 
2.5.5

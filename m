From: Krisztian Litkey <kli@iki.fi>
Subject: [PATCH v2 1/1] ovl: setxattr: avoid deadlock when setting IMA xattr.
Date: Sun, 15 May 2016 16:07:35 -0400
Message-ID: <1463342855-27091-1-git-send-email-kli@iki.fi>
References: <1463338367.14611.40.camel@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:35573 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcEOUH5 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 15 May 2016 16:07:57 -0400
Received: by mail-lf0-f46.google.com with SMTP id j8so109563182lfd.2
        for <linux-unionfs@vger.kernel.org>; Sun, 15 May 2016 13:07:56 -0700 (PDT)
In-Reply-To: <1463338367.14611.40.camel@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: zohar@us.ibm.com, Krisztian Litkey <kli@iki.fi>

If we're writing the extended attribute used by IMA, don't
try to lock sb_writers (mnt_want_write) or i_mutex. We're
being called from ima_file_free and the necessary locks
are already being held. Trying to lock them again will
deadlock.

In practice we test if the real inode has the S_IMA flag
set and if the xattr being set is the IMA attribute. If
both are true, we call __vfs_setxattr_noperm instead of
the usual vfs_setxattr we call for all other cases.

Signed-off-by: Krisztian Litkey <kli@iki.fi>
---
 fs/overlayfs/inode.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b29036a..15f4af3 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -222,12 +222,18 @@ static bool ovl_is_private_xattr(const char *name)
 int ovl_setxattr(struct dentry *dentry, const char *name,
 		 const void *value, size_t size, int flags)
 {
-	int err;
+	int err, ima;
 	struct dentry *upperdentry;
+	struct inode *inode;
 
-	err = ovl_want_write(dentry);
-	if (err)
-		goto out;
+	inode = ovl_dentry_real(dentry)->d_inode;
+	ima = IS_IMA(inode) && !strcmp(name, XATTR_NAME_IMA);
+
+	if (!ima) {
+		err = ovl_want_write(dentry);
+		if (err)
+			goto out;
+	}
 
 	err = -EPERM;
 	if (ovl_is_private_xattr(name))
@@ -238,10 +244,16 @@ int ovl_setxattr(struct dentry *dentry, const char *name,
 		goto out_drop_write;
 
 	upperdentry = ovl_dentry_upper(dentry);
-	err = vfs_setxattr(upperdentry, name, value, size, flags);
+
+	if (!ima)
+		err = vfs_setxattr(upperdentry, name, value, size, flags);
+	else
+		err = __vfs_setxattr_noperm(upperdentry, name, value, size,
+					    flags);
 
 out_drop_write:
-	ovl_drop_write(dentry);
+	if (!ima)
+		ovl_drop_write(dentry);
 out:
 	return err;
 }
-- 
2.5.5

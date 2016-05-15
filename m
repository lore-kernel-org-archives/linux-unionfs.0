From: Krisztian Litkey <kli@iki.fi>
Subject: [PATCH 1/1] ovl: setxattr: avoid deadlock when writing IMA xattrs.
Date: Sun, 15 May 2016 13:14:26 -0400
Message-ID: <1463332466-26930-2-git-send-email-kli@iki.fi>
References: <201605150256.u4F2uQnX030109@d03av04.boulder.ibm.com>
 <1463332466-26930-1-git-send-email-kli@iki.fi>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36538 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbcEOROy (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 15 May 2016 13:14:54 -0400
Received: by mail-lb0-f173.google.com with SMTP id h1so43294808lbj.3
        for <linux-unionfs@vger.kernel.org>; Sun, 15 May 2016 10:14:53 -0700 (PDT)
In-Reply-To: <1463332466-26930-1-git-send-email-kli@iki.fi>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: zohar@us.ibm.com, Krisztian Litkey <kli@iki.fi>

If we're writing an extended attribute used by IMA, don't
try to lock sb_writers (mnt_want_write) or i_mutex. We're
being called from ima_file_free and the necessary locks
are already being held. Trying to lock them again will
deadlock.

In practice we test if the real inode has the S_IMA flag
set and if it does we call __vfs_setxattr_noperm instead
of the usual vfs_setxattr we call for all other cases.

Signed-off-by: Krisztian Litkey <kli@iki.fi>
---
 fs/overlayfs/inode.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b29036a..9257e8d 100644
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
+	ima = IS_IMA(inode);
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

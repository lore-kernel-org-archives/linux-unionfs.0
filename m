From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 2/2] ovl: check IS_APPEND() on real upper inode
Date: Sat,  8 Apr 2017 14:49:07 +0300
Message-ID: <1491652147-19794-3-git-send-email-amir73il@gmail.com>
References: <1491652147-19794-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33136 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752013AbdDHLtE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2017 07:49:04 -0400
Received: by mail-wm0-f68.google.com with SMTP id o81so2187552wmb.0
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Apr 2017 04:49:03 -0700 (PDT)
In-Reply-To: <1491652147-19794-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

For overlay file open, check IS_APPEND() on the real upper inode
inside d_real(), because the overlay inode does not have the
S_APPEND flag and IS_APPEND() can only be checked at open time.

Note that because overlayfs does not copy up the chattr inode flags
(i.e. S_APPEND, S_IMMUTABLE), the IS_APPEND() check is only relevant
for upper inodes that were set with chattr +a and not to lower
inodes that had chattr +a before copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c9e70d3..c072a0c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -49,11 +49,28 @@ static void ovl_dentry_release(struct dentry *dentry)
 	}
 }
 
+static int ovl_check_append_only(struct inode *inode, int flag)
+{
+	/*
+	 * This test was moot in vfs may_open() because overlay inode does
+	 * not have the S_APPEND flag, so re-check on real upper inode
+	 */
+	if (IS_APPEND(inode)) {
+		if  ((flag & O_ACCMODE) != O_RDONLY && !(flag & O_APPEND))
+			return -EPERM;
+		if (flag & O_TRUNC)
+			return -EPERM;
+	}
+
+	return 0;
+}
+
 static struct dentry *ovl_d_real(struct dentry *dentry,
 				 const struct inode *inode,
 				 unsigned int open_flags)
 {
 	struct dentry *real;
+	int err;
 
 	if (!d_is_reg(dentry)) {
 		if (!inode || inode == d_inode(dentry))
@@ -65,15 +82,20 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 		return dentry;
 
 	if (open_flags) {
-		int err = ovl_open_maybe_copy_up(dentry, open_flags);
-
+		err = ovl_open_maybe_copy_up(dentry, open_flags);
 		if (err)
 			return ERR_PTR(err);
 	}
 
 	real = ovl_dentry_upper(dentry);
-	if (real && (!inode || inode == d_inode(real)))
+	if (real && (!inode || inode == d_inode(real))) {
+		if (!inode) {
+			err = ovl_check_append_only(d_inode(real), open_flags);
+			if (err)
+				return ERR_PTR(err);
+		}
 		return real;
+	}
 
 	real = ovl_dentry_lower(dentry);
 	if (!real)
-- 
2.7.4

From: =?UTF-8?B?546L5pet?= <xuw2015@gmail.com>
Subject: [PATCH] ovl: free file dentry immediately
Date: Mon, 9 Feb 2015 15:23:06 +0800
Message-ID: <CAPBX1xJDVd9HxS0qT=4b22hDH5vPYh5=-2C9epiRqyRP=A13_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qc0-f193.google.com ([209.85.216.193]:52123 "EHLO
	mail-qc0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444AbbBIHfX (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 9 Feb 2015 02:35:23 -0500
Received: by mail-qc0-f193.google.com with SMTP id w7so8196671qcr.0
        for <linux-unionfs@vger.kernel.org>; Sun, 08 Feb 2015 23:35:22 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org

Do not cache the overlay file dentries in dentry lru. For the fs dentry of
overlay is fake, the real operations happen either lower dentry or upper dentry.
So it's not helpful to performance.

And for a special use, the fnctl F_SETLEASE F_WRLCK needs the dentry count is 1.
If we cache the ovl dentry, which will hold the reference for upper dentry, and
the fcntl will do operation on upper dentry, whose reference will be 2. And
finally the fcntl F_SETLEASE F_WRLCK will fail with -EAGAIN. The ltp fcntl24,
fcntl25 and fcntl26 test case cover it.

Signed-off-by: George Wang <xuw@redhat.com>
---
 fs/overlayfs/super.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f16d318..80b9ea8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -256,6 +256,17 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
     return false;
 }

+static int ovl_dentry_delete(struct dentry *dentry)
+{
+    struct inode *inode = dentry->d_inode;
+
+    //dir dentry holds ovl_dir_cache, which will speed up readdir
+    if (inode && S_ISDIR(inode->i_mode))
+        return 0;
+
+    return 1;
+}
+
 static void ovl_dentry_release(struct dentry *dentry)
 {
     struct ovl_entry *oe = dentry->d_fsdata;
@@ -268,7 +279,8 @@ static void ovl_dentry_release(struct dentry *dentry)
 }

 static const struct dentry_operations ovl_dentry_operations = {
-    .d_release = ovl_dentry_release,
+    .d_delete    = ovl_dentry_delete,
+    .d_release    = ovl_dentry_release,
 };

 static struct ovl_entry *ovl_alloc_entry(void)
-- 
1.9.3

From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] ovl: Fix info leak in ovl_lookup_temp()
Date: Fri, 16 Sep 2016 11:45:24 +0200
Message-ID: <1474019124-11340-1-git-send-email-richard@nod.at>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751948AbcIPJqR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Sep 2016 05:46:17 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, keescook@chromium.org, Richard Weinberger <richard@nod.at>

The function uses the memory address of a struct dentry as unique id.
While the address-based directory entry is only visible to root
it is IMHO still worth fixing since the temporary name does not have
to be a kernel address. It can be any unique number. Replace it by an
atomic integer which is allowed to wrap around.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/overlayfs/dir.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1560fdc..6e00a08 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -14,6 +14,7 @@
 #include <linux/cred.h>
 #include <linux/posix_acl.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/atomic.h>
 #include "overlayfs.h"
 
 void ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
@@ -37,8 +38,9 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir, struct dentry *dentry)
 {
 	struct dentry *temp;
 	char name[20];
+	static atomic_t temp_id = ATOMIC_INIT(0);
 
-	snprintf(name, sizeof(name), "#%lx", (unsigned long) dentry);
+	snprintf(name, sizeof(name), "#%x", atomic_inc_return(&temp_id));
 
 	temp = lookup_one_len(name, workdir, strlen(name));
 	if (!IS_ERR(temp) && temp->d_inode) {
-- 
2.7.3

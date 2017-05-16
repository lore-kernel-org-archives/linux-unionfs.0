From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix creds leak in copy up error path
Date: Tue, 16 May 2017 08:45:46 +0300
Message-ID: <1494913546-2723-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36855 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbdEPFpd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2017 01:45:33 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "# v4 . 11" <stable@vger.kernel.org>

Fixes: 42f269b92540 ("ovl: rearrange code in ovl_copy_up_locked()")
Cc: <stable@vger.kernel.org> # v4.11
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Miklos,

Found that fall out while trying to 'simplify' this function. (see WIP at
https://github.com/amir73il/linux/commits/ovl-index-dir).

Amir.

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 9008ab9..061a844 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -343,12 +343,13 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 		temp = ovl_do_tmpfile(upperdir, stat->mode);
 	else
 		temp = ovl_lookup_temp(workdir, dentry);
-	err = PTR_ERR(temp);
-	if (IS_ERR(temp))
-		goto out1;
-
 	err = 0;
-	if (!tmpfile)
+	if (IS_ERR(temp)) {
+		err = PTR_ERR(temp);
+		temp = NULL;
+	}
+
+	if (!err && !tmpfile)
 		err = ovl_create_real(wdir, temp, &cattr, NULL, true);
 
 	if (new_creds) {
-- 
2.7.4

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] ovl: take mnt_want_write() for removing impure xattr
Date: Wed,  3 Jan 2018 18:54:42 +0200
Message-ID: <1514998482-26662-2-git-send-email-amir73il@gmail.com>
References: <1514998482-26662-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:44859 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbeACQyH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 11:54:07 -0500
Received: by mail-wm0-f67.google.com with SMTP id t8so3735334wmc.3
        for <linux-unionfs@vger.kernel.org>; Wed, 03 Jan 2018 08:54:07 -0800 (PST)
In-Reply-To: <1514998482-26662-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

The optimization in ovl_cache_get_impure() that tries to remove an
unneeded "impure" xattr needs to take mnt_want_write() on upper fs.

Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
Cc: <stable@vger.kernel.org> #v4.14
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 8c98578d27a1..001c79297bc5 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -593,8 +593,15 @@ static struct ovl_dir_cache *ovl_cache_get_impure(struct path *path)
 		return ERR_PTR(res);
 	}
 	if (list_empty(&cache->entries)) {
-		/* Good oportunity to get rid of an unnecessary "impure" flag */
-		ovl_do_removexattr(ovl_dentry_upper(dentry), OVL_XATTR_IMPURE);
+		/*
+		 * A good opportunity to get rid of an unneeded "impure" flag.
+		 * Removing the "impure" xattr is best effort.
+		 */
+		if (!ovl_want_write(dentry)) {
+			ovl_do_removexattr(ovl_dentry_upper(dentry),
+					   OVL_XATTR_IMPURE);
+			ovl_drop_write(dentry);
+		}
 		ovl_clear_flag(OVL_IMPURE, d_inode(dentry));
 		kfree(cache);
 		return NULL;
-- 
2.7.4

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v6 8/9] ovl: update merge dir cache for non-samefs case
Date: Wed,  1 Nov 2017 22:22:52 +0200
Message-ID: <1509567773-25590-9-git-send-email-amir73il@gmail.com>
References: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:43519 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755211AbdKAUWW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 16:22:22 -0400
Received: by mail-wm0-f67.google.com with SMTP id m72so9006wmc.0
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Nov 2017 13:22:21 -0700 (PDT)
In-Reply-To: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

st_ino returned by stat(2) for dirs on non-samefs is the non persistent
overlay i_ino. Update the dir cache with volatile overlay i_ino values.
Overlay dir cache and inode cache may get out of sync after child inodes
exit and re-enter inode cache. This means that user may see inconsistent
st_ino/d_ino, but user can already see inconsistent st_ino of same object
in different times, so this is better than nothing.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 74b859ed569e..fa1be3fe68fa 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -120,6 +120,10 @@ static bool ovl_calc_d_ino(struct ovl_readdir_data *rdd,
 	if (!rdd->dentry)
 		return false;
 
+	/* Always recalc d_ino from i_ino for dir on non-samefs */
+	if (p->type == DT_DIR && !ovl_same_sb(rdd->dentry->d_sb))
+		return true;
+
 	/* Always recalc d_ino for parent */
 	if (strcmp(p->name, "..") == 0)
 		return true;
@@ -480,6 +484,19 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 	}
 
 get:
+	/*
+	 * st_ino for dirs on non-samefs is the non persistent overlay i_ino.
+	 * Update the dir cache with volatile overlay i_ino, even though
+	 * dir cache and inode cache may get out of sync after child inodes
+	 * exit and re-enter inode cache. This means that user may see
+	 * inconsistent st_ino/d_ino, but user can already see inconsistent
+	 * st_ino of same object in different times.
+	 */
+	if (p->type == DT_DIR && !ovl_same_sb(dir->d_sb)) {
+		ino = this->d_inode->i_ino;
+		goto out;
+	}
+
 	type = ovl_path_type(this);
 	if (OVL_TYPE_ORIGIN(type)) {
 		struct kstat stat;
@@ -489,7 +506,7 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 		err = vfs_getattr(&statpath, &stat, STATX_INO, 0);
 		if (err)
 			goto fail;
-		if (d_is_dir(this) || ovl_same_sb(this->d_sb))
+		if (ovl_same_sb(dir->d_sb))
 			WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
 		ino = stat.ino;
 	}
-- 
2.7.4

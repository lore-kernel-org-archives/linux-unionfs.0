From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v7 3/8] ovl: allocate anonymous devs for lowerdirs
Date: Thu,  2 Nov 2017 22:38:06 +0200
Message-ID: <1509655091-13630-4-git-send-email-amir73il@gmail.com>
References: <1509655091-13630-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51177 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934441AbdKBUhc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 16:37:32 -0400
Received: by mail-wm0-f68.google.com with SMTP id s66so1306121wmf.5
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Nov 2017 13:37:32 -0700 (PDT)
In-Reply-To: <1509655091-13630-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

From: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Generate unique values of st_dev per lower layer for non-samefs
overlay mount. The unique values are obtained by allocating anonymous
bdevs for each of the lowerdirs in the overlayfs instance.

The anonymous bdev is going to be returned by stat(2) for lowerdir
non-dir entries in non-samefs case.

[amir: split from ovl_getattr() and re-structure patches]

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 1e28329b5db8..93eb6a044dd2 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -19,6 +19,7 @@ struct ovl_config {
 
 struct ovl_layer {
 	struct vfsmount *mnt;
+	dev_t pseudo_dev;
 };
 
 struct ovl_path {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e6e13d9588d1..323dfd7a0236 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -219,8 +219,10 @@ static void ovl_put_super(struct super_block *sb)
 	if (ufs->upper_mnt && ufs->upperdir_locked)
 		ovl_inuse_unlock(ufs->upper_mnt->mnt_root);
 	mntput(ufs->upper_mnt);
-	for (i = 0; i < ufs->numlower; i++)
+	for (i = 0; i < ufs->numlower; i++) {
 		mntput(ufs->lower_layers[i].mnt);
+		free_anon_bdev(ufs->lower_layers[i].pseudo_dev);
+	}
 	kfree(ufs->lower_layers);
 
 	kfree(ufs->config.lowerdir);
@@ -1032,11 +1034,19 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_put_workdir;
 	for (i = 0; i < numlower; i++) {
 		struct vfsmount *mnt;
+		dev_t dev;
+
+		err = get_anon_bdev(&dev);
+		if (err) {
+			pr_err("overlayfs: failed to get anonymous bdev for lowerpath\n");
+			goto out_put_lower_layers;
+		}
 
 		mnt = clone_private_mount(&stack[i]);
 		err = PTR_ERR(mnt);
 		if (IS_ERR(mnt)) {
 			pr_err("overlayfs: failed to clone lowerpath\n");
+			free_anon_bdev(dev);
 			goto out_put_lower_layers;
 		}
 		/*
@@ -1046,6 +1056,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		mnt->mnt_flags |= MNT_READONLY | MNT_NOATIME;
 
 		ufs->lower_layers[ufs->numlower].mnt = mnt;
+		ufs->lower_layers[ufs->numlower].pseudo_dev = dev;
 		ufs->numlower++;
 
 		/* Check if all lower layers are on same sb */
@@ -1160,8 +1171,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 out_free_oe:
 	kfree(oe);
 out_put_lower_layers:
-	for (i = 0; i < ufs->numlower; i++)
+	for (i = 0; i < ufs->numlower; i++) {
+		if (ufs->lower_layers[i].mnt)
+			free_anon_bdev(ufs->lower_layers[i].pseudo_dev);
 		mntput(ufs->lower_layers[i].mnt);
+	}
 	kfree(ufs->lower_layers);
 out_put_workdir:
 	dput(ufs->workdir);
-- 
2.7.4

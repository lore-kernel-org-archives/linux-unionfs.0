From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 3/9] ovl: allocate anonymous devs for lowerdirs
Date: Tue,  7 Nov 2017 18:58:03 +0200
Message-ID: <1510073889-11657-4-git-send-email-amir73il@gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:52844 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754954AbdKGQ5g (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 11:57:36 -0500
Received: by mail-wm0-f68.google.com with SMTP id t139so5364051wmt.1
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 08:57:35 -0800 (PST)
In-Reply-To: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

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
index 7573f98ddec1..63ef5ae9275b 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -21,6 +21,7 @@ struct ovl_layer {
 	struct vfsmount *mnt;
 	/* Index of this layer in mount (upper == 0) */
 	int idx;
+	dev_t pseudo_dev;
 };
 
 struct ovl_path {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ceca3a9ac27f..0b8fe8dca187 100644
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
@@ -1047,6 +1057,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 		ufs->lower_layers[ufs->numlower].mnt = mnt;
 		ufs->lower_layers[ufs->numlower].idx = i + 1;
+		ufs->lower_layers[ufs->numlower].pseudo_dev = dev;
 		ufs->numlower++;
 
 		/* Check if all lower layers are on same sb */
@@ -1161,8 +1172,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
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

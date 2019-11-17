Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43275 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfKQPoH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 17 Nov 2019 10:44:07 -0500
Received: by mail-wr1-f67.google.com with SMTP id n1so16500323wra.10
        for <linux-unionfs@vger.kernel.org>; Sun, 17 Nov 2019 07:44:06 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6/6] ovl: fix corner case of non-constant st_dev;st_ino
Date: Sun, 17 Nov 2019 17:43:49 +0200
Message-Id: <20191117154349.28695-7-amir73il@gmail.com>
In-Reply-To: <20191117154349.28695-1-amir73il@gmail.com>
References: <20191117154349.28695-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Colin Ian King <colin.king@canonical.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On non-samefs overlay without xino, non pure upper inodes should use a
pseudo_dev assigned to each unique lower fs, but if lower layer is on
the same fs and upper layer, it has no pseudo_dev assigned.

In this overlay layers setup:
- two filesystems, A and B
- upper layer is on A
- lower layer 1 is also on A
- lower layer 2 is on B

Non pure upper overlay inode, whose origin is in layer 1 will have the
st_dev;st_ino values of the real lower inode before copy up and the
st_dev;st_ino values of the real upper inode after copy up.

Fix this inconsitency by assigning a unique pseudo_dev also for upper fs,
that will be used as st_dev value along with the lower inode st_dev for
overlay inodes in the case above.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 13 +++----------
 fs/overlayfs/super.c | 15 ++++++++++-----
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 9e894f5e19b4..00c4e9c17492 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -125,9 +125,8 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 		/*
 		 * For non-samefs setup, if we cannot map all layers st_ino
 		 * to a unified address space, we need to make sure that st_dev
-		 * is unique per lower fs. Layers that are on the same fs as
-		 * upper layer use real upper st_dev and other lower layers use
-		 * the unique anonymous bdev assigned to the lower fs.
+		 * is unique per underlying fs, so we use the unique anonymous
+		 * bdev assigned to the underlying fs.
 		 */
 		stat->dev = OVL_FS(dentry->d_sb)->fs[fsid].pseudo_dev;
 	}
@@ -195,13 +194,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) ||
 			    (!ovl_verify_lower(dentry->d_sb) &&
 			     (is_dir || lowerstat.nlink == 1))) {
-				/*
-				 * Cannot use origin st_dev;st_ino because
-				 * origin inode content may differ from overlay
-				 * inode content.
-				 */
-				if (samefs || fsid)
-					stat->ino = lowerstat.ino;
+				stat->ino = lowerstat.ino;
 			} else {
 				fsid = 0;
 			}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e80f79bb8a4e..9270e059eb9b 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -230,8 +230,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	}
 	kfree(ofs->layers);
 	if (ofs->fs) {
-		/* fs[0].pseudo_dev is either null or real upper st_dev */
-		for (i = 1; i <= ofs->maxfsid; i++)
+		for (i = 0; i <= ofs->maxfsid; i++)
 			free_anon_bdev(ofs->fs[i].pseudo_dev);
 		kfree(ofs->fs);
 	}
@@ -1335,13 +1334,19 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	ofs->layers[0].fsid = 0;
 
 	/*
-	 * All lower layers that share the same fs as upper layer, use the real
-	 * upper st_dev.
+	 * All lower layers that share the same fs as upper layer, use the same
+	 * pseudo_dev as upper layer.  Allocate fs[0].pseudo_dev even for lower
+	 * only overlay to simplify ovl_fs_free().
 	 * is_lower will be set if upper fs is shared with a lower layer.
 	 */
+	err = get_anon_bdev(&ofs->fs[0].pseudo_dev);
+	if (err) {
+		pr_err("overlayfs: failed to get anonymous bdev for upper fs\n");
+		goto out;
+	}
+
 	if (ofs->upper_mnt) {
 		ofs->fs[0].sb = ofs->upper_mnt->mnt_sb;
-		ofs->fs[0].pseudo_dev = ofs->upper_mnt->mnt_sb->s_dev;
 		ofs->fs[0].is_lower = false;
 	}
 
-- 
2.17.1

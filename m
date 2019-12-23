Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix wrong WARN_ON() in ovl_cache_update_ino()
Date: Mon, 23 Dec 2019 08:40:25 +0200
Message-Id: <20191223064025.23801-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

The WARN_ON() that child entry is always on overlay st_dev became wrong
when we allowed this function to update d_ino in non-samefs setup with
xino enabled.

It is not true in case of xino bits overflow on a non-dir inode.
Leave the WARN_ON() only for directories, where assertion is still true.

Fixes: adbf4f7ea834 ("ovl: consistent d_ino for non-samefs with xino")
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Hi Miklos,

Another fall out from testing nested xino setup.

Thanks,
Amir.

 fs/overlayfs/readdir.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 47a91c9733a5..7255e6a5838f 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -504,7 +504,13 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 		if (err)
 			goto fail;
 
-		WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
+		/*
+		 * Directory inode is always on overlay st_dev.
+		 * Non-dir with ovl_same_dev() could be on pseudo st_dev in case
+		 * of xino bits overflow.
+		 */
+		WARN_ON_ONCE(S_ISDIR(stat.mode) &&
+			     dir->d_sb->s_dev != stat.dev);
 		ino = stat.ino;
 	} else if (xinobits && !OVL_TYPE_UPPER(type)) {
 		ino = ovl_remap_lower_ino(ino, xinobits,
-- 
2.17.1

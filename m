Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH v2 1/5] ovl: reorder tests in ovl_open_need_copy_up()
Date: Tue, 22 Jan 2019 14:34:53 +0200
Message-Id: <20190122123457.10600-2-amir73il@gmail.com>
In-Reply-To: <20190122123457.10600-1-amir73il@gmail.com>
References: <20190122123457.10600-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

ovl_already_copied_up() has two memory barriers, which could be
avoided for open for read, so move it after open flags test.

special_file() is not expected from ovl_open(), so WARN_ON it,
and remove stale comment about disconnected dentry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0c0e11d529d0..05f853c7db0d 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -872,17 +872,14 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 
 static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
 {
-	/* Copy up of disconnected dentry does not set upper alias */
-	if (ovl_already_copied_up(dentry, flags))
-		return false;
-
-	if (special_file(d_inode(dentry)->i_mode))
+	/* Not called from regular file ops? */
+	if (WARN_ON(special_file(d_inode(dentry)->i_mode)))
 		return false;
 
 	if (!ovl_open_flags_need_copy_up(flags))
 		return false;
 
-	return true;
+	return !ovl_already_copied_up(dentry, flags);
 }
 
 int ovl_maybe_copy_up(struct dentry *dentry, int flags)
-- 
2.17.1

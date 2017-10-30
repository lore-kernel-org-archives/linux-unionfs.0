From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v5 4/4] ovl: relax same fs constraint for constant d_ino
Date: Mon, 30 Oct 2017 22:27:27 +0200
Message-ID: <1509395247-15180-5-git-send-email-amir73il@gmail.com>
References: <1509395247-15180-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:54435 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751894AbdJ3U0w (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2017 16:26:52 -0400
Received: by mail-wr0-f194.google.com with SMTP id o44so13884455wrf.11
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2017 13:26:51 -0700 (PDT)
In-Reply-To: <1509395247-15180-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

From: Chandan Rajendra <chandan@linux.vnet.ibm.com>

For a pure upper dir in a non-samefs setup, ovl_getattr() returns the
overlay inode number as the value of st_ino. To keep in line with this
behaviour, ovl_fill_real() has been modified to return overlay inode
number of the "." entry as the d_ino of a pure upper dir.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/overlayfs/readdir.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 0ab657f2c1c8..aad74f0891a5 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -452,7 +452,6 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
  * sure that d_ino will be consistent with st_ino from stat(2).
  */
 static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
-
 {
 	struct dentry *dir = path->dentry;
 	struct dentry *this = NULL;
@@ -460,9 +459,6 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 	u64 ino = p->real_ino;
 	int err = 0;
 
-	if (!ovl_same_sb(dir->d_sb))
-		goto out;
-
 	if (p->name[0] == '.') {
 		if (p->len == 1) {
 			this = dget(dir);
@@ -494,8 +490,8 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 		err = vfs_getattr(&statpath, &stat, STATX_INO, 0);
 		if (err)
 			goto fail;
-
-		WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
+		if (d_is_dir(this) || ovl_same_sb(this->d_sb))
+			WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
 		ino = stat.ino;
 	}
 
@@ -617,6 +613,7 @@ struct ovl_readdir_translate {
 	struct ovl_dir_cache *cache;
 	struct dir_context ctx;
 	u64 parent_ino;
+	u64 current_ino;
 };
 
 static int ovl_fill_real(struct dir_context *ctx, const char *name,
@@ -629,6 +626,8 @@ static int ovl_fill_real(struct dir_context *ctx, const char *name,
 
 	if (rdt->parent_ino && strcmp(name, "..") == 0)
 		ino = rdt->parent_ino;
+	else if (rdt->current_ino && namelen == 1 && name[0] == '.')
+		ino = rdt->current_ino;
 	else if (rdt->cache) {
 		struct ovl_cache_entry *p;
 
@@ -669,6 +668,9 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 			return PTR_ERR(rdt.cache);
 	}
 
+	if (!ovl_same_sb(dir->d_sb))
+		rdt.current_ino = dir->d_inode->i_ino;
+
 	return iterate_dir(od->realfile, &rdt.ctx);
 }
 
@@ -689,9 +691,9 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		 * dir is impure then need to adjust d_ino for copied up
 		 * entries.
 		 */
-		if (ovl_same_sb(dentry->d_sb) &&
-		    (ovl_test_flag(OVL_IMPURE, d_inode(dentry)) ||
-		     OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent)))) {
+		if (ovl_test_flag(OVL_IMPURE, d_inode(dentry)) ||
+		     OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent)) ||
+		     !ovl_same_sb(dentry->d_sb)) {
 			return ovl_iterate_real(file, ctx);
 		}
 		return iterate_dir(od->realfile, ctx);
-- 
2.7.4

From: xuw2015@gmail.com
Subject: [PATCH] ovl: keep lockdep silent when nest iterate_dir calling of lowerdir
Date: Fri, 26 Jun 2015 15:04:00 +0800
Message-ID: <1435302240-4855-1-git-send-email-xuw2015@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbbFZHEO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 26 Jun 2015 03:04:14 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, koct9i@gmail.com
Cc: George Wang <xuw2015@gmail.com>

From: George Wang <xuw2015@gmail.com>

If we use the overlayfs mount point as the lowerdir of another overlayfs, the
->iterate will be called nestly. It's just like overlayfs2->iterate will call
overlayfs1->iterate when we ls the overlayfs2 items. We turn off the lockdep
to avoid the false positive warning in this situation, and trun on the lockdep
when it finished.

The following procedure can reproduce it:

mkdir 1 1_lower 1_upper 1_work 2 2_upper 2_work
mount -t overlay overlay 1 -o lowerdir=1_lower,upperdir=1_upper,workdir=1_work
mount -t overlay overlay 2 -o lowerdir=1,upperdir=2_upper,workdir=2_work
ls 2

Reported-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: George Wang <xuw2015@gmail.com>
---
 fs/overlayfs/readdir.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 70e9af5..3f7f99b 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -236,6 +236,31 @@ static int ovl_check_whiteouts(struct dentry *dir, struct ovl_readdir_data *rdd)
 	return err;
 }
 
+/*
+ * If we use overlayfs as lower, the iterate_dir will be nest. This will
+ * trigger the lockdep deadlock warning, but actually, this is not deadlock.
+ * No one wants to see false positive warnings, so we use this wrapper
+ * function to keep silent in this situation.
+ */
+static inline int iterate_dir_silent(struct file *dir, struct dir_context *ctx)
+{
+    extern const struct file_operations ovl_dir_operations;
+    int err = 0;
+    int off = 0;
+
+    if (dir->f_op == &ovl_dir_operations) {
+        lockdep_off();
+        off = 1;
+    }
+
+    err = iterate_dir(dir, ctx);
+
+    if (off)
+        lockdep_on();
+
+    return err;
+}
+
 static inline int ovl_dir_read(struct path *realpath,
 			       struct ovl_readdir_data *rdd)
 {
@@ -251,7 +276,7 @@ static inline int ovl_dir_read(struct path *realpath,
 	do {
 		rdd->count = 0;
 		rdd->err = 0;
-		err = iterate_dir(realfile, &rdd->ctx);
+		err = iterate_dir_silent(realfile, &rdd->ctx);
 		if (err >= 0)
 			err = rdd->err;
 	} while (!err && rdd->count);
@@ -370,7 +395,7 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		ovl_dir_reset(file);
 
 	if (od->is_real)
-		return iterate_dir(od->realfile, ctx);
+		return iterate_dir_silent(od->realfile, ctx);
 
 	if (!od->cache) {
 		struct ovl_dir_cache *cache;
-- 
1.8.3.1

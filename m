Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix wrong use of impure dir cache in ovl_iterate()
Date: Tue, 17 Jul 2018 16:05:38 +0300
Message-Id: <1531832738-18097-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Aditya Kali <adityakali@google.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Only upper dir can be impure, but if we are in the middle of
iterating a lower real dir, dir could be copied up and marked
impure. We only want the impure cache if we started iterating
a real upper dir to begin with.

Aditya Kali reported that the following reproducer hits the
WARN_ON(!cache->refcount) in ovl_get_cache():

 docker run --rm drupal:8.5.4-fpm-alpine \
    sh -c 'cd /var/www/html/vendor/symfony && \
           chown -R www-data:www-data . && ls -l .'

Reported-by: Aditya Kali <adityakali@google.com>
Tested-by: Aditya Kali <adityakali@google.com>
Fixes: 4edb83bb1041 ('ovl: constant d_ino for non-merge dirs')
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index ef1fe42ff7bb..bccbb3ee9932 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -696,7 +696,13 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 		rdt.parent_ino = stat.ino;
 	}
 
-	if (ovl_test_flag(OVL_IMPURE, d_inode(dir))) {
+	/*
+	 * Only upper dir can be impure, but if we are in the middle of
+	 * iterating a lower real dir, dir could be copied up and marked
+	 * impure. We only want the impure cache if we started iterating
+	 * a real upper dir to begin with.
+	 */
+	if (od->is_upper && ovl_test_flag(OVL_IMPURE, d_inode(dir))) {
 		rdt.cache = ovl_cache_get_impure(&file->f_path);
 		if (IS_ERR(rdt.cache))
 			return PTR_ERR(rdt.cache);
@@ -721,14 +727,16 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 
 	if (od->is_real) {
 		/*
-		 * If parent is merge, then need to adjust d_ino for '..', if
-		 * dir is impure then need to adjust d_ino for copied up
-		 * entries.
+		 * If xino is enabled, need to adjust lower d_ino.
+		 * If parent is merge, then need to adjust d_ino for '..'.
+		 * If dir is upper and impure then need to adjust d_ino for
+		 * copied up entries.
 		 */
 		if (ovl_xino_bits(dentry->d_sb) ||
 		    (ovl_same_sb(dentry->d_sb) &&
-		     (ovl_test_flag(OVL_IMPURE, d_inode(dentry)) ||
-		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
+		     (OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent)) ||
+		      (od->is_upper &&
+		       ovl_test_flag(OVL_IMPURE, d_inode(dentry)))))) {
 			return ovl_iterate_real(file, ctx);
 		}
 		return iterate_dir(od->realfile, ctx);
-- 
2.7.4

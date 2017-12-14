From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 07/18] fsck.overlay: check lowers use relative path
Date: Thu, 14 Dec 2017 14:47:36 +0800
Message-ID: <20171214064747.20999-8-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11983 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751305AbdLNGmB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:01 -0500
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

instead of absolute path

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 check.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/check.c b/check.c
index add7e11..1d008cd 100644
--- a/check.c
+++ b/check.c
@@ -6,11 +6,13 @@
  *
  */
 
+#define _GNU_SOURCE
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <errno.h>
 #include <unistd.h>
+#include <fcntl.h>
 #include <stdbool.h>
 #include <sys/types.h>
 #include <sys/xattr.h>
@@ -23,11 +25,9 @@
 
 /* Underlying information */
 struct ovl_lower_check {
-	unsigned int type;	/* check extent type */
-
 	bool exist;
-	char path[PATH_MAX];	/* exist pathname found, only valid if exist */
-	struct stat st;		/* only valid if exist */
+	char path[PATH_MAX];	/* pathname found */
+	struct stat st;		/* stat(2) information */
 };
 
 /* Redirect information */
@@ -48,6 +48,7 @@ struct ovl_redirect_entry {
 extern char **lowerdir;
 extern char upperdir[];
 extern char workdir[];
+extern int *lowerfd;
 extern unsigned int lower_num;
 extern int flags;
 extern int status;
@@ -144,23 +145,25 @@ static inline int ovl_create_whiteout(const char *pathname)
  * Scan each lower dir lower than 'start' and check type matching,
  * we stop scan if we found something.
  *
- * skip: skip whiteout.
+ * pathname: path name relative to lower base directory
+ * start: which lower layer start to check
+ * skip: skip whiteout
  *
  */
 static int ovl_check_lower(const char *pathname, unsigned int start,
 			   struct ovl_lower_check *chk, bool skip)
 {
-	char lower_path[PATH_MAX];
 	struct stat st;
 	unsigned int i;
 
 	for (i = start; i < lower_num; i++) {
-		path_pack(lower_path, sizeof(lower_path), lowerdir[i], pathname);
+		if (fstatat(lowerfd[i], pathname, &st,
+			    AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW) != 0) {
 
-		if (lstat(lower_path, &st) != 0) {
 			if (errno != ENOENT && errno != ENOTDIR) {
-				print_err(_("Cannot stat %s: %s\n"),
-					    lower_path, strerror(errno));
+				print_err(_("Cannot stat %s in %s: %s\n"),
+					    pathname, lowerdir[i],
+					    strerror(errno));
 				return -1;
 			}
 			continue;
@@ -169,7 +172,7 @@ static int ovl_check_lower(const char *pathname, unsigned int start,
 		if (skip && is_whiteout(&st))
 			continue;
 
-		strncpy(chk->path, lower_path, sizeof(chk->path));
+		path_pack(chk->path, sizeof(chk->path), lowerdir[i], pathname);
 		chk->exist = true;
 		chk->st = st;
 
-- 
2.9.5

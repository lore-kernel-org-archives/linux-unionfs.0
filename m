From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 05/18] fsck.overlay: convert path parse to use helper function
Date: Thu, 14 Dec 2017 14:47:34 +0800
Message-ID: <20171214064747.20999-6-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 check.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/check.c b/check.c
index 1794501..add7e11 100644
--- a/check.c
+++ b/check.c
@@ -113,9 +113,13 @@ static int ovl_get_redirect(const char *pathname, size_t dirlen,
 		buf = srealloc(buf, ret + baselen + 1);
 		memmove(buf + baselen, buf, ret);
 		memcpy(buf, pathname+dirlen, baselen);
-		buf[ret + baselen] = '\0';
+		ret += baselen;
 	}
 
+	ret -= 1;
+	memmove(buf, buf+1, ret);
+	buf[ret] = '\0';
+
 	*redirect = buf;
 	return 0;
 }
@@ -143,7 +147,7 @@ static inline int ovl_create_whiteout(const char *pathname)
  * skip: skip whiteout.
  *
  */
-static int ovl_check_lower(const char *path, unsigned int start,
+static int ovl_check_lower(const char *pathname, unsigned int start,
 			   struct ovl_lower_check *chk, bool skip)
 {
 	char lower_path[PATH_MAX];
@@ -151,7 +155,7 @@ static int ovl_check_lower(const char *path, unsigned int start,
 	unsigned int i;
 
 	for (i = start; i < lower_num; i++) {
-		snprintf(lower_path, sizeof(lower_path), "%s%s", lowerdir[i], path);
+		path_pack(lower_path, sizeof(lower_path), lowerdir[i], pathname);
 
 		if (lstat(lower_path, &st) != 0) {
 			if (errno != ENOENT && errno != ENOTDIR) {
@@ -165,9 +169,10 @@ static int ovl_check_lower(const char *path, unsigned int start,
 		if (skip && is_whiteout(&st))
 			continue;
 
+		strncpy(chk->path, lower_path, sizeof(chk->path));
 		chk->exist = true;
 		chk->st = st;
-		strncpy(chk->path, lower_path, sizeof(chk->path));
+
 		break;
 	}
 
@@ -200,7 +205,8 @@ static int ovl_check_whiteout(struct scan_ctx *sctx)
 	 * check is there a file or dir with the same name.
 	 */
 	start = (sctx->dirtype == OVL_LOWER) ? sctx->num + 1 : 0;
-	ret = ovl_check_lower(pathname + sctx->dirlen, start, &chk, true);
+	ret = ovl_check_lower(path_pick(pathname, sctx->dirlen),
+			      start, &chk, true);
 	if (ret)
 		return ret;
 	if (chk.exist && !is_whiteout(&chk.st))
@@ -234,7 +240,7 @@ out:
 static int ovl_check_opaque(struct scan_ctx *sctx)
 {
 	const char *pathname = sctx->pathname;
-	char parent_path[PATH_MAX];
+	char parent[PATH_MAX];
 	struct ovl_lower_check chk = {0};
 	unsigned int start;
 	int ret = 0;
@@ -252,15 +258,17 @@ static int ovl_check_opaque(struct scan_ctx *sctx)
 	 * check if there is a file or dir with the same name.
 	 */
 	start = (sctx->dirtype == OVL_LOWER) ? sctx->num + 1 : 0;
-	ret = ovl_check_lower(pathname + sctx->dirlen, start, &chk, true);
+	ret = ovl_check_lower(path_pick(pathname, sctx->dirlen),
+			      start, &chk, true);
 	if (ret)
 		return ret;
 	if (chk.exist && !is_whiteout(&chk.st))
 		goto out;
 
 	/* Check parent directory merged or pure */
-	memcpy(parent_path, pathname, sctx->pathlen-sctx->filelen);
-	ret = ovl_check_lower(parent_path + sctx->dirlen, start, &chk, false);
+	path_truncate(parent, sizeof(parent), pathname, sctx->filename);
+	ret = ovl_check_lower(path_pick(parent, sctx->dirlen),
+			      start, &chk, false);
 	if (ret)
 		return ret;
 	if (chk.exist && is_dir(&chk.st))
@@ -396,8 +404,8 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 				       sctx->num, chk.path);
 
 		/* Check and fix whiteout or opaque dir */
-		snprintf(redirect_rpath, sizeof(redirect_rpath), "%s%s",
-			 sctx->dirname, redirect);
+		path_pack(redirect_rpath, sizeof(redirect_rpath),
+			  sctx->dirname, redirect);
 		if (lstat(redirect_rpath, &rst) != 0) {
 			if (errno != ENOENT && errno != ENOTDIR) {
 				print_err(_("Cannot stat %s: %s\n"),
-- 
2.9.5

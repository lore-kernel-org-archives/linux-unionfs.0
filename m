From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 13/18] fsck.overlay: handle missing case of redirecte directory
Date: Thu, 14 Dec 2017 14:47:42 +0800
Message-ID: <20171214064747.20999-14-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11990 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbdLNGmH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:07 -0500
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

When we find a valid reidrect dir, the lower redirect target must
be covered by a whiteout or an opaque dir or an other redirect dir.
This patch handle the missing case of another redirect dir. At the
same time, when we remove an invalid redirect xattr, we should also
consider to fix the opaque xattr for this case.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 check.c | 46 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/check.c b/check.c
index 1e40cac..ca75358 100644
--- a/check.c
+++ b/check.c
@@ -130,6 +130,16 @@ static inline int ovl_remove_redirect(const char *pathname)
 	return remove_xattr(pathname, OVL_REDIRECT_XATTR);
 }
 
+/* Just check exists */
+static inline bool ovl_is_redirect(const char *pathname)
+{
+	bool exist = false;
+	ssize_t ret;
+
+	ret = get_xattr(pathname, OVL_REDIRECT_XATTR, NULL, &exist);
+	return ret ? false : exist;
+}
+
 static inline int ovl_create_whiteout(const char *pathname)
 {
 	int ret;
@@ -380,7 +390,11 @@ static void ovl_redirect_free(void)
  *    If more than one in the same layer, there must be some inconsistency
  *    but not sure which one is invalid, just warn in 'auto' mode and remove
  *    the duplicate one in 'yes' mode.
- * 3) Check and fix the missing whiteout or opaque in redierct parent dir.
+ * 3) Check and fix the missing whiteout or opaque in redierct parent directory
+ *    if there is no another redirected upper directory covering the redirect
+ *    lower target.
+ * When a redirect xattr is removed, and the lower layers have directory with
+ * same name, add opaque to cover it.
  */
 static int ovl_check_redirect(struct scan_ctx *sctx)
 {
@@ -402,8 +416,10 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 	sctx->redirects[SC_TOTAL]++;
 
 	/* Redirect dir in last lower dir ? */
-	if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1)
+	if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1) {
+		start = lower_num;
 		goto remove;
+	}
 
 	/* Scan lower directories to check redirect dir exist or not */
 	start = (sctx->dirtype == OVL_LOWER) ? sctx->num + 1 : 0;
@@ -448,8 +464,15 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 			sctx->whiteouts[SC_CREATE]++;
 			sctx->whiteouts[SC_TOTAL]++;
 
-		} else if (is_dir(&rst) && !ovl_is_opaque(redirect_rpath)) {
-			/* Found a directory but not opaqued, fix opaque xattr */
+		} else if (is_dir(&rst) && !ovl_is_opaque(redirect_rpath) &&
+			   !ovl_is_redirect(redirect_rpath)) {
+			/*
+			 * Found a directory but not opaqued and not
+			 * redirected, fix the opaque xattr. Note that we
+			 * don't check redirect validity here, the opaque
+			 * will be fixed if it's invalid when we remove it
+			 * later.
+			 */
 			if ((ret = ovl_set_opaque(redirect_rpath)))
 				goto out;
 
@@ -467,9 +490,18 @@ remove:
 	if (!ovl_ask_invalid("Invalid redirect xattr", pathname, 1))
 		goto out;
 remove_d:
-	ret = ovl_remove_redirect(pathname);
-	if (!ret)
-		sctx->redirects[SC_INVALID_DEL]++;
+	if ((ret = ovl_remove_redirect(pathname)))
+		goto out;
+
+	sctx->redirects[SC_INVALID_DEL]++;
+
+	/* If lower directory exist, create opaque xattr to cover it */
+	if (start < lower_num) {
+		if ((ret = ovl_check_lower(pathname, start, &chk, false)))
+			goto out;
+		if (chk.exist && is_dir(&chk.st))
+			ret = ovl_set_opaque(pathname);
+	}
 out:
 	free(redirect);
 	return ret;
-- 
2.9.5

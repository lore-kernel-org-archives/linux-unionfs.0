From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 11/18] fsck.overlay: add ovl_ask_invalid helper
Date: Thu, 14 Dec 2017 14:47:40 +0800
Message-ID: <20171214064747.20999-12-yi.zhang@huawei.com>
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
 check.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/check.c b/check.c
index 0b2e303..99cd95a 100644
--- a/check.c
+++ b/check.c
@@ -141,6 +141,14 @@ static inline int ovl_create_whiteout(const char *pathname)
 	return ret;
 }
 
+static inline int ovl_ask_invalid(const char *question, const char *pathname,
+				  int action)
+{
+	print_info(_("%s: %s "), question, pathname);
+
+	return ask_question("Remove", action);
+}
+
 /*
  * Scan each lower dir lower than 'start' and check type matching,
  * we stop scan if we found something.
@@ -219,9 +227,9 @@ static int ovl_check_whiteout(struct scan_ctx *sctx)
 
 remove:
 	sctx->whiteouts[SC_INVALID]++;
+
 	/* Remove orphan whiteout directly or ask user */
-	print_info(_("Orphan whiteout: %s "), pathname);
-	if (!ask_question("Remove", 1))
+	if (!ovl_ask_invalid("Orphan whiteout", pathname, 1))
 		return 0;
 
 	ret = unlink(pathname);
@@ -285,9 +293,9 @@ static int ovl_check_opaque(struct scan_ctx *sctx)
 
 remove:
 	sctx->opaques[SC_INVALID]++;
+
 	/* Remove opaque xattr or ask user */
-	print_info(_("Invalid opaque xattr: %s "), pathname);
-	if (!ask_question("Remove", 1))
+	if (!ovl_ask_invalid("Invalid opaque xattr", pathname, 1))
 		return 0;
 
 	ret = ovl_remove_opaque(pathname);
@@ -449,9 +457,9 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 
 remove:
 	sctx->redirects[SC_INVALID]++;
+
 	/* Remove redirect xattr or ask user */
-	print_info(_("Invalid redirect xattr: %s "), pathname);
-	if (!ask_question("Remove", 1))
+	if (!ovl_ask_invalid("Invalid redirect xattr", pathname, 1))
 		goto out;
 
 	ret = ovl_remove_redirect(pathname);
-- 
2.9.5

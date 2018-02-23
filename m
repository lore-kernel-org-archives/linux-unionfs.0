Return-Path: <yangerkun@huawei.com>
From: yangerkun <yangerkun@huawei.com>
Subject: [PATCH] fsck.overlay: fix report bug
Date: Fri, 23 Feb 2018 20:00:16 +0800
Message-ID: <20180223120016.32728-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, zhaohongjiang@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Now, the ovl_scan_check will not show all the infomation
about the invalid xattr.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 check.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/check.c b/check.c
index 10d345f..e109620 100644
--- a/check.c
+++ b/check.c
@@ -904,19 +904,26 @@ static void ovl_scan_report(struct scan_ctx *sctx)
 /* Report the invalid targets left */
 static void ovl_scan_check(struct scan_ctx *sctx)
 {
-	if (sctx->i_whiteouts)
+	bool incons = false;
+
+	if (sctx->i_whiteouts) {
 		print_info(_("Invalid whiteouts %d left!\n"),
 			     sctx->i_whiteouts);
-	else if (sctx->i_redirects)
+		incons = true;
+	}
+	if (sctx->i_redirects) {
 		print_info(_("Invalid redirect directories %d left!\n"),
 			     sctx->i_redirects);
-	else if (sctx->m_impure)
+		incons = true;
+	}
+	if (sctx->m_impure) {
 		print_info(_("Directories %d missing impure xattr!\n"),
 			     sctx->m_impure);
-	else
-		return;
+		incons = true;
+	}
 
-	set_inconsistency(&status);
+	if (incons)
+		set_inconsistency(&status);
 }
 
 /* Scan upperdir and each lowerdirs, check and fix inconsistency */
-- 
2.13.6

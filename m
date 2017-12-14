From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 10/18] fsck.overlay: fix verbose flag
Date: Thu, 14 Dec 2017 14:47:39 +0800
Message-ID: <20171214064747.20999-11-yi.zhang@huawei.com>
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
 check.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/check.c b/check.c
index b3a8607..0b2e303 100644
--- a/check.c
+++ b/check.c
@@ -472,7 +472,7 @@ static void ovl_scan_report(struct scan_ctx *sctx)
 {
 	int i_whiteouts, i_opaques, i_redirects;
 
-	if (flags | FL_VERBOSE) {
+	if (flags & FL_VERBOSE) {
 		print_info(_("Scan %d directories, %d files\n"),
 			   sctx->directories, sctx->files);
 		print_info(_("Whiteouts: %d/%d/%d/%d [Total/Invalid/Deleted/Create]\n"),
@@ -515,11 +515,11 @@ int ovl_scan_fix(void)
 	unsigned int i;
 	int ret = 0;
 
-	if (flags | FL_VERBOSE)
+	if (flags & FL_VERBOSE)
 		print_info(_("Scan and fix: [whiteouts|opaque|redirectdir]\n"));
 
 	/* Scan upper directory */
-	if (flags | FL_VERBOSE)
+	if (flags & FL_VERBOSE)
 		print_info(_("Scan upper directory: %s\n"), upperdir);
 
 	sctx.dirname = upperdir;
@@ -532,7 +532,7 @@ int ovl_scan_fix(void)
 
 	/* Scan every lower directories */
 	for (i = 0; i < lower_num; i++) {
-		if (flags | FL_VERBOSE)
+		if (flags & FL_VERBOSE)
 			print_info(_("Scan upper directory: %s\n"), lowerdir[i]);
 
 		sctx.dirname = lowerdir[i];
-- 
2.9.5

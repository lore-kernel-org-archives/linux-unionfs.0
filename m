From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 12/18] fsck.overlay: remove duplicate redirect xattr in yes mode
Date: Thu, 14 Dec 2017 14:47:41 +0800
Message-ID: <20171214064747.20999-13-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11991 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751551AbdLNGmG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:06 -0500
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

For the duplicate redirect directories which point to the same origin,
we cannot confirm which one is invalid now, so cannot remove it in 'auto'
mode for safty reason. But in 'yes' mode, we remove the duplicate one
directly for consistency.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 check.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/check.c b/check.c
index 99cd95a..1e40cac 100644
--- a/check.c
+++ b/check.c
@@ -378,7 +378,8 @@ static void ovl_redirect_free(void)
  * 1) Check the origin directory exist or not. If not, remove xattr.
  * 2) Count how many directories the origin directory was redirected by.
  *    If more than one in the same layer, there must be some inconsistency
- *    but not sure, just warn.
+ *    but not sure which one is invalid, just warn in 'auto' mode and remove
+ *    the duplicate one in 'yes' mode.
  * 3) Check and fix the missing whiteout or opaque in redierct parent dir.
  */
 static int ovl_check_redirect(struct scan_ctx *sctx)
@@ -420,7 +421,11 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 				   chk.path, pathname, tmp);
 
 			sctx->redirects[SC_INVALID]++;
-			set_st_inconsistency(&status);
+
+			/* Don't remove in auto mode */
+			if (ovl_ask_invalid("Duplicate redirect xattr",
+					     pathname, 0))
+				goto remove_d;
 		}
 
 		ovl_redirect_entry_add(pathname, sctx->dirtype,
@@ -461,7 +466,7 @@ remove:
 	/* Remove redirect xattr or ask user */
 	if (!ovl_ask_invalid("Invalid redirect xattr", pathname, 1))
 		goto out;
-
+remove_d:
 	ret = ovl_remove_redirect(pathname);
 	if (!ret)
 		sctx->redirects[SC_INVALID_DEL]++;
-- 
2.9.5

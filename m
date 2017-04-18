From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/4] fstests: add helper _require_exportfs
Date: Tue, 18 Apr 2017 21:17:23 +0300
Message-ID: <1492539444-25938-4-git-send-email-amir73il@gmail.com>
References: <1492539444-25938-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36528 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752936AbdDRSRV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2017 14:17:21 -0400
In-Reply-To: <1492539444-25938-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

Use open_by_handle -c to determine if filesystem supports NFS export
---
 common/rc | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/common/rc b/common/rc
index 685b859..f24a21f 100644
--- a/common/rc
+++ b/common/rc
@@ -2857,6 +2857,15 @@ _require_freeze()
 	[ $result -eq 0 ] || _notrun "$FSTYP does not support freezing"
 }
 
+# Does NFS export work on this fs?
+_require_exportfs()
+{
+	mkdir -p "$TEST_DIR"/export_test
+	$here/src/open_by_handle -c "$TEST_DIR"/export_test 2>&1 \
+		|| _notrun "$FSTYP does not support NFS export"
+}
+
+
 # Does shutdown work on this fs?
 _require_scratch_shutdown()
 {
-- 
2.7.4

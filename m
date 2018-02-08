From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v3 2/5] overlay: define common overlay xattr keys
Date: Thu, 8 Feb 2018 11:19:10 +0800
Message-ID: <20180208031913.14013-3-yi.zhang@huawei.com>
References: <20180208031913.14013-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:51455 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750736AbeBHDKm (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Feb 2018 22:10:42 -0500
In-Reply-To: <20180208031913.14013-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Define common overlay xattr keys from Linux kernel for ovl tests use.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 common/overlay | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/common/overlay b/common/overlay
index 16f13a8..9000432 100644
--- a/common/overlay
+++ b/common/overlay
@@ -3,6 +3,16 @@
 #
 . ./common/module
 
+# Export overlayfs xattrs and constant value
+export OVL_XATTR_OPAQUE="trusted.overlay.opaque"
+export OVL_XATTR_REDIRECT="trusted.overlay.redirect"
+export OVL_XATTR_IMPURE="trusted.overlay.impure"
+export OVL_XATTR_ORIGIN="trusted.overlay.origin"
+export OVL_XATTR_NLINK="trusted.overlay.nlink"
+export OVL_XATTR_UPPER="trusted.overlay.upper"
+export OVL_XATTR_OPAQUE_VAL="y"
+export OVL_XATTR_IMPURE_VAL="y"
+
 # helper function to do the actual overlayfs mount operation
 _overlay_mount_dirs()
 {
-- 
2.5.0

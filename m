From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v3] common/rc: perform _require_metadata_journaling check on overlay base fs
Date: Sat,  6 Jan 2018 16:23:58 +0800
Message-ID: <1515227038-50536-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:42647 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752450AbeAFIZc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 6 Jan 2018 03:25:32 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: amir73il@gmail.com, eguan@redhat.com
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

Currently generic shutdown tests are enabled on overlayfs by extending
_require_scratch_shutdown() to check shutdown support for overlayfs,
some of those tests also call _require_metadata_journaling() to inspect
whether test filesystem support metadata journaling or not, so need to
extend _require_metadata_journaling() as well to check metadata journaling
support for overlayfs in case shutdown tests run on uncommon overlayfs
setup and fail. For example, base filesystem of overlayfs is ext2 or ext4
with noload mode.

Metadata journaling check is based on base filesystem configurations
and  because -overlay option saves those configurations to OVL_BASE_*,
adding restore/override the configurations before/after the check.

Tested ext2, xfs, ext4(load/no-load mode) as base filesystem of overlayfs
in single and multi section configurations.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
Changes since v2:
- Add comment for modification in the code.

Changes since v1:
- Rewrite commit log.

 common/rc | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/common/rc b/common/rc
index 9216efd..540d29d 100644
--- a/common/rc
+++ b/common/rc
@@ -3007,6 +3007,18 @@ _require_metadata_journaling()
 		# ext4 might not load a journal
 		_exclude_scratch_mount_option "noload"
 		;;
+	overlay)
+		# metadata journaling check is based on base filesystem configurations
+		# and  because -overlay option saves those configurations to OVL_BASE_*,
+		# adding restore/override the configurations before/after the check.
+		if [ ! -z $OVL_BASE_FSTYP -a $OVL_BASE_FSTYP != "overlay" ]; then
+			_overlay_config_restore
+			_require_metadata_journaling
+			_overlay_config_override
+		else
+			_notrun "Please specify underlying filesystem type in config file"
+		fi
+		;;
 	*)
 		# by default we pass; if you need to, add your fs above!
 		;;
-- 
1.8.3.1

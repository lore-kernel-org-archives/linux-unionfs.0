From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v2] common/rc: Extending _require_metadata_journaling for overlayfs in case shutdown tests run on uncommon overlayfs setup and fail
Date: Sat,  6 Jan 2018 14:29:50 +0800
Message-ID: <1515220190-17424-1-git-send-email-cgxu519@icloud.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: amir73il@gmail.com, eguan@redhat.com
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>
List-Id: linux-unionfs@vger.kernel.org

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
Changes since v1:
- Rewrite commit log.

 common/rc | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/common/rc b/common/rc
index 9216efd..83ef3f1 100644
--- a/common/rc
+++ b/common/rc
@@ -3007,6 +3007,15 @@ _require_metadata_journaling()
 		# ext4 might not load a journal
 		_exclude_scratch_mount_option "noload"
 		;;
+	overlay)
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

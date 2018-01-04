From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH] common/rc: add overlay support to _require_metadata_journaling
Date: Thu,  4 Jan 2018 11:03:37 +0800
Message-ID: <1515035017-156043-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:27985 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751566AbeADDEp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 22:04:45 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: eguan@redhat.com
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

metadata journaling check needs base filesystem configureations
and ./check -overlay saves those configurations to OVL_BASE_*,
so restore/override the configuratons before/after the check.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
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

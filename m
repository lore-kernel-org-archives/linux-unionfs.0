From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v2 1/3] common/rc: add scratch shutdown support for overlayfs
Date: Thu,  7 Dec 2017 10:22:05 +0800
Message-ID: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:23485 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752257AbdLGCWz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 21:22:55 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: eguan@redhat.com, amir73il@gmail.com
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---

Changes since v1:
_scratch_shutdown() does not call notrun.

 common/rc | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 4c053a5..911dba3 100644
--- a/common/rc
+++ b/common/rc
@@ -382,6 +382,15 @@ _scratch_cycle_mount()
     _scratch_mount "$opts"
 }
 
+_scratch_shutdown()
+{
+	if [ $FSTYP = "overlay" ]; then
+		src/godown -f $OVL_BASE_SCRATCH_MNT
+	else
+		src/godown -f $SCRATCH_MNT
+	fi
+}
+
 _test_mount()
 {
     if [ "$FSTYP" == "overlay" ]; then
@@ -2908,8 +2917,19 @@ _require_scratch_shutdown()
 
 	_scratch_mkfs > /dev/null 2>&1
 	_scratch_mount
-	src/godown -f $SCRATCH_MNT 2>&1 \
-		|| _notrun "$FSTYP does not support shutdown"
+
+	if [ $FSTYP = "overlay" ]; then
+		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
+			_notrun "$SCRATCH_DEV is not a block device"
+		else
+			src/godown -f $OVL_BASE_SCRATCH_MNT 2>&1 \
+			|| _notrun "Underlying filesystem does not support shutdown"
+		fi
+	else
+		src/godown -f $SCRATCH_MNT 2>&1 \
+			|| _notrun "$FSTYP does not support shutdown"
+	fi
+
 	_scratch_unmount
 }
 
-- 
1.8.3.1

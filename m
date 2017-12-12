From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v3 1/3] common/rc: add scratch shutdown support for overlayfs
Date: Tue, 12 Dec 2017 11:09:37 +0800
Message-ID: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:40579 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752277AbdLLDLi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Dec 2017 22:11:38 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: eguan@redhat.com, amir73il@gmail.com
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

OverlayFS overrides SCRATCH_MNT variable to it's own,
so adjust target to underlying filesystem(OVL_BASE_SCRATCH_MNT)
when running shutdown on overlayfs.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---

Changes since v2:
1. Make option for _scratch_shutdown(), so caller can 
specify option when calling.
2. Add comment for why overlay requires special handling.
3. Add commit log.

Changes since v1:
_scratch_shutdown() does not call notrun.

 common/rc | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 4c053a5..a5c4ace 100644
--- a/common/rc
+++ b/common/rc
@@ -382,6 +382,24 @@ _scratch_cycle_mount()
     _scratch_mount "$opts"
 }
 
+_scratch_shutdown()
+{
+	if [ $FSTYP = "overlay" ]; then
+		# In lagacy overlay usage, it may specify directory as 
+		# SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
+		# will be null, so check OVL_BASE_SCRATCH_DEV before
+		# running shutdown to avoid shutting down base fs accidently.
+		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
+			echo -n "Ignore shutdown because "
+			echo "$SCRATCH_DEV is not a block device"
+		else
+			src/godown $* $OVL_BASE_SCRATCH_MNT
+		fi
+	else
+		src/godown $* $SCRATCH_MNT
+	fi
+}
+
 _test_mount()
 {
     if [ "$FSTYP" == "overlay" ]; then
@@ -2908,8 +2926,23 @@ _require_scratch_shutdown()
 
 	_scratch_mkfs > /dev/null 2>&1
 	_scratch_mount
-	src/godown -f $SCRATCH_MNT 2>&1 \
-		|| _notrun "$FSTYP does not support shutdown"
+
+	if [ $FSTYP = "overlay" ]; then
+		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
+			# In lagacy overlay usage, it may specify directory as 
+			# SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
+			# will be null, so check OVL_BASE_SCRATCH_DEV before
+			# running shutdown to avoid shutting down base fs accidently.
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

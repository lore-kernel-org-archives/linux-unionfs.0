From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 1/5] fstests: implement require of multiple overlayfs features
Date: Tue, 30 Jan 2018 08:12:18 +0200
Message-ID: <1517292742-15624-2-git-send-email-amir73il@gmail.com>
References: <1517292742-15624-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40479 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752506AbeA3GLX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 Jan 2018 01:11:23 -0500
In-Reply-To: <1517292742-15624-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Some overlayfs features must be checked together, because they cannot
be enabled without a dependent feature (e.g. nfs_export and index).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay | 27 ++++++++++++++++++++++-----
 common/rc      |  2 +-
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/common/overlay b/common/overlay
index 1da4ab1..ad2f3be 100644
--- a/common/overlay
+++ b/common/overlay
@@ -122,8 +122,8 @@ _overlay_scratch_unmount()
 	_overlay_base_unmount "$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT"
 }
 
-# Require a specific overlayfs feature
-_require_scratch_overlay_feature()
+# Check that a specific overlayfs feature is supported
+__check_scratch_overlay_feature()
 {
 	local feature=$1
 
@@ -138,9 +138,6 @@ _require_scratch_overlay_feature()
 	[ "$default" = Y ] || [ "$default" = N ] || \
 		_notrun "feature '${feature}' not supported by ${FSTYP}"
 
-	_scratch_mkfs > /dev/null 2>&1
-	_scratch_mount -o ${feature}=on || \
-		_notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
 	# Check options to be sure. For example, Overlayfs will fallback to
 	# index=off if underlying fs does not support file handles.
 	# Overlayfs only displays mount option if it differs from the default.
@@ -149,5 +146,25 @@ _require_scratch_overlay_feature()
 	  ( [ "$default" = Y ] && ! _fs_options $SCRATCH_DEV | grep -q "${feature}=off" )) && \
 	    touch $SCRATCH_MNT/foo 2>/dev/null ) || \
 	        _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
+}
+
+# Require a set of overlayfs features
+_require_scratch_overlay_features()
+{
+	local features=( $* )
+	local opts="rw"
+
+	for feature in ${features[*]}; do
+		opts+=",${feature}=on"
+	done
+
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount -o $opts || \
+		_notrun "overlay options '$opts' cannot be enabled on ${SCRATCH_DEV}"
+
+	for feature in ${features[*]}; do
+		__check_scratch_overlay_feature ${feature}
+	done
+
 	_scratch_unmount
 }
diff --git a/common/rc b/common/rc
index 2e3a83a..4ad59b1 100644
--- a/common/rc
+++ b/common/rc
@@ -3726,7 +3726,7 @@ _require_scratch_feature()
 
 	case "$FSTYP" in
 	overlay)
-		_require_scratch_overlay_feature ${feature}
+		_require_scratch_overlay_features ${feature}
 		;;
 	*)
 		_fail "Test for feature '${feature}' of ${FSTYP} is not implemented"
-- 
2.7.4

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 1/5] fstests: implement require of multiple overlayfs features
Date: Sun, 28 Jan 2018 11:22:32 +0200
Message-ID: <1517131356-8048-2-git-send-email-amir73il@gmail.com>
References: <1517131356-8048-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38559 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbeA1JVi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 28 Jan 2018 04:21:38 -0500
In-Reply-To: <1517131356-8048-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Some overlayfs features must be checked together, because they cannot
be enabled without a dependent feature (e.g. nfs_export and index).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay | 23 ++++++++++++++++++++---
 common/rc      | 15 +++++++++------
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/common/overlay b/common/overlay
index 1da4ab1..38fe994 100644
--- a/common/overlay
+++ b/common/overlay
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
+		_require_scratch_overlay_feature ${feature}
+	done
+
 	_scratch_unmount
 }
diff --git a/common/rc b/common/rc
index 77a4eb4..3b81061 100644
--- a/common/rc
+++ b/common/rc
@@ -3658,22 +3658,25 @@ _get_fs_sysfs_attr()
 	cat /sys/fs/${FSTYP}/${dname}/${attr}
 }
 
-# Generic test for specific filesystem feature.
+# Generic test for specific filesystem features.
 # Currently only implemented to test overlayfs features.
-_require_scratch_feature()
+_require_scratch_features()
 {
-	local feature=$1
-
 	case "$FSTYP" in
 	overlay)
-		_require_scratch_overlay_feature ${feature}
+		_require_scratch_overlay_features $*
 		;;
 	*)
-		_fail "Test for feature '${feature}' of ${FSTYP} is not implemented"
+		_fail "Test for features '$*' of ${FSTYP} is not implemented"
 		;;
 	esac
 }
 
+_require_scratch_feature()
+{
+	_require_scratch_features $1
+}
+
 init_rc
 
 ################################################################################
-- 
2.7.4

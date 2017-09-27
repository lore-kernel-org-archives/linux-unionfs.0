From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/4] overlay: remove stale implementation of _scratch_mount_options
Date: Wed, 27 Sep 2017 10:04:09 +0300
Message-ID: <1506495852-7295-2-git-send-email-amir73il@gmail.com>
References: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:45527 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751436AbdI0HDm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Sep 2017 03:03:42 -0400
In-Reply-To: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

_scratch_mount_options() was not implemented correctly for
overlayfs and wasn't used by any overlay tests.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/common/rc b/common/rc
index 53bbb11..1a61549 100644
--- a/common/rc
+++ b/common/rc
@@ -300,26 +300,10 @@ _common_dev_mount_options()
 	echo $MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS $*
 }
 
-_overlay_basic_mount_options()
-{
-	echo "-o lowerdir=$1/$OVL_LOWER,upperdir=$1/$OVL_UPPER,workdir=$1/$OVL_WORK"
-}
-
-_overlay_mount_options()
-{
-	echo `_common_dev_mount_options` \
-	     `_overlay_basic_mount_options $1` \
-	     $OVERLAY_MOUNT_OPTIONS
-}
-
 _scratch_mount_options()
 {
 	_scratch_options mount
 
-	if [ "$FSTYP" == "overlay" ]; then
-		echo `_overlay_mount_options $OVL_BASE_SCRATCH_MNT`
-		return 0
-	fi
 	echo `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
 					$SCRATCH_DEV $SCRATCH_MNT
 }
-- 
2.7.4

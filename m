From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay/036: expect EBUSY for dir inuse only when mounting with index=on
Date: Thu, 12 Oct 2017 09:33:29 +0300
Message-ID: <1507790009-9171-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33617 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbdJLGct (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2017 02:32:49 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

This fixes test failure with kernel v4.14-rc4 and default index=off
configuration.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/036 | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/tests/overlay/036 b/tests/overlay/036
index d44efc1..544d4e4 100755
--- a/tests/overlay/036
+++ b/tests/overlay/036
@@ -11,7 +11,14 @@
 # are currently in-use by another overlayfs mount on the system and bad
 # things can happen with such configuration.
 #
-# Expect EBUSY when trying to mount overlay when:
+# Commit 2cac0c00a6cd ("ovl: get exclusive ownership on upper/work dirs")
+# in kernel v4.13 enforces upper/work dir in-use for any overlayfs mount.
+# Later stable fix commit 85fdee1eef1a ("ovl: fix regression caused by
+# exclusive upper/work dir protection") relaxes mount failure to a warning
+# for index=off mount and fails mount with EBUSY for index=on mount.
+#
+# This test expects success with index=off and EBUSY with index=on
+# when trying to mount overlay with:
 # - Upper dir is in-use by another overlay mount
 # - Work dir is in-use by another overlay mount
 #
@@ -63,6 +70,7 @@ rm -f $seqres.full
 _supported_fs overlay
 _supported_os Linux
 _require_scratch
+_require_scratch_feature index
 
 # Remove all files from previous tests
 _scratch_mkfs
@@ -78,13 +86,30 @@ mkdir -p $lowerdir $lowerdir2 $upperdir $upperdir2 $workdir $workdir2
 
 # Mount overlay with lowerdir, upperdir, workdir
 _overlay_mount_dirs $lowerdir $upperdir $workdir \
-		    overlay1 $SCRATCH_MNT
-# Try to mount another overlay with the same upperdir - expect EBUSY
+		    overlay $SCRATCH_MNT
+
+# Try to mount another overlay with the same upperdir
+# with index=off - expect success
+_overlay_mount_dirs $lowerdir2 $upperdir $workdir2 \
+		    overlay0 $SCRATCH_MNT -oindex=off && \
+		    $UMOUNT_PROG $SCRATCH_MNT
+
+# Try to mount another overlay with the same workdir
+# with index=off - expect success
+_overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
+		    overlay1 $SCRATCH_MNT -oindex=off && \
+		    $UMOUNT_PROG $SCRATCH_MNT
+
+# Try to mount another overlay with the same upperdir
+# with index=on - expect EBUSY
 _overlay_mount_dirs $lowerdir2 $upperdir $workdir2 \
-		    overlay2 $SCRATCH_MNT 2>&1 | _filter_scratch
-# Try to mount another overlay with the same workdir - expect EBUSY
+		    overlay2 $SCRATCH_MNT -oindex=on 2>&1 | _filter_scratch
+
+# Try to mount another overlay with the same workdir
+# with index=on - expect EBUSY
 _overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
-		    overlay3 $SCRATCH_MNT 2>&1 | _filter_scratch
+		    overlay3 $SCRATCH_MNT -oindex=on 2>&1 | _filter_scratch
+
 
 # success, all done
 status=0
-- 
2.7.4

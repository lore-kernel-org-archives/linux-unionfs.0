Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay/065: adjust test to expect EBUSY only with index=on
Date: Mon, 22 Jul 2019 08:02:27 +0300
Message-Id: <20190722050227.24944-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

This is needed to support the kernel regression fix commit 0be0bfd2de9d
("ovl: fix regression caused by overlapping layers detection").

Overlayfs mount is not supposed to fail due to upper/work dir in-use
by other mount unless option index=on is enabled.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

With this applied, test is expected to fail on upstream kernel,
because upstream kernel has a regression.

The kernel fix commit is on Miklos' overlayfs-next branch.

Thanks,
Amir.

 tests/overlay/065     | 26 ++++++++++++++++----------
 tests/overlay/065.out |  4 ++--
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/tests/overlay/065 b/tests/overlay/065
index abfc6737..a75a9a10 100755
--- a/tests/overlay/065
+++ b/tests/overlay/065
@@ -13,9 +13,14 @@
 #
 # Overlapping layers on mount or lookup results in ELOOP.
 # Overlapping lowerdir with other mount upperdir/workdir
-# result in EBUSY.
+# result in EBUSY (if index=on is used).
 #
-# Kernel patch "ovl: detect overlapping layers" is needed to pass the test.
+# This is a regression test for kernel commit:
+#
+#    146d62e5a586 "ovl: detect overlapping layers"
+#
+# and its followup fix commit:
+#    0be0bfd2de9d "ovl: fix regression caused by overlapping layers detection"
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
@@ -46,6 +51,7 @@ _supported_os Linux
 # Use non-default scratch underlying overlay dirs, we need to check
 # them explicity after test.
 _require_scratch_nocheck
+_require_scratch_feature index
 
 # Remove all files from previous tests
 _scratch_mkfs
@@ -61,10 +67,10 @@ mnt2=$basedir/mnt.2
 
 mkdir -p $lowerdir/lower $upperdir $workdir
 
-# Try to mount an overlay with the same upperdir/lowerdir - expect EBUSY
+# Try to mount an overlay with the same upperdir/lowerdir - expect ELOOP
 echo Conflicting upperdir/lowerdir
 _overlay_scratch_mount_dirs $upperdir $upperdir $workdir \
-	2>&1 | _filter_busy_mount
+	2>&1 | _filter_error_mount
 $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 
 # Use new upper/work dirs for each test to avoid ESTALE errors
@@ -72,11 +78,11 @@ $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 rm -rf $upperdir $workdir
 mkdir $upperdir $workdir
 
-# Try to mount an overlay with the same workdir/lowerdir - expect EBUSY
+# Try to mount an overlay with the same workdir/lowerdir - expect ELOOP
 # because $workdir/work overlaps with lowerdir
 echo Conflicting workdir/lowerdir
 _overlay_scratch_mount_dirs $workdir $upperdir $workdir \
-	2>&1 | _filter_busy_mount
+	-oindex=off 2>&1 | _filter_error_mount
 $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 
 rm -rf $upperdir $workdir
@@ -126,20 +132,20 @@ rm -rf $upperdir2 $workdir2
 mkdir -p $upperdir2 $workdir2 $mnt2
 
 # Try to mount an overlay with layers overlapping with another overlayfs
-# upperdir - expect EBUSY
+# upperdir - expect EBUSY with index=on
 echo Overlapping with upperdir of another instance
 _overlay_scratch_mount_dirs $upperdir/upper $upperdir2 $workdir2 \
-	2>&1 | _filter_busy_mount
+	-oindex=on 2>&1 | _filter_busy_mount
 $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 
 rm -rf $upperdir2 $workdir2
 mkdir -p $upperdir2 $workdir2
 
 # Try to mount an overlay with layers overlapping with another overlayfs
-# workdir - expect EBUSY
+# workdir - expect EBUSY with index=on
 echo Overlapping with workdir of another instance
 _overlay_scratch_mount_dirs $workdir/work $upperdir2 $workdir2 \
-	2>&1 | _filter_busy_mount
+	-oindex=on 2>&1 | _filter_busy_mount
 $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 
 # Move upper layer root into lower layer after mount
diff --git a/tests/overlay/065.out b/tests/overlay/065.out
index 0260327c..c63d4df8 100644
--- a/tests/overlay/065.out
+++ b/tests/overlay/065.out
@@ -1,8 +1,8 @@
 QA output created by 065
 Conflicting upperdir/lowerdir
-mount: device already mounted or mount point busy
+mount: Too many levels of symbolic links
 Conflicting workdir/lowerdir
-mount: device already mounted or mount point busy
+mount: Too many levels of symbolic links
 Overlapping upperdir/lowerdir
 mount: Too many levels of symbolic links
 Conflicting lower layers
-- 
2.17.1

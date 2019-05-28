Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay: Test mount error cases with overlapping layers
Date: Tue, 28 May 2019 11:27:14 +0300
Message-Id: <20190528082714.18965-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Add tests for overlayfs mounts with:
- Same upperdir/lowerdir
- Overlapping upperdir/lowerdir
- Overlapping lowerdir layers
- Overlapping lowerdir with other mount upperdir/workdir

Add test for moving layer into another after mount.

Overlapping layers on mount or lookup results in ELOOP.
Overlapping lowerdir with other mount upperdir/workdir
result in EBUSY.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

This new test is expected to fail with upstream kernel.
It is fixed by commit 0e7f2cccb42a ("ovl: detect overlapping layers")
in Miklos' overlayfs-next branch.

Thanks,
Amir.

 tests/overlay/065     | 149 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/065.out |  21 ++++++
 tests/overlay/group   |   1 +
 3 files changed, 171 insertions(+)
 create mode 100755 tests/overlay/065
 create mode 100644 tests/overlay/065.out

diff --git a/tests/overlay/065 b/tests/overlay/065
new file mode 100755
index 00000000..1f411b09
--- /dev/null
+++ b/tests/overlay/065
@@ -0,0 +1,149 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test 065
+#
+# Test mount error cases with overlapping layers
+#
+# - Same upperdir/lowerdir
+# - Overlapping upperdir/lowerdir
+# - Overlapping lowerdir layers
+# - Overlapping lowerdir with other mount upperdir/workdir
+#
+# Overlapping layers on mount or lookup results in ELOOP.
+# Overlapping lowerdir with other mount upperdir/workdir
+# result in EBUSY.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	$UMOUNT_PROG $mnt2 2>/dev/null
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create multiple lowerdirs, upperdirs and workdir
+basedir=$OVL_BASE_SCRATCH_MNT
+lowerdir=$basedir/lower
+upperdir=$basedir/upper
+workdir=$basedir/workdir
+upperdir2=$basedir/upper.2
+workdir2=$basedir/workdir.2
+mnt2=$basedir/mnt.2
+
+mkdir -p $lowerdir/lower $upperdir $workdir
+
+# Try to mount an overlay with the same upperdir/lowerdir - expect EBUSY
+echo Conflicting upperdir/lowerdir
+_overlay_scratch_mount_dirs $upperdir $upperdir $workdir \
+	2>&1 | _filter_busy_mount
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+# Use new upper/work dirs for each test to avoid ESTALE errors
+# on mismatch lowerdir/upperdir (see test overlay/037)
+rm -rf $upperdir $workdir
+mkdir $upperdir $workdir
+
+# Try to mount an overlay with the same workdir/lowerdir - expect EBUSY
+# because $workdir/work overlaps with lowerdir
+echo Conflicting workdir/lowerdir
+_overlay_scratch_mount_dirs $workdir $upperdir $workdir \
+	2>&1 | _filter_busy_mount
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+rm -rf $upperdir $workdir
+mkdir $upperdir $workdir
+
+# Try to mount an overlay with overlapping upperdir/lowerdir - expect ELOOP
+echo Overlapping upperdir/lowerdir
+_overlay_scratch_mount_dirs $basedir $upperdir $workdir \
+	2>&1 | _filter_error_mount
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+rm -rf $upperdir $workdir
+mkdir $upperdir $workdir
+
+# Try to mount an overlay with the same lower layers - expect EEXIST
+echo Conflicting lower layers
+_overlay_scratch_mount_dirs $lowerdir:$lowerdir $upperdir $workdir \
+	2>&1 | _filter_error_mount
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+rm -rf $upperdir $workdir
+mkdir $upperdir $workdir
+
+# Try to mount an overlay with overlapping lower layers - expect ELOOP
+echo Overlapping lower layers below
+_overlay_scratch_mount_dirs $lowerdir:$lowerdir/lower $upperdir $workdir \
+	2>&1 | _filter_error_mount
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+rm -rf $upperdir $workdir
+mkdir $upperdir $workdir
+
+# Try to mount an overlay with overlapping lower layers - expect ELOOP
+echo Overlapping lower layers above
+_overlay_scratch_mount_dirs $lowerdir/lower:$lowerdir $upperdir $workdir \
+	2>&1 | _filter_error_mount
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+rm -rf $upperdir $workdir
+mkdir -p $upperdir/upper $workdir $mnt2
+
+# Mount overlay with non overlapping lowerdir, upperdir, workdir - expect success
+_overlay_mount_dirs $lowerdir $upperdir $workdir overlay $mnt2
+
+rm -rf $upperdir2 $workdir2
+mkdir -p $upperdir2 $workdir2 $mnt2
+
+# Try to mount an overlay with layers overlapping with another overlayfs upperdir - expect EBUSY
+echo Overlapping with upperdir of another instance
+_overlay_scratch_mount_dirs $upperdir/upper $upperdir2 $workdir2 \
+	2>&1 | _filter_busy_mount
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+rm -rf $upperdir2 $workdir2
+mkdir -p $upperdir2 $workdir2
+
+# Try to mount an overlay with layers overlapping with another overlayfs workdir - expect EBUSY
+echo Overlapping with workdir of another instance
+_overlay_scratch_mount_dirs $workdir/work $upperdir2 $workdir2 \
+	2>&1 | _filter_busy_mount
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+# Move upper layer root into lower layer after mount
+echo Overlapping upperdir/lowerdir after mount
+mv $upperdir $lowerdir/
+# Lookup files in overlay mount with overlapping layers - expect ELOOP
+# when overlay merge dir is found
+find $mnt2 2>&1 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/065.out b/tests/overlay/065.out
new file mode 100644
index 00000000..0260327c
--- /dev/null
+++ b/tests/overlay/065.out
@@ -0,0 +1,21 @@
+QA output created by 065
+Conflicting upperdir/lowerdir
+mount: device already mounted or mount point busy
+Conflicting workdir/lowerdir
+mount: device already mounted or mount point busy
+Overlapping upperdir/lowerdir
+mount: Too many levels of symbolic links
+Conflicting lower layers
+mount: Too many levels of symbolic links
+Overlapping lower layers below
+mount: Too many levels of symbolic links
+Overlapping lower layers above
+mount: Too many levels of symbolic links
+Overlapping with upperdir of another instance
+mount: device already mounted or mount point busy
+Overlapping with workdir of another instance
+mount: device already mounted or mount point busy
+Overlapping upperdir/lowerdir after mount
+SCRATCH_DEV/mnt.2
+SCRATCH_DEV/mnt.2/lower
+find: 'SCRATCH_DEV/mnt.2/upper': Too many levels of symbolic links
diff --git a/tests/overlay/group b/tests/overlay/group
index 494656e1..8bde6ea1 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -67,3 +67,4 @@
 062 auto quick exportfs
 063 auto quick whiteout
 064 auto quick copyup
+065 auto quick mount
-- 
2.17.1

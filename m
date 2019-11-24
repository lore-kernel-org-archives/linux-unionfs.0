Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay: Test unique st_dev;st_ino on non-samefs setup
Date: Sun, 24 Nov 2019 16:29:57 +0200
Message-Id: <20191124142957.20873-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Check that files from middle layer on same fs as upper layer
are not allowed to export the real inode st_dev;st_ino.

This is a regression test for kernel commit:
  ovl: fix corner case of non-unique st_dev;st_ino

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

This is a test for kernel v4.17 regression I noticed during discussion
on an unrelated change.

The fix for this regression has been posted [1] last week, but did not
get any feedback yet. So maybe wait with merging the test until Miklos
ackloledges the bug, or until the fix commit has a final description.

As the test demonstrates in a simple user scenario, the problem is real,
although I have no idea how common this setup is in the wild.

Thanks,
Amir.

[1] https://marc.info/?l=linux-unionfs&m=157400544201252&w=2

 tests/overlay/067     | 94 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/067.out |  2 +
 tests/overlay/group   |  1 +
 3 files changed, 97 insertions(+)
 create mode 100755 tests/overlay/067
 create mode 100644 tests/overlay/067.out

diff --git a/tests/overlay/067 b/tests/overlay/067
new file mode 100755
index 00000000..88bcd399
--- /dev/null
+++ b/tests/overlay/067
@@ -0,0 +1,94 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 CTERA Networks. All Rights Reserved.
+#
+# FSQA Test No. 067
+#
+# Test unique st_dev;st_ino on non-samefs setup.
+#
+# Check that files from middle layer on same fs as upper layer
+# are not allowed to export the real inode st_dev;st_ino.
+#
+# This is a regression test for kernel commit:
+#   ovl: fix corner case of non-unique st_dev;st_ino
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
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
+_require_test
+
+# Lower is on test partition
+lower=$OVL_BASE_TEST_DIR/$OVL_LOWER-$seq
+# Upper/work are on scratch partition
+middle=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upper=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+work=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+
+rm -rf $lower
+mkdir $lower
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+realfile=$middle/file
+testfile=$SCRATCH_MNT/file
+
+# Create a file on middle layer on same fs as upper layer
+echo wrong > $realfile
+
+# Mount an overlay on $SCRATCH_MNT with lower layer on test partition
+# and middle and upper layer on scratch partition.
+# Disable xino, so not all overlay inodes are on the same st_dev.
+_overlay_scratch_mount_dirs $middle:$lower $upper $work -o xino=off || \
+	_notrun "cannot mount overlay with xino=off option"
+
+stat $realfile >>$seqres.full
+stat $testfile >>$seqres.full
+
+# Diverge the content of the overlay file from its origin
+echo right > $testfile
+
+stat $testfile >>$seqres.full
+
+# Expect the overlay file to differ from the original lower file
+diff -q $realfile $testfile >>$seqres.full &&
+	echo "diff with middle layer file doesn't know right from wrong! (warm cache)"
+
+echo 3 > /proc/sys/vm/drop_caches
+
+stat $testfile >>$seqres.full
+
+# Expect the overlay file to differ from the original lower file
+diff -q $realfile $testfile >>$seqres.full &&
+	echo "diff with middle layer file doesn't know right from wrong! (cold cache)"
+
+$UMOUNT_PROG $SCRATCH_MNT
+# check overlayfs
+_overlay_check_scratch_dirs $middle:$lower $upper $work -o xino=off
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/067.out b/tests/overlay/067.out
new file mode 100644
index 00000000..daa15453
--- /dev/null
+++ b/tests/overlay/067.out
@@ -0,0 +1,2 @@
+QA output created by 067
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 1dec7db9..b7cd7774 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -69,3 +69,4 @@
 064 auto quick copyup
 065 auto quick mount
 066 auto quick copyup
+067 auto quick copyup nonsamefs
-- 
2.17.1

Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH 3/3] overlay: add fsck.overlay exception tests
Date: Sat, 28 Jul 2018 16:42:42 +0800
Message-ID: <20180728084242.33918-4-yi.zhang@huawei.com>
In-Reply-To: <20180728084242.33918-1-yi.zhang@huawei.com>
References: <20180728084242.33918-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: guaneryu@gmail.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Introduce some exception test cases for fsck.overlay which runs on
invalid/unnormal underlying dirs or invalid input parameters to test
exception handling processes.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/062     | 236 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/062.out |  10 +++
 tests/overlay/group   |   1 +
 3 files changed, 247 insertions(+)
 create mode 100755 tests/overlay/062
 create mode 100644 tests/overlay/062.out

diff --git a/tests/overlay/062 b/tests/overlay/062
new file mode 100755
index 0000000..31f856d
--- /dev/null
+++ b/tests/overlay/062
@@ -0,0 +1,236 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Huawei.  All Rights Reserved.
+#
+# FS QA Test No. 062
+#
+# Exception test: test fsck.overlay runs on invalid underlying
+# dirs or with invalid input options.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1        # failure is the default!
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
+. ./common/attr
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch_nocheck
+_require_attrs
+_require_command "$FSCK_OVERLAY_PROG" fsck.overlay
+_require_chattr i
+
+# remove all files from previous tests
+_scratch_mkfs
+
+# Create a whiteout
+make_whiteout()
+{
+	for arg in $*; do
+		mknod $arg c 0 0
+	done
+}
+
+# Create a redirect directory
+make_redirect_dir()
+{
+	local target=$1
+	local value=$2
+
+	mkdir -p $target
+	$SETFATTR_PROG -n $OVL_XATTR_REDIRECT -v $value $target
+}
+
+# Run fsck.overlay and check return value
+run_fsck()
+{
+	local expect=$1
+	local lowerdir=$2
+	local upperdir=$3
+	local workdir=$4
+	shift 4
+
+	[[ -n $lowerdir ]] && idirs=$(echo -n "-o lowerdir=$lowerdir")
+	[[ -n $upperdir ]] && idirs=$(echo -n "$idirs -o upperdir=$upperdir")
+	[[ -n $workdir ]] && idirs=$(echo -n "$idirs -o workdir=$workdir")
+
+	$FSCK_OVERLAY_PROG $idirs $* >> $seqres.full 2>&1
+	fsck_ret=$?
+
+	[[ "$fsck_ret" == "$expect" ]] || \
+		echo "fsck return unexpected:$expect,$fsck_ret"
+}
+
+# Create test directories
+lowerdir=$OVL_BASE_SCRATCH_MNT/lower
+lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
+
+make_test_dirs()
+{
+	rm -rf $lowerdir $lowerdir2 $upperdir $workdir
+	mkdir -p $lowerdir $lowerdir2 $upperdir $workdir
+}
+
+# Test incomplete underlying dirs, should fail
+echo "+ Invalid input"
+make_test_dirs
+
+none_dir=""
+
+run_fsck $FSCK_USAGE $lowerdir $none_dir $none_dir
+run_fsck $FSCK_USAGE $lowerdir $upperdir $none_dir
+run_fsck $FSCK_USAGE $none_dir $upperdir $workdir
+
+
+# Test invalid underlying dirs, should fail
+echo "+ Invalid input(2)"
+make_test_dirs
+
+invalid_dir=$OVL_BASE_SCRATCH_MNT/invalid_dir
+
+run_fsck $FSCK_ERROR $lowerdir $upperdir $invalid_dir
+run_fsck $FSCK_ERROR $lowerdir $invalid_dir $workdir
+run_fsck $FSCK_ERROR $invalid_dir $upperdir $workdir
+
+
+# Test conflict input options, should fail
+echo "+ Invalid input(3)"
+make_test_dirs
+
+run_fsck $FSCK_USAGE $lowerdir $upperdir $workdir -pn
+run_fsck $FSCK_USAGE $lowerdir $upperdir $workdir -yn
+run_fsck $FSCK_USAGE $lowerdir $upperdir $workdir -py
+run_fsck $FSCK_USAGE $lowerdir $upperdir $workdir -pyn
+
+
+# Test upperdir and lowerdir belong to different base filesystems, should fail
+echo "+ Invalid workdir"
+make_test_dirs
+
+test_workdir=$OVL_BASE_TEST_DIR/work
+mkdir -p $test_workdir
+run_fsck $FSCK_ERROR $lowerdir $upperdir $test_workdir
+rm -rf $test_workdir
+
+
+# Test upperdir is subdir of workdir and vice versa, should fail
+echo "+ Invalid workdir(2)"
+make_test_dirs
+
+test_workdir=$upperdir/work
+test_upperdir=$workdir/upper
+mkdir -p $test_workdir $test_upperdir
+
+run_fsck $FSCK_ERROR $lowerdir $upperdir $test_workdir
+run_fsck $FSCK_ERROR $lowerdir $test_upperdir $workdir
+
+
+# Test upper layer is read-only, should fail in "!no" mode, and should
+# return the real consistent result in "no" mode.
+echo "+ Upper read-only"
+make_test_dirs
+
+test_lowerdir=$OVL_BASE_TEST_DIR/lower
+mkdir -p $test_lowerdir
+
+# Let upper layer read-only
+$MOUNT_PROG -o remount,ro $OVL_BASE_SCRATCH_MNT > /dev/null 2>&1
+# Refuse to check read-only upper layer
+run_fsck $FSCK_ERROR $test_lowerdir $upperdir $workdir
+run_fsck $FSCK_ERROR $test_lowerdir $upperdir $workdir -p
+run_fsck $FSCK_ERROR $test_lowerdir $upperdir $workdir -y
+# Allow to use "no" mode scan read-only upper layer
+run_fsck $FSCK_OK $test_lowerdir $upperdir $workdir -n
+$MOUNT_PROG -o remount,rw $OVL_BASE_SCRATCH_MNT > /dev/null 2>&1
+
+# Make a simple inconsistency on the upper layer and expect return failure
+make_whiteout $upperdir/invalid
+$MOUNT_PROG -o remount,ro $OVL_BASE_SCRATCH_MNT > /dev/null 2>&1
+run_fsck $FSCK_UNCORRECTED $test_lowerdir $upperdir $workdir -n
+$MOUNT_PROG -o remount,rw $OVL_BASE_SCRATCH_MNT > /dev/null 2>&1
+rm -rf $test_lowerdir
+
+
+# Test lower layer is read-only, should sacn each layer and return
+# the real consistent result.
+echo "+ Lower read-only"
+make_test_dirs
+
+test_lowerdir=$OVL_BASE_TEST_DIR/lower
+mkdir -p $test_lowerdir
+
+# Let lower layer read-only
+$MOUNT_PROG -o remount,ro $OVL_BASE_TEST_DIR > /dev/null 2>&1
+# Allow check read-only lower layers in all modes
+run_fsck $FSCK_OK $test_lowerdir $upperdir $workdir -p
+$MOUNT_PROG -o remount,rw $OVL_BASE_TEST_DIR > /dev/null 2>&1
+
+# Make a simple inconsistency on the read-only lower layer and expect
+# return failure.
+make_whiteout $test_lowerdir/invalid
+$MOUNT_PROG -o remount,ro $OVL_BASE_TEST_DIR > /dev/null 2>&1
+run_fsck $FSCK_UNCORRECTED $test_lowerdir $upperdir $workdir -p
+$MOUNT_PROG -o remount,rw $OVL_BASE_TEST_DIR > /dev/null 2>&1
+rm -rf $test_lowerdir
+
+
+# Test one of the lower layers is read-only, should sacn each layer and
+# return the real consistent result.
+echo "+ Lower read-only(2)"
+make_test_dirs
+
+test_lowerdir=$OVL_BASE_TEST_DIR/lower
+mkdir -p $test_lowerdir
+
+# Let lower layer read-only
+$MOUNT_PROG -o remount,ro $OVL_BASE_TEST_DIR > /dev/null 2>&1
+# Make a simple inconsistency on the bottom read-write lower layer
+# and expect return success (consistent middle read-only layer should
+# not affect the result).
+make_whiteout $lowerdir2/invalid
+run_fsck $FSCK_NONDESTRUCT $test_lowerdir:$lowerdir2 $upperdir $workdir -p
+$MOUNT_PROG -o remount,rw $OVL_BASE_TEST_DIR > /dev/null 2>&1
+
+# Make a simple inconsistency on the middle read-only lower layer
+# and expect return failure.
+make_whiteout $test_lowerdir/invalid
+$MOUNT_PROG -o remount,ro $OVL_BASE_TEST_DIR > /dev/null 2>&1
+run_fsck $FSCK_UNCORRECTED $test_lowerdir:$lowerdir2 $upperdir $workdir -p
+$MOUNT_PROG -o remount,rw $OVL_BASE_TEST_DIR > /dev/null 2>&1
+rm -rf $test_lowerdir
+
+
+# Test encounter error when try to fix some inconsistency, should fail
+echo "+ Encounter error"
+make_test_dirs
+
+# Make a simple inconsistency and set immutable flag to simulate fix error
+make_redirect_dir $upperdir/testdir "invalid"
+
+$CHATTR_PROG +i $upperdir/testdir
+run_fsck $(($FSCK_UNCORRECTED+$FSCK_ERROR)) $lowerdir $upperdir $workdir -p
+$CHATTR_PROG -i $upperdir/testdir
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/062.out b/tests/overlay/062.out
new file mode 100644
index 0000000..021b74f
--- /dev/null
+++ b/tests/overlay/062.out
@@ -0,0 +1,10 @@
+QA output created by 062
++ Invalid input
++ Invalid input(2)
++ Invalid input(3)
++ Invalid workdir
++ Invalid workdir(2)
++ Upper read-only
++ Lower read-only
++ Lower read-only(2)
++ Encounter error
diff --git a/tests/overlay/group b/tests/overlay/group
index 7d13271..37c0b03 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -64,3 +64,4 @@
 059 auto quick copyup
 060 auto quick metacopy
 061 auto stress fsck
+062 auto quick fsck
-- 
2.5.0

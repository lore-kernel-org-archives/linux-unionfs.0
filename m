From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v3 3/5] overlay: add fsck.overlay whiteout test
Date: Thu, 8 Feb 2018 11:19:11 +0800
Message-ID: <20180208031913.14013-4-yi.zhang@huawei.com>
References: <20180208031913.14013-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180208031913.14013-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

Add fsck.overlay test case to test it how to deal with orphan/valid
whiteouts in underlying directories of overlayfs.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/201     | 228 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/201.out |  10 +++
 tests/overlay/group   |   1 +
 3 files changed, 239 insertions(+)
 create mode 100755 tests/overlay/201
 create mode 100644 tests/overlay/201.out

diff --git a/tests/overlay/201 b/tests/overlay/201
new file mode 100755
index 0000000..7c41a9b
--- /dev/null
+++ b/tests/overlay/201
@@ -0,0 +1,228 @@
+#! /bin/bash
+# FS QA Test 201
+#
+# Test fsck.overlay how to deal with whiteouts in overlayfs.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Huawei.  All Rights Reserved.
+# Author: zhangyi (F) <yi.zhang@huawei.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
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
+
+# remove all files from previous tests
+_scratch_mkfs
+
+# Check whiteout
+check_whiteout()
+{
+	for arg in $*; do
+		local ttype=`stat -c "%F:%t,%T" $arg`
+
+		[[ "$ttype" == "character special file:0,0" ]] || \
+			echo "Valid whiteout removed incorrectly"
+	done
+}
+
+# Create a whiteout
+make_whiteout()
+{
+	for arg in $*; do
+		mknod $arg c 0 0
+	done
+}
+
+# Create an opaque directory
+make_opaque_dir()
+{
+	local target=$1
+
+	mkdir -p $target
+	$SETFATTR_PROG -n $OVL_XATTR_OPAQUE -v $OVL_XATTR_OPAQUE_VAL $target
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
+# Test orphan whiteout in lower and upper layer, should remove
+echo "+ Orphan whiteout"
+make_test_dirs
+make_whiteout $lowerdir/foo $upperdir/{foo,bar}
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+	echo "fsck should not fail"
+ls $lowerdir
+ls $upperdir
+
+# Test valid whiteout covering lower target, should not remove
+echo "+ Valid whiteout"
+make_test_dirs
+touch $lowerdir2/{foo,bar}
+make_whiteout $upperdir/foo $lowerdir/bar
+
+_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
+	 $seqres.full 2>&1 || echo "fsck should not fail"
+check_whiteout $upperdir/foo $lowerdir/bar
+
+# Test orphan whiteout in opaque directory, should remove
+echo "+ Orphan whiteout(2)"
+make_test_dirs
+mkdir $lowerdir/testdir
+touch $lowerdir/testdir/foo
+make_opaque_dir $upperdir/testdir
+make_whiteout $upperdir/testdir/foo
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+	echo "fsck should not fail"
+ls $upperdir/testdir
+
+# Test orphan whiteout whose parent path is not an merged directory,
+# should remove
+echo "+ Orphan whiteout(3)"
+make_test_dirs
+mkdir $lowerdir2/{testdir1,testdir2,testdir3}
+touch $lowerdir2/{testdir1/foo,testdir2/foo,testdir3/foo}
+mkdir $upperdir/{testdir1,testdir2,testdir3,testdir4}
+touch $lowerdir/testdir1
+make_whiteout $lowerdir/testdir2
+make_opaque_dir $lowerdir/testdir3
+make_whiteout $upperdir/{testdir1/foo,/testdir2/foo,testdir3/foo,testdir4/foo}
+
+_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
+	$seqres.full 2>&1 || echo "fsck should not fail"
+ls $upperdir/testdir1
+ls $upperdir/testdir2
+ls $upperdir/testdir3
+ls $upperdir/testdir4
+
+# Test orphan whiteout in redirect directory, should remove
+echo "+ Orphan whiteout(4)"
+make_test_dirs
+mkdir $lowerdir/{testdir,origin}
+touch $lowerdir/testdir/foo
+make_redirect_dir $upperdir/testdir "origin"
+make_whiteout $upperdir/testdir/foo
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+	echo "fsck should not fail"
+ls $upperdir/testdir
+
+# Test valid whiteout in redirect directory cover file in lower
+# redirect origin directory, should not remove
+echo "+ Valid whiteout(2)"
+make_test_dirs
+mkdir $lowerdir/origin
+touch $lowerdir/origin/foo
+make_redirect_dir $upperdir/testdir "origin"
+make_whiteout $upperdir/testdir/foo
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+	echo "fsck should not fail"
+check_whiteout $upperdir/testdir/foo
+
+# Test valid whiteout covering lower target whose parent directory
+# merge with a redirect directory in the middle layer, should not remove.
+echo "+ Valid whiteout(3)"
+make_test_dirs
+mkdir -p $lowerdir2/origin/subdir
+touch $lowerdir2/origin/subdir/foo
+make_redirect_dir $lowerdir/testdir "origin"
+mkdir -p $upperdir/testdir/subdir
+make_whiteout $upperdir/testdir/subdir/foo
+
+_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p \
+	>> $seqres.full 2>&1 || echo "fsck should not fail"
+check_whiteout $upperdir/testdir/subdir/foo
+
+# Test invalid whiteout in opaque subdirectory in a redirect directory,
+# should remove
+echo "+ Orphan whiteout(5)"
+make_test_dirs
+mkdir -p $lowerdir/origin/subdir
+touch $lowerdir/origin/subdir/foo
+make_redirect_dir $upperdir/testdir "origin"
+make_opaque_dir $upperdir/testdir/subdir
+make_whiteout $upperdir/testdir/subdir/foo
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+	echo "fsck should not fail"
+ls $upperdir/testdir/subdir
+
+# Test valid whiteout in reidrect subdirectory in a opaque directory
+# covering lower target, should not remove
+echo "+ Valid whiteout(4)"
+make_test_dirs
+mkdir $lowerdir/origin
+touch $lowerdir/origin/foo
+make_opaque_dir $upperdir/testdir
+make_redirect_dir $upperdir/testdir/subdir "/origin"
+make_whiteout $upperdir/testdir/subdir/foo
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+        echo "fsck should not fail"
+check_whiteout $upperdir/testdir/subdir/foo
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/201.out b/tests/overlay/201.out
new file mode 100644
index 0000000..157bb85
--- /dev/null
+++ b/tests/overlay/201.out
@@ -0,0 +1,10 @@
+QA output created by 201
++ Orphan whiteout
++ Valid whiteout
++ Orphan whiteout(2)
++ Orphan whiteout(3)
++ Orphan whiteout(4)
++ Valid whiteout(2)
++ Valid whiteout(3)
++ Orphan whiteout(5)
++ Valid whiteout(4)
diff --git a/tests/overlay/group b/tests/overlay/group
index 40c1a05..50e0d5b 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -56,3 +56,4 @@
 053 auto quick copyup redirect exportfs nonsamefs
 054 auto quick copyup redirect exportfs
 055 auto quick copyup redirect exportfs nonsamefs
+201 auto quick fsck
-- 
2.5.0

From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V4] overlay: Test consistent d_ino feature for non-samefs setup
Date: Thu, 12 Oct 2017 19:04:32 +0530
Message-ID: <20171012133432.20645-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43114 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757424AbdJLNdr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2017 09:33:47 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9CDTghT073209
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2017 09:33:47 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2dj79yxvy3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2017 09:33:46 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 12 Oct 2017 07:33:46 -0600
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org, amir73il@gmail.com, david@fromorbit.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org, eguan@redhat.com

This commit adds a test to verify consistent d_ino feature when
the overlayfs instance is composed of two different underlying
filesystem instances.

For example,
$ mount -t xfs /dev/loop0 /mnt/test
$ mount -t xfs /dev/loop1 /mnt/scratch
$ mkdir /mnt/scratch/upper
$ mkdir /mnt/scratch/work
$ mount -t overlay overlay -o lowerdir=/mnt/test \
        -o upperdir=/mnt/scratch/upper \
	-o workdir=/mnt/scratch/work /mnt/merge

The goal of this test is to verify that the inode numbers returned by
readdir(3) (i.e. dirent->d_ino) are consistent with inode numbers
returned by stat(2) (i.e. stat->st_ino) in all the below listed cases,
- Parent's (i.e. "..") d_ino must always be calculated because a
  pure dir can be residing inside a merged dir.
- d_ino for "." must always be calculated because the present
  directory can have a copy-up origin.
- Verify d_ino of '.' and '..' before and after dir becomes impure.
  While at it also verify if trusted.overlay.impure xattr is
  set/reset appropriately and invalidation of readdir cache.
- Verify copied up file's (inside a impure dir) d_ino.
- Verify invalidation of readdir cache.
- Verify d_ino values corresponding to "." and ".." entries of a
  pure lower dir.
- Verify d_ino of ".." entry of a merged dir.
- Verify pure lower residing in dir which has another lower layer

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
Eryu,
This test requires the following "yet to be upstreamed" overlayfs kernel
patches to be merged,
https://marc.info/?l=linux-unionfs&m=150728247029074&w=2
https://marc.info/?l=linux-unionfs&m=150728190228896&w=2
https://marc.info/?l=linux-unionfs&m=150728190428897&w=2

Changelog:
 v1->v2:
 Address the following review comments from Amir.
 1. overlay/041 now uses _overlay_scratch_mount_dirs() introduced by the patch
 "overlay: create helper _overlay_scratch_mount_dirs()" (unmerged patch from
 Amir Goldstein).
 2. Use _scratch_mkfs() instead of manually setting of the base filesystem.
 3. Use a directory in $OVL_BASE_TEST_DIR as the overlay instance's lowerdir.
 4. Remove redundant invocation of "chown" operation on a regular file to cause
 copy-up to occur.

 v2->v3:
 1. Remove debug code. Thanks to Amir for spotting this.
 2. Add a commit message describing non-samefs setup of an overlayfs instance
 and the scenarios being tested by this test.

 v3->v4:
 1. Replace _overlay_scratch_unmount invocation with _scratch_unmount.

tests/overlay/041     | 193 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/041.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 196 insertions(+)
 create mode 100755 tests/overlay/041
 create mode 100644 tests/overlay/041.out

diff --git a/tests/overlay/041 b/tests/overlay/041
new file mode 100755
index 0000000..4d7feb8
--- /dev/null
+++ b/tests/overlay/041
@@ -0,0 +1,193 @@
+#! /bin/bash
+# FSQA Test No. 041
+#
+# Test consistent d_ino numbers on non-samefs setup
+# This is a variant of overlay/038 to test consistent d_ino numbers
+# for non-samefs setup.
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2017 IBM Corporation. All Rights Reserved.
+# Author: Chandan Rajendra <chandan@linux.vnet.ibm.com>
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
+. ./common/attr
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+_require_test
+_require_attrs
+_require_test_program "t_dir_type"
+
+rm -f $seqres.full
+
+lowerdir=$OVL_BASE_TEST_DIR/$seq-ovl-lower
+rm -rf $lowerdir
+mkdir $lowerdir
+
+# Create our test files.
+mkdir $lowerdir/test_dir/
+mkdir $lowerdir/test_dir/pure_lower_dir
+mkdir $lowerdir/test_dir/merged_dir
+touch $lowerdir/test_file
+
+_scratch_mkfs
+
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
+
+test_dir=$SCRATCH_MNT/test_dir/
+merged_dir=$test_dir/merged_dir
+pure_upper_dir=$merged_dir/pure_upper_dir
+
+mkdir -p $pure_upper_dir
+
+merged_dir_st_ino=$(stat -c '%i' $merged_dir)
+
+# Pure dir's parent d_ino must always be calculated because
+# it can be residing inside a merged dir.
+parent_d=$($here/src/t_dir_type $pure_upper_dir $merged_dir_st_ino)
+[[ $parent_d == ".. d" ]] || \
+	echo "Pure dir inside a merged dir: Invalid d_ino reported for .."
+
+# d_ino for "." must always be calculated because the present
+# directory can have a copy-up origin.
+current_d=$($here/src/t_dir_type $merged_dir $merged_dir_st_ino)
+[[ $current_d == ". d" ]] || echo "Merged dir: Invalid d_ino reported for ."
+
+# Verify d_ino of '.' and '..' before and after dir becomes impure.
+impure_dir=$test_dir/impure_dir
+mkdir -p $impure_dir
+
+impure_dir_st_ino=$(stat -c '%i' $impure_dir)
+impure_dir_parent_st_ino=$(stat -c '%i' $test_dir)
+
+# Before $impure_dir becomes impure
+parent_d=$($here/src/t_dir_type $impure_dir $impure_dir_parent_st_ino)
+[[ $parent_d == ".. d" ]] || \
+    echo "Before dir becomes impure: Invalid d_ino reported for .."
+
+current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
+[[ $current_d == ". d" ]] || \
+    echo "Before dir becomes impure: Invalid d_ino reported for ."
+
+
+mv $SCRATCH_MNT/test_file $impure_dir
+test_file_st_ino=$(stat -c '%i' $impure_dir/test_file)
+
+impure=$($GETFATTR_PROG --absolute-names --only-values -n 'trusted.overlay.impure' \
+			$upperdir/test_dir/impure_dir)
+[[ $impure == "y" ]] || echo "Impure directory missing impure xattr"
+
+# After $impure_dir becomes impure
+parent_d=$($here/src/t_dir_type $impure_dir $impure_dir_parent_st_ino)
+[[ $parent_d == ".. d" ]] || \
+    echo "After dir becomes impure: Invalid d_ino reported for .."
+
+current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
+[[ $current_d == ". d" ]] || \
+    echo "After dir becomes impure: Invalid d_ino reported for ."
+
+# Verify copy up file's d_ino
+file_d=$($here/src/t_dir_type $impure_dir $test_file_st_ino)
+[[ $file_d == "test_file f" ]] || \
+	echo "Impure dir: Invalid d_ino reported for entry with copy-up origin"
+
+# Make $impure_dir pure
+rm -rf $impure_dir/test_file
+
+# Verify invalidation of readdir cache
+$here/src/t_dir_type $impure_dir $test_file_st_ino
+[[ $? != 0 ]] || echo "Directory's readdir cache has stale entries"
+
+impure=$($GETFATTR_PROG --absolute-names --only-values -n 'trusted.overlay.impure' \
+			$upperdir/test_dir/impure_dir 2>/dev/null)
+[[ -z $impure ]] || echo "Pure directory has impure xattr"
+
+# Verify d_ino values corresponding to "." and ".." entries of a
+# pure lower dir.
+parent_st_ino=$(stat -c '%i' $SCRATCH_MNT/test_dir)
+pure_lower_dir=$SCRATCH_MNT/test_dir/pure_lower_dir
+
+parent_d=$($here/src/t_dir_type $pure_lower_dir $parent_st_ino)
+[[ $parent_d == ".. d" ]] || echo "Pure lower dir: Invalid d_ino reported for .."
+
+pure_lower_dir_st_ino=$(stat -c '%i' $pure_lower_dir)
+
+current_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_dir_st_ino)
+[[ $current_d == ". d" ]] || echo "Pure lower dir: Invalid d_ino reported for ."
+
+# Verify d_ino of ".." entry of a merged dir.
+merged_dir=$SCRATCH_MNT/test_dir/merged_dir
+
+parent_d=$($here/src/t_dir_type $merged_dir $parent_st_ino)
+[[ $parent_d == ".. d" ]] || echo "Merged dir: Invalid d_ino reported for .."
+
+_scratch_unmount
+
+# Verify pure lower residing in dir which has another lower layer
+middir=$OVL_BASE_TEST_DIR/$seq-ovl-mid
+lowerdir=$OVL_BASE_TEST_DIR/$seq-ovl-lower
+rm -rf $middir
+rm -rf $lowerdir
+mkdir $middir
+mkdir $lowerdir
+
+mkdir -p $middir/test_dir
+mkdir -p $lowerdir/test_dir/pure_lower_dir
+
+_scratch_mkfs
+
+upperdir=$OVL_BASE_SCRATCH_MNT/ovl-upper
+workdir=$OVL_BASE_SCRATCH_MNT/ovl-work
+
+_overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir
+
+# Copy up test_dir
+touch $SCRATCH_MNT/test_dir/test_file
+
+test_dir_st_ino=$(stat -c '%i' $SCRATCH_MNT/test_dir)
+
+parent_d=$($here/src/t_dir_type $SCRATCH_MNT/test_dir/pure_lower_dir $test_dir_st_ino)
+[[ $parent_d == ".. d" ]] || \
+	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for .."
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/041.out b/tests/overlay/041.out
new file mode 100644
index 0000000..04f5bf1
--- /dev/null
+++ b/tests/overlay/041.out
@@ -0,0 +1,2 @@
+QA output created by 041
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 022f2ef..8629325 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -43,3 +43,4 @@
 038 auto quick copyup
 039 auto quick atime
 040 auto quick
+041 auto quick copyup nonsamefs
-- 
2.9.5

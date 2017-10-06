From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] constant d_ino test for non-samefs setup
Date: Fri,  6 Oct 2017 14:59:46 +0530
Message-ID: <20171006092946.15718-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60988 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752583AbdJFJ3W (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 05:29:22 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v969TLno126883
        for <linux-unionfs@vger.kernel.org>; Fri, 6 Oct 2017 05:29:21 -0400
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2de6cetbd2-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Oct 2017 05:29:20 -0400
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 6 Oct 2017 03:29:00 -0600
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org, amir73il@gmail.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org, eguan@redhat.com

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/overlay/041     | 210 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/041.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 213 insertions(+)
 create mode 100755 tests/overlay/041
 create mode 100644 tests/overlay/041.out

diff --git a/tests/overlay/041 b/tests/overlay/041
new file mode 100755
index 0000000..b992346
--- /dev/null
+++ b/tests/overlay/041
@@ -0,0 +1,210 @@
+#! /bin/bash
+# FSQA Test No. 041
+#
+# Test constant d_ino numbers on non-samefs setup
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
+_scratch_unmount &>>$seqres.full
+_test_unmount &>>$seqres.full
+
+$MOUNT_PROG $OVL_BASE_SCRATCH_DEV $OVL_BASE_SCRATCH_MNT
+$MOUNT_PROG $OVL_BASE_TEST_DEV $OVL_BASE_TEST_DIR
+
+rm -rf $OVL_BASE_SCRATCH_MNT/*
+rm -rf $OVL_BASE_TEST_DIR/*
+
+lowerdir=$OVL_BASE_TEST_DIR/ovl-lower
+upperdir=$OVL_BASE_SCRATCH_MNT/ovl-upper
+workdir=$OVL_BASE_SCRATCH_MNT/ovl-work
+ovlmnt=$OVL_BASE_SCRATCH_MNT/ovl-mnt
+
+mkdir $lowerdir
+mkdir $upperdir
+mkdir $workdir
+mkdir $ovlmnt
+
+# Create our test files.
+mkdir $lowerdir/test_dir/
+mkdir $lowerdir/test_dir/pure_lower_dir
+mkdir $lowerdir/test_dir/merged_dir
+
+touch $lowerdir/test_file
+
+$MOUNT_PROG -t overlay overlay -o lowerdir=$lowerdir \
+	    -o upperdir=$upperdir -o workdir=$workdir $ovlmnt
+
+test_dir=$ovlmnt/test_dir/
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
+chown -h 100 $ovlmnt/test_file
+test_file_st_ino=$(stat -c '%i' $ovlmnt/test_file)
+
+mv $ovlmnt/test_file $impure_dir
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
+parent_st_ino=$(stat -c '%i' $ovlmnt/test_dir)
+pure_lower_dir=$ovlmnt/test_dir/pure_lower_dir
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
+merged_dir=$ovlmnt/test_dir/merged_dir
+
+parent_d=$($here/src/t_dir_type $merged_dir $parent_st_ino)
+[[ $parent_d == ".. d" ]] || echo "Merged dir: Invalid d_ino reported for .."
+
+$UMOUNT_PROG $ovlmnt
+
+# Verify pure lower residing in dir which has another lower layer
+rm -rf $OVL_BASE_SCRATCH_MNT/*
+rm -rf $OVL_BASE_TEST_DIR/*
+
+middir=$OVL_BASE_TEST_DIR/ovl-lower0
+lowerdir=$OVL_BASE_TEST_DIR/ovl-lower1
+upperdir=$OVL_BASE_SCRATCH_MNT/ovl-upper
+workdir=$OVL_BASE_SCRATCH_MNT/ovl-work
+ovlmnt=$OVL_BASE_SCRATCH_MNT/ovl-mnt
+
+mkdir -p $middir
+mkdir -p $lowerdir
+mkdir -p $upperdir
+mkdir -p $workdir
+mkdir -p $ovlmnt
+
+mkdir -p $middir/test_dir
+mkdir -p $lowerdir/test_dir/pure_lower_dir
+
+$MOUNT_PROG -t overlay overlay -o lowerdir=$middir:$lowerdir \
+	    -o upperdir=$upperdir -o workdir=$workdir $ovlmnt
+
+# Copy up test_dir
+touch $ovlmnt/test_dir/test_file
+
+test_dir_st_ino=$(stat -c '%i' $ovlmnt/test_dir)
+
+parent_d=$($here/src/t_dir_type $ovlmnt/test_dir/pure_lower_dir $test_dir_st_ino)
+[[ $parent_d == ".. d" ]] || \
+	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for .."
+
+$UMOUNT_PROG $ovlmnt
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
index 022f2ef..89f6325 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -43,3 +43,4 @@
 038 auto quick copyup
 039 auto quick atime
 040 auto quick
+041 auto quick copyup
-- 
2.9.5

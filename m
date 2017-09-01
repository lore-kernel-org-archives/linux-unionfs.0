From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V3] overlay: Test constant d_ino feature
Date: Fri,  1 Sep 2017 19:53:41 +0530
Message-ID: <20170901142341.28872-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56173 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751964AbdIAOXM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 1 Sep 2017 10:23:12 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v81EMu5I063304
        for <linux-unionfs@vger.kernel.org>; Fri, 1 Sep 2017 10:23:12 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cq8035reg-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Fri, 01 Sep 2017 10:23:11 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 1 Sep 2017 08:23:11 -0600
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: amir73il@gmail.com, eguan@redhat.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, fstests@vger.kernel.org, miklos@szeredi.hu, linux-unionfs@vger.kernel.org

This commit adds a test to verify constant d_ino feature. The following
scenarios are checked,
- Parent's (i.e. "..") d_ino must always be calculated because a pure
  dir can be residing inside a merged dir.
- d_ino for "." must always be calculated because the present directory
  can have a copy-up origin.
- Verify d_ino of '.' and '..' before and after dir becomes
  impure. While at it also verify if trusted.overlay.impure xattr is
  set/reset appropriately and invalidation of readdir cache.
- Verify copied up file's (inside a impure dir) d_ino.
- Verify d_ino values corresponding to "." and ".." entries of a pure
  lower dir.
- Verify d_ino of ".." entry of a merged dir.
- Verify pure lower residing in dir which has another lower layer

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
Changelog:
v2->v3:
1. Add the following new test scenarios.
   - Verify d_ino of '.' and '..' before and after dir becomes impure.
   - Verify copied up file's (inside a impure dir) d_ino.
2. For the "Verify pure lower residing in dir which has another lower layer"
   test, use sane variable names.
Once again, Thanks to Amir for his suggestions.

v1->v2:
1. Removed tests copied over from overlay/017.
2. Removed src/t_dir_ino.c.
3. Add code for testing,
  - d_ino of . and .. entries of pure_lower_dir.
  - d_ino of .. entry of merged_dir.
  - Verify pure lower residing in dir which has another lower layer.
Thanks to Amir for suggesting these tests.

 tests/overlay/037     | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/037.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 193 insertions(+)
 create mode 100755 tests/overlay/037
 create mode 100644 tests/overlay/037.out

diff --git a/tests/overlay/037 b/tests/overlay/037
new file mode 100755
index 0000000..0ef5e74
--- /dev/null
+++ b/tests/overlay/037
@@ -0,0 +1,190 @@
+#! /bin/bash
+# FSQA Test No. 037
+#
+# Test constant d_ino numbers
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
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+_require_test_program "af_unix"
+_require_test_program "t_dir_type"
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+# Create our test files.
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+mkdir -p $lowerdir
+
+mkdir $lowerdir/test_dir/
+mkdir $lowerdir/test_dir/pure_lower_dir
+mkdir $lowerdir/test_dir/merged_dir
+
+touch $lowerdir/test_file
+
+_scratch_mount
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
+[[ $parent_d != ".. d" ]] && \
+	echo "Pure dir inside a merged dir: Invalid d_ino reported for .."
+
+# d_ino for "." must always be calculated because the present
+# directory can have a copy-up origin.
+current_d=$($here/src/t_dir_type $merged_dir $merged_dir_st_ino)
+[[ $current_d != ". d" ]] && echo "Merged dir: Invalid d_ino reported for ."
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
+[[ $parent_d != ".. d" ]] && echo "Before dir becomes impure: Invalid d_ino reported for .."
+
+current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
+[[ $current_d != ". d" ]] && echo "Before dir becomes impure: Invalid d_ino reported for ."
+
+chown -h 100 $SCRATCH_MNT/test_file
+test_file_st_ino=$(stat -c '%i' $SCRATCH_MNT/test_file)
+
+mv $SCRATCH_MNT/test_file $impure_dir
+
+$GETFATTR_PROG --absolute-names --dump -m trusted $upperdir/test_dir/impure_dir \
+	| grep -q -F 'trusted.overlay.impure'
+[[ $? != 0 ]] && echo "Impure directory missing impure xattr"
+
+# After $impure_dir becomes impure
+parent_d=$($here/src/t_dir_type $impure_dir $impure_dir_parent_st_ino)
+[[ $parent_d != ".. d" ]] && echo "After dir becomes impure: Invalid d_ino reported for .."
+
+current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
+[[ $current_d != ". d" ]] && echo "After dir becomes impure: Invalid d_ino reported for ."
+
+# Verify copy up file's d_ino
+file_d=$($here/src/t_dir_type $impure_dir $test_file_st_ino)
+[[ $file_d != "test_file f" ]] && \
+	echo "Impure dir: Invalid d_ino reported for entry with copy-up origin"
+
+# Make $impure_dir pure
+rm -rf $impure_dir/test_file
+
+# Verify invalidation of readdir cache
+$here/src/t_dir_type $impure_dir $test_file_st_ino
+[[ $? == 0 ]] && echo "Directory's readdir cache has stale entries"
+
+$GETFATTR_PROG --absolute-names --dump -m trusted $upperdir/test_dir/impure_dir \
+	| grep -q -F 'trusted.overlay.impure'
+[[ $? == 0 ]] && echo "Pure directory has impure xattr"
+
+# Verify d_ino values corresponding to "." and ".." entries of a
+# pure lower dir.
+parent_st_ino=$(stat -c '%i' $SCRATCH_MNT/test_dir)
+pure_lower_dir=$SCRATCH_MNT/test_dir/pure_lower_dir
+
+parent_d=$($here/src/t_dir_type $pure_lower_dir $parent_st_ino)
+[[ $parent_d != ".. d" ]] && echo "Pure lower dir: Invalid d_ino reported for .."
+
+pure_lower_dir_st_ino=$(stat -c '%i' $pure_lower_dir)
+
+current_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_dir_st_ino)
+[[ $current_d != ". d" ]] && echo "Pure lower dir: Invalid d_ino reported for ."
+
+# Verify d_ino of ".." entry of a merged dir.
+merged_dir=$SCRATCH_MNT/test_dir/merged_dir
+
+parent_d=$($here/src/t_dir_type $merged_dir $parent_st_ino)
+[[ $parent_d != ".. d" ]] && echo "Merged dir: Invalid d_ino reported for .."
+
+_scratch_unmount
+
+# Verify pure lower residing in dir which has another lower layer
+_scratch_mkfs
+
+OVL_LOWER0=${OVL_LOWER}0
+OVL_LOWER1=${OVL_LOWER}1
+
+middir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER0
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER1
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+
+mkdir -p $middir
+mkdir -p $lowerdir
+mkdir -p $upperdir
+mkdir -p $workdir
+
+mkdir -p $middir/dir0
+mkdir -p $lowerdir/dir0/dir1
+
+$MOUNT_PROG -t overlay overlay -o lowerdir=$middir:$lowerdir \
+	    -o upperdir=$upperdir -o workdir=$workdir $SCRATCH_MNT
+
+# Copy up dir0
+touch $SCRATCH_MNT/dir0/test_file
+
+dir0_st_ino=$(stat -c '%i' $SCRATCH_MNT/dir0)
+
+parent_d=$($here/src/t_dir_type $SCRATCH_MNT/dir0/dir1 $dir0_st_ino)
+[[ $parent_d != ".. d" ]] && \
+	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for .."
+
+$UMOUNT_PROG $SCRATCH_MNT
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/037.out b/tests/overlay/037.out
new file mode 100644
index 0000000..5c3a30a
--- /dev/null
+++ b/tests/overlay/037.out
@@ -0,0 +1,2 @@
+QA output created by 037
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 4cc1d74..b2460e1 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -39,3 +39,4 @@
 034 auto quick copyup hardlink
 035 auto quick mount
 036 auto quick mount
+037 auto quick copyup
-- 
2.9.5

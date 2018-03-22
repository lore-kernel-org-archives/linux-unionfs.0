Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH 2/2] overlay: test mount operation with supported features and enabled feature mount options
Date: Thu, 22 Mar 2018 19:38:34 +0800
Message-ID: <20180322113834.48168-2-yi.zhang@huawei.com>
In-Reply-To: <20180322113834.48168-1-yi.zhang@huawei.com>
References: <20180322113834.48168-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, guaneryu@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Test overlay mount operation which has supported feature set, and
test mount operation with feature mount options:
- Check overlay mount with enabled redirect_dir/index/nfs_export
  mount options
- Check overlay mount with supported redirect_dir/index/nfs_export
  feature on the upper root dir
- Check overlay mount with supported redirect_dir/index/nfs_export
  feature on the lower root dir only

Mount operation should succeed if supported features is detected on
the underlying root dir. One feature should be set on the upper
root dir if user give the enabled mount option or the same feature
is detected on the lower root dir.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/059     | 140 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/059.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 143 insertions(+)
 create mode 100755 tests/overlay/059
 create mode 100644 tests/overlay/059.out

diff --git a/tests/overlay/059 b/tests/overlay/059
new file mode 100755
index 00000000..cec20d4a
--- /dev/null
+++ b/tests/overlay/059
@@ -0,0 +1,140 @@
+#! /bin/bash
+# FS QA Test 059
+#
+# Test overlay mount operation which has supported feature set, and
+# test mount operation with feature mount options:
+# - Check overlay mount with enabled redirect_dir/index/nfs_export
+#   mount options
+# - Check overlay mount with supported redirect_dir/index/nfs_export
+#   feature on the upper root dir
+# - Check overlay mount with supported redirect_dir/index/nfs_export
+#   feature on the lower root dir only
+#
+# Mount operation should succeed if supported features is detected on
+# the underlying root dir. One feature should be set on the upper
+# root dir if user give the enabled mount option or the same feature
+# is detected on the lower root dir.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2018 Huawei.  All Rights Reserved.
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
+_require_scratch_overlay_features redirect_dir index nfs_export
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Check compat/ro_compat/incompat features on the underlying root dir
+check_feature()
+{
+	local compat_type=$1
+	local expect=$2
+	local target=$3
+
+	feature=$($GETFATTR_PROG --absolute-names --only-values -n \
+			$compat_type $target)
+
+	[[ "$feature" =~ "$expect" ]] || echo "Feature xattr incorrect"
+}
+
+# Create lowerdir, multiple upperdirs and workdirs
+lowerdir=$OVL_BASE_SCRATCH_MNT/lower
+upperdir1=$OVL_BASE_SCRATCH_MNT/upper1
+upperdir2=$OVL_BASE_SCRATCH_MNT/upper2
+workdir1=$OVL_BASE_SCRATCH_MNT/work1
+workdir2=$OVL_BASE_SCRATCH_MNT/work2
+
+mkdir -p $lowerdir $upperdir1 $upperdir2 $workdir1 $workdir2
+
+# Mount overlay with enabled redirect_dir, index and nfs_export mount
+# options, expect to set corresponding feature in upper root dir
+_overlay_scratch_mount_dirs $lowerdir $upperdir1 $workdir1 \
+			-o "redirect_dir=on,index=on,nfs_export=on"
+$UMOUNT_PROG $SCRATCH_MNT
+
+check_feature $OVL_XATTR_FEATURE_RO_COMPAT "index" $upperdir1
+check_feature $OVL_XATTR_FEATURE_RO_COMPAT "nfs_export" $upperdir1
+check_feature $OVL_XATTR_FEATURE_INCOMPAT "redirect_dir" $upperdir1
+
+# check overlayfs
+_overlay_check_scratch_dirs $lowerdir $upperdir1 $workdir1 \
+			-o "edirect_dir=on,index=on,nfs_export=on"
+
+# Mount again without mount options, expect success
+_overlay_scratch_mount_dirs $lowerdir $upperdir1 $workdir1
+$UMOUNT_PROG $SCRATCH_MNT
+
+# check overlayfs again
+_overlay_check_scratch_dirs $lowerdir $upperdir1 $workdir1
+
+
+# Move down all layers and mount overlay with disabled redirect_dir,
+# index and nfs_export mount options. Now, the overlay have redirect_dir,
+# index and nfs_export features on the lower layer, expect mount success
+# and set all these features on the upper root dir.
+_overlay_scratch_mount_dirs "$upperdir1:$lowerdir" $upperdir2 $workdir2 \
+			-o "redirect_dir=off,index=off,nfs_export=off"
+$UMOUNT_PROG $SCRATCH_MNT
+
+check_feature $OVL_XATTR_FEATURE_RO_COMPAT "index" $upperdir2
+check_feature $OVL_XATTR_FEATURE_RO_COMPAT "nfs_export" $upperdir2
+check_feature $OVL_XATTR_FEATURE_INCOMPAT "redirect_dir" $upperdir2
+
+# check overlayfs
+_overlay_check_scratch_dirs "$upperdir1:$lowerdir" $upperdir2 $workdir2
+
+# Mount again without mount options, expect success
+_overlay_scratch_mount_dirs "$upperdir1:$lowerdir" $upperdir2 $workdir2
+$UMOUNT_PROG $SCRATCH_MNT
+
+# check overlayfs again
+_overlay_check_scratch_dirs "$upperdir1:$lowerdir" $upperdir2 $workdir2
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/059.out b/tests/overlay/059.out
new file mode 100644
index 00000000..36ebeea0
--- /dev/null
+++ b/tests/overlay/059.out
@@ -0,0 +1,2 @@
+QA output created by 059
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 605a9f56..77a24dd5 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -61,3 +61,4 @@
 056 auto quick fsck
 057 auto quick redirect
 058 auto quick feature
+059 auto quick feature
-- 
2.13.6

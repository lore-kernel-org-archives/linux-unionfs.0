Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay: test file handle decode with multi lower layers on same fs
Date: Mon,  5 Nov 2018 07:18:15 +0200
Message-Id: <20181105051815.15074-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

This test is for a regression that was introduced in kernel v4.17 by
commit 8b58924ad55c ("ovl: lookup in inode cache first when decoding
lower file handle").

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/062     | 86 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/062.out |  2 +
 tests/overlay/group   |  1 +
 3 files changed, 89 insertions(+)
 create mode 100755 tests/overlay/062
 create mode 100644 tests/overlay/062.out

diff --git a/tests/overlay/062 b/tests/overlay/062
new file mode 100755
index 00000000..2c86a4b6
--- /dev/null
+++ b/tests/overlay/062
@@ -0,0 +1,86 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test No. 062
+#
+# Test file handle decode with multi lower layers on same fs
+#
+# This test is for a regression that was introduced in kernel v4.17 by
+# commit 8b58924ad55c ("ovl: lookup in inode cache first when decoding
+# lower file handle").
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
+	$UMOUNT_PROG $lowertestdir
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+_require_test_program "open_by_handle"
+# We need to require all features together, because nfs_export cannot
+# be enabled when index is disabled
+_require_scratch_overlay_features index nfs_export
+
+NUMFILES=1
+
+# Create test dir and empty test files
+create_test_files()
+{
+	local dir=$1
+
+	mkdir -p $dir
+	$here/src/open_by_handle -cwp $dir $NUMFILES
+}
+
+# Test encode/decode file handles on overlay mount
+test_file_handles()
+{
+	local dir=$1
+
+	$here/src/open_by_handle -rp $dir $NUMFILES
+}
+
+_scratch_mkfs
+
+# All lower layers are on scratch partition
+lower=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+lower2=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER.2
+lowertestdir=$lower2/testdir
+
+create_test_files $lowertestdir
+
+# bind mount to pin lower test dir dentry to dcache
+$MOUNT_PROG --bind $lowertestdir $lowertestdir
+
+# For non-upper overlay mount, nfs_export requires disabling redirect_dir.
+$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+	-o ro,redirect_dir=nofollow,nfs_export=on,lowerdir=$lower:$lower2
+
+# Decode an overlay directory file handle, whose underlying lower dir dentry
+# is in dcache and connected and does not belong to the upper most lower layer.
+# The test program drops caches, but $lowertestdir dcache in pinned, so only
+# the overlay dentry is dropped.
+test_file_handles $SCRATCH_MNT/testdir -rp
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/062.out b/tests/overlay/062.out
new file mode 100644
index 00000000..a1578f48
--- /dev/null
+++ b/tests/overlay/062.out
@@ -0,0 +1,2 @@
+QA output created by 062
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index ccc71f3b..165f002d 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -64,3 +64,4 @@
 059 auto quick copyup
 060 auto quick metacopy
 061 auto quick copyup
+062 auto quick exportfs
-- 
2.17.1

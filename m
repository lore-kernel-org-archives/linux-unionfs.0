Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH 2/3] overlay: add fsck.overlay stress test
Date: Sat, 28 Jul 2018 16:42:41 +0800
Message-ID: <20180728084242.33918-3-yi.zhang@huawei.com>
In-Reply-To: <20180728084242.33918-1-yi.zhang@huawei.com>
References: <20180728084242.33918-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: guaneryu@gmail.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Introduce a test case for fsck.overlay which runs on the underlying
directories created by fsstress (contain a lot of fs objects) to
find potential stability issue.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/061     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/061.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 84 insertions(+)
 create mode 100755 tests/overlay/061
 create mode 100644 tests/overlay/061.out

diff --git a/tests/overlay/061 b/tests/overlay/061
new file mode 100755
index 0000000..b66b36a
--- /dev/null
+++ b/tests/overlay/061
@@ -0,0 +1,81 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Huawei.  All Rights Reserved.
+#
+# FS QA Test No. 061
+#
+# Stress test: test fsck.overlay running on the underlying dirs
+# which were created by fsstress.
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
+_require_command "$FSCK_OVERLAY_PROG" fsck.overlay
+
+# remove all files from previous tests
+_scratch_mkfs
+
+# Create an underlying layer which contain a lot of random objects
+create_layer()
+{
+	for dir in $*; do
+		$FSSTRESS_PROG -s 42 -d $dir -z \
+			-f creat=20 -f link=10 -f mkdir=20 -f mknod=10 \
+			-f rename=10 -f setxattr=10 -f symlink=10 -f write=10 \
+			-p 4 -n 500 -l50 > /dev/null 2>&1 &
+	done
+}
+
+
+# Create test directories
+lowerdir=$OVL_BASE_SCRATCH_MNT/$seq-ovl-lower
+lowerdir2=$OVL_BASE_SCRATCH_MNT/$seq-ovl-lower2
+upperdir=$OVL_BASE_SCRATCH_MNT/$seq-ovl-upper
+workdir=$OVL_BASE_SCRATCH_MNT/$seq-ovl-workdir
+
+make_test_dirs()
+{
+	rm -rf $lowerdir $lowerdir2 $upperdir $workdir
+	mkdir -p $lowerdir $lowerdir2 $upperdir $workdir
+}
+
+
+# Test stability, should not crash and should not fail on "yes" mode.
+make_test_dirs
+create_layer $lowerdir2 $lowerdir $upperdir
+wait %1 %2 %3
+
+_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -y >> \
+	$seqres.full 2>&1
+
+[[ "$?" == "$FSCK_OK" || "$?" == "$FSCK_NONDESTRUCT" ]] || \
+	echo "fsck return unexpected $?"
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/061.out b/tests/overlay/061.out
new file mode 100644
index 0000000..273be9e
--- /dev/null
+++ b/tests/overlay/061.out
@@ -0,0 +1,2 @@
+QA output created by 061
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index b73d7e9..7d13271 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -63,3 +63,4 @@
 058 auto quick exportfs
 059 auto quick copyup
 060 auto quick metacopy
+061 auto stress fsck
-- 
2.5.0

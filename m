From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v2 3/3] generic/470: add syncfs test
Date: Thu,  7 Dec 2017 10:22:07 +0800
Message-ID: <1512613327-218016-3-git-send-email-cgxu519@icloud.com>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:23527 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752248AbdLGCXZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 21:23:25 -0500
In-Reply-To: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: eguan@redhat.com, amir73il@gmail.com
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

Inspired by syncfs bug of overlayfs which does not sync dirtyinodes in
underlying filesystem.
Run syncfs and shutdown filesystem(or underlying filesystem of overlayfs)
to check syncfs result.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---

Changes since v1:
Use fs shutdown and fssum to check syncfs result instead of
checking delalloc state of extents.

 tests/generic/470     | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/470.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 91 insertions(+)
 create mode 100755 tests/generic/470
 create mode 100644 tests/generic/470.out

diff --git a/tests/generic/470 b/tests/generic/470
new file mode 100755
index 0000000..b488747
--- /dev/null
+++ b/tests/generic/470
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test 470
+#
+# Inspired by syncfs bug of overlayfs which does not sync dirty inodes in
+# underlying filesystem. 
+#
+# Run syncfs and shutdown filesystem(or underlying filesystem of overlayfs)
+# to check syncfs result.
+#
+# Test will be skipped if filesystem(or underlying filesystem of overlayfs)
+# does not support shutdown.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Chengguang Xu <cgxu519@icloud.com>
+# All Rights Reserved.
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
+status=1
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_fssum
+_require_scratch
+_require_scratch_shutdown
+_require_xfs_io_command "syncfs"
+
+
+FCNT=1000
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# In order to mitigate interference of write-back,
+# create many files for test.
+for i in `seq 1 $FCNT`; do
+	$XFS_IO_PROG -f -c "pwrite 1K 1M" \
+		$SCRATCH_MNT/$i >/dev/null 2>&1
+done
+
+$FSSUM_PROG -ugomAcdES -f -w $TEST_DIR/before_test $SCRATCH_MNT
+$XFS_IO_PROG -c "syncfs" $SCRATCH_MNT/${FCNT} >/dev/null 2>&1
+_scratch_shutdown
+_scratch_cycle_mount
+$FSSUM_PROG -ugomAcdES -f -w $TEST_DIR/after_test $SCRATCH_MNT
+diff $TEST_DIR/before_test $TEST_DIR/after_test
+if [ $? -eq 0 ]; then
+	status=0
+fi
+
+echo "Silence is golden"
+exit
diff --git a/tests/generic/470.out b/tests/generic/470.out
new file mode 100644
index 0000000..79fb532
--- /dev/null
+++ b/tests/generic/470.out
@@ -0,0 +1,2 @@
+QA output created by 470
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 6c3bb03..493a44c 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -472,3 +472,4 @@
 467 auto quick exportfs
 468 shutdown auto quick metadata
 469 auto quick
+470 auto quick shutdown sync
-- 
1.8.3.1

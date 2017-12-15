From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v5 3/3] generic/471: add syncfs test
Date: Fri, 15 Dec 2017 15:47:35 +0800
Message-ID: <1513324055-77618-3-git-send-email-cgxu519@icloud.com>
References: <1513324055-77618-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:11535 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752642AbdLOHsQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Dec 2017 02:48:16 -0500
In-Reply-To: <1513324055-77618-1-git-send-email-cgxu519@icloud.com>
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
Changes since v3:
1. Change case No to 471.
2. Change failure checking method.
3. Cut comment about fssum.

Changes since v2:
1. Modify multiple test files to single small test file.
2. Use fssum to check result instead of diff.
3. Add comment for why running sync before test.
4. Add option explanation of fssum.

Changes since v1:
Use fs shutdown and fssum to check syncfs result instead of
checking delalloc state of extents.

 tests/generic/471     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/471.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 87 insertions(+)
 create mode 100755 tests/generic/471
 create mode 100644 tests/generic/471.out

diff --git a/tests/generic/471 b/tests/generic/471
new file mode 100755
index 0000000..bd1a72f
--- /dev/null
+++ b/tests/generic/471
@@ -0,0 +1,84 @@
+#! /bin/bash
+# FS QA Test 471
+#
+# Inspired by syncfs bug of overlayfs which does not sync dirty inodes in
+# underlying filesystem.
+#
+# Create a small file then run syncfs and shutdown filesystem(or underlying
+# filesystem of overlayfs) to check syncfs result.
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
+status=0
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
+_require_fssum
+_require_scratch
+_require_scratch_shutdown
+_require_xfs_io_command "syncfs"
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# Background writeback will flush dirty inode by dirty ratio and dirty time
+# period(default 30 seconds), in order to avoid interference from it,
+# run sync before test to make all dirty inodes clean, and it also
+# accelerates syncfs on testing filesystem so that test case can finish
+# in 30 seconds.
+
+sync
+
+$XFS_IO_PROG -f -c "pwrite 0 4K" $SCRATCH_MNT/testfile >/dev/null 2>&1
+
+# fssum used for comparing checksum of test file(data & metedata),
+# exclude checking about atime, block structure, open error.
+$FSSUM_PROG -ugomAcdES -f -w $tmp.fssum $SCRATCH_MNT
+$XFS_IO_PROG -c "syncfs" $SCRATCH_MNT/testfile >/dev/null 2>&1
+_scratch_shutdown
+_scratch_cycle_mount
+$FSSUM_PROG -r $tmp.fssum $SCRATCH_MNT
+
+exit
diff --git a/tests/generic/471.out b/tests/generic/471.out
new file mode 100644
index 0000000..6944d77
--- /dev/null
+++ b/tests/generic/471.out
@@ -0,0 +1,2 @@
+QA output created by 471
+OK
diff --git a/tests/generic/group b/tests/generic/group
index 1e60722..3a61f42 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -473,3 +473,4 @@
 468 shutdown auto quick metadata
 469 auto quick
 470 auto quick dax
+471 shutdown auto quick sync
-- 
1.8.3.1

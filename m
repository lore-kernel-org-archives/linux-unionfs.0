From: Chengguang Xu <cgxu@mykernel.net>
Subject: [PATCH] generic/470: Add check for different sync modes
Date: Thu, 30 Nov 2017 10:43:21 +0800
Message-ID: <1512009801-11466-1-git-send-email-cgxu@mykernel.net>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:34705 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753432AbdK3Cot (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Nov 2017 21:44:49 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu@mykernel.net>

generic/470 should be skipped when delalloc is not supported.

Signed-off-by: Chengguang Xu <cgxu@mykernel.net>
---
 tests/generic/470     | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/470.out |   2 +
 tests/generic/group   |   1 +
 3 files changed, 136 insertions(+)
 create mode 100755 tests/generic/470
 create mode 100644 tests/generic/470.out

diff --git a/tests/generic/470 b/tests/generic/470
new file mode 100755
index 0000000..a43fb91
--- /dev/null
+++ b/tests/generic/470
@@ -0,0 +1,133 @@
+#! /bin/bash
+# FS QA Test No. 470
+# 
+# Run fsync & fdatasync & syncfs & sync to test sync result.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Chengguang Xu <cgxu@mykernel.net>. All Rights Reserved.
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
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_xfs_io_command "fsync"
+_require_xfs_io_command "fdatasync"
+_require_xfs_io_command "syncfs"
+_require_xfs_io_command "sync"
+_require_command "$FILEFRAG_PROG" filefrag
+
+PREFIX=$TEST_DIR/${seq}-testfile
+TESTFILES=$TEST_DIR/${seq}-testfile-*
+FCNT=1000
+
+write_data()
+{
+	rm -f $TESTFILES >/dev/null 2>&1
+	for i in `seq 1 $FCNT`; do
+		$XFS_IO_PROG -f -c "pwrite 1K 1K" \
+				${PREFIX}-$i >/dev/null 2>&1
+	done
+}
+
+check_delalloc_support()
+{
+	write_data
+	$FILEFRAG_PROG -e $TESTFILES | grep -w delalloc >/dev/null 2>&1
+	if [ $? -ne 0 ]; then
+		_notrun "This test requires delayed allocation support!"
+	fi
+}
+
+sync_data()
+{
+	case $1 in
+	sync)
+		$XFS_IO_PROG -c "sync" >/dev/null 2>&1
+		;;
+	syncfs)
+		$XFS_IO_PROG -c "syncfs" ${PREFIX}-${FCNT} >/dev/null 2>&1
+		;;
+	fsync)
+		for i in `seq 1 $FCNT`; do
+			$XFS_IO_PROG -c "fsync" ${PREFIX}-${i} >/dev/null 2>&1
+		done
+		;;
+	fdatasync)
+		for i in `seq 1 $FCNT`; do
+			$XFS_IO_PROG -c "fdatasync" ${PREFIX}-${i} >/dev/null 2>&1
+		done
+		;;
+	*)
+		;;
+	esac
+}
+
+check_data()
+{
+	$FILEFRAG_PROG -e $TESTFILES | grep -w delalloc 2>/dev/null
+	if [ $? -eq 0 ]; then
+		status=1
+	fi
+}
+
+test_sync()
+{
+	local sync_mode=$1
+
+	if [ $sync_mode = "sync" ]; then
+		echo 3 > /proc/sys/vm/drop_caches
+	fi
+
+	write_data
+	sync_data $sync_mode
+	check_data
+}
+
+check_delalloc_support
+
+for i in fsync fdatasync syncfs sync; do
+	test_sync $i
+done
+
+rm -f $TESTFILES >/dev/null 2>&1
+
+echo "Silence is golden"
+exit $status
diff --git a/tests/generic/470.out b/tests/generic/470.out
new file mode 100644
index 0000000..79fb532
--- /dev/null
+++ b/tests/generic/470.out
@@ -0,0 +1,2 @@
+QA output created by 470
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 6c3bb03..23e325c 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -472,3 +472,4 @@
 467 auto quick exportfs
 468 shutdown auto quick metadata
 469 auto quick
+470 auto quick sync
-- 
1.8.3.1

Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] fstests: Check that high-offset reads and writes work on non-blockdev fs
Date: Tue,  5 Feb 2019 21:42:02 +0200
Message-Id: <20190205194202.31745-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

This is a variant of test generic/466 for filesystems that
do not support mkfs_sized

It is needed for testing high-offset reads and writes with overlayfs
over a basefs that supports huge files.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

This test found some issues with WIP implementation of overlayfs
page cache. I though of extending generic/466 to test also with
"default" block size, but turned out to be simpler and cleaner
to fork the test.

Thanks,
Amir.

 tests/generic/999     | 63 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 66 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..18788c30
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,63 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2017, Oracle and/or its affiliates.
+# Copyright (C) 2019, CTERA Networks.
+# All Rights Reserved.
+#
+# FS QA Test No. 999
+#
+# Check that high-offset reads and writes work.
+#
+# This is a variant of test generic/466 for filesystems that
+# do not support mkfs_sized.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
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
+_supported_os Linux
+_supported_fs generic
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+testdir=$SCRATCH_MNT
+
+echo "++ Create the original files" >> $seqres.full
+bigoff=$(echo "2^63 - 2" | $BC_PROG)
+len=$(echo "2^63 - 1" | $BC_PROG)
+$XFS_IO_PROG -f -c "truncate $len" $testdir/file0 >> $seqres.full 2>&1
+if [ ! -s $testdir/file0 ]; then
+	# If we can't set a large file size then don't bother
+	# with read/write tests, because fs doesn't support it.
+	_notrun "filesystem does not support huge file size"
+fi
+_pwrite_byte 0x61 $bigoff 1 $testdir/file1 >> $seqres.full
+
+echo "++ Check file creation" >> $seqres.full
+_scratch_cycle_mount
+
+$XFS_IO_PROG -c "pread -v -q $bigoff 1" $testdir/file1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..72b91e5d
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+7ffffffffffffffe:  61  a
diff --git a/tests/generic/group b/tests/generic/group
index 6f5f28d8..7fe44c2c 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -527,3 +527,4 @@
 522 soak long_rw
 523 auto quick attr
 524 auto quick
+999 auto quick rw
-- 
2.17.1

Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/3] generic: check CAP_LINUX_IMMUTABLE capability with FS_IOC_FSSETXATTR
Date: Tue, 11 Jun 2019 19:08:39 +0300
Message-Id: <20190611160839.14777-4-amir73il@gmail.com>
In-Reply-To: <20190611160839.14777-1-amir73il@gmail.com>
References: <20190611160839.14777-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

This is a flavor of test generic/545 with FS_IOC_FSSETXATTR ioctl
instead of FS_IOC_SETFLAGS ioctl.

Overlayfs gained support for FS_IOC_FSSETXATTR ioctl in v5.2-rc4
with buggy capability check. This change fixed the problem:

  ovl: fix wrong flags check in FS_IOC_FS[SG]ETXATTR ioctls

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/555     | 74 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/555.out |  9 ++++++
 tests/generic/group   |  1 +
 3 files changed, 84 insertions(+)
 create mode 100755 tests/generic/555
 create mode 100644 tests/generic/555.out

diff --git a/tests/generic/555 b/tests/generic/555
new file mode 100755
index 00000000..e100da97
--- /dev/null
+++ b/tests/generic/555
@@ -0,0 +1,74 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 CTERA Networks. All Rights Reserved.
+#
+# FS QA Test No. 555
+#
+# Check that we can't set FS_XFLAG_APPEND and FS_XFLAG_IMMUTABLE inode
+# flags without capbility CAP_LINUX_IMMUTABLE.
+#
+# This test uses xfs_io chattr, rather than the (e2fsprogs) chattr
+# program to exercise the FS_IOC_FSSETXATTR ioctl.
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
+	# Cleanup of flags on both file in case test is aborted
+	# (i.e. CTRL-C), so we have no immutable/append-only files
+	$XFS_IO_PROG -f -r -c "chattr -ia" $workdir/file1 >/dev/null 2>&1
+	$XFS_IO_PROG -f -r -c "chattr -ia" $workdir/file2 >/dev/null 2>&1
+
+	cd /
+	rm -rf $tmp.* $workdir
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs generic
+
+_require_test
+_require_xfs_io_command "chattr" "ia"
+_require_command "$CAPSH_PROG" "capsh"
+
+workdir="$TEST_DIR/test-$seq"
+rm -rf $workdir
+mkdir $workdir
+
+echo "Create the original files"
+touch $workdir/file1
+touch $workdir/file2
+
+do_filter_output()
+{
+	grep -o "Operation not permitted"
+}
+
+echo "Try to xfs_io chattr +ia with capabilities CAP_LINUX_IMMUTABLE"
+$XFS_IO_PROG -f -c "chattr +ia" $workdir/file1
+
+echo "Try to xfs_io chattr +ia/-ia without capability CAP_LINUX_IMMUTABLE"
+$CAPSH_PROG --drop=cap_linux_immutable -- -c "$XFS_IO_PROG -f -c 'chattr +a' $workdir/file2" 2>&1 | do_filter_output
+$CAPSH_PROG --drop=cap_linux_immutable -- -c "$XFS_IO_PROG -f -c 'chattr +i' $workdir/file2" 2>&1 | do_filter_output
+
+$CAPSH_PROG --drop=cap_linux_immutable -- -c "$XFS_IO_PROG -f -r -c 'chattr -i' $workdir/file1" 2>&1 | do_filter_output
+$CAPSH_PROG --drop=cap_linux_immutable -- -c "$XFS_IO_PROG -f -r -c 'chattr -a' $workdir/file1" 2>&1 | do_filter_output
+
+echo "Try to xfs_io chattr -ia with capability CAP_LINUX_IMMUTABLE"
+$XFS_IO_PROG -f -r -c "chattr -ia" $workdir/file1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/555.out b/tests/generic/555.out
new file mode 100644
index 00000000..c4f989d1
--- /dev/null
+++ b/tests/generic/555.out
@@ -0,0 +1,9 @@
+QA output created by 555
+Create the original files
+Try to xfs_io chattr +ia with capabilities CAP_LINUX_IMMUTABLE
+Try to xfs_io chattr +ia/-ia without capability CAP_LINUX_IMMUTABLE
+Operation not permitted
+Operation not permitted
+Operation not permitted
+Operation not permitted
+Try to xfs_io chattr -ia with capability CAP_LINUX_IMMUTABLE
diff --git a/tests/generic/group b/tests/generic/group
index 44ce8eff..8262b09c 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -557,3 +557,4 @@
 552 auto quick log
 553 auto quick copy_range
 554 auto quick copy_range swap
+555 auto quick cap
-- 
2.17.1

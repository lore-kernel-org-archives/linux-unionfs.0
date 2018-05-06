Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] common/rc: decouple xfs_io flink check from xfs_io -T check
Date: Sun,  6 May 2018 09:36:07 +0300
Message-Id: <1525588568-1714-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1525588568-1714-1-git-send-email-amir73il@gmail.com>
References: <1525588568-1714-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

The 3 tests that _require_xfs_io_command "flink", actually require
O_TMPFILE support and flink command, but the former is far unlikely
to be missing. The test btrfs/058 doesn't even use the flink command.

When running these tests on a filesystem that does not support O_TMPFILE
(e.g. overlayfs) the result is not very infomative:

 generic/004 1s ... [not run] xfs_io flink failed (old kernel/wrong fs?)

Decouple the requirements for "flink" command and "-T" command line flag
and require the former explicitly in tests that use it.

As a result the report is now more informative:

 generic/004 1s ... [not run] O_TMPFILE is not supported

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc         | 15 +++++++++++----
 tests/btrfs/058   |  4 +---
 tests/generic/004 |  1 +
 tests/generic/389 |  1 +
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/common/rc b/common/rc
index 9ffab7f..3dabdc9 100644
--- a/common/rc
+++ b/common/rc
@@ -2147,13 +2147,20 @@ _require_xfs_io_command()
 			-c "fiemap -v $param" $testfile 2>&1`
 		param_checked=1
 		;;
-	"flink" )
-		testio=`$XFS_IO_PROG -T -F -c "flink $testfile" \
-			$TEST_DIR 2>&1`
+	"flink")
+		local testlink=$TEST_DIR/$$.link.xfs_io
+		testio=`$XFS_IO_PROG -F -f -c "flink $testlink" $testfile 2>&1`
+		rm -f $testlink > /dev/null 2>&1
+		;;
+	"-T")
+		# Check O_TMPFILE support in xfs_io, kernel and fs
+		testio=`$XFS_IO_PROG -T -c quit $TEST_DIR 2>&1`
 		echo $testio | egrep -q "invalid option|Is a directory" && \
 			_notrun "xfs_io $command support is missing"
+		echo $testio | grep -q "Operation not supported" && \
+			_notrun "O_TMPFILE is not supported"
 		;;
-	"fsmap" )
+	"fsmap")
 		testio=`$XFS_IO_PROG -f -c "fsmap" $testfile 2>&1`
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
diff --git a/tests/btrfs/058 b/tests/btrfs/058
index ed39f94..f139d0c 100755
--- a/tests/btrfs/058
+++ b/tests/btrfs/058
@@ -53,9 +53,7 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-# Requiring flink command tests for the presence of the -T option used
-# to pass O_TMPFILE to open(2).
-_require_xfs_io_command "flink"
+_require_xfs_io_command "-T"
 
 rm -f $seqres.full
 
diff --git a/tests/generic/004 b/tests/generic/004
index d0926f1..df6f215 100755
--- a/tests/generic/004
+++ b/tests/generic/004
@@ -45,6 +45,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_test
+_require_xfs_io_command "-T"
 _require_xfs_io_command "flink"
 
 rm -f $seqres.full
diff --git a/tests/generic/389 b/tests/generic/389
index 6d63eda..1b7bd77 100755
--- a/tests/generic/389
+++ b/tests/generic/389
@@ -47,6 +47,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_test
+_require_xfs_io_command "-T"
 _require_xfs_io_command "flink"
 _require_acls
 
-- 
2.7.4

Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/3] fstests: check for filesystem FS_IOC_FSSETXATTR support
Date: Tue, 11 Jun 2019 19:08:38 +0300
Message-Id: <20190611160839.14777-3-amir73il@gmail.com>
In-Reply-To: <20190611160839.14777-1-amir73il@gmail.com>
References: <20190611160839.14777-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

With "_require_xfs_io_command chattr <letter>", check that
flag can be set/cleared using FS_IOC_FSSETXATTR ioctl, similar
to "_require_chattr <letter>" and FS_IOC_SETFLAGS ioctl.

Update the documentation and the tests that use
"_require_xfs_io_command chattr" to test filesystem support
and not only xfs_io support.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc                    | 10 ++++++++++
 doc/requirement-checking.txt |  2 +-
 tests/generic/553            |  3 +--
 tests/xfs/260                |  2 +-
 tests/xfs/431                |  2 +-
 5 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/common/rc b/common/rc
index 85330de2..25203bb4 100644
--- a/common/rc
+++ b/common/rc
@@ -2090,6 +2090,16 @@ _require_xfs_io_command()
 	local testfile=$TEST_DIR/$$.xfs_io
 	local testio
 	case $command in
+	"chattr")
+		if [ -z "$param" ]; then
+			param=s
+		fi
+		# Test xfs_io chattr support AND
+		# filesystem FS_IOC_FSSETXATTR support
+		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
+		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
+		param_checked="+$param"
+		;;
 	"chproj")
 		testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
 		;;
diff --git a/doc/requirement-checking.txt b/doc/requirement-checking.txt
index 1ec04d4b..45d2756b 100644
--- a/doc/requirement-checking.txt
+++ b/doc/requirement-checking.txt
@@ -69,7 +69,7 @@ _require_xfs_io_command <name> [<switch>]
      switch.  For example:
 
 	_require_xfs_io_command "falloc"
-	_require_xfs_io_command "chattr" "+/-x"
+	_require_xfs_io_command "chattr" "x"
 
      The first requires that xfs_io support the falloc command and the second
      that it supports the chattr command and that the chattr command supports
diff --git a/tests/generic/553 b/tests/generic/553
index efe25d84..98ef77cc 100755
--- a/tests/generic/553
+++ b/tests/generic/553
@@ -34,9 +34,8 @@ _supported_fs generic
 rm -f $seqres.full
 
 _require_test
-_require_chattr i
 _require_xfs_io_command "copy_range"
-_require_xfs_io_command "chattr"
+_require_xfs_io_command "chattr" "i"
 
 rm -rf $workdir
 mkdir $workdir
diff --git a/tests/xfs/260 b/tests/xfs/260
index ba606998..4956752c 100755
--- a/tests/xfs/260
+++ b/tests/xfs/260
@@ -33,7 +33,7 @@ _supported_os Linux
 _require_scratch_dax
 _require_test_program "feature"
 _require_test_program "t_mmap_dio"
-_require_xfs_io_command "chattr" "+/-x"
+_require_xfs_io_command "chattr" "x"
 _require_xfs_io_command "falloc"
 
 prep_files()
diff --git a/tests/xfs/431 b/tests/xfs/431
index 63b45fd4..febc89d5 100755
--- a/tests/xfs/431
+++ b/tests/xfs/431
@@ -38,7 +38,7 @@ rm -f $seqres.full
 # Modify as appropriate.
 _supported_fs xfs
 _supported_os Linux
-_require_xfs_io_command "chattr"
+_require_xfs_io_command "chattr" "t"
 _require_xfs_io_command "fsync"
 _require_xfs_io_command "pwrite"
 _require_scratch
-- 
2.17.1

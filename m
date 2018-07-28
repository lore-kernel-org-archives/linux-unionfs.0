Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH 1/3] overlay: correct fsck.overlay exit code
Date: Sat, 28 Jul 2018 16:42:40 +0800
Message-ID: <20180728084242.33918-2-yi.zhang@huawei.com>
In-Reply-To: <20180728084242.33918-1-yi.zhang@huawei.com>
References: <20180728084242.33918-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: guaneryu@gmail.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

fsck.overlay should return correct exit code to show the file system
status after fsck, instead of return 0 means consistency and !0 means
inconsistency or something bad happened.

Fix the following three exit code after running fsck.overlay:

- Return FSCK_OK if the input file system is consistent,
- Return FSCK_NONDESTRUCT if the file system inconsistent errors
  corrected,
- Return FSCK_UNCORRECTED if the file system still have inconsistent
  errors.

This patch also correct the input underlying dirs for some "valid" test
cases, avoid return unexpected exit code which caused by other unrelated
inconsistency.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 common/config     | 10 +++++++++
 tests/overlay/045 | 59 +++++++++++++++++++++++++++++++++-------------------
 tests/overlay/046 | 62 ++++++++++++++++++++++++++++++++++---------------------
 tests/overlay/056 | 22 ++++++++++++++------
 4 files changed, 102 insertions(+), 51 deletions(-)

diff --git a/common/config b/common/config
index 2f1f272..6e83fca 100644
--- a/common/config
+++ b/common/config
@@ -194,6 +194,16 @@ export CHECKBASHISMS_PROG="$(type -P checkbashisms)"
 export XFS_INFO_PROG="$(type -P xfs_info)"
 export DUPEREMOVE_PROG="$(type -P duperemove)"
 
+# Export exit code used by fsck-type programs
+export FSCK_OK=0
+export FSCK_NONDESTRUCT=1
+export FSCK_REBOOT=2
+export FSCK_UNCORRECTED=4
+export FSCK_ERROR=8
+export FSCK_USAGE=16
+export FSCK_CANCELED=32
+export FSCK_LIBRARY=128
+
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
 # But if neither one is available, just set it to "sleep 1" to wait for lv to
diff --git a/tests/overlay/045 b/tests/overlay/045
index acc7087..04db626 100755
--- a/tests/overlay/045
+++ b/tests/overlay/045
@@ -37,6 +37,7 @@ _require_attrs
 _require_command "$FSCK_OVERLAY_PROG" fsck.overlay
 
 OVL_XATTR_OPAQUE_VAL=y
+OVL_XATTR_IMPURE_VAL=y
 
 # remove all files from previous tests
 _scratch_mkfs
@@ -69,6 +70,15 @@ make_opaque_dir()
 	$SETFATTR_PROG -n $OVL_XATTR_OPAQUE -v $OVL_XATTR_OPAQUE_VAL $target
 }
 
+# Create impure directories
+make_impure_dir()
+{
+	for dir in $*; do
+		mkdir -p $dir
+		$SETFATTR_PROG -n $OVL_XATTR_IMPURE -v $OVL_XATTR_IMPURE_VAL $dir
+	done
+}
+
 # Create a redirect directory
 make_redirect_dir()
 {
@@ -79,6 +89,19 @@ make_redirect_dir()
 	$SETFATTR_PROG -n $OVL_XATTR_REDIRECT -v $value $target
 }
 
+# Run fsck.overlay and check return value
+run_fsck()
+{
+	local expect=$1
+	shift 1
+
+	_overlay_fsck_dirs $* >> $seqres.full 2>&1
+	fsck_ret=$?
+
+	[[ "$fsck_ret" == "$expect" ]] || \
+		echo "fsck return unexpected:$expect,$fsck_ret"
+}
+
 # Create test directories
 lowerdir=$OVL_BASE_SCRATCH_MNT/lower
 lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
@@ -96,8 +119,7 @@ echo "+ Orphan whiteout"
 make_test_dirs
 make_whiteout $lowerdir/foo $upperdir/{foo,bar}
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
 ls $lowerdir
 ls $upperdir
 
@@ -107,8 +129,7 @@ make_test_dirs
 touch $lowerdir2/{foo,bar}
 make_whiteout $upperdir/foo $lowerdir/bar
 
-_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
-	 $seqres.full 2>&1 || echo "fsck should not fail"
+run_fsck $FSCK_OK "$lowerdir:$lowerdir2" $upperdir $workdir -p
 check_whiteout $upperdir/foo $lowerdir/bar
 
 # Test orphan whiteout in opaque directory, should remove
@@ -119,8 +140,7 @@ touch $lowerdir/testdir/foo
 make_opaque_dir $upperdir/testdir
 make_whiteout $upperdir/testdir/foo
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
 ls $upperdir/testdir
 
 # Test orphan whiteout whose parent path is not an merged directory,
@@ -135,8 +155,7 @@ make_whiteout $lowerdir/testdir2
 make_opaque_dir $lowerdir/testdir3
 make_whiteout $upperdir/{testdir1/foo,/testdir2/foo,testdir3/foo,testdir4/foo}
 
-_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
-	$seqres.full 2>&1 || echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT "$lowerdir:$lowerdir2" $upperdir $workdir -p
 ls $upperdir/testdir1
 ls $upperdir/testdir2
 ls $upperdir/testdir3
@@ -150,8 +169,7 @@ touch $lowerdir/testdir/foo
 make_redirect_dir $upperdir/testdir "origin"
 make_whiteout $upperdir/testdir/foo
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
 ls $upperdir/testdir
 
 # Test valid whiteout in redirect directory cover file in lower
@@ -160,11 +178,11 @@ echo "+ Valid whiteout(2)"
 make_test_dirs
 mkdir $lowerdir/origin
 touch $lowerdir/origin/foo
+make_impure_dir $upperdir
 make_redirect_dir $upperdir/testdir "origin"
-make_whiteout $upperdir/testdir/foo
+make_whiteout $upperdir/origin $upperdir/testdir/foo
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_OK $lowerdir $upperdir $workdir -p
 check_whiteout $upperdir/testdir/foo
 
 # Test valid whiteout covering lower target whose parent directory
@@ -175,10 +193,10 @@ mkdir -p $lowerdir2/origin/subdir
 touch $lowerdir2/origin/subdir/foo
 make_redirect_dir $lowerdir/testdir "origin"
 mkdir -p $upperdir/testdir/subdir
-make_whiteout $upperdir/testdir/subdir/foo
+make_whiteout $lowerdir/origin $upperdir/testdir/subdir/foo
+make_impure_dir $upperdir/testdir $upperdir
 
-_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p \
-	>> $seqres.full 2>&1 || echo "fsck should not fail"
+run_fsck $FSCK_OK "$lowerdir:$lowerdir2" $upperdir $workdir -p
 check_whiteout $upperdir/testdir/subdir/foo
 
 # Test invalid whiteout in opaque subdirectory in a redirect directory,
@@ -191,8 +209,7 @@ make_redirect_dir $upperdir/testdir "origin"
 make_opaque_dir $upperdir/testdir/subdir
 make_whiteout $upperdir/testdir/subdir/foo
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
 ls $upperdir/testdir/subdir
 
 # Test valid whiteout in reidrect subdirectory in a opaque directory
@@ -203,10 +220,10 @@ mkdir $lowerdir/origin
 touch $lowerdir/origin/foo
 make_opaque_dir $upperdir/testdir
 make_redirect_dir $upperdir/testdir/subdir "/origin"
-make_whiteout $upperdir/testdir/subdir/foo
+make_whiteout $upperdir/origin $upperdir/testdir/subdir/foo
+make_impure_dir $upperdir/testdir
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-        echo "fsck should not fail"
+run_fsck $FSCK_OK $lowerdir $upperdir $workdir -p
 check_whiteout $upperdir/testdir/subdir/foo
 
 # success, all done
diff --git a/tests/overlay/046 b/tests/overlay/046
index 1c09609..a87aaa6 100755
--- a/tests/overlay/046
+++ b/tests/overlay/046
@@ -40,6 +40,16 @@ _require_command "$FSCK_OVERLAY_PROG" fsck.overlay
 _scratch_mkfs
 
 OVL_XATTR_OPAQUE_VAL=y
+OVL_XATTR_IMPURE_VAL=y
+
+# Create impure directories
+make_impure_dir()
+{
+	for dir in $*; do
+		mkdir -p $dir
+		$SETFATTR_PROG -n $OVL_XATTR_IMPURE -v $OVL_XATTR_IMPURE_VAL $dir
+	done
+}
 
 # Create a redirect directory
 make_redirect_dir()
@@ -104,6 +114,19 @@ check_whiteout()
 	done
 }
 
+# Run fsck.overlay and check return value
+run_fsck()
+{
+	local expect=$1
+	shift 1
+
+	_overlay_fsck_dirs $* >> $seqres.full 2>&1
+	fsck_ret=$?
+
+	[[ "$fsck_ret" == "$expect" ]] || \
+		echo "fsck return unexpected:$expect,$fsck_ret"
+}
+
 # Create test directories
 lowerdir=$OVL_BASE_SCRATCH_MNT/lower
 lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
@@ -121,8 +144,7 @@ echo "+ Invalid redirect"
 make_test_dirs
 make_redirect_dir $upperdir/testdir "invalid"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
 check_no_redirect $upperdir/testdir
 
 # Test invalid redirect xattr point to a file origin, should remove
@@ -131,8 +153,7 @@ make_test_dirs
 touch $lowerdir/origin
 make_redirect_dir $upperdir/testdir "origin"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
 check_no_redirect $upperdir/testdir
 
 # Test valid redirect xattr point to a directory origin in the same directory,
@@ -142,9 +163,9 @@ make_test_dirs
 mkdir $lowerdir/origin
 make_whiteout $upperdir/origin
 make_redirect_dir $upperdir/testdir "origin"
+make_impure_dir $upperdir
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_OK $lowerdir $upperdir $workdir -p
 check_redirect $upperdir/testdir "origin"
 
 # Test valid redirect xattr point to a directory origin in different directories
@@ -154,9 +175,9 @@ make_test_dirs
 mkdir $lowerdir/origin
 make_whiteout $upperdir/origin
 make_redirect_dir $upperdir/testdir1/testdir2 "/origin"
+make_impure_dir $upperdir/testdir1
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_OK $lowerdir $upperdir $workdir -p
 check_redirect $upperdir/testdir1/testdir2 "/origin"
 
 # Test valid redirect xattr but missing whiteout to cover lower target,
@@ -166,8 +187,7 @@ make_test_dirs
 mkdir $lowerdir/origin
 make_redirect_dir $upperdir/testdir "origin"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
 check_redirect $upperdir/testdir "origin"
 check_whiteout $upperdir/origin
 
@@ -177,9 +197,9 @@ make_test_dirs
 mkdir $lowerdir/{testdir1,testdir2}
 make_redirect_dir $upperdir/testdir1 "testdir2"
 make_redirect_dir $upperdir/testdir2 "testdir1"
+make_impure_dir $upperdir
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_OK $lowerdir $upperdir $workdir -p
 check_redirect $upperdir/testdir1 "testdir2"
 check_redirect $upperdir/testdir2 "testdir1"
 
@@ -191,8 +211,7 @@ mkdir $lowerdir/testdir
 make_redirect_dir $upperdir/testdir "invalid"
 
 # Question get yes answer: Should set opaque dir ?
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -y
 check_no_redirect $upperdir/testdir
 check_opaque $upperdir/testdir
 
@@ -205,12 +224,10 @@ make_redirect_dir $lowerdir/testdir1 "origin"
 make_redirect_dir $lowerdir/testdir2 "origin"
 make_redirect_dir $upperdir/testdir3 "origin"
 
-_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
-	$seqres.full 2>&1 && echo "fsck should fail"
+run_fsck $FSCK_UNCORRECTED "$lowerdir:$lowerdir2" $upperdir $workdir -p
 
 # Question get yes answer: Duplicate redirect directory, remove xattr ?
-_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -y >> \
-	$seqres.full 2>&1 || echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT "$lowerdir:$lowerdir2" $upperdir $workdir -y
 redirect_1=`check_redirect $lowerdir/testdir1 "origin" 2>/dev/null`
 redirect_2=`check_redirect $lowerdir/testdir2 "origin" 2>/dev/null`
 [[ $redirect_1 == $redirect_2 ]] && echo "Redirect xattr incorrect"
@@ -223,12 +240,10 @@ make_test_dirs
 mkdir $lowerdir/origin $upperdir/origin
 make_redirect_dir $upperdir/testdir "origin"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 && \
-	echo "fsck should fail"
+run_fsck $FSCK_UNCORRECTED $lowerdir $upperdir $workdir -p
 
 # Question get yes answer: Duplicate redirect directory, remove xattr ?
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -y
 check_no_redirect $upperdir/testdir
 
 # Test duplicate redirect xattr with lower same name directory exists,
@@ -240,8 +255,7 @@ make_redirect_dir $upperdir/testdir "invalid"
 
 # Question one get yes answer: Duplicate redirect directory, remove xattr?
 # Question two get yes answer: Should set opaque dir ?
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -y
 check_no_redirect $upperdir/testdir
 check_opaque $upperdir/testdir
 
diff --git a/tests/overlay/056 b/tests/overlay/056
index 778e1f6..9fca632 100755
--- a/tests/overlay/056
+++ b/tests/overlay/056
@@ -70,6 +70,19 @@ check_impure()
 	[[ "$value" == "$OVL_XATTR_IMPURE_VAL" ]] || echo "Missing impure xattr"
 }
 
+# Run fsck.overlay and check return value
+run_fsck()
+{
+	local expect=$1
+	shift 1
+
+	_overlay_fsck_dirs $* >> $seqres.full 2>&1
+	fsck_ret=$?
+
+	[[ "$fsck_ret" == "$expect" ]] || \
+		echo "fsck return unexpected:$expect,$fsck_ret"
+}
+
 # Create test directories
 lowerdir=$OVL_BASE_SCRATCH_MNT/lower
 lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
@@ -96,8 +109,7 @@ $UMOUNT_PROG $SCRATCH_MNT
 remove_impure $upperdir/testdir1
 remove_impure $upperdir/testdir2
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
 check_impure $upperdir/testdir1
 check_impure $upperdir/testdir2
 
@@ -108,8 +120,7 @@ make_test_dirs
 mkdir $lowerdir/origin
 make_redirect_dir $upperdir/testdir/subdir "/origin"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
 check_impure $upperdir/testdir
 
 # Test missing impure xattr in directory which has merge directories,
@@ -118,8 +129,7 @@ echo "+ Missing impure(3)"
 make_test_dirs
 mkdir $lowerdir/testdir $upperdir/testdir
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+run_fsck $FSCK_NONDESTRUCT $lowerdir $upperdir $workdir -p
 check_impure $upperdir
 
 # success, all done
-- 
2.5.0

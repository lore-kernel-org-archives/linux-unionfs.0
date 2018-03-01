Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v5 5/5] overlay: correct scratch dirs check
Date: Thu, 1 Mar 2018 20:13:47 +0800
Message-ID: <20180301121347.5824-6-yi.zhang@huawei.com>
In-Reply-To: <20180301121347.5824-1-yi.zhang@huawei.com>
References: <20180301121347.5824-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Tests that use _overlay_scratch_mount_dirs instead of _scratch_mount
should use _require_scratch_nocheck instead of _require_scratch
because these tests are either mounting with multiple lower dirs or
mounting with non-default lower/upper/work dir, so
_check_overlay_scratch_fs won't handle these cases correctly. So we
introduce _overlay_check_scratch_dirs helper and should call this
helper with the correct dir arguments for these non-default cases.

This patch modify these tests to optionally call
_overlay_check_scratch_dirs at the end of the test or after
_scratch_umount to mount base filesystem only and run the checker.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay    | 29 +++++++++++++++++++++++++++++
 tests/overlay/005 |  7 ++++++-
 tests/overlay/010 |  7 ++++++-
 tests/overlay/014 | 10 +++++++++-
 tests/overlay/035 |  7 ++++++-
 tests/overlay/036 |  6 +++++-
 tests/overlay/037 |  7 ++++++-
 tests/overlay/038 | 10 +++++++++-
 tests/overlay/041 | 10 +++++++++-
 tests/overlay/043 |  7 ++++++-
 tests/overlay/044 |  8 +++++++-
 tests/overlay/051 | 10 ++++++++--
 tests/overlay/053 | 10 ++++++++--
 tests/overlay/055 | 10 ++++++++--
 14 files changed, 122 insertions(+), 16 deletions(-)

diff --git a/common/overlay b/common/overlay
index 5d01e5e..441827b 100644
--- a/common/overlay
+++ b/common/overlay
@@ -219,6 +219,35 @@ _overlay_check_dirs()
 	return $err
 }
 
+# Check the same mnt/dev of _check_overlay_scratch_fs but non-default
+# underlying scratch dirs of overlayfs, it needs lower/upper/work dirs
+# provided as arguments, and it's useful for non-default setups such
+# as multiple lower layers
+_overlay_check_scratch_dirs()
+{
+	local lowerdir=$1
+	local upperdir=$2
+	local workdir=$3
+	shift 3
+
+	# Need to umount overlay for scratch dir check
+	local ovl_mounted=`_is_dir_mountpoint $SCRATCH_MNT`
+	[ -z "$ovl_mounted" ] || $UMOUNT_PROG $SCRATCH_MNT
+
+	# Check dirs with extra overlay options
+	_overlay_check_dirs $lowerdir $upperdir $workdir $*
+	local ret=$?
+
+	if [ $ret -eq 0 -a -n "$ovl_mounted" ]; then
+		# overlay was mounted, remount with extra mount options
+		_overlay_scratch_mount_dirs $lowerdir $upperdir \
+					    $workdir $*
+		ret=$?
+	fi
+
+	return $ret
+}
+
 _overlay_check_fs()
 {
 	# The first arguments is overlay mount point use for checking
diff --git a/tests/overlay/005 b/tests/overlay/005
index 17992a3..87fc9bb 100755
--- a/tests/overlay/005
+++ b/tests/overlay/005
@@ -54,7 +54,9 @@ rm -f $seqres.full
 # Modify as appropriate.
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 _require_loop
 
 # Remove all files from previous tests
@@ -102,6 +104,9 @@ $XFS_IO_PROG -f -c "o" ${SCRATCH_MNT}/test_file \
 # unmount overlayfs
 $UMOUNT_PROG $SCRATCH_MNT
 
+# check overlayfs
+_overlay_check_scratch_dirs $lowerd $upperd $workd
+
 # unmount undelying xfs, this tiggers panic if memleak happens
 $UMOUNT_PROG ${OVL_BASE_SCRATCH_MNT}/uppermnt
 $UMOUNT_PROG ${OVL_BASE_SCRATCH_MNT}/lowermnt
diff --git a/tests/overlay/010 b/tests/overlay/010
index f55ebec..32af89c 100755
--- a/tests/overlay/010
+++ b/tests/overlay/010
@@ -48,7 +48,9 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 
 # Remove all files from previous tests
 _scratch_mkfs
@@ -70,6 +72,9 @@ mknod $lowerdir2/testdir/a c 0 0
 _overlay_scratch_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
 rm -rf $SCRATCH_MNT/testdir
 
+# check overlayfs
+_overlay_check_scratch_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
+
 # success, all done
 echo "Silence is golden"
 status=0
diff --git a/tests/overlay/014 b/tests/overlay/014
index 9f308d3..67fad9f 100755
--- a/tests/overlay/014
+++ b/tests/overlay/014
@@ -53,7 +53,9 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 
 # Remove all files from previous tests
 _scratch_mkfs
@@ -78,6 +80,9 @@ mkdir -p $SCRATCH_MNT/testdir/visibledir
 # unmount overlayfs but not base fs
 $UMOUNT_PROG $SCRATCH_MNT
 
+# check overlayfs
+_overlay_check_scratch_dirs $lowerdir1 $lowerdir2 $workdir2
+
 # mount overlay again, with lowerdir1 and lowerdir2 as multiple lowerdirs,
 # and create a new file in testdir, triggers copyup from lowerdir,
 # copyup should not copy overlayfs private xattr
@@ -90,6 +95,9 @@ $UMOUNT_PROG $SCRATCH_MNT
 _overlay_scratch_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
 ls $SCRATCH_MNT/testdir
 
+# check overlayfs
+_overlay_check_scratch_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
+
 # success, all done
 status=0
 exit
diff --git a/tests/overlay/035 b/tests/overlay/035
index 0544774..d1b2c19 100755
--- a/tests/overlay/035
+++ b/tests/overlay/035
@@ -51,7 +51,9 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 _require_chattr i
 
 # Remove all files from previous tests
@@ -81,6 +83,9 @@ _overlay_scratch_mount_dirs $lowerdir2 $upperdir $workdir
 touch $SCRATCH_MNT/bar 2>&1 | _filter_scratch
 _scratch_remount rw 2>&1 | _filter_ro_mount
 
+# check overlayfs
+_overlay_check_scratch_dirs $lowerdir2 $upperdir $workdir
+
 # success, all done
 status=0
 exit
diff --git a/tests/overlay/036 b/tests/overlay/036
index e04aaee..8d3ccf4 100755
--- a/tests/overlay/036
+++ b/tests/overlay/036
@@ -69,7 +69,9 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 _require_scratch_feature index
 
 # Remove all files from previous tests
@@ -110,6 +112,8 @@ _overlay_mount_dirs $lowerdir $upperdir $workdir2 \
 _overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
 	    overlay3 $SCRATCH_MNT -oindex=on 2>&1 | _filter_busy_mount
 
+# check overlayfs
+_overlay_check_scratch_dirs $lowerdir $upperdir $workdir
 
 # success, all done
 status=0
diff --git a/tests/overlay/037 b/tests/overlay/037
index 6710dda..4e2e5df 100755
--- a/tests/overlay/037
+++ b/tests/overlay/037
@@ -55,7 +55,9 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 _require_scratch_feature index
 
 # Remove all files from previous tests
@@ -87,6 +89,9 @@ $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 # Mount overlay with original lowerdir, upperdir, workdir and index=on - expect success
 _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -oindex=on
 
+# check overlayfs
+_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -oindex=on
+
 # success, all done
 status=0
 exit
diff --git a/tests/overlay/038 b/tests/overlay/038
index bd87156..972a16e 100755
--- a/tests/overlay/038
+++ b/tests/overlay/038
@@ -46,7 +46,9 @@ _cleanup()
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 _require_attrs
 _require_test_program "t_dir_type"
 
@@ -163,6 +165,9 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
 
 _scratch_unmount
 
+# check overlayfs
+_check_scratch_fs
+
 # Verify pure lower residing in dir which has another lower layer
 _scratch_mkfs
 
@@ -202,6 +207,9 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
 [[ $subdir_d == "subdir d" ]] || \
 	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for subdir"
 
+# check overlayfs
+_overlay_check_scratch_dirs "$middir:$lowerdir" $upperdir $workdir
+
 echo "Silence is golden"
 status=0
 exit
diff --git a/tests/overlay/041 b/tests/overlay/041
index 11efacb..4e72348 100755
--- a/tests/overlay/041
+++ b/tests/overlay/041
@@ -48,7 +48,9 @@ _cleanup()
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 _require_test
 _require_attrs
 _require_test_program "t_dir_type"
@@ -168,6 +170,9 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
 
 _scratch_unmount
 
+# check overlayfs
+_overlay_check_scratch_dirs $lowerdir $upperdir $workdir
+
 # Verify pure lower residing in dir which has another lower layer
 middir=$OVL_BASE_TEST_DIR/$seq-ovl-mid
 lowerdir=$OVL_BASE_TEST_DIR/$seq-ovl-lower
@@ -206,6 +211,9 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
 [[ $subdir_d == "subdir d" ]] || \
 	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for subdir"
 
+# check overlayfs
+_overlay_check_scratch_dirs "$middir:$lowerdir" $upperdir $workdir
+
 echo "Silence is golden"
 status=0
 exit
diff --git a/tests/overlay/043 b/tests/overlay/043
index 699c4e1..46df686 100755
--- a/tests/overlay/043
+++ b/tests/overlay/043
@@ -56,7 +56,9 @@ _cleanup()
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 _require_test
 _require_test_program "af_unix"
 _require_test_program "t_dir_type"
@@ -153,6 +155,9 @@ _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
 # Compare inode numbers before/after mount cycle
 check_inode_numbers $testdir $tmp.after_move $tmp.after_cycle
 
+# check overlayfs
+_overlay_check_scratch_dirs $lowerdir $upperdir $workdir
+
 echo "Silence is golden"
 status=0
 exit
diff --git a/tests/overlay/044 b/tests/overlay/044
index e57f6f7..2ab3035 100755
--- a/tests/overlay/044
+++ b/tests/overlay/044
@@ -49,7 +49,9 @@ _cleanup()
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 _require_test
 _require_scratch_feature index
 _require_test_program "t_dir_type"
@@ -122,6 +124,7 @@ check_ino_nlink $SCRATCH_MNT $tmp.before $tmp.after_one
 
 # Verify that the hardlinks survive a mount cycle
 $UMOUNT_PROG $SCRATCH_MNT
+_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o index=on
 _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on
 
 echo "== After mount cycle =="
@@ -138,5 +141,8 @@ echo "== After write two =="
 cat $FILES
 check_ino_nlink $SCRATCH_MNT $tmp.after_one $tmp.after_two
 
+# check overlayfs
+_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o index=on
+
 status=0
 exit
diff --git a/tests/overlay/051 b/tests/overlay/051
index ae7844d..04bd133 100755
--- a/tests/overlay/051
+++ b/tests/overlay/051
@@ -61,8 +61,10 @@ _cleanup()
 _supported_fs overlay
 _supported_os Linux
 _require_test
-_require_scratch
 _require_test_program "open_by_handle"
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 # We need to require both features together, because nfs_export cannot
 # be enabled when index is disabled
 _require_scratch_overlay_features index nfs_export
@@ -122,10 +124,14 @@ mount_dirs()
 				-o "index=on,nfs_export=on"
 }
 
-# Unmount the overlay without unmounting base fs
+# Unmount the overlay without unmounting base fs and check the
+# underlying dirs
 unmount_dirs()
 {
 	$UMOUNT_PROG $SCRATCH_MNT
+
+	_overlay_check_scratch_dirs $middle:$lower $upper $work \
+				-o "index=on,nfs_export=on"
 }
 
 # Check non-stale file handles of lower/upper files and verify
diff --git a/tests/overlay/053 b/tests/overlay/053
index d4fdcde..d766cde 100755
--- a/tests/overlay/053
+++ b/tests/overlay/053
@@ -63,8 +63,10 @@ _cleanup()
 _supported_fs overlay
 _supported_os Linux
 _require_test
-_require_scratch
 _require_test_program "open_by_handle"
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 # We need to require all features together, because nfs_export cannot
 # be enabled when index is disabled
 _require_scratch_overlay_features index nfs_export redirect_dir
@@ -118,10 +120,14 @@ mount_dirs()
 				-o "index=on,nfs_export=on,redirect_dir=on"
 }
 
-# Unmount the overlay without unmounting base fs
+# Unmount the overlay without unmounting base fs and check the
+# underlying dirs
 unmount_dirs()
 {
 	$UMOUNT_PROG $SCRATCH_MNT
+
+	_overlay_check_scratch_dirs $middle:$lower $upper $work \
+				-o "index=on,nfs_export=on,redirect_dir=on"
 }
 
 # Check non-stale file handles of lower/upper moved files
diff --git a/tests/overlay/055 b/tests/overlay/055
index 70fe6ac..02da6ef 100755
--- a/tests/overlay/055
+++ b/tests/overlay/055
@@ -67,8 +67,10 @@ _cleanup()
 _supported_fs overlay
 _supported_os Linux
 _require_test
-_require_scratch
 _require_test_program "open_by_handle"
+# Use non-default scratch underlying overlay dirs, we need to check
+# them explicity after test.
+_require_scratch_nocheck
 # We need to require all features together, because nfs_export cannot
 # be enabled when index is disabled
 _require_scratch_overlay_features index nfs_export redirect_dir
@@ -122,10 +124,14 @@ mount_dirs()
 				-o "index=on,nfs_export=on,redirect_dir=on"
 }
 
-# Unmount the overlay without unmounting base fs
+# Unmount the overlay without unmounting base fs and check the
+# underlying dirs
 unmount_dirs()
 {
 	$UMOUNT_PROG $SCRATCH_MNT
+
+	_overlay_check_scratch_dirs $middle:$lower $upper $work \
+				-o "index=on,nfs_export=on,redirect_dir=on"
 }
 
 # Check file handles of dir with ancestor under lower redirect
-- 
2.5.0

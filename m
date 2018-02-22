Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v2] overlay: correct test mount options
Date: Thu, 22 Feb 2018 10:54:13 +0800
Message-ID: <20180222025413.31131-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Current overlay's _test_mount functions mount base test filesystem
with TEST_FS_MOUNT_OPTS and mount test overlayfs with MOUNT_OPTIONS
instead of TEST_FS_MOUNT_OPTS. The TEST_FS_MOUNT_OPTS variable
should be used for test overlayfs like MOUNT_OPTIONS use for scratch
overlayfs.

This patch rename OVL_BASE_MOUNT_OPTIONS to
OVL_BASE_SCRATCH_MOUNT_OPTIONS and introduce an counterpart variable
OVL_BASE_TEST_MOUNT_OPTIONS for test base filesystem, and then use
TEST_FS_MOUNT_OPTS for test overlayfs. We also modify overlay mount
helpers to adapt mount options.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---

Changes since v1:
- Rename _overlay_mount_dirs() to _do_overlay_mount_dirs() to do
  the actual overlayfs mount operation, and introduce another
  _overlay_mount_dirs() to mount optional overlayfs for tests use.

---
 common/config  | 17 +++++++++++++----
 common/overlay | 32 +++++++++++++++++++++++---------
 2 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/common/config b/common/config
index 20f0e5f..fd04a16 100644
--- a/common/config
+++ b/common/config
@@ -346,6 +346,9 @@ _test_mount_opts()
 	glusterfs)
 		export TEST_FS_MOUNT_OPTS=$GLUSTERFS_MOUNT_OPTIONS
 		;;
+	overlay)
+		export TEST_FS_MOUNT_OPTS=$OVERLAY_MOUNT_OPTIONS
+		;;
 	ext2|ext3|ext4|ext4dev)
 		# acls & xattrs aren't turned on by default on older ext$FOO
 		export TEST_FS_MOUNT_OPTS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
@@ -546,16 +549,19 @@ _overlay_config_override()
 	# Store original base fs vars
 	export OVL_BASE_TEST_DEV="$TEST_DEV"
 	export OVL_BASE_TEST_DIR="$TEST_DIR"
-	# If config does not set MOUNT_OPTIONS, its value may be
-	# leftover from previous _overlay_config_override, so
+	# If config does not set MOUNT_OPTIONS and TEST_FS_MOUNT_OPTS, its
+	# value may be leftover from previous _overlay_config_override, so
 	# don't use that value for base fs mount
 	[ "$MOUNT_OPTIONS" != "$OVERLAY_MOUNT_OPTIONS" ] || unset MOUNT_OPTIONS
-	export OVL_BASE_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+	export OVL_BASE_SCRATCH_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+	[ "$TEST_FS_MOUNT_OPTS" != "$OVERLAY_MOUNT_OPTIONS" ] || unset TEST_FS_MOUNT_OPTS
+	export OVL_BASE_TEST_MOUNT_OPTIONS="$TEST_FS_MOUNT_OPTS"
 
 	# Set TEST vars to overlay base and mount dirs inside base fs
 	export TEST_DEV="$OVL_BASE_TEST_DIR"
 	export TEST_DIR="$OVL_BASE_TEST_DIR/$OVL_MNT"
 	export MOUNT_OPTIONS="$OVERLAY_MOUNT_OPTIONS"
+	export TEST_FS_MOUNT_OPTS="$OVERLAY_MOUNT_OPTIONS"
 
 	[ -b "$SCRATCH_DEV" ] || return 0
 
@@ -580,7 +586,10 @@ _overlay_config_restore()
 	[ -z "$OVL_BASE_TEST_DIR" ] || export TEST_DIR=$OVL_BASE_TEST_DIR
 	[ -z "$OVL_BASE_SCRATCH_DEV" ] || export SCRATCH_DEV=$OVL_BASE_SCRATCH_DEV
 	[ -z "$OVL_BASE_SCRATCH_MNT" ] || export SCRATCH_MNT=$OVL_BASE_SCRATCH_MNT
-	[ -z "$OVL_BASE_MOUNT_OPTIONS" ] || export MOUNT_OPTIONS=$OVL_BASE_MOUNT_OPTIONS
+	[ -z "$OVL_BASE_SCRATCH_MOUNT_OPTIONS" ] || \
+		export MOUNT_OPTIONS=$OVL_BASE_SCRATCH_MOUNT_OPTIONS
+	[ -z "$OVL_BASE_TEST_MOUNT_OPTIONS" ] || \
+		export TEST_FS_MOUNT_OPTS=$OVL_BASE_TEST_MOUNT_OPTIONS
 }
 
 # Parse config section options. This function will parse all the configuration
diff --git a/common/overlay b/common/overlay
index 29f9bf8..46a876b 100644
--- a/common/overlay
+++ b/common/overlay
@@ -12,7 +12,7 @@ export OVL_XATTR_NLINK="trusted.overlay.nlink"
 export OVL_XATTR_UPPER="trusted.overlay.upper"
 
 # helper function to do the actual overlayfs mount operation
-_overlay_mount_dirs()
+_do_overlay_mount_dirs()
 {
 	local lowerdir=$1
 	local upperdir=$2
@@ -20,7 +20,19 @@ _overlay_mount_dirs()
 	shift 3
 
 	$MOUNT_PROG -t overlay -o lowerdir=$lowerdir -o upperdir=$upperdir \
-		    -o workdir=$workdir `_common_dev_mount_options $*`
+		    -o workdir=$workdir $*
+}
+
+# Mount overlayfs with optional dirs and mount point
+_overlay_mount_dirs()
+{
+	local lowerdir=$1
+	local upperdir=$2
+	local workdir=$3
+	shift 3
+
+	_do_overlay_mount_dirs $lowerdir $upperdir $workdir \
+			       `_common_dev_mount_options $*`
 }
 
 # Mount with same options/mnt/dev of scratch mount, but optionally
@@ -58,7 +70,7 @@ _overlay_mount()
 
 	_overlay_mkdirs $dir
 
-	_overlay_mount_dirs $dir/$OVL_LOWER $dir/$OVL_UPPER $dir/$OVL_WORK \
+	_do_overlay_mount_dirs $dir/$OVL_LOWER $dir/$OVL_UPPER $dir/$OVL_WORK \
 				$* $dir $mnt
 }
 
@@ -86,26 +98,28 @@ _overlay_base_test_mount()
 {
 	_overlay_base_mount OVL_BASE_TEST_DEV OVL_BASE_TEST_DIR \
 			"$OVL_BASE_TEST_DEV" "$OVL_BASE_TEST_DIR" \
-			$TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS
+			$OVL_BASE_TEST_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
 }
 
 _overlay_test_mount()
 {
 	_overlay_base_test_mount && \
-		_overlay_mount $OVL_BASE_TEST_DIR $TEST_DIR $*
+		_overlay_mount $OVL_BASE_TEST_DIR $TEST_DIR \
+			       $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS $*
 }
 
 _overlay_base_scratch_mount()
 {
 	_overlay_base_mount OVL_BASE_SCRATCH_DEV OVL_BASE_SCRATCH_MNT \
 			"$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT" \
-			$OVL_BASE_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
+			$OVL_BASE_SCRATCH_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
 }
 
 _overlay_scratch_mount()
 {
 	_overlay_base_scratch_mount && \
-		_overlay_mount $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
+		_overlay_mount $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
+			       `_common_dev_mount_options $*`
 }
 
 _overlay_base_unmount()
@@ -305,7 +319,7 @@ _check_overlay_test_fs()
 	_overlay_check_fs "$TEST_DIR" \
 		OVL_BASE_TEST_DEV OVL_BASE_TEST_DIR \
 		"$OVL_BASE_TEST_DEV" "$OVL_BASE_TEST_DIR" \
-		$TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS
+		$OVL_BASE_TEST_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
 }
 
 _check_overlay_scratch_fs()
@@ -313,5 +327,5 @@ _check_overlay_scratch_fs()
 	_overlay_check_fs "$SCRATCH_MNT" \
 		OVL_BASE_SCRATCH_DEV OVL_BASE_SCRATCH_MNT \
 		"$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT" \
-		$OVL_BASE_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
+		$OVL_BASE_SCRATCH_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
 }
-- 
2.5.0

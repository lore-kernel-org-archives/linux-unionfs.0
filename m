Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v5 2/5] overlay: hook filesystem check helper
Date: Thu, 1 Mar 2018 20:13:44 +0800
Message-ID: <20180301121347.5824-3-yi.zhang@huawei.com>
In-Reply-To: <20180301121347.5824-1-yi.zhang@huawei.com>
References: <20180301121347.5824-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Hook filesystem check helper to _check_test_fs and _check_scratch_fs
for checking consistency of underlying dirs of overlay filesystem.
These helpers works only if fsck.overlay exists.

This patch introduce OVERLAY_FSCK_OPTIONS use for check overlayfs like
OVERLAY_MOUNT_OPTIONS, and also introduce a mount point check helper in
common/rc to detect a dir is a mount point or not.

[ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 README.overlay | 10 ++++--
 common/config  |  4 +++
 common/overlay | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc      | 18 +++++++++--
 4 files changed, 127 insertions(+), 4 deletions(-)

diff --git a/README.overlay b/README.overlay
index dfb8234..3cbefab 100644
--- a/README.overlay
+++ b/README.overlay
@@ -22,6 +22,10 @@ the base fs should be pre-formatted before starting the -overlay run.
 An easy way to accomplish this is by running './check <some test>' once,
 before running './check -overlay'.
 
+'./check -overlay' support check overlay test and scratch dirs,
+OVERLAY_FSCK_OPTIONS should be set instead of FSCK_OPTIONS if fsck
+options need to given directly.
+
 Because of the lack of mkfs support, multi-section config files are only
 partly supported with './check -overlay'. Only multi-section files that
 do not change FSTYP and MKFS_OPTIONS can be safely used with -overlay.
@@ -40,7 +44,9 @@ run overlay tests on the same base fs, but with different mount options:
  MOUNT_OPTIONS="-o pquota"
  TEST_FS_MOUNT_OPTS="-o noatime"
  OVERLAY_MOUNT_OPTIONS="-o redirect_dir=off"
+ OVERLAY_FSCK_OPTIONS="-n redirect_dir=off"
 
 In the example above, MOUNT_OPTIONS will be used to mount the base scratch fs,
-TEST_FS_MOUNT_OPTS will be used to mount the base test fs and
-OVERLAY_MOUNT_OPTIONS will be used to mount both test and scratch overlays.
+TEST_FS_MOUNT_OPTS will be used to mount the base test fs,
+OVERLAY_MOUNT_OPTIONS will be used to mount both test and scratch overlay and
+OVERLAY_FSCK_OPTIONS will be used to check both test and scratch overlay.
diff --git a/common/config b/common/config
index 71115bd..20f0e5f 100644
--- a/common/config
+++ b/common/config
@@ -566,6 +566,10 @@ _overlay_config_override()
 	# Set SCRATCH vars to overlay base and mount dirs inside base fs
 	export SCRATCH_DEV="$OVL_BASE_SCRATCH_MNT"
 	export SCRATCH_MNT="$OVL_BASE_SCRATCH_MNT/$OVL_MNT"
+
+	# Set fsck options, use default if user not set directly.
+	export FSCK_OPTIONS="$OVERLAY_FSCK_OPTIONS"
+	[ -z "$FSCK_OPTIONS" ] && _fsck_opts
 }
 
 _overlay_config_restore()
diff --git a/common/overlay b/common/overlay
index e1b07f4..5d01e5e 100644
--- a/common/overlay
+++ b/common/overlay
@@ -190,3 +190,102 @@ _overlay_fsck_dirs()
 	$FSCK_OVERLAY_PROG -o lowerdir=$lowerdir -o upperdir=$upperdir \
 			   -o workdir=$workdir $*
 }
+
+_overlay_check_dirs()
+{
+	local lowerdir=$1
+	local upperdir=$2
+	local workdir=$3
+	shift 3
+	local err=0
+
+	_overlay_fsck_dirs $lowerdir $upperdir $workdir \
+			   $FSCK_OPTIONS $* >>$tmp.fsck 2>&1
+	if [ $? -ne 0 ]; then
+		_log_err "_overlay_check_fs: overlayfs on $lowerdir,$upperdir,$workdir is inconsistent"
+
+		echo "*** fsck.overlay output ***"	>>$seqres.full
+		cat $tmp.fsck				>>$seqres.full
+		echo "*** end fsck.overlay output"	>>$seqres.full
+
+		echo "*** mount output ***"		>>$seqres.full
+		_mount					>>$seqres.full
+		echo "*** end mount output"		>>$seqres.full
+
+		err=1
+	fi
+	rm -f $tmp.fsck
+
+	return $err
+}
+
+_overlay_check_fs()
+{
+	# The first arguments is overlay mount point use for checking
+	# overlay filesystem is mounted or not, the remaining arquments
+	# use for mounting overlay base filesystem if it was not mounted.
+	# We shift one to aligns arguments for _overlay_base_mount.
+	local ovl_mnt=$1
+	shift 1
+
+	local base_dev=$3
+	local base_mnt=$4
+
+	[ "$FSTYP" = overlay ] || return 0
+
+	# Base fs needs to be mounted to check overlay dirs
+	local base_fstype=""
+	local ovl_mounted=""
+
+	[ -z "$base_dev" ] || \
+		base_fstype=`_fs_type $base_dev`
+
+	# If base_dev is set but base_fstype is empty, base fs is not
+	# mounted, we need to mount base fs. Otherwise, we need to
+	# check and umount overlayfs if it was mounted.
+	if [ -n "$base_dev" -a -z "$base_fstype" ]; then
+		_overlay_base_mount $*
+	else
+		# Check and umount overlay for dir check
+		ovl_mounted=`_is_dir_mountpoint $ovl_mnt`
+		[ -z "$ovl_mounted" ] || $UMOUNT_PROG $ovl_mnt
+	fi
+
+	_overlay_check_dirs $base_mnt/$OVL_LOWER $base_mnt/$OVL_UPPER \
+			    $base_mnt/$OVL_WORK
+	local ret=$?
+
+	if [ -n "$base_dev" -a -z "$base_fstype" ]; then
+		_overlay_base_unmount "$base_dev" "$base_mnt"
+	elif [ $ret -eq 0 -a -n "$ovl_mounted" ]; then
+		# overlay was mounted, remount besides extra mount options
+		_overlay_mount $base_mnt $ovl_mnt
+		ret=$?
+	fi
+
+	if [ $ret != 0 ]; then
+		status=1
+		if [ "$iam" != "check" ]; then
+			exit 1
+		fi
+		return 1
+	fi
+
+	return 0
+}
+
+_check_overlay_test_fs()
+{
+	_overlay_check_fs "$TEST_DIR" \
+		OVL_BASE_TEST_DEV OVL_BASE_TEST_DIR \
+		"$OVL_BASE_TEST_DEV" "$OVL_BASE_TEST_DIR" \
+		$TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS
+}
+
+_check_overlay_scratch_fs()
+{
+	_overlay_check_fs "$SCRATCH_MNT" \
+		OVL_BASE_SCRATCH_DEV OVL_BASE_SCRATCH_MNT \
+		"$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT" \
+		$OVL_BASE_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
+}
diff --git a/common/rc b/common/rc
index 1dae3bf..9317674 100644
--- a/common/rc
+++ b/common/rc
@@ -2395,6 +2395,20 @@ _is_dev_mounted()
 	findmnt -rncv -S $dev -t $fstype -o TARGET | head -1
 }
 
+# check if the given dir is a mount point, if so, return mount point
+_is_dir_mountpoint()
+{
+	local dir=$1
+	local fstype=${2:-$FSTYP}
+
+	if [ $# -lt 1 ]; then
+		echo "Uasge: _is_dir_mountpoint <dir> [fstype]" 1>&2
+		exit 1
+	fi
+
+	findmnt -rncv -t $fstype -o TARGET $dir | head -1
+}
+
 # remount a FS to a new mode (ro or rw)
 #
 _remount()
@@ -2590,7 +2604,7 @@ _check_test_fs()
 	# no way to check consistency for GlusterFS
 	;;
     overlay)
-	# no way to check consistency for overlay
+	_check_overlay_test_fs
 	;;
     pvfs2)
 	;;
@@ -2648,7 +2662,7 @@ _check_scratch_fs()
 	# no way to check consistency for GlusterFS
 	;;
     overlay)
-	# no way to check consistency for overlay
+	_check_overlay_scratch_fs
 	;;
     pvfs2)
 	;;
-- 
2.5.0

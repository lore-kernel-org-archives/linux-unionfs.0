From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v2 2/5] overlay: hook filesystem check helper
Date: Wed, 31 Jan 2018 18:27:56 +0800
Message-ID: <20180131102759.40997-3-yi.zhang@huawei.com>
References: <20180131102759.40997-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180131102759.40997-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

Hook filesystem check helper to _check_test_fs and _check_scratch_fs for
constants underlying dirs of overlay filesystem, and introduce scratch
check helpers for optionally lower/upper/work dirs. These helpers works
only if fsck.overlay exists.

[ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 common/overlay | 128 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc      |   4 +-
 2 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/common/overlay b/common/overlay
index d741a7e..0e45ddd 100644
--- a/common/overlay
+++ b/common/overlay
@@ -152,6 +152,14 @@ _require_scratch_overlay_feature()
 	_scratch_unmount
 }
 
+# Require the same scratch device as _require_scratch, but do not check
+# the constants OVL_LOWER/OVL_UPPER/OVL_WORK dirs, should use together
+# with optionally lower/upper/work dirs and do check explicitly after test.
+_require_overlay_scratch_dirs()
+{
+	_require_scratch_nocheck
+}
+
 # Helper function to check underlying dirs of overlay filesystem
 _overlay_fsck_dirs()
 {
@@ -165,3 +173,123 @@ _overlay_fsck_dirs()
 	$FSCK_OVERLAY_PROG -o lowerdir=$lowerdir -o upperdir=$upperdir \
 			   -o workdir=$workdir $*
 }
+
+_overlay_check_dirs()
+{
+	local lowerdir=$1
+	local upperdir=$2
+	local workdir=$3
+	local err=0
+
+	_overlay_fsck_dirs $* $FSCK_OPTIONS >>$tmp.fsck 2>&1
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
+# Check the same mnt/dev of _check_overlay_scratch_fs, but check optionally
+# lower/upper/work dirs of overlay filesystem, should use together with
+# _require_overlay_scratch_dirs
+_overlay_check_scratch_dirs()
+{
+	local lowerdir=$1
+	local upperdir=$2
+	local workdir=$3
+	shift 3
+
+	# Need to umount overlay for scratch dir check
+	local ovl_mounted=`_is_mounted $SCRATCH_MNT`
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
+_overlay_check_fs()
+{
+	# Aligns arguments for _overlay_base_mount
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
+	# If base fstype is set, base fs is mounted, mount otherwise
+	if [ -z "$base_fstype" ]; then
+		_overlay_base_mount $*
+	else
+		# Need to umount overlay for dir check
+		ovl_mounted=`_is_mounted $ovl_mnt`
+		[ -z "$ovl_mounted" ] || $UMOUNT_PROG $ovl_mnt
+	fi
+
+	_overlay_check_dirs $base_mnt/$OVL_LOWER $base_mnt/$OVL_UPPER \
+			    $base_mnt/$OVL_WORK
+	local ret=$?
+
+	if [ -z "$base_fstype" ]; then
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
index 3351f00..7b84bb5 100644
--- a/common/rc
+++ b/common/rc
@@ -2585,7 +2585,7 @@ _check_test_fs()
 	# no way to check consistency for GlusterFS
 	;;
     overlay)
-	# no way to check consistency for overlay
+	_check_overlay_test_fs
 	;;
     pvfs2)
 	;;
@@ -2643,7 +2643,7 @@ _check_scratch_fs()
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

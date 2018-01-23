From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v5 1/7] overlay: add filesystem check helper
Date: Tue, 23 Jan 2018 15:34:46 +0800
Message-ID: <20180123073452.19074-2-yi.zhang@huawei.com>
References: <20180123073452.19074-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4271 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751157AbeAWH0j (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 Jan 2018 02:26:39 -0500
In-Reply-To: <20180123073452.19074-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Add filesystem check helpers for the upcoming fsck.overlay utility.
Hook these helpers to _check_test_fs and _check_scratch_fs for constants
underlying dirs of overlay filesystem, and introduce scratch check helpers
for optionally lower/upper/work dirs. These helpers works only if
fsck.overlay exists.

[ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 common/config  |   1 +
 common/overlay | 145 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc      |   4 +-
 3 files changed, 148 insertions(+), 2 deletions(-)

diff --git a/common/config b/common/config
index 5f40413..71115bd 100644
--- a/common/config
+++ b/common/config
@@ -236,6 +236,7 @@ case "$HOSTOS" in
         export MKFS_REISER4_PROG="`set_prog_path mkfs.reiser4`"
 	export E2FSCK_PROG="`set_prog_path e2fsck`"
 	export TUNE2FS_PROG="`set_prog_path tune2fs`"
+	export FSCK_OVERLAY_PROG="`set_prog_path fsck.overlay`"
         ;;
 esac
 
diff --git a/common/overlay b/common/overlay
index 1da4ab1..c611a49 100644
--- a/common/overlay
+++ b/common/overlay
@@ -151,3 +151,148 @@ _require_scratch_overlay_feature()
 	        _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
 	_scratch_unmount
 }
+
+# Require the same scratch device as _require_scratch, but do not check
+# the constants OVL_LOWER/OVL_UPPER/OVL_WORK dirs, should use together
+# with optionally lower/upper/work dirs and do check explicitly after test.
+_require_overlay_scratch_dirs()
+{
+	_require_scratch_nocheck
+}
+
+_overlay_fsck_dirs()
+{
+	local lowerdir=$1
+	local upperdir=$2
+	local workdir=$3
+	local options=$4
+
+	[[ ! -x "$FSCK_OVERLAY_PROG" ]] && return 0
+
+	$FSCK_OVERLAY_PROG -o lowerdir=$lowerdir -o upperdir=$upperdir \
+			   -o workdir=$workdir $options
+}
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
+
+	# Need to umount overlay for scratch dir check
+	local type=`_fs_type $OVL_BASE_SCRATCH_MNT`
+
+	# If type is set, overlay is mounted
+	[ "$type" = "$FSTYP" ] && $UMOUNT_PROG $SCRATCH_MNT
+
+	_overlay_check_dirs $lowerdir $upperdir $workdir
+	local ret=$?
+
+	if [ $ret = 0 -a "$type" = "$FSTYP" ]; then
+		# overlay was mounted...
+
+		# If overlayfs have to recover with last mount options,
+		# OVERLAY_MOUNT_OPTIONS should be clarified before last
+		# mount
+		_overlay_scratch_mount_dirs $lowerdir $upperdir \
+			$workdir $OVERLAY_MOUNT_OPTIONS
+		ret=$?
+	fi
+
+	return $ret
+}
+
+_overlay_check_fs()
+{
+	local ovl_mnt=$1
+	local base_dev=$4
+	local base_mnt=$5
+	shift 1
+
+	[ "$FSTYP" = overlay ] || return 0
+
+	# Base fs needs to be mounted to check overlay dirs
+	local mounted=""
+	[ -z "$base_dev" ] || mounted=`_is_mounted $base_dev`
+
+	if [ -z "$mounted" ]; then
+		_overlay_base_mount $*
+	else
+		# Need to umount overlay for dir check
+		local type=`_fs_type $base_mnt`
+
+		# If type is set, overlay is mounted
+		[ "$type" = "$FSTYP" ] && $UMOUNT_PROG $ovl_mnt
+	fi
+
+	_overlay_check_dirs $base_mnt/$OVL_LOWER $base_mnt/$OVL_UPPER \
+			    $base_mnt/$OVL_WORK
+	local ret=$?
+
+	if [ -z "$mounted" ]; then
+		_overlay_base_unmount "$base_dev" "$base_mnt"
+	elif [ $ret = 0 -a "$type" = "$FSTYP" ]; then
+		# overlay was mounted...
+
+		# If overlayfs have to recover with last mount options,
+		# OVERLAY_MOUNT_OPTIONS should be clarified before last
+		# mount
+		_overlay_mount $base_mnt $ovl_mnt $OVERLAY_MOUNT_OPTIONS
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
index 77a4eb4..99aa092 100644
--- a/common/rc
+++ b/common/rc
@@ -2590,7 +2590,7 @@ _check_test_fs()
 	# no way to check consistency for GlusterFS
 	;;
     overlay)
-	# no way to check consistency for overlay
+	_check_overlay_test_fs
 	;;
     pvfs2)
 	;;
@@ -2648,7 +2648,7 @@ _check_scratch_fs()
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

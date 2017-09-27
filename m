From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5/5] overlay: move _overlay helpers to common/overlay
Date: Wed, 27 Sep 2017 13:47:32 +0300
Message-ID: <1506509252-4582-1-git-send-email-amir73il@gmail.com>
References: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

If you don't mind, please apply this cleanup patch on
top of the OVERLAY_MOUNT_OPTIONS series.

This is actaully a prep patch for implementing the first
_check_overlay_filesystem, but might as well take it now.

Amir.

 common/overlay | 160 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc      | 152 +-----------------------------------------------------
 2 files changed, 162 insertions(+), 150 deletions(-)
 create mode 100644 common/overlay

diff --git a/common/overlay b/common/overlay
new file mode 100644
index 0000000..c3bb9ee
--- /dev/null
+++ b/common/overlay
@@ -0,0 +1,160 @@
+#
+# overlayfs specific common functions.
+#
+
+# helper function to do the actual overlayfs mount operation
+_overlay_mount_dirs()
+{
+	local lowerdir=$1
+	local upperdir=$2
+	local workdir=$3
+	shift 3
+
+	$MOUNT_PROG -t overlay -o lowerdir=$lowerdir -o upperdir=$upperdir \
+		    -o workdir=$workdir `_common_dev_mount_options $*`
+}
+
+# Mount with same options/mnt/dev of scratch mount, but optionally
+# with different lower/upper/work dirs
+_overlay_scratch_mount_dirs()
+{
+	local lowerdir=$1
+	local upperdir=$2
+	local workdir=$3
+	shift 3
+
+	_overlay_mount_dirs $lowerdir $upperdir $workdir \
+				$* $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+}
+
+_overlay_mkdirs()
+{
+	local dir=$1
+
+	mkdir -p $dir/$OVL_UPPER
+	mkdir -p $dir/$OVL_LOWER
+	mkdir -p $dir/$OVL_WORK
+	mkdir -p $dir/$OVL_MNT
+}
+
+# Given a base fs dir, set up overlay directories and mount on the given mnt.
+# The dir is used as the mount device so it can be seen from df or mount
+_overlay_mount()
+{
+	local dir=$1
+	local mnt=$2
+	shift 2
+
+	_supports_filetype $dir || _notrun "upper fs needs to support d_type"
+
+	_overlay_mkdirs $dir
+
+	_overlay_mount_dirs $dir/$OVL_LOWER $dir/$OVL_UPPER $dir/$OVL_WORK \
+				$* $dir $mnt
+}
+
+_overlay_base_test_mount()
+{
+	if [ -z "$OVL_BASE_TEST_DEV" -o -z "$OVL_BASE_TEST_DIR" ] || \
+		_check_mounted_on OVL_BASE_TEST_DEV $OVL_BASE_TEST_DEV \
+				OVL_BASE_TEST_DIR $OVL_BASE_TEST_DIR
+	then
+		# no base fs or already mounted
+		return 0
+	elif [ $? -ne 1 ]
+	then
+		# base fs mounted but not on mount point
+		return 1
+	fi
+
+	_mount $TEST_FS_MOUNT_OPTS \
+		$SELINUX_MOUNT_OPTIONS \
+		$OVL_BASE_TEST_DEV $OVL_BASE_TEST_DIR
+}
+
+_overlay_test_mount()
+{
+	_overlay_base_test_mount && \
+		_overlay_mount $OVL_BASE_TEST_DIR $TEST_DIR $*
+}
+
+_overlay_base_scratch_mount()
+{
+	if [ -z "$OVL_BASE_SCRATCH_DEV" -o -z "$OVL_BASE_SCRATCH_MNT" ] || \
+		_check_mounted_on OVL_BASE_SCRATCH_DEV $OVL_BASE_SCRATCH_DEV \
+				OVL_BASE_SCRATCH_MNT $OVL_BASE_SCRATCH_MNT
+	then
+		# no base fs or already mounted
+		return 0
+	elif [ $? -ne 1 ]
+	then
+		# base fs mounted but not on mount point
+		return 1
+	fi
+
+	_mount $OVL_BASE_MOUNT_OPTIONS \
+		$SELINUX_MOUNT_OPTIONS \
+		$OVL_BASE_SCRATCH_DEV $OVL_BASE_SCRATCH_MNT
+}
+
+_overlay_base_scratch_unmount()
+{
+	[ -n "$OVL_BASE_SCRATCH_DEV" -a -n "$OVL_BASE_SCRATCH_MNT" ] || return 0
+
+	$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT
+}
+
+_overlay_scratch_mount()
+{
+	_overlay_base_scratch_mount && \
+		_overlay_mount $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
+}
+
+_overlay_base_test_unmount()
+{
+	[ -n "$OVL_BASE_TEST_DEV" -a -n "$OVL_BASE_TEST_DIR" ] || return 0
+
+	$UMOUNT_PROG $OVL_BASE_TEST_DIR
+}
+
+_overlay_test_unmount()
+{
+	$UMOUNT_PROG $TEST_DIR
+	_overlay_base_test_unmount
+}
+
+_overlay_scratch_unmount()
+{
+	$UMOUNT_PROG $SCRATCH_MNT
+	_overlay_base_scratch_unmount
+}
+
+# Require a specific overlayfs feature
+_require_scratch_overlay_feature()
+{
+	local feature=$1
+
+	# overalyfs features (e.g. redirect_dir, index) are
+	# configurable from Kconfig (the build default), by module
+	# parameter (the system default) and per mount by mount
+	# option ${feature}=[on|off].
+	#
+	# If the module parameter does not exist then there is no
+	# point in checking the mount option.
+	local default=`_get_fs_module_param ${feature}`
+	[ "$default" = Y ] || [ "$default" = N ] || \
+		_notrun "feature '${feature}' not supported by ${FSTYP}"
+
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount -o ${feature}=on || \
+		_notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
+	# Check options to be sure. For example, Overlayfs will fallback to
+	# index=off if underlying fs does not support file handles.
+	# Overlayfs only displays mount option if it differs from the default.
+	# Overlayfs may enable the feature, but fallback to read-only mount.
+	((( [ "$default" = N ] && _fs_options $SCRATCH_DEV | grep -q "${feature}=on" ) || \
+	  ( [ "$default" = Y ] && ! _fs_options $SCRATCH_DEV | grep -q "${feature}=off" )) && \
+	    touch $SCRATCH_MNT/foo 2>/dev/null ) || \
+	        _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
+	_scratch_unmount
+}
diff --git a/common/rc b/common/rc
index 54f81d3..201159b 100644
--- a/common/rc
+++ b/common/rc
@@ -171,6 +171,7 @@ case "$FSTYP" in
     glusterfs)
 	 ;;
     overlay)
+	 . ./common/overlay
 	 ;;
     reiser4)
 	 [ "$MKFS_REISER4_PROG" = "" ] && _fatal "mkfs.reiser4 not found"
@@ -333,133 +334,6 @@ _supports_filetype()
 	esac
 }
 
-# helper function to do the actual overlayfs mount operation
-_overlay_mount_dirs()
-{
-	local lowerdir=$1
-	local upperdir=$2
-	local workdir=$3
-	shift 3
-
-	$MOUNT_PROG -t overlay -o lowerdir=$lowerdir -o upperdir=$upperdir \
-		    -o workdir=$workdir `_common_dev_mount_options $*`
-}
-
-# Mount with same options/mnt/dev of scratch mount, but optionally
-# with different lower/upper/work dirs
-_overlay_scratch_mount_dirs()
-{
-	local lowerdir=$1
-	local upperdir=$2
-	local workdir=$3
-	shift 3
-
-	_overlay_mount_dirs $lowerdir $upperdir $workdir \
-				$* $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
-}
-
-_overlay_mkdirs()
-{
-	local dir=$1
-
-	mkdir -p $dir/$OVL_UPPER
-	mkdir -p $dir/$OVL_LOWER
-	mkdir -p $dir/$OVL_WORK
-	mkdir -p $dir/$OVL_MNT
-}
-
-# Given a base fs dir, set up overlay directories and mount on the given mnt.
-# The dir is used as the mount device so it can be seen from df or mount
-_overlay_mount()
-{
-	local dir=$1
-	local mnt=$2
-	shift 2
-
-	_supports_filetype $dir || _notrun "upper fs needs to support d_type"
-
-	_overlay_mkdirs $dir
-
-	_overlay_mount_dirs $dir/$OVL_LOWER $dir/$OVL_UPPER $dir/$OVL_WORK \
-				$* $dir $mnt
-}
-
-_overlay_base_test_mount()
-{
-	if [ -z "$OVL_BASE_TEST_DEV" -o -z "$OVL_BASE_TEST_DIR" ] || \
-		_check_mounted_on OVL_BASE_TEST_DEV $OVL_BASE_TEST_DEV \
-				OVL_BASE_TEST_DIR $OVL_BASE_TEST_DIR
-	then
-		# no base fs or already mounted
-		return 0
-	elif [ $? -ne 1 ]
-	then
-		# base fs mounted but not on mount point
-		return 1
-	fi
-
-	_mount $TEST_FS_MOUNT_OPTS \
-		$SELINUX_MOUNT_OPTIONS \
-		$OVL_BASE_TEST_DEV $OVL_BASE_TEST_DIR
-}
-
-_overlay_test_mount()
-{
-	_overlay_base_test_mount && \
-		_overlay_mount $OVL_BASE_TEST_DIR $TEST_DIR $*
-}
-
-_overlay_base_scratch_mount()
-{
-	if [ -z "$OVL_BASE_SCRATCH_DEV" -o -z "$OVL_BASE_SCRATCH_MNT" ] || \
-		_check_mounted_on OVL_BASE_SCRATCH_DEV $OVL_BASE_SCRATCH_DEV \
-				OVL_BASE_SCRATCH_MNT $OVL_BASE_SCRATCH_MNT
-	then
-		# no base fs or already mounted
-		return 0
-	elif [ $? -ne 1 ]
-	then
-		# base fs mounted but not on mount point
-		return 1
-	fi
-
-	_mount $OVL_BASE_MOUNT_OPTIONS \
-		$SELINUX_MOUNT_OPTIONS \
-		$OVL_BASE_SCRATCH_DEV $OVL_BASE_SCRATCH_MNT
-}
-
-_overlay_base_scratch_unmount()
-{
-	[ -n "$OVL_BASE_SCRATCH_DEV" -a -n "$OVL_BASE_SCRATCH_MNT" ] || return 0
-
-	$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT
-}
-
-_overlay_scratch_mount()
-{
-	_overlay_base_scratch_mount && \
-		_overlay_mount $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
-}
-
-_overlay_base_test_unmount()
-{
-	[ -n "$OVL_BASE_TEST_DEV" -a -n "$OVL_BASE_TEST_DIR" ] || return 0
-
-	$UMOUNT_PROG $OVL_BASE_TEST_DIR
-}
-
-_overlay_test_unmount()
-{
-	$UMOUNT_PROG $TEST_DIR
-	_overlay_base_test_unmount
-}
-
-_overlay_scratch_unmount()
-{
-	$UMOUNT_PROG $SCRATCH_MNT
-	_overlay_base_scratch_unmount
-}
-
 _scratch_mount()
 {
     if [ "$FSTYP" == "overlay" ]; then
@@ -3672,29 +3546,7 @@ _require_scratch_feature()
 
 	case "$FSTYP" in
 	overlay)
-		# overalyfs features (e.g. redirect_dir, index) are
-		# configurable from Kconfig (the build default), by module
-		# parameter (the system default) and per mount by mount
-		# option ${feature}=[on|off].
-		#
-		# If the module parameter does not exist then there is no
-		# point in checking the mount option.
-		local default=`_get_fs_module_param ${feature}`
-		[ "$default" = Y ] || [ "$default" = N ] || \
-			_notrun "feature '${feature}' not supported by ${FSTYP}"
-
-		_scratch_mkfs > /dev/null 2>&1
-		_scratch_mount -o ${feature}=on || \
-			_notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
-		# Check options to be sure. For example, Overlayfs will fallback to
-		# index=off if underlying fs does not support file handles.
-		# Overlayfs only displays mount option if it differs from the default.
-		# Overlayfs may enable the feature, but fallback to read-only mount.
-		((( [ "$default" = N ] && _fs_options $SCRATCH_DEV | grep -q "${feature}=on" ) || \
-		  ( [ "$default" = Y ] && ! _fs_options $SCRATCH_DEV | grep -q "${feature}=off" )) && \
-		    touch $SCRATCH_MNT/foo 2>/dev/null ) || \
-		        _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
-		_scratch_unmount
+		_require_scratch_overlay_feature ${feature}
 		;;
 	*)
 		_fail "Test for feature '${feature}' of ${FSTYP} is not implemented"
-- 
2.7.4

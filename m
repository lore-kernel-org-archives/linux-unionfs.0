From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/3] overlay: configure base fs mount point for running tests
Date: Fri, 27 Jan 2017 10:56:03 +0200
Message-ID: <1485507365-29012-2-git-send-email-amir73il@gmail.com>
References: <1485507365-29012-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1485507365-29012-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Instead of setting the vars TEST/SCRATCH_DEV to overlay base dirs,
allow setting the vars SCRATCH/TEST_BASE_MNT, to configure where
the base fs is mounted and where overlay dirs will be created.
For example:

-export TEST_DEV=/mnt/base/test/ovl
-export SCRATCH_DEV=/mnt/base/scratch/ovl
+export TEST_BASE_MNT=/mnt/base/test
+export SCRATCH_BASE_MNT=/mnt/base/scratch
export TEST_DIR=/mnt/test
export SCRATCH_MNT=/mnt/scratch
export FSTYP=overlay

The new canonical vars SCRATCH/TEST_BASE_DIR are defined to refer to
overlay base dir explicitly, whether it was set by old or new config
method. Tests should always use these canonical vars and not the fake
SCRATCH/TEST_DEV vars when referring to overlay based dir.

An upcoming change is going to support mount/umount of base fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/config | 52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 common/rc     | 20 +++++++++++---------
 2 files changed, 62 insertions(+), 10 deletions(-)

diff --git a/common/config b/common/config
index 0706aca..db5721c 100644
--- a/common/config
+++ b/common/config
@@ -35,6 +35,8 @@
 # RMT_TAPE_DEV -    the remote tape device for the xfsdump tests
 # RMT_IRIXTAPE_DEV- the IRIX remote tape device for the xfsdump tests
 # RMT_TAPE_USER -   remote user for tape device
+# TEST_BASE_MNT -   mount point for base fs of overlay test dirs
+# SCRATCH_BASE_MNT- mount point for base fs of overlay scratch dirs
 #
 # - These can be added to $HOST_CONFIG_DIR (witch default to ./config)
 #   below or a separate local configuration file can be used (using
@@ -77,6 +79,9 @@ export XFS_MKFS_OPTIONS=${XFS_MKFS_OPTIONS:=-bsize=4096}
 export TIME_FACTOR=${TIME_FACTOR:=1}
 export LOAD_FACTOR=${LOAD_FACTOR:=1}
 export DEBUGFS_MNT=${DEBUGFS_MNT:="/sys/kernel/debug"}
+# directory inside TEST/SCRATCH_BASE_MNT where overlay dirs are created
+export OVERLAY_BASE_DIR=${OVERLAY_BASE_DIR:="ovl"}
+# directories created inside TEST/SCRATCH_BASE_DIR
 export OVERLAY_UPPER_DIR=${OVERLAY_UPPER_DIR:="upper"}
 export OVERLAY_LOWER_DIR=${OVERLAY_LOWER_DIR:="lower"}
 export OVERLAY_WORK_DIR=${OVERLAY_WORK_DIR:="work"}
@@ -443,7 +448,7 @@ _check_device()
 	echo $dev | grep -qE ":|//" > /dev/null 2>&1
 	network_dev=$?
 	if [ "$FSTYP" == "overlay" ]; then
-		if [ ! -d "$dev" ]; then
+		if [ -z "$TEST_BASE_MNT" -a ! -d "$dev" ]; then
 			_fatal "common/config: $name ($dev) is not a directory for overlay"
 		fi
 	elif [ ! -b "$dev" -a "$network_dev" != "0" ]; then
@@ -451,6 +456,46 @@ _check_device()
 	fi
 }
 
+# Set SCRATCH/TEST_BASE_DIR either from legacy TEST/SCRATCH_DEV
+# Or by deriving them from base fs if SCRATCH/TEST_BASE_MNT are defined.
+# Tests should always use SCRATCH/TEST_BASE_DIR when referering to
+# overlay base dir explicitly.
+_config_overlay()
+{
+	# There are 2 options for testing overlayfs:
+	#
+	# 1. (legacy) set SCRATCH/TEST_DEV to existing directories
+	#    on an already mounted fs.
+	#
+	[ -z "$TEST_DEV" ] || export TEST_BASE_DIR="$TEST_DEV"
+	[ -z "$SCRATCH_DEV" ] || export SCRATCH_BASE_DIR="$SCRATCH_DEV"
+
+	# 2. set SCRATCH/TEST_BASE_MNT to configure base fs.
+	#    SCRATCH/TEST_DEV are derived from SCRATCH/TEST_BASE_MNT
+	#    and therein, overlay fs directories will be created.
+	[ -n "$TEST_BASE_MNT" ] || return
+
+	if [ ! -d "$TEST_BASE_MNT" ]; then
+		echo "common/config: Error: \$TEST_BASE_MNT ($TEST_BASE_MNT) is not a directory"
+		exit 1
+	fi
+
+	export TEST_BASE_DIR="$TEST_BASE_MNT/$OVERLAY_BASE_DIR"
+	# Set TEST_DEV to base dir to satisfy common helpers
+	export TEST_DEV="$TEST_BASE_DIR"
+
+	[ -n "$SCRATCH_BASE_MNT" ] || return
+
+	if [ ! -d "$SCRATCH_BASE_MNT" ]; then
+		echo "common/config: Error: \$SCRATCH_BASE_MNT ($SCRATCH_BASE_MNT) is not a directory"
+		exit 1
+	fi
+
+	export SCRATCH_BASE_DIR="$SCRATCH_BASE_MNT/$OVERLAY_BASE_DIR"
+	# Set SCRATCH_DEV to base dir to satisfy common helpers
+	export SCRATCH_DEV="$SCRATCH_BASE_DIR"
+}
+
 # Parse config section options. This function will parse all the configuration
 # within a single section which name is passed as an argument. For section
 # name format see comments in get_config_sections().
@@ -525,6 +570,11 @@ get_next_config() {
 		export RESULT_BASE="$here/results/"
 	fi
 
+	# Maybe derive TEST_DEV from TEST_BASE_MNT
+	if [ "$FSTYP" == "overlay" ]; then
+		_config_overlay
+	fi
+
 	#  Mandatory Config values.
 	MC=""
 	[ -z "$EMAIL" ]          && MC="$MC EMAIL"
diff --git a/common/rc b/common/rc
index 862bc04..f5ab869 100644
--- a/common/rc
+++ b/common/rc
@@ -257,7 +257,7 @@ _scratch_mount_options()
 	_scratch_options mount
 
 	if [ "$FSTYP" == "overlay" ]; then
-		echo `_overlay_mount_options $SCRATCH_DEV`
+		echo `_overlay_mount_options $SCRATCH_BASE_DIR`
 		return 0
 	fi
 	echo `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
@@ -322,12 +322,12 @@ _overlay_mount()
 
 _overlay_test_mount()
 {
-	_overlay_mount $TEST_DEV $TEST_DIR $*
+	_overlay_mount $TEST_BASE_DIR $TEST_DIR $*
 }
 
 _overlay_scratch_mount()
 {
-	_overlay_mount $SCRATCH_DEV $SCRATCH_MNT $*
+	_overlay_mount $SCRATCH_BASE_DIR $SCRATCH_MNT $*
 }
 
 _overlay_test_unmount()
@@ -641,10 +641,12 @@ _scratch_cleanup_files()
 {
 	case $FSTYP in
 	overlay)
-		# $SCRATCH_DEV is a valid directory in overlay case
-		rm -rf $SCRATCH_DEV/*
+		# Avoid rm -rf /* if we messed up
+		[ -n "$SCRATCH_BASE_DIR" ] || return
+		rm -rf $SCRATCH_BASE_DIR/*
 		;;
 	*)
+		[ -n "$SCRATCH_MNT" ] || return
 		_scratch_mount
 		rm -rf $SCRATCH_MNT/*
 		_scratch_unmount
@@ -1343,8 +1345,8 @@ _require_scratch_nocheck()
 		fi
 		;;
 	overlay)
-		if [ -z "$SCRATCH_DEV" -o ! -d "$SCRATCH_DEV" ]; then
-			_notrun "this test requires a valid \$SCRATCH_DEV as ovl base dir"
+		if [ -z "$SCRATCH_BASE_DIR" -o ! -d "$SCRATCH_BASE_DIR" ]; then
+			_notrun "this test requires a valid \$SCRATCH_BASE_DIR as ovl base dir"
 		fi
 		if [ ! -d "$SCRATCH_MNT" ]; then
 			_notrun "this test requires a valid \$SCRATCH_MNT"
@@ -1428,8 +1430,8 @@ _require_test()
 		fi
 		;;
 	overlay)
-		if [ -z "$TEST_DEV" -o ! -d "$TEST_DEV" ]; then
-			_notrun "this test requires a valid \$TEST_DEV as ovl base dir"
+		if [ -z "$TEST_BASE_DIR" -o ! -d "$TEST_BASE_DIR" ]; then
+			_notrun "this test requires a valid \$TEST_BASE_DIR as ovl base dir"
 		fi
 		if [ ! -d "$TEST_DIR" ]; then
 			_notrun "this test requires a valid \$TEST_DIR"
-- 
2.7.4

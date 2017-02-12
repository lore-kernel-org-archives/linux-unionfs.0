From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 6/9] overlay: configure TEST/SCRATCH vars to base fs
Date: Sun, 12 Feb 2017 22:43:41 +0200
Message-ID: <1486932224-17075-7-git-send-email-amir73il@gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34259 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdBLUoD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 12 Feb 2017 15:44:03 -0500
In-Reply-To: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Instead of setting the vars TEST/SCRATCH_DEV to overlay base dirs,
allow setting them to block devices to configure the base fs partition,
where overlay dirs will be created.

For example, the following config file can be used to run tests on
xfs test/scratch partitions:

 TEST_DEV=/dev/sda5
 TEST_DIR=/mnt/test
 SCRATCH_DEV=/dev/sda6
 SCRATCH_MNT=/mnt/scratch
 FSTYP=xfs

Using the same config file, but executing './check -overlay' will
use the same partitions as base fs for overlayfs directories
and set TEST_DIR/SCRATCH_MNT values to overlay mount points, i.e.:
/mnt/test/ovl-mnt and /mnt/scratch/ovl-mnt.

The base fs should be pre-formatted and mounted when starting the test.
An upcoming change is going to support mount/umount of base fs.

The new OVL_BASE_SCRATCH/TEST_* vars are set to point at the
overlayfs base dirs in either legacy or new config method.
Tests should always use these vars and not the legacy SCRATCH/TEST_DEV
vars when referring to overlay base dir.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 README        | 16 ++++++-----
 check         |  2 +-
 common/config | 85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 common/rc     | 23 +++++++++-------
 4 files changed, 105 insertions(+), 21 deletions(-)

diff --git a/README b/README
index bb42985..842e835 100644
--- a/README
+++ b/README
@@ -117,16 +117,18 @@ Running tests:
     - By default the tests suite will run xfs tests:
     - ./check '*/001' '*/002' '*/003'
     - ./check '*/06?'
-    - You can explicitly specify NFS/CIFS/UDF, otherwise the filesystem type will
-      be autodetected from $TEST_DEV:
-      ./check -nfs [test(s)]
     - Groups of tests maybe ran by: ./check -g [group(s)]
       See the 'group' file for details on groups
-    - for udf tests: ./check -udf [test(s)]
-      Running all the udf tests: ./check -udf -g udf
-    - for running nfs tests: ./check -nfs [test(s)]
-    - for running cifs/smb3 tests: ./check -cifs [test(s)]
     - To randomize test order: ./check -r [test(s)]
+    - You can explicitly specify NFS/CIFS/UDF/OVERLAY, otherwise
+      the filesystem type will be autodetected from $TEST_DEV:
+        - for running nfs tests: ./check -nfs [test(s)]
+        - for running cifs/smb3 tests: ./check -cifs [test(s)]
+        - for udf tests: ./check -udf [test(s)]
+          Running all the udf tests: ./check -udf -g udf
+        - for overlay tests: ./check -overlay [test(s)]
+          The TEST and SCRATCH partitions should be pre-formatted
+          with another base fs, where the overlay dirs will be created
 
     
     The check script tests the return value of each script, and
diff --git a/check b/check
index ec9798a..c51fc0c 100755
--- a/check
+++ b/check
@@ -258,7 +258,7 @@ while [ $# -gt 0 ]; do
 
 	-nfs)		FSTYP=nfs ;;
 	-cifs)		FSTYP=cifs ;;
-	-overlay)	FSTYP=overlay ;;
+	-overlay)	FSTYP=overlay; export OVERLAY=true ;;
 	-tmpfs)		FSTYP=tmpfs ;;
 
 	-g)	group=$2 ; shift ;
diff --git a/common/config b/common/config
index a7ab2d9..5d90138 100644
--- a/common/config
+++ b/common/config
@@ -82,6 +82,8 @@ export DEBUGFS_MNT=${DEBUGFS_MNT:="/sys/kernel/debug"}
 export OVL_UPPER="ovl-upper"
 export OVL_LOWER="ovl-lower"
 export OVL_WORK="ovl-work"
+# overlay mount point parent must be the base fs root
+export OVL_MNT="ovl-mnt"
 
 export PWD=`pwd`
 #export DEBUG=${DEBUG:=...} # arbitrary CFLAGS really.
@@ -462,12 +464,68 @@ _canonicalize_mountpoint()
 	local name=$1
 	local dir=$2
 
-	if [ ! -d "$dir" ]; then
+	if [ -d "$dir" ]; then
+		# this follows symlinks and removes all trailing "/"s
+		readlink -e "$dir"
+		return 0
+	fi
+
+	if [ "$FSTYP" != "overlay" ] || [[ "$name" == OVL_BASE_* ]]; then
 		_fatal "common/config: $name ($dir) is not a directory"
 	fi
 
-	# this follows symlinks and removes all trailing "/"s
-	readlink -e "$dir"
+	# base fs may not be mounted yet, so just check that parent dir
+	# exists (where base fs will be mounted) because we are going to
+	# mkdir the overlay mount point dir anyway
+	local base=`basename $dir`
+	local parent=`dirname $dir`
+	local parent=`_canonicalize_mountpoint OVL_BASE_$name "$parent"`
+
+	# prepend the overlay mount point to canonical parent path
+	echo "$parent/$base"
+}
+
+_config_overlay()
+{
+	# There are 2 options for configuring overlayfs tests:
+	#
+	# 1. (legacy) SCRATCH/TEST_DEV point to existing directories
+	#    on an already mounted fs.  In this case, the new
+	#    OVL_BASE_SCRATCH/TEST_* vars are set to use the legacy
+	#    vars values (even though they may not be mount points).
+	#
+	[ ! -d "$TEST_DEV" ] || export OVL_BASE_TEST_DIR="$TEST_DEV"
+	[ ! -d "$SCRATCH_DEV" ] || export OVL_BASE_SCRATCH_MNT="$SCRATCH_DEV"
+
+	# 2. SCRATCH/TEST_DEV point to the base fs partitions.  In this case,
+	#    the new OVL_BASE_SCRATCH/TEST_DEV/MNT vars are set to the values
+	#    of the configured base fs and SCRATCH/TEST_DEV vars are set to the
+	#    overlayfs base and mount dirs inside base fs mount.
+	[ -b "$TEST_DEV" ] || return 0
+
+	# Config file may specify base fs type, but we obay -overlay flag
+	export OVL_BASE_FSTYP="$FSTYP"
+	export FSTYP=overlay
+
+	# Store original base fs vars
+	export OVL_BASE_TEST_DEV="$TEST_DEV"
+	export OVL_BASE_TEST_DIR=`_canonicalize_mountpoint OVL_BASE_TEST_DIR $TEST_DIR`
+	export OVL_BASE_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+
+	# Set TEST vars to overlay base and mount dirs inside base fs
+	export TEST_DEV="$OVL_BASE_TEST_DIR"
+	export TEST_DIR="$OVL_BASE_TEST_DIR/$OVL_MNT"
+	export MOUNT_OPTIONS="$OVERLAY_MOUNT_OPTIONS"
+
+	[ -b "$SCRATCH_DEV" ] || return 0
+
+	# Store original base fs vars
+	export OVL_BASE_SCRATCH_DEV="$SCRATCH_DEV"
+	export OVL_BASE_SCRATCH_MNT=`_canonicalize_mountpoint OVL_BASE_SCRATCH_MNT $SCRATCH_MNT`
+
+	# Set SCRATCH vars to overlay base and mount dirs inside base fs
+	export SCRATCH_DEV="$OVL_BASE_SCRATCH_MNT"
+	export SCRATCH_MNT="$OVL_BASE_SCRATCH_MNT/$OVL_MNT"
 }
 
 # Parse config section options. This function will parse all the configuration
@@ -516,6 +574,15 @@ get_next_config() {
 		unset SCRATCH_DEV
 	fi
 
+	# We might have overriden TEST/SCRATCH vars with overlay base dir in the
+	# previous run, so restore them to original values stored in OVL_BASE_*
+	if [ "$FSTYP" == "overlay" ]; then
+		[ -z "$OVL_BASE_TEST_DEV" ] || export TEST_DEV=$OVL_BASE_TEST_DEV
+		[ -z "$OVL_BASE_TEST_DIR" ] || export TEST_DIR=$OVL_BASE_TEST_DIR
+		[ -z "$OVL_BASE_SCRATCH_DEV" ] || export SCRATCH_DEV=$OVL_BASE_SCRATCH_DEV
+		[ -z "$OVL_BASE_SCRATCH_MNT" ] || export SCRATCH_MNT=$OVL_BASE_SCRATCH_MNT
+	fi
+
 	parse_config_section $1
 
 	if [ ! -z "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
@@ -544,6 +611,12 @@ get_next_config() {
 		export RESULT_BASE="$here/results/"
 	fi
 
+	# Override FSTYP from config when running ./check -overlay
+	# and maybe derive overlay TEST/SCRATCH from base fs values
+	if [ "$OVERLAY" == "true" -o "$FSTYP" == "overlay" ]; then
+		_config_overlay
+	fi
+
 	#  Mandatory Config values.
 	MC=""
 	[ -z "$EMAIL" ]          && MC="$MC EMAIL"
@@ -601,6 +674,12 @@ if [ -z "$CONFIG_INCLUDED" ]; then
 	[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
 	[ -z "$FSCK_OPTIONS" ] && _fsck_opts
 else
+	# Override FSTYP from config when running ./check -overlay
+	# and maybe derive overlay TEST/SCRATCH from base fs values
+	if [ "$OVERLAY" == "true" -o "$FSTYP" == "overlay" ]; then
+		_config_overlay
+	fi
+
 	# canonicalize the mount points
 	# this follows symlinks and removes all trailing "/"s
 	export TEST_DIR=`_canonicalize_mountpoint TEST_DIR $TEST_DIR`
diff --git a/common/rc b/common/rc
index 4e0cbdf..74168ea 100644
--- a/common/rc
+++ b/common/rc
@@ -257,7 +257,7 @@ _scratch_mount_options()
 	_scratch_options mount
 
 	if [ "$FSTYP" == "overlay" ]; then
-		echo `_overlay_mount_options $SCRATCH_DEV`
+		echo `_overlay_mount_options $OVL_BASE_SCRATCH_MNT`
 		return 0
 	fi
 	echo `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
@@ -308,9 +308,10 @@ _overlay_mkdirs()
 	mkdir -p $dir/$OVL_UPPER
 	mkdir -p $dir/$OVL_LOWER
 	mkdir -p $dir/$OVL_WORK
+	mkdir -p $dir/$OVL_MNT
 }
 
-# Given a dir, set up 3 subdirectories and mount on the given mnt.
+# Given a base fs dir, set up overlay directories and mount on the given mnt.
 # The dir is used as the mount device so it can be seen from df or mount
 _overlay_mount()
 {
@@ -329,12 +330,12 @@ _overlay_mount()
 
 _overlay_test_mount()
 {
-	_overlay_mount $TEST_DEV $TEST_DIR $*
+	_overlay_mount $OVL_BASE_TEST_DIR $TEST_DIR $*
 }
 
 _overlay_scratch_mount()
 {
-	_overlay_mount $SCRATCH_DEV $SCRATCH_MNT $*
+	_overlay_mount $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
 }
 
 _overlay_test_unmount()
@@ -649,10 +650,12 @@ _scratch_cleanup_files()
 {
 	case $FSTYP in
 	overlay)
-		# $SCRATCH_DEV is a valid directory in overlay case
-		rm -rf $SCRATCH_DEV/*
+		# Avoid rm -rf /* if we messed up
+		[ -n "$OVL_BASE_SCRATCH_MNT" ] || return 1
+		rm -rf $OVL_BASE_SCRATCH_MNT/*
 		;;
 	*)
+		[ -n "$SCRATCH_MNT" ] || return 1
 		_scratch_mount
 		rm -rf $SCRATCH_MNT/*
 		_scratch_unmount
@@ -1390,8 +1393,8 @@ _require_scratch_nocheck()
 		fi
 		;;
 	overlay)
-		if [ -z "$SCRATCH_DEV" -o ! -d "$SCRATCH_DEV" ]; then
-			_notrun "this test requires a valid \$SCRATCH_DEV as ovl base dir"
+		if [ -z "$OVL_BASE_SCRATCH_MNT" -o ! -d "$OVL_BASE_SCRATCH_MNT" ]; then
+			_notrun "this test requires a valid \$SCRATCH_MNT as ovl base dir"
 		fi
 		if [ ! -d "$SCRATCH_MNT" ]; then
 			_notrun "this test requires a valid \$SCRATCH_MNT"
@@ -1463,8 +1466,8 @@ _require_test()
 		fi
 		;;
 	overlay)
-		if [ -z "$TEST_DEV" -o ! -d "$TEST_DEV" ]; then
-			_notrun "this test requires a valid \$TEST_DEV as ovl base dir"
+		if [ -z "$OVL_BASE_TEST_DIR" -o ! -d "$OVL_BASE_TEST_DIR" ]; then
+			_notrun "this test requires a valid \$TEST_DIR as ovl base dir"
 		fi
 		if [ ! -d "$TEST_DIR" ]; then
 			_notrun "this test requires a valid \$TEST_DIR"
-- 
2.7.4

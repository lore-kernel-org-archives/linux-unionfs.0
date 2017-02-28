From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v5 08/10] overlay: configure TEST/SCRATCH vars to base fs
Date: Tue, 28 Feb 2017 14:18:35 +0200
Message-ID: <1488284317-3119-9-git-send-email-amir73il@gmail.com>
References: <1488284317-3119-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1488284317-3119-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

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

The new vars OVL_BASE_SCRATCH_MNT/TEST_DIR are set to point at the
overlayfs base dirs in either legacy or new config method.
Tests should always use these vars and not the legacy SCRATCH/TEST_DEV
vars when referring to overlay base dir.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 README         |  16 ++++----
 README.overlay |  18 +++++++++
 check          |   2 +-
 common/config  | 124 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 common/rc      |  28 ++++++++-----
 5 files changed, 162 insertions(+), 26 deletions(-)
 create mode 100644 README.overlay

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
diff --git a/README.overlay b/README.overlay
new file mode 100644
index 0000000..647f9ea
--- /dev/null
+++ b/README.overlay
@@ -0,0 +1,18 @@
+
+To run xfstest on overlayfs, configure the variables of TEST and SCRATCH
+partitions to be used as the "base fs" and run './check -overlay'.
+
+For example, the following config file can be used to run tests on
+xfs test/scratch partitions:
+
+ TEST_DEV=/dev/sda5
+ TEST_DIR=/mnt/test
+ SCRATCH_DEV=/dev/sda6
+ SCRATCH_MNT=/mnt/scratch
+ FSTYP=xfs
+
+Using the same config file, but executing './check -overlay' will
+use the same partitions as base fs for overlayfs directories
+and set TEST_DIR/SCRATCH_MNT values to overlay mount points, i.e.:
+/mnt/test/ovl-mnt and /mnt/scratch/ovl-mnt, for the context of
+individual tests.
diff --git a/check b/check
index fbd12e9..66a349a 100755
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
index d09cac1..37b0189 100644
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
@@ -443,16 +445,19 @@ _check_device()
 		if [ "$dev_needed" == "required" ]; then
 			_fatal "common/config: $name is required but not defined!"
 		fi
-		return
+		return 0
+	fi
+
+	if [ -b "$dev" ] || ( echo $dev | grep -qE ":|//" ); then
+		# block device or a network url
+		return 0
 	fi
 
-	echo $dev | grep -qE ":|//" > /dev/null 2>&1
-	network_dev=$?
 	if [ "$FSTYP" == "overlay" ]; then
 		if [ ! -d "$dev" ]; then
 			_fatal "common/config: $name ($dev) is not a directory for overlay"
 		fi
-	elif [ ! -b "$dev" -a "$network_dev" != "0" ]; then
+	else
 		_fatal "common/config: $name ($dev) is not a block device or a network filesystem"
 	fi
 }
@@ -463,12 +468,89 @@ _canonicalize_mountpoint()
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
+	parent=`_canonicalize_mountpoint OVL_BASE_$name "$parent"`
+
+	# prepend the overlay mount point to canonical parent path
+	echo "$parent/$base"
+}
+
+# On check -overlay, for the non multi section config case, this
+# function is called on every test, before init_rc().
+# When SCRATCH/TEST_* vars are defined in config file, config file
+# is sourced on every test and this function overrides the vars
+# every time.
+# When SCRATCH/TEST_* vars are defined in evironment and not
+# in config file, this function is called after vars have already
+# been overriden in the previous test.
+# In that case, TEST_DEV is a directory and not a blockdev and
+# the function will return without overriding the SCRATCH/TEST_* vars.
+_overlay_config_override()
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
+	export OVL_BASE_TEST_DIR="$TEST_DIR"
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
+	export OVL_BASE_SCRATCH_MNT="$SCRATCH_MNT"
+
+	# Set SCRATCH vars to overlay base and mount dirs inside base fs
+	export SCRATCH_DEV="$OVL_BASE_SCRATCH_MNT"
+	export SCRATCH_MNT="$OVL_BASE_SCRATCH_MNT/$OVL_MNT"
+}
+
+_overlay_config_restore()
+{
+	export OVERLAY=true
+	[ -z "$OVL_BASE_FSTYP" ] || export FSTYP=$OVL_BASE_FSTYP
+	[ -z "$OVL_BASE_TEST_DEV" ] || export TEST_DEV=$OVL_BASE_TEST_DEV
+	[ -z "$OVL_BASE_TEST_DIR" ] || export TEST_DIR=$OVL_BASE_TEST_DIR
+	[ -z "$OVL_BASE_SCRATCH_DEV" ] || export SCRATCH_DEV=$OVL_BASE_SCRATCH_DEV
+	[ -z "$OVL_BASE_SCRATCH_MNT" ] || export SCRATCH_MNT=$OVL_BASE_SCRATCH_MNT
+	[ -z "$OVL_BASE_MOUNT_OPTIONS" ] || export MOUNT_OPTIONS=$OVL_BASE_MOUNT_OPTIONS
 }
 
 # Parse config section options. This function will parse all the configuration
@@ -499,6 +581,15 @@ get_next_config() {
 		return 0
 	fi
 
+	# We might have overriden FSTYP and TEST/SCRATCH vars with overlay values
+	# in the previous section, so restore them to original values stored in
+	# OVL_BASE_*.
+	# We need to do this *before* old FSTYP and MOUNT_OPTIONS are recorded
+	# and *before* SCRATCH_DEV and MOUNT_OPTIONS are unset
+	if [ "$FSTYP" == "overlay" ]; then
+		_overlay_config_restore
+	fi
+
 	local OLD_FSTYP=$FSTYP
 	local OLD_MOUNT_OPTIONS=$MOUNT_OPTIONS
 	local OLD_TEST_FS_MOUNT_OPTS=$TEST_FS_MOUNT_OPTS
@@ -582,6 +673,14 @@ get_next_config() {
 		_check_device SCRATCH_RTDEV optional $SCRATCH_RTDEV
 		_check_device SCRATCH_LOGDEV optional $SCRATCH_LOGDEV
 	fi
+
+	# Override FSTYP from config when running ./check -overlay
+	# and maybe override base fs TEST/SCRATCH_DEV with overlay base dirs.
+	# We need to do this *after* default mount options are set by base FSTYP
+	# and *after* SCRATCH_DEV is deduced from SCRATCH_DEV_POOL
+	if [ "$OVERLAY" == "true" -o "$FSTYP" == "overlay" ]; then
+		_overlay_config_override
+	fi
 }
 
 if [ -z "$CONFIG_INCLUDED" ]; then
@@ -602,10 +701,21 @@ if [ -z "$CONFIG_INCLUDED" ]; then
 	[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
 	[ -z "$FSCK_OPTIONS" ] && _fsck_opts
 else
+	# We get here for the non multi section case, on every test that sources
+	# common/rc after re-sourcing the HOST_OPTIONS config file.
+	# Because of this re-sourcing, we need to re-canonicalize the configured
+	# mount points and re-override TEST/SCRATCH_DEV overlay vars.
+
 	# canonicalize the mount points
 	# this follows symlinks and removes all trailing "/"s
 	export TEST_DIR=`_canonicalize_mountpoint TEST_DIR $TEST_DIR`
 	export SCRATCH_MNT=`_canonicalize_mountpoint SCRATCH_MNT $SCRATCH_MNT`
+
+	# Override FSTYP from config when running ./check -overlay
+	# and maybe override base fs TEST/SCRATCH_DEV with overlay base dirs
+	if [ "$OVERLAY" == "true" -o "$FSTYP" == "overlay" ]; then
+		_overlay_config_override
+	fi
 fi
 
 # make sure this script returns success
diff --git a/common/rc b/common/rc
index cca046b..fa4ca5e 100644
--- a/common/rc
+++ b/common/rc
@@ -292,7 +292,7 @@ _scratch_mount_options()
 	_scratch_options mount
 
 	if [ "$FSTYP" == "overlay" ]; then
-		echo `_overlay_mount_options $SCRATCH_DEV`
+		echo `_overlay_mount_options $OVL_BASE_SCRATCH_MNT`
 		return 0
 	fi
 	echo `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
@@ -343,9 +343,10 @@ _overlay_mkdirs()
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
@@ -364,12 +365,12 @@ _overlay_mount()
 
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
@@ -684,10 +685,12 @@ _scratch_cleanup_files()
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
@@ -1425,10 +1428,13 @@ _require_scratch_nocheck()
 		fi
 		;;
 	overlay)
-		if [ -z "$SCRATCH_DEV" -o ! -d "$SCRATCH_DEV" ]; then
-			_notrun "this test requires a valid \$SCRATCH_DEV as ovl base dir"
+		if [ -z "$OVL_BASE_SCRATCH_MNT" -o ! -d "$OVL_BASE_SCRATCH_MNT" ]; then
+			_notrun "this test requires a valid \$OVL_BASE_SCRATCH_MNT as ovl base dir"
 		fi
-		if [ ! -d "$SCRATCH_MNT" ]; then
+		# if $SCRATCH_MNT is derived from $OVL_BASE_SCRATCH_MNT then
+		# don't check $SCRATCH_MNT dir here because base fs may not be mounted
+		# and we will create the mount point anyway on _overlay_mount
+		if [ "$SCRATCH_MNT" != "$OVL_BASE_SCRATCH_MNT/$OVL_MNT" -a ! -d "$SCRATCH_MNT" ]; then
 			_notrun "this test requires a valid \$SCRATCH_MNT"
 		fi
 		;;
@@ -1501,8 +1507,8 @@ _require_test()
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

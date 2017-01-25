From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH] common: mount overlay base fs for running tests
Date: Wed, 25 Jan 2017 08:51:24 +0200
Message-ID: <1485327084-26190-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36021 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751286AbdAYGvi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Jan 2017 01:51:38 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Instead of setting the fake TEST/SCRATCH_DEV vars to existing overlay
directories, allow setting the vars OVERLAY_BASE_DEV/MNT, to configure
the base fs where overlay directories are created. For example:

-export TEST_DEV=/mnt/xfs/ovl/test
-export SCRATCH_DEV=/mnt/xfs/ovl/scratch
+export OVERLAY_BASE_DEV=/dev/mapper/test-xfs
+export OVERLAY_BASE_MNT=/mnt/xfs
export TEST_DIR=/mnt/test
export SCRATCH_MNT=/mnt/scratch
export FSTYP=overlay

With this change, the base fs is mounted before running the tests
unmounted after running the tests and recycled on _test_cycle_mount.
This helps catching overlayfs bugs related to leaking objects in
underlying (base) fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/config | 35 ++++++++++++++++++++++++++++++++++-
 common/rc     |  8 ++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

Eryu,

I was planning to also support _test_mkfs for base fs (as kvm-xfstests does),
but decided to make a RFC rest stop after _test_mount, which seems useful in
its own right.

The main point to consider is whether it is worth separating OVERLAY_BASE_DEV
to test and scratch base devices. This patch (with shared dev) is much simpler
to configure to I am sending it out to see if folk think it is sufficiently
useful as is.

The limitation of keepong this patch as is, is not being able to recycle base fs
on _scratch_mount/umount/recycle and not being able to mkfs base fs on _scratch_mkfs.

Thought?

Amir.

diff --git a/common/config b/common/config
index 0706aca..d63c22a 100644
--- a/common/config
+++ b/common/config
@@ -35,6 +35,8 @@
 # RMT_TAPE_DEV -    the remote tape device for the xfsdump tests
 # RMT_IRIXTAPE_DEV- the IRIX remote tape device for the xfsdump tests
 # RMT_TAPE_USER -   remote user for tape device
+# OVERLAY_BASE_DEV- device for base fs containing overlay directories
+# OVERLAY_BASE_MNT- mount point for base fs of overlay directories
 #
 # - These can be added to $HOST_CONFIG_DIR (witch default to ./config)
 #   below or a separate local configuration file can be used (using
@@ -77,6 +79,9 @@ export XFS_MKFS_OPTIONS=${XFS_MKFS_OPTIONS:=-bsize=4096}
 export TIME_FACTOR=${TIME_FACTOR:=1}
 export LOAD_FACTOR=${LOAD_FACTOR:=1}
 export DEBUGFS_MNT=${DEBUGFS_MNT:="/sys/kernel/debug"}
+# directory inside $OVERLAY_BASE_MNT where TEST/SCRATCH_DEV dirs are created
+export OVERLAY_BASE_DIR=${OVERLAY_BASE_DIR:="ovl"}
+# directories created inside TEST/SCRATCH_DEV
 export OVERLAY_UPPER_DIR=${OVERLAY_UPPER_DIR:="upper"}
 export OVERLAY_LOWER_DIR=${OVERLAY_LOWER_DIR:="lower"}
 export OVERLAY_WORK_DIR=${OVERLAY_WORK_DIR:="work"}
@@ -443,7 +448,7 @@ _check_device()
 	echo $dev | grep -qE ":|//" > /dev/null 2>&1
 	network_dev=$?
 	if [ "$FSTYP" == "overlay" ]; then
-		if [ ! -d "$dev" ]; then
+		if [ -z "$OVERLAY_BASE_MNT" -a ! -d "$dev" ]; then
 			_fatal "common/config: $name ($dev) is not a directory for overlay"
 		fi
 	elif [ ! -b "$dev" -a "$network_dev" != "0" ]; then
@@ -451,6 +456,29 @@ _check_device()
 	fi
 }
 
+# Derive TEST/SCRATCH_DEV from base fs if OVERLAY_BASE_MNT is defined
+_config_overlay()
+{
+	# There are 2 options for testing overlayfs:
+	#
+	# 1. (legacy) set SCRATCH/TEST_DEV to existing directories
+	#    on an already mounted fs.
+	#
+	# 2. set OVERLAY_BASE_DEV/MNT to configure base fs.
+	#    SCRATCH/TEST_DEV are derived from OVERLAY_BASE_MNT and therein,
+	#    overlay fs directories will be created.
+	[ -n "$OVERLAY_BASE_MNT" ] || return
+
+	_check_device OVERLAY_BASE_DEV required $OVERLAY_BASE_DEV
+	if [ ! -d "$OVERLAY_BASE_MNT" ]; then
+		echo "common/config: Error: \$OVERLAY_BASE_MNT ($OVERLAY_BASE_MNT) is not a directory"
+		exit 1
+	fi
+
+	export TEST_DEV="$OVERLAY_BASE_MNT/$OVERLAY_BASE_DIR/test"
+	export SCRATCH_DEV="$OVERLAY_BASE_MNT/$OVERLAY_BASE_DIR/scratch"
+}
+
 # Parse config section options. This function will parse all the configuration
 # within a single section which name is passed as an argument. For section
 # name format see comments in get_config_sections().
@@ -525,6 +553,11 @@ get_next_config() {
 		export RESULT_BASE="$here/results/"
 	fi
 
+	# Maybe derive TEST_DEV from OVERLAY_BASE_MNT
+	if [ "$FSTYP" == "overlay" ]; then
+		_config_overlay
+	fi
+
 	#  Mandatory Config values.
 	MC=""
 	[ -z "$EMAIL" ]          && MC="$MC EMAIL"
diff --git a/common/rc b/common/rc
index 862bc04..8c403e3 100644
--- a/common/rc
+++ b/common/rc
@@ -322,6 +322,11 @@ _overlay_mount()
 
 _overlay_test_mount()
 {
+	if [ -n "$OVERLAY_BASE_MNT" ]; then
+		_mount $OVERLAY_BASE_MOUNT_OPTIONS \
+			$SELINUX_MOUNT_OPTIONS \
+			$OVERLAY_BASE_DEV $OVERLAY_BASE_MNT
+	fi
 	_overlay_mount $TEST_DEV $TEST_DIR $*
 }
 
@@ -333,6 +338,9 @@ _overlay_scratch_mount()
 _overlay_test_unmount()
 {
 	$UMOUNT_PROG $TEST_DIR
+	if [ -n "$OVERLAY_BASE_MNT" ]; then
+		$UMOUNT_PROG $OVERLAY_BASE_MNT
+	fi
 }
 
 _overlay_scratch_unmount()
-- 
2.7.4

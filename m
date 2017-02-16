From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 09/10] overlay: mount/unmount base fs before/after running tests
Date: Thu, 16 Feb 2017 21:57:07 +0200
Message-ID: <1487275028-29885-10-git-send-email-amir73il@gmail.com>
References: <1487275028-29885-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35937 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933239AbdBPT5f (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Feb 2017 14:57:35 -0500
In-Reply-To: <1487275028-29885-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

When TEST/SCRATCH_DEV are configured to the base fs block device,
use this information to mount base fs before running tests,
unmount it after running tests and cycle on _test_cycle_mount
along with the overlay mounts.

This helps catching overlayfs bugs related to leaking objects in
underlying (base) fs.

To preserve expected tests behavior, the semantics are:
- _scratch_mkfs mounts the base fs, cleans all files, creates
  lower/upper dirs and keeps base fs mounted
- _scratch_mount mounts base fs (if needed) and mounts overlay
- _scratch_unmount unmounts overlay and base fs

Tests that use _scratch_unmount to unmount a custom overlay mount
and expect to have access to overlay base dir, were fixed to use
explicit umount $SCRATCH_MNT instead.

The overlay test itself, does not support formatting the base fs,
so config options like MKFS_OPTIONS and FSCK_OPTIONS are ignored
on 'check -overlay'.
The config option MOUNT_OPTIONS is used to mount the base scratch fs.
The config option TEST_FS_MOUNT_OPTS is used to mount the base test fs.
The config option OVERLAY_MOUNT_OPTIONS is used to mount both test and
scratch overlay mounts.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 README.overlay    | 28 +++++++++++++++++++++++
 common/rc         | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 tests/overlay/003 |  3 ++-
 tests/overlay/004 |  3 ++-
 tests/overlay/014 |  5 +++--
 5 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/README.overlay b/README.overlay
index 647f9ea..dfb8234 100644
--- a/README.overlay
+++ b/README.overlay
@@ -16,3 +16,31 @@ use the same partitions as base fs for overlayfs directories
 and set TEST_DIR/SCRATCH_MNT values to overlay mount points, i.e.:
 /mnt/test/ovl-mnt and /mnt/scratch/ovl-mnt, for the context of
 individual tests.
+
+'./check -overlay' does not support mkfs and fsck on the base fs, so
+the base fs should be pre-formatted before starting the -overlay run.
+An easy way to accomplish this is by running './check <some test>' once,
+before running './check -overlay'.
+
+Because of the lack of mkfs support, multi-section config files are only
+partly supported with './check -overlay'. Only multi-section files that
+do not change FSTYP and MKFS_OPTIONS can be safely used with -overlay.
+
+For example, the following multi-section config file can be used to
+run overlay tests on the same base fs, but with different mount options:
+
+ [xfs]
+ TEST_DEV=/dev/sda5
+ TEST_DIR=/mnt/test
+ SCRATCH_DEV=/dev/sda6
+ SCRATCH_MNT=/mnt/scratch
+ FSTYP=xfs
+
+ [xfs_pquota]
+ MOUNT_OPTIONS="-o pquota"
+ TEST_FS_MOUNT_OPTS="-o noatime"
+ OVERLAY_MOUNT_OPTIONS="-o redirect_dir=off"
+
+In the example above, MOUNT_OPTIONS will be used to mount the base scratch fs,
+TEST_FS_MOUNT_OPTS will be used to mount the base test fs and
+OVERLAY_MOUNT_OPTIONS will be used to mount both test and scratch overlays.
diff --git a/common/rc b/common/rc
index a545c69..a15a9f0 100644
--- a/common/rc
+++ b/common/rc
@@ -328,24 +328,80 @@ _overlay_mount()
 			    $SELINUX_MOUNT_OPTIONS $* $dir $mnt
 }
 
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
 _overlay_test_mount()
 {
-	_overlay_mount $OVL_BASE_TEST_DIR $TEST_DIR $*
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
 }
 
 _overlay_scratch_mount()
 {
-	_overlay_mount $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
+	_overlay_base_scratch_mount && \
+		_overlay_mount $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
+}
+
+_overlay_base_test_unmount()
+{
+	[ -n "$OVL_BASE_TEST_DEV" -a -n "$OVL_BASE_TEST_DIR" ] || return 0
+
+	$UMOUNT_PROG $OVL_BASE_TEST_DIR
 }
 
 _overlay_test_unmount()
 {
 	$UMOUNT_PROG $TEST_DIR
+	_overlay_base_test_unmount
 }
 
 _overlay_scratch_unmount()
 {
 	$UMOUNT_PROG $SCRATCH_MNT
+	_overlay_base_scratch_unmount
 }
 
 _scratch_mount()
@@ -652,7 +708,10 @@ _scratch_cleanup_files()
 	overlay)
 		# Avoid rm -rf /* if we messed up
 		[ -n "$OVL_BASE_SCRATCH_MNT" ] || return 1
-		rm -rf $OVL_BASE_SCRATCH_MNT/*
+		_overlay_base_scratch_mount || return 1
+		rm -rf $OVL_BASE_SCRATCH_MNT/* || return 1
+		_overlay_mkdirs $OVL_BASE_SCRATCH_MNT
+		# leave base fs mouted so tests can setup lower/upper dir files
 		;;
 	*)
 		[ -n "$SCRATCH_MNT" ] || return 1
@@ -675,7 +734,7 @@ _scratch_mkfs()
 		# $SCRATCH_MNT to avoid EEXIST caused by the leftover files
 		# created in previous runs
 		_scratch_cleanup_files
-		return 0
+		return $?
 		;;
 	tmpfs)
 		# do nothing for tmpfs
diff --git a/tests/overlay/003 b/tests/overlay/003
index 7c7f41b..f980edb 100755
--- a/tests/overlay/003
+++ b/tests/overlay/003
@@ -89,7 +89,8 @@ rm -rf ${SCRATCH_MNT}/*
 # nothing should be listed
 ls ${SCRATCH_MNT}/
 
-_scratch_unmount
+# unmount overlayfs but not base fs
+$UMOUNT_PROG $SCRATCH_MNT
 
 rm -rf $lowerdir
 echo "Silence is golden"
diff --git a/tests/overlay/004 b/tests/overlay/004
index bc08f34..611847a 100755
--- a/tests/overlay/004
+++ b/tests/overlay/004
@@ -85,7 +85,8 @@ _user_do "chmod g+t ${SCRATCH_MNT}/attr_file2 > /dev/null 2>&1"
 _user_do "chmod u-X ${SCRATCH_MNT}/attr_file2 > /dev/null 2>&1"
 stat -c %a ${SCRATCH_MNT}/attr_file2
 
-_scratch_unmount
+# unmount overlayfs but not base fs
+$UMOUNT_PROG $SCRATCH_MNT
 
 # check mode bits of the file that has been copied up, and
 # the file that should not have been copied up.
diff --git a/tests/overlay/014 b/tests/overlay/014
index 491f735..653b7d6 100755
--- a/tests/overlay/014
+++ b/tests/overlay/014
@@ -73,7 +73,8 @@ mkdir -p $lowerdir1/testdir/d
 _overlay_mount_dirs $lowerdir1 $lowerdir2 $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 rm -rf $SCRATCH_MNT/testdir
 mkdir -p $SCRATCH_MNT/testdir/visibledir
-_scratch_unmount
+# unmount overlayfs but not base fs
+$UMOUNT_PROG $SCRATCH_MNT
 
 # mount overlay again, with lowerdir1 and lowerdir2 as multiple lowerdirs,
 # and create a new file in testdir, triggers copyup from lowerdir,
@@ -84,7 +85,7 @@ touch $SCRATCH_MNT/testdir/visiblefile
 
 # umount and mount overlay again, buggy kernel treats the copied-up dir as
 # opaque, visibledir is not seen in merged dir.
-_scratch_unmount
+$UMOUNT_PROG $SCRATCH_MNT
 _overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
 		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 ls $SCRATCH_MNT/testdir
-- 
2.7.4

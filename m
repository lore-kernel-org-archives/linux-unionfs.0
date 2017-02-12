From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 9/9] overlay: mount/unmount base fs before/after running tests
Date: Sun, 12 Feb 2017 22:43:44 +0200
Message-ID: <1486932224-17075-10-git-send-email-amir73il@gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35003 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdBLUoI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 12 Feb 2017 15:44:08 -0500
In-Reply-To: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
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

The overlay test itself, does not support formatting the base fs.
However, it is possible to add overlay sections to a multi section
config file after every base fs configuration, to run the overlay
tests with the file system that was created on the test partitions
in the previous section (see example in README.config-sections).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 README.config-sections |  6 ++++++
 common/rc              | 55 ++++++++++++++++++++++++++++++++++++++++++++++++--
 tests/overlay/003      |  3 ++-
 tests/overlay/004      |  3 ++-
 tests/overlay/014      |  5 +++--
 5 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/README.config-sections b/README.config-sections
index df7c929..d45d6da 100644
--- a/README.config-sections
+++ b/README.config-sections
@@ -102,6 +102,9 @@ MKFS_OPTIONS="-q -F -b4096"
 FSTYP=ext4
 RESULT_BASE="`pwd`/results/`date +%d%m%y_%H%M%S`"
 
+[ext4_overlay]
+FSTYP=overlay
+
 [ext4_1k_block_size]
 MKFS_OPTIONS="-q -F -b1024"
 
@@ -112,6 +115,9 @@ MKFS_OPTIONS="-q -F -b4096 -O ^has_journal"
 MKFS_OPTIONS="-f"
 FSTYP=xfs
 
+[xfs_overlay]
+FSTYP=overlay
+
 [ext3_filesystem]
 FSTYP=ext3
 MOUNT_OPTIONS="-o noatime"
diff --git a/common/rc b/common/rc
index 74168ea..e9ac0df 100644
--- a/common/rc
+++ b/common/rc
@@ -328,24 +328,70 @@ _overlay_mount()
 			    $SELINUX_MOUNT_OPTIONS $* $dir $mnt
 }
 
+_overlay_base_test_mount()
+{
+	if [ -z "$OVL_BASE_TEST_DEV" -o -z "$OVL_BASE_TEST_DIR" ] || \
+		_check_mounted_on OVL_BASE_TEST_DEV $OVL_BASE_TEST_DEV \
+				OVL_BASE_TEST_DIR $OVL_BASE_TEST_DIR
+	then
+		return 0
+	fi
+
+	_mount $OVL_BASE_MOUNT_OPTIONS \
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
+		return 0
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
@@ -652,7 +698,12 @@ _scratch_cleanup_files()
 	overlay)
 		# Avoid rm -rf /* if we messed up
 		[ -n "$OVL_BASE_SCRATCH_MNT" ] || return 1
+		# overlay 'mkfs' needs to make sure base fs is mounted and clean
+		_overlay_base_scratch_unmount 2>/dev/null
+		_overlay_base_scratch_mount
 		rm -rf $OVL_BASE_SCRATCH_MNT/*
+		_overlay_mkdirs $OVL_BASE_SCRATCH_MNT
+		# leave base fs mouted so tests can setup lower/upper dir files
 		;;
 	*)
 		[ -n "$SCRATCH_MNT" ] || return 1
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

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/4] overlay: create helper _overlay_scratch_mount_dirs()
Date: Wed, 27 Sep 2017 10:04:11 +0300
Message-ID: <1506495852-7295-4-git-send-email-amir73il@gmail.com>
References: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36422 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdI0HDp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Sep 2017 03:03:45 -0400
In-Reply-To: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

A helper to mount with same options/mnt/dev of scratch mount, but
optionally with different lower/upper/work dirs.
use instead of _overlay_mount_dirs() in all tests where applicable.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc         | 13 +++++++++++++
 tests/overlay/005 |  2 +-
 tests/overlay/010 |  3 +--
 tests/overlay/014 |  8 +++-----
 tests/overlay/031 | 11 +++++------
 tests/overlay/035 |  3 +--
 tests/overlay/037 | 14 ++++++--------
 tests/overlay/038 |  3 +--
 8 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/common/rc b/common/rc
index b30c4b9..54f81d3 100644
--- a/common/rc
+++ b/common/rc
@@ -345,6 +345,19 @@ _overlay_mount_dirs()
 		    -o workdir=$workdir `_common_dev_mount_options $*`
 }
 
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
 _overlay_mkdirs()
 {
 	local dir=$1
diff --git a/tests/overlay/005 b/tests/overlay/005
index f885fdc..17992a3 100755
--- a/tests/overlay/005
+++ b/tests/overlay/005
@@ -93,7 +93,7 @@ $XFS_IO_PROG -f -c "truncate 48m" ${lowerd}/test_file \
 	>>$seqres.full 2>&1
 
 # mount new overlayfs
-_overlay_mount_dirs $lowerd $upperd $workd $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_scratch_mount_dirs $lowerd $upperd $workd
 
 # the open call triggers copy-up and it will fail ENOSPC
 $XFS_IO_PROG -f -c "o" ${SCRATCH_MNT}/test_file \
diff --git a/tests/overlay/010 b/tests/overlay/010
index dee99cf..f55ebec 100755
--- a/tests/overlay/010
+++ b/tests/overlay/010
@@ -67,8 +67,7 @@ touch $lowerdir1/testdir/a $lowerdir1/testdir/b
 mknod $lowerdir2/testdir/a c 0 0
 
 # Mount overlayfs and remove testdir, which led to kernel crash
-_overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
-		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_scratch_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
 rm -rf $SCRATCH_MNT/testdir
 
 # success, all done
diff --git a/tests/overlay/014 b/tests/overlay/014
index cd76835..9f308d3 100755
--- a/tests/overlay/014
+++ b/tests/overlay/014
@@ -72,7 +72,7 @@ mkdir -p $lowerdir1/testdir/d
 
 # mount overlay with $lowerdir2 as upperdir, and remove & recreate testdir,
 # make testdir on $lowerdir2 opaque
-_overlay_mount_dirs $lowerdir1 $lowerdir2 $workdir2 $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_scratch_mount_dirs $lowerdir1 $lowerdir2 $workdir2
 rm -rf $SCRATCH_MNT/testdir
 mkdir -p $SCRATCH_MNT/testdir/visibledir
 # unmount overlayfs but not base fs
@@ -81,15 +81,13 @@ $UMOUNT_PROG $SCRATCH_MNT
 # mount overlay again, with lowerdir1 and lowerdir2 as multiple lowerdirs,
 # and create a new file in testdir, triggers copyup from lowerdir,
 # copyup should not copy overlayfs private xattr
-_overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
-		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_scratch_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
 touch $SCRATCH_MNT/testdir/visiblefile
 
 # umount and mount overlay again, buggy kernel treats the copied-up dir as
 # opaque, visibledir is not seen in merged dir.
 $UMOUNT_PROG $SCRATCH_MNT
-_overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
-		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_scratch_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
 ls $SCRATCH_MNT/testdir
 
 # success, all done
diff --git a/tests/overlay/031 b/tests/overlay/031
index 70ee299..186b409 100755
--- a/tests/overlay/031
+++ b/tests/overlay/031
@@ -51,7 +51,7 @@ create_whiteout()
 	mkdir -p $lower/testdir
 	touch $lower/testdir/$file
 
-	_overlay_mount_dirs $lower $upper $work $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+	_overlay_scratch_mount_dirs $lower $upper $work
 
 	rm -f $SCRATCH_MNT/testdir/$file
 
@@ -91,7 +91,7 @@ create_whiteout $lowerdir1 $upperdir $workdir $testfile1
 # whiteout will expose.
 rm -rf $lowerdir1/testdir
 
-_overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_scratch_mount_dirs $lowerdir1 $upperdir $workdir
 
 ls $SCRATCH_MNT/testdir
 
@@ -104,7 +104,7 @@ rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
 $UMOUNT_PROG $SCRATCH_MNT
 touch $lowerdir1/testdir
 
-_overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_scratch_mount_dirs $lowerdir1 $upperdir $workdir
 
 # try to remove test dir from overlay dir, trigger ovl_remove_and_whiteout,
 # it will not clean up the dir and lead to residue.
@@ -121,8 +121,7 @@ create_whiteout $lowerdir2 $lowerdir1 $workdir1 $testfile1
 
 rm -rf $lowerdir2/testdir
 
-_overlay_mount_dirs "$lowerdir1:$lowerdir2" $upperdir $workdir \
-		     $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_scratch_mount_dirs "$lowerdir1:$lowerdir2" $upperdir $workdir
 
 ls $SCRATCH_MNT/testdir
 rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
@@ -139,7 +138,7 @@ rm -rf $lowerdir1/testdir/$testfile1
 
 create_whiteout $lowerdir2 $lowerdir1 $workdir1 $testfile2
 
-_overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_scratch_mount_dirs $lowerdir1 $upperdir $workdir
 
 ls $SCRATCH_MNT/testdir
 rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
diff --git a/tests/overlay/035 b/tests/overlay/035
index 0ef91c6..64fcd70 100755
--- a/tests/overlay/035
+++ b/tests/overlay/035
@@ -77,8 +77,7 @@ $CHATTR_PROG +i $workdir
 
 # Mount overlay with upper and workdir and expect failure to re-create workdir.
 # Verify that overlay is mounted read-only and that it cannot be remounted rw.
-_overlay_mount_dirs $lowerdir2 $upperdir $workdir \
-		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_scratch_mount_dirs $lowerdir2 $upperdir $workdir
 touch $SCRATCH_MNT/bar 2>&1 | _filter_scratch
 _scratch_remount rw 2>&1 | _filter_scratch
 
diff --git a/tests/overlay/037 b/tests/overlay/037
index 6be9a26..7287329 100755
--- a/tests/overlay/037
+++ b/tests/overlay/037
@@ -71,23 +71,21 @@ mkdir -p $lowerdir $lowerdir2 $upperdir $upperdir2 $workdir
 
 # Mount overlay with lowerdir, upperdir, workdir and index=on
 # to store the file handles of lowerdir and upperdir in overlay.origin xattr
-_overlay_mount_dirs $lowerdir $upperdir $workdir \
-		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT -oindex=on
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -oindex=on
 $UMOUNT_PROG $SCRATCH_MNT
 
 # Try to mount an overlay with the same upperdir and different lowerdir - expect ESTALE
-_overlay_mount_dirs $lowerdir2 $upperdir $workdir \
-		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT -oindex=on 2>&1 | _filter_scratch
+_overlay_scratch_mount_dirs $lowerdir2 $upperdir $workdir -oindex=on \
+	2>&1 | _filter_scratch
 $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 
 # Try to mount an overlay with the same workdir and different upperdir - expect ESTALE
-_overlay_mount_dirs $lowerdir $upperdir2 $workdir \
-		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT -oindex=on 2>&1 | _filter_scratch
+_overlay_scratch_mount_dirs $lowerdir $upperdir2 $workdir -oindex=on \
+	2>&1 | _filter_scratch
 $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 
 # Mount overlay with original lowerdir, upperdir, workdir and index=on - expect success
-_overlay_mount_dirs $lowerdir $upperdir $workdir \
-		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT -oindex=on
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -oindex=on
 
 # success, all done
 status=0
diff --git a/tests/overlay/038 b/tests/overlay/038
index 69fd76a..a281691 100755
--- a/tests/overlay/038
+++ b/tests/overlay/038
@@ -177,8 +177,7 @@ mkdir -p $workdir
 mkdir -p $middir/test_dir
 mkdir -p $lowerdir/test_dir/pure_lower_dir
 
-$MOUNT_PROG -t overlay overlay -o lowerdir=$middir:$lowerdir \
-	    -o upperdir=$upperdir -o workdir=$workdir $SCRATCH_MNT
+_overlay_scratch_mount_dirs "$middir:$lowerdir" $upperdir $workdir
 
 # Copy up test_dir
 touch $SCRATCH_MNT/test_dir/test_file
-- 
2.7.4

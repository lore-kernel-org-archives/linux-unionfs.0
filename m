From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 1/2] common/rc: introduce _overlay_mount_dirs helper
Date: Tue,  9 Aug 2016 19:16:20 +0800
Message-ID: <1470741381-32610-1-git-send-email-eguan@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbcHILQe (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 9 Aug 2016 07:16:34 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

Introduce a new _overlay_mount_dirs() helper to do the actual
overlay mount operation and factor _overlay_scratch_mount and
_overlay_mount code to use a single implemention of
_overlay_mount_dirs(). Also convert all bare mount of overlay in
tests to use it.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/rc         | 21 +++++++++++++++------
 tests/overlay/005 |  6 ++----
 tests/overlay/010 |  5 ++---
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/common/rc b/common/rc
index b19b698..6c1c3ff 100644
--- a/common/rc
+++ b/common/rc
@@ -266,6 +266,18 @@ _scratch_mount_options()
 					$SCRATCH_DEV $SCRATCH_MNT
 }
 
+# helper function to do the actual overlayfs mount operation
+_overlay_mount_dirs()
+{
+	local lowerdir=$1
+	local upperdir=$2
+	local workdir=$3
+	shift 3
+
+	$MOUNT_PROG -t overlay -o lowerdir=$lowerdir -o upperdir=$upperdir \
+		    -o workdir=$workdir $*
+}
+
 # Given a dir, set up 3 subdirectories and mount on the given mnt.
 # The dir is used as the mount device so it can be seen from df or mount
 _overlay_mount()
@@ -293,12 +305,9 @@ _overlay_mount()
 	mkdir -p $dir/$OVERLAY_LOWER_DIR
 	mkdir -p $dir/$OVERLAY_WORK_DIR
 
-	$MOUNT_PROG -t overlay $SELINUX_MOUNT_OPTIONS \
-		    -o lowerdir=$dir/$OVERLAY_LOWER_DIR \
-		    -o upperdir=$dir/$OVERLAY_UPPER_DIR \
-		    -o workdir=$dir/$OVERLAY_WORK_DIR   \
-		    $OVERLAY_MOUNT_OPTIONS $* \
-		    $dir $mnt
+	_overlay_mount_dirs $dir/$OVERLAY_LOWER_DIR $dir/$OVERLAY_UPPER_DIR \
+			    $dir/$OVERLAY_WORK_DIR $OVERLAY_MOUNT_OPTIONS $* \
+			    $dir $mnt
 }
 
 _overlay_test_mount()
diff --git a/tests/overlay/005 b/tests/overlay/005
index 495e7b5..522c6f0 100755
--- a/tests/overlay/005
+++ b/tests/overlay/005
@@ -93,10 +93,8 @@ $XFS_IO_PROG -f -c "truncate 48m" ${lowerd}/test_file \
 	>>$seqres.full 2>&1
 
 # mount new overlayfs
-$MOUNT_PROG -t overlay $SELINUX_MOUNT_OPTIONS \
-	    -o lowerdir=$lowerd -o upperdir=$upperd \
-	    -o workdir=$workd \
-	    $SCRATCH_DEV $SCRATCH_MNT
+_overlay_mount_dirs $lowerd $upperd $workd $SELINUX_MOUNT_OPTIONS \
+		    $SCRATCH_DEV $SCRATCH_MNT
 
 # the open call triggers copy-up and it will fail ENOSPC
 $XFS_IO_PROG -f -c "o" ${SCRATCH_MNT}/test_file \
diff --git a/tests/overlay/010 b/tests/overlay/010
index 5d1c2bd..a302d74 100755
--- a/tests/overlay/010
+++ b/tests/overlay/010
@@ -67,9 +67,8 @@ touch $lowerdir1/testdir/a $lowerdir1/testdir/b
 mknod $lowerdir2/testdir/a c 0 0
 
 # Mount overlayfs and remove testdir, which led to kernel crash
-$MOUNT_PROG -t overlay -o lowerdir=$lowerdir2:$lowerdir1 \
-	    -o upperdir=$upperdir,workdir=$workdir \
-	    $SCRATCH_DEV $SCRATCH_MNT
+_overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
+		    $SCRATCH_DEV $SCRATCH_MNT
 rm -rf $SCRATCH_MNT/testdir
 
 # success, all done
-- 
2.7.4

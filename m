From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstest PATCH] overlay/031: add tests of whiteouts in lowerdir and both dirs
Date: Wed, 28 Jun 2017 18:12:02 +0800
Message-ID: <1498644722-43912-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: fstests@vger.kernel.org
Cc: eguan@redhat.com, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com
List-Id: linux-unionfs@vger.kernel.org

In overlay/031, it only cover the test case of whiteouts in
origined upper dir. This patch add two cases cover the other
two situations:

1) Lower origined dir have whiteouts;
2) Both upper and lower origined dirs have whiteouts (although
this case is pass now, still add this to cover all three kinds
of situations).

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/031 | 83 +++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 63 insertions(+), 20 deletions(-)

diff --git a/tests/overlay/031 b/tests/overlay/031
index 674c11f..0835ddf 100755
--- a/tests/overlay/031
+++ b/tests/overlay/031
@@ -1,9 +1,10 @@
 #! /bin/bash
 # FS QA Test 031
 #
-# The unmerged and impure upper directories may contain invalid
-# whiteouts when we change lowerdir(e.g. clean up dir) and remount
-# overlay. This may lead to whiteouts exposure and rmdir failure.
+# The unmerged and origined directories may contain invalid
+# whiteouts when we change underlaying dir(e.g. clean up lowerdir)
+# and remount overlay. This may lead to whiteouts exposure and
+# rmdir failure.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2017 Huawei.  All Rights Reserved.
@@ -38,6 +39,20 @@ _cleanup()
 	rm -f $tmp.*
 }
 
+# create test directory and test file, mount overlayfs and remove
+# testfile to create a whiteout.
+_create_whiteout()
+{
+	mkdir -p $1/testdir
+	touch $1/testdir/$4
+
+	_overlay_mount_dirs $1 $2 $3 $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+
+	rm -f $SCRATCH_MNT/testdir/$4
+
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
@@ -52,26 +67,22 @@ _require_scratch
 # remove all files from previous runs
 _scratch_mkfs
 
-# create test directory and test file
-lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
-upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
-workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
-mkdir -p $lowerdir/testdir
-touch $lowerdir/testdir/a
-
-# mount overlayfs and remove testfile to create a whiteout
-_scratch_mount
+# create test directorys and whiteout
+lowerdir1=$OVL_BASE_SCRATCH_MNT/lower1
+lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
+testfile1=a
+testfile2=b
+mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 
-rm -f $SCRATCH_MNT/testdir/a
-
-# unmount overlayfs but not base fs
-$UMOUNT_PROG $SCRATCH_MNT
+_create_whiteout $lowerdir1 $upperdir $workdir $testfile1
 
 # clean up the lower directory and mount overlay again,
 # whiteout will expose.
-rm -rf $lowerdir/testdir
+rm -rf $lowerdir1/testdir
 
-_scratch_mount
+_overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 
 ls $SCRATCH_MNT/testdir
 
@@ -82,15 +93,47 @@ rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
 # umount overlay again, create a new file with the same name and
 # mount overlay again.
 $UMOUNT_PROG $SCRATCH_MNT
-touch $lowerdir/testdir
+touch $lowerdir1/testdir
 
-_scratch_mount
+_overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 
 # try to remove test dir from overlay dir, trigger ovl_remove_and_whiteout,
 # it will not clean up the dir and lead to residue.
 rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
 ls $workdir/work
 
+$UMOUNT_PROG $SCRATCH_MNT
+
+# exchange lower dir and upper dir, repeat ls and rmidr test again,
+# the lower dir will have invalid whiteout this time.
+rm -rf $lowerdir1/testdir
+rm -rf $upperdir/testdir
+
+_create_whiteout $lowerdir1 $upperdir $workdir $testfile1
+
+rm -rf $lowerdir1/testdir
+
+_overlay_mount_dirs $upperdir $lowerdir1 $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+
+ls $SCRATCH_MNT/testdir
+rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
+
+$UMOUNT_PROG $SCRATCH_MNT
+
+# let lower dir and upper dir both have invalid whiteouts, repeat ls and rmdir again.
+rm -rf $lowerdir1/testdir
+rm -rf $upperdir/testdir
+
+_create_whiteout $lowerdir1 $upperdir $workdir $testfile1
+
+rm -rf $lowerdir1/testdir
+_create_whiteout $lowerdir1 $lowerdir2 $workdir $testfile2
+
+_overlay_mount_dirs $lowerdir2 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+
+ls $SCRATCH_MNT/testdir
+rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
+
 # success, all done
 echo "Silence is golden"
 status=0
-- 
2.5.0

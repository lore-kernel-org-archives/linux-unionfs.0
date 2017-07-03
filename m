From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstest PATCH V3 1/2] overlay/031: factor out _create_whiteout() helper
Date: Mon, 3 Jul 2017 18:43:30 +0800
Message-ID: <1499078611-18755-2-git-send-email-yi.zhang@huawei.com>
References: <1499078611-18755-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:9341 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753755AbdGCKjg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 3 Jul 2017 06:39:36 -0400
In-Reply-To: <1499078611-18755-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: eguan@redhat.com, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com

Factor out helper for create an leftover whiteout,
this is common to repeat test of whiteout check in
different underlaying directories.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/031 | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/tests/overlay/031 b/tests/overlay/031
index 674c11f..cb29ee5 100755
--- a/tests/overlay/031
+++ b/tests/overlay/031
@@ -38,6 +38,20 @@ _cleanup()
 	rm -f $tmp.*
 }
 
+# create test directory and test file, mount overlayfs and remove
+# testfile to create a whiteout in upper dir.
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
@@ -52,26 +66,20 @@ _require_scratch
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
+lowerdir=$OVL_BASE_SCRATCH_MNT/lower
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
+testfile=a
+mkdir -p $lowerdir $upperdir $workdir
 
-rm -f $SCRATCH_MNT/testdir/a
-
-# unmount overlayfs but not base fs
-$UMOUNT_PROG $SCRATCH_MNT
+_create_whiteout $lowerdir $upperdir $workdir $testfile
 
 # clean up the lower directory and mount overlay again,
 # whiteout will expose.
 rm -rf $lowerdir/testdir
 
-_scratch_mount
+_overlay_mount_dirs $lowerdir $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 
 ls $SCRATCH_MNT/testdir
 
@@ -84,7 +92,7 @@ rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
 $UMOUNT_PROG $SCRATCH_MNT
 touch $lowerdir/testdir
 
-_scratch_mount
+_overlay_mount_dirs $lowerdir $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 
 # try to remove test dir from overlay dir, trigger ovl_remove_and_whiteout,
 # it will not clean up the dir and lead to residue.
-- 
2.5.0

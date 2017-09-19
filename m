From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] overlay/031: fix test with inodes index enabled
Date: Tue, 19 Sep 2017 14:39:44 +0300
Message-ID: <1505821184-3913-3-git-send-email-amir73il@gmail.com>
References: <1505821184-3913-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36302 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbdISLjR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Sep 2017 07:39:17 -0400
In-Reply-To: <1505821184-3913-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, zhangyi <yi.zhang@huawei.com>

When overlayfs is configured with CONFIG_OVERLAY_FS_INDEX=y,
workdir from previous overlay mount cannot be reused in a new
overlay mount that uses a different upper dir.

Fix the test to use a different workdir when mounting with a
different upper dir.

This change has no effect on older kernels and overlay
configured without CONFIG_OVERLAY_FS_INDEX.

Cc: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/031 | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/tests/overlay/031 b/tests/overlay/031
index 161022e..70ee299 100755
--- a/tests/overlay/031
+++ b/tests/overlay/031
@@ -43,12 +43,17 @@ _cleanup()
 # testfile to create a whiteout in upper dir.
 create_whiteout()
 {
-	mkdir -p $1/testdir
-	touch $1/testdir/$4
+	local lower=$1
+	local upper=$2
+	local work=$3
+	local file=$4
 
-	_overlay_mount_dirs $1 $2 $3 $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+	mkdir -p $lower/testdir
+	touch $lower/testdir/$file
 
-	rm -f $SCRATCH_MNT/testdir/$4
+	_overlay_mount_dirs $lower $upper $work $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+
+	rm -f $SCRATCH_MNT/testdir/$file
 
 	$UMOUNT_PROG $SCRATCH_MNT
 }
@@ -72,9 +77,13 @@ lowerdir1=$OVL_BASE_SCRATCH_MNT/lower1
 lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
 upperdir=$OVL_BASE_SCRATCH_MNT/upper
 workdir=$OVL_BASE_SCRATCH_MNT/workdir
+# When overlay inode index feature is enabled, a workdir cannot be reused
+# with a different upperdir. workdir1 in this test is used as the workdir
+# when lowerdir1 is used as the upperdir.
+workdir1=$OVL_BASE_SCRATCH_MNT/workdir1
 testfile1=a
 testfile2=b
-mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
+mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir $workdir1
 
 create_whiteout $lowerdir1 $upperdir $workdir $testfile1
 
@@ -108,7 +117,7 @@ $UMOUNT_PROG $SCRATCH_MNT
 rm -rf $lowerdir1/testdir
 rm -rf $upperdir/testdir
 
-create_whiteout $lowerdir2 $lowerdir1 $workdir $testfile1
+create_whiteout $lowerdir2 $lowerdir1 $workdir1 $testfile1
 
 rm -rf $lowerdir2/testdir
 
@@ -128,7 +137,7 @@ create_whiteout $lowerdir1 $upperdir $workdir $testfile1
 
 rm -rf $lowerdir1/testdir/$testfile1
 
-create_whiteout $lowerdir2 $lowerdir1 $workdir $testfile2
+create_whiteout $lowerdir2 $lowerdir1 $workdir1 $testfile2
 
 _overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 
-- 
2.7.4

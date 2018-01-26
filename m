From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/4] ovelray: drop explicit use of OVERLAY_MOUNT_OPTIONS
Date: Fri, 26 Jan 2018 09:59:05 +0200
Message-ID: <1516953548-15679-2-git-send-email-amir73il@gmail.com>
References: <1516953548-15679-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:42101 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751920AbeAZH6K (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 26 Jan 2018 02:58:10 -0500
In-Reply-To: <1516953548-15679-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Tests don't need to specify $OVERLAY_MOUNT_OPTIONS for overlay mount
helpers. These options have already been assigned to MOUNT_OPTIONS by
_overlay_config_override or by _mount_opts and will be added to mount
command by _common_dev_mount_options in _overlay_mount_dirs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/041 | 6 ++----
 tests/overlay/043 | 6 ++----
 tests/overlay/044 | 7 ++-----
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/tests/overlay/041 b/tests/overlay/041
index 4152107..11efacb 100755
--- a/tests/overlay/041
+++ b/tests/overlay/041
@@ -68,8 +68,7 @@ _scratch_mkfs
 upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir \
-			$OVERLAY_MOUNT_OPTIONS
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
 
 test_dir=$SCRATCH_MNT/test_dir/
 
@@ -185,8 +184,7 @@ _scratch_mkfs
 upperdir=$OVL_BASE_SCRATCH_MNT/ovl-upper
 workdir=$OVL_BASE_SCRATCH_MNT/ovl-work
 
-_overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir \
-			$OVERLAY_MOUNT_OPTIONS
+_overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir
 
 # Copy up test_dir
 touch $test_dir/test_file
diff --git a/tests/overlay/043 b/tests/overlay/043
index 858b6a9..699c4e1 100755
--- a/tests/overlay/043
+++ b/tests/overlay/043
@@ -81,8 +81,7 @@ _scratch_mkfs >>$seqres.full 2>&1
 upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir \
-			    $OVERLAY_MOUNT_OPTIONS
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
 
 FILES="dir file symlink chrdev blkdev fifo socket"
 
@@ -149,8 +148,7 @@ check_inode_numbers $testdir $tmp.after_copyup $tmp.after_move
 
 # Verify that the inode numbers survive a mount cycle
 $UMOUNT_PROG $SCRATCH_MNT
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir \
-			    $OVERLAY_MOUNT_OPTIONS
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
 
 # Compare inode numbers before/after mount cycle
 check_inode_numbers $testdir $tmp.after_move $tmp.after_cycle
diff --git a/tests/overlay/044 b/tests/overlay/044
index 9c0ff04..e57f6f7 100755
--- a/tests/overlay/044
+++ b/tests/overlay/044
@@ -98,9 +98,7 @@ upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 
 # Enable overlay index feature to prevent breaking hardlinks on copy up
-OVERLAY_MOUNT_OPTIONS="${OVERLAY_MOUNT_OPTIONS} -o index=on"
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir \
-			    $OVERLAY_MOUNT_OPTIONS
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on
 
 rm -f $tmp.*
 
@@ -124,8 +122,7 @@ check_ino_nlink $SCRATCH_MNT $tmp.before $tmp.after_one
 
 # Verify that the hardlinks survive a mount cycle
 $UMOUNT_PROG $SCRATCH_MNT
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir \
-			    $OVERLAY_MOUNT_OPTIONS
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on
 
 echo "== After mount cycle =="
 cat $FILES
-- 
2.7.4

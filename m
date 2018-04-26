Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/4] overlay/043: require and enable redirect_dir
Date: Wed, 25 Apr 2018 23:53:26 -0600
Message-Id: <1524722007-30891-4-git-send-email-amir73il@gmail.com>
In-Reply-To: <1524722007-30891-1-git-send-email-amir73il@gmail.com>
References: <1524722007-30891-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

This test renames a merge directory so it needs to enable
redirect_dir feature, which is not enabled by default.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/043 | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tests/overlay/043 b/tests/overlay/043
index 46df686..f70ee7f 100755
--- a/tests/overlay/043
+++ b/tests/overlay/043
@@ -62,6 +62,8 @@ _require_scratch_nocheck
 _require_test
 _require_test_program "af_unix"
 _require_test_program "t_dir_type"
+# Require redirect_dir for renaming a merge directory
+_require_scratch_feature redirect_dir
 
 rm -f $seqres.full
 
@@ -83,7 +85,8 @@ _scratch_mkfs >>$seqres.full 2>&1
 upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
+# Enable redirect_dir for renaming a merge directory
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o redirect_dir=on
 
 FILES="dir file symlink chrdev blkdev fifo socket"
 
@@ -150,13 +153,13 @@ check_inode_numbers $testdir $tmp.after_copyup $tmp.after_move
 
 # Verify that the inode numbers survive a mount cycle
 $UMOUNT_PROG $SCRATCH_MNT
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o redirect_dir=on
 
 # Compare inode numbers before/after mount cycle
 check_inode_numbers $testdir $tmp.after_move $tmp.after_cycle
 
 # check overlayfs
-_overlay_check_scratch_dirs $lowerdir $upperdir $workdir
+_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o redirect_dir=on
 
 echo "Silence is golden"
 status=0
-- 
2.7.4

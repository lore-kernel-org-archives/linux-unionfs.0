From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/3] overlay/041: code cleanup
Date: Sun, 19 Nov 2017 13:56:27 +0200
Message-ID: <1511092589-29179-2-git-send-email-amir73il@gmail.com>
References: <1511092589-29179-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:46155 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdKSLzw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Nov 2017 06:55:52 -0500
In-Reply-To: <1511092589-29179-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

- Remove duplicate merged dir tests
- Remove duplicate pure upper dir inside merged dir tests
- Sort out comments and error messages

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/041 | 67 ++++++++++++++++++++++---------------------------------
 1 file changed, 27 insertions(+), 40 deletions(-)

diff --git a/tests/overlay/041 b/tests/overlay/041
index 4d7feb8..a615fcc 100755
--- a/tests/overlay/041
+++ b/tests/overlay/041
@@ -60,9 +60,7 @@ rm -rf $lowerdir
 mkdir $lowerdir
 
 # Create our test files.
-mkdir $lowerdir/test_dir/
-mkdir $lowerdir/test_dir/pure_lower_dir
-mkdir $lowerdir/test_dir/merged_dir
+mkdir -p $lowerdir/test_dir/pure_lower_dir
 touch $lowerdir/test_file
 
 _scratch_mkfs
@@ -73,23 +71,6 @@ workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
 
 test_dir=$SCRATCH_MNT/test_dir/
-merged_dir=$test_dir/merged_dir
-pure_upper_dir=$merged_dir/pure_upper_dir
-
-mkdir -p $pure_upper_dir
-
-merged_dir_st_ino=$(stat -c '%i' $merged_dir)
-
-# Pure dir's parent d_ino must always be calculated because
-# it can be residing inside a merged dir.
-parent_d=$($here/src/t_dir_type $pure_upper_dir $merged_dir_st_ino)
-[[ $parent_d == ".. d" ]] || \
-	echo "Pure dir inside a merged dir: Invalid d_ino reported for .."
-
-# d_ino for "." must always be calculated because the present
-# directory can have a copy-up origin.
-current_d=$($here/src/t_dir_type $merged_dir $merged_dir_st_ino)
-[[ $current_d == ". d" ]] || echo "Merged dir: Invalid d_ino reported for ."
 
 # Verify d_ino of '.' and '..' before and after dir becomes impure.
 impure_dir=$test_dir/impure_dir
@@ -101,13 +82,13 @@ impure_dir_parent_st_ino=$(stat -c '%i' $test_dir)
 # Before $impure_dir becomes impure
 parent_d=$($here/src/t_dir_type $impure_dir $impure_dir_parent_st_ino)
 [[ $parent_d == ".. d" ]] || \
-    echo "Before dir becomes impure: Invalid d_ino reported for .."
+    echo "Pure upper dir: Invalid d_ino reported for .."
 
 current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
 [[ $current_d == ". d" ]] || \
-    echo "Before dir becomes impure: Invalid d_ino reported for ."
-
+    echo "Pure upper dir: Invalid d_ino reported for ."
 
+# Move a copied up file into pure dir to make it impure
 mv $SCRATCH_MNT/test_file $impure_dir
 test_file_st_ino=$(stat -c '%i' $impure_dir/test_file)
 
@@ -118,11 +99,11 @@ impure=$($GETFATTR_PROG --absolute-names --only-values -n 'trusted.overlay.impur
 # After $impure_dir becomes impure
 parent_d=$($here/src/t_dir_type $impure_dir $impure_dir_parent_st_ino)
 [[ $parent_d == ".. d" ]] || \
-    echo "After dir becomes impure: Invalid d_ino reported for .."
+    echo "Impure dir: Invalid d_ino reported for .."
 
 current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
 [[ $current_d == ". d" ]] || \
-    echo "After dir becomes impure: Invalid d_ino reported for ."
+    echo "Impure dir: Invalid d_ino reported for ."
 
 # Verify copy up file's d_ino
 file_d=$($here/src/t_dir_type $impure_dir $test_file_st_ino)
@@ -134,30 +115,35 @@ rm -rf $impure_dir/test_file
 
 # Verify invalidation of readdir cache
 $here/src/t_dir_type $impure_dir $test_file_st_ino
-[[ $? != 0 ]] || echo "Directory's readdir cache has stale entries"
+[[ $? != 0 ]] || echo "Directory's readdir cache has stale file entries"
 
 impure=$($GETFATTR_PROG --absolute-names --only-values -n 'trusted.overlay.impure' \
 			$upperdir/test_dir/impure_dir 2>/dev/null)
 [[ -z $impure ]] || echo "Pure directory has impure xattr"
 
-# Verify d_ino values corresponding to "." and ".." entries of a
-# pure lower dir.
-parent_st_ino=$(stat -c '%i' $SCRATCH_MNT/test_dir)
+# Verify d_ino of '.' and '..' before and after dir becomes merge dir.
+parent_st_ino=$(stat -c '%i' $test_dir)
 pure_lower_dir=$SCRATCH_MNT/test_dir/pure_lower_dir
+pure_lower_dir_st_ino=$(stat -c '%i' $pure_lower_dir)
 
 parent_d=$($here/src/t_dir_type $pure_lower_dir $parent_st_ino)
-[[ $parent_d == ".. d" ]] || echo "Pure lower dir: Invalid d_ino reported for .."
-
-pure_lower_dir_st_ino=$(stat -c '%i' $pure_lower_dir)
+[[ $parent_d == ".. d" ]] || \
+	echo "Pure lower dir: Invalid d_ino reported for .."
 
 current_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_dir_st_ino)
-[[ $current_d == ". d" ]] || echo "Pure lower dir: Invalid d_ino reported for ."
+[[ $current_d == ". d" ]] || \
+	echo "Pure lower dir: Invalid d_ino reported for ."
+
+# Create a file in pure lower dir to make it a merge dir
+touch $pure_lower_dir/newfile
 
-# Verify d_ino of ".." entry of a merged dir.
-merged_dir=$SCRATCH_MNT/test_dir/merged_dir
+parent_d=$($here/src/t_dir_type $pure_lower_dir $parent_st_ino)
+[[ $parent_d == ".. d" ]] || \
+	echo "Merged dir: Invalid d_ino reported for .."
 
-parent_d=$($here/src/t_dir_type $merged_dir $parent_st_ino)
-[[ $parent_d == ".. d" ]] || echo "Merged dir: Invalid d_ino reported for .."
+current_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_dir_st_ino)
+[[ $current_d == ". d" ]] || \
+	echo "Merged dir: Invalid d_ino reported for ."
 
 _scratch_unmount
 
@@ -180,11 +166,12 @@ workdir=$OVL_BASE_SCRATCH_MNT/ovl-work
 _overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir
 
 # Copy up test_dir
-touch $SCRATCH_MNT/test_dir/test_file
+touch $test_dir/test_file
 
-test_dir_st_ino=$(stat -c '%i' $SCRATCH_MNT/test_dir)
+test_dir_st_ino=$(stat -c '%i' $test_dir)
+pure_lower_dir=$test_dir/pure_lower_dir
 
-parent_d=$($here/src/t_dir_type $SCRATCH_MNT/test_dir/pure_lower_dir $test_dir_st_ino)
+parent_d=$($here/src/t_dir_type $pure_lower_dir $test_dir_st_ino)
 [[ $parent_d == ".. d" ]] || \
 	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for .."
 
-- 
2.7.4

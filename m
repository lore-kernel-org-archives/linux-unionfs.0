From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH 1/2] overlay/038: code cleanup
Date: Mon, 20 Nov 2017 20:04:09 +0530
Message-ID: <20171120143410.23357-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751124AbdKTOdU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Nov 2017 09:33:20 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAKETFdh084886
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Nov 2017 09:33:19 -0500
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ec0g9hhxa-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Nov 2017 09:33:19 -0500
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 20 Nov 2017 09:33:18 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org, amir73il@gmail.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org, eguan@redhat.com

This commit implements similar changes made to overlay/041 test i.e.
- Remove duplicate merged dir tests
- Remove duplicate pure upper dir inside merged dir tests
- Sort out comments and error messages

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/overlay/038 | 66 +++++++++++++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 39 deletions(-)

diff --git a/tests/overlay/038 b/tests/overlay/038
index 28c9c4e..fd804c4 100755
--- a/tests/overlay/038
+++ b/tests/overlay/038
@@ -59,32 +59,13 @@ upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 
-mkdir $lowerdir/test_dir/
-mkdir $lowerdir/test_dir/pure_lower_dir
-mkdir $lowerdir/test_dir/merged_dir
+mkdir -p $lowerdir/test_dir/pure_lower_dir
 
 touch $lowerdir/test_file
 
 _scratch_mount
 
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
@@ -96,12 +77,13 @@ impure_dir_parent_st_ino=$(stat -c '%i' $test_dir)
 # Before $impure_dir becomes impure
 parent_d=$($here/src/t_dir_type $impure_dir $impure_dir_parent_st_ino)
 [[ $parent_d == ".. d" ]] || \
-    echo "Before dir becomes impure: Invalid d_ino reported for .."
+    echo "Pure upper dir: Invalid d_ino reported for .."
 
 current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
 [[ $current_d == ". d" ]] || \
-    echo "Before dir becomes impure: Invalid d_ino reported for ."
+    echo "Pure upper dir: Invalid d_ino reported for ."
 
+# Move a copied up file into pure dir to make it impure
 mv $SCRATCH_MNT/test_file $impure_dir
 test_file_st_ino=$(stat -c '%i' $impure_dir/test_file)
 
@@ -112,11 +94,11 @@ impure=$($GETFATTR_PROG --absolute-names --only-values -n 'trusted.overlay.impur
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
@@ -128,30 +110,35 @@ rm -rf $impure_dir/test_file
 
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
 
-# Verify d_ino of ".." entry of a merged dir.
-merged_dir=$SCRATCH_MNT/test_dir/merged_dir
+# Create a file in pure lower dir to make it a merge dir
+touch $pure_lower_dir/newfile
 
-parent_d=$($here/src/t_dir_type $merged_dir $parent_st_ino)
-[[ $parent_d == ".. d" ]] || echo "Merged dir: Invalid d_ino reported for .."
+parent_d=$($here/src/t_dir_type $pure_lower_dir $parent_st_ino)
+[[ $parent_d == ".. d" ]] || \
+	echo "Merged dir: Invalid d_ino reported for .."
+ 
+current_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_dir_st_ino)
+[[ $current_d == ". d" ]] || \
+	echo "Merged dir: Invalid d_ino reported for ."
 
 _scratch_unmount
 
@@ -177,11 +164,12 @@ mkdir -p $lowerdir/test_dir/pure_lower_dir
 _overlay_scratch_mount_dirs "$middir:$lowerdir" $upperdir $workdir
 
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
2.9.5

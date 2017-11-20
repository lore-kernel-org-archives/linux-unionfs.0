From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH 2/2] overlay/038: test consistent values of st_ino/d_ino for subdirs
Date: Mon, 20 Nov 2017 20:04:10 +0530
Message-ID: <20171120143410.23357-2-chandan@linux.vnet.ibm.com>
References: <20171120143410.23357-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35256 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751124AbdKTOdX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Nov 2017 09:33:23 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAKETHVp085045
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Nov 2017 09:33:23 -0500
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ec0g9hj1n-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Nov 2017 09:33:23 -0500
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 20 Nov 2017 09:33:22 -0500
In-Reply-To: <20171120143410.23357-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org, amir73il@gmail.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org, eguan@redhat.com

This commit implements similar changes made to overlay/038 test i.e. in
addition to checking consistent values of st_ino/d_ino for "."  and ".."
entries, check also the values for subdir inside each tested directory
setup.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/overlay/038 | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/tests/overlay/038 b/tests/overlay/038
index fd804c4..5415324 100755
--- a/tests/overlay/038
+++ b/tests/overlay/038
@@ -59,7 +59,7 @@ upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 
-mkdir -p $lowerdir/test_dir/pure_lower_dir
+mkdir -p $lowerdir/test_dir/pure_lower_dir/subdir
 
 touch $lowerdir/test_file
 
@@ -69,10 +69,11 @@ test_dir=$SCRATCH_MNT/test_dir/
 
 # Verify d_ino of '.' and '..' before and after dir becomes impure.
 impure_dir=$test_dir/impure_dir
-mkdir -p $impure_dir
+mkdir -p $impure_dir/subdir
 
 impure_dir_st_ino=$(stat -c '%i' $impure_dir)
 impure_dir_parent_st_ino=$(stat -c '%i' $test_dir)
+impure_subdir_st_ino=$(stat -c '%i' $impure_dir/subdir)
 
 # Before $impure_dir becomes impure
 parent_d=$($here/src/t_dir_type $impure_dir $impure_dir_parent_st_ino)
@@ -83,6 +84,10 @@ current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
 [[ $current_d == ". d" ]] || \
     echo "Pure upper dir: Invalid d_ino reported for ."
 
+subdir_d=$($here/src/t_dir_type $impure_dir $impure_subdir_st_ino)
+[[ $subdir_d == "subdir d" ]] || \
+    echo "Pure upper dir: Invalid d_ino reported for subdir"
+
 # Move a copied up file into pure dir to make it impure
 mv $SCRATCH_MNT/test_file $impure_dir
 test_file_st_ino=$(stat -c '%i' $impure_dir/test_file)
@@ -100,6 +105,10 @@ current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
 [[ $current_d == ". d" ]] || \
     echo "Impure dir: Invalid d_ino reported for ."
 
+subdir_d=$($here/src/t_dir_type $impure_dir $impure_subdir_st_ino)
+[[ $subdir_d == "subdir d" ]] || \
+    echo "Impure dir: Invalid d_ino reported for subdir"
+
 # Verify copy up file's d_ino
 file_d=$($here/src/t_dir_type $impure_dir $test_file_st_ino)
 [[ $file_d == "test_file f" ]] || \
@@ -107,19 +116,23 @@ file_d=$($here/src/t_dir_type $impure_dir $test_file_st_ino)
 
 # Make $impure_dir pure
 rm -rf $impure_dir/test_file
+rm -rf $impure_dir/subdir
 
 # Verify invalidation of readdir cache
 $here/src/t_dir_type $impure_dir $test_file_st_ino
 [[ $? != 0 ]] || echo "Directory's readdir cache has stale file entries"
+$here/src/t_dir_type $impure_dir $impure_subdir_st_ino
+[[ $? != 0 ]] || echo "Directory's readdir cache has stale subdir entries"
 
 impure=$($GETFATTR_PROG --absolute-names --only-values -n 'trusted.overlay.impure' \
 			$upperdir/test_dir/impure_dir 2>/dev/null)
 [[ -z $impure ]] || echo "Pure directory has impure xattr"
 
-# Verify d_ino of '.' and '..' before and after dir becomes merge dir.
+# Verify d_ino values of subdir entries of a pure lower dir.
 parent_st_ino=$(stat -c '%i' $test_dir)
 pure_lower_dir=$SCRATCH_MNT/test_dir/pure_lower_dir
 pure_lower_dir_st_ino=$(stat -c '%i' $pure_lower_dir)
+pure_lower_subdir_st_ino=$(stat -c '%i' $pure_lower_dir/subdir)
 
 parent_d=$($here/src/t_dir_type $pure_lower_dir $parent_st_ino)
 [[ $parent_d == ".. d" ]] || \
@@ -129,6 +142,10 @@ current_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_dir_st_ino)
 [[ $current_d == ". d" ]] || \
 	echo "Pure lower dir: Invalid d_ino reported for ."
 
+subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
+[[ $subdir_d == "subdir d" ]] || \
+	echo "Pure lower dir: Invalid d_ino reported for subdir"
+
 # Create a file in pure lower dir to make it a merge dir
 touch $pure_lower_dir/newfile
 
@@ -140,6 +157,10 @@ current_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_dir_st_ino)
 [[ $current_d == ". d" ]] || \
 	echo "Merged dir: Invalid d_ino reported for ."
 
+subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
+[[ $subdir_d == "subdir d" ]] || \
+	echo "Merged dir: Invalid d_ino reported for subdir"
+
 _scratch_unmount
 
 # Verify pure lower residing in dir which has another lower layer
@@ -158,8 +179,7 @@ mkdir -p $lowerdir
 mkdir -p $upperdir
 mkdir -p $workdir
 
-mkdir -p $middir/test_dir
-mkdir -p $lowerdir/test_dir/pure_lower_dir
+mkdir -p $lowerdir/test_dir/pure_lower_dir/subdir
 
 _overlay_scratch_mount_dirs "$middir:$lowerdir" $upperdir $workdir
 
@@ -168,10 +188,19 @@ touch $test_dir/test_file
 
 test_dir_st_ino=$(stat -c '%i' $test_dir)
 pure_lower_dir=$test_dir/pure_lower_dir
+pure_lower_dir_st_ino=$(stat -c '%i' $pure_lower_dir)
+pure_lower_subdir_st_ino=$(stat -c '%i' $pure_lower_dir/subdir)
 
 parent_d=$($here/src/t_dir_type $pure_lower_dir $test_dir_st_ino)
 [[ $parent_d == ".. d" ]] || \
 	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for .."
+current_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_dir_st_ino)
+[[ $current_d == ". d" ]] || \
+	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for ."
+
+subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
+[[ $subdir_d == "subdir d" ]] || \
+	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for subdir"
 
 echo "Silence is golden"
 status=0
-- 
2.9.5

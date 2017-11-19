From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/3] overlay/041: test consistent values of st_ino/d_ino for subdirs
Date: Sun, 19 Nov 2017 13:56:28 +0200
Message-ID: <1511092589-29179-3-git-send-email-amir73il@gmail.com>
References: <1511092589-29179-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1511092589-29179-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

In addition to checking consistent values of st_ino/d_ino for "."
and ".." entries, check also the values for subdir inside each
tested directory setup.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/041 | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/tests/overlay/041 b/tests/overlay/041
index a615fcc..11efacb 100755
--- a/tests/overlay/041
+++ b/tests/overlay/041
@@ -60,7 +60,7 @@ rm -rf $lowerdir
 mkdir $lowerdir
 
 # Create our test files.
-mkdir -p $lowerdir/test_dir/pure_lower_dir
+mkdir -p $lowerdir/test_dir/pure_lower_dir/subdir
 touch $lowerdir/test_file
 
 _scratch_mkfs
@@ -74,10 +74,11 @@ test_dir=$SCRATCH_MNT/test_dir/
 
 # Verify d_ino of '.' and '..' before and after dir becomes impure.
 impure_dir=$test_dir/impure_dir
-mkdir -p $impure_dir
+mkdir -p $impure_dir/subdir
 
 impure_dir_st_ino=$(stat -c '%i' $impure_dir)
 impure_dir_parent_st_ino=$(stat -c '%i' $test_dir)
+impure_subdir_st_ino=$(stat -c '%i' $impure_dir/subdir)
 
 # Before $impure_dir becomes impure
 parent_d=$($here/src/t_dir_type $impure_dir $impure_dir_parent_st_ino)
@@ -88,6 +89,10 @@ current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
 [[ $current_d == ". d" ]] || \
     echo "Pure upper dir: Invalid d_ino reported for ."
 
+subdir_d=$($here/src/t_dir_type $impure_dir $impure_subdir_st_ino)
+[[ $subdir_d == "subdir d" ]] || \
+    echo "Pure upper dir: Invalid d_ino reported for subdir"
+
 # Move a copied up file into pure dir to make it impure
 mv $SCRATCH_MNT/test_file $impure_dir
 test_file_st_ino=$(stat -c '%i' $impure_dir/test_file)
@@ -105,6 +110,10 @@ current_d=$($here/src/t_dir_type $impure_dir $impure_dir_st_ino)
 [[ $current_d == ". d" ]] || \
     echo "Impure dir: Invalid d_ino reported for ."
 
+subdir_d=$($here/src/t_dir_type $impure_dir $impure_subdir_st_ino)
+[[ $subdir_d == "subdir d" ]] || \
+    echo "Impure dir: Invalid d_ino reported for subdir"
+
 # Verify copy up file's d_ino
 file_d=$($here/src/t_dir_type $impure_dir $test_file_st_ino)
 [[ $file_d == "test_file f" ]] || \
@@ -112,19 +121,23 @@ file_d=$($here/src/t_dir_type $impure_dir $test_file_st_ino)
 
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
@@ -134,6 +147,10 @@ current_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_dir_st_ino)
 [[ $current_d == ". d" ]] || \
 	echo "Pure lower dir: Invalid d_ino reported for ."
 
+subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
+[[ $subdir_d == "subdir d" ]] || \
+	echo "Pure lower dir: Invalid d_ino reported for subdir"
+
 # Create a file in pure lower dir to make it a merge dir
 touch $pure_lower_dir/newfile
 
@@ -145,6 +162,10 @@ current_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_dir_st_ino)
 [[ $current_d == ". d" ]] || \
 	echo "Merged dir: Invalid d_ino reported for ."
 
+subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
+[[ $subdir_d == "subdir d" ]] || \
+	echo "Merged dir: Invalid d_ino reported for subdir"
+
 _scratch_unmount
 
 # Verify pure lower residing in dir which has another lower layer
@@ -156,7 +177,7 @@ mkdir $middir
 mkdir $lowerdir
 
 mkdir -p $middir/test_dir
-mkdir -p $lowerdir/test_dir/pure_lower_dir
+mkdir -p $lowerdir/test_dir/pure_lower_dir/subdir
 
 _scratch_mkfs
 
@@ -170,11 +191,21 @@ touch $test_dir/test_file
 
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
+
 echo "Silence is golden"
 status=0
 exit
-- 
2.7.4

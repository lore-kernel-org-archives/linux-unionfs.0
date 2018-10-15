Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay: check expected fsck.overlay exit codes
Date: Mon, 15 Oct 2018 23:29:19 +0300
Message-Id: <20181015202919.23679-1-amir73il@gmail.com>
To: zhangyi <yi.zhang@huawei.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

The latest version of fsck.overlay now conforms to e2fsck exit codes.
Adjust the tests to correctly check the expected exit codes.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zhangyi,

With fsck.overlay from your master branch all the -g overlay/fsck
test fail.

Please confirm that this patch correctly describes expected behavior.

The test overlay/045 still fails on "fsck should be happy" assertions.
Does fsck.overlay actually fixes anything in those cases? or is not
returning FSCK_OK an oversight?

Thanks,
Amir.

 tests/overlay/045 | 35 +++++++++++++++++++----------------
 tests/overlay/046 | 46 ++++++++++++++++++++++++----------------------
 tests/overlay/056 | 12 ++++++------
 3 files changed, 49 insertions(+), 44 deletions(-)

diff --git a/tests/overlay/045 b/tests/overlay/045
index acc70871..4d06f7a1 100755
--- a/tests/overlay/045
+++ b/tests/overlay/045
@@ -96,8 +96,8 @@ echo "+ Orphan whiteout"
 make_test_dirs
 make_whiteout $lowerdir/foo $upperdir/{foo,bar}
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 ls $lowerdir
 ls $upperdir
 
@@ -108,7 +108,8 @@ touch $lowerdir2/{foo,bar}
 make_whiteout $upperdir/foo $lowerdir/bar
 
 _overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
-	 $seqres.full 2>&1 || echo "fsck should not fail"
+	$seqres.full 2>&1
+[ $? = 0 ] || echo "fsck should be happy"
 check_whiteout $upperdir/foo $lowerdir/bar
 
 # Test orphan whiteout in opaque directory, should remove
@@ -119,8 +120,8 @@ touch $lowerdir/testdir/foo
 make_opaque_dir $upperdir/testdir
 make_whiteout $upperdir/testdir/foo
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 ls $upperdir/testdir
 
 # Test orphan whiteout whose parent path is not an merged directory,
@@ -136,7 +137,8 @@ make_opaque_dir $lowerdir/testdir3
 make_whiteout $upperdir/{testdir1/foo,/testdir2/foo,testdir3/foo,testdir4/foo}
 
 _overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
-	$seqres.full 2>&1 || echo "fsck should not fail"
+	$seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 ls $upperdir/testdir1
 ls $upperdir/testdir2
 ls $upperdir/testdir3
@@ -150,8 +152,8 @@ touch $lowerdir/testdir/foo
 make_redirect_dir $upperdir/testdir "origin"
 make_whiteout $upperdir/testdir/foo
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 ls $upperdir/testdir
 
 # Test valid whiteout in redirect directory cover file in lower
@@ -163,8 +165,8 @@ touch $lowerdir/origin/foo
 make_redirect_dir $upperdir/testdir "origin"
 make_whiteout $upperdir/testdir/foo
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 0 ] || echo "fsck should be happy"
 check_whiteout $upperdir/testdir/foo
 
 # Test valid whiteout covering lower target whose parent directory
@@ -177,8 +179,9 @@ make_redirect_dir $lowerdir/testdir "origin"
 mkdir -p $upperdir/testdir/subdir
 make_whiteout $upperdir/testdir/subdir/foo
 
-_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p \
-	>> $seqres.full 2>&1 || echo "fsck should not fail"
+_overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
+	$seqres.full 2>&1
+[ $? = 0 ] || echo "fsck should be happy"
 check_whiteout $upperdir/testdir/subdir/foo
 
 # Test invalid whiteout in opaque subdirectory in a redirect directory,
@@ -191,8 +194,8 @@ make_redirect_dir $upperdir/testdir "origin"
 make_opaque_dir $upperdir/testdir/subdir
 make_whiteout $upperdir/testdir/subdir/foo
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 ls $upperdir/testdir/subdir
 
 # Test valid whiteout in reidrect subdirectory in a opaque directory
@@ -205,8 +208,8 @@ make_opaque_dir $upperdir/testdir
 make_redirect_dir $upperdir/testdir/subdir "/origin"
 make_whiteout $upperdir/testdir/subdir/foo
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-        echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 0 ] || echo "fsck should be happy"
 check_whiteout $upperdir/testdir/subdir/foo
 
 # success, all done
diff --git a/tests/overlay/046 b/tests/overlay/046
index 6338a383..d4dc0977 100755
--- a/tests/overlay/046
+++ b/tests/overlay/046
@@ -121,8 +121,8 @@ echo "+ Invalid redirect"
 make_test_dirs
 make_redirect_dir $upperdir/testdir "invalid"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 check_no_redirect $upperdir/testdir
 
 # Test invalid redirect xattr point to a file origin, should remove
@@ -131,8 +131,8 @@ make_test_dirs
 touch $lowerdir/origin
 make_redirect_dir $upperdir/testdir "origin"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 check_no_redirect $upperdir/testdir
 
 # Test valid redirect xattr point to a directory origin in the same directory,
@@ -143,8 +143,8 @@ mkdir $lowerdir/origin
 make_whiteout $upperdir/origin
 make_redirect_dir $upperdir/testdir "origin"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 check_redirect $upperdir/testdir "origin"
 
 # Test valid redirect xattr point to a directory origin in different directories
@@ -155,8 +155,8 @@ mkdir $lowerdir/origin
 make_whiteout $upperdir/origin
 make_redirect_dir $upperdir/testdir1/testdir2 "/origin"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 check_redirect $upperdir/testdir1/testdir2 "/origin"
 
 # Test valid redirect xattr but missing whiteout to cover lower target,
@@ -166,8 +166,8 @@ make_test_dirs
 mkdir $lowerdir/origin
 make_redirect_dir $upperdir/testdir "origin"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 check_redirect $upperdir/testdir "origin"
 check_whiteout $upperdir/origin
 
@@ -178,8 +178,8 @@ mkdir $lowerdir/{testdir1,testdir2}
 make_redirect_dir $upperdir/testdir1 "testdir2"
 make_redirect_dir $upperdir/testdir2 "testdir1"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 check_redirect $upperdir/testdir1 "testdir2"
 check_redirect $upperdir/testdir2 "testdir1"
 
@@ -191,8 +191,8 @@ mkdir $lowerdir/testdir
 make_redirect_dir $upperdir/testdir "invalid"
 
 # Question get yes answer: Should set opaque dir ?
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 check_no_redirect $upperdir/testdir
 check_opaque $upperdir/testdir
 
@@ -206,11 +206,13 @@ make_redirect_dir $lowerdir/testdir2 "origin"
 make_redirect_dir $upperdir/testdir3 "origin"
 
 _overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -p >> \
-	$seqres.full 2>&1 && echo "fsck should fail"
+	$seqres.full 2>&1
+[ $? = 4 ] || echo "fsck should fail to correct errors"
 
 # Question get yes answer: Duplicate redirect directory, remove xattr ?
 _overlay_fsck_dirs "$lowerdir:$lowerdir2" $upperdir $workdir -y >> \
-	$seqres.full 2>&1 || echo "fsck should not fail"
+	$seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 redirect_1=`check_redirect $lowerdir/testdir1 "origin" 2>/dev/null`
 redirect_2=`check_redirect $lowerdir/testdir2 "origin" 2>/dev/null`
 [[ $redirect_1 == $redirect_2 ]] && echo "Redirect xattr incorrect"
@@ -223,12 +225,12 @@ make_test_dirs
 mkdir $lowerdir/origin $upperdir/origin
 make_redirect_dir $upperdir/testdir "origin"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 && \
-	echo "fsck should fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 4 ] || echo "fsck should fail to correct errors"
 
 # Question get yes answer: Duplicate redirect directory, remove xattr ?
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 check_no_redirect $upperdir/testdir
 
 # Test duplicate redirect xattr with lower same name directory exists,
@@ -240,8 +242,8 @@ make_redirect_dir $upperdir/testdir "invalid"
 
 # Question one get yes answer: Duplicate redirect directory, remove xattr?
 # Question two get yes answer: Should set opaque dir ?
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 check_no_redirect $upperdir/testdir
 check_opaque $upperdir/testdir
 
diff --git a/tests/overlay/056 b/tests/overlay/056
index 44ffb54a..9fccaaea 100755
--- a/tests/overlay/056
+++ b/tests/overlay/056
@@ -96,8 +96,8 @@ $UMOUNT_PROG $SCRATCH_MNT
 remove_impure $upperdir/testdir1
 remove_impure $upperdir/testdir2
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 check_impure $upperdir/testdir1
 check_impure $upperdir/testdir2
 
@@ -108,8 +108,8 @@ make_test_dirs
 mkdir $lowerdir/origin
 make_redirect_dir $upperdir/testdir/subdir "/origin"
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 check_impure $upperdir/testdir
 
 # Test missing impure xattr in directory which has merge directories,
@@ -118,8 +118,8 @@ echo "+ Missing impure(3)"
 make_test_dirs
 mkdir $lowerdir/testdir $upperdir/testdir
 
-_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
-	echo "fsck should not fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1
+[ $? = 1 ] || echo "fsck should correct errors"
 check_impure $upperdir
 
 # success, all done
-- 
2.17.1

Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 4/4] overlay: fix exit code for some fsck.overlay valid cases
Date: Tue, 28 May 2019 18:17:23 +0300
Message-Id: <20190528151723.12525-5-amir73il@gmail.com>
In-Reply-To: <20190528151723.12525-1-amir73il@gmail.com>
References: <20190528151723.12525-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: "zhangyi (F)" <yi.zhang@huawei.com>

Some valid test cases about fsck.overlay may be not valid enough now,
they lose the impure xattr on the parent directory of the simluated
redirect directory, and lose the whiteout which use to cover the origin
lower object. Then fsck.overlay will fix these two inconsistency which
are not those test cases want to cover, thus it will lead to
fsck.overlay return FSCK_NONDESTRUCT instead of FSCK_OK. Fix these by
complement the missing overlay related features.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/045 | 19 ++++++++++++++++---
 tests/overlay/046 | 13 +++++++++++++
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/tests/overlay/045 b/tests/overlay/045
index 6b5e8ae4..34b7ce4c 100755
--- a/tests/overlay/045
+++ b/tests/overlay/045
@@ -37,6 +37,7 @@ _require_attrs
 _require_command "$FSCK_OVERLAY_PROG" fsck.overlay
 
 OVL_XATTR_OPAQUE_VAL=y
+OVL_XATTR_IMPURE_VAL=y
 
 # remove all files from previous tests
 _scratch_mkfs
@@ -69,6 +70,15 @@ make_opaque_dir()
 	$SETFATTR_PROG -n $OVL_XATTR_OPAQUE -v $OVL_XATTR_OPAQUE_VAL $target
 }
 
+# Create impure directories
+make_impure_dir()
+{
+	for dir in $*; do
+		mkdir -p $dir
+		$SETFATTR_PROG -n $OVL_XATTR_IMPURE -v $OVL_XATTR_IMPURE_VAL $dir
+	done
+}
+
 # Create a redirect directory
 make_redirect_dir()
 {
@@ -155,8 +165,9 @@ echo "+ Valid whiteout(2)"
 make_test_dirs
 mkdir $lowerdir/origin
 touch $lowerdir/origin/foo
+make_impure_dir $upperdir
 make_redirect_dir $upperdir/testdir "origin"
-make_whiteout $upperdir/testdir/foo
+make_whiteout $upperdir/origin $upperdir/testdir/foo
 
 _overlay_fsck_expect $FSCK_OK $lowerdir $upperdir $workdir -p
 check_whiteout $upperdir/testdir/foo
@@ -169,7 +180,8 @@ mkdir -p $lowerdir2/origin/subdir
 touch $lowerdir2/origin/subdir/foo
 make_redirect_dir $lowerdir/testdir "origin"
 mkdir -p $upperdir/testdir/subdir
-make_whiteout $upperdir/testdir/subdir/foo
+make_whiteout $lowerdir/origin $upperdir/testdir/subdir/foo
+make_impure_dir $upperdir/testdir $upperdir
 
 _overlay_fsck_expect $FSCK_OK "$lowerdir:$lowerdir2" $upperdir $workdir -p
 check_whiteout $upperdir/testdir/subdir/foo
@@ -195,7 +207,8 @@ mkdir $lowerdir/origin
 touch $lowerdir/origin/foo
 make_opaque_dir $upperdir/testdir
 make_redirect_dir $upperdir/testdir/subdir "/origin"
-make_whiteout $upperdir/testdir/subdir/foo
+make_whiteout $upperdir/origin $upperdir/testdir/subdir/foo
+make_impure_dir $upperdir/testdir
 
 _overlay_fsck_expect $FSCK_OK $lowerdir $upperdir $workdir -p
 check_whiteout $upperdir/testdir/subdir/foo
diff --git a/tests/overlay/046 b/tests/overlay/046
index 4a9ee68f..36c74207 100755
--- a/tests/overlay/046
+++ b/tests/overlay/046
@@ -40,6 +40,16 @@ _require_command "$FSCK_OVERLAY_PROG" fsck.overlay
 _scratch_mkfs
 
 OVL_XATTR_OPAQUE_VAL=y
+OVL_XATTR_IMPURE_VAL=y
+
+# Create impure directories
+make_impure_dir()
+{
+	for dir in $*; do
+		mkdir -p $dir
+		$SETFATTR_PROG -n $OVL_XATTR_IMPURE -v $OVL_XATTR_IMPURE_VAL $dir
+	done
+}
 
 # Create a redirect directory
 make_redirect_dir()
@@ -140,6 +150,7 @@ make_test_dirs
 mkdir $lowerdir/origin
 make_whiteout $upperdir/origin
 make_redirect_dir $upperdir/testdir "origin"
+make_impure_dir $upperdir
 
 _overlay_fsck_expect $FSCK_OK $lowerdir $upperdir $workdir -p
 check_redirect $upperdir/testdir "origin"
@@ -151,6 +162,7 @@ make_test_dirs
 mkdir $lowerdir/origin
 make_whiteout $upperdir/origin
 make_redirect_dir $upperdir/testdir1/testdir2 "/origin"
+make_impure_dir $upperdir/testdir1
 
 _overlay_fsck_expect $FSCK_OK $lowerdir $upperdir $workdir -p
 check_redirect $upperdir/testdir1/testdir2 "/origin"
@@ -172,6 +184,7 @@ make_test_dirs
 mkdir $lowerdir/{testdir1,testdir2}
 make_redirect_dir $upperdir/testdir1 "testdir2"
 make_redirect_dir $upperdir/testdir2 "testdir1"
+make_impure_dir $upperdir
 
 _overlay_fsck_expect $FSCK_OK $lowerdir $upperdir $workdir -p
 check_redirect $upperdir/testdir1 "testdir2"
-- 
2.17.1

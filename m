From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 04/10] overlay: rename OVERLAY_LOWER/UPPER/WORK_DIR
Date: Thu, 16 Feb 2017 21:57:02 +0200
Message-ID: <1487275028-29885-5-git-send-email-amir73il@gmail.com>
References: <1487275028-29885-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35986 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933136AbdBPT50 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Feb 2017 14:57:26 -0500
In-Reply-To: <1487275028-29885-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

As preparation step for configuring test/scratch base fs
for overlay tests:

- Rename OVERLAY_LOWER/UPPER/WORK_DIR => OVL_LOWER/UPPER/WORK
  because we want to use OVL_ prefix for all base fs vars

- Prepend "ovl-" prefix to lower/upper/work path values to
  isolate the overlay test dirs when running on a base fs
  that is also used to run non overlay tests

- Make those vars values constant, because lower/upper/work
  directory names are an internal test detail which should
  not concern the user and because we wish to simplify
  and document the overlay tests setup

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/config     |  8 +++++---
 common/rc         | 19 +++++++++++++------
 tests/overlay/001 |  2 +-
 tests/overlay/002 |  2 +-
 tests/overlay/003 |  2 +-
 tests/overlay/004 |  4 ++--
 tests/overlay/006 | 10 +++++-----
 tests/overlay/008 |  8 ++++----
 tests/overlay/009 |  2 +-
 tests/overlay/010 |  8 ++++----
 tests/overlay/011 |  4 ++--
 tests/overlay/012 |  4 ++--
 tests/overlay/013 |  4 ++--
 tests/overlay/015 |  2 +-
 tests/overlay/016 |  2 +-
 tests/overlay/017 |  2 +-
 tests/overlay/018 |  2 +-
 tests/overlay/019 |  2 +-
 tests/overlay/020 |  2 +-
 tests/overlay/021 |  2 +-
 20 files changed, 50 insertions(+), 41 deletions(-)

diff --git a/common/config b/common/config
index bfd6429..a7ab2d9 100644
--- a/common/config
+++ b/common/config
@@ -77,9 +77,11 @@ export XFS_MKFS_OPTIONS=${XFS_MKFS_OPTIONS:=-bsize=4096}
 export TIME_FACTOR=${TIME_FACTOR:=1}
 export LOAD_FACTOR=${LOAD_FACTOR:=1}
 export DEBUGFS_MNT=${DEBUGFS_MNT:="/sys/kernel/debug"}
-export OVERLAY_UPPER_DIR=${OVERLAY_UPPER_DIR:="upper"}
-export OVERLAY_LOWER_DIR=${OVERLAY_LOWER_DIR:="lower"}
-export OVERLAY_WORK_DIR=${OVERLAY_WORK_DIR:="work"}
+
+# some constants for overlayfs setup
+export OVL_UPPER="ovl-upper"
+export OVL_LOWER="ovl-lower"
+export OVL_WORK="ovl-work"
 
 export PWD=`pwd`
 #export DEBUG=${DEBUG:=...} # arbitrary CFLAGS really.
diff --git a/common/rc b/common/rc
index debef5e..45e7202 100644
--- a/common/rc
+++ b/common/rc
@@ -242,7 +242,7 @@ _common_dev_mount_options()
 
 _overlay_basic_mount_options()
 {
-	echo "-o lowerdir=$1/$OVERLAY_LOWER_DIR,upperdir=$1/$OVERLAY_UPPER_DIR,workdir=$1/$OVERLAY_WORK_DIR"
+	echo "-o lowerdir=$1/$OVL_LOWER,upperdir=$1/$OVL_UPPER,workdir=$1/$OVL_WORK"
 }
 
 _overlay_mount_options()
@@ -301,6 +301,15 @@ _overlay_mount_dirs()
 		    -o workdir=$workdir $*
 }
 
+_overlay_mkdirs()
+{
+	local dir=$1
+
+	mkdir -p $dir/$OVL_UPPER
+	mkdir -p $dir/$OVL_LOWER
+	mkdir -p $dir/$OVL_WORK
+}
+
 # Given a dir, set up 3 subdirectories and mount on the given mnt.
 # The dir is used as the mount device so it can be seen from df or mount
 _overlay_mount()
@@ -311,12 +320,10 @@ _overlay_mount()
 
 	_supports_filetype $dir || _notrun "upper fs needs to support d_type"
 
-	mkdir -p $dir/$OVERLAY_UPPER_DIR
-	mkdir -p $dir/$OVERLAY_LOWER_DIR
-	mkdir -p $dir/$OVERLAY_WORK_DIR
+	_overlay_mkdirs $dir
 
-	_overlay_mount_dirs $dir/$OVERLAY_LOWER_DIR $dir/$OVERLAY_UPPER_DIR \
-			    $dir/$OVERLAY_WORK_DIR $OVERLAY_MOUNT_OPTIONS \
+	_overlay_mount_dirs $dir/$OVL_LOWER $dir/$OVL_UPPER \
+			    $dir/$OVL_WORK $OVERLAY_MOUNT_OPTIONS \
 			    $SELINUX_MOUNT_OPTIONS $* $dir $mnt
 }
 
diff --git a/tests/overlay/001 b/tests/overlay/001
index 7be9ae5..099ddd5 100755
--- a/tests/overlay/001
+++ b/tests/overlay/001
@@ -60,7 +60,7 @@ _scratch_mkfs
 _require_fs_space $SCRATCH_DEV $((4*1024*1024*2 + 8))
 
 # Create test files with different sizes in lower dir
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
 mkdir -p $lowerdir
 touch $lowerdir/zero_size
 $XFS_IO_PROG -fc "pwrite 0 4k" $lowerdir/less_than_4g >>$seqres.full
diff --git a/tests/overlay/002 b/tests/overlay/002
index ec7874e..eaf9a91 100755
--- a/tests/overlay/002
+++ b/tests/overlay/002
@@ -59,7 +59,7 @@ _require_scratch
 _scratch_mkfs
 
 # Create our test file.
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
 mkdir -p $lowerdir
 touch $lowerdir/foobar
 
diff --git a/tests/overlay/003 b/tests/overlay/003
index fbc242a..5e610c8 100755
--- a/tests/overlay/003
+++ b/tests/overlay/003
@@ -60,7 +60,7 @@ _require_scratch
 _scratch_mkfs
 
 # Create test files dirs in lower dir
-lowerdir=${SCRATCH_DEV}/${OVERLAY_LOWER_DIR}
+lowerdir=${SCRATCH_DEV}/${OVL_LOWER}
 mkdir -p $lowerdir
 
 touch ${lowerdir}/test_file
diff --git a/tests/overlay/004 b/tests/overlay/004
index 4075094..8da5170 100755
--- a/tests/overlay/004
+++ b/tests/overlay/004
@@ -53,8 +53,8 @@ _require_user
 _scratch_mkfs
 
 # Create test file in lower dir
-lowerdir=${SCRATCH_DEV}/${OVERLAY_LOWER_DIR}
-upperdir=${SCRATCH_DEV}/${OVERLAY_UPPER_DIR}
+lowerdir=${SCRATCH_DEV}/${OVL_LOWER}
+upperdir=${SCRATCH_DEV}/${OVL_UPPER}
 mkdir -p $lowerdir
 touch ${lowerdir}/attr_file1
 chmod 000 ${lowerdir}/attr_file1
diff --git a/tests/overlay/006 b/tests/overlay/006
index 31f11ef..55fc2dd 100755
--- a/tests/overlay/006
+++ b/tests/overlay/006
@@ -57,15 +57,15 @@ echo "Silence is golden"
 _scratch_mkfs
 
 # Create test file/dir before mount
-mkdir $SCRATCH_DEV/$OVERLAY_LOWER_DIR
-mkdir $SCRATCH_DEV/$OVERLAY_UPPER_DIR
-touch $SCRATCH_DEV/$OVERLAY_LOWER_DIR/lowertestfile
-mkdir $SCRATCH_DEV/$OVERLAY_UPPER_DIR/uppertestdir
+mkdir -p $SCRATCH_DEV/$OVL_LOWER
+mkdir -p $SCRATCH_DEV/$OVL_UPPER
+touch $SCRATCH_DEV/$OVL_LOWER/lowertestfile
+mkdir $SCRATCH_DEV/$OVL_UPPER/uppertestdir
 
 _scratch_mount
 
 # rename lowertestfile to uppertestdir, this triggers copyup and creates
-# whiteout in $OVERLAY_UPPER_DIR
+# whiteout in $OVL_UPPER
 mv $SCRATCH_MNT/lowertestfile $SCRATCH_MNT/uppertestdir
 # the lowertestfile can be removed
 rm $SCRATCH_MNT/uppertestdir/lowertestfile
diff --git a/tests/overlay/008 b/tests/overlay/008
index cb8667c..b81cff8 100755
--- a/tests/overlay/008
+++ b/tests/overlay/008
@@ -56,14 +56,14 @@ _require_user
 _scratch_mkfs
 
 # Create test file on lower dir, and chown to fsgqa user
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
-mkdir $lowerdir
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
+mkdir -p $lowerdir
 touch $lowerdir/testfile
 chown fsgqa:fsgqa $lowerdir/testfile
 
 # chown upperdir to fsgqa user, so new file/dir can be created by the user
-upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
-mkdir $upperdir
+upperdir=$SCRATCH_DEV/$OVL_UPPER
+mkdir -p $upperdir
 chown fsgqa:fsgqa $upperdir
 
 _scratch_mount
diff --git a/tests/overlay/009 b/tests/overlay/009
index de94ca4..bdac6b7 100755
--- a/tests/overlay/009
+++ b/tests/overlay/009
@@ -54,7 +54,7 @@ _require_scratch
 _scratch_mkfs
 
 # Create test file in lowerdir
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
 mkdir -p $lowerdir
 touch $lowerdir/testfile
 
diff --git a/tests/overlay/010 b/tests/overlay/010
index a302d74..5882db9 100755
--- a/tests/overlay/010
+++ b/tests/overlay/010
@@ -55,10 +55,10 @@ _scratch_mkfs
 
 # Need two lower dirs in this test, and we mount overlay ourselves,
 # create upper and workdir as well
-lowerdir1=$SCRATCH_DEV/$OVERLAY_LOWER_DIR.1
-lowerdir2=$SCRATCH_DEV/$OVERLAY_LOWER_DIR.2
-upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
-workdir=$SCRATCH_DEV/$OVERLAY_WORK_DIR
+lowerdir1=$SCRATCH_DEV/$OVL_LOWER.1
+lowerdir2=$SCRATCH_DEV/$OVL_LOWER.2
+upperdir=$SCRATCH_DEV/$OVL_UPPER
+workdir=$SCRATCH_DEV/$OVL_WORK
 mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 
 # One lowerdir contains test dir and test files, the other contains whiteout
diff --git a/tests/overlay/011 b/tests/overlay/011
index 4b697b8..1d6c44a 100755
--- a/tests/overlay/011
+++ b/tests/overlay/011
@@ -58,8 +58,8 @@ _require_attrs
 _scratch_mkfs
 
 # Create test dir on upper and make it opaque by setting proper xattr
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
-upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
+upperdir=$SCRATCH_DEV/$OVL_UPPER
 mkdir -p $lowerdir/testdir
 mkdir -p $upperdir/testdir
 $SETFATTR_PROG -n "trusted.overlay.opaque" -v "y" $upperdir/testdir
diff --git a/tests/overlay/012 b/tests/overlay/012
index cfe16f2..1c4f7c6 100755
--- a/tests/overlay/012
+++ b/tests/overlay/012
@@ -55,8 +55,8 @@ _require_scratch
 # remove all files from previous runs
 _scratch_mkfs
 
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
-upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
+upperdir=$SCRATCH_DEV/$OVL_UPPER
 mkdir -p $lowerdir/test
 
 _scratch_mount
diff --git a/tests/overlay/013 b/tests/overlay/013
index e99e10a..536e981 100755
--- a/tests/overlay/013
+++ b/tests/overlay/013
@@ -54,8 +54,8 @@ _require_test_program "t_truncate_self"
 _scratch_mkfs
 
 # copy test program to lower and upper dir
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
-upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
+upperdir=$SCRATCH_DEV/$OVL_UPPER
 mkdir -p $lowerdir
 mkdir -p $upperdir
 cp $here/src/t_truncate_self $lowerdir/test_lower
diff --git a/tests/overlay/015 b/tests/overlay/015
index c39caed..0e09e0c 100755
--- a/tests/overlay/015
+++ b/tests/overlay/015
@@ -57,7 +57,7 @@ _scratch_mkfs
 umask 022
 
 # Create test dir in lower dir and set sgid bit
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
 mkdir -p $lowerdir/dir
 chown $qa_user:$qa_group $lowerdir/dir
 chmod 2775 $lowerdir/dir
diff --git a/tests/overlay/016 b/tests/overlay/016
index cffcde7..c678ea4 100755
--- a/tests/overlay/016
+++ b/tests/overlay/016
@@ -57,7 +57,7 @@ rm -f $seqres.full
 _scratch_mkfs >>$seqres.full 2>&1
 
 # Create our test files.
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
 mkdir -p $lowerdir
 echo "This is old news" > $lowerdir/foo
 echo "This is old news" > $lowerdir/bar
diff --git a/tests/overlay/017 b/tests/overlay/017
index 5330de2..6b12722 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -60,7 +60,7 @@ _scratch_mkfs >>$seqres.full 2>&1
 # Not dealing with hardlinks here, because there is more to test
 # then stable inode number.
 # Hardlinks will get a test of their own.
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
 mkdir -p $lowerdir
 mkdir $lowerdir/dir
 touch $lowerdir/file
diff --git a/tests/overlay/018 b/tests/overlay/018
index df631fc..37bf11c 100755
--- a/tests/overlay/018
+++ b/tests/overlay/018
@@ -55,7 +55,7 @@ rm -f $seqres.full
 _scratch_mkfs >>$seqres.full 2>&1
 
 # Create 2 hardlinked files in lower
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
 mkdir -p $lowerdir
 echo "patient zero" >> $lowerdir/foo
 ln $lowerdir/foo $lowerdir/bar
diff --git a/tests/overlay/019 b/tests/overlay/019
index 41ce63b..9177acb 100755
--- a/tests/overlay/019
+++ b/tests/overlay/019
@@ -51,7 +51,7 @@ _require_scratch
 # Remove all files from previous tests
 _scratch_mkfs
 
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
 mkdir -p $lowerdir
 
 _scratch_mount
diff --git a/tests/overlay/020 b/tests/overlay/020
index 4afd40a..3cd0f05 100755
--- a/tests/overlay/020
+++ b/tests/overlay/020
@@ -55,7 +55,7 @@ _require_scratch
 # Remove all files from previous tests
 _scratch_mkfs
 
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
 mkdir -p $lowerdir/dir
 
 _scratch_mount
diff --git a/tests/overlay/021 b/tests/overlay/021
index c79bb01..c6d68aa 100755
--- a/tests/overlay/021
+++ b/tests/overlay/021
@@ -60,7 +60,7 @@ _scratch_mkfs
 # conservative and reserve space for 16 data copy ups per directory.
 _require_fs_space $SCRATCH_DEV $((16*(16+32+64+128)*1024))
 
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_DEV/$OVL_LOWER
 mkdir -p $lowerdir
 
 testdir=arena
-- 
2.7.4

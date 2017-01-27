From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/3] overlay: use SCRATCH_BASE_DIR instead of SCRATCH_DEV
Date: Fri, 27 Jan 2017 10:56:04 +0200
Message-ID: <1485507365-29012-3-git-send-email-amir73il@gmail.com>
References: <1485507365-29012-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33582 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932358AbdA0Kix (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Jan 2017 05:38:53 -0500
In-Reply-To: <1485507365-29012-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Use the new canonical var SCRATCH_BASE_DIR to refer to overlay
base dir instead of the old 'fake' SCRATCH_DEV var.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/001 |  7 +++----
 tests/overlay/002 |  2 +-
 tests/overlay/003 |  2 +-
 tests/overlay/004 |  4 ++--
 tests/overlay/005 | 30 +++++++++++++++---------------
 tests/overlay/006 |  8 ++++----
 tests/overlay/008 |  4 ++--
 tests/overlay/009 |  2 +-
 tests/overlay/010 | 10 +++++-----
 tests/overlay/011 |  4 ++--
 tests/overlay/012 |  4 ++--
 tests/overlay/013 |  4 ++--
 tests/overlay/014 | 14 +++++++-------
 tests/overlay/015 |  2 +-
 tests/overlay/016 |  2 +-
 tests/overlay/017 |  2 +-
 tests/overlay/018 |  2 +-
 tests/overlay/019 |  2 +-
 tests/overlay/020 |  2 +-
 tests/overlay/021 |  6 +++---
 20 files changed, 56 insertions(+), 57 deletions(-)

diff --git a/tests/overlay/001 b/tests/overlay/001
index 7be9ae5..462b83c 100755
--- a/tests/overlay/001
+++ b/tests/overlay/001
@@ -55,12 +55,11 @@ _require_scratch
 _scratch_mkfs
 
 # overlay copy_up doesn't deal with sparse file well, holes will be filled by
-# zeros, so at least (4G + 4G + 8k) free space is needed on $SCRATCH_DEV,
-# where $SCRATCH_DEV is actually a test dir used in overlay testing
-_require_fs_space $SCRATCH_DEV $((4*1024*1024*2 + 8))
+# zeros, so at least (4G + 4G + 8k) free space is needed on $SCRATCH_BASE_DIR
+_require_fs_space $SCRATCH_BASE_DIR $((4*1024*1024*2 + 8))
 
 # Create test files with different sizes in lower dir
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
 mkdir -p $lowerdir
 touch $lowerdir/zero_size
 $XFS_IO_PROG -fc "pwrite 0 4k" $lowerdir/less_than_4g >>$seqres.full
diff --git a/tests/overlay/002 b/tests/overlay/002
index ec7874e..391e755 100755
--- a/tests/overlay/002
+++ b/tests/overlay/002
@@ -59,7 +59,7 @@ _require_scratch
 _scratch_mkfs
 
 # Create our test file.
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
 mkdir -p $lowerdir
 touch $lowerdir/foobar
 
diff --git a/tests/overlay/003 b/tests/overlay/003
index fbc242a..bb59700 100755
--- a/tests/overlay/003
+++ b/tests/overlay/003
@@ -60,7 +60,7 @@ _require_scratch
 _scratch_mkfs
 
 # Create test files dirs in lower dir
-lowerdir=${SCRATCH_DEV}/${OVERLAY_LOWER_DIR}
+lowerdir=${SCRATCH_BASE_DIR}/${OVERLAY_LOWER_DIR}
 mkdir -p $lowerdir
 
 touch ${lowerdir}/test_file
diff --git a/tests/overlay/004 b/tests/overlay/004
index 4075094..6d78f9f 100755
--- a/tests/overlay/004
+++ b/tests/overlay/004
@@ -53,8 +53,8 @@ _require_user
 _scratch_mkfs
 
 # Create test file in lower dir
-lowerdir=${SCRATCH_DEV}/${OVERLAY_LOWER_DIR}
-upperdir=${SCRATCH_DEV}/${OVERLAY_UPPER_DIR}
+lowerdir=${SCRATCH_BASE_DIR}/${OVERLAY_LOWER_DIR}
+upperdir=${SCRATCH_BASE_DIR}/${OVERLAY_UPPER_DIR}
 mkdir -p $lowerdir
 touch ${lowerdir}/attr_file1
 chmod 000 ${lowerdir}/attr_file1
diff --git a/tests/overlay/005 b/tests/overlay/005
index baadb69..d037335 100755
--- a/tests/overlay/005
+++ b/tests/overlay/005
@@ -61,31 +61,31 @@ _require_loop
 _scratch_mkfs
 
 # setup loop images fs for overlayfs
-lower_img=${SCRATCH_DEV}/${seq}.$$.img
+lower_img=${SCRATCH_BASE_DIR}/${seq}.$$.img
 $XFS_IO_PROG -f -c "truncate 120m" $lower_img >>$seqres.full 2>&1
 fs_loop_dev=`_create_loop_device $lower_img`
 $MKFS_XFS_PROG -f -n ftype=1 $fs_loop_dev >>$seqres.full 2>&1
 
 # only 20m for upper dir
-upper_img=${SCRATCH_DEV}/$$.${seq}.img
+upper_img=${SCRATCH_BASE_DIR}/$$.${seq}.img
 $XFS_IO_PROG -f -c "truncate 20m" $upper_img >>$seqres.full 2>&1
 upper_loop_dev=`_create_loop_device $upper_img`
 $MKFS_XFS_PROG -f -n ftype=1 $upper_loop_dev >>$seqres.full 2>&1
 
 # mount underlying xfs
-mkdir -p ${SCRATCH_DEV}/lowermnt
-mkdir -p ${SCRATCH_DEV}/uppermnt
-$MOUNT_PROG $fs_loop_dev ${SCRATCH_DEV}/lowermnt
-$MOUNT_PROG $upper_loop_dev ${SCRATCH_DEV}/uppermnt
+mkdir -p ${SCRATCH_BASE_DIR}/lowermnt
+mkdir -p ${SCRATCH_BASE_DIR}/uppermnt
+$MOUNT_PROG $fs_loop_dev ${SCRATCH_BASE_DIR}/lowermnt
+$MOUNT_PROG $upper_loop_dev ${SCRATCH_BASE_DIR}/uppermnt
 
 # prepare dirs
-mkdir -p ${SCRATCH_DEV}/lowermnt/lower
-mkdir -p ${SCRATCH_DEV}/uppermnt/upper
-mkdir -p ${SCRATCH_DEV}/uppermnt/work
+mkdir -p ${SCRATCH_BASE_DIR}/lowermnt/lower
+mkdir -p ${SCRATCH_BASE_DIR}/uppermnt/upper
+mkdir -p ${SCRATCH_BASE_DIR}/uppermnt/work
 
-lowerd=${SCRATCH_DEV}/lowermnt/lower
-upperd=${SCRATCH_DEV}/uppermnt/upper
-workd=${SCRATCH_DEV}/uppermnt/work
+lowerd=${SCRATCH_BASE_DIR}/lowermnt/lower
+upperd=${SCRATCH_BASE_DIR}/uppermnt/upper
+workd=${SCRATCH_BASE_DIR}/uppermnt/work
 
 # Create test file in lower dir, with too big a size for
 # upper dir to copy up.
@@ -93,7 +93,7 @@ $XFS_IO_PROG -f -c "truncate 48m" ${lowerd}/test_file \
 	>>$seqres.full 2>&1
 
 # mount new overlayfs
-_overlay_mount_dirs $lowerd $upperd $workd $SCRATCH_DEV $SCRATCH_MNT
+_overlay_mount_dirs $lowerd $upperd $workd $SCRATCH_BASE_DIR $SCRATCH_MNT
 
 # the open call triggers copy-up and it will fail ENOSPC
 $XFS_IO_PROG -f -c "o" ${SCRATCH_MNT}/test_file \
@@ -103,8 +103,8 @@ $XFS_IO_PROG -f -c "o" ${SCRATCH_MNT}/test_file \
 $UMOUNT_PROG $SCRATCH_MNT
 
 # unmount undelying xfs, this tiggers panic if memleak happens
-$UMOUNT_PROG ${SCRATCH_DEV}/uppermnt
-$UMOUNT_PROG ${SCRATCH_DEV}/lowermnt
+$UMOUNT_PROG ${SCRATCH_BASE_DIR}/uppermnt
+$UMOUNT_PROG ${SCRATCH_BASE_DIR}/lowermnt
 
 # success, all done
 echo "Silence is golden"
diff --git a/tests/overlay/006 b/tests/overlay/006
index 31f11ef..9450ef9 100755
--- a/tests/overlay/006
+++ b/tests/overlay/006
@@ -57,10 +57,10 @@ echo "Silence is golden"
 _scratch_mkfs
 
 # Create test file/dir before mount
-mkdir $SCRATCH_DEV/$OVERLAY_LOWER_DIR
-mkdir $SCRATCH_DEV/$OVERLAY_UPPER_DIR
-touch $SCRATCH_DEV/$OVERLAY_LOWER_DIR/lowertestfile
-mkdir $SCRATCH_DEV/$OVERLAY_UPPER_DIR/uppertestdir
+mkdir $SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
+mkdir $SCRATCH_BASE_DIR/$OVERLAY_UPPER_DIR
+touch $SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR/lowertestfile
+mkdir $SCRATCH_BASE_DIR/$OVERLAY_UPPER_DIR/uppertestdir
 
 _scratch_mount
 
diff --git a/tests/overlay/008 b/tests/overlay/008
index cb8667c..9219b41 100755
--- a/tests/overlay/008
+++ b/tests/overlay/008
@@ -56,13 +56,13 @@ _require_user
 _scratch_mkfs
 
 # Create test file on lower dir, and chown to fsgqa user
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
 mkdir $lowerdir
 touch $lowerdir/testfile
 chown fsgqa:fsgqa $lowerdir/testfile
 
 # chown upperdir to fsgqa user, so new file/dir can be created by the user
-upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
+upperdir=$SCRATCH_BASE_DIR/$OVERLAY_UPPER_DIR
 mkdir $upperdir
 chown fsgqa:fsgqa $upperdir
 
diff --git a/tests/overlay/009 b/tests/overlay/009
index de94ca4..efc05ce 100755
--- a/tests/overlay/009
+++ b/tests/overlay/009
@@ -54,7 +54,7 @@ _require_scratch
 _scratch_mkfs
 
 # Create test file in lowerdir
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
 mkdir -p $lowerdir
 touch $lowerdir/testfile
 
diff --git a/tests/overlay/010 b/tests/overlay/010
index a302d74..4aeaa7b 100755
--- a/tests/overlay/010
+++ b/tests/overlay/010
@@ -55,10 +55,10 @@ _scratch_mkfs
 
 # Need two lower dirs in this test, and we mount overlay ourselves,
 # create upper and workdir as well
-lowerdir1=$SCRATCH_DEV/$OVERLAY_LOWER_DIR.1
-lowerdir2=$SCRATCH_DEV/$OVERLAY_LOWER_DIR.2
-upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
-workdir=$SCRATCH_DEV/$OVERLAY_WORK_DIR
+lowerdir1=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR.1
+lowerdir2=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR.2
+upperdir=$SCRATCH_BASE_DIR/$OVERLAY_UPPER_DIR
+workdir=$SCRATCH_BASE_DIR/$OVERLAY_WORK_DIR
 mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 
 # One lowerdir contains test dir and test files, the other contains whiteout
@@ -68,7 +68,7 @@ mknod $lowerdir2/testdir/a c 0 0
 
 # Mount overlayfs and remove testdir, which led to kernel crash
 _overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
-		    $SCRATCH_DEV $SCRATCH_MNT
+		    $SCRATCH_BASE_DIR $SCRATCH_MNT
 rm -rf $SCRATCH_MNT/testdir
 
 # success, all done
diff --git a/tests/overlay/011 b/tests/overlay/011
index 4b697b8..4f474d6 100755
--- a/tests/overlay/011
+++ b/tests/overlay/011
@@ -58,8 +58,8 @@ _require_attrs
 _scratch_mkfs
 
 # Create test dir on upper and make it opaque by setting proper xattr
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
-upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
+upperdir=$SCRATCH_BASE_DIR/$OVERLAY_UPPER_DIR
 mkdir -p $lowerdir/testdir
 mkdir -p $upperdir/testdir
 $SETFATTR_PROG -n "trusted.overlay.opaque" -v "y" $upperdir/testdir
diff --git a/tests/overlay/012 b/tests/overlay/012
index cfe16f2..339b2af 100755
--- a/tests/overlay/012
+++ b/tests/overlay/012
@@ -55,8 +55,8 @@ _require_scratch
 # remove all files from previous runs
 _scratch_mkfs
 
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
-upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
+upperdir=$SCRATCH_BASE_DIR/$OVERLAY_UPPER_DIR
 mkdir -p $lowerdir/test
 
 _scratch_mount
diff --git a/tests/overlay/013 b/tests/overlay/013
index e99e10a..b09a7d1 100755
--- a/tests/overlay/013
+++ b/tests/overlay/013
@@ -54,8 +54,8 @@ _require_test_program "t_truncate_self"
 _scratch_mkfs
 
 # copy test program to lower and upper dir
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
-upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
+upperdir=$SCRATCH_BASE_DIR/$OVERLAY_UPPER_DIR
 mkdir -p $lowerdir
 mkdir -p $upperdir
 cp $here/src/t_truncate_self $lowerdir/test_lower
diff --git a/tests/overlay/014 b/tests/overlay/014
index 36d7077..7426c31 100755
--- a/tests/overlay/014
+++ b/tests/overlay/014
@@ -61,16 +61,16 @@ _require_scratch
 _scratch_mkfs
 
 # Create multiple lowerdirs and upperdir, workdir, and testdir on lowerdir
-lowerdir1=$SCRATCH_DEV/lower1
-lowerdir2=$SCRATCH_DEV/lower2
-upperdir=$SCRATCH_DEV/upper
-workdir=$SCRATCH_DEV/workdir
+lowerdir1=$SCRATCH_BASE_DIR/lower1
+lowerdir2=$SCRATCH_BASE_DIR/lower2
+upperdir=$SCRATCH_BASE_DIR/upper
+workdir=$SCRATCH_BASE_DIR/workdir
 mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 mkdir -p $lowerdir1/testdir/d
 
 # mount overlay with $lowerdir2 as upperdir, and remove & recreate testdir,
 # make testdir on $lowerdir2 opaque
-_overlay_mount_dirs $lowerdir1 $lowerdir2 $workdir $SCRATCH_DEV $SCRATCH_MNT
+_overlay_mount_dirs $lowerdir1 $lowerdir2 $workdir $SCRATCH_BASE_DIR $SCRATCH_MNT
 rm -rf $SCRATCH_MNT/testdir
 mkdir -p $SCRATCH_MNT/testdir/visibledir
 _scratch_unmount
@@ -79,14 +79,14 @@ _scratch_unmount
 # and create a new file in testdir, triggers copyup from lowerdir,
 # copyup should not copy overlayfs private xattr
 _overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
-		    $SCRATCH_DEV $SCRATCH_MNT
+		    $SCRATCH_BASE_DIR $SCRATCH_MNT
 touch $SCRATCH_MNT/testdir/visiblefile
 
 # umount and mount overlay again, buggy kernel treats the copied-up dir as
 # opaque, visibledir is not seen in merged dir.
 _scratch_unmount
 _overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
-		    $SCRATCH_DEV $SCRATCH_MNT
+		    $SCRATCH_BASE_DIR $SCRATCH_MNT
 ls $SCRATCH_MNT/testdir
 
 # success, all done
diff --git a/tests/overlay/015 b/tests/overlay/015
index c39caed..e70930b 100755
--- a/tests/overlay/015
+++ b/tests/overlay/015
@@ -57,7 +57,7 @@ _scratch_mkfs
 umask 022
 
 # Create test dir in lower dir and set sgid bit
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
 mkdir -p $lowerdir/dir
 chown $qa_user:$qa_group $lowerdir/dir
 chmod 2775 $lowerdir/dir
diff --git a/tests/overlay/016 b/tests/overlay/016
index cffcde7..bb4366d 100755
--- a/tests/overlay/016
+++ b/tests/overlay/016
@@ -57,7 +57,7 @@ rm -f $seqres.full
 _scratch_mkfs >>$seqres.full 2>&1
 
 # Create our test files.
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
 mkdir -p $lowerdir
 echo "This is old news" > $lowerdir/foo
 echo "This is old news" > $lowerdir/bar
diff --git a/tests/overlay/017 b/tests/overlay/017
index 5330de2..f9c1bfc 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -60,7 +60,7 @@ _scratch_mkfs >>$seqres.full 2>&1
 # Not dealing with hardlinks here, because there is more to test
 # then stable inode number.
 # Hardlinks will get a test of their own.
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
 mkdir -p $lowerdir
 mkdir $lowerdir/dir
 touch $lowerdir/file
diff --git a/tests/overlay/018 b/tests/overlay/018
index df631fc..0b73e52 100755
--- a/tests/overlay/018
+++ b/tests/overlay/018
@@ -55,7 +55,7 @@ rm -f $seqres.full
 _scratch_mkfs >>$seqres.full 2>&1
 
 # Create 2 hardlinked files in lower
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
 mkdir -p $lowerdir
 echo "patient zero" >> $lowerdir/foo
 ln $lowerdir/foo $lowerdir/bar
diff --git a/tests/overlay/019 b/tests/overlay/019
index 41ce63b..1a6a4bd 100755
--- a/tests/overlay/019
+++ b/tests/overlay/019
@@ -51,7 +51,7 @@ _require_scratch
 # Remove all files from previous tests
 _scratch_mkfs
 
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
 mkdir -p $lowerdir
 
 _scratch_mount
diff --git a/tests/overlay/020 b/tests/overlay/020
index 4afd40a..189d83c 100755
--- a/tests/overlay/020
+++ b/tests/overlay/020
@@ -55,7 +55,7 @@ _require_scratch
 # Remove all files from previous tests
 _scratch_mkfs
 
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
 mkdir -p $lowerdir/dir
 
 _scratch_mount
diff --git a/tests/overlay/021 b/tests/overlay/021
index c79bb01..4d619c6 100755
--- a/tests/overlay/021
+++ b/tests/overlay/021
@@ -54,13 +54,13 @@ _scratch_mkfs
 
 # overlay copy_up doesn't deal with sparse file well, holes will be filled by
 # zeros, so for the worst case of hitting all the copy up bomb files, we need
-# (64*(16+32+64+128)M) free space on $SCRATCH_DEV.
+# (64*(16+32+64+128)M) free space on $SCRATCH_BASE_DIR.
 # However, triggering more than a total of 16 copy up bombs would require
 # really fast data copy (clone up doesn't take up space at all), so let's be
 # conservative and reserve space for 16 data copy ups per directory.
-_require_fs_space $SCRATCH_DEV $((16*(16+32+64+128)*1024))
+_require_fs_space $SCRATCH_BASE_DIR $((16*(16+32+64+128)*1024))
 
-lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+lowerdir=$SCRATCH_BASE_DIR/$OVERLAY_LOWER_DIR
 mkdir -p $lowerdir
 
 testdir=arena
-- 
2.7.4

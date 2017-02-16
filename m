From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 07/10] overlay: use OVL_BASE_SCRATCH_MNT instead of SCRATCH_DEV
Date: Thu, 16 Feb 2017 21:57:05 +0200
Message-ID: <1487275028-29885-8-git-send-email-amir73il@gmail.com>
References: <1487275028-29885-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33509 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933237AbdBPT5c (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Feb 2017 14:57:32 -0500
In-Reply-To: <1487275028-29885-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Use the new var OVL_BASE_SCRATCH_MNT to refer to overlay
base dir instead of the legacy SCRATCH_DEV var.

In overlay/011, when using MOUNT_PROG directly, provide
OVL_BASE_SCRATCH_MNT as device argument instead of 'none'.
This fix is required to support mount of base fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>

fix OVL_BASE_SCRATCH_MNT
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
 tests/overlay/011 |  6 +++---
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
 20 files changed, 57 insertions(+), 58 deletions(-)

diff --git a/tests/overlay/001 b/tests/overlay/001
index 099ddd5..c0abbfb 100755
--- a/tests/overlay/001
+++ b/tests/overlay/001
@@ -55,12 +55,11 @@ _require_scratch
 _scratch_mkfs
 
 # overlay copy_up doesn't deal with sparse file well, holes will be filled by
-# zeros, so at least (4G + 4G + 8k) free space is needed on $SCRATCH_DEV,
-# where $SCRATCH_DEV is actually a test dir used in overlay testing
-_require_fs_space $SCRATCH_DEV $((4*1024*1024*2 + 8))
+# zeros, so at least (4G + 4G + 8k) free space is needed on scratch base fs
+_require_fs_space $OVL_BASE_SCRATCH_MNT $((4*1024*1024*2 + 8))
 
 # Create test files with different sizes in lower dir
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 touch $lowerdir/zero_size
 $XFS_IO_PROG -fc "pwrite 0 4k" $lowerdir/less_than_4g >>$seqres.full
diff --git a/tests/overlay/002 b/tests/overlay/002
index eaf9a91..ffdec18 100755
--- a/tests/overlay/002
+++ b/tests/overlay/002
@@ -59,7 +59,7 @@ _require_scratch
 _scratch_mkfs
 
 # Create our test file.
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 touch $lowerdir/foobar
 
diff --git a/tests/overlay/003 b/tests/overlay/003
index 5e610c8..7c7f41b 100755
--- a/tests/overlay/003
+++ b/tests/overlay/003
@@ -60,7 +60,7 @@ _require_scratch
 _scratch_mkfs
 
 # Create test files dirs in lower dir
-lowerdir=${SCRATCH_DEV}/${OVL_LOWER}
+lowerdir=${OVL_BASE_SCRATCH_MNT}/${OVL_LOWER}
 mkdir -p $lowerdir
 
 touch ${lowerdir}/test_file
diff --git a/tests/overlay/004 b/tests/overlay/004
index 8da5170..bc08f34 100755
--- a/tests/overlay/004
+++ b/tests/overlay/004
@@ -53,8 +53,8 @@ _require_user
 _scratch_mkfs
 
 # Create test file in lower dir
-lowerdir=${SCRATCH_DEV}/${OVL_LOWER}
-upperdir=${SCRATCH_DEV}/${OVL_UPPER}
+lowerdir=${OVL_BASE_SCRATCH_MNT}/${OVL_LOWER}
+upperdir=${OVL_BASE_SCRATCH_MNT}/${OVL_UPPER}
 mkdir -p $lowerdir
 touch ${lowerdir}/attr_file1
 chmod 000 ${lowerdir}/attr_file1
diff --git a/tests/overlay/005 b/tests/overlay/005
index baadb69..f885fdc 100755
--- a/tests/overlay/005
+++ b/tests/overlay/005
@@ -61,31 +61,31 @@ _require_loop
 _scratch_mkfs
 
 # setup loop images fs for overlayfs
-lower_img=${SCRATCH_DEV}/${seq}.$$.img
+lower_img=${OVL_BASE_SCRATCH_MNT}/${seq}.$$.img
 $XFS_IO_PROG -f -c "truncate 120m" $lower_img >>$seqres.full 2>&1
 fs_loop_dev=`_create_loop_device $lower_img`
 $MKFS_XFS_PROG -f -n ftype=1 $fs_loop_dev >>$seqres.full 2>&1
 
 # only 20m for upper dir
-upper_img=${SCRATCH_DEV}/$$.${seq}.img
+upper_img=${OVL_BASE_SCRATCH_MNT}/$$.${seq}.img
 $XFS_IO_PROG -f -c "truncate 20m" $upper_img >>$seqres.full 2>&1
 upper_loop_dev=`_create_loop_device $upper_img`
 $MKFS_XFS_PROG -f -n ftype=1 $upper_loop_dev >>$seqres.full 2>&1
 
 # mount underlying xfs
-mkdir -p ${SCRATCH_DEV}/lowermnt
-mkdir -p ${SCRATCH_DEV}/uppermnt
-$MOUNT_PROG $fs_loop_dev ${SCRATCH_DEV}/lowermnt
-$MOUNT_PROG $upper_loop_dev ${SCRATCH_DEV}/uppermnt
+mkdir -p ${OVL_BASE_SCRATCH_MNT}/lowermnt
+mkdir -p ${OVL_BASE_SCRATCH_MNT}/uppermnt
+$MOUNT_PROG $fs_loop_dev ${OVL_BASE_SCRATCH_MNT}/lowermnt
+$MOUNT_PROG $upper_loop_dev ${OVL_BASE_SCRATCH_MNT}/uppermnt
 
 # prepare dirs
-mkdir -p ${SCRATCH_DEV}/lowermnt/lower
-mkdir -p ${SCRATCH_DEV}/uppermnt/upper
-mkdir -p ${SCRATCH_DEV}/uppermnt/work
+mkdir -p ${OVL_BASE_SCRATCH_MNT}/lowermnt/lower
+mkdir -p ${OVL_BASE_SCRATCH_MNT}/uppermnt/upper
+mkdir -p ${OVL_BASE_SCRATCH_MNT}/uppermnt/work
 
-lowerd=${SCRATCH_DEV}/lowermnt/lower
-upperd=${SCRATCH_DEV}/uppermnt/upper
-workd=${SCRATCH_DEV}/uppermnt/work
+lowerd=${OVL_BASE_SCRATCH_MNT}/lowermnt/lower
+upperd=${OVL_BASE_SCRATCH_MNT}/uppermnt/upper
+workd=${OVL_BASE_SCRATCH_MNT}/uppermnt/work
 
 # Create test file in lower dir, with too big a size for
 # upper dir to copy up.
@@ -93,7 +93,7 @@ $XFS_IO_PROG -f -c "truncate 48m" ${lowerd}/test_file \
 	>>$seqres.full 2>&1
 
 # mount new overlayfs
-_overlay_mount_dirs $lowerd $upperd $workd $SCRATCH_DEV $SCRATCH_MNT
+_overlay_mount_dirs $lowerd $upperd $workd $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 
 # the open call triggers copy-up and it will fail ENOSPC
 $XFS_IO_PROG -f -c "o" ${SCRATCH_MNT}/test_file \
@@ -103,8 +103,8 @@ $XFS_IO_PROG -f -c "o" ${SCRATCH_MNT}/test_file \
 $UMOUNT_PROG $SCRATCH_MNT
 
 # unmount undelying xfs, this tiggers panic if memleak happens
-$UMOUNT_PROG ${SCRATCH_DEV}/uppermnt
-$UMOUNT_PROG ${SCRATCH_DEV}/lowermnt
+$UMOUNT_PROG ${OVL_BASE_SCRATCH_MNT}/uppermnt
+$UMOUNT_PROG ${OVL_BASE_SCRATCH_MNT}/lowermnt
 
 # success, all done
 echo "Silence is golden"
diff --git a/tests/overlay/006 b/tests/overlay/006
index 55fc2dd..815657f 100755
--- a/tests/overlay/006
+++ b/tests/overlay/006
@@ -57,10 +57,10 @@ echo "Silence is golden"
 _scratch_mkfs
 
 # Create test file/dir before mount
-mkdir -p $SCRATCH_DEV/$OVL_LOWER
-mkdir -p $SCRATCH_DEV/$OVL_UPPER
-touch $SCRATCH_DEV/$OVL_LOWER/lowertestfile
-mkdir $SCRATCH_DEV/$OVL_UPPER/uppertestdir
+mkdir -p $OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+mkdir -p $OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+touch $OVL_BASE_SCRATCH_MNT/$OVL_LOWER/lowertestfile
+mkdir $OVL_BASE_SCRATCH_MNT/$OVL_UPPER/uppertestdir
 
 _scratch_mount
 
diff --git a/tests/overlay/008 b/tests/overlay/008
index b81cff8..d5bc1df 100755
--- a/tests/overlay/008
+++ b/tests/overlay/008
@@ -56,13 +56,13 @@ _require_user
 _scratch_mkfs
 
 # Create test file on lower dir, and chown to fsgqa user
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 touch $lowerdir/testfile
 chown fsgqa:fsgqa $lowerdir/testfile
 
 # chown upperdir to fsgqa user, so new file/dir can be created by the user
-upperdir=$SCRATCH_DEV/$OVL_UPPER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 mkdir -p $upperdir
 chown fsgqa:fsgqa $upperdir
 
diff --git a/tests/overlay/009 b/tests/overlay/009
index bdac6b7..f367887 100755
--- a/tests/overlay/009
+++ b/tests/overlay/009
@@ -54,7 +54,7 @@ _require_scratch
 _scratch_mkfs
 
 # Create test file in lowerdir
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 touch $lowerdir/testfile
 
diff --git a/tests/overlay/010 b/tests/overlay/010
index 5882db9..dee99cf 100755
--- a/tests/overlay/010
+++ b/tests/overlay/010
@@ -55,10 +55,10 @@ _scratch_mkfs
 
 # Need two lower dirs in this test, and we mount overlay ourselves,
 # create upper and workdir as well
-lowerdir1=$SCRATCH_DEV/$OVL_LOWER.1
-lowerdir2=$SCRATCH_DEV/$OVL_LOWER.2
-upperdir=$SCRATCH_DEV/$OVL_UPPER
-workdir=$SCRATCH_DEV/$OVL_WORK
+lowerdir1=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER.1
+lowerdir2=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER.2
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 
 # One lowerdir contains test dir and test files, the other contains whiteout
@@ -68,7 +68,7 @@ mknod $lowerdir2/testdir/a c 0 0
 
 # Mount overlayfs and remove testdir, which led to kernel crash
 _overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
-		    $SCRATCH_DEV $SCRATCH_MNT
+		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 rm -rf $SCRATCH_MNT/testdir
 
 # success, all done
diff --git a/tests/overlay/011 b/tests/overlay/011
index 1d6c44a..87ac17b 100755
--- a/tests/overlay/011
+++ b/tests/overlay/011
@@ -58,8 +58,8 @@ _require_attrs
 _scratch_mkfs
 
 # Create test dir on upper and make it opaque by setting proper xattr
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
-upperdir=$SCRATCH_DEV/$OVL_UPPER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 mkdir -p $lowerdir/testdir
 mkdir -p $upperdir/testdir
 $SETFATTR_PROG -n "trusted.overlay.opaque" -v "y" $upperdir/testdir
@@ -68,7 +68,7 @@ $SETFATTR_PROG -n "trusted.overlay.opaque" -v "y" $upperdir/testdir
 # $upperdir overlaid on top of $lowerdir, so that "trusted.overlay.opaque"
 # xattr should be honored and should not be listed
 # mount readonly, because there's no upper and workdir
-$MOUNT_PROG -t overlay -o ro -o lowerdir=$upperdir:$lowerdir none $SCRATCH_MNT
+$MOUNT_PROG -t overlay -o ro -o lowerdir=$upperdir:$lowerdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 
 # Dump trusted.overlay xattr, we should not see the "opaque" xattr
 $GETFATTR_PROG -d -m overlay $SCRATCH_MNT/testdir
diff --git a/tests/overlay/012 b/tests/overlay/012
index 1c4f7c6..9cf1526 100755
--- a/tests/overlay/012
+++ b/tests/overlay/012
@@ -55,8 +55,8 @@ _require_scratch
 # remove all files from previous runs
 _scratch_mkfs
 
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
-upperdir=$SCRATCH_DEV/$OVL_UPPER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 mkdir -p $lowerdir/test
 
 _scratch_mount
diff --git a/tests/overlay/013 b/tests/overlay/013
index 536e981..de0fc26 100755
--- a/tests/overlay/013
+++ b/tests/overlay/013
@@ -54,8 +54,8 @@ _require_test_program "t_truncate_self"
 _scratch_mkfs
 
 # copy test program to lower and upper dir
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
-upperdir=$SCRATCH_DEV/$OVL_UPPER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 mkdir -p $lowerdir
 mkdir -p $upperdir
 cp $here/src/t_truncate_self $lowerdir/test_lower
diff --git a/tests/overlay/014 b/tests/overlay/014
index 36d7077..491f735 100755
--- a/tests/overlay/014
+++ b/tests/overlay/014
@@ -61,16 +61,16 @@ _require_scratch
 _scratch_mkfs
 
 # Create multiple lowerdirs and upperdir, workdir, and testdir on lowerdir
-lowerdir1=$SCRATCH_DEV/lower1
-lowerdir2=$SCRATCH_DEV/lower2
-upperdir=$SCRATCH_DEV/upper
-workdir=$SCRATCH_DEV/workdir
+lowerdir1=$OVL_BASE_SCRATCH_MNT/lower1
+lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
 mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 mkdir -p $lowerdir1/testdir/d
 
 # mount overlay with $lowerdir2 as upperdir, and remove & recreate testdir,
 # make testdir on $lowerdir2 opaque
-_overlay_mount_dirs $lowerdir1 $lowerdir2 $workdir $SCRATCH_DEV $SCRATCH_MNT
+_overlay_mount_dirs $lowerdir1 $lowerdir2 $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 rm -rf $SCRATCH_MNT/testdir
 mkdir -p $SCRATCH_MNT/testdir/visibledir
 _scratch_unmount
@@ -79,14 +79,14 @@ _scratch_unmount
 # and create a new file in testdir, triggers copyup from lowerdir,
 # copyup should not copy overlayfs private xattr
 _overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
-		    $SCRATCH_DEV $SCRATCH_MNT
+		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 touch $SCRATCH_MNT/testdir/visiblefile
 
 # umount and mount overlay again, buggy kernel treats the copied-up dir as
 # opaque, visibledir is not seen in merged dir.
 _scratch_unmount
 _overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
-		    $SCRATCH_DEV $SCRATCH_MNT
+		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 ls $SCRATCH_MNT/testdir
 
 # success, all done
diff --git a/tests/overlay/015 b/tests/overlay/015
index 0e09e0c..4894097 100755
--- a/tests/overlay/015
+++ b/tests/overlay/015
@@ -57,7 +57,7 @@ _scratch_mkfs
 umask 022
 
 # Create test dir in lower dir and set sgid bit
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir/dir
 chown $qa_user:$qa_group $lowerdir/dir
 chmod 2775 $lowerdir/dir
diff --git a/tests/overlay/016 b/tests/overlay/016
index c678ea4..86a7d28 100755
--- a/tests/overlay/016
+++ b/tests/overlay/016
@@ -57,7 +57,7 @@ rm -f $seqres.full
 _scratch_mkfs >>$seqres.full 2>&1
 
 # Create our test files.
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 echo "This is old news" > $lowerdir/foo
 echo "This is old news" > $lowerdir/bar
diff --git a/tests/overlay/017 b/tests/overlay/017
index 6b12722..5ca3040 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -60,7 +60,7 @@ _scratch_mkfs >>$seqres.full 2>&1
 # Not dealing with hardlinks here, because there is more to test
 # then stable inode number.
 # Hardlinks will get a test of their own.
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 mkdir $lowerdir/dir
 touch $lowerdir/file
diff --git a/tests/overlay/018 b/tests/overlay/018
index 37bf11c..7e47732 100755
--- a/tests/overlay/018
+++ b/tests/overlay/018
@@ -55,7 +55,7 @@ rm -f $seqres.full
 _scratch_mkfs >>$seqres.full 2>&1
 
 # Create 2 hardlinked files in lower
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 echo "patient zero" >> $lowerdir/foo
 ln $lowerdir/foo $lowerdir/bar
diff --git a/tests/overlay/019 b/tests/overlay/019
index 9177acb..3e2bc4e 100755
--- a/tests/overlay/019
+++ b/tests/overlay/019
@@ -51,7 +51,7 @@ _require_scratch
 # Remove all files from previous tests
 _scratch_mkfs
 
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 
 _scratch_mount
diff --git a/tests/overlay/020 b/tests/overlay/020
index 3cd0f05..de3816c 100755
--- a/tests/overlay/020
+++ b/tests/overlay/020
@@ -55,7 +55,7 @@ _require_scratch
 # Remove all files from previous tests
 _scratch_mkfs
 
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir/dir
 
 _scratch_mount
diff --git a/tests/overlay/021 b/tests/overlay/021
index c6d68aa..1347f52 100755
--- a/tests/overlay/021
+++ b/tests/overlay/021
@@ -54,13 +54,13 @@ _scratch_mkfs
 
 # overlay copy_up doesn't deal with sparse file well, holes will be filled by
 # zeros, so for the worst case of hitting all the copy up bomb files, we need
-# (64*(16+32+64+128)M) free space on $SCRATCH_DEV.
+# (64*(16+32+64+128)M) free space on $OVL_BASE_SCRATCH_MNT.
 # However, triggering more than a total of 16 copy up bombs would require
 # really fast data copy (clone up doesn't take up space at all), so let's be
 # conservative and reserve space for 16 data copy ups per directory.
-_require_fs_space $SCRATCH_DEV $((16*(16+32+64+128)*1024))
+_require_fs_space $OVL_BASE_SCRATCH_MNT $((16*(16+32+64+128)*1024))
 
-lowerdir=$SCRATCH_DEV/$OVL_LOWER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 
 testdir=arena
-- 
2.7.4

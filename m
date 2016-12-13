From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay/01[6,8]: do not cd into $SCRATCH_MNT
Date: Tue, 13 Dec 2016 07:05:02 +0200
Message-ID: <1481605502-8361-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:35900 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbcLMFFZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Dec 2016 00:05:25 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

- Avoid cd into $SCRATCH_MNT
- Cleanup unneeded _cleanup()

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/016     | 21 +++++++--------------
 tests/overlay/016.out |  4 ++--
 tests/overlay/018     | 10 ++++------
 tests/overlay/018.out | 12 ++++++------
 4 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/tests/overlay/016 b/tests/overlay/016
index 041ab3d..c37a0d4 100755
--- a/tests/overlay/016
+++ b/tests/overlay/016
@@ -32,15 +32,9 @@ seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
-tmp=/tmp/$$
 status=1	# failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
+trap "exit \$status" 0 1 2 3 15
 
-_cleanup()
-{
-	cd /
-	rm -f $tmp.*
-}
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -64,7 +58,6 @@ echo "This is old news" > $lowerdir/bar
 
 _scratch_mount
 
-cd $SCRATCH_MNT
 
 #
 # case #1:
@@ -73,12 +66,12 @@ cd $SCRATCH_MNT
 # write to rwfd
 # read from rofd
 #
-$XFS_IO_PROG -r foo \
-	-C "open foo" \
+$XFS_IO_PROG -r $SCRATCH_MNT/foo \
+	-C "open $SCRATCH_MNT/foo" \
 	-C "pwrite -S 0x61 0 16" \
 	-C "file 0" \
 	-C "pread -v 0 16" \
-| _filter_xfs_io
+| _filter_xfs_io | _filter_scratch
 
 #
 # case #2:
@@ -86,12 +79,12 @@ $XFS_IO_PROG -r foo \
 # write to rwfd
 # read from mapped memory
 #
-$XFS_IO_PROG -r bar \
+$XFS_IO_PROG -r $SCRATCH_MNT/bar \
 	-C "mmap -r 0 16" \
-	-C "open bar" \
+	-C "open $SCRATCH_MNT/bar" \
 	-C "pwrite -S 0x61 0 16" \
 	-C "mread -v 0 16" \
-| _filter_xfs_io
+| _filter_xfs_io | _filter_scratch
 
 status=0
 exit
diff --git a/tests/overlay/016.out b/tests/overlay/016.out
index c49f8dc..a28aaa6 100644
--- a/tests/overlay/016.out
+++ b/tests/overlay/016.out
@@ -1,8 +1,8 @@
 QA output created by 016
 wrote 16/16 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-[000] foo            (foreign,non-sync,non-direct,read-only)
- 001  foo            (foreign,non-sync,non-direct,read-write)
+[000] SCRATCH_MNT/foo (foreign,non-sync,non-direct,read-only)
+ 001  SCRATCH_MNT/foo (foreign,non-sync,non-direct,read-write)
 00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
 read 16/16 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/overlay/018 b/tests/overlay/018
index 230245b..92fb63d 100755
--- a/tests/overlay/018
+++ b/tests/overlay/018
@@ -40,7 +40,6 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-	cd /
 	rm -f $tmp.*
 }
 
@@ -73,7 +72,6 @@ mknod $lowerdir/fifo p
 
 _scratch_mount
 
-cd $SCRATCH_MNT
 
 rm -f $tmp.before $tmp.after
 
@@ -81,17 +79,17 @@ rm -f $tmp.before $tmp.after
 
 # Record inode numbers before and after copy up
 for f in dir file symlink chrdev blkdev fifo; do
-	ls -id $f >> $tmp.before
+	ls -id $SCRATCH_MNT/$f >> $tmp.before
 	# chown -h modifies all those file types
-	chown -h 100 $f
-	ls -id $f >> $tmp.after
+	chown -h 100 $SCRATCH_MNT/$f
+	ls -id $SCRATCH_MNT/$f >> $tmp.after
 done
 
 # Test stable readdir(3)/getdents(2) d_ino
 
 # find by inode number - expect to find file by inode number
 cat $tmp.before | while read ino f; do
-	find $f -inum $ino -maxdepth 0
+	find $f -inum $ino -maxdepth 0 | _filter_scratch
 done
 
 # Compare before..after - expect silence
diff --git a/tests/overlay/018.out b/tests/overlay/018.out
index bf4bce8..0e5132c 100644
--- a/tests/overlay/018.out
+++ b/tests/overlay/018.out
@@ -1,7 +1,7 @@
 QA output created by 018
-dir
-file
-symlink
-chrdev
-blkdev
-fifo
+SCRATCH_MNT/dir
+SCRATCH_MNT/file
+SCRATCH_MNT/symlink
+SCRATCH_MNT/chrdev
+SCRATCH_MNT/blkdev
+SCRATCH_MNT/fifo
-- 
2.7.4

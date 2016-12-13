From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] overlay/016: do not cd into $SCRATCH_MNT
Date: Tue, 13 Dec 2016 08:15:29 +0200
Message-ID: <1481609729-12341-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Avoid cd into $SCRATCH_MNT

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/016     | 13 ++++++-------
 tests/overlay/016.out |  4 ++--
 2 files changed, 8 insertions(+), 9 deletions(-)

v2:
- undo cleanup of _cleanup()
- sperate patch for 016

diff --git a/tests/overlay/016 b/tests/overlay/016
index 041ab3d..cffcde7 100755
--- a/tests/overlay/016
+++ b/tests/overlay/016
@@ -64,7 +64,6 @@ echo "This is old news" > $lowerdir/bar
 
 _scratch_mount
 
-cd $SCRATCH_MNT
 
 #
 # case #1:
@@ -73,12 +72,12 @@ cd $SCRATCH_MNT
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
@@ -86,12 +85,12 @@ $XFS_IO_PROG -r foo \
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
-- 
2.7.4

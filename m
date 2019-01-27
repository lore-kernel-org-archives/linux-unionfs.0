Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay/061: enhance mmap ro/rw inconsistencies test
Date: Sun, 27 Jan 2019 10:38:50 +0200
Message-Id: <20190127083850.28834-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

overlay/061 is currently the only overlay test that is expected to fail
on upstream kernel.

It is a flavor of test overlay/016 with mread in stead of pread.
The ro/rw inconsistencies related to file read()/write() API were fixed
with stacked file operations in v4.19, but the ro/rw inconsistencies
related to shared mmap read/write remain to be fixed.

The test currently checks cache coherency between mmap read and file
write(), but this sort of cache coherency is a Linux implementation
detail not a requirement of the API.
Instead of mread vs. pwrite, check consistency of mread vs. mwrite
to shared mmap, which is required by the MMAP_SHARED API.

Because we can, perform the test on shared memory that maps files
that are already close and check also that mwrite after file is closed
is persistent.
This adds test coverage for future overlayfs writeback code.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/061     | 36 +++++++++++++++++++++++++++++-------
 tests/overlay/061.out |  4 ++--
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/tests/overlay/061 b/tests/overlay/061
index aea72eb9..47be2cc3 100755
--- a/tests/overlay/061
+++ b/tests/overlay/061
@@ -4,14 +4,15 @@
 #
 # FSQA Test No. 061
 #
-# Test ro/rw fd data inconsistecies
+# Test memory mapped data inconsistencies
 #
 # This is a variant of test overlay/016 with mread instead of pread.
 #
 # This simple test demonstrates a known issue with overlayfs:
-# - process A opens file F for read + mmap
-# - process B writes new data to file F
-# - process A reads old data from mapped memory
+# - process A created shared ro mmap on file F
+# - process B created shared rw mmap on file F
+# - process B writes new data to shared mmap
+# - process A reads old data from shared mmap
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
@@ -49,15 +50,36 @@ echo "This is old news" > $lowerdir/foo
 _scratch_mount
 
 
+filter_xfs_io_mmap()
+{
+	# filter out these lines:
+	# [000] 0x7f3d9aece000 - 0x7f3d9aece010 r--  SCRATCH_MNT/foo (0 : 16)
+	grep -Fv '[00'
+}
+
 #
 # mmap MAP_SHARED|PROT_READ of rofd
-# write to rwfd
-# read from mapped memory
+# mmap MAP_SHARED|PROT_WRITE of rwfd
+# write to rw mmap
+# read from ro mmap
 #
 $XFS_IO_PROG -r $SCRATCH_MNT/foo \
 	-C "mmap -r 0 16" \
+	-C "close" \
 	-C "open $SCRATCH_MNT/foo" \
-	-C "pwrite -S 0x61 0 16" \
+	-C "mmap -w 0 16" \
+	-C "close" \
+	-C "mwrite -S 0x61 0 16" \
+	-C "munmap" \
+	-C "mread -v 0 16" \
+| _filter_xfs_io | _filter_scratch | filter_xfs_io_mmap
+
+_scratch_cycle_mount
+
+# Verify mmap write after close has persisted through mount cycle
+echo "After mount cycle:"
+$XFS_IO_PROG -r $SCRATCH_MNT/foo \
+	-C "mmap -r 0 16" \
 	-C "mread -v 0 16" \
 | _filter_xfs_io | _filter_scratch
 
diff --git a/tests/overlay/061.out b/tests/overlay/061.out
index 0662721c..d0e8b86e 100644
--- a/tests/overlay/061.out
+++ b/tests/overlay/061.out
@@ -1,4 +1,4 @@
 QA output created by 061
-wrote 16/16 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
+After mount cycle:
 00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
-- 
2.17.1

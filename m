Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3] overlay/016: split into two tests
Date: Fri, 24 Aug 2018 07:40:44 +0300
Message-Id: <1535085644-23131-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

overlay/016 tests two cases of ro/rw fd data inconsistecies -
one using pread and one using mmap read (i.e. mread).

The first case now passes with stacked overlay file operations
patch set merged. The second case will still fail.

By splitting the two test cases we get one regression test for
the common case of ro/rw fd data inconsistecy with pread and
one test to track the remaining non-standard behavior of
overlayfs w.r.t mmap.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

The overlayfs ro/rw fd data inconsistecies patches were
finally merged, so we can now merge this test change to
reflect new behavior.

After this change on current master:
- overlay/16 is expected to pass
- overlay/61 is expected to fail

FYI, overlay/60 (new metacopy feature test) is also expected to
run and pass on master.

Thanks,
Amir.

Changes from v2:
- remove unimplemented feature copy_up_shared

 tests/overlay/016     | 15 ------------
 tests/overlay/016.out |  3 ---
 tests/overlay/061     | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/061.out |  4 ++++
 tests/overlay/group   |  1 +
 5 files changed, 70 insertions(+), 18 deletions(-)
 create mode 100755 tests/overlay/061
 create mode 100644 tests/overlay/061.out

diff --git a/tests/overlay/016 b/tests/overlay/016
index 5c5d9ab..4fcb31e 100755
--- a/tests/overlay/016
+++ b/tests/overlay/016
@@ -43,13 +43,11 @@ _scratch_mkfs >>$seqres.full 2>&1
 lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 echo "This is old news" > $lowerdir/foo
-echo "This is old news" > $lowerdir/bar
 
 _scratch_mount
 
 
 #
-# case #1:
 # open file for read (rofd)
 # open file for write (rwfd)
 # write to rwfd
@@ -62,18 +60,5 @@ $XFS_IO_PROG -r $SCRATCH_MNT/foo \
 	-C "pread -v 0 16" \
 | _filter_xfs_io | _filter_scratch
 
-#
-# case #2:
-# mmap MAP_SHARED|PROT_READ of rofd
-# write to rwfd
-# read from mapped memory
-#
-$XFS_IO_PROG -r $SCRATCH_MNT/bar \
-	-C "mmap -r 0 16" \
-	-C "open $SCRATCH_MNT/bar" \
-	-C "pwrite -S 0x61 0 16" \
-	-C "mread -v 0 16" \
-| _filter_xfs_io | _filter_scratch
-
 status=0
 exit
diff --git a/tests/overlay/016.out b/tests/overlay/016.out
index a28aaa6..02b2ae2 100644
--- a/tests/overlay/016.out
+++ b/tests/overlay/016.out
@@ -6,6 +6,3 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
 read 16/16 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 16/16 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
diff --git a/tests/overlay/061 b/tests/overlay/061
new file mode 100755
index 0000000..4b653ab
--- /dev/null
+++ b/tests/overlay/061
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 CTERA Networks. All Rights Reserved.
+#
+# FSQA Test No. 061
+#
+# Test ro/rw fd data inconsistecies
+#
+# This is a variant of test overlay/016 with mread instead of pread.
+#
+# This simple test demonstrates a known issue with overlayfs:
+# - process A opens file F for read + mmap
+# - process B writes new data to file F
+# - process A reads old data from mapped memory
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "open"
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+# Create our test files.
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+mkdir -p $lowerdir
+echo "This is old news" > $lowerdir/foo
+
+_scratch_mount
+
+
+#
+# mmap MAP_SHARED|PROT_READ of rofd
+# write to rwfd
+# read from mapped memory
+#
+$XFS_IO_PROG -r $SCRATCH_MNT/foo \
+	-C "mmap -r 0 16" \
+	-C "open $SCRATCH_MNT/foo" \
+	-C "pwrite -S 0x61 0 16" \
+	-C "mread -v 0 16" \
+| _filter_xfs_io | _filter_scratch
+
+status=0
+exit
diff --git a/tests/overlay/061.out b/tests/overlay/061.out
new file mode 100644
index 0000000..0662721
--- /dev/null
+++ b/tests/overlay/061.out
@@ -0,0 +1,4 @@
+QA output created by 061
+wrote 16/16 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
diff --git a/tests/overlay/group b/tests/overlay/group
index b73d7e9..ccc71f3 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -63,3 +63,4 @@
 058 auto quick exportfs
 059 auto quick copyup
 060 auto quick metacopy
+061 auto quick copyup
-- 
2.7.4

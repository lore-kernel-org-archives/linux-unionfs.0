Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/2] overlay/016: split into two tests
Date: Sat,  2 Jun 2018 21:52:19 +0300
Message-Id: <1527965539-30607-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

overlay/016 tests two cases of ro/rw fd data inconsistecies -
one using pread and one using mmap read (i.e. mread).

The first case will pass as soon as stacked overlay operations
patch set is merged. The second case requires enabling a new opt-in
feature "copy_up_shared" in order to pass.

Instead of changing the entire test from fail to notrun, split
the two cases into two tests and require the new feature only
for the new test.

This way, the new test will change from notrun to pass with
stacked overlay operations and the old test will change from
fail to pass.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Changes from v1:
- Remove unused file bar and use only foo (Vivek)

 tests/overlay/016     | 15 ---------
 tests/overlay/016.out |  3 --
 tests/overlay/061     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/061.out |  4 +++
 tests/overlay/group   |  1 +
 5 files changed, 89 insertions(+), 18 deletions(-)
 create mode 100755 tests/overlay/061
 create mode 100644 tests/overlay/061.out

diff --git a/tests/overlay/016 b/tests/overlay/016
index 86a7d28..06d1101 100755
--- a/tests/overlay/016
+++ b/tests/overlay/016
@@ -60,13 +60,11 @@ _scratch_mkfs >>$seqres.full 2>&1
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
@@ -79,18 +77,5 @@ $XFS_IO_PROG -r $SCRATCH_MNT/foo \
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
index 0000000..2324e48
--- /dev/null
+++ b/tests/overlay/061
@@ -0,0 +1,84 @@
+#! /bin/bash
+# FSQA Test No. 061
+#
+# Test ro/rw fd data inconsistecies
+#
+# This is a variant of test overlay/016 with mread instead of pread.
+# This test requires and enables copy_up_shared feature.
+#
+# This simple test demonstrates a known issue with overlayfs:
+# - process A opens file F for read + mmap
+# - process B writes new data to file F
+# - process A reads old data from mapped memory
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2016 CTERA Networks. All Rights Reserved.
+# Author: Amir Goldstein <amir73il@gmail.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
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
+_require_scratch_feature copy_up_shared
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
+_scratch_mount -o copy_up_shared=on
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

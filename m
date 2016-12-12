From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] overlay: test unstable inode number
Date: Mon, 12 Dec 2016 10:12:04 +0200
Message-ID: <1481530324-28866-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Introduce a new test to demonstrate a known issue with overlayfs:
- stat file A shows inode number X
- modify A to trigger copy up
- stat file A shows inode number Y != X

Also test if d_ino of readdir entries changes after copy up.

There is a POC patch by Miklos Szeredi that fixes this issue.
---
 tests/overlay/018     | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/018.out |  5 +++
 tests/overlay/group   |  1 +
 3 files changed, 102 insertions(+)
 create mode 100755 tests/overlay/018
 create mode 100644 tests/overlay/018.out

v2: use arbitrary uid for chown

diff --git a/tests/overlay/018 b/tests/overlay/018
new file mode 100755
index 0000000..473d881
--- /dev/null
+++ b/tests/overlay/018
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FSQA Test No. 018
+#
+# Test unstable inode number
+#
+# This simple test demonstrates a known issue with overlayfs:
+# - stat file A shows inode number X
+# - modify A to trigger copy up
+# - stat file A shows inode number Y != X
+#
+# Also test if d_ino of readdir entries changes after copy up.
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
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+# Create our test files
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+mkdir -p $lowerdir
+mkdir $lowerdir/dir
+touch $lowerdir/file
+ln -s $lowerdir/file $lowerdir/symlink
+mkfifo $lowerdir/fifo
+
+
+_scratch_mount
+
+cd $SCRATCH_MNT
+
+rm -f $tmp.before $tmp.after
+
+# Test stable stat(2) st_ino
+
+# Record inode numbers before and after copy up
+for f in dir file symlink fifo; do
+	ls -id $f >> $tmp.before
+	# chown -h modifies all those file types
+	chown -h 100 $f
+	ls -id $f >> $tmp.after
+done
+
+# Test stable readdir(3)/getdents(2) d_ino
+
+# find by inode number - expect to find file by inode number
+cat $tmp.before | while read ino f; do
+	find $f -inum $ino -maxdepth 0
+done
+
+# Compare before..after - expect silence
+diff $tmp.before $tmp.after
+
+status=0
+exit
diff --git a/tests/overlay/018.out b/tests/overlay/018.out
new file mode 100644
index 0000000..75e80e7
--- /dev/null
+++ b/tests/overlay/018.out
@@ -0,0 +1,5 @@
+QA output created by 018
+dir
+file
+symlink
+fifo
diff --git a/tests/overlay/group b/tests/overlay/group
index 5740d2a..683b2fc 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -19,3 +19,4 @@
 014 auto quick copyup
 015 auto quick whiteout
 016 auto quick
+018 auto quick
-- 
2.7.4

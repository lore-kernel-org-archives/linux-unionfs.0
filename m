From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3] overlay: test unstable inode number
Date: Tue, 13 Dec 2016 08:18:29 +0200
Message-ID: <1481609909-12433-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35663 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752478AbcLMGSx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Dec 2016 01:18:53 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Introduce a new test to demonstrate a known issue with overlayfs:
- stat file A shows inode number X
- modify A to trigger copy up
- stat file A shows inode number Y != X

Also test if d_ino of readdir entries changes after copy up.

There is a POC patch by Miklos Szeredi that fixes this issue.

Not dealing with hardlinks here, because there is more to test
then stable inode number.
Hardlinks will get a test of their own.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/018     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/018.out |  7 ++++
 tests/overlay/group   |  1 +
 3 files changed, 107 insertions(+)
 create mode 100755 tests/overlay/018
 create mode 100644 tests/overlay/018.out

v3:
- avoid cd into $SCRATCH_MNT

v2:
- use arbitrary uid for chown

diff --git a/tests/overlay/018 b/tests/overlay/018
new file mode 100755
index 0000000..92fb63d
--- /dev/null
+++ b/tests/overlay/018
@@ -0,0 +1,99 @@
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
+# Create our test files.
+# Not dealing with hardlinks here, because there is more to test
+# then stable inode number.
+# Hardlinks will get a test of their own.
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+mkdir -p $lowerdir
+mkdir $lowerdir/dir
+touch $lowerdir/file
+ln -s $lowerdir/file $lowerdir/symlink
+mknod $lowerdir/chrdev c 1 1
+mknod $lowerdir/blkdev b 1 1
+mknod $lowerdir/fifo p
+
+
+_scratch_mount
+
+
+rm -f $tmp.before $tmp.after
+
+# Test stable stat(2) st_ino
+
+# Record inode numbers before and after copy up
+for f in dir file symlink chrdev blkdev fifo; do
+	ls -id $SCRATCH_MNT/$f >> $tmp.before
+	# chown -h modifies all those file types
+	chown -h 100 $SCRATCH_MNT/$f
+	ls -id $SCRATCH_MNT/$f >> $tmp.after
+done
+
+# Test stable readdir(3)/getdents(2) d_ino
+
+# find by inode number - expect to find file by inode number
+cat $tmp.before | while read ino f; do
+	find $f -inum $ino -maxdepth 0 | _filter_scratch
+done
+
+# Compare before..after - expect silence
+diff $tmp.before $tmp.after
+
+status=0
+exit
diff --git a/tests/overlay/018.out b/tests/overlay/018.out
new file mode 100644
index 0000000..0e5132c
--- /dev/null
+++ b/tests/overlay/018.out
@@ -0,0 +1,7 @@
+QA output created by 018
+SCRATCH_MNT/dir
+SCRATCH_MNT/file
+SCRATCH_MNT/symlink
+SCRATCH_MNT/chrdev
+SCRATCH_MNT/blkdev
+SCRATCH_MNT/fifo
diff --git a/tests/overlay/group b/tests/overlay/group
index 7cb2615..fb6610d 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -19,3 +19,4 @@
 014 auto quick copyup
 015 auto quick whiteout
 016 auto quick copyup
+018 auto quick copyup
-- 
2.7.4

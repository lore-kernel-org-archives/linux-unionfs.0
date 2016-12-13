From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] overlay: test hardlink breakage on copy up
Date: Tue, 13 Dec 2016 07:12:37 +0200
Message-ID: <1481605957-8527-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:32828 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750717AbcLMFM7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 13 Dec 2016 00:12:59 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Introduce a new test to demonstrate a known issue with overlayfs:
- file A and B are hardlinked in lower
- modify A to trigger copy up
- file A is no longer a hardlink of file B

There is no fix for this issue at this time.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/019     | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/019.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 92 insertions(+)
 create mode 100755 tests/overlay/019
 create mode 100644 tests/overlay/019.out

v2: avoid cd into $SCRATCH_MNT

Eryu,

Merging this test with unknown schedule for fix is up to you.
I just wanted to write all the tests to cover
https://github.com/amir73il/overlayfs/wiki/Non-standard-behavior
and this was the last one.

Anyway, I'll keep it hanging on my overlayfs-devel branch on github.

Cheers,
Amir.

diff --git a/tests/overlay/019 b/tests/overlay/019
new file mode 100755
index 0000000..9ce945d
--- /dev/null
+++ b/tests/overlay/019
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FSQA Test No. 019
+#
+# Test hardlink breakage
+#
+# This simple test demonstrates a known issue with overlayfs:
+# - file A and B are hardlinked in lower
+# - modify A to trigger copy up
+# - file A is no longer a hardlink of file B
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
+# Create 2 hardlinked files in lower
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+mkdir -p $lowerdir
+echo "patient zero" >> $lowerdir/foo
+ln $lowerdir/foo $lowerdir/bar
+
+
+_scratch_mount
+
+
+rm -f $tmp.before $tmp.after
+
+foo=$SCRATCH_MNT/foo
+bar=$SCRATCH_MNT/bar
+
+# Record inode number and nlink before copy up
+ls -li $foo $bar | awk '{ print $1, $3 }' > $tmp.before
+
+# Modify content of one of the hardlinks
+echo "mutated" >> $foo
+
+# Record inode number and nlink after copy up
+ls -li $foo $bar | awk '{ print $1, $3 }' > $tmp.after
+
+# Compare ino/nlink before..after - expect silence
+diff $tmp.before $tmp.after
+
+# Compare content of files - expect silence
+diff $foo $bar
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/019.out b/tests/overlay/019.out
new file mode 100644
index 0000000..163484b
--- /dev/null
+++ b/tests/overlay/019.out
@@ -0,0 +1,2 @@
+QA output created by 019
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index fb6610d..f266b0a 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -20,3 +20,4 @@
 015 auto quick whiteout
 016 auto quick copyup
 018 auto quick copyup
+019 auto quick copyup
-- 
2.7.4

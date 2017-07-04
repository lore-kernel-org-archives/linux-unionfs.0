From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 7/7] overlay: test dropping nlink below zero
Date: Tue,  4 Jul 2017 14:40:34 +0300
Message-ID: <1499168434-23859-8-git-send-email-amir73il@gmail.com>
References: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

nlink of overlay inode could be dropped indefinety by adding
un-accounted lower hardlinks underneath a mounted overlay and
trying to remove them.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/034     | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/034.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 94 insertions(+)
 create mode 100755 tests/overlay/034
 create mode 100644 tests/overlay/034.out

diff --git a/tests/overlay/034 b/tests/overlay/034
new file mode 100755
index 0000000..cb023bf
--- /dev/null
+++ b/tests/overlay/034
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FS QA Test 034
+#
+# Test overlay nlink when adding lower hardlinks.
+#
+# nlink of overlay inode could be dropped indefinety by adding
+# unaccounted lower hardlinks underneath a mounted overlay and
+# trying to remove them.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2017 CTERA Networks. All Rights Reserved.
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create lower hardlink
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+mkdir -p $lowerdir
+touch $lowerdir/0
+ln $lowerdir/0 $lowerdir/1
+
+_scratch_mount
+
+# Copy up lower hardlink - nlink should be 2
+touch $SCRATCH_MNT/0
+
+# Add lower hardlinks while overlay is mounted
+ln $lowerdir/0 $lowerdir/2
+ln $lowerdir/0 $lowerdir/3
+
+# Unlink un-accounted lowers to drive nlink to 0
+rm $SCRATCH_MNT/2
+rm $SCRATCH_MNT/3
+
+# Check for getting ENOENT for trying to link !I_LINKABLE with nlink 0
+ln $SCRATCH_MNT/0 $SCRATCH_MNT/4
+
+# Unlink all hardlink to drive nlink below 0
+rm $SCRATCH_MNT/0
+rm $SCRATCH_MNT/1
+rm $SCRATCH_MNT/4
+
+# Verify that orphan index is cleaned on mount
+_scratch_cycle_mount
+ls $OVL_BASE_SCRATCH_MNT/$OVL_WORK/index 2>/dev/null
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/034.out b/tests/overlay/034.out
new file mode 100644
index 0000000..4c8873c
--- /dev/null
+++ b/tests/overlay/034.out
@@ -0,0 +1,2 @@
+QA output created by 034
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 35cd5a5..b55ed0c 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -36,3 +36,4 @@
 031 auto quick whiteout
 032 auto quick copyup hardlink
 033 auto quick copyup hardlink
+034 auto quick copyup hardlink
-- 
2.7.4

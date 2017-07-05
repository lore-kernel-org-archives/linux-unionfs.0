From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 7/7] overlay: test dropping nlink below zero
Date: Wed,  5 Jul 2017 15:02:06 +0300
Message-ID: <1499256126-21866-8-git-send-email-amir73il@gmail.com>
References: <1499256126-21866-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33674 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752547AbdGEMCE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2017 08:02:04 -0400
In-Reply-To: <1499256126-21866-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

nlink of overlay inode could be dropped indefinitely by adding
un-accounted lower hardlinks underneath a mounted overlay and
trying to remove them.

The simplest way to understand this test is this:
Imagine that you have a tool (e.g. xfs_db) with which you can add
hardlinks, without changing the value of nlink stored on-disk for the
inode. This is exactly what this test does when it adds lower hardlinks
underneath a mounted overlay.

Commit 5f8415d6b87e ("ovl: persistent overlay inode nlink for indexed
inodes") fixes this issue, although the issue was never exposed in any
released kernel.

With overlayfs indexed copy up and without the fix, the test triggers
WARN_ON(inode->i_nlink == 0) in drop_link().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/034     | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/034.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 110 insertions(+)
 create mode 100755 tests/overlay/034
 create mode 100644 tests/overlay/034.out

diff --git a/tests/overlay/034 b/tests/overlay/034
new file mode 100755
index 0000000..2b4ca73
--- /dev/null
+++ b/tests/overlay/034
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test 034
+#
+# Test overlay nlink when adding lower hardlinks.
+#
+# nlink of overlay inode could be dropped indefinitely by adding
+# unaccounted lower hardlinks underneath a mounted overlay and
+# trying to remove them.
+#
+# The simplest way to understand this test is this:
+# Imagine that you have a tool (e.g. xfs_db) with which you can add
+# hardlinks, without changing the value of nlink stored on-disk for the
+# inode. This is exactly what this test does when it adds lower hardlinks
+# underneath a mounted overlay.
+#
+# Commit 5f8415d6b87e ("ovl: persistent overlay inode nlink for indexed
+# inodes") fixes this issue, although the issue was never exposed in any
+# released kernel.
+#
+# With overlayfs indexed copy up and without the fix, the test triggers
+# WARN_ON(inode->i_nlink == 0) in drop_link().
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
+# Copy up lower hardlink - overlay inode nlink 2 is copied from lower
+touch $SCRATCH_MNT/0
+
+# Add lower hardlinks while overlay is mounted - overlay inode nlink
+# is not being updated
+ln $lowerdir/0 $lowerdir/2
+ln $lowerdir/0 $lowerdir/3
+
+# Unlink the 2 un-accounted lower hardlinks - overlay inode nlinks
+# drops 2 and may reach 0 if the situation is not detected
+rm $SCRATCH_MNT/2
+rm $SCRATCH_MNT/3
+
+# Check if getting ENOENT when trying to link !I_LINKABLE with nlink 0
+ln $SCRATCH_MNT/0 $SCRATCH_MNT/4
+
+# Unlink all hardlinks - if overlay inode nlink is 0, this will trigger
+# WARN_ON() in drop_nlink()
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

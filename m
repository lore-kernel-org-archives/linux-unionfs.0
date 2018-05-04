Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] overlay: test multiple origin references to the same lower file
Date: Fri,  4 May 2018 12:41:31 +0300
Message-Id: <1525426891-6121-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1525426891-6121-1-git-send-email-amir73il@gmail.com>
References: <1525426891-6121-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Multiple origin references to the same lower file from upper files that
are not hardlinks will falsely return the same st_ino/st_dev for two
different overlay files and will cause 'diff' to falsely report that
content of files is the same when it is not.

This test checks that overlayfs detects and fails lookup of a multiply
referenced origin.

The check for multiply referenced origin was a by-product of kernel
commit 31747eda41ef ("ovl: hash directory inodes for fsnotify")

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/059     | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/059.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 108 insertions(+)
 create mode 100755 tests/overlay/059
 create mode 100644 tests/overlay/059.out

diff --git a/tests/overlay/059 b/tests/overlay/059
new file mode 100755
index 0000000..5ac2b1b
--- /dev/null
+++ b/tests/overlay/059
@@ -0,0 +1,105 @@
+#! /bin/bash
+# FS QA Test 059
+#
+# Test multiple origin references to the same lower file.
+#
+# Multiple origin references to the same lower file from upper files that
+# are not hardlinks will falsely return the same st_ino/st_dev for two
+# different overlay files and will cause 'diff' to falsely report that
+# content of files is the same when it is not.
+#
+# This test checks that overlayfs detects and fails lookup of a multiply
+# referenced origin.
+#
+# The check for multiply referenced origin was a by-product of kernel
+# commit 31747eda41ef ("ovl: hash directory inodes for fsnotify")
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2018 CTERA Networks. All Rights Reserved.
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
+here=`pwd`
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
+# Rename lower file to create copy up with origin xattr
+create_origin_ref()
+{
+	local ref=$1
+
+	touch $lowerdir/origin
+
+	# Enabling redirect_dir may seem irrelevant to rename of non-dir,
+	# but with upcoming 'metacopy' feature, redirects will be set also
+	# on non-dir and may also create multiple redirects.
+	_scratch_mount -o redirect_dir=on
+	mv $SCRATCH_MNT/origin $SCRATCH_MNT/$ref
+
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch_nocheck
+_require_scratch_feature redirect_dir
+
+# remove all files from previous runs
+_scratch_mkfs
+
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+
+# Create copied up file with origin xattr
+create_origin_ref ref1
+# Duplicate the copied up file
+cp -a $upperdir/ref1 $upperdir/ref2
+
+# Diverge the content of the two copies of file
+# and the content of two copies of redirected dir
+echo right >> $upperdir/ref1
+echo wrong >> $upperdir/ref2
+
+_scratch_mount -o redirect_dir=on
+
+# If both copies of file use the same st_dev/st_ino in overlay
+# diff won't detect that their content differs
+diff -q $SCRATCH_MNT/ref1 $SCRATCH_MNT/ref2 &>/dev/null && \
+	echo "diff on duplicated upper files doesn't know right from wrong!"
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/059.out b/tests/overlay/059.out
new file mode 100644
index 0000000..36ebeea
--- /dev/null
+++ b/tests/overlay/059.out
@@ -0,0 +1,2 @@
+QA output created by 059
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 359ed42..40445a0 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -61,3 +61,4 @@
 056 auto quick fsck
 057 auto quick redirect
 058 auto quick exportfs
+059 auto quick copyup
-- 
2.7.4

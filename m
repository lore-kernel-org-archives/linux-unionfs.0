From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 5/7] overlay: test concurrent copy up of lower hardlinks
Date: Tue,  4 Jul 2017 14:40:32 +0300
Message-ID: <1499168434-23859-6-git-send-email-amir73il@gmail.com>
References: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Two tasks make a modification concurrently on two hardlinks of a large
lower inode.  The copy up should be triggered by one of the tasks and the
other should be waiting for copy up to complete.  Both copy up targets
should end up being upper hardlinks and both metadata changes should be
visible in both hardlinks.

With kernel <= v4.12, hardlinks are broken on copy up, meaning that copy up
is performed independetly and the resulting upper copy up targets each have
only one of the the metadata changes visible.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/032     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/032.out |   4 ++
 tests/overlay/group   |   1 +
 3 files changed, 107 insertions(+)
 create mode 100755 tests/overlay/032
 create mode 100644 tests/overlay/032.out

diff --git a/tests/overlay/032 b/tests/overlay/032
new file mode 100755
index 0000000..9a7995e
--- /dev/null
+++ b/tests/overlay/032
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test 032
+#
+# Test concurrent copy up of lower hardlinks.
+#
+# Two tasks make a metadata change concurrently on two hardlinks of a large
+# lower inode.  The copy up should be triggers by one of the tasks and the
+# other should be waiting for copy up to complete.  Both copy up targets
+# should end up being upper hardlinks and both metadata changes should be
+# applied.
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
+# overlay copy_up doesn't deal with sparse file well, holes will be filled by
+# zeros, so if both hardlinks are broken on copy up, we need (2*500M) free space
+# on $OVL_BASE_SCRATCH_MNT.
+_require_fs_space $OVL_BASE_SCRATCH_MNT $((500*1024*2))
+
+# Create a large file in lower with 2 hardlinks
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+mkdir -p $lowerdir
+touch $lowerdir/zero
+$XFS_IO_PROG -c "truncate 500m" $lowerdir/zero
+ln $lowerdir/zero $lowerdir/one
+ln $lowerdir/zero $lowerdir/two
+
+_scratch_mount
+
+_do_cmd()
+{
+	echo "`date +%T` $1..." >> $seqres.full
+	eval "$1"
+	echo "`date +%T` ...$1" >> $seqres.full
+}
+
+# Perform one modification on each hardlink (size and owner)
+_do_cmd "echo >> $SCRATCH_MNT/one" &
+#
+# When hardlinks are broken and overlayfs supports concurrent copy up,
+# $seqres.full will show that file two copy up started ~2s after file one
+# copy up started and ended ~2s after file one copy up ended.
+# With synchronized copy up of lower inodes, $seqres.full will show that
+# file two copy up ended at the same time as file one copy up.
+#
+sleep 2
+_do_cmd "chown 100 $SCRATCH_MNT/two" &
+
+wait
+
+# Expect all hardlinks to show both metadata modifications
+for f in zero one two; do
+	_ls_l -n $SCRATCH_MNT/$f | awk '{ print $2, $3, $5, $9 }' | _filter_scratch
+done
+
+status=0
+exit
diff --git a/tests/overlay/032.out b/tests/overlay/032.out
new file mode 100644
index 0000000..0069740
--- /dev/null
+++ b/tests/overlay/032.out
@@ -0,0 +1,4 @@
+QA output created by 032
+3 100 524288001 SCRATCH_MNT/zero
+3 100 524288001 SCRATCH_MNT/one
+3 100 524288001 SCRATCH_MNT/two
diff --git a/tests/overlay/group b/tests/overlay/group
index 28df5b6..2baba3a 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -34,3 +34,4 @@
 029 auto quick
 030 auto quick perms
 031 auto quick whiteout
+032 auto quick copyup hardlink
-- 
2.7.4

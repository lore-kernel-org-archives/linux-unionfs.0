From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 6/7] overlay: test nlink accounting of overlay hardlinks
Date: Tue,  4 Jul 2017 14:40:33 +0300
Message-ID: <1499168434-23859-7-git-send-email-amir73il@gmail.com>
References: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

nlink of overlay inode should account for the union of lower
and upper hardlinks.

persistent overlay union nlink is stored in an extended attribute
on the upper inode.

In order to test persistent overlay nlink accounting, the test is
repeated with both warm and cold dentry/inode cache.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/033     | 149 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/033.out |  69 +++++++++++++++++++++++
 tests/overlay/group   |   1 +
 3 files changed, 219 insertions(+)
 create mode 100755 tests/overlay/033
 create mode 100644 tests/overlay/033.out

diff --git a/tests/overlay/033 b/tests/overlay/033
new file mode 100755
index 0000000..743edc8
--- /dev/null
+++ b/tests/overlay/033
@@ -0,0 +1,149 @@
+#! /bin/bash
+# FS QA Test 033
+#
+# Test nlink accounting of overlay hardlinks.
+#
+# nlink of overlay inode should account for the union of lower and upper
+# hardlinks.
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
+report_nlink()
+{
+	when=$1
+
+	[ $DCACHETEMP != cold ] || echo 2 > /proc/sys/vm/drop_caches
+
+	# check nlink with warm dcache after overlay modification
+	echo "== $when - $DCACHETEMP dcache =="
+	for f in $HARDLINKS; do
+		_ls_l $SCRATCH_MNT/$f | awk '{ print $2, $9 }' | _filter_scratch
+	done
+}
+
+# Create lower hardlinks
+create_hardlinks()
+{
+	lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+	mkdir -p $lowerdir
+	touch $lowerdir/0
+	ln $lowerdir/0 $lowerdir/1
+	ln $lowerdir/0 $lowerdir/2
+	ln $lowerdir/0 $lowerdir/3
+}
+
+test_hardlinks()
+{
+	HARDLINKS=`seq 0 3`
+	report_nlink "all lower"
+
+	# Unlink lower hardlink
+	rm $SCRATCH_MNT/0
+	HARDLINKS=`seq 1 3`
+	report_nlink "unlink lower"
+
+	# Link to lower hardlink
+	ln $SCRATCH_MNT/3 $SCRATCH_MNT/4
+	HARDLINKS=`seq 1 4`
+	report_nlink "link lower"
+
+	# Link to upper hardlink
+	ln $SCRATCH_MNT/4 $SCRATCH_MNT/5
+	HARDLINKS=`seq 1 5`
+	report_nlink "link upper"
+
+	# Rename over lower hardlink
+	touch $SCRATCH_MNT/new
+	mv $SCRATCH_MNT/new $SCRATCH_MNT/1
+	HARDLINKS=`seq 2 5`
+	report_nlink "cover lower"
+
+	# Unlink upper hardlink
+	rm $SCRATCH_MNT/5
+	HARDLINKS=`seq 2 4`
+	report_nlink "unlink upper"
+
+	# Rename over upper hardlink
+	touch $SCRATCH_MNT/new
+	mv $SCRATCH_MNT/new $SCRATCH_MNT/4
+	HARDLINKS=`seq 2 3`
+	report_nlink "cover upper"
+
+	# Unlink last upper (union still has one lower)
+	rm $SCRATCH_MNT/3
+	HARDLINKS=2
+	report_nlink "unlink last upper"
+
+	# Unlink last lower and drop union nlink to zero (and hopefully not below)
+	rm $SCRATCH_MNT/2
+
+	# Verify that orphan index is cleaned when dropping nlink to zero
+	ls $OVL_BASE_SCRATCH_MNT/$OVL_WORK/index 2>/dev/null
+}
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create lower hardlinks
+create_hardlinks
+
+_scratch_mount
+# Test hardlinks with warm dcache
+DCACHETEMP=warm
+test_hardlinks
+
+# Reset to lower hardlinks
+_scratch_unmount
+_scratch_mkfs
+create_hardlinks
+_scratch_mount
+
+# Test hardlinks with cold dcache
+DCACHETEMP=cold
+test_hardlinks
+
+status=0
+exit
diff --git a/tests/overlay/033.out b/tests/overlay/033.out
new file mode 100644
index 0000000..506ccc1
--- /dev/null
+++ b/tests/overlay/033.out
@@ -0,0 +1,69 @@
+QA output created by 033
+== all lower - warm dcache ==
+4 SCRATCH_MNT/0
+4 SCRATCH_MNT/1
+4 SCRATCH_MNT/2
+4 SCRATCH_MNT/3
+== unlink lower - warm dcache ==
+3 SCRATCH_MNT/1
+3 SCRATCH_MNT/2
+3 SCRATCH_MNT/3
+== link lower - warm dcache ==
+4 SCRATCH_MNT/1
+4 SCRATCH_MNT/2
+4 SCRATCH_MNT/3
+4 SCRATCH_MNT/4
+== link upper - warm dcache ==
+5 SCRATCH_MNT/1
+5 SCRATCH_MNT/2
+5 SCRATCH_MNT/3
+5 SCRATCH_MNT/4
+5 SCRATCH_MNT/5
+== cover lower - warm dcache ==
+4 SCRATCH_MNT/2
+4 SCRATCH_MNT/3
+4 SCRATCH_MNT/4
+4 SCRATCH_MNT/5
+== unlink upper - warm dcache ==
+3 SCRATCH_MNT/2
+3 SCRATCH_MNT/3
+3 SCRATCH_MNT/4
+== cover upper - warm dcache ==
+2 SCRATCH_MNT/2
+2 SCRATCH_MNT/3
+== unlink last upper - warm dcache ==
+1 SCRATCH_MNT/2
+== all lower - cold dcache ==
+4 SCRATCH_MNT/0
+4 SCRATCH_MNT/1
+4 SCRATCH_MNT/2
+4 SCRATCH_MNT/3
+== unlink lower - cold dcache ==
+3 SCRATCH_MNT/1
+3 SCRATCH_MNT/2
+3 SCRATCH_MNT/3
+== link lower - cold dcache ==
+4 SCRATCH_MNT/1
+4 SCRATCH_MNT/2
+4 SCRATCH_MNT/3
+4 SCRATCH_MNT/4
+== link upper - cold dcache ==
+5 SCRATCH_MNT/1
+5 SCRATCH_MNT/2
+5 SCRATCH_MNT/3
+5 SCRATCH_MNT/4
+5 SCRATCH_MNT/5
+== cover lower - cold dcache ==
+4 SCRATCH_MNT/2
+4 SCRATCH_MNT/3
+4 SCRATCH_MNT/4
+4 SCRATCH_MNT/5
+== unlink upper - cold dcache ==
+3 SCRATCH_MNT/2
+3 SCRATCH_MNT/3
+3 SCRATCH_MNT/4
+== cover upper - cold dcache ==
+2 SCRATCH_MNT/2
+2 SCRATCH_MNT/3
+== unlink last upper - cold dcache ==
+1 SCRATCH_MNT/2
diff --git a/tests/overlay/group b/tests/overlay/group
index 2baba3a..35cd5a5 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -35,3 +35,4 @@
 030 auto quick perms
 031 auto quick whiteout
 032 auto quick copyup hardlink
+033 auto quick copyup hardlink
-- 
2.7.4

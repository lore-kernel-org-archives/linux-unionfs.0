From: Roman Lebedev <lebedev.ri@gmail.com>
Subject: [RFC PATCH] fstests: generic: Test that fsync works on file in overlayfs merged directory
Date: Wed, 30 Sep 2015 22:57:45 +0300
Message-ID: <1443643065-16460-2-git-send-email-lebedev.ri@gmail.com>
References: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org
Cc: Roman Lebedev <lebedev.ri@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

As per overlayfs documentation, any activity on a merged directory
for a application that is doing such activity should work exactly
as if that would be a normal, non overlayfs-merged directory.

That is, e.g. simple fopen-fwrite-fsync-fclose sequence should
work just fine.

But apparently it does not. Add a simple generic test to check that.
As of right now (linux-4.2.1) this test fails at least on btrfs.

PS: An alternative (and probably better approach) would be to run
fstests test suite with TEST_DIR set to overlayfs work directory.

Also, i'm not sure that this test fits here, but it's my best guess.

Signed-off-by: Roman Lebedev <lebedev.ri@gmail.com>
---
 tests/generic/111     | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/111.out |  5 ++++
 tests/generic/group   |  1 +
 3 files changed, 86 insertions(+)
 create mode 100755 tests/generic/111
 create mode 100644 tests/generic/111.out

diff --git a/tests/generic/111 b/tests/generic/111
new file mode 100755
index 0000000..3c2599b
--- /dev/null
+++ b/tests/generic/111
@@ -0,0 +1,80 @@
+#! /bin/bash
+# FS QA Test 111
+#
+# Test that fsync works on file in overlayfs merged directory
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Roman Lebedev.  All Rights Reserved.
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
+lower=$TEST_DIR/lower.$$
+upper=$TEST_DIR/upper.$$
+work=$TEST_DIR/work.$$
+merged=$TEST_DIR/merged.$$
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	umount $merged
+	rm -rf $merged
+	rm -rf $work
+	rm -rf $upper
+	rm -rf $lower
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+_supported_fs generic
+_supported_os IRIX Linux
+_require_test
+
+mkdir $lower
+
+$XFS_IO_PROG -f -c "pwrite 0 4k" -c "fsync" \
+	$lower/file | _filter_xfs_io
+
+mkdir $upper
+mkdir $work
+mkdir $merged
+
+sync
+
+mount -t overlay overlay -olowerdir=$lower \
+	-oupperdir=$upper -oworkdir=$work $merged
+
+$XFS_IO_PROG -f -c "pwrite 0 4k" -c "fsync" \
+	$merged/file | _filter_xfs_io
+
+# if we are here, then fsync did not crash, so we're good.
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/111.out b/tests/generic/111.out
new file mode 100644
index 0000000..36c7fde
--- /dev/null
+++ b/tests/generic/111.out
@@ -0,0 +1,5 @@
+QA output created by 111
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/generic/group b/tests/generic/group
index 4ae256f..d3516f9 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -112,6 +112,7 @@
 107 auto quick metadata
 108 auto quick rw
 109 auto metadata dir
+111 auto quick
 112 rw aio auto quick
 113 rw aio auto quick
 117 attr auto quick
-- 
2.6.0


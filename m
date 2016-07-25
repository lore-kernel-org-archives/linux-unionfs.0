From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 2/3] overlay: remove stale file from upperdir
Date: Tue, 26 Jul 2016 01:27:49 +0800
Message-ID: <1469467670-22287-2-git-send-email-eguan@redhat.com>
References: <1469467670-22287-1-git-send-email-eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1469467670-22287-1-git-send-email-eguan@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, xzhou@redhat.com, Eryu Guan <eguan@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

The upper dentry may become stale before we remove it from overlay,
e.g. file was removed from upperdir directly, which triggered
warning/oops in ovl_remove_and_whiteout().

Commit cfc9fde0b07c ("ovl: verify upper dentry in
ovl_remove_and_whiteout()") fixed this issue.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/overlay/012     | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/012.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 80 insertions(+)
 create mode 100755 tests/overlay/012
 create mode 100644 tests/overlay/012.out

diff --git a/tests/overlay/012 b/tests/overlay/012
new file mode 100755
index 0000000..cfe16f2
--- /dev/null
+++ b/tests/overlay/012
@@ -0,0 +1,77 @@
+#! /bin/bash
+# FS QA Test 012
+#
+# The upper dentry may become stale before we remove it from
+# overlay, e.g. file was removed from upperdir directly, which
+# triggered warning/oops in ovl_remove_and_whiteout().
+#
+# Commit cfc9fde0b07c ("ovl: verify upper dentry in
+# ovl_remove_and_whiteout()") fixed this issue.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Red Hat Inc.  All Rights Reserved.
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
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+
+# remove all files from previous runs
+_scratch_mkfs
+
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
+mkdir -p $lowerdir/test
+
+_scratch_mount
+
+# remove test file to create a whiteout
+rmdir $SCRATCH_MNT/test
+
+# create the test file again and remove it from upperdir directly, make the
+# upper dentry become stale
+touch $SCRATCH_MNT/test
+rm $upperdir/test
+# try to remove test file from overlay dir, trigger ovl_remove_and_whiteout, it
+# should see stale file handle error, and no warnings/oops are expected.
+rm $SCRATCH_MNT/test 2>&1 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/012.out b/tests/overlay/012.out
new file mode 100644
index 0000000..1bfa147
--- /dev/null
+++ b/tests/overlay/012.out
@@ -0,0 +1,2 @@
+QA output created by 012
+rm: cannot remove 'SCRATCH_MNT/test': Stale file handle
diff --git a/tests/overlay/group b/tests/overlay/group
index acd8ac4..103e2e1 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -14,3 +14,4 @@
 009 auto quick
 010 auto quick whiteout
 011 auto quick
+012 auto quick
-- 
2.7.4

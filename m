From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 1/3] overlay: dump overlay private xattr
Date: Tue, 26 Jul 2016 01:27:48 +0800
Message-ID: <1469467670-22287-1-git-send-email-eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, xzhou@redhat.com, Eryu Guan <eguan@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

Test dump overlay private xattr on overlayfs with multiple lower
dirs. All the lower layers, except the lowest one, should honor
overlay private xattr "trusted.overlay", which means it should not
be visible to user.

Commit b581755b1c56 ("ovl: xattr filter fix") fixed this issue.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/overlay/011     | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/011.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 82 insertions(+)
 create mode 100755 tests/overlay/011
 create mode 100644 tests/overlay/011.out

diff --git a/tests/overlay/011 b/tests/overlay/011
new file mode 100755
index 0000000..4b697b8
--- /dev/null
+++ b/tests/overlay/011
@@ -0,0 +1,79 @@
+#! /bin/bash
+# FS QA Test 011
+#
+# test overlay private xattr on overlayfs with multiple lower dirs, all the
+# lower layers except the lowest one should honor overlay private xattr
+# "trusted.overlay", which means it should not be visible to user.
+#
+# Commit b581755b1c56 ("ovl: xattr filter fix") fixed this issue.
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
+. ./common/attr
+
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_test
+_require_scratch
+_require_attrs
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create test dir on upper and make it opaque by setting proper xattr
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
+mkdir -p $lowerdir/testdir
+mkdir -p $upperdir/testdir
+$SETFATTR_PROG -n "trusted.overlay.opaque" -v "y" $upperdir/testdir
+
+# mount overlay with multiple lowerdirs, with $lowerdir as the lowest dir and
+# $upperdir overlaid on top of $lowerdir, so that "trusted.overlay.opaque"
+# xattr should be honored and should not be listed
+# mount readonly, because there's no upper and workdir
+$MOUNT_PROG -t overlay -o ro -o lowerdir=$upperdir:$lowerdir none $SCRATCH_MNT
+
+# Dump trusted.overlay xattr, we should not see the "opaque" xattr
+$GETFATTR_PROG -d -m overlay $SCRATCH_MNT/testdir
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/011.out b/tests/overlay/011.out
new file mode 100644
index 0000000..62e0251
--- /dev/null
+++ b/tests/overlay/011.out
@@ -0,0 +1,2 @@
+QA output created by 011
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 06cdb7e..acd8ac4 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -13,3 +13,4 @@
 008 auto quick whiteout
 009 auto quick
 010 auto quick whiteout
+011 auto quick
-- 
2.7.4

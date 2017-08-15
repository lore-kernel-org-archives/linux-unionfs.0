From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] overlay: test mount error cases with index=on
Date: Tue, 15 Aug 2017 13:31:30 +0300
Message-ID: <1502793090-19372-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36067 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753423AbdHOKbB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2017 06:31:01 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

- Upper/lower mismatch
- Index/upper mismatch

With index=on, lowerdir and upperdir are verified using a file handle
stored in trusted.overlay.origin xattr in upperdir and indexdir.

Failure to verify lowerdir/upperdir on mount results in ESTALE.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

This test depends on a kernel commit 961af647fc9e ("ovl: fix origin
verification of index dir") that was merged for v4.13-rc2.

v2:
- Add verification that mount with original lower and upper
  dir still succeeds, after the mismatch attempts

 tests/overlay/037     | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/037.out |  3 ++
 tests/overlay/group   |  1 +
 3 files changed, 98 insertions(+)
 create mode 100755 tests/overlay/037
 create mode 100644 tests/overlay/037.out

diff --git a/tests/overlay/037 b/tests/overlay/037
new file mode 100755
index 0000000..6be9a26
--- /dev/null
+++ b/tests/overlay/037
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test 037
+#
+# Test mount error cases with option index=on
+#
+# - Upper/lower mismatch
+# - Index/upper mismatch
+#
+# With index=on, lowerdir and upperdir are verified using a file handle
+# stored in trusted.overlay.origin xattr in upperdir and indexdir.
+#
+# Failure to verify lowerdir/upperdir on mount results in ESTALE.
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+_require_scratch_feature index
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create multiple lowerdirs, upperdirs and workdir
+lowerdir=$OVL_BASE_SCRATCH_MNT/lower
+lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+upperdir2=$OVL_BASE_SCRATCH_MNT/upper2
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
+mkdir -p $lowerdir $lowerdir2 $upperdir $upperdir2 $workdir
+
+# Mount overlay with lowerdir, upperdir, workdir and index=on
+# to store the file handles of lowerdir and upperdir in overlay.origin xattr
+_overlay_mount_dirs $lowerdir $upperdir $workdir \
+		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT -oindex=on
+$UMOUNT_PROG $SCRATCH_MNT
+
+# Try to mount an overlay with the same upperdir and different lowerdir - expect ESTALE
+_overlay_mount_dirs $lowerdir2 $upperdir $workdir \
+		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT -oindex=on 2>&1 | _filter_scratch
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+# Try to mount an overlay with the same workdir and different upperdir - expect ESTALE
+_overlay_mount_dirs $lowerdir $upperdir2 $workdir \
+		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT -oindex=on 2>&1 | _filter_scratch
+$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+
+# Mount overlay with original lowerdir, upperdir, workdir and index=on - expect success
+_overlay_mount_dirs $lowerdir $upperdir $workdir \
+		    $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT -oindex=on
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/037.out b/tests/overlay/037.out
new file mode 100644
index 0000000..786ef85
--- /dev/null
+++ b/tests/overlay/037.out
@@ -0,0 +1,3 @@
+QA output created by 037
+mount: mount SCRATCH_DEV on SCRATCH_MNT failed: Stale file handle
+mount: mount SCRATCH_DEV on SCRATCH_MNT failed: Stale file handle
diff --git a/tests/overlay/group b/tests/overlay/group
index 4cc1d74..28f1e63 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -39,3 +39,4 @@
 034 auto quick copyup hardlink
 035 auto quick mount
 036 auto quick mount
+037 auto quick mount
-- 
2.7.4

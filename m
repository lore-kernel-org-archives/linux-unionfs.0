From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/3] overlay: regression test for hardlink breakage after unlink and mount cycle
Date: Tue, 28 Nov 2017 18:42:00 +0200
Message-ID: <1511887322-29254-2-git-send-email-amir73il@gmail.com>
References: <1511887322-29254-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:40748 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753683AbdK1QmB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:42:01 -0500
In-Reply-To: <1511887322-29254-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

- file A and B are hardlinked in lower
- modify A to trigger copy up and index lower
- unlink A and mount cycle
- check that B still contains the modified data

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/047     | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/047.out |  16 ++++++++
 tests/overlay/group   |   1 +
 3 files changed, 124 insertions(+)
 create mode 100755 tests/overlay/047
 create mode 100644 tests/overlay/047.out

diff --git a/tests/overlay/047 b/tests/overlay/047
new file mode 100755
index 0000000..ad1aabe
--- /dev/null
+++ b/tests/overlay/047
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FSQA Test No. 047
+#
+# Test hardlink breakage after unlink and mount cycle
+#
+# - file A and B are hardlinked in lower
+# - modify A to trigger copy up and index lower
+# - unlink A and mount cycle
+# - check that B still contains the modified data
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2016-2017 CTERA Networks. All Rights Reserved.
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
+_require_scratch_feature index
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+# Create 2 hardlinked files in lower
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+mkdir -p $lowerdir
+echo "zero" >> $lowerdir/foo
+ln $lowerdir/foo $lowerdir/bar
+
+
+# Enable overlay index feature to prevent breaking hardlinks on copy up
+_scratch_mount -o index=on
+
+
+rm -f $tmp.*
+
+foo=$SCRATCH_MNT/foo
+bar=$SCRATCH_MNT/bar
+
+FILES="$foo $bar"
+
+echo "== Before copy up =="
+cat $foo
+
+# Modify content of one of the hardlinks
+echo "one" >> $bar
+
+echo "== After write one =="
+cat $foo
+
+# Unlink the copied up hardlink
+rm $bar
+
+echo "== After unlink one =="
+cat $foo
+
+# Verify that the hardlinks survive a mount cycle
+_scratch_cycle_mount index=on
+
+echo "== After mount cycle =="
+cat $foo
+
+# Drop caches to get the copied up hardlink out of cache
+echo 3 > /proc/sys/vm/drop_caches
+
+# Modify content of the other hardlink
+echo "two" >> $foo
+
+echo "== After write two =="
+cat $foo
+
+status=0
+exit
diff --git a/tests/overlay/047.out b/tests/overlay/047.out
new file mode 100644
index 0000000..298e116
--- /dev/null
+++ b/tests/overlay/047.out
@@ -0,0 +1,16 @@
+QA output created by 047
+== Before copy up ==
+zero
+== After write one ==
+zero
+one
+== After unlink one ==
+zero
+one
+== After mount cycle ==
+zero
+one
+== After write two ==
+zero
+one
+two
diff --git a/tests/overlay/group b/tests/overlay/group
index b32c6cd..3e31d2d 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -47,3 +47,4 @@
 042 auto quick copyup hardlink
 043 auto quick copyup nonsamefs
 044 auto quick copyup hardlink nonsamefs
+047 auto quick copyup hardlink
-- 
2.7.4

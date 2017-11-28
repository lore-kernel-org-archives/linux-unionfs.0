From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/3] overlay: regression test for orphan index cleanup on mount
Date: Tue, 28 Nov 2017 18:42:01 +0200
Message-ID: <1511887322-29254-3-git-send-email-amir73il@gmail.com>
References: <1511887322-29254-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:44810 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752730AbdK1QmD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:42:03 -0500
In-Reply-To: <1511887322-29254-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Test nlink accounting of overlay hardlinks with offline modifications.

nlink of overlay inode should account for the union of lower and upper
hardlinks. Orphan index inodes with union nlink 0 should be cleaned on
mount.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/048     | 141 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/048.out |  18 +++++++
 tests/overlay/group   |   1 +
 3 files changed, 160 insertions(+)
 create mode 100755 tests/overlay/048
 create mode 100644 tests/overlay/048.out

diff --git a/tests/overlay/048 b/tests/overlay/048
new file mode 100755
index 0000000..4b2c58f
--- /dev/null
+++ b/tests/overlay/048
@@ -0,0 +1,141 @@
+#! /bin/bash
+# FS QA Test 048
+#
+# Test nlink accounting of overlay hardlinks with offline modifications.
+#
+# nlink of overlay inode should account for the union of lower and upper
+# hardlinks. Orphan index inodes with union nlink 0 should be cleaned on
+# mount.
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
+_require_scratch_feature index
+
+report_nlink()
+{
+	when=$1
+
+	# mount and check nlink after overlay offline modification
+	_scratch_mount -o index=on
+
+	# List <nlink> <name>
+	echo "== $when offline =="
+	for f in $HARDLINKS; do
+		_ls_l $SCRATCH_MNT/$f | awk '{ print $2, $9 }' | _filter_scratch
+	done
+
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
+# Create lower hardlinks
+create_hardlinks()
+{
+	mkdir -p $lowerdir
+	touch $lowerdir/0
+	ln $lowerdir/0 $lowerdir/1
+	ln $lowerdir/0 $lowerdir/2
+}
+
+test_hardlinks_offline()
+{
+	HARDLINKS=`seq 0 2`
+	report_nlink "all upper"
+
+	# Unlink copied up hardlink
+	rm $upperdir/0
+	HARDLINKS=`seq 1 2`
+	report_nlink "unlink upper"
+
+	# Link to copied up hardlink
+	ln $upperdir/2 $upperdir/3
+	HARDLINKS=`seq 1 3`
+	report_nlink "link upper"
+
+	# Rename over copied up hardlink
+	touch $upperdir/new
+	mv $upperdir/new $upperdir/1
+	HARDLINKS=`seq 2 3`
+	report_nlink "rename over upper"
+
+	# Unlink new upper hardlink
+	rm $upperdir/3
+	HARDLINKS=2
+	report_nlink "unlink new upper"
+
+	# Unlink last upper and drop union nlink to zero
+	rm $upperdir/2
+
+	HARDLINKS=
+	report_nlink "unlink last lower"
+
+	# Verify that orphan index is cleaned when dropping nlink to zero
+	ls $workdir/index
+}
+
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create lower hardlinks
+create_hardlinks
+
+# Enable overlay index feature to prevent breaking hardlinks on copy up
+_scratch_mount -o index=on
+
+# Copy up and index hardlinks
+touch $SCRATCH_MNT/0
+touch $SCRATCH_MNT/1
+touch $SCRATCH_MNT/2
+
+# Perform the rest of the changes offline
+$UMOUNT_PROG $SCRATCH_MNT
+
+test_hardlinks_offline
+
+status=0
+exit
diff --git a/tests/overlay/048.out b/tests/overlay/048.out
new file mode 100644
index 0000000..0527dec
--- /dev/null
+++ b/tests/overlay/048.out
@@ -0,0 +1,18 @@
+QA output created by 048
+== all upper offline ==
+3 SCRATCH_MNT/0
+3 SCRATCH_MNT/1
+3 SCRATCH_MNT/2
+== unlink upper offline ==
+2 SCRATCH_MNT/1
+2 SCRATCH_MNT/2
+== link upper offline ==
+3 SCRATCH_MNT/1
+3 SCRATCH_MNT/2
+3 SCRATCH_MNT/3
+== rename over upper offline ==
+2 SCRATCH_MNT/2
+2 SCRATCH_MNT/3
+== unlink new upper offline ==
+1 SCRATCH_MNT/2
+== unlink last lower offline ==
diff --git a/tests/overlay/group b/tests/overlay/group
index 3e31d2d..7e541e4 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -48,3 +48,4 @@
 043 auto quick copyup nonsamefs
 044 auto quick copyup hardlink nonsamefs
 047 auto quick copyup hardlink
+048 auto quick copyup hardlink
-- 
2.7.4

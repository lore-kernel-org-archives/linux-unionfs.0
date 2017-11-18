From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH 3/3] overlay: Test hardlink breakage on non-samefs setup
Date: Sat, 18 Nov 2017 11:28:04 +0530
Message-ID: <20171118055804.17611-3-chandan@linux.vnet.ibm.com>
References: <20171118055804.17611-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43324 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1161461AbdKRF5U (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 18 Nov 2017 00:57:20 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAI5rs1q109768
        for <linux-unionfs@vger.kernel.org>; Sat, 18 Nov 2017 00:57:19 -0500
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2eaehurvtw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Sat, 18 Nov 2017 00:57:19 -0500
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sat, 18 Nov 2017 00:57:18 -0500
In-Reply-To: <20171118055804.17611-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org, amir73il@gmail.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org, eguan@redhat.com

This commit adds a test to check hardlink breakage when the overlayfs
instance is composed of two different underlying filesystem instances.

For example,
$ mount -t xfs /dev/loop0 /mnt/test
$ mount -t xfs /dev/loop1 /mnt/scratch
$ mkdir /mnt/scratch/upper
$ mkdir /mnt/scratch/work
$ mount -t overlay overlay -o lowerdir=/mnt/test \
        -o upperdir=/mnt/scratch/upper \
        -o workdir=/mnt/scratch/work /mnt/merge

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/overlay/044     | 145 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/044.out |  21 ++++++++
 tests/overlay/group   |   1 +
 3 files changed, 167 insertions(+)
 create mode 100755 tests/overlay/044
 create mode 100644 tests/overlay/044.out

diff --git a/tests/overlay/044 b/tests/overlay/044
new file mode 100755
index 0000000..9c0ff04
--- /dev/null
+++ b/tests/overlay/044
@@ -0,0 +1,145 @@
+#! /bin/bash
+# FSQA Test No. 044
+#
+# Test hardlink breakage on non-samefs setup
+# This is a variant of overlay/018 to test.
+#
+# This simple test demonstrates a known issue with overlayfs:
+# - file A and B are hardlinked in lower
+# - modify A to trigger copy up
+# - file A is no longer a hardlink of file B
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2017 IBM Corporation. All Rights Reserved.
+# Author: Chandan Rajendra <chandan@linux.vnet.ibm.com>
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
+_require_test
+_require_scratch_feature index
+_require_test_program "t_dir_type"
+
+rm -f $seqres.full
+
+# Record inode numbers in format <ino> <nlink>
+function record_ino_nlink()
+{
+	ls -li $FILES | awk '{ print $1, $3, $10}' > $1
+}
+
+# Check inode numbers match recorded inode numbers
+function check_ino_nlink()
+{
+	dir=$1
+	before=$2
+	after=$3
+
+	record_ino_nlink $after
+
+	# Test constant stat(2) st_ino/st_nlink -
+	#   Compare before..after - expect silence
+	# We use diff -u so out.bad will tell us which stage failed
+	diff -u $before $after
+
+	# Test constant readdir(3)/getdents(2) d_ino -
+	#   Expect to find file by inode number
+	cat $before | while read ino nlink f; do
+		$here/src/t_dir_type $dir $ino | grep -q $(basename $f) || \
+			echo "$(basename $f) not found by ino $ino (from $before)"
+	done
+}
+
+lowerdir=$OVL_BASE_TEST_DIR/$seq-ovl-lower
+rm -rf $lowerdir
+mkdir $lowerdir
+
+# Create 2 hardlinked files in lower
+echo "zero" >> $lowerdir/foo
+ln $lowerdir/foo $lowerdir/bar
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+
+# Enable overlay index feature to prevent breaking hardlinks on copy up
+OVERLAY_MOUNT_OPTIONS="${OVERLAY_MOUNT_OPTIONS} -o index=on"
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir \
+			    $OVERLAY_MOUNT_OPTIONS
+
+rm -f $tmp.*
+
+foo=$SCRATCH_MNT/foo
+bar=$SCRATCH_MNT/bar
+
+FILES="$foo $bar"
+
+echo "== Before copy up =="
+cat $FILES
+record_ino_nlink $tmp.before
+
+# Modify content of one of the hardlinks
+# Intentionally modify the last hardlink in $FILES, so after mount cycle
+# when reading the first file in $FILES, last file won't be in inode/dcache
+echo "one" >> $bar
+
+echo "== After write one =="
+cat $FILES
+check_ino_nlink $SCRATCH_MNT $tmp.before $tmp.after_one
+
+# Verify that the hardlinks survive a mount cycle
+$UMOUNT_PROG $SCRATCH_MNT
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir \
+			    $OVERLAY_MOUNT_OPTIONS
+
+echo "== After mount cycle =="
+cat $FILES
+check_ino_nlink $SCRATCH_MNT $tmp.after_one $tmp.after_cycle
+
+# Drop caches to get the copied up hardlink out of cache
+echo 3 > /proc/sys/vm/drop_caches
+
+# Modify content of the other hardlink
+echo "two" >> $foo
+
+echo "== After write two =="
+cat $FILES
+check_ino_nlink $SCRATCH_MNT $tmp.after_one $tmp.after_two
+
+status=0
+exit
diff --git a/tests/overlay/044.out b/tests/overlay/044.out
new file mode 100644
index 0000000..8e519e8
--- /dev/null
+++ b/tests/overlay/044.out
@@ -0,0 +1,21 @@
+QA output created by 044
+== Before copy up ==
+zero
+zero
+== After write one ==
+zero
+one
+zero
+one
+== After mount cycle ==
+zero
+one
+zero
+one
+== After write two ==
+zero
+one
+two
+zero
+one
+two
diff --git a/tests/overlay/group b/tests/overlay/group
index a99ff07..b32c6cd 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -46,3 +46,4 @@
 041 auto quick copyup nonsamefs
 042 auto quick copyup hardlink
 043 auto quick copyup nonsamefs
+044 auto quick copyup hardlink nonsamefs
-- 
2.9.5

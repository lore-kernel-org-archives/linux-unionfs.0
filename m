From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH for xfstests 2/4] overlay: add fsck.overlay whiteout test
Date: Thu, 14 Dec 2017 14:48:44 +0800
Message-ID: <20171214064846.21587-3-yi.zhang@huawei.com>
References: <20171214064846.21587-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:2679 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750873AbdLNGmx (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:53 -0500
In-Reply-To: <20171214064846.21587-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

Add fsck.overlay test case to test it how to deal with orphan/valid
whiteouts in underlying directories of overlayfs.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/201     | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/201.out |  3 ++
 tests/overlay/group   |  1 +
 3 files changed, 102 insertions(+)
 create mode 100755 tests/overlay/201
 create mode 100644 tests/overlay/201.out

diff --git a/tests/overlay/201 b/tests/overlay/201
new file mode 100755
index 0000000..1052baa
--- /dev/null
+++ b/tests/overlay/201
@@ -0,0 +1,98 @@
+#! /bin/bash
+# FS QA Test 201
+#
+# Test fsck.overlay how to deal with whiteouts in overlayfs.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Huawei.  All Rights Reserved.
+# Author: zhangyi (F) <yi.zhang@huawei.com>
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
+status=1        # failure is the default!
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
+_require_command "$FSCK_OVERLAY_PROG" fsck.overlay
+
+# remove all files from previous tests
+_scratch_mkfs
+
+# Check whiteout
+check_whiteout()
+{
+	local target=$1
+
+	target_type=`stat -c "%F:%t,%T" $target`
+
+	[[ $target_type == "character special file:0,0" ]] || \
+		echo "Valid whiteout removed incorrectly"
+}
+
+# Create test directories
+lowerdir=$OVL_BASE_SCRATCH_MNT/lower
+lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
+
+mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir
+
+# Test orphan whiteout in lower and upper layer, should remove
+echo "+ Orphan whiteout"
+mknod $lowerdir/foo c 0 0
+mknod $upperdir/foo c 0 0
+mknod $upperdir/bar c 0 0
+_overlay_fsck_dirs -a $lowerdir $upperdir $workdir >> $seqres.full 2>&1 || \
+	_fail "fsck should not fail"
+ls $lowerdir
+ls $upperdir
+rm -rf $lowerdir/* $upperdir/*
+
+# Test valid whiteout covering lower target, should not remove
+echo "+ Valid whiteout"
+touch $lowerdir2/foo $lowerdir2/bar
+mknod $upperdir/foo c 0 0
+mknod $lowerdir/bar c 0 0
+_overlay_fsck_dirs -a "$lowerdir:$lowerdir2" $upperdir $workdir >> \
+	 $seqres.full 2>&1 || _fail "fsck should not fail"
+check_whiteout $upperdir/foo
+check_whiteout $lowerdir/bar
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/201.out b/tests/overlay/201.out
new file mode 100644
index 0000000..20338db
--- /dev/null
+++ b/tests/overlay/201.out
@@ -0,0 +1,3 @@
+QA output created by 201
++ Orphan whiteout
++ Valid whiteout
diff --git a/tests/overlay/group b/tests/overlay/group
index 7e541e4..7c5fcbb 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -49,3 +49,4 @@
 044 auto quick copyup hardlink nonsamefs
 047 auto quick copyup hardlink
 048 auto quick copyup hardlink
+201 auto quick fsck
-- 
2.5.0

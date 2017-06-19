From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH] overlay: test whiteout check in impure dir
Date: Mon, 19 Jun 2017 11:53:39 +0800
Message-ID: <1497844419-23824-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:8749 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdFSDvc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 18 Jun 2017 23:51:32 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, eguan@redhat.com, amir73il@gmail.com, miklos@szeredi.hu, yi.zhang@huawei.com, miaoxie@huawei.com

The unmerged and impure upper directories may contain invalid
whiteouts when we umount && modify lowerdir(e.g. clean up dir) and
remount overlay. This may lead to whiteouts exposure and rmdir
failure.

This case test impure dir's whiteouts check in ovl_iterate() and
ovl_remove_xxx().

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/031     | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/031.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 100 insertions(+)
 create mode 100755 tests/overlay/031
 create mode 100644 tests/overlay/031.out

diff --git a/tests/overlay/031 b/tests/overlay/031
new file mode 100755
index 0000000..674c11f
--- /dev/null
+++ b/tests/overlay/031
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test 031
+#
+# The unmerged and impure upper directories may contain invalid
+# whiteouts when we change lowerdir(e.g. clean up dir) and remount
+# overlay. This may lead to whiteouts exposure and rmdir failure.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Huawei.  All Rights Reserved.
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
+# create test directory and test file
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+mkdir -p $lowerdir/testdir
+touch $lowerdir/testdir/a
+
+# mount overlayfs and remove testfile to create a whiteout
+_scratch_mount
+
+rm -f $SCRATCH_MNT/testdir/a
+
+# unmount overlayfs but not base fs
+$UMOUNT_PROG $SCRATCH_MNT
+
+# clean up the lower directory and mount overlay again,
+# whiteout will expose.
+rm -rf $lowerdir/testdir
+
+_scratch_mount
+
+ls $SCRATCH_MNT/testdir
+
+# try to remove test dir from overlay dir, trigger ovl_remove_upper,
+# it will not clean up the dir and lead to rmdir failure.
+rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
+
+# umount overlay again, create a new file with the same name and
+# mount overlay again.
+$UMOUNT_PROG $SCRATCH_MNT
+touch $lowerdir/testdir
+
+_scratch_mount
+
+# try to remove test dir from overlay dir, trigger ovl_remove_and_whiteout,
+# it will not clean up the dir and lead to residue.
+rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
+ls $workdir/work
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/031.out b/tests/overlay/031.out
new file mode 100644
index 0000000..b3d0bb0
--- /dev/null
+++ b/tests/overlay/031.out
@@ -0,0 +1,2 @@
+QA output created by 031
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index c5048c4..4001820 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -33,3 +33,4 @@
 028 auto copyup quick
 029 auto quick
 030 auto quick perms
+031 auto quick
-- 
1.8.3.1

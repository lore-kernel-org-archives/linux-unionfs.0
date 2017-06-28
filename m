From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstest PATCH v2] overlay: test whiteout check in origin dir
Date: Wed, 28 Jun 2017 16:04:05 +0800
Message-ID: <1498637045-19185-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: fstests@vger.kernel.org
Cc: eguan@redhat.com, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com
List-Id: linux-unionfs@vger.kernel.org

The unmerged and origined directories may contain invalid
whiteouts when we umount && modify dir(e.g. clean up dir) and
remount overlay. This may lead to whiteouts exposure and rmdir
failure.

This case test origin dir's whiteouts check in ovl_iterate() and
ovl_remove_xxx().

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
v2:
 - add test of lower origin dir have whiteouts
 - add test of both upper and lower origin dirs have whiteouts
   (although this case is pass now, still add this to cover all
   three kinds of situations)
 - add to whiteout group
---
 tests/overlay/031     | 139 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/031.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 142 insertions(+)
 create mode 100755 tests/overlay/031
 create mode 100644 tests/overlay/031.out

diff --git a/tests/overlay/031 b/tests/overlay/031
new file mode 100755
index 0000000..7dd5f5f
--- /dev/null
+++ b/tests/overlay/031
@@ -0,0 +1,139 @@
+#! /bin/bash
+# FS QA Test 031
+#
+# The unmerged and origined directories may contain invalid
+# whiteouts when we change dir(e.g. clean up lowerdir) and remount
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
+# create test directory and test file, mount overlayfs and remove
+# testfile to create a whiteout.
+_create_whiteout()
+{
+	mkdir -p $1/testdir
+	touch $1/testdir/$4
+
+	_overlay_mount_dirs $1 $2 $3 $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+
+	rm -f $SCRATCH_MNT/testdir/$4
+
+	$UMOUNT_PROG $SCRATCH_MNT
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
+# create test directorys and whiteout
+lowerdir1=$OVL_BASE_SCRATCH_MNT/lower1
+lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
+testfile1=a
+testfile2=b
+mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
+
+_create_whiteout $lowerdir1 $upperdir $workdir $testfile1
+
+# clean up the lower directory and mount overlay again,
+# whiteout will expose.
+rm -rf $lowerdir1/testdir
+
+_overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
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
+touch $lowerdir1/testdir
+
+_overlay_mount_dirs $lowerdir1 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+
+# try to remove test dir from overlay dir, trigger ovl_remove_and_whiteout,
+# it will not clean up the dir and lead to residue.
+rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
+ls $workdir/work
+
+$UMOUNT_PROG $SCRATCH_MNT
+
+# exchange lower dir and upper dir, repeat ls and rmidr test again,
+# the lower dir will have invalid whiteout this time.
+rm -rf $lowerdir1/testdir
+rm -rf $upperdir/testdir
+
+_create_whiteout $lowerdir1 $upperdir $workdir $testfile1
+
+rm -rf $lowerdir1/testdir
+
+_overlay_mount_dirs $upperdir $lowerdir1 $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+
+ls $SCRATCH_MNT/testdir
+rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
+
+$UMOUNT_PROG $SCRATCH_MNT
+
+# let lower dir and upper dir both have invalid whiteouts, repeat ls and rmdir again.
+rm -rf $lowerdir1/testdir
+rm -rf $upperdir/testdir
+
+_create_whiteout $lowerdir1 $upperdir $workdir $testfile1
+
+rm -rf $lowerdir1/testdir
+_create_whiteout $lowerdir1 $lowerdir2 $workdir $testfile2
+
+_overlay_mount_dirs $lowerdir2 $upperdir $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+
+ls $SCRATCH_MNT/testdir
+rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
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
index c5048c4..64d200c 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -33,3 +33,4 @@
 028 auto copyup quick
 029 auto quick
 030 auto quick perms
+031 auto quick whiteout
-- 
1.8.3.1

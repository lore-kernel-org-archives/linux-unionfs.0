From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH xfstest v2 4/4] overlay: add fsck.overlay impure xattr test
Date: Thu, 28 Dec 2017 19:49:33 +0800
Message-ID: <20171228114933.47759-5-yi.zhang@huawei.com>
References: <20171228114933.47759-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3241 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751244AbdL1LmV (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Dec 2017 06:42:21 -0500
In-Reply-To: <20171228114933.47759-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Add fsck.overlay test case to test it how to deal with impure
xattr in underlying directories of overlayfs.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/203     | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/203.out |   3 ++
 tests/overlay/group   |   1 +
 3 files changed, 128 insertions(+)
 create mode 100755 tests/overlay/203
 create mode 100644 tests/overlay/203.out

diff --git a/tests/overlay/203 b/tests/overlay/203
new file mode 100755
index 0000000..f21dc6d
--- /dev/null
+++ b/tests/overlay/203
@@ -0,0 +1,124 @@
+#! /bin/bash
+# FS QA Test 203
+#
+# Test fsck.overlay how to deal with impure xattr in overlayfs.
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
+OVL_REDIRECT_XATTR="trusted.overlay.redirect"
+OVL_IMPURE_XATTR="trusted.overlay.impure"
+OVL_IMPURE_XATTR_VAL="y"
+
+# Create a redirect directory
+make_redirect_dir()
+{
+	local target=$1
+	local value=$2
+
+	mkdir -p $target
+	$SETFATTR_PROG -n $OVL_REDIRECT_XATTR -v $value $target
+}
+
+# Remove impure xattr
+remove_impure()
+{
+	local target=$1
+
+	$SETFATTR_PROG -x $OVL_IMPURE_XATTR $target
+}
+
+# Check impure xattr
+check_impure()
+{
+	local target=$1
+
+        value=$($GETFATTR_PROG --absolute-names --only-values \
+                -n $OVL_IMPURE_XATTR $target)
+
+        [[ $value == $OVL_IMPURE_XATTR_VAL ]] || echo "Missing impure xattr"
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
+# Test missing impure xattr in directory which has origin files, should fix
+echo "+ Missing impure"
+mkdir $lowerdir/testdir $upperdir/testdir
+touch $lowerdir/testdir/foo
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
+touch $SCRATCH_MNT/testdir/foo
+$UMOUNT_PROG $SCRATCH_MNT
+remove_impure $upperdir/testdir
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+	_fail "fsck should not fail"
+check_impure $upperdir/testdir
+rm -rf $lowerdir/* $upperdir/*
+
+# Test missing impure xattr in directory which has redirect directories,
+# should fix
+echo "+ Missing impure(2)"
+mkdir -p $lowerdir/origin
+make_redirect_dir $upperdir/testdir/subdir "/origin"
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+        _fail "fsck should not fail"
+check_impure $upperdir/testdir
+rm -rf $lowerdir/* $upperdir/*
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/203.out b/tests/overlay/203.out
new file mode 100644
index 0000000..3bedf2a
--- /dev/null
+++ b/tests/overlay/203.out
@@ -0,0 +1,3 @@
+QA output created by 203
++ Missing impure
++ Missing impure(2)
diff --git a/tests/overlay/group b/tests/overlay/group
index e39b5e0..f99d89e 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -51,3 +51,4 @@
 048 auto quick copyup hardlink
 201 auto quick fsck
 202 auto quick fsck
+203 auto quick fsck
-- 
2.5.0

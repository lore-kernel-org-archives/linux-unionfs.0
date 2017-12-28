From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH xfstest v2 3/4] overlay: add fsck.overlay redirect directory test
Date: Thu, 28 Dec 2017 19:49:32 +0800
Message-ID: <20171228114933.47759-4-yi.zhang@huawei.com>
References: <20171228114933.47759-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3239 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751417AbdL1LmW (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Dec 2017 06:42:22 -0500
In-Reply-To: <20171228114933.47759-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Add fsck.overlay test case to test it how to deal with invalid/valid/
duplicate redirect xattr in underlying directories of overlayfs.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/202     | 234 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/202.out |  10 +++
 tests/overlay/group   |   1 +
 3 files changed, 245 insertions(+)
 create mode 100755 tests/overlay/202
 create mode 100644 tests/overlay/202.out

diff --git a/tests/overlay/202 b/tests/overlay/202
new file mode 100755
index 0000000..91bff47
--- /dev/null
+++ b/tests/overlay/202
@@ -0,0 +1,234 @@
+#! /bin/bash
+# FS QA Test 202
+#
+# Test fsck.overlay how to deal with redirect xattr in overlayfs.
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
+. ./common/attr
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+_require_attrs
+_require_command "$FSCK_OVERLAY_PROG" fsck.overlay
+
+# remove all files from previous tests
+_scratch_mkfs
+
+OVL_REDIRECT_XATTR="trusted.overlay.redirect"
+OVL_OPAQUE_XATTR="trusted.overlay.opaque"
+OVL_OPAQUE_XATTR_VAL="y"
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
+# Check redirect xattr
+check_redirect()
+{
+	local expect=$1
+	local target=$2
+
+	value=$($GETFATTR_PROG --absolute-names --only-values \
+		-n $OVL_REDIRECT_XATTR $target)
+
+	[[ $value == $expect ]]	|| echo "Redirect xattr incorrect"
+}
+
+# Check opaque xattr
+check_opaque()
+{
+	local target=$1
+
+	value=$($GETFATTR_PROG --absolute-names --only-values \
+		-n $OVL_OPAQUE_XATTR $target)
+
+	[[ $value == $OVL_OPAQUE_XATTR_VAL ]] || echo "Opaque xattr incorrect"
+}
+
+# Check whiteout
+check_whiteout()
+{
+	local target=$1
+
+	target_type=`stat -c "%F:%t,%T" $target`
+
+	[[ $target_type == "character special file:0,0" ]] || \
+		echo "Whiteout missing"
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
+# Test invalid redirect xattr point to a nonexistent origin, should remove
+echo "+ Invalid redirect"
+make_redirect_dir $upperdir/testdir "abc"
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+	_fail "fsck should not fail"
+$GETFATTR_PROG --absolute-names -d -m $OVL_REDIRECT_XATTR $upperdir/testdir
+rm -rf $upperdir/*
+
+# Test invalid redirect xattr point to a file origin, should remove
+echo "+ Invalid redirect(2)"
+touch $lowerdir/origin
+make_redirect_dir $upperdir/testdir "origin"
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+	_fail "fsck should not fail"
+$GETFATTR_PROG --absolute-names -d -m $OVL_REDIRECT_XATTR $upperdir/testdir
+rm -rf $lowerdir/* $upperdir/*
+
+# Test valid redirect xattr point to a directory origin in the same directory,
+# should not remove
+echo "+ Valid redirect"
+mkdir $lowerdir/origin
+mknod $upperdir/origin c 0 0
+make_redirect_dir $upperdir/testdir "origin"
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+	_fail "fsck should not fail"
+check_redirect "origin" $upperdir/testdir
+rm -rf $lowerdir/* $upperdir/*
+
+# Test valid redirect xattr point to a directory origin in different directories
+# should not remove
+echo "+ Valid redirect(2)"
+mkdir $lowerdir/origin
+mknod $upperdir/origin c 0 0
+make_redirect_dir $upperdir/testdir1/testdir2 "/origin"
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+	_fail "fsck should not fail"
+check_redirect "/origin" $upperdir/testdir1/testdir2
+rm -rf $lowerdir/* $upperdir/*
+
+# Test valid redirect xattr but missing whiteout to cover lower target,
+# should fix whiteout
+echo "+ Missing whiteout"
+mkdir $lowerdir/origin
+make_redirect_dir $upperdir/testdir "origin"
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+	_fail "fsck should not fail"
+check_redirect "origin" $upperdir/testdir
+check_whiteout $upperdir/origin
+rm -rf $lowerdir/* $upperdir/*
+
+# Test valid redirect xattrs exchanged by rename, should not remove
+echo "+ Valid redirect(3)"
+mkdir $lowerdir/testdir1 $lowerdir/testdir2
+make_redirect_dir $upperdir/testdir1 "testdir2"
+make_redirect_dir $upperdir/testdir2 "testdir1"
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+        _fail "fsck should not fail"
+check_redirect "testdir2" $upperdir/testdir1
+check_redirect "testdir1" $upperdir/testdir2
+rm -rf $lowerdir/* $upperdir/*
+
+# Test valid redirect xattr with general directory cover lower origin
+# target, should ask user this directory is merged or not by default
+# and do nothing in auto mode
+echo "+ Valid redirect(4)"
+mkdir $lowerdir/origin
+mkdir $upperdir/origin
+make_redirect_dir $upperdir/testdir "origin"
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 || \
+	_fail "fsck should not fail"
+check_redirect "origin" $upperdir/testdir
+$GETFATTR_PROG --absolute-names -d -m $OVL_OPAQUE_XATTR $upperdir/testdir
+
+echo "n" > $tmp.input
+_overlay_fsck_dirs $lowerdir $upperdir $workdir <$tmp.input >> $seqres.full 2>&1 || \
+	_fail "fsck should not fail"
+check_redirect "origin" $upperdir/testdir
+check_opaque $upperdir/origin
+rm -rf $lowerdir/* $upperdir/*
+
+# Test invalid redirect xattr with lower same name directory exists,
+# should remove invalid xattr, and ask user directory merge or not
+# by default
+echo "+ Invalid redirect(3)"
+mkdir $lowerdir/testdir
+make_redirect_dir $upperdir/testdir "origin"
+
+echo "y" > $tmp.input
+echo "n" >> $tmp.input
+_overlay_fsck_dirs $lowerdir $upperdir $workdir <$tmp.input >> $seqres.full 2>&1 || \
+        _fail "fsck should not fail"
+$GETFATTR_PROG --absolute-names -d -m $OVL_REDIRECT_XATTR $upperdir/testdir
+check_opaque $upperdir/testdir
+rm -rf $lowerdir/* $upperdir/*
+
+# Test duplicate redirect directories point to one origin, should fail in
+# auto mode, should remove the duplicate one in yes mode
+echo "+ Duplicate redirect"
+mkdir $lowerdir/origin
+mknod $upperdir/origin c 0 0
+make_redirect_dir $upperdir/testdir1 "origin"
+make_redirect_dir $upperdir/testdir2 "origin"
+
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -p >> $seqres.full 2>&1 && \
+	_fail "fsck should fail"
+_overlay_fsck_dirs $lowerdir $upperdir $workdir -y >> $seqres.full 2>&1 || \
+	_fail "fsck should not fail"
+redirect_1=`check_redirect "origin" $upperdir/testdir1 2>/dev/null`
+redirect_2=`check_redirect "origin" $upperdir/testdir2 2>/dev/null`
+[[ $redirect_1 == $redirect_2 ]] && echo "Redirect xattr incorrect"
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/202.out b/tests/overlay/202.out
new file mode 100644
index 0000000..ae50d96
--- /dev/null
+++ b/tests/overlay/202.out
@@ -0,0 +1,10 @@
+QA output created by 202
++ Invalid redirect
++ Invalid redirect(2)
++ Valid redirect
++ Valid redirect(2)
++ Missing whiteout
++ Valid redirect(3)
++ Valid redirect(4)
++ Invalid redirect(3)
++ Duplicate redirect
diff --git a/tests/overlay/group b/tests/overlay/group
index 7c5fcbb..e39b5e0 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -50,3 +50,4 @@
 047 auto quick copyup hardlink
 048 auto quick copyup hardlink
 201 auto quick fsck
+202 auto quick fsck
-- 
2.5.0

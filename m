From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] overlay/030: test immutable and append-only upper files
Date: Wed,  5 Apr 2017 15:09:27 +0300
Message-ID: <1491394167-31409-1-git-send-email-amir73il@gmail.com>
References: <1491389271-24726-2-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35719 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752287AbdDEMJY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Apr 2017 08:09:24 -0400
In-Reply-To: <1491389271-24726-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Run the t_immutable test program for immutable/append-only files
and directories in an overlayfs upper directory.

This test is similar and was derived from generic/079, but
the original test is _notrun on overlay mount because FS_IOC_GETFLAGS
FS_IOC_SETFLAGS ioctls fail on overlay directory inodes.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/079     |  6 ++---
 tests/overlay/030     | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/030.out |  5 ++++
 tests/overlay/group   |  1 +
 4 files changed, 81 insertions(+), 4 deletions(-)
 create mode 100755 tests/overlay/030
 create mode 100644 tests/overlay/030.out

Eryu,

Here is v2 with fixes to your comments.

I also changed generic/079 to use modern _require_* statements.
and removed _scratch_unmount from its cleanup callback.

Amir.

diff --git a/tests/generic/079 b/tests/generic/079
index 5cceeba..c2db6bf 100755
--- a/tests/generic/079
+++ b/tests/generic/079
@@ -37,7 +37,6 @@ _cleanup()
     cd /
     echo "*** cleaning up"
     $timmutable -r $SCRATCH_MNT/$seq
-    _scratch_unmount
 }
 
 # get standard environment, filters and checks
@@ -48,11 +47,10 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-_require_chattr i
+_require_chattr ia
+_require_test_program "t_immutable"
 _require_scratch
 
-[ -x $timmutable ] || _notrun "t_immutable was not built for this platform"
-
 # real QA test starts here
 _scratch_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
diff --git a/tests/overlay/030 b/tests/overlay/030
new file mode 100755
index 0000000..bbce140
--- /dev/null
+++ b/tests/overlay/030
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FS QA Test No. 030
+#
+# Run the t_immutable test program for immutable/append-only files
+# and directories in an overlayfs upper directory.
+#
+# This test is similar and was derived from generic/079, but
+# the original test is _notrun on overlay mount because FS_IOC_GETFLAGS
+# FS_IOC_SETFLAGS ioctls fail on overlay directory inodes.
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
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+timmutable=$here/src/t_immutable
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	$timmutable -r $upperdir/t_immutable &> /dev/null
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_supported_fs overlay
+_supported_os Linux
+
+_require_chattr ia
+_require_test_program "t_immutable"
+_require_scratch
+
+_scratch_mkfs
+
+# Preparing immutable files in uppper dir
+mkdir -p $upperdir
+$timmutable -C $upperdir/t_immutable >$tmp.out 2>&1
+if grep -q -e 'Operation not supported' -e "Inappropriate ioctl" $tmp.out; then
+	_notrun "Setting immutable/append flag not supported"
+fi
+
+_scratch_mount
+
+# Test immutability of files in overlay
+$timmutable $SCRATCH_MNT/t_immutable 2>&1
+status=$?
+exit
diff --git a/tests/overlay/030.out b/tests/overlay/030.out
new file mode 100644
index 0000000..57ba0cd
--- /dev/null
+++ b/tests/overlay/030.out
@@ -0,0 +1,5 @@
+QA output created by 030
+testing immutable...PASS.
+testing append-only...PASS.
+testing immutable as non-root...PASS.
+testing append-only as non-root...PASS.
diff --git a/tests/overlay/group b/tests/overlay/group
index 7e72a30..c5048c4 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -32,3 +32,4 @@
 027 auto quick perms
 028 auto copyup quick
 029 auto quick
+030 auto quick perms
-- 
2.7.4

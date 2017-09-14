From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH xfstests 2/2] overlay: test chattr lower file in overlay
Date: Thu, 14 Sep 2017 20:04:03 +0800
Message-ID: <1505390643-6981-2-git-send-email-yi.zhang@huawei.com>
References: <1505390643-6981-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1505390643-6981-1-git-send-email-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: fstests@vger.kernel.org
Cc: eguan@redhat.com, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com
List-Id: linux-unionfs@vger.kernel.org

chattr with [iap..] attributes open file for read-only and
invoke ioctl(). If we chattr a lower file in overlay, it
will get the lower file but not trigger copy-up, so ioctl()
lead to modification of that lower file incorrectly. Add this
test for this case.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/040     | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/040.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 92 insertions(+)
 create mode 100755 tests/overlay/040
 create mode 100644 tests/overlay/040.out

diff --git a/tests/overlay/040 b/tests/overlay/040
new file mode 100755
index 0000000..4d0c7ef
--- /dev/null
+++ b/tests/overlay/040
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test 040
+#
+# chattr with [iap..] attributes open file for read-only and
+# invoke ioctl(). If we chattr a lower file in overlay, it
+# will get the lower file but not trigger copy-up, so ioctl()
+# lead to modification of that lower file.
+#
+# Upstream Commit 7c6893e3c9ab ("ovl: don't allow writing
+# ioctl on lower layer") return EPERM for this case to avoid
+# this issue.
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
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	$CHATTR_PROG -i $lowerdir/foo
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
+_require_chattr i
+
+# remove all files from previous runs
+_scratch_mkfs
+
+# prepare lower test file
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+mkdir -p $lowerdir
+touch $lowerdir/foo
+
+# mounting overlay
+_scratch_mount
+
+# Try to add immutable attributes in overlay, it will
+# open file for read-only and invoke ioctl(), it should not
+# modify lower origin file.
+$CHATTR_PROG +i $SCRATCH_MNT/foo > /dev/null 2>&1
+
+$UMOUNT_PROG $SCRATCH_MNT
+
+# touching origin file in lower, should succeed
+touch $lowerdir/foo > /dev/null 2>&1
+
+if [ $? -ne 0 ]; then
+        echo "Test Fail, immutable attributes is modified in lower."
+fi
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/040.out b/tests/overlay/040.out
new file mode 100644
index 0000000..9e3d4d9
--- /dev/null
+++ b/tests/overlay/040.out
@@ -0,0 +1,2 @@
+QA output created by 040
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 39177c4..4cd4af1 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -42,3 +42,4 @@
 037 auto quick mount
 038 auto quick copyup
 039 auto quick
+040 auto quick
-- 
2.5.0

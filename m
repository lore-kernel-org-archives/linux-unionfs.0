From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH xfstests 1/2] overlay: test relatime for directories
Date: Thu, 14 Sep 2017 20:04:02 +0800
Message-ID: <1505390643-6981-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:6056 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751800AbdINL72 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Sep 2017 07:59:28 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: eguan@redhat.com, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com

Add test access time update issue for directories in upper layer.

Upstream commit cd91304e7190 ("ovl: fix relatime for directories")
fixed this issue.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/039     | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/039.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 92 insertions(+)
 create mode 100755 tests/overlay/039
 create mode 100644 tests/overlay/039.out

diff --git a/tests/overlay/039 b/tests/overlay/039
new file mode 100755
index 0000000..cd81ce5
--- /dev/null
+++ b/tests/overlay/039
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test 039
+#
+# Test access time update issue for directories in upper layer.
+#
+# Upstream Commit cd91304e7190 ("ovl: fix relatime for directories")
+# fixed this issue.
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
+_require_relatime
+
+# remove all files from previous runs
+_scratch_mkfs
+
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+mkdir -p $upperdir/test
+
+_scratch_mount "-o relatime"
+
+# access test dir, it's access time will be updated normally
+ls $SCRATCH_MNT/test
+
+pre_access_time=`stat -c "%X" $SCRATCH_MNT/test`
+
+# In relatime mode, access time is only updated if the previous
+# access time was earlier than the current modify or change time,
+# so trigger modify and change time update.
+touch $SCRATCH_MNT/test/foo
+sleep 1
+
+# access test dir again
+ls $SCRATCH_MNT/test > /dev/null 2>&1
+
+cur_access_time=`stat -c "%X" $SCRATCH_MNT/test`
+
+# compare the results, current access time should later than the previous one
+if [ $cur_access_time -le $pre_access_time ] ; then
+	echo "Access time is not updated correctly."
+fi
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/039.out b/tests/overlay/039.out
new file mode 100644
index 0000000..d4e7ef6
--- /dev/null
+++ b/tests/overlay/039.out
@@ -0,0 +1,2 @@
+QA output created by 039
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index ac66bc7..39177c4 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -41,3 +41,4 @@
 036 auto quick mount
 037 auto quick mount
 038 auto quick copyup
+039 auto quick
-- 
2.5.0

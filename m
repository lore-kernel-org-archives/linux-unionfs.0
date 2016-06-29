From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 1/2] overlay: dentry leak for default_permissions mount option
Date: Wed, 29 Jun 2016 21:39:33 +0800
Message-ID: <1467207574-11082-1-git-send-email-eguan@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbcF2Nly (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 29 Jun 2016 09:41:54 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, xzhou@redhat.com, Eryu Guan <eguan@redhat.com>

overlayfs was leaking dentry on non-directories when using the
'default_permissions' mount option, which resulted in "BUG Dentry
still in use".

The following kernel commit fixed it:
ovl: fix dentry leak for default_permissions

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/overlay/009     | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/009.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 71 insertions(+)
 create mode 100755 tests/overlay/009
 create mode 100644 tests/overlay/009.out

diff --git a/tests/overlay/009 b/tests/overlay/009
new file mode 100755
index 0000000..de94ca4
--- /dev/null
+++ b/tests/overlay/009
@@ -0,0 +1,68 @@
+#! /bin/bash
+# FS QA Test 009
+#
+# dentry leak for default_permissions mount option
+#
+# This is fixed by kernel commit named as
+# ovl: fix dentry leak for default_permissions
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Red Hat Inc.  All Rights Reserved.
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
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create test file in lowerdir
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+mkdir -p $lowerdir
+touch $lowerdir/testfile
+
+# mount overlay with default_permissions option, get a reference on the dentry
+_scratch_mount -o default_permissions
+cat $SCRATCH_MNT/testfile
+
+# overlay will be unmounted by test harness and kernel BUG if dentry leaked
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/009.out b/tests/overlay/009.out
new file mode 100644
index 0000000..7e97715
--- /dev/null
+++ b/tests/overlay/009.out
@@ -0,0 +1,2 @@
+QA output created by 009
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 874bfdd..3f08cd3 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -11,3 +11,4 @@
 006 auto quick copyup whiteout
 007 auto quick
 008 auto quick whiteout
+009 auto quick
-- 
2.7.4

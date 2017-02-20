From: Xiong Zhou <xzhou@redhat.com>
Subject: [xfstests v3 6/8] overlay: can not change underlying immutable file
Date: Mon, 20 Feb 2017 16:48:42 +0800
Message-ID: <1487580524-21503-7-git-send-email-xzhou@redhat.com>
References: <1487580524-21503-1-git-send-email-xzhou@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751082AbdBTItO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Feb 2017 03:49:14 -0500
In-Reply-To: <1487580524-21503-1-git-send-email-xzhou@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, mszeredi@redhat.com, Xiong Zhou <xzhou@redhat.com>

Even timestamp change by touch.

CC: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Xiong Zhou <xzhou@redhat.com>
---
 tests/overlay/027     | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/027.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 90 insertions(+)
 create mode 100755 tests/overlay/027
 create mode 100644 tests/overlay/027.out

diff --git a/tests/overlay/027 b/tests/overlay/027
new file mode 100755
index 0000000..4bb0329
--- /dev/null
+++ b/tests/overlay/027
@@ -0,0 +1,87 @@
+#! /bin/bash
+# FS QA Test 027
+#
+# If underlying upper file is immutable, it should stays
+# untouchable in the overlayfs mount.
+#
+# Kernel commit below fixed it.
+# f2b20f6ee842 vfs: move permission checking into ...
+#
+# This reproducer was originally written by
+#     Miklos Szeredi <mszeredi@redhat.com>
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat Inc.  All Rights Reserved.
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
+	$CHATTR_PROG -i $upperdir/foo
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
+
+# Modify as appropriate.
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+_require_chattr
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Preparing immutable file
+upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
+mkdir -p $upperdir
+touch $upperdir/foo
+$CHATTR_PROG +i $upperdir/foo
+
+# Mounting overlay
+_scratch_mount
+
+# Touching immutable file in overlay, should fail.
+# Not filtering output here because of errno returned
+# varies among kernel versions:
+#   touch: setting times of 'foo': Operation not permitted
+#   touch: cannot touch 'foo': Permission denied
+if touch $SCRATCH_MNT/foo > /dev/null 2>&1 ; then
+	echo "Test Fail, you can't change an immutable file"
+else
+	echo "Silence is golden"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/027.out b/tests/overlay/027.out
new file mode 100644
index 0000000..ef78cda
--- /dev/null
+++ b/tests/overlay/027.out
@@ -0,0 +1,2 @@
+QA output created by 027
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 92afa8d..4db6751 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -29,3 +29,4 @@
 024 auto quick
 025 auto quick attr
 026 auto attr quick
+027 auto quick perms
-- 
1.8.3.1

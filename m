From: Xiong Zhou <xzhou@redhat.com>
Subject: [PATCH] overlay: copy up and remove from another namespace
Date: Wed,  4 Jan 2017 16:59:11 +0800
Message-ID: <1483520351-26897-1-git-send-email-xzhou@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753302AbdADI7l (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 4 Jan 2017 03:59:41 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, amurdaca@redhat.com, Xiong Zhou <xzhou@redhat.com>

Via unshare, copy up dir from lower dir then remove
them in another unshared namespace.

This would fail before v4.7 kernel with EPERM.

Kernel commit 3fe6e52f
  ovl: override creds with the ones from the superblock mounter
fixed this issue, with this reproducer provided. Original
reproducer was written by commit author:
Antonio Murdaca <amurdaca@redhat.com>

Signed-off-by: Xiong Zhou <xzhou@redhat.com>
---
 tests/overlay/020     | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/020.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 73 insertions(+)
 create mode 100755 tests/overlay/020
 create mode 100644 tests/overlay/020.out

diff --git a/tests/overlay/020 b/tests/overlay/020
new file mode 100755
index 0000000..4afd40a
--- /dev/null
+++ b/tests/overlay/020
@@ -0,0 +1,70 @@
+#! /bin/bash
+# FS QA Test 020
+#
+# Reproducer from kernel commit 3fe6e52
+#    ovl: override creds with the ones from the superblock mounter
+# Testing ovl copyup/namespace/cred issue.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Red Hat Inc. All Rights Reserved.
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
+
+# Modify as appropriate.
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+mkdir -p $lowerdir/dir
+
+_scratch_mount
+
+unshare -m -p -f -U -r bash -c \
+	"touch $SCRATCH_MNT/dir/{1,2,3}; rm -fR $SCRATCH_MNT/*"
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/020.out b/tests/overlay/020.out
new file mode 100644
index 0000000..20d7944
--- /dev/null
+++ b/tests/overlay/020.out
@@ -0,0 +1,2 @@
+QA output created by 020
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 66f780f..684ed45 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -22,3 +22,4 @@
 017 auto quick copyup
 018 auto quick copyup
 019 auto stress
+020 auto quick copyup perms
-- 
1.8.3.1

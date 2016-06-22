From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 3/3] overlay: create new file over whiteout
Date: Wed, 22 Jun 2016 19:38:58 +0800
Message-ID: <1466595538-23719-3-git-send-email-eguan@redhat.com>
References: <1466595538-23719-1-git-send-email-eguan@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbcFVLlY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 22 Jun 2016 07:41:24 -0400
In-Reply-To: <1466595538-23719-1-git-send-email-eguan@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

Create file/dir over whiteout by another user, uid/gid of the
file/dir should be current fsuid/fsgid, not the mounter's.

This upstream kernel patch fixed the issue
d0e13f5 ovl: fix uid/gid when creating over whiteout

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/overlay/008     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/008.out |  3 ++
 tests/overlay/group   |  1 +
 3 files changed, 89 insertions(+)
 create mode 100755 tests/overlay/008
 create mode 100644 tests/overlay/008.out

diff --git a/tests/overlay/008 b/tests/overlay/008
new file mode 100755
index 0000000..cb8667c
--- /dev/null
+++ b/tests/overlay/008
@@ -0,0 +1,85 @@
+#! /bin/bash
+# FS QA Test 008
+#
+# Create file/dir over whiteout by another user, uid/gid of the file/dir should
+# be current fsuid/fsgid, not the mounter's.
+#
+# This upstream kernel patch fixed the issue
+# d0e13f5 ovl: fix uid/gid when creating over whiteout
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
+_require_user
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create test file on lower dir, and chown to fsgqa user
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+mkdir $lowerdir
+touch $lowerdir/testfile
+chown fsgqa:fsgqa $lowerdir/testfile
+
+# chown upperdir to fsgqa user, so new file/dir can be created by the user
+upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
+mkdir $upperdir
+chown fsgqa:fsgqa $upperdir
+
+_scratch_mount
+
+# Remove testfile, whiteout created in lowerdir
+rm -f $SCRATCH_MNT/testfile
+
+# Create new file over whiteout and check the file ownership
+_user_do "touch $SCRATCH_MNT/testfile"
+stat -c %U:%G-%F $SCRATCH_MNT/testfile
+
+# Create new dir over whiteout and check ownership again
+rm -f $SCRATCH_MNT/testfile
+_user_do "mkdir $SCRATCH_MNT/testfile"
+stat -c %U:%G-%F $SCRATCH_MNT/testfile
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/008.out b/tests/overlay/008.out
new file mode 100644
index 0000000..6e17968
--- /dev/null
+++ b/tests/overlay/008.out
@@ -0,0 +1,3 @@
+QA output created by 008
+fsgqa:fsgqa-regular empty file
+fsgqa:fsgqa-directory
diff --git a/tests/overlay/group b/tests/overlay/group
index e29e540..874bfdd 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -10,3 +10,4 @@
 005 auto copyup quick
 006 auto quick copyup whiteout
 007 auto quick
+008 auto quick whiteout
-- 
2.7.4

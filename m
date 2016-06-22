From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 1/3] overlay: test visible whiteout issue after rename
Date: Wed, 22 Jun 2016 19:38:56 +0800
Message-ID: <1466595538-23719-1-git-send-email-eguan@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbcFVLlY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 22 Jun 2016 07:41:24 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

Test visible whiteout issue after renaming file from lowerdir to a
dir in upperdir.

Upstream commit 45d117389696 ("ovl: ignore lower entries when
checking purity of non-directory entries") fixed the issue

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/overlay/006     | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/006.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 80 insertions(+)
 create mode 100755 tests/overlay/006
 create mode 100644 tests/overlay/006.out

diff --git a/tests/overlay/006 b/tests/overlay/006
new file mode 100755
index 0000000..31f11ef
--- /dev/null
+++ b/tests/overlay/006
@@ -0,0 +1,77 @@
+#! /bin/bash
+# FS QA Test 006
+#
+# Test visible whiteout issue after renaming file from lowerdir to a dir in
+# upperdir.
+#
+# Upstream commit 45d117389696 ("ovl: ignore lower entries when checking purity
+# of non-directory entries") fixed the issue
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Red Hat Inc.,  All Rights Reserved.
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
+echo "Silence is golden"
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create test file/dir before mount
+mkdir $SCRATCH_DEV/$OVERLAY_LOWER_DIR
+mkdir $SCRATCH_DEV/$OVERLAY_UPPER_DIR
+touch $SCRATCH_DEV/$OVERLAY_LOWER_DIR/lowertestfile
+mkdir $SCRATCH_DEV/$OVERLAY_UPPER_DIR/uppertestdir
+
+_scratch_mount
+
+# rename lowertestfile to uppertestdir, this triggers copyup and creates
+# whiteout in $OVERLAY_UPPER_DIR
+mv $SCRATCH_MNT/lowertestfile $SCRATCH_MNT/uppertestdir
+# the lowertestfile can be removed
+rm $SCRATCH_MNT/uppertestdir/lowertestfile
+# no file no whiteout file in upptestdir
+ls $SCRATCH_MNT/uppertestdir
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/006.out b/tests/overlay/006.out
new file mode 100644
index 0000000..675c1b7
--- /dev/null
+++ b/tests/overlay/006.out
@@ -0,0 +1,2 @@
+QA output created by 006
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index d8fc597..78a67bf 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -8,3 +8,4 @@
 003 auto quick whiteout
 004 attr auto copyup quick
 005 auto copyup quick
+006 auto quick copyup whiteout
-- 
2.7.4

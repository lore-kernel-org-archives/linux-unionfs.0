From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 2/3] overlay: getcwd() after a failed rmdir
Date: Wed, 22 Jun 2016 19:38:57 +0800
Message-ID: <1466595538-23719-2-git-send-email-eguan@redhat.com>
References: <1466595538-23719-1-git-send-email-eguan@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbcFVLlY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 22 Jun 2016 07:41:24 -0400
In-Reply-To: <1466595538-23719-1-git-send-email-eguan@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

Test getcwd() failure after unsuccessful rmdir, the getcwd() call
should return the correct path.

Upstream commit ce9113bbcbf4 ("ovl: fix getcwd() failure after
unsuccessful rmdir") fixed this issue.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/overlay/007     | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/007.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 68 insertions(+)
 create mode 100755 tests/overlay/007
 create mode 100644 tests/overlay/007.out

diff --git a/tests/overlay/007 b/tests/overlay/007
new file mode 100755
index 0000000..ccf2b75
--- /dev/null
+++ b/tests/overlay/007
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test 007
+#
+# Test getcwd() failure after unsuccessful rmdir
+#
+# Upstream commit ce9113bbcbf4 ("ovl: fix getcwd() failure after unsuccessful
+# rmdir") fixed this issue
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
+_require_test
+
+rm -rf $TEST_DIR/$seq
+
+# make a non-empty dir $seq
+mkdir -p $TEST_DIR/$seq/$seq.sub
+# cd to it and call rmdir on it, rmdir should fail
+cd $TEST_DIR/$seq
+rmdir ../$seq >>$seqres.full 2>&1
+# getcwd should return the correct current dir
+pwd | _filter_test_dir
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/007.out b/tests/overlay/007.out
new file mode 100644
index 0000000..86aabe4
--- /dev/null
+++ b/tests/overlay/007.out
@@ -0,0 +1,2 @@
+QA output created by 007
+TEST_DIR/007
diff --git a/tests/overlay/group b/tests/overlay/group
index 78a67bf..e29e540 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -9,3 +9,4 @@
 004 attr auto copyup quick
 005 auto copyup quick
 006 auto quick copyup whiteout
+007 auto quick
-- 
2.7.4

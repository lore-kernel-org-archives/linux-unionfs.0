From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] generic: simple permission check on hard links
Date: Wed,  7 Sep 2016 18:26:09 +0800
Message-ID: <1473243969-12326-1-git-send-email-eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

Overlayfs had a bug that hardlinks don't share inode, if
chmod/chown/etc. is performed on one of the links then the inode
belonging to the other one won't be updated. The following patch
fixed this issue:

51f7e52 ovl: share inode for hard link

This is a simple test that has nothing overlayfs specific, so make
it a generic test.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/generic/377     | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/377.out |  3 +++
 tests/generic/group   |  1 +
 3 files changed, 77 insertions(+)
 create mode 100755 tests/generic/377
 create mode 100644 tests/generic/377.out

diff --git a/tests/generic/377 b/tests/generic/377
new file mode 100755
index 0000000..2e0b1fd
--- /dev/null
+++ b/tests/generic/377
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FS QA Test 377
+#
+# Simple permission check on hard links.
+#
+# Overlayfs had a bug that hardlinks don't share inode, if chmod/chown/etc.
+# is performed on one of the links then the inode belonging to the other
+# one won't be updated. The following patch fixed this issue
+#
+# 51f7e52 ovl: share inode for hard link
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os IRIX Linux
+_require_test
+_require_user
+
+# Setup testfile and its hardlink
+testfile=$TEST_DIR/testfile.$seq
+testlink=$testfile.hardlink
+rm -f $testfile $testlink
+echo "You should not see this" >$testfile
+ln $testfile $testlink
+
+# remove read permission from testfile and unprivileged user should have no
+# permission to read testfile and hardlink
+chmod -r $testfile
+_user_do "cat $testfile"
+_user_do "cat $testlink"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/377.out b/tests/generic/377.out
new file mode 100644
index 0000000..8833788
--- /dev/null
+++ b/tests/generic/377.out
@@ -0,0 +1,3 @@
+QA output created by 377
+Permission denied
+Permission denied
diff --git a/tests/generic/group b/tests/generic/group
index a81d126..4209300 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -380,3 +380,4 @@
 374 auto quick clone dedupe
 375 auto quick acl
 376 auto quick metadata
+377 auto quick metadata
-- 
2.7.4

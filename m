From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: [PATCH] overlay: test permission checks within upper layer
Date: Mon, 01 Feb 2016 00:24:49 +0300
Message-ID: <145427548927.28315.7391257381640174593.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36452 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294AbcAaVY4 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 31 Jan 2016 16:24:56 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, linux-unionfs@vger.kernel.org

Verify that unpriveleged user cannot copy-up and change file mode.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 tests/overlay/001     |   87 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/001.out |    2 +
 tests/overlay/group   |    6 +++
 3 files changed, 95 insertions(+)
 create mode 100755 tests/overlay/001
 create mode 100644 tests/overlay/001.out
 create mode 100644 tests/overlay/group

diff --git a/tests/overlay/001 b/tests/overlay/001
new file mode 100755
index 000000000000..28fdf2af2b57
--- /dev/null
+++ b/tests/overlay/001
@@ -0,0 +1,87 @@
+#! /bin/bash
+# FS QA Test 001
+#
+# Test permission checks for operations within upper layer
+#
+# Ubuntu CVE-2015-1328
+# acff81ec2c79 ("ovl: fix permission checking for setattr")
+# cf9a6784f7c1 ("ovl: setattr: check permissions before copy-up")
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Konstantin Khlebnikov.  All Rights Reserved.
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
+runas=$here/src/runas
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	rm -fr $TEST_DEV/lower/$seq.dir
+	rm -fr $TEST_DEV/upper/$seq.dir
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
+_require_test
+_need_to_be_root
+
+echo "Silence is golden."
+
+[ -x $runas ] || _notrun "$runas executable not found"
+
+cd $TEST_DEV/lower
+mkdir $seq.dir
+touch $seq.dir/file
+chmod 444 $seq.dir/file
+
+cd $TEST_DEV/upper
+mkdir $seq.dir
+chmod 555 $seq.dir
+
+cd $TEST_DIR
+$runas -u 99 -g 99 chmod 777 $seq.dir/file >/dev/null 2>&1
+
+cd $TEST_DEV/upper
+if [ -e $seq.dir/file ] ; then
+	echo "FAIL: unpriveleged user copied-up file into upper"
+	if [ `stat -c '%a' $seq.dir/file` != 444 ] ; then
+		echo "FAIL: unpriveleged user changed file attributes"
+	fi
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/001.out b/tests/overlay/001.out
new file mode 100644
index 000000000000..2d86e35be2fb
--- /dev/null
+++ b/tests/overlay/001.out
@@ -0,0 +1,2 @@
+QA output created by 001
+Silence is golden.
diff --git a/tests/overlay/group b/tests/overlay/group
new file mode 100644
index 000000000000..51a62cf64b89
--- /dev/null
+++ b/tests/overlay/group
@@ -0,0 +1,6 @@
+# QA groups control
+#
+# define groups and default group owners
+# do not start group name with a digit
+#
+001 perms auto quick

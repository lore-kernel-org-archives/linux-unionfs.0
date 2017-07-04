From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH][RFC] Run unionmount testsuite with new overlay/union test group
Date: Tue,  4 Jul 2017 15:14:11 +0300
Message-ID: <1499170451-24596-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34760 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752052AbdGDMNz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Jul 2017 08:13:55 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

This test group requires that unionmount-testsuite is installed
under src dir.

These tests use tmpfs and have no need for test nor scratch partition.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

unionmount-testsuite, written by David Howells, is a powerfull tool for
validating "union mounts", which nowadays, mostly means overlayfs.

The testsuite was enhanced with directory rename tests for kernel v4.10,
and with constant inode number verification for kernel v4.12.
The most recent repository is maintained on my github [1].

The tool is written in python. By default, it uses tmpfs for the
overlayfs layers and a complete run of all the tests in the most
basic configuration takes ~10 seconds on my laptop.

I have been using xfstests as a test harness to run unionmount-testsuite
with several configuration (e.g. layers on same/non-same fs) and I am quite
certain that more people can benefit from this setup.

The proposed patch is how I use the harness, but it raises some questions:
- How does xfstests community feel about relying on external repositories?
- How does xfstests community feel about including python sources in the
  xfstests repository?

There are probably very few, if any, people running the testsuite, besides
Miklos and myself and I personally have no strong preference towards
maintaining the tool in an external repository or in xfstests repository.

Thoughts?

Amir.

[1] https://github.com/amir73il/unionmount-testsuite

 common/rc             |  8 +++++++
 tests/overlay/100     | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/100.out |  2 ++
 tests/overlay/101     | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/101.out |  2 ++
 tests/overlay/102     | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/102.out |  2 ++
 tests/overlay/103     | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/103.out |  2 ++
 tests/overlay/group   |  4 ++++
 10 files changed, 264 insertions(+)
 create mode 100755 tests/overlay/100
 create mode 100644 tests/overlay/100.out
 create mode 100755 tests/overlay/101
 create mode 100644 tests/overlay/101.out
 create mode 100755 tests/overlay/102
 create mode 100644 tests/overlay/102.out
 create mode 100755 tests/overlay/103
 create mode 100644 tests/overlay/103.out

diff --git a/common/rc b/common/rc
index 57d596c..68513fb 100644
--- a/common/rc
+++ b/common/rc
@@ -1986,6 +1986,14 @@ _require_test_program()
     [ -x $SRC_TEST ] || _notrun "$SRC_TEST not built"
 }
 
+# this test requires that the unionmount testsuite is installed under src/
+_require_unionmount_testsuite()
+{
+	UNIONMOUNT_TESTSUITE=src/unionmount-testsuite
+	[ -x "$UNIONMOUNT_TESTSUITE/run" ] || \
+		_notrun "unionmount testsuite required."
+}
+
 # run an aio-dio program
 # $1 - command
 _run_aiodio()
diff --git a/tests/overlay/100 b/tests/overlay/100
new file mode 100755
index 0000000..fb1f828
--- /dev/null
+++ b/tests/overlay/100
@@ -0,0 +1,61 @@
+#! /bin/bash
+# FS QA Test 100
+#
+# Run unionmount testsuite to verify correctness
+# with single lower layer not on same fs as upper
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2017 CTERA Networks.  All Rights Reserved.
+# Author: Amir Goldstein <amir73il@gmail.com>
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
+_supported_fs overlay
+_supported_os Linux
+_require_tmpfs
+_require_unionmount_testsuite
+
+cd $UNIONMOUNT_TESTSUITE
+./run --ov --verify > $seqres.full
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/100.out b/tests/overlay/100.out
new file mode 100644
index 0000000..798c013
--- /dev/null
+++ b/tests/overlay/100.out
@@ -0,0 +1,2 @@
+QA output created by 100
+Silence is golden
diff --git a/tests/overlay/101 b/tests/overlay/101
new file mode 100755
index 0000000..95d575e
--- /dev/null
+++ b/tests/overlay/101
@@ -0,0 +1,61 @@
+#! /bin/bash
+# FS QA Test 101
+#
+# Run unionmount testsuite to verify correctness
+# with single lower layer on same fs as upper
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2017 CTERA Networks.  All Rights Reserved.
+# Author: Amir Goldstein <amir73il@gmail.com>
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
+_supported_fs overlay
+_supported_os Linux
+_require_tmpfs
+_require_unionmount_testsuite
+
+cd $UNIONMOUNT_TESTSUITE
+./run --ov --samefs --verify > $seqres.full
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/101.out b/tests/overlay/101.out
new file mode 100644
index 0000000..e651a91
--- /dev/null
+++ b/tests/overlay/101.out
@@ -0,0 +1,2 @@
+QA output created by 101
+Silence is golden
diff --git a/tests/overlay/102 b/tests/overlay/102
new file mode 100755
index 0000000..d23e8e6
--- /dev/null
+++ b/tests/overlay/102
@@ -0,0 +1,61 @@
+#! /bin/bash
+# FS QA Test 102
+#
+# Run unionmount testsuite to verify correctness
+# with multi lower layers not on same fs
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2017 CTERA Networks.  All Rights Reserved.
+# Author: Amir Goldstein <amir73il@gmail.com>
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
+_supported_fs overlay
+_supported_os Linux
+_require_tmpfs
+_require_unionmount_testsuite
+
+cd $UNIONMOUNT_TESTSUITE
+./run --ov=10 --verify > $seqres.full
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/102.out b/tests/overlay/102.out
new file mode 100644
index 0000000..86dd1f9
--- /dev/null
+++ b/tests/overlay/102.out
@@ -0,0 +1,2 @@
+QA output created by 102
+Silence is golden
diff --git a/tests/overlay/103 b/tests/overlay/103
new file mode 100755
index 0000000..b86c3ce
--- /dev/null
+++ b/tests/overlay/103
@@ -0,0 +1,61 @@
+#! /bin/bash
+# FS QA Test 103
+#
+# Run unionmount testsuite to verify correctness
+# with multi lower layers on same fs as upper
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2017 CTERA Networks.  All Rights Reserved.
+# Author: Amir Goldstein <amir73il@gmail.com>
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
+_supported_fs overlay
+_supported_os Linux
+_require_tmpfs
+_require_unionmount_testsuite
+
+cd $UNIONMOUNT_TESTSUITE
+./run --ov=10 --samefs --verify > $seqres.full
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/103.out b/tests/overlay/103.out
new file mode 100644
index 0000000..78212a3
--- /dev/null
+++ b/tests/overlay/103.out
@@ -0,0 +1,2 @@
+QA output created by 103
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index b55ed0c..4e74fd7 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -37,3 +37,7 @@
 032 auto quick copyup hardlink
 033 auto quick copyup hardlink
 034 auto quick copyup hardlink
+100 auto quick union nonsamefs
+101 auto quick union samefs
+102 auto union rotate nonsamefs
+103 auto union rotate samefs
-- 
2.7.4

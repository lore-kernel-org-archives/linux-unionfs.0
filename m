From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 2/2] overlay: test copy up files from lower dir
Date: Mon, 11 Jan 2016 19:38:21 +0800
Message-ID: <1452512301-22145-2-git-send-email-eguan@redhat.com>
References: <1452512301-22145-1-git-send-email-eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1452512301-22145-1-git-send-email-eguan@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

Test copy up files from lower dir that are <, =, > 4G in size.

Kernel commit 0480334fa604 ("ovl: use O_LARGEFILE in ovl_copy_up()")
fixed bug when copying up large file(>4G) from lower dir.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/overlay/001      | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/001.out  |  2 ++
 tests/overlay/Makefile | 20 +++++++++++++
 tests/overlay/group    |  6 ++++
 4 files changed, 104 insertions(+)
 create mode 100755 tests/overlay/001
 create mode 100644 tests/overlay/001.out
 create mode 100644 tests/overlay/Makefile
 create mode 100644 tests/overlay/group

diff --git a/tests/overlay/001 b/tests/overlay/001
new file mode 100755
index 0000000..5025a69
--- /dev/null
+++ b/tests/overlay/001
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test 002
+#
+# Test copy up files from lower dir that are <, =, > 4G in size.
+#
+# Kernel commit 0480334fa604 ("ovl: use O_LARGEFILE in ovl_copy_up()")
+# fixed bug when copying up large file from lower dir.
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
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create test files with different sizes in lower dir
+# $SCRATCH_DEV is actually a test dir used in overlay testing
+mkdir -p $SCRATCH_DEV/lower
+touch $SCRATCH_DEV/lower/zero_size
+$XFS_IO_PROG -fc "pwrite 0 4k" $SCRATCH_DEV/lower/less_than_4g >>$seqres.full
+$XFS_IO_PROG -fc "pwrite 4294963200 4k" $SCRATCH_DEV/lower/4gfile >>$seqres.full
+$XFS_IO_PROG -fc "pwrite 4g 4k" $SCRATCH_DEV/lower/larger_than_4g >>$seqres.full
+
+_scratch_mount
+
+echo "Silence is golden"
+
+# Open the files should succeed, no errors are expected (e.g. EFBIG)
+for f in $SCRATCH_MNT/*; do
+	$XFS_IO_PROG -c "open" $f >>$seqres.full
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/001.out b/tests/overlay/001.out
new file mode 100644
index 0000000..88678b8
--- /dev/null
+++ b/tests/overlay/001.out
@@ -0,0 +1,2 @@
+QA output created by 001
+Silence is golden
diff --git a/tests/overlay/Makefile b/tests/overlay/Makefile
new file mode 100644
index 0000000..63c9878
--- /dev/null
+++ b/tests/overlay/Makefile
@@ -0,0 +1,20 @@
+#
+# Copyright (c) 2016 Red Hat Inc.  All Rights Reserved.
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+OVERLAY_DIR = overlay
+TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(OVERLAY_DIR)
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_DIR)
+	$(INSTALL) -m 755 [0-9]?? $(TARGET_DIR)
+	$(INSTALL) -m 644 group $(TARGET_DIR)
+	$(INSTALL) -m 644 [0-9]??.* $(TARGET_DIR)
+
+# Nothing.
+install-dev install-lib:
diff --git a/tests/overlay/group b/tests/overlay/group
new file mode 100644
index 0000000..5056c3b
--- /dev/null
+++ b/tests/overlay/group
@@ -0,0 +1,6 @@
+# QA groups control file
+# Defines test groups and nominal group owners
+# - do not start group names with a digit
+# - comment line before each group is "new" description
+#
+001 auto quick copyup
-- 
1.8.3.1

Return-Path: <vgoyal@redhat.com>
Date: Thu, 10 Jan 2019 17:32:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] xfstest: overlay: File capabilities should not be lost over
 copy-up
Message-ID: <20190110223251.GA15463@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
Cc: guaneryu@gmail.com, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

Make sure file capabilities are not lost over copy-up when file is
opened for WRITE but nothing is actually written to it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tests/overlay/064     |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/064.out |    3 ++
 tests/overlay/group   |    1 
 3 files changed, 76 insertions(+)

Index: xfstests-dev/tests/overlay/064
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/tests/overlay/064	2019-01-10 17:06:28.806079686 -0500
@@ -0,0 +1,72 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test 064
+#
+# Make sure CAP_SETUID is not cleared over file copy up.
+#
+# Following commit introduced regression where if a lower file with
+# CAP_SETUID is opened for writing, and capability is cleared over copy up.
+#
+# bd64e57586d3 ("ovl: During copy up, first copy up metadata and then data")
+#
+# A later kernel patch will fix it. This test will help avoid introducing
+# such regressions again.
+#
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
+_require_command "$SETCAP_PROG" setcap
+_require_command "$GETCAP_PROG" getcap
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create test file
+lowerdir=${OVL_BASE_SCRATCH_MNT}/${OVL_LOWER}
+upperdir=${OVL_BASE_SCRATCH_MNT}/${OVL_UPPER}
+mkdir -p $lowerdir
+touch ${lowerdir}/file
+echo "This is lower" >> ${lowerdir}/file
+# set setuid bit
+$SETCAP_PROG cap_setuid+ep ${lowerdir}/file
+
+_scratch_mount
+
+# Trigger file copy up without actually writing anything to file.
+$XFS_IO_PROG -c "open -a" ${SCRATCH_MNT}/file >>$seqres.full
+
+# Make sure cap_setuid is still there
+$GETCAP_PROG ${SCRATCH_MNT}/file | _filter_scratch
+
+# unmount overlayfs
+$UMOUNT_PROG $SCRATCH_MNT
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
Index: xfstests-dev/tests/overlay/064.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/tests/overlay/064.out	2019-01-10 17:18:14.731461223 -0500
@@ -0,0 +1,3 @@
+QA output created by 064
+SCRATCH_MNT/file = cap_setuid+ep
+Silence is golden
Index: xfstests-dev/tests/overlay/group
===================================================================
--- xfstests-dev.orig/tests/overlay/group	2018-12-19 11:47:04.443031019 -0500
+++ xfstests-dev/tests/overlay/group	2019-01-10 15:43:28.053079686 -0500
@@ -66,3 +66,4 @@
 061 auto quick copyup
 062 auto quick exportfs
 063 auto quick whiteout
+064 auto quick copyup

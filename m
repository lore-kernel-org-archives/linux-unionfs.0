Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39079 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbeJaSwe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Oct 2018 14:52:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id y144-v6so13861207wmd.4
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Oct 2018 02:55:08 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH] overlay: create directory over deleted whiteout
Date: Wed, 31 Oct 2018 10:55:02 +0100
Message-Id: <20181031095502.12504-1-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

There's a bug in the overlayfs implementation starting from the very first
merged version that may cause an Oops of various forms if a directory is created
over a whiteout dentry, but the actual whiteout on the upper layer was removed
to the directory creation.

Reported by: kaixuxia <xiakaixu1987@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 tests/overlay/062     | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/062.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 63 insertions(+)
 create mode 100644 tests/overlay/062
 create mode 100644 tests/overlay/062.out

diff --git a/tests/overlay/062 b/tests/overlay/062
new file mode 100644
index 000000000000..b2cc350afefb
--- /dev/null
+++ b/tests/overlay/062
@@ -0,0 +1,60 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test 062
+#
+# Create dir over cached negative dentry, but whiteout removed from upper
+#
+# The following kernel commit fixed the kernel crash: ???
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
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+# Create test file
+lowerdir=${OVL_BASE_SCRATCH_MNT}/${OVL_LOWER}
+upperdir=${OVL_BASE_SCRATCH_MNT}/${OVL_UPPER}
+mkdir -p $lowerdir
+touch ${lowerdir}/file
+
+_scratch_mount
+
+rm ${SCRATCH_MNT}/file
+ls -l ${SCRATCH_MNT}/file > /dev/null 2>&1
+rm ${upperdir}/file
+mkdir ${SCRATCH_MNT}/file > /dev/null 2>&1
+
+# unmount overlayfs
+$UMOUNT_PROG $SCRATCH_MNT
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/062.out b/tests/overlay/062.out
new file mode 100644
index 000000000000..a1578f4842ef
--- /dev/null
+++ b/tests/overlay/062.out
@@ -0,0 +1,2 @@
+QA output created by 062
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index ccc71f3bf846..0d3ceed3602d 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -64,3 +64,4 @@
 059 auto quick copyup
 060 auto quick metacopy
 061 auto quick copyup
+062 auto quick whiteout
-- 
2.14.3

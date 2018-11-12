Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44322 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbeKLTku (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Nov 2018 14:40:50 -0500
Received: by mail-wr1-f68.google.com with SMTP id j17-v6so8509321wrq.11
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Nov 2018 01:48:23 -0800 (PST)
From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2] overlay: create directory over deleted whiteout
Date: Mon, 12 Nov 2018 10:48:18 +0100
Message-Id: <20181112094818.3742-1-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

There's a bug in the overlayfs implementation starting from the very first
merged version that may cause an Oops of various forms if a directory is
created over a whiteout dentry, but the actual whiteout on the upper layer
was removed to the directory creation.

Reported by: kaixuxia <xiakaixu1987@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 tests/overlay/063     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/063.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 69 insertions(+)
 create mode 100644 tests/overlay/063
 create mode 100644 tests/overlay/063.out

diff --git a/tests/overlay/063 b/tests/overlay/063
new file mode 100644
index 000000000000..0b62c2ca9a9d
--- /dev/null
+++ b/tests/overlay/063
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test 063
+#
+# Create dir over cached negative dentry, but whiteout removed from upper
+#
+# The following kernel commit fixed the kernel crash: 5e1275808630 ("ovl: check
+# whiteout in ovl_create_over_whiteout()")
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
+# Create whiteout and populate dcache with negative dentry
+
+rm ${SCRATCH_MNT}/file
+ls -l ${SCRATCH_MNT}/file > /dev/null 2>&1
+
+# Remove whiteout and try to create dir over negative dentry
+
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
diff --git a/tests/overlay/063.out b/tests/overlay/063.out
new file mode 100644
index 000000000000..de35fc52cfc4
--- /dev/null
+++ b/tests/overlay/063.out
@@ -0,0 +1,2 @@
+QA output created by 063
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 165f002d96ae..1c4acd640a30 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -65,3 +65,4 @@
 060 auto quick metacopy
 061 auto quick copyup
 062 auto quick exportfs
+063 auto quick whiteout
-- 
2.14.3

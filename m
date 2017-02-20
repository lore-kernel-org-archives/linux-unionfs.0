From: Xiong Zhou <xzhou@redhat.com>
Subject: [xfstests v3 7/8] overlay: test flock after copied up
Date: Mon, 20 Feb 2017 16:48:43 +0800
Message-ID: <1487580524-21503-8-git-send-email-xzhou@redhat.com>
References: <1487580524-21503-1-git-send-email-xzhou@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752374AbdBTItQ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Feb 2017 03:49:16 -0500
In-Reply-To: <1487580524-21503-1-git-send-email-xzhou@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, mszeredi@redhat.com, Xiong Zhou <xzhou@redhat.com>

Locks of file in lower dir should working after it's
been copied up.

CC: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Xiong Zhou <xzhou@redhat.com>
---
 tests/overlay/028     | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/028.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 83 insertions(+)
 create mode 100755 tests/overlay/028
 create mode 100644 tests/overlay/028.out

diff --git a/tests/overlay/028 b/tests/overlay/028
new file mode 100755
index 0000000..cf0b77a
--- /dev/null
+++ b/tests/overlay/028
@@ -0,0 +1,80 @@
+#! /bin/bash
+# FS QA Test 028
+#
+# When file in lower dir is locked and it's been copied up,
+# make sure the lock is working in overlayfs.
+#
+# Kernel commit below fixed it.
+# c568d68341be locks: fix file locking on overlayfs
+#
+# This reproducer was originally written by
+#     Miklos Szeredi <mszeredi@redhat.com>
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat Inc.  All Rights Reserved.
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
+# Modify as appropriate.
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+mkdir -p $lowerdir
+touch $lowerdir/foo
+
+# Mounting overlay
+_scratch_mount
+
+# Testing copyup and flock
+flock $SCRATCH_MNT/foo sleep 3 &
+# flock in subshell should fail with no output
+(sleep 1; echo bar > $SCRATCH_MNT/foo; \
+  flock -n $SCRATCH_MNT/foo echo LOCKED)
+
+wait
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/028.out b/tests/overlay/028.out
new file mode 100644
index 0000000..2615f73
--- /dev/null
+++ b/tests/overlay/028.out
@@ -0,0 +1,2 @@
+QA output created by 028
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 4db6751..cf058fc 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -30,3 +30,4 @@
 025 auto quick attr
 026 auto attr quick
 027 auto quick perms
+028 auto copyup quick
-- 
1.8.3.1

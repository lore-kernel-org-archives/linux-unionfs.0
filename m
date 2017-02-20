From: Xiong Zhou <xzhou@redhat.com>
Subject: [xfstests v3 4/8] overlay: permission check with cached acls in tmpfs
Date: Mon, 20 Feb 2017 16:48:40 +0800
Message-ID: <1487580524-21503-5-git-send-email-xzhou@redhat.com>
References: <1487580524-21503-1-git-send-email-xzhou@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44042 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752326AbdBTItI (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Feb 2017 03:49:08 -0500
In-Reply-To: <1487580524-21503-1-git-send-email-xzhou@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, mszeredi@redhat.com, Xiong Zhou <xzhou@redhat.com>

tmpfs does not implement ->get_acl method, overlayfs
need to get its cached acls in permission check when
lower or upper fs is tmpfs.

CC: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Xiong Zhou <xzhou@redhat.com>
---
 tests/overlay/025     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/025.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 88 insertions(+)
 create mode 100755 tests/overlay/025
 create mode 100644 tests/overlay/025.out

diff --git a/tests/overlay/025 b/tests/overlay/025
new file mode 100755
index 0000000..69d7f91
--- /dev/null
+++ b/tests/overlay/025
@@ -0,0 +1,85 @@
+#! /bin/bash
+# FS QA Test 025
+#
+# Overlayfs failed to get posix acls if lower or upper
+# fs is tmpfs.
+# Kernel commit below fixed it.
+# 5201dc449e4b ovl: use cached acl on underlying layer
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
+	$UMOUNT_PROG $tmp/tmpfs/mnt
+	$UMOUNT_PROG $tmp/tmpfs
+	rm -rf $tmp
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
+_require_user
+
+# create a tmpfs under $tmp
+mkdir -p $tmp/tmpfs
+$MOUNT_PROG -t tmpfs tmpfs $tmp/tmpfs || \
+  _notrun "this test requires a valid tmpfs"
+
+pushd $tmp/tmpfs > /dev/null 2>&1
+
+mkdir -p lower upper work mnt
+mkdir -p -m 0 upper/testd
+# grant permission for $qa_user
+setfacl -m u:$qa_user:rx upper/testd
+
+# mount overlay using dirs in tmpfs
+_overlay_mount_dirs lower upper work overlay mnt
+
+popd > /dev/null 2>&1
+
+# user accessing test dir, should be Okay
+_user_do "ls $tmp/tmpfs/mnt/testd"
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/025.out b/tests/overlay/025.out
new file mode 100644
index 0000000..3d70951
--- /dev/null
+++ b/tests/overlay/025.out
@@ -0,0 +1,2 @@
+QA output created by 025
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 0563a04..82fe69e 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -27,3 +27,4 @@
 022 auto quick
 023 auto quick attr
 024 auto quick
+025 auto quick attr
-- 
1.8.3.1

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay: test ro/rw fd data inconsistecies
Date: Thu, 24 Nov 2016 22:12:12 +0200
Message-ID: <1480018332-16567-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:36671 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757276AbcKXUMk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2016 15:12:40 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, Filipe Manana <fdmanana@suse.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Introduce a new test to demonstrates a known issue with overlayfs:
- process A opens file F for read
- process B writes new data to file F
- process A reads old data from file F

This issue is about to be fixed with a patch set by Miklos Szeredi.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/016     | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/016.out | 12 +++++++
 tests/overlay/group   |  1 +
 3 files changed, 111 insertions(+)
 create mode 100755 tests/overlay/016
 create mode 100644 tests/overlay/016.out

diff --git a/tests/overlay/016 b/tests/overlay/016
new file mode 100755
index 0000000..6d3e339
--- /dev/null
+++ b/tests/overlay/016
@@ -0,0 +1,98 @@
+#! /bin/bash
+# FSQA Test No. 016
+#
+# Test ro/rw fd data inconsistecies
+#
+# This simple test demonstrates a known issue with overlayfs:
+# - process A opens file F for read
+# - process B writes new data to file F
+# - process A reads old data from file F
+#
+#-----------------------------------------------------------------------
+#
+# Copyright (C) 2016 CTERA Networks. All Rights Reserved.
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
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+# Create our test files.
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+mkdir -p $lowerdir
+echo "This is old news" > $lowerdir/foo
+echo "This is old news" > $lowerdir/bar
+
+_scratch_mount
+
+cd $SCRATCH_MNT
+
+#
+# case #1:
+# open file for read (rofd)
+# open file for write (rwfd)
+# write to rwfd
+# read from rofd
+#
+$XFS_IO_PROG << EOF | _filter_xfs_io
+open -r foo
+open foo
+pwrite -S 0x61 0 16
+file 0
+pread -v 0 16
+EOF
+
+#
+# case #2:
+# mmap MAP_SHARED|PROT_READ of rofd
+# write to rwfd
+# read from mapped memory
+#
+$XFS_IO_PROG << EOF | _filter_xfs_io
+open -r bar
+mmap -r 0 16
+open bar
+pwrite -S 0x61 0 16
+mread -v 0 16
+EOF
+
+status=0
+exit
diff --git a/tests/overlay/016.out b/tests/overlay/016.out
new file mode 100644
index 0000000..52b8cd7
--- /dev/null
+++ b/tests/overlay/016.out
@@ -0,0 +1,12 @@
+QA output created by 016
+xfs_io> xfs_io> xfs_io> wrote 16/16 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+xfs_io> [000] foo            (foreign,non-sync,non-direct,read-only)
+ 001  foo            (foreign,non-sync,non-direct,read-write)
+xfs_io> 00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
+read 16/16 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+xfs_io> xfs_io> xfs_io> xfs_io> xfs_io> wrote 16/16 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+xfs_io> 00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
+xfs_io> 
\ No newline at end of file
diff --git a/tests/overlay/group b/tests/overlay/group
index 84850b1..5740d2a 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -18,3 +18,4 @@
 013 auto quick
 014 auto quick copyup
 015 auto quick whiteout
+016 auto quick
-- 
2.7.4

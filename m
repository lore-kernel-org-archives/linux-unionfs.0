From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] overlay: add a test for multiple redirects to the same lower dir
Date: Sun, 28 Jan 2018 11:07:30 +0200
Message-ID: <1517130450-7586-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:44760 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbeA1JGc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 28 Jan 2018 04:06:32 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Multiple redirects to the same lower dir will falsely return the
same st_ino/st_dev for two different upper dirs and will cause 'diff'
to falsely report that content of directories is the same when it is not.

This test checks that overalyfs detects and fails lookup of a multiply
redirected dir.

The check for multiply redirected dir was implemented by kernel commit
31747eda41ef ("ovl: hash directory inodes for fsnotify").

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

Originally, I wrote this test to check directory indexing, which is only
enabled by nfs_export feature.

When I posted v1 of this test, I questioned whether the inconsistency
checked by this test is something that overlayfs driver should check on
lookup or we should leave that check entirely to fsck.overlay.

Since I posted v1 of this test, the following happenend:
1. A bug was reported with overlayfs+inotify
2. A fix I posted for the overlayfs+inotify bug had a nice by-product
   of detecting multiply redirected dirs on lookup
3. A later NFS export patch I posted, 0aceb53e73be ("ovl: do not pass
   overlay dentry to ovl_get_inode()") had subtly broken the
   overlayfs+inotify fix, although the LTP test case I wrote wasn't
   good enough to detect that breakage
4. The multiply redirected test did detect the breakage of the
   "by-prodyct", leading me to post a fix for the breakage ("ovl: fix
   regression in fsnotify of overlay merge dir")

At this time, both overlayfs+inotify bug fix and the breaking commit
are on overlayfs-next, so this test is expected to:
- fail on upstream
- fail on overlayfs-next with nfs_export=off
- pass on overlayfs-next with nfs_export=on

After applying the breakage fix, this test in expected to pass with any
overlayfs configuration.

In other words, besides different expectations and naming a fix commit
in the test header, there are no changes since v1 posting.

Amir.

 tests/overlay/049     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/049.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 112 insertions(+)
 create mode 100755 tests/overlay/049
 create mode 100644 tests/overlay/049.out

diff --git a/tests/overlay/049 b/tests/overlay/049
new file mode 100755
index 0000000..b6a9b67
--- /dev/null
+++ b/tests/overlay/049
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test 049
+#
+# Test multiple redirects to the same lower dir.
+#
+# Multiple redirects to the same lower dir will falsely return the same
+# st_ino/st_dev for two different upper dirs and will cause 'diff' to
+# falsely report that content of directories is the same when it is not.
+#
+# This test checks that overlayfs detects and fails lookup of a multiply
+# redirected dir.
+#
+# The check for multiply redirected dir was implemented by kernel commit
+#   31747eda41ef ("ovl: hash directory inodes for fsnotify")
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2017 CTERA Networks. All Rights Reserved.
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
+# Rename lower dir to create a redirected upper dir and
+# touch lower file to create copy up with origin xattr
+create_redirect()
+{
+	local redirect=$1
+
+	mkdir -p $lowerdir/origin
+	touch $lowerdir/origin/file
+
+	_scratch_mount -o redirect_dir=on
+	touch $SCRATCH_MNT/origin/file
+	mv $SCRATCH_MNT/origin $SCRATCH_MNT/$redirect
+
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+_require_scratch_feature redirect_dir
+
+# remove all files from previous runs
+_scratch_mkfs
+
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+
+# Create redirected dir with copied up file
+create_redirect redirect1
+# Duplicate the redirected dir and copied up file
+cp -a $upperdir/redirect1 $upperdir/redirect2
+
+# Diverge the content of the two copies of file
+# and the content of two copies of redirected dir
+echo right >> $upperdir/redirect1/file
+touch $upperdir/redirect1/right
+echo wrong >> $upperdir/redirect2/file
+touch $upperdir/redirect2/wrong
+
+_scratch_mount -o "redirect_dir=on"
+
+# If both copies of file/dir use the same st_dev/st_ino in overlay
+# diff won't detect that their content differs
+diff -q $SCRATCH_MNT/redirect1/file $SCRATCH_MNT/redirect2/file &>/dev/null && \
+	echo "diff on files inside duplicate redirect parent doesn't know right from wrong!"
+
+diff -q $SCRATCH_MNT/redirect1 $SCRATCH_MNT/redirect2 &> /dev/null && \
+	echo "diff on duplicate redirect dirs doesn't know right from wrong!"
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/049.out b/tests/overlay/049.out
new file mode 100644
index 0000000..c69568a
--- /dev/null
+++ b/tests/overlay/049.out
@@ -0,0 +1,2 @@
+QA output created by 049
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index edea64a..4e138b9 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -49,3 +49,4 @@
 044 auto quick copyup hardlink nonsamefs
 047 auto quick copyup hardlink
 048 auto quick copyup hardlink
+049 auto quick copyup redirect
-- 
2.7.4

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 5/5] overlay: test mount error cases with exclusive directories
Date: Wed, 12 Jul 2017 15:07:59 +0300
Message-ID: <1499861279-18789-1-git-send-email-amir73il@gmail.com>
References: <1499802726-11045-6-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35255 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756539AbdGLMHs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jul 2017 08:07:48 -0400
In-Reply-To: <1499802726-11045-6-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Overlayfs is often used to mount several mounts that share a single
lower dir, but every overlayfs mount should have its own private
upperdir and private workdir.

Overlayfs mount on kernel <= v4.12 does not check if upper/work dirs
are currently in-use by another overlayfs mount on the system and bad
things can happen with such configuration.

Expect EBUSY when trying to mount overlay when:
- Upper dir is in-use by another overlay mount
- Work dir is in-use by another overlay mount

This test does not depend on the overlay index feature.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/036     | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/036.out |  3 ++
 tests/overlay/group   |  1 +
 3 files changed, 95 insertions(+)
 create mode 100755 tests/overlay/036
 create mode 100644 tests/overlay/036.out

diff --git a/tests/overlay/036 b/tests/overlay/036
new file mode 100755
index 0000000..d44efc1
--- /dev/null
+++ b/tests/overlay/036
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FS QA Test 036
+#
+# Test mount error cases with exclusive directories
+#
+# Overlayfs is often used to mount several mounts that share a single
+# lower dir, but every overlayfs mount should have its own private
+# upperdir and private workdir.
+#
+# Overlayfs mount on kernel <= v4.12 does not check if upper/work dirs
+# are currently in-use by another overlayfs mount on the system and bad
+# things can happen with such configuration.
+#
+# Expect EBUSY when trying to mount overlay when:
+# - Upper dir is in-use by another overlay mount
+# - Work dir is in-use by another overlay mount
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
+	# unmount the two extra mounts in case they did not fail
+	$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
+	$UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
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
+# Create multiple lowerdirs, upperdirs and workdirs
+lowerdir=$OVL_BASE_SCRATCH_MNT/lower
+lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+upperdir2=$OVL_BASE_SCRATCH_MNT/upper2
+workdir=$OVL_BASE_SCRATCH_MNT/workdir
+workdir2=$OVL_BASE_SCRATCH_MNT/workdir2
+mkdir -p $lowerdir $lowerdir2 $upperdir $upperdir2 $workdir $workdir2
+
+# Mount overlay with lowerdir, upperdir, workdir
+_overlay_mount_dirs $lowerdir $upperdir $workdir \
+		    overlay1 $SCRATCH_MNT
+# Try to mount another overlay with the same upperdir - expect EBUSY
+_overlay_mount_dirs $lowerdir2 $upperdir $workdir2 \
+		    overlay2 $SCRATCH_MNT 2>&1 | _filter_scratch
+# Try to mount another overlay with the same workdir - expect EBUSY
+_overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
+		    overlay3 $SCRATCH_MNT 2>&1 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/overlay/036.out b/tests/overlay/036.out
new file mode 100644
index 0000000..5174611
--- /dev/null
+++ b/tests/overlay/036.out
@@ -0,0 +1,3 @@
+QA output created by 036
+mount: overlay2 is already mounted or SCRATCH_MNT busy
+mount: overlay3 is already mounted or SCRATCH_MNT busy
diff --git a/tests/overlay/group b/tests/overlay/group
index 87e3aaf..4cc1d74 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -38,3 +38,4 @@
 033 auto quick copyup hardlink
 034 auto quick copyup hardlink
 035 auto quick mount
+036 auto quick mount
-- 
2.7.4

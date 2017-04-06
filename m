From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 3/3] overlay/030: test immutable and append-only upper files
Date: Thu,  6 Apr 2017 08:49:20 +0300
Message-ID: <1491457760-9240-3-git-send-email-amir73il@gmail.com>
References: <1491457760-9240-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1491457760-9240-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Run the t_immutable test program for immutable/append-only files
and directories in an overlayfs upper directory.

This test is similar and was derived from generic/079, but
the original test is _notrun on overlay mount because FS_IOC_GETFLAGS
FS_IOC_SETFLAGS ioctls fail on overlay directory inodes.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/030     | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/030.out |  5 ++++
 tests/overlay/group   |  1 +
 3 files changed, 79 insertions(+)
 create mode 100755 tests/overlay/030
 create mode 100644 tests/overlay/030.out

Eryu,

My previous statement that overlayfs does not enforce directory immutable
directory inodes was wrong. The directory tests do pass because overlayfs
does the right thing.

So only failures are for open(O_TRUNC) and truncate() of IS_APPEND
regular file inodes, which shouldn't be too hard to fix:

QA output created by 030
open(/mnt/scratch/ovl-mnt/t_immutable/append-only.f, O_RDWR) did not fail
open(/mnt/scratch/ovl-mnt/t_immutable/append-only.f, O_WRONLY) did not fail
open(/mnt/scratch/ovl-mnt/t_immutable/append-only.f, O_RDWR|O_TRUNC) did not fail
open(/mnt/scratch/ovl-mnt/t_immutable/append-only.f, O_WRONLY|O_TRUNC) did not fail
open(/mnt/scratch/ovl-mnt/t_immutable/append-only.f, O_RDWR|O_APPEND|O_TRUNC) did not fail
open(/mnt/scratch/ovl-mnt/t_immutable/append-only.f, O_WRONLY|O_APPEND|O_TRUNC) did not fail
truncate(/mnt/scratch/ovl-mnt/t_immutable/append-only.f, 0) did not fail
testing immutable...PASS.
testing append-only...FAILED! (7 tests failed)


diff --git a/tests/overlay/030 b/tests/overlay/030
new file mode 100755
index 0000000..bbce140
--- /dev/null
+++ b/tests/overlay/030
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FS QA Test No. 030
+#
+# Run the t_immutable test program for immutable/append-only files
+# and directories in an overlayfs upper directory.
+#
+# This test is similar and was derived from generic/079, but
+# the original test is _notrun on overlay mount because FS_IOC_GETFLAGS
+# FS_IOC_SETFLAGS ioctls fail on overlay directory inodes.
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
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+timmutable=$here/src/t_immutable
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	$timmutable -r $upperdir/t_immutable &> /dev/null
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_supported_fs overlay
+_supported_os Linux
+
+_require_chattr ia
+_require_test_program "t_immutable"
+_require_scratch
+
+_scratch_mkfs
+
+# Preparing immutable files in uppper dir
+mkdir -p $upperdir
+$timmutable -C $upperdir/t_immutable >$tmp.out 2>&1
+if grep -q -e 'Operation not supported' -e "Inappropriate ioctl" $tmp.out; then
+	_notrun "Setting immutable/append flag not supported"
+fi
+
+_scratch_mount
+
+# Test immutability of files in overlay
+$timmutable $SCRATCH_MNT/t_immutable 2>&1
+status=$?
+exit
diff --git a/tests/overlay/030.out b/tests/overlay/030.out
new file mode 100644
index 0000000..57ba0cd
--- /dev/null
+++ b/tests/overlay/030.out
@@ -0,0 +1,5 @@
+QA output created by 030
+testing immutable...PASS.
+testing append-only...PASS.
+testing immutable as non-root...PASS.
+testing append-only as non-root...PASS.
diff --git a/tests/overlay/group b/tests/overlay/group
index 7e72a30..c5048c4 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -32,3 +32,4 @@
 027 auto quick perms
 028 auto copyup quick
 029 auto quick
+030 auto quick perms
-- 
2.7.4

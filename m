From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH 2/2] overlay/045: add test for syncfs
Date: Tue, 05 Dec 2017 23:50:34 +0800
Message-ID: <B4077824-4B28-4DC1-9407-33EF2316A4F2@icloud.com>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>, Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Chengguang Xu <cgxu519@icloud.com>
List-Id: linux-unionfs@vger.kernel.org

Run syncfs and shutdown upper filesystem to check syncfs result.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
tests/overlay/045     | 107 =
++++++++++++++++++++++++++++++++++++++++++++++++++
tests/overlay/045.out |   2 +
tests/overlay/group   |   1 +
3 files changed, 110 insertions(+)
create mode 100755 tests/overlay/045
create mode 100644 tests/overlay/045.out

diff --git a/tests/overlay/045 b/tests/overlay/045
new file mode 100755
index 0000000..402a955
--- /dev/null
+++ b/tests/overlay/045
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test 045
+#
+# Inspired by syncfs bug of overlayfs.=20
+# Run syncfs and shutdown upper filesystem to check syncfs result.
+# Test will be skipped if underlying upper filesystem does not support
+# shutdown or syncfs syscall.
+#
=
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Chengguang Xu <cgxu519@icloud.com>.
+# All Rights Reserved.
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
=
+#-----------------------------------------------------------------------
+#
+
+seq=3D`basename $0`
+seqres=3D$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=3D`pwd`
+tmp=3D/tmp/$$
+status=3D0
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
+_require_test
+_require_scratch
+_require_scratch_shutdown
+_require_xfs_io_command "syncfs"
+
+# if error
+
+PREFIX=3D${seq}-testfile
+TESTFILES=3D${PREFIX}-*
+FCNT=3D1000
+
+write_data()
+{
+	if [ $1 -eq 0 ]; then
+		TARGET=3D$TEST_DIR	=09
+	else
+		TARGET=3D$SCRATCH_MNT
+	fi
+
+	rm -f $TARGET/$TESTFILES >/dev/null 2>&1
+	for i in `seq 1 $FCNT`; do
+		$XFS_IO_PROG -f -c "pwrite 1K 1K" \
+				${TARGET}/${PREFIX}-$i >/dev/null 2>&1
+	done
+}
+
+
+check_data()
+{
+	diff -r $TEST_DIR $SCRATCH_MNT
+	if [ $? -ne 0 ]; then
+		status=3D1
+	fi
+}
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+write_data 0
+echo 3 > /proc/sys/vm/drop_caches
+
+write_data 1
+$XFS_IO_PROG -c "syncfs" $SCRATCH_MNT/${PREFIX}-${FCNT} >/dev/null 2>&1
+
+_scratch_shutdown
+_scratch_cycle_mount
+check_data
+
+rm -f $TEST_DIR/$TESTFILES >/dev/null 2>&1
+rm -f $SCRATCH_MNT/$TESTFILES >/dev/null 2>&1
+
+echo "Silence is golden"
+exit
diff --git a/tests/overlay/045.out b/tests/overlay/045.out
new file mode 100644
index 0000000..66276cf
--- /dev/null
+++ b/tests/overlay/045.out
@@ -0,0 +1,2 @@
+QA output created by 045
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index b32c6cd..eccd7d0 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -47,3 +47,4 @@
042 auto quick copyup hardlink
043 auto quick copyup nonsamefs
044 auto quick copyup hardlink nonsamefs
+045 auto quick sync
--=20
1.8.3.1=

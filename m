Return-Path: <cgxu519@mykernel.net>
From: Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20191022122621.27374-1-cgxu519@mykernel.net>
Subject: [PATCH] overlay/066: copy-up test for variant sparse files
Date: Tue, 22 Oct 2019 20:26:21 +0800
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf8
To: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
Cc: guaneryu@gmail.com, amir73il@gmail.com, miklos@szeredi.hu, Chengguang Xu <cgxu519@mykernel.net>
List-ID: <linux-unionfs@vger.kernel.org>

This is intensive copy-up test for sparse files,
these cases are mainly used for regression test
of copy-up improvement for sparse files.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 tests/overlay/066     | 108 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/066.out |   2 +
 tests/overlay/group   |   1 +
 3 files changed, 111 insertions(+)
 create mode 100755 tests/overlay/066
 create mode 100644 tests/overlay/066.out

diff --git a/tests/overlay/066 b/tests/overlay/066
new file mode 100755
index 00000000..0394b14e
--- /dev/null
+++ b/tests/overlay/066
@@ -0,0 +1,108 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Chengguang Xu <cgxu519@mykernel.net>. All Rights Rese=
rved.
+#
+# FS QA Test 066
+#
+# Test overlayfs copy-up function for variant sparse files.
+#
+seq=3D`basename $0`
+seqres=3D$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=3D`pwd`
+tmp=3D/tmp/$$
+status=3D1=09# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+=09cd /
+=09rm -f $tmp.*
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
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_scratch
+
+# Remove all files from previous tests
+_scratch_mkfs
+_require_fs_space $OVL_BASE_SCRATCH_MNT $((10*1024*13 + 100*1024))
+
+lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
+testfile=3D"copyup_sparse_test"
+mkdir -p $lowerdir
+
+# Create a completely empty hole file.
+$XFS_IO_PROG -fc "truncate 10M" "${lowerdir}/${testfile}_empty_holefile" >=
>$seqres.full
+
+iosize=3D`stat -c %o "${lowerdir}/${testfile}_empty_holefile"`
+if [ $iosize -le 1024 ]; then
+=09ioszie=3D1
+else
+=09iosize=3D`expr $iosize / 1024`
+fi
+
+# Create test files with different hole size patterns.
+while [ $iosize -le 2048 ]; do
+=09pos=3D$iosize
+=09$XFS_IO_PROG -fc "truncate 10M" "${lowerdir}/${testfile}_iosize${iosize=
}K_holefile" >>$seqres.full
+=09while [ $pos -lt 8192 ]; do
+=09=09$XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" "${lowerdir}/${testfile=
}_iosize${iosize}K_holefile" >>$seqres.full
+=09=09pos=3D`expr $pos + $iosize + $iosize`
+=09done
+=09iosize=3D`expr $iosize + $iosize`
+done
+
+# Create test file with many random holes(1M~2M).
+$XFS_IO_PROG -fc "truncate 100M" "${lowerdir}/${testfile}_random_holefile"=
 >>$seqres.full
+pos=3D2048
+while [ $pos -le 81920 ]; do
+=09iosize=3D`expr $RANDOM % 2048`
+=09if [ $iosize -lt 1024 ]; then
+=09=09iosize=3D`expr $iosize + 1024`
+=09fi
+=09$XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" "${lowerdir}/${testfile}_r=
andom_holefile" >>$seqres.full
+=09pos=3D`expr $pos + $iosize + $iosize`
+done
+
+_scratch_mount
+
+# Open the files should succeed, no errors are expected.
+for f in $SCRATCH_MNT/*; do
+=09$XFS_IO_PROG -c "open" $f >>$seqres.full
+done
+
+echo "Silence is golden"
+
+# Check all copy-up files in upper layer.
+iosize=3D`stat -c %o "${lowerdir}/${testfile}_empty_holefile"`
+if [ $iosize -le 1024 ]; then
+=09ioszie=3D1
+else
+=09iosize=3D`expr $iosize / 1024`
+fi
+
+while [ $iosize -le 2048 ]; do
+=09diff "${lowerdir}/${testfile}_iosize${iosize}K_holefile" "${upperdir}/$=
{testfile}_iosize${iosize}K_holefile" >>$seqres.full
+=09iosize=3D`expr $iosize + $iosize`
+done
+
+diff "${lowerdir}/${testfile}_empty_holefile"  "${upperdir}/${testfile}_em=
pty_holefile"  >>$seqres.full
+diff "${lowerdir}/${testfile}_random_holefile" "${upperdir}/${testfile}_ra=
ndom_holefile" >>$seqres.full
+
+# success, all done
+status=3D0
+exit
diff --git a/tests/overlay/066.out b/tests/overlay/066.out
new file mode 100644
index 00000000..b60cc24c
--- /dev/null
+++ b/tests/overlay/066.out
@@ -0,0 +1,2 @@
+QA output created by 066
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index ef8517a1..1dec7db9 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -68,3 +68,4 @@
 063 auto quick whiteout
 064 auto quick copyup
 065 auto quick mount
+066 auto quick copyup
--=20
2.20.1

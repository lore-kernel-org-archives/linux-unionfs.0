From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] generic/396: test correct d_type value
Date: Mon, 19 Dec 2016 18:15:08 +0200
Message-ID: <1482164108-19389-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35739 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933529AbcLSQP3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Dec 2016 11:15:29 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Verify correct d_type values of dir enrties.

This test would fail for file systems with no d_type support,
but I have no idea how to test d_type support in a generic way,
without confusing a bug of d_type = DT_UNKNOWN with no support.

I wonder if anybody is interested in testing a file system
with no d_type support.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .gitignore            |   1 +
 src/Makefile          |   2 +-
 src/t_dir_type.c      | 106 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/396     |  72 ++++++++++++++++++++++++++++++++++
 tests/generic/396.out |   7 ++++
 tests/generic/group   |   1 +
 6 files changed, 188 insertions(+), 1 deletion(-)
 create mode 100644 src/t_dir_type.c
 create mode 100755 tests/generic/396
 create mode 100644 tests/generic/396.out

diff --git a/.gitignore b/.gitignore
index b8d13a0..7dcea14 100644
--- a/.gitignore
+++ b/.gitignore
@@ -94,6 +94,7 @@
 /src/t_access_root
 /src/t_dir_offset
 /src/t_dir_offset2
+/src/t_dir_type
 /src/t_futimens
 /src/t_getcwd
 /src/t_holes
diff --git a/src/Makefile b/src/Makefile
index 4056496..94d74aa 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -21,7 +21,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
 	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
-	attr-list-by-handle-cursor-test listxattr dio-interleaved
+	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type
 
 SUBDIRS =
 
diff --git a/src/t_dir_type.c b/src/t_dir_type.c
new file mode 100644
index 0000000..32f58cf
--- /dev/null
+++ b/src/t_dir_type.c
@@ -0,0 +1,106 @@
+/*
+ * Copyright (C) 2016 CTERA Networks. All Rights Reserved.
+ * Author: Amir Goldstein <amir73il@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * t_dir_type
+ *
+ * print directory entries, optionally filtered by d_type
+ *
+ * ./t_dir_type <path> [f|d|c|b|l|p|w]
+ */
+
+#include <fcntl.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <dirent.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+
+struct linux_dirent64 {
+	uint64_t	d_ino;
+	int64_t		d_off;
+	unsigned short	d_reclen;
+	unsigned char	d_type;
+	char		d_name[0];
+};
+
+#define DT_MASK 15
+#define DT_MAX 15
+unsigned char type_to_char[DT_MAX] = {
+	[DT_UNKNOWN] = '?',
+	[DT_DIR] = 'd',
+	[DT_REG] = 'f',
+	[DT_LNK] = 'l',
+	[DT_CHR] = 'c',
+	[DT_BLK] = 'b',
+	[DT_FIFO] = 'p',
+	[DT_SOCK] = 's',
+	[DT_WHT] = 'w',
+};
+
+#define DT_CHAR(t) type_to_char[(t)&DT_MASK]
+
+#define BUF_SIZE 4096
+
+int
+main(int argc, char *argv[])
+{
+	int fd, nread;
+	char buf[BUF_SIZE];
+	struct linux_dirent64 *d;
+	int bpos;
+	int type = 0;
+
+	fd = open(argv[1], O_RDONLY | O_DIRECTORY);
+	if (fd < 0) {
+		perror("open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (argc > 2) {
+		char t = argv[2][0];
+
+		for (type = DT_MAX-1; type > 0; type--)
+			if (t && DT_CHAR(type) == t)
+				break;
+	}
+
+	for ( ; ; ) {
+		nread = syscall(SYS_getdents64, fd, buf, BUF_SIZE);
+		if (nread == -1) {
+			perror("getdents");
+			exit(EXIT_FAILURE);
+		}
+
+		if (nread == 0)
+			break;
+
+		for (bpos = 0; bpos < nread;) {
+			d = (struct linux_dirent64 *) (buf + bpos);
+			if (!type || type == (int)d->d_type) {
+				printf("d_name = %s, d_type = %c\n",
+						d->d_name, DT_CHAR(d->d_type));
+			}
+			bpos += d->d_reclen;
+		}
+	}
+
+	exit(EXIT_SUCCESS);
+}
diff --git a/tests/generic/396 b/tests/generic/396
new file mode 100755
index 0000000..1021540
--- /dev/null
+++ b/tests/generic/396
@@ -0,0 +1,72 @@
+#! /bin/bash
+# FSQA Test No. 396
+#
+# Test filetype feature
+#
+# Lookup dir entries by d_type
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
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs >>$seqres.full 2>&1
+
+_scratch_mount
+
+# Create our test files.
+testdir=$SCRATCH_MNT/find-by-type
+mkdir -p $testdir
+mkdir $testdir/d
+touch $testdir/f
+ln -s $testdir/f $testdir/l
+mknod $testdir/c c 1 1
+mknod $testdir/b b 1 1
+mknod $testdir/p p
+
+# Test valid getdents(2) d_type
+for t in d f l c b p; do
+	src/t_dir_type $testdir $t | grep -vF 'name = .'
+done
+
+status=0
+exit
diff --git a/tests/generic/396.out b/tests/generic/396.out
new file mode 100644
index 0000000..77592ce
--- /dev/null
+++ b/tests/generic/396.out
@@ -0,0 +1,7 @@
+QA output created by 396
+d_name = d, d_type = d
+d_name = f, d_type = f
+d_name = l, d_type = l
+d_name = c, d_type = c
+d_name = b, d_type = b
+d_name = p, d_type = p
diff --git a/tests/generic/group b/tests/generic/group
index 20b31ef..24c242f 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -397,3 +397,4 @@
 392 auto quick metadata
 393 auto quick rw
 394 auto quick
+396 auto quick
-- 
2.7.4

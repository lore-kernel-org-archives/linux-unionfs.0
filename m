Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 2/2] generic: Test that SEEK_HOLE can find a punched hole
Date: Wed,  3 Apr 2019 08:59:26 +0300
Message-Id: <20190403055926.23253-2-amir73il@gmail.com>
In-Reply-To: <20190403055926.23253-1-amir73il@gmail.com>
References: <20190403055926.23253-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Eddie Horng <eddiehorng.tw@gmail.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Added a test case to seek_sanity_test and a test to run it.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/seek_sanity_test.c | 63 +++++++++++++++++++++++++++++++++++++++---
 tests/generic/999      | 44 +++++++++++++++++++++++++++++
 tests/generic/999.out  |  1 +
 tests/generic/group    |  1 +
 4 files changed, 105 insertions(+), 4 deletions(-)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index a6bda0b1..30e996e2 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -16,6 +16,7 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <assert.h>
+#include "global.h"
 
 #ifndef SEEK_DATA
 #define SEEK_DATA      3
@@ -26,6 +27,7 @@ static blksize_t alloc_size;
 int allow_default_behavior = 1;
 int default_behavior = 0;
 int unwritten_extents = 0;
+int punch_hole = 0;
 char *base_file_path;
 
 static void get_file_system(int fd)
@@ -118,8 +120,9 @@ static int do_fallocate(int fd, off_t offset, off_t length, int mode)
 
 	ret = fallocate(fd, mode, offset, length);
 	if (ret)
-		fprintf(stderr, "  ERROR %d: Failed to preallocate "
-			"space to %ld bytes\n", errno, (long) length);
+		fprintf(stderr, "  ERROR %d: Failed to %s of %ld bytes\n",
+			errno, (mode & FALLOC_FL_PUNCH_HOLE) ? "punch hole" :
+			"preallocate space", (long) length);
 
 	return ret;
 }
@@ -262,6 +265,52 @@ out:
 	return ret;
 }
 
+/*
+ * Make sure hole size is properly reported when punched in the middle of a file
+ */
+static int test21(int fd, int testnum)
+{
+	char *buf = NULL;
+	int bufsz, filsz;
+	int ret = 0;
+
+	if (!punch_hole) {
+		fprintf(stdout, "Test skipped as fs doesn't support punch hole.\n");
+		goto out;
+	}
+
+	if (default_behavior) {
+		fprintf(stdout, "Test skipped as fs doesn't support seeking a punched hole.\n");
+		goto out;
+	}
+
+	bufsz = alloc_size * 3;
+	buf = do_malloc(bufsz);
+	if (!buf) {
+		ret = -1;
+		goto out;
+	}
+	memset(buf, 'a', bufsz);
+
+	ret = do_pwrite(fd, buf, bufsz, 0);
+	if (ret)
+		goto out;
+
+	filsz = bufsz;
+	ret = do_fallocate(fd, alloc_size, alloc_size,
+			   FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE);
+	if (ret < 0)
+		goto out;
+
+	ret += do_lseek(testnum, 1, fd, filsz, SEEK_DATA, 0, 0);
+	ret += do_lseek(testnum, 2, fd, filsz, SEEK_HOLE, 0, alloc_size);
+	ret += do_lseek(testnum, 3, fd, filsz, SEEK_DATA, alloc_size, alloc_size * 2);
+out:
+	if (buf)
+		free(buf);
+	return ret;
+}
+
 /*
  * Make sure hole size is properly reported when starting in the middle of a
  * hole in ext? doubly indirect tree
@@ -1050,6 +1099,7 @@ struct testrec seek_tests[] = {
        { 18, test18, "Test file with negative SEEK_{HOLE,DATA} offsets" },
        { 19, test19, "Test file SEEK_DATA from middle of a large hole" },
        { 20, test20, "Test file SEEK_DATA from middle of a huge hole" },
+       { 21, test21, "Test file SEEK_HOLE that was created by PUNCH_HOLE" },
 };
 
 static int run_test(struct testrec *tr)
@@ -1127,15 +1177,20 @@ static int test_basic_support(void)
 	}
 
 	ftruncate(fd, 0);
-	if (fallocate(fd, 0, 0, alloc_size) == -1) {
+	if (fallocate(fd, 0, 0, alloc_size * 2) == -1) {
 		if (errno == EOPNOTSUPP)
-			fprintf(stderr, "File system does not support fallocate.");
+			fprintf(stderr, "File system does not support fallocate.\n");
 		else {
 			fprintf(stderr, "ERROR %d: Failed to preallocate "
 				"space to %ld bytes. Aborting.\n", errno, (long) alloc_size);
 			ret = -1;
 		}
 		goto out;
+	} else if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+			     0, alloc_size) == -1) {
+		fprintf(stderr, "File system does not support punch hole.\n");
+	} else {
+		punch_hole = 1;
 	}
 
 	pos = lseek(fd, 0, SEEK_DATA);
diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..d8565041
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,44 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019, CTERA Networks.  All Rights Reserved.
+#
+# FS QA Test No. 999
+#
+# Check that SEEK_HOLE can find a punched hole.
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
+# get standard environment, filters and checks
+. ./common/rc
+
+_supported_fs generic
+_supported_os Linux
+
+_require_test
+_require_seek_data_hole
+_require_xfs_io_command "fpunch"
+
+base_test_file=$TEST_DIR/seek_sanity_testfile.$seq
+
+_require_test_program "seek_sanity_test"
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	rm -f $base_test_file*
+}
+
+_run_seek_sanity_test -s 21 -e 21 $base_test_file > $seqres.full 2>&1 ||
+	_fail "seek sanity check failed!"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..7fbc6768
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1 @@
+QA output created by 999
diff --git a/tests/generic/group b/tests/generic/group
index c63035ce..f85e416c 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -540,3 +540,4 @@
 535 auto quick log
 536 auto quick rw shutdown
 537 auto quick trim
+999 auto quick punch seek
-- 
2.17.1

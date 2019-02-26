Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] generic: Test that SEEK_HOLE can find a punched hole
Date: Tue, 26 Feb 2019 16:09:02 +0200
Message-Id: <20190226140902.32219-2-amir73il@gmail.com>
In-Reply-To: <20190226140902.32219-1-amir73il@gmail.com>
References: <20190226140902.32219-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Eddie Horng <eddiehorng.tw@gmail.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Added a test case to seek_sanity_test and a test to run it.

When checking for SEEK_HOLE support, abort if filesystem
supports punching holes that SEEK_HOLE will not find, because
this configuration doesn't make any sense.

This kind of senless behavior was introduced to overlayfs
in v4.19 with stacked file operations, because overlay fallocate
op is stacked and llseek op is not stacked.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

After this change, the generic/seek group tests will start
failing with overlayfs on upstream kernel.

We had missing coverage of SEEK_HOLE, so we missed a regression
in kernel v4.19 when overlayfs SEEK_HOLE stopped finding punched
holes (or any holes for that matter).

Thanks,
Amir.

 src/seek_sanity_test.c | 63 +++++++++++++++++++++++++++++++++++++++---
 tests/generic/999      | 44 +++++++++++++++++++++++++++++
 tests/generic/999.out  |  1 +
 tests/generic/group    |  1 +
 4 files changed, 105 insertions(+), 4 deletions(-)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index e9938d1b..a98bae03 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -16,6 +16,7 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <assert.h>
+#include "global.h"
 
 #ifndef SEEK_DATA
 #define SEEK_DATA      3
@@ -25,6 +26,7 @@
 static blksize_t alloc_size;
 int default_behavior = 0;
 int unwritten_extents = 0;
+int punch_hole = 0;
 char *base_file_path;
 
 static void get_file_system(int fd)
@@ -117,8 +119,9 @@ static int do_fallocate(int fd, off_t offset, off_t length, int mode)
 
 	ret = fallocate(fd, mode, offset, length);
 	if (ret)
-		fprintf(stderr, "  ERROR %d: Failed to preallocate "
-			"space to %ld bytes\n", errno, (long) length);
+		fprintf(stderr, "  ERROR %d: Failed to %s of %ld bytes\n",
+			errno, (mode & FALLOC_FL_PUNCH_HOLE) ? "punch hole" :
+			"preallocate space", (long) length);
 
 	return ret;
 }
@@ -261,6 +264,47 @@ out:
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
@@ -1049,6 +1093,7 @@ struct testrec seek_tests[] = {
        { 18, test18, "Test file with negative SEEK_{HOLE,DATA} offsets" },
        { 19, test19, "Test file SEEK_DATA from middle of a large hole" },
        { 20, test20, "Test file SEEK_DATA from middle of a huge hole" },
+       { 21, test21, "Test file SEEK_HOLE that was created by PUNCH_HOLE" },
 };
 
 static int run_test(struct testrec *tr)
@@ -1120,15 +1165,25 @@ static int test_basic_support(void)
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
+	} else if (default_behavior) {
+		fprintf(stderr, "File system supports punch hole, but does not support "
+				"finding holes with SEEK_HOLE. Aborting.\n");
+		ret = -1;
+		goto out;
+	} else {
+		punch_hole = 1;
 	}
 
 	pos = lseek(fd, 0, SEEK_DATA);
diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..b52f6985
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
+$here/src/seek_sanity_test -s 21 -e 21 $base_test_file > $seqres.full 2>&1 ||
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
index 15227b67..14ac9b2c 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -534,3 +534,4 @@
 529 auto quick attr
 530 auto quick unlink
 531 auto quick unlink
+999 auto quick punch seek
-- 
2.17.1

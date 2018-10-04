Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/5] syscalls/readahead01: Convert to newlib
Date: Thu,  4 Oct 2018 09:26:20 +0300
Message-Id: <20181004062624.27295-2-amir73il@gmail.com>
In-Reply-To: <20181004062624.27295-1-amir73il@gmail.com>
References: <20181004062624.27295-1-amir73il@gmail.com>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

* Use SPDX-License-Identifier

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Jan Stancek <jstancek@redhat.com>
---
 .../kernel/syscalls/readahead/readahead01.c   | 119 +++++-------------
 1 file changed, 34 insertions(+), 85 deletions(-)

diff --git a/testcases/kernel/syscalls/readahead/readahead01.c b/testcases/kernel/syscalls/readahead/readahead01.c
index f35019488..682b524b3 100644
--- a/testcases/kernel/syscalls/readahead/readahead01.c
+++ b/testcases/kernel/syscalls/readahead/readahead01.c
@@ -1,25 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2012 Linux Test Project, Inc.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of version 2 of the GNU General Public
- * License as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
- * Further, this software is distributed without any warranty that it
- * is free of the rightful claim of any third person regarding
- * infringement or the like.  Any license provided herein, whether
- * implied or otherwise, applies only to this software file.  Patent
- * licenses, if any, provided herein do not apply to combinations of
- * this program with other software, or any other product whatsoever.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  */
 
 /*
@@ -36,47 +17,36 @@
 #include <sys/syscall.h>
 #include <sys/types.h>
 #include "config.h"
-#include "test.h"
-#include "safe_macros.h"
+#include "tst_test.h"
 #include "lapi/syscalls.h"
 
-char *TCID = "readahead01";
-int TST_TOTAL = 1;
-
-option_t options[] = {
-	{NULL, NULL, NULL}
-};
-
 #if defined(__NR_readahead)
-static void setup(void);
-static void cleanup(void);
-
 static int check_ret(long expected_ret)
 {
-	if (expected_ret == TEST_RETURN) {
-		tst_resm(TPASS, "expected ret success - "
-			 "returned value = %ld", TEST_RETURN);
+	if (expected_ret == TST_RET) {
+		tst_res(TPASS, "expected ret success - "
+			"returned value = %ld", TST_RET);
 		return 0;
 	}
-	tst_resm(TFAIL, "unexpected failure - "
-		 "returned value = %ld, expected: %ld",
-		 TEST_RETURN, expected_ret);
+	tst_res(TFAIL, "unexpected failure - "
+		"returned value = %ld, expected: %ld",
+		TST_RET, expected_ret);
 	return 1;
 }
 
 static int check_errno(long expected_errno)
 {
-	if (TEST_ERRNO == expected_errno) {
-		tst_resm(TPASS | TTERRNO, "expected failure");
+	if (TST_ERR == expected_errno) {
+		tst_res(TPASS | TTERRNO, "expected failure");
 		return 0;
 	}
 
-	if (TEST_ERRNO == 0)
-		tst_resm(TFAIL, "call succeeded unexpectedly");
+	if (TST_ERR == 0)
+		tst_res(TFAIL, "call succeeded unexpectedly");
 	else
-		tst_resm(TFAIL | TTERRNO, "unexpected failure - "
-			 "expected = %ld : %s, actual",
-			 expected_errno, strerror(expected_errno));
+		tst_res(TFAIL | TTERRNO, "unexpected failure - "
+			"expected = %ld : %s, actual",
+			expected_errno, strerror(expected_errno));
 	return 1;
 }
 
@@ -85,19 +55,17 @@ static void test_bad_fd(void)
 	char tempname[PATH_MAX] = "readahead01_XXXXXX";
 	int fd;
 
-	tst_resm(TINFO, "test_bad_fd -1");
+	tst_res(TINFO, "test_bad_fd -1");
 	TEST(readahead(-1, 0, getpagesize()));
 	check_ret(-1);
 	check_errno(EBADF);
 
-	tst_resm(TINFO, "test_bad_fd O_WRONLY");
+	tst_res(TINFO, "test_bad_fd O_WRONLY");
 	fd = mkstemp(tempname);
 	if (fd == -1)
-		tst_resm(TBROK | TERRNO, "mkstemp failed");
+		tst_res(TBROK | TERRNO, "mkstemp failed");
 	close(fd);
-	fd = open(tempname, O_WRONLY);
-	if (fd == -1)
-		tst_resm(TBROK | TERRNO, "Failed to open testfile");
+	fd = SAFE_OPEN(tempname, O_WRONLY);
 	TEST(readahead(fd, 0, getpagesize()));
 	check_ret(-1);
 	check_errno(EBADF);
@@ -109,60 +77,41 @@ static void test_invalid_fd(void)
 {
 	int fd[2];
 
-	tst_resm(TINFO, "test_invalid_fd pipe");
-	if (pipe(fd) < 0)
-		tst_resm(TBROK | TERRNO, "Failed to create pipe");
+	tst_res(TINFO, "test_invalid_fd pipe");
+	SAFE_PIPE(fd);
 	TEST(readahead(fd[0], 0, getpagesize()));
 	check_ret(-1);
 	check_errno(EINVAL);
 	close(fd[0]);
 	close(fd[1]);
 
-	tst_resm(TINFO, "test_invalid_fd socket");
-	fd[0] = socket(AF_INET, SOCK_STREAM, 0);
-	if (fd[0] < 0)
-		tst_resm(TBROK | TERRNO, "Failed to create socket");
+	tst_res(TINFO, "test_invalid_fd socket");
+	fd[0] = SAFE_SOCKET(AF_INET, SOCK_STREAM, 0);
 	TEST(readahead(fd[0], 0, getpagesize()));
 	check_ret(-1);
 	check_errno(EINVAL);
 	close(fd[0]);
 }
 
-int main(int argc, char *argv[])
+void test_readahead(void)
 {
-	int lc;
-
-	tst_parse_opts(argc, argv, options, NULL);
-
-	setup();
-	for (lc = 0; TEST_LOOPING(lc); lc++) {
-		tst_count = 0;
-		test_bad_fd();
-		test_invalid_fd();
-	}
-	cleanup();
-	tst_exit();
+	test_bad_fd();
+	test_invalid_fd();
 }
 
 static void setup(void)
 {
-	tst_require_root();
-	tst_tmpdir();
-
 	/* check if readahead syscall is supported */
-	ltp_syscall(__NR_readahead, 0, 0, 0);
-
-	TEST_PAUSE;
+	tst_syscall(__NR_readahead, 0, 0, 0);
 }
 
-static void cleanup(void)
-{
-	tst_rmdir();
-}
+static struct tst_test test = {
+	.needs_root = 1,
+	.needs_tmpdir = 1,
+	.setup = setup,
+	.test_all = test_readahead,
+};
 
 #else /* __NR_readahead */
-int main(void)
-{
-	tst_brkm(TCONF, NULL, "System doesn't support __NR_readahead");
-}
+	TST_TEST_TCONF("System doesn't support __NR_readahead");
 #endif
-- 
2.17.1

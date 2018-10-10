Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 3/6] syscalls/readahead02: abort test if readahead syscall fails
Date: Thu, 11 Oct 2018 02:34:38 +0300
Message-Id: <20181010233441.5337-4-amir73il@gmail.com>
In-Reply-To: <20181010233441.5337-1-amir73il@gmail.com>
References: <20181010233441.5337-1-amir73il@gmail.com>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

There is no reason to continue the test if readahead syscall fails
and we can also check and report TCONF if filesystem does not support
readahead.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../kernel/syscalls/readahead/readahead02.c   | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/testcases/kernel/syscalls/readahead/readahead02.c b/testcases/kernel/syscalls/readahead/readahead02.c
index c739d3ba2..f77e7c66c 100644
--- a/testcases/kernel/syscalls/readahead/readahead02.c
+++ b/testcases/kernel/syscalls/readahead/readahead02.c
@@ -45,16 +45,17 @@ static struct tst_option options[] = {
 	{NULL, NULL, NULL}
 };
 
-static int check_ret(long expected_ret)
+static int check_ret(void)
 {
-	if (expected_ret == TST_RET) {
-		tst_res(TPASS, "expected ret success - "
-			"returned value = %ld", TST_RET);
+	if (TST_RET == 0)
 		return 0;
+	if (TST_ERR == EINVAL) {
+		tst_res(TCONF, "readahead not supported on %s",
+			tst_device->fs_type);
+	} else {
+		tst_res(TFAIL | TTERRNO, "readahead failed on %s",
+			tst_device->fs_type);
 	}
-	tst_res(TFAIL | TTERRNO, "unexpected failure - "
-		"returned value = %ld, expected: %ld",
-		TST_RET, expected_ret);
 	return 1;
 }
 
@@ -163,8 +164,8 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 		do {
 			TEST(readahead(fd, offset, fsize - offset));
 			if (TST_RET != 0) {
-				check_ret(0);
-				break;
+				SAFE_CLOSE(fd);
+				return;
 			}
 
 			/* estimate max readahead size based on first call */
@@ -252,6 +253,8 @@ static void test_readahead(void)
 	tst_res(TINFO, "read_testfile(1)");
 	read_testfile(1, testfile, testfile_size, &read_bytes_ra,
 		      &usec_ra, &cached_ra);
+	if (check_ret())
+		return;
 	if (cached_ra > cached_low)
 		cached_ra = cached_ra - cached_low;
 	else
-- 
2.17.1

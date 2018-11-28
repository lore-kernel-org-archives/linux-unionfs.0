Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 2/6] syscalls/readahead02: abort test if readahead syscall fails
Date: Wed, 28 Nov 2018 18:46:41 +0200
Message-Id: <20181128164645.783-3-amir73il@gmail.com>
In-Reply-To: <20181128164645.783-1-amir73il@gmail.com>
References: <20181128164645.783-1-amir73il@gmail.com>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

There is no reason to continue the test if readahead syscall fails
and we can also check and report TCONF if filesystem does not support
readahead.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../kernel/syscalls/readahead/readahead02.c   | 27 +++++++++----------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/testcases/kernel/syscalls/readahead/readahead02.c b/testcases/kernel/syscalls/readahead/readahead02.c
index 956a1d5e5..88eb5fbff 100644
--- a/testcases/kernel/syscalls/readahead/readahead02.c
+++ b/testcases/kernel/syscalls/readahead/readahead02.c
@@ -44,19 +44,6 @@ static struct tst_option options[] = {
 	{NULL, NULL, NULL}
 };
 
-static int check_ret(long expected_ret)
-{
-	if (expected_ret == TST_RET) {
-		tst_res(TPASS, "expected ret success - "
-			"returned value = %ld", TST_RET);
-		return 0;
-	}
-	tst_res(TFAIL | TTERRNO, "unexpected failure - "
-		"returned value = %ld, expected: %ld",
-		TST_RET, expected_ret);
-	return 1;
-}
-
 static int has_file(const char *fname, int required)
 {
 	struct stat buf;
@@ -162,8 +149,8 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 		do {
 			TEST(readahead(fd, offset, fsize - offset));
 			if (TST_RET != 0) {
-				check_ret(0);
-				break;
+				SAFE_CLOSE(fd);
+				return;
 			}
 
 			/* estimate max readahead size based on first call */
@@ -251,6 +238,16 @@ static void test_readahead(void)
 	tst_res(TINFO, "read_testfile(1)");
 	read_testfile(1, testfile, testfile_size, &read_bytes_ra,
 		      &usec_ra, &cached_ra);
+	if (TST_RET != 0) {
+		if (TST_ERR == EINVAL) {
+			tst_res(TCONF, "readahead not supported on %s",
+				tst_device->fs_type);
+		} else {
+			tst_res(TFAIL | TTERRNO, "readahead failed on %s",
+				tst_device->fs_type);
+		}
+		return;
+	}
 	if (cached_ra > cached_low)
 		cached_ra = cached_ra - cached_low;
 	else
-- 
2.17.1

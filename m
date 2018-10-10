Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 5/6] syscalls/readahead02: test readahead using posix_fadvise()
Date: Thu, 11 Oct 2018 02:34:40 +0300
Message-Id: <20181010233441.5337-6-amir73il@gmail.com>
In-Reply-To: <20181010233441.5337-1-amir73il@gmail.com>
References: <20181010233441.5337-1-amir73il@gmail.com>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

The call to posix_fadvise(POSIX_FADV_WILLNEED) should have the same
effect as the call to readahead() syscall.

Repeat the test cases for local file and overlayfs file with
posix_fadvise().

The new test case is a regression test for kernel commit b833a3660394
("ovl: add ovl_fadvise()") which fixes a regression of fadvise() on
an overlay file that was introduced by kernel commit 5b910bd615ba
("ovl: fix GPF in swapfile_activate of file from overlayfs over xfs").

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../kernel/syscalls/readahead/readahead02.c   | 41 +++++++++++++++----
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/testcases/kernel/syscalls/readahead/readahead02.c b/testcases/kernel/syscalls/readahead/readahead02.c
index 56a8496ff..d5cc7677b 100644
--- a/testcases/kernel/syscalls/readahead/readahead02.c
+++ b/testcases/kernel/syscalls/readahead/readahead02.c
@@ -55,24 +55,49 @@ static struct tst_option options[] = {
 static struct tcase {
 	const char *tname;
 	int use_overlay;
+	int use_fadvise;
 } tcases[] = {
-	{ "readahead on file", 0 },
-	{ "readahead on overlayfs file", 1 },
+	{ "readahead on file", 0, 0 },
+	{ "readahead on overlayfs file", 1, 0 },
+	{ "POSIX_FADV_WILLNEED on file", 0, 1 },
+	{ "POSIX_FADV_WILLNEED on overlayfs file", 1, 1 },
 };
 
+static int fadvise_willneed(int fd, off_t offset, size_t len)
+{
+	/* Should have the same effect as readahead() syscall */
+	return posix_fadvise(fd, offset, len, POSIX_FADV_WILLNEED);
+}
+
+static int libc_readahead(int fd, off_t offset, size_t len)
+{
+	return readahead(fd, offset, len);
+}
+
+typedef int (*readahead_func_t)(int, off_t, size_t);
+static readahead_func_t readahead_func = libc_readahead;
+
 static int readahead_supported = 1;
+static int fadvise_supported = 1;
 
 static int check_ret(struct tcase *tc)
 {
 	if (TST_RET == 0)
 		return 0;
-	if (TST_ERR == EINVAL &&
-	    (!tc->use_overlay || !readahead_supported)) {
+	/* posix_fadvise returns error number (not in errno) */
+	if (tc->use_fadvise && (TST_ERR = TST_RET) == EINVAL &&
+	    (!tc->use_overlay || !fadvise_supported)) {
+		fadvise_supported = 0;
+		tst_res(TCONF, "fadvise not supported on %s",
+			tst_device->fs_type);
+	} else if (TST_ERR == EINVAL &&
+		   (!tc->use_overlay || !readahead_supported)) {
 		readahead_supported = 0;
 		tst_res(TCONF, "readahead not supported on %s",
 			tst_device->fs_type);
 	} else {
-		tst_res(TFAIL | TTERRNO, "readahead failed on %s",
+		tst_res(TFAIL | TTERRNO, "%s failed on %s",
+			tc->use_fadvise ? "fadvise" : "readahead",
 			tc->use_overlay ? "overlayfs" : tst_device->fs_type);
 	}
 	return 1;
@@ -152,7 +177,6 @@ static void create_testfile(int use_overlay)
 	free(tmp);
 }
 
-
 /* read_testfile - mmap testfile and read every page.
  * This functions measures how many I/O and time it takes to fully
  * read contents of test file.
@@ -182,7 +206,7 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 	if (do_readahead) {
 		cached_start = get_cached_size();
 		do {
-			TEST(readahead(fd, offset, fsize - offset));
+			TEST(readahead_func(fd, offset, fsize - offset));
 			if (TST_RET != 0) {
 				SAFE_CLOSE(fd);
 				return;
@@ -264,6 +288,9 @@ static void test_readahead(unsigned int n)
 
 	create_testfile(tc->use_overlay);
 
+	/* Use either readahead() syscall or POSIX_FADV_WILLNEED */
+	readahead_func = tc->use_fadvise ? fadvise_willneed : libc_readahead;
+
 	/* find out how much can cache hold if we read whole file */
 	read_testfile(0, testfile, testfile_size, &read_bytes, &usec, &cached);
 	cached_high = get_cached_size();
-- 
2.17.1

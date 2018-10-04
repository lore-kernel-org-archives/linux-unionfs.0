Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 4/5] syscalls/readahead02: test readahead using posix_fadvise()
Date: Thu,  4 Oct 2018 09:26:23 +0300
Message-Id: <20181004062624.27295-5-amir73il@gmail.com>
In-Reply-To: <20181004062624.27295-1-amir73il@gmail.com>
References: <20181004062624.27295-1-amir73il@gmail.com>
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
 .../kernel/syscalls/readahead/readahead02.c   | 58 +++++++++++++++++--
 1 file changed, 52 insertions(+), 6 deletions(-)

diff --git a/testcases/kernel/syscalls/readahead/readahead02.c b/testcases/kernel/syscalls/readahead/readahead02.c
index 158bfc955..ea73f8566 100644
--- a/testcases/kernel/syscalls/readahead/readahead02.c
+++ b/testcases/kernel/syscalls/readahead/readahead02.c
@@ -52,6 +52,46 @@ static struct tst_option options[] = {
 	{NULL, NULL, NULL}
 };
 
+/*
+ * Check this system has fadvise64 syscall which is used in posix_fadvise.
+ * This is the only system configuration supported by the posix_fadvise tests,
+ * so use posix_fadvise in this test only with this system configuration.
+ */
+#ifdef __NR_fadvise64
+#define READAHEAD_WITH_FADVISE
+#else
+#if defined(_FILE_OFFSET_BITS) && (_FILE_OFFSET_BITS == 64)
+#define READAHEAD_WITH_FADVISE
+#endif
+#endif
+
+static struct tcase {
+	const char *tname;
+	int use_overlay;
+	int use_fadvise;
+} tcases[] = {
+	{ "readahead on file", 0, 0 },
+	{ "readahead on overlayfs file", 1, 0 },
+#ifdef READAHEAD_WITH_FADVISE
+	{ "POSIX_FADV_WILLNEED on file", 0, 1 },
+	{ "POSIX_FADV_WILLNEED on overlayfs file", 1, 1 },
+#endif
+};
+
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
 static int check_ret(long expected_ret)
 {
 	if (expected_ret == TST_RET) {
@@ -139,7 +179,6 @@ static void create_testfile(int use_overlay)
 	free(tmp);
 }
 
-
 /* read_testfile - mmap testfile and read every page.
  * This functions measures how many I/O and time it takes to fully
  * read contents of test file.
@@ -169,7 +208,7 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 	if (do_readahead) {
 		cached_start = get_cached_size();
 		do {
-			TEST(readahead(fd, offset, fsize - offset));
+			TEST(readahead_func(fd, offset, fsize - offset));
 			if (TST_RET != 0) {
 				check_ret(0);
 				break;
@@ -231,21 +270,28 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 	SAFE_CLOSE(fd);
 }
 
-static void test_readahead(unsigned int use_overlay)
+static void test_readahead(unsigned int n)
 {
 	unsigned long read_bytes, read_bytes_ra;
 	long usec, usec_ra;
 	unsigned long cached_high, cached_low, cached, cached_ra;
 	char proc_io_fname[128];
+	struct tcase *tc = &tcases[n];
+
+	tst_res(TINFO, "Test #%d: %s", n, tc->tname);
+
 	sprintf(proc_io_fname, "/proc/%u/io", getpid());
 
-	if (use_overlay && !ovl_mounted) {
+	if (tc->use_overlay && !ovl_mounted) {
 		tst_res(TCONF,
 			"overlayfs is not configured in this kernel.");
 		return;
 	}
 
-	create_testfile(use_overlay);
+	create_testfile(tc->use_overlay);
+
+	/* Use either readahead() syscall or POSIX_FADV_WILLNEED */
+	readahead_func = tc->use_fadvise ? fadvise_willneed : libc_readahead;
 
 	/* find out how much can cache hold if we read whole file */
 	read_testfile(0, testfile, testfile_size, &read_bytes, &usec, &cached);
@@ -361,7 +407,7 @@ static struct tst_test test = {
 	.cleanup = cleanup,
 	.options = options,
 	.test = test_readahead,
-	.tcnt = 2, /* Repeat with overlayfs */
+	.tcnt = ARRAY_SIZE(tcases),
 };
 
 #else /* __NR_readahead */
-- 
2.17.1

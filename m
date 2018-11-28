Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 5/6] syscalls/readahead02: test readahead() on an overlayfs file
Date: Wed, 28 Nov 2018 18:46:44 +0200
Message-Id: <20181128164645.783-6-amir73il@gmail.com>
In-Reply-To: <20181128164645.783-1-amir73il@gmail.com>
References: <20181128164645.783-1-amir73il@gmail.com>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Repeat the test case on an overlayfs file.

The new test case is a regression test for kernel commit b833a3660394
("ovl: add ovl_fadvise()") which fixes a regression of readahead() on
an overlay file that was introduced by kernel commit 5b910bd615ba
("ovl: fix GPF in swapfile_activate of file from overlayfs over xfs").

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../kernel/syscalls/readahead/readahead02.c   | 80 ++++++++++++++++---
 1 file changed, 71 insertions(+), 9 deletions(-)

diff --git a/testcases/kernel/syscalls/readahead/readahead02.c b/testcases/kernel/syscalls/readahead/readahead02.c
index 24f045900..73c8a6ce6 100644
--- a/testcases/kernel/syscalls/readahead/readahead02.c
+++ b/testcases/kernel/syscalls/readahead/readahead02.c
@@ -14,6 +14,7 @@
 #include <sys/types.h>
 #include <sys/syscall.h>
 #include <sys/mman.h>
+#include <sys/mount.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <errno.h>
@@ -33,8 +34,14 @@ static const char meminfo_fname[] = "/proc/meminfo";
 static size_t testfile_size = 64 * 1024 * 1024;
 static char *opt_fsizestr;
 static int pagesize;
+static unsigned long cached_max;
+static int ovl_mounted;
 
 #define MNTPOINT        "mntpoint"
+#define OVL_LOWER	MNTPOINT"/lower"
+#define OVL_UPPER	MNTPOINT"/upper"
+#define OVL_WORK	MNTPOINT"/work"
+#define OVL_MNT		MNTPOINT"/ovl"
 #define MIN_SANE_READAHEAD (4u * 1024u)
 
 static const char mntpoint[] = MNTPOINT;
@@ -44,6 +51,16 @@ static struct tst_option options[] = {
 	{NULL, NULL, NULL}
 };
 
+static struct tcase {
+	const char *tname;
+	int use_overlay;
+} tcases[] = {
+	{ "readahead on file", 0 },
+	{ "readahead on overlayfs file", 1 },
+};
+
+static int readahead_supported = 1;
+
 static int has_file(const char *fname, int required)
 {
 	struct stat buf;
@@ -97,12 +114,13 @@ static unsigned long get_cached_size(void)
 	return parse_entry(meminfo_fname, entry);
 }
 
-static void create_testfile(void)
+static void create_testfile(int use_overlay)
 {
 	int fd;
 	char *tmp;
 	size_t i;
 
+	sprintf(testfile, "%s/testfile", use_overlay ? OVL_MNT : MNTPOINT);
 	tst_res(TINFO, "creating test file of size: %zu", testfile_size);
 	tmp = SAFE_MALLOC(pagesize);
 
@@ -203,21 +221,33 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 	SAFE_CLOSE(fd);
 }
 
-static void test_readahead(void)
+static void test_readahead(unsigned int n)
 {
 	unsigned long read_bytes, read_bytes_ra;
 	long long usec, usec_ra;
-	unsigned long cached_max, cached_low, cached, cached_ra;
+	unsigned long cached_high, cached_low, cached, cached_ra;
 	char proc_io_fname[128];
+	struct tcase *tc = &tcases[n];
+
+	tst_res(TINFO, "Test #%d: %s", n, tc->tname);
+
 	sprintf(proc_io_fname, "/proc/%u/io", getpid());
 
+	if (tc->use_overlay && !ovl_mounted) {
+		tst_res(TCONF,
+			"overlayfs is not configured in this kernel.");
+		return;
+	}
+
+	create_testfile(tc->use_overlay);
+
 	/* find out how much can cache hold if we read whole file */
 	read_testfile(0, testfile, testfile_size, &read_bytes, &usec, &cached);
-	cached_max = get_cached_size();
+	cached_high = get_cached_size();
 	sync();
 	drop_caches();
 	cached_low = get_cached_size();
-	cached_max = cached_max - cached_low;
+	cached_max = MAX(cached_max, cached_high - cached_low);
 
 	tst_res(TINFO, "read_testfile(0)");
 	read_testfile(0, testfile, testfile_size, &read_bytes, &usec, &cached);
@@ -233,11 +263,14 @@ static void test_readahead(void)
 	read_testfile(1, testfile, testfile_size, &read_bytes_ra,
 		      &usec_ra, &cached_ra);
 	if (TST_RET != 0) {
-		if (TST_ERR == EINVAL) {
+		if (TST_ERR == EINVAL &&
+		    (!tc->use_overlay || !readahead_supported)) {
+			readahead_supported = 0;
 			tst_res(TCONF, "readahead not supported on %s",
 				tst_device->fs_type);
 		} else {
 			tst_res(TFAIL | TTERRNO, "readahead failed on %s",
+				tc->use_overlay ? "overlayfs" :
 				tst_device->fs_type);
 		}
 		return;
@@ -284,6 +317,28 @@ static void test_readahead(void)
 	}
 }
 
+static void setup_overlay(void)
+{
+	int ret;
+
+	/* Setup an overlay mount with lower dir and file */
+	SAFE_MKDIR(OVL_LOWER, 0755);
+	SAFE_MKDIR(OVL_UPPER, 0755);
+	SAFE_MKDIR(OVL_WORK, 0755);
+	SAFE_MKDIR(OVL_MNT, 0755);
+	ret = mount("overlay", OVL_MNT, "overlay", 0, "lowerdir="OVL_LOWER
+		    ",upperdir="OVL_UPPER",workdir="OVL_WORK);
+	if (ret < 0) {
+		if (errno == ENODEV) {
+			tst_res(TINFO,
+				"overlayfs is not configured in this kernel.");
+			return;
+		}
+		tst_brk(TBROK | TERRNO, "overlayfs mount failed");
+	}
+	ovl_mounted = 1;
+}
+
 static void setup(void)
 {
 	if (opt_fsizestr)
@@ -297,8 +352,13 @@ static void setup(void)
 
 	pagesize = getpagesize();
 
-	sprintf(testfile, "%s/testfile", mntpoint);
-	create_testfile();
+	setup_overlay();
+}
+
+static void cleanup(void)
+{
+	if (ovl_mounted)
+		SAFE_UMOUNT(OVL_MNT);
 }
 
 static struct tst_test test = {
@@ -307,6 +367,8 @@ static struct tst_test test = {
 	.mount_device = 1,
 	.mntpoint = mntpoint,
 	.setup = setup,
+	.cleanup = cleanup,
 	.options = options,
-	.test_all = test_readahead,
+	.test = test_readahead,
+	.tcnt = ARRAY_SIZE(tcases),
 };
-- 
2.17.1

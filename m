Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/5] syscalls/readahead02: Convert to newlib and cleanup
Date: Thu,  4 Oct 2018 09:26:21 +0300
Message-Id: <20181004062624.27295-3-amir73il@gmail.com>
In-Reply-To: <20181004062624.27295-1-amir73il@gmail.com>
References: <20181004062624.27295-1-amir73il@gmail.com>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

* Use SAFE macros

* Use SPDX-License-Identifier

* No need to cleanup test file from temp dir

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../kernel/syscalls/readahead/readahead02.c   | 248 +++++-------------
 1 file changed, 72 insertions(+), 176 deletions(-)

diff --git a/testcases/kernel/syscalls/readahead/readahead02.c b/testcases/kernel/syscalls/readahead/readahead02.c
index c9d92a6a4..c739d3ba2 100644
--- a/testcases/kernel/syscalls/readahead/readahead02.c
+++ b/testcases/kernel/syscalls/readahead/readahead02.c
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
@@ -43,86 +24,57 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include "config.h"
-#include "test.h"
-#include "safe_macros.h"
+#include "tst_test.h"
 #include "lapi/syscalls.h"
 
-char *TCID = "readahead02";
-int TST_TOTAL = 1;
-
 #if defined(__NR_readahead)
 static char testfile[PATH_MAX] = "testfile";
 static const char drop_caches_fname[] = "/proc/sys/vm/drop_caches";
 static const char meminfo_fname[] = "/proc/meminfo";
 static size_t testfile_size = 64 * 1024 * 1024;
-static int opt_fsize;
 static char *opt_fsizestr;
 static int pagesize;
-static const char *fs_type;
-static const char *device;
-static int mount_flag;
 
 #define MNTPOINT        "mntpoint"
 #define MIN_SANE_READAHEAD (4u * 1024u)
 
-option_t options[] = {
-	{"s:", &opt_fsize, &opt_fsizestr},
+static const char mntpoint[] = MNTPOINT;
+
+static struct tst_option options[] = {
+	{"s:", &opt_fsizestr, "-s    testfile size (default 64MB)"},
 	{NULL, NULL, NULL}
 };
 
-static void setup(void);
-static void cleanup(void);
-
-static void help(void)
-{
-	printf("  -s x    testfile size (default 64MB)\n");
-}
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
-	tst_resm(TFAIL | TTERRNO, "unexpected failure - "
-		 "returned value = %ld, expected: %ld",
-		 TEST_RETURN, expected_ret);
+	tst_res(TFAIL | TTERRNO, "unexpected failure - "
+		"returned value = %ld, expected: %ld",
+		TST_RET, expected_ret);
 	return 1;
 }
 
 static int has_file(const char *fname, int required)
 {
-	int ret;
 	struct stat buf;
-	ret = stat(fname, &buf);
-	if (ret == -1) {
-		if (errno == ENOENT)
-			if (required)
-				tst_brkm(TCONF, cleanup, "%s not available",
-					 fname);
-			else
-				return 0;
-		else
-			tst_brkm(TBROK | TERRNO, cleanup, "stat %s", fname);
+
+	if (stat(fname, &buf) == -1) {
+		if (errno != ENOENT)
+			tst_brk(TBROK | TERRNO, "stat %s", fname);
+		if (required)
+			tst_brk(TCONF, "%s not available", fname);
+		return 0;
 	}
 	return 1;
 }
 
 static void drop_caches(void)
 {
-	int ret;
-	FILE *f;
-
-	f = fopen(drop_caches_fname, "w");
-	if (f) {
-		ret = fprintf(f, "1");
-		fclose(f);
-		if (ret < 1)
-			tst_brkm(TBROK, cleanup, "Failed to drop caches");
-	} else {
-		tst_brkm(TBROK, cleanup, "Failed to open drop_caches");
-	}
+	SAFE_FILE_PRINTF(drop_caches_fname, "1");
 }
 
 static unsigned long parse_entry(const char *fname, const char *entry)
@@ -161,32 +113,21 @@ static unsigned long get_cached_size(void)
 
 static void create_testfile(void)
 {
-	FILE *f;
+	int fd;
 	char *tmp;
 	size_t i;
 
-	tst_resm(TINFO, "creating test file of size: %zu", testfile_size);
-	tmp = SAFE_MALLOC(cleanup, pagesize);
+	tst_res(TINFO, "creating test file of size: %zu", testfile_size);
+	tmp = SAFE_MALLOC(pagesize);
 
 	/* round to page size */
 	testfile_size = testfile_size & ~((long)pagesize - 1);
 
-	f = fopen(testfile, "w");
-	if (!f) {
-		free(tmp);
-		tst_brkm(TBROK | TERRNO, cleanup, "Failed to create %s",
-			 testfile);
-	}
-
+	fd = SAFE_CREAT(testfile, 0644);
 	for (i = 0; i < testfile_size; i += pagesize)
-		if (fwrite(tmp, pagesize, 1, f) < 1) {
-			free(tmp);
-			tst_brkm(TBROK, cleanup, "Failed to create %s",
-				 testfile);
-		}
-	fflush(f);
-	fsync(fileno(f));
-	fclose(f);
+		SAFE_WRITE(1, fd, tmp, pagesize);
+	SAFE_FSYNC(fd);
+	SAFE_CLOSE(fd);
 	free(tmp);
 }
 
@@ -215,13 +156,13 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 	off_t offset = 0;
 	struct timeval now;
 
-	fd = SAFE_OPEN(cleanup, fname, O_RDONLY);
+	fd = SAFE_OPEN(fname, O_RDONLY);
 
 	if (do_readahead) {
 		cached_start = get_cached_size();
 		do {
 			TEST(readahead(fd, offset, fsize - offset));
-			if (TEST_RETURN != 0) {
+			if (TST_RET != 0) {
 				check_ret(0);
 				break;
 			}
@@ -232,7 +173,7 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 				if (*cached > cached_start) {
 					max_ra_estimate = (1024 *
 						(*cached - cached_start));
-					tst_resm(TINFO, "max ra estimate: %lu",
+					tst_res(TINFO, "max ra estimate: %lu",
 						max_ra_estimate);
 				}
 				max_ra_estimate = MAX(max_ra_estimate,
@@ -242,27 +183,23 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 			i++;
 			offset += max_ra_estimate;
 		} while ((size_t)offset < fsize);
-		tst_resm(TINFO, "readahead calls made: %zu", i);
+		tst_res(TINFO, "readahead calls made: %zu", i);
 		*cached = get_cached_size();
 
 		/* offset of file shouldn't change after readahead */
-		offset = lseek(fd, 0, SEEK_CUR);
-		if (offset == (off_t) - 1)
-			tst_brkm(TBROK | TERRNO, cleanup, "lseek failed");
+		offset = SAFE_LSEEK(fd, 0, SEEK_CUR);
 		if (offset == 0)
-			tst_resm(TPASS, "offset is still at 0 as expected");
+			tst_res(TPASS, "offset is still at 0 as expected");
 		else
-			tst_resm(TFAIL, "offset has changed to: %lu", offset);
+			tst_res(TFAIL, "offset has changed to: %lu", offset);
 	}
 
 	if (gettimeofday(&now, NULL) == -1)
-		tst_brkm(TBROK | TERRNO, cleanup, "gettimeofday failed");
+		tst_brk(TBROK | TERRNO, "gettimeofday failed");
 	time_start_usec = now.tv_sec * 1000000 + now.tv_usec;
 	read_bytes_start = get_bytes_read();
 
-	p = mmap(NULL, fsize, PROT_READ, MAP_SHARED | MAP_POPULATE, fd, 0);
-	if (p == MAP_FAILED)
-		tst_brkm(TBROK | TERRNO, cleanup, "mmap failed");
+	p = SAFE_MMAP(NULL, fsize, PROT_READ, MAP_SHARED | MAP_POPULATE, fd, 0);
 
 	/* for old kernels, where MAP_POPULATE doesn't work, touch each page */
 	tmp = 0;
@@ -270,20 +207,20 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 		tmp = tmp ^ p[i];
 	/* prevent gcc from optimizing out loop above */
 	if (tmp != 0)
-		tst_brkm(TBROK, NULL, "This line should not be reached");
+		tst_brk(TBROK, "This line should not be reached");
 
 	if (!do_readahead)
 		*cached = get_cached_size();
 
-	SAFE_MUNMAP(cleanup, p, fsize);
+	SAFE_MUNMAP(p, fsize);
 
 	*read_bytes = get_bytes_read() - read_bytes_start;
 	if (gettimeofday(&now, NULL) == -1)
-		tst_brkm(TBROK | TERRNO, cleanup, "gettimeofday failed");
+		tst_brk(TBROK | TERRNO, "gettimeofday failed");
 	time_end_usec = now.tv_sec * 1000000 + now.tv_usec;
 	*usec = time_end_usec - time_start_usec;
 
-	SAFE_CLOSE(cleanup, fd);
+	SAFE_CLOSE(fd);
 }
 
 static void test_readahead(void)
@@ -302,7 +239,7 @@ static void test_readahead(void)
 	cached_low = get_cached_size();
 	cached_max = cached_max - cached_low;
 
-	tst_resm(TINFO, "read_testfile(0)");
+	tst_res(TINFO, "read_testfile(0)");
 	read_testfile(0, testfile, testfile_size, &read_bytes, &usec, &cached);
 	if (cached > cached_low)
 		cached = cached - cached_low;
@@ -312,7 +249,7 @@ static void test_readahead(void)
 	sync();
 	drop_caches();
 	cached_low = get_cached_size();
-	tst_resm(TINFO, "read_testfile(1)");
+	tst_res(TINFO, "read_testfile(1)");
 	read_testfile(1, testfile, testfile_size, &read_bytes_ra,
 		      &usec_ra, &cached_ra);
 	if (cached_ra > cached_low)
@@ -320,25 +257,25 @@ static void test_readahead(void)
 	else
 		cached_ra = 0;
 
-	tst_resm(TINFO, "read_testfile(0) took: %ld usec", usec);
-	tst_resm(TINFO, "read_testfile(1) took: %ld usec", usec_ra);
+	tst_res(TINFO, "read_testfile(0) took: %ld usec", usec);
+	tst_res(TINFO, "read_testfile(1) took: %ld usec", usec_ra);
 	if (has_file(proc_io_fname, 0)) {
-		tst_resm(TINFO, "read_testfile(0) read: %ld bytes", read_bytes);
-		tst_resm(TINFO, "read_testfile(1) read: %ld bytes",
-			 read_bytes_ra);
+		tst_res(TINFO, "read_testfile(0) read: %ld bytes", read_bytes);
+		tst_res(TINFO, "read_testfile(1) read: %ld bytes",
+			read_bytes_ra);
 		/* actual number of read bytes depends on total RAM */
 		if (read_bytes_ra < read_bytes)
-			tst_resm(TPASS, "readahead saved some I/O");
+			tst_res(TPASS, "readahead saved some I/O");
 		else
-			tst_resm(TFAIL, "readahead failed to save any I/O");
+			tst_res(TFAIL, "readahead failed to save any I/O");
 	} else {
-		tst_resm(TCONF, "Your system doesn't have /proc/pid/io,"
-			 " unable to determine read bytes during test");
+		tst_res(TCONF, "Your system doesn't have /proc/pid/io,"
+			" unable to determine read bytes during test");
 	}
 
-	tst_resm(TINFO, "cache can hold at least: %ld kB", cached_max);
-	tst_resm(TINFO, "read_testfile(0) used cache: %ld kB", cached);
-	tst_resm(TINFO, "read_testfile(1) used cache: %ld kB", cached_ra);
+	tst_res(TINFO, "cache can hold at least: %ld kB", cached_max);
+	tst_res(TINFO, "read_testfile(0) used cache: %ld kB", cached);
+	tst_res(TINFO, "read_testfile(1) used cache: %ld kB", cached_ra);
 
 	if (cached_max * 1024 >= testfile_size) {
 		/*
@@ -346,83 +283,42 @@ static void test_readahead(void)
 		 * for readahead should be at least testfile_size/2
 		 */
 		if (cached_ra * 1024 > testfile_size / 2)
-			tst_resm(TPASS, "using cache as expected");
+			tst_res(TPASS, "using cache as expected");
 		else
-			tst_resm(TWARN, "using less cache than expected");
+			tst_res(TWARN, "using less cache than expected");
 	} else {
-		tst_resm(TCONF, "Page cache on your system is too small "
-			 "to hold whole testfile.");
+		tst_res(TCONF, "Page cache on your system is too small "
+			"to hold whole testfile.");
 	}
 }
 
-int main(int argc, char *argv[])
-{
-	int lc;
-
-	tst_parse_opts(argc, argv, options, help);
-
-	if (opt_fsize)
-		testfile_size = atoi(opt_fsizestr);
-
-	setup();
-	for (lc = 0; TEST_LOOPING(lc); lc++) {
-		tst_count = 0;
-		test_readahead();
-	}
-	cleanup();
-	tst_exit();
-}
-
 static void setup(void)
 {
-	tst_require_root();
-	tst_tmpdir();
-	TEST_PAUSE;
+	if (opt_fsizestr)
+		testfile_size = SAFE_STRTOL(opt_fsizestr, 1, INT_MAX);
 
 	has_file(drop_caches_fname, 1);
 	has_file(meminfo_fname, 1);
 
 	/* check if readahead is supported */
-	ltp_syscall(__NR_readahead, 0, 0, 0);
+	tst_syscall(__NR_readahead, 0, 0, 0);
 
 	pagesize = getpagesize();
 
-	if (tst_fs_type(cleanup, ".") == TST_TMPFS_MAGIC) {
-		tst_resm(TINFO, "TMPFS detected, creating loop device");
-
-		fs_type = tst_dev_fs_type();
-		device = tst_acquire_device(cleanup);
-		if (!device) {
-			tst_brkm(TCONF, cleanup,
-				"Failed to obtain block device");
-		}
-
-		tst_mkfs(cleanup, device, fs_type, NULL, NULL);
-
-		SAFE_MKDIR(cleanup, MNTPOINT, 0755);
-		SAFE_MOUNT(cleanup, device, MNTPOINT, fs_type, 0, NULL);
-		mount_flag = 1;
-
-		sprintf(testfile, MNTPOINT"/testfile");
-	}
+	sprintf(testfile, "%s/testfile", mntpoint);
 	create_testfile();
 }
 
-static void cleanup(void)
-{
-	unlink(testfile);
-	if (mount_flag && tst_umount(MNTPOINT) < 0)
-		tst_resm(TWARN | TERRNO, "umount device:%s failed", device);
-
-	if (device)
-		tst_release_device(device);
-
-	tst_rmdir();
-}
+static struct tst_test test = {
+	.needs_root = 1,
+	.needs_tmpdir = 1,
+	.mount_device = 1,
+	.mntpoint = mntpoint,
+	.setup = setup,
+	.options = options,
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

Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33578 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbeK2DtP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Nov 2018 22:49:15 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so21368753wrr.0
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Nov 2018 08:46:58 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 4/6] syscalls/readahead02: Convert to tst_timer helpers
Date: Wed, 28 Nov 2018 18:46:43 +0200
Message-Id: <20181128164645.783-5-amir73il@gmail.com>
In-Reply-To: <20181128164645.783-1-amir73il@gmail.com>
References: <20181128164645.783-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

To avoid usinf wall clock and get rid of gettimeofday boiler plate code.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../kernel/syscalls/readahead/readahead02.c   | 22 +++++++------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/testcases/kernel/syscalls/readahead/readahead02.c b/testcases/kernel/syscalls/readahead/readahead02.c
index 0acdad482..24f045900 100644
--- a/testcases/kernel/syscalls/readahead/readahead02.c
+++ b/testcases/kernel/syscalls/readahead/readahead02.c
@@ -16,7 +16,6 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
-#include <sys/time.h>
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -25,6 +24,7 @@
 #include <fcntl.h>
 #include "config.h"
 #include "tst_test.h"
+#include "tst_timer.h"
 #include "lapi/syscalls.h"
 
 static char testfile[PATH_MAX] = "testfile";
@@ -130,17 +130,15 @@ static void create_testfile(void)
  * @cached: returns cached kB from /proc/meminfo
  */
 static void read_testfile(int do_readahead, const char *fname, size_t fsize,
-			  unsigned long *read_bytes, long *usec,
+			  unsigned long *read_bytes, long long *usec,
 			  unsigned long *cached)
 {
 	int fd;
 	size_t i = 0;
 	long read_bytes_start;
 	unsigned char *p, tmp;
-	unsigned long time_start_usec, time_end_usec;
 	unsigned long cached_start, max_ra_estimate = 0;
 	off_t offset = 0;
-	struct timeval now;
 
 	fd = SAFE_OPEN(fname, O_RDONLY);
 
@@ -180,9 +178,7 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 			tst_res(TFAIL, "offset has changed to: %lu", offset);
 	}
 
-	if (gettimeofday(&now, NULL) == -1)
-		tst_brk(TBROK | TERRNO, "gettimeofday failed");
-	time_start_usec = now.tv_sec * 1000000 + now.tv_usec;
+	tst_timer_start(CLOCK_MONOTONIC);
 	read_bytes_start = get_bytes_read();
 
 	p = SAFE_MMAP(NULL, fsize, PROT_READ, MAP_SHARED | MAP_POPULATE, fd, 0);
@@ -201,10 +197,8 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 	SAFE_MUNMAP(p, fsize);
 
 	*read_bytes = get_bytes_read() - read_bytes_start;
-	if (gettimeofday(&now, NULL) == -1)
-		tst_brk(TBROK | TERRNO, "gettimeofday failed");
-	time_end_usec = now.tv_sec * 1000000 + now.tv_usec;
-	*usec = time_end_usec - time_start_usec;
+	tst_timer_stop();
+	*usec = tst_timer_elapsed_us();
 
 	SAFE_CLOSE(fd);
 }
@@ -212,7 +206,7 @@ static void read_testfile(int do_readahead, const char *fname, size_t fsize,
 static void test_readahead(void)
 {
 	unsigned long read_bytes, read_bytes_ra;
-	long usec, usec_ra;
+	long long usec, usec_ra;
 	unsigned long cached_max, cached_low, cached, cached_ra;
 	char proc_io_fname[128];
 	sprintf(proc_io_fname, "/proc/%u/io", getpid());
@@ -253,8 +247,8 @@ static void test_readahead(void)
 	else
 		cached_ra = 0;
 
-	tst_res(TINFO, "read_testfile(0) took: %ld usec", usec);
-	tst_res(TINFO, "read_testfile(1) took: %ld usec", usec_ra);
+	tst_res(TINFO, "read_testfile(0) took: %lli usec", usec);
+	tst_res(TINFO, "read_testfile(1) took: %lli usec", usec_ra);
 	if (has_file(proc_io_fname, 0)) {
 		tst_res(TINFO, "read_testfile(0) read: %ld bytes", read_bytes);
 		tst_res(TINFO, "read_testfile(1) read: %ld bytes",
-- 
2.17.1

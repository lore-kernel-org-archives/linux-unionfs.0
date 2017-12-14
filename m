From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 06/18] fsck.overlay: open lowerdirs in advance
Date: Thu, 14 Dec 2017 14:47:35 +0800
Message-ID: <20171214064747.20999-7-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11978 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbdLNGmA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:00 -0500
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

Now, we use absolute path and lstat() to get directory and file's stat
when scaning each lower directories. So we need to package lower path
to absolute path every time.

This patch check fd counts and open each lower root path in advice,
prepare for invoking fstatat() with relative path instead of absolute path.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fsck.c | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 lib.h  |  3 +++
 2 files changed, 88 insertions(+), 6 deletions(-)

diff --git a/fsck.c b/fsck.c
index f4c806b..0a84903 100644
--- a/fsck.c
+++ b/fsck.c
@@ -13,8 +13,12 @@
 #include <getopt.h>
 #include <libgen.h>
 #include <stdbool.h>
+#include <fcntl.h>
+#include <unistd.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 #include <linux/limits.h>
 
 #include "common.h"
@@ -28,22 +32,80 @@ char *program_name;
 char **lowerdir = NULL;
 char upperdir[PATH_MAX] = {0};
 char workdir[PATH_MAX] = {0};
+int *lowerfd = NULL;
 unsigned int lower_num = 0;
 int flags = 0;		/* user input option flags */
 int status = 0;		/* fsck scan status */
 
+/* Open lower dirs */
+static int ovl_open_lowerdirs(void)
+{
+	unsigned int i;
+	struct rlimit rlim;
+	rlim_t rlim_need = lower_num + NOFILE_BASE;
+
+	/* If RLIMIT_NOFILE limit is small than we need, try to expand limit */
+	if ((getrlimit(RLIMIT_NOFILE, &rlim))) {
+		print_err(_("Failed to getrlimit:%s\n"), strerror(errno));
+		return -1;
+	}
+	print_debug(_("Open softlimit=%lu, hardlimit=%lu, need=%lu\n"),
+		      rlim.rlim_cur, rlim.rlim_max, rlim_need);
+
+	if (rlim.rlim_cur < rlim_need) {
+		rlim.rlim_cur = rlim_need;
+		rlim.rlim_max = rlim.rlim_cur < rlim.rlim_max ?
+				rlim.rlim_max : rlim.rlim_cur;
+		if ((setrlimit(RLIMIT_NOFILE, &rlim))) {
+			print_err(_("Failed to setrlimit:%s\n"), strerror(errno));
+			print_info(_("Open fd number limit=%lu too small, need %lu\n"),
+				     rlim.rlim_max, rlim_need);
+			return -1;
+		}
+	}
+
+	lowerfd = smalloc(lower_num * sizeof(int));
+	for (i = 0; i < lower_num; i++) {
+		lowerfd[i] = open(lowerdir[i],
+				  O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC);
+		if (lowerfd[i] < 0) {
+			print_err(_("Failed to open %s:%s\n"),
+				    lowerdir[i], strerror(errno));
+			goto err;
+		}
+	}
+
+	return 0;
+err:
+	for (i--; i >= 0; i--) {
+		close(lowerfd[i]);
+		lowerfd[i] = 0;
+	}
+	free(lowerfd);
+	lowerfd = NULL;
+	return -1;
+}
+
 /* Cleanup lower directories buf */
 static void ovl_clean_lowerdirs(void)
 {
 	unsigned int i;
 
 	for (i = 0; i < lower_num; i++) {
+		if (lowerfd && lowerfd[i]) {
+			close(lowerfd[i]);
+			lowerfd[i] = 0;
+		}
 		free(lowerdir[i]);
 		lowerdir[i] = NULL;
-		lower_num = 0;
+	}
+	if (lowerfd) {
+		free(lowerfd);
+		lowerfd = NULL;
 	}
 	free(lowerdir);
 	lowerdir = NULL;
+	lower_num = 0;
 }
 
 static void usage(void)
@@ -71,6 +133,7 @@ static void parse_options(int argc, char *argv[])
 	int c;
 	int ret = 0;
 	bool opt_conflict = false;
+	bool show_usage = false;
 
 	struct option long_options[] = {
 		{"lowerdir", required_argument, NULL, 'l'},
@@ -85,9 +148,14 @@ static void parse_options(int argc, char *argv[])
 	while ((c = getopt_long(argc, argv, "l:u:w:apnyvVh", long_options, NULL)) != -1) {
 		switch (c) {
 		case 'l':
+			if (lower_num)
+				ovl_clean_lowerdirs();
+
 			lowertemp = strdup(optarg);
 			ret = ovl_resolve_lowerdirs(lowertemp, &lowerdir, &lower_num);
 			free(lowertemp);
+			if (!ret)
+				ret = ovl_open_lowerdirs();
 			break;
 		case 'u':
 			if (realpath(optarg, upperdir)) {
@@ -139,18 +207,29 @@ static void parse_options(int argc, char *argv[])
 		}
 
 		if (ret)
-			exit(1);
+			goto err_out;
 	}
 
 	if (!lower_num || (!(flags & FL_UPPER) && lower_num == 1)) {
-		print_info(_("Please specify correct lowerdirs and upperdir\n"));
-		usage();
+		print_info(_("Please specify correct lowerdirs and upperdir!\n\n"));
+		show_usage = true;
+		goto err_out;
 	}
 
 	if (opt_conflict) {
-		print_info(_("Only one of the options -p/-a, -n or -y can be specified.\n"));
-		usage();
+		print_info(_("Only one of the options -p/-a, -n or -y can be specified!\n\n"));
+		show_usage = true;
+		goto err_out;
 	}
+
+	return;
+
+err_out:
+	if (lower_num)
+		ovl_clean_lowerdirs();
+	if (show_usage)
+		usage();
+	exit(1);
 }
 
 void fsck_status_check(int *val)
diff --git a/lib.h b/lib.h
index 618791c..e389ed6 100644
--- a/lib.h
+++ b/lib.h
@@ -1,6 +1,9 @@
 #ifndef OVL_LIB_H
 #define OVL_LIB_H
 
+/* Open file descriptor number base limit */
+#define NOFILE_BASE	20	/* not contain lower directory's fd */
+
 /* Common return value */
 #define FSCK_OK          0	/* No errors */
 #define FSCK_NONDESTRUCT 1	/* File system errors corrected */
-- 
2.9.5

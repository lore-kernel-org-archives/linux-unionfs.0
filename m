From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 03/18] fsck.overlay: add -n -p and -y options
Date: Thu, 14 Dec 2017 14:47:32 +0800
Message-ID: <20171214064747.20999-4-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11985 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751472AbdLNGmD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:03 -0500
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

Add -n -p and -y options to make it official as fsck utilities.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fsck.c | 36 ++++++++++++++++++++++++++++++------
 lib.c  |  3 ++-
 lib.h  |  6 +++++-
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/fsck.c b/fsck.c
index 7f704c8..f4c806b 100644
--- a/fsck.c
+++ b/fsck.c
@@ -49,13 +49,16 @@ static void ovl_clean_lowerdirs(void)
 static void usage(void)
 {
 	print_info(_("Usage:\n\t%s [-l lowerdir] [-u upperdir] [-w workdir] "
-		    "[-avhV]\n\n"), program_name);
+		    "[-pnyvhV]\n\n"), program_name);
 	print_info(_("Options:\n"
 		    "-l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,\n"
-		    "                          multiple lower use ':' as separator\n"
+		    "                          multiple lower use ':' as separator,\n"
+		    "                          the leftmost one is the toppest\n"
 		    "-u, --upperdir=UPPERDIR   specify upper directory of overlayfs\n"
 		    "-w, --workdir=WORKDIR     specify work directory of overlayfs\n"
-		    "-a, --auto                repair automatically (no questions)\n"
+		    "-p,                       automatic repair (no questions)\n"
+		    "-n,                       make no changes to the filesystem\n"
+		    "-y,                       assume \"yes\" to all questions\n"
 		    "-v, --verbose             print more messages of overlayfs\n"
 		    "-h, --help                display this usage of overlayfs\n"
 		    "-V, --version             display version information\n"));
@@ -67,19 +70,19 @@ static void parse_options(int argc, char *argv[])
 	char *lowertemp;
 	int c;
 	int ret = 0;
+	bool opt_conflict = false;
 
 	struct option long_options[] = {
 		{"lowerdir", required_argument, NULL, 'l'},
 		{"upperdir", required_argument, NULL, 'u'},
 		{"workdir", required_argument, NULL, 'w'},
-		{"auto", no_argument, NULL, 'a'},
 		{"verbose", no_argument, NULL, 'v'},
 		{"version", no_argument, NULL, 'V'},
 		{"help", no_argument, NULL, 'h'},
 		{NULL, 0, NULL, 0}
 	};
 
-	while ((c = getopt_long(argc, argv, "l:u:w:avVh", long_options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "l:u:w:apnyvVh", long_options, NULL)) != -1) {
 		switch (c) {
 		case 'l':
 			lowertemp = strdup(optarg);
@@ -105,7 +108,23 @@ static void parse_options(int argc, char *argv[])
 			}
 			break;
 		case 'a':
-			flags |= FL_AUTO;
+		case 'p':
+			if (flags & (FL_OPT_YES | FL_OPT_NO))
+				opt_conflict = true;
+			else
+				flags |= FL_OPT_AUTO;
+			break;
+		case 'n':
+			if (flags & (FL_OPT_YES | FL_OPT_AUTO))
+				opt_conflict = true;
+			else
+				flags |= FL_OPT_NO;
+			break;
+		case 'y':
+			if (flags & (FL_OPT_NO | FL_OPT_AUTO))
+				opt_conflict = true;
+			else
+				flags |= FL_OPT_YES;
 			break;
 		case 'v':
 			flags |= FL_VERBOSE;
@@ -127,6 +146,11 @@ static void parse_options(int argc, char *argv[])
 		print_info(_("Please specify correct lowerdirs and upperdir\n"));
 		usage();
 	}
+
+	if (opt_conflict) {
+		print_info(_("Only one of the options -p/-a, -n or -y can be specified.\n"));
+		usage();
+	}
 }
 
 void fsck_status_check(int *val)
diff --git a/lib.c b/lib.c
index a6832fe..7607517 100644
--- a/lib.c
+++ b/lib.c
@@ -46,7 +46,8 @@ static int ask_yn(const char *question, int def)
 /* Ask user */
 int ask_question(const char *question, int def)
 {
-	if (flags & FL_AUTO) {
+	if (flags & FL_OPT_MASK) {
+		def = (flags & FL_OPT_YES) ? 1 : (flags & FL_OPT_NO) ? 0 : def;
 		print_info(_("%s? %s\n"), question, def ? _("y") : _("n"));
 		return def;
 	}
diff --git a/lib.h b/lib.h
index 463b263..2956235 100644
--- a/lib.h
+++ b/lib.h
@@ -19,7 +19,11 @@
 #define FL_VERBOSE	(1 << 0)	/* verbose */
 #define FL_UPPER	(1 << 1)	/* specify upper directory */
 #define FL_WORK		(1 << 2)	/* specify work directory */
-#define FL_AUTO		(1 << 3)	/* automactically scan dirs and repair */
+#define FL_OPT_AUTO	(1 << 3)	/* automactically scan dirs and repair */
+#define FL_OPT_NO	(1 << 4)	/* no changes to the filesystem */
+#define FL_OPT_YES	(1 << 5)	/* yes to all questions */
+#define FL_OPT_MASK	(FL_OPT_AUTO|FL_OPT_NO|FL_OPT_YES)
+
 
 /* Scan path type */
 #define OVL_UPPER	0
-- 
2.9.5

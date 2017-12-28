From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v3 3/6] fsck.overlay: encapsulate underlying directories options
Date: Thu, 28 Dec 2017 19:40:20 +0800
Message-ID: <20171228114023.43999-4-yi.zhang@huawei.com>
References: <20171228114023.43999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:44791 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752954AbdL1LdS (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Dec 2017 06:33:18 -0500
In-Reply-To: <20171228114023.43999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Encapsulate separate underlying directories options to use -o option as
for mount, see mount(8).

Old Usage:
  fsck.overlay [-l lowerdir] [-u upperdir] [-w workdir]

New Usage:
  fsck.overlay [-o lowerdir=<lowers>,upperdir=<upper>,workdir=<work>]

Example:
  fsck.overlay -o lowerdir=lower,upperdir=upper,workdir=work
  or
  fsck.overlay -o lowerdir=lower -o upperdir=upper -o workdir=work

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 README.md |  11 ++--
 check.c   |   4 +-
 fsck.c    |  78 +++++++++++++--------------
 mount.c   | 182 +++++++++++++++++++++++++++++++++++---------------------------
 mount.h   |  12 ++++-
 5 files changed, 157 insertions(+), 130 deletions(-)

diff --git a/README.md b/README.md
index 458a815..a8d0b1c 100644
--- a/README.md
+++ b/README.md
@@ -44,13 +44,11 @@ Usage
 
 2. Run fsck.overlay program:
    Usage:
-   fsck.overlay [-l lowerdir] [-u upperdir] [-w workdir] [-pnyvhV]
+   fsck.overlay [-o lowerdir=<lowers>,upperdir=<upper>,workdir=<work>] [-pnyvhV]
 
    Options:
-   -l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,
-                             multiple lower use ':' as separator.
-   -u, --upperdir=UPPERDIR   specify upper directory of overlayfs
-   -w, --workdir=WORKDIR     specify work directory of overlayfs
+   -o,                       specify underlying directories of overlayfs:
+                             multiple lower directories use ':' as separator
    -p,                       automatic repair (no questions)
    -n,                       make no changes to the filesystem
    -y,                       assume "yes" to all questions
@@ -58,6 +56,9 @@ Usage
    -h, --help                display this usage of overlayfs
    -V, --version             display version information
 
+   Example:
+   fsck.overlay -o lowerdir=lower,upperdir=upper,workdir=work
+
 3. Exit value:
    0      No errors
    1      Filesystem errors corrected
diff --git a/check.c b/check.c
index efa180f..0b5d49b 100644
--- a/check.c
+++ b/check.c
@@ -58,8 +58,8 @@ struct ovl_redirect_entry {
 #define WHITEOUT_MOD	0
 
 extern char **lowerdir;
-extern char upperdir[];
-extern char workdir[];
+extern char *upperdir;
+extern char *workdir;
 extern int lower_num;
 extern int flags;
 extern int status;
diff --git a/fsck.c b/fsck.c
index 44211f7..5d34378 100644
--- a/fsck.c
+++ b/fsck.c
@@ -38,15 +38,16 @@
 
 char *program_name;
 
+char *lowerdirs = NULL;
 char **lowerdir = NULL;
-char upperdir[PATH_MAX] = {0};
-char workdir[PATH_MAX] = {0};
+char *upperdir = NULL;
+char *workdir = NULL;
 int lower_num = 0;
 int flags = 0;		/* user input option flags */
 int status = 0;		/* fsck scan status */
 
-/* Cleanup lower directories buf */
-static void ovl_clean_lowerdirs(void)
+/* Cleanup underlying directories buffer */
+static void ovl_clean_dirs(void)
 {
 	int i;
 
@@ -57,17 +58,19 @@ static void ovl_clean_lowerdirs(void)
 	free(lowerdir);
 	lowerdir = NULL;
 	lower_num = 0;
+	free(upperdir);
+	upperdir = NULL;
+	free(workdir);
+	workdir = NULL;
 }
 
 static void usage(void)
 {
-	print_info(_("Usage:\n\t%s [-l lowerdir] [-u upperdir] [-w workdir] "
+	print_info(_("Usage:\n\t%s [-o lowerdir=<lowers>,upperdir=<upper>,workdir=<work>] "
 		    "[-pnyvhV]\n\n"), program_name);
 	print_info(_("Options:\n"
-		    "-l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,\n"
-		    "                          multiple lower use ':' as separator\n"
-		    "-u, --upperdir=UPPERDIR   specify upper directory of overlayfs\n"
-		    "-w, --workdir=WORKDIR     specify work directory of overlayfs\n"
+		    "-o,                       specify underlying directories of overlayfs:\n"
+		    "                          multiple lower directories use ':' as separator\n"
 		    "-p,                       automatic repair (no questions)\n"
 		    "-n,                       make no changes to the filesystem\n"
 		    "-y,                       assume \"yes\" to all questions\n"
@@ -79,46 +82,25 @@ static void usage(void)
 
 static void parse_options(int argc, char *argv[])
 {
-	char *lowertemp;
+	struct ovl_config config = {0};
+	char *ovl_opts = NULL;
 	int c;
 	int ret = 0;
-	bool show_usage = false;
 	bool opt_conflict = false;
 
 	struct option long_options[] = {
-		{"lowerdir", required_argument, NULL, 'l'},
-		{"upperdir", required_argument, NULL, 'u'},
-		{"workdir", required_argument, NULL, 'w'},
 		{"verbose", no_argument, NULL, 'v'},
 		{"version", no_argument, NULL, 'V'},
 		{"help", no_argument, NULL, 'h'},
 		{NULL, 0, NULL, 0}
 	};
 
-	while ((c = getopt_long(argc, argv, "l:u:w:apnyvVh", long_options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "o:apnyvVh", long_options, NULL)) != -1) {
 		switch (c) {
-		case 'l':
-			lowertemp = strdup(optarg);
-			ret = ovl_resolve_lowerdirs(lowertemp, &lowerdir, &lower_num);
-			free(lowertemp);
-			break;
-		case 'u':
-			if (realpath(optarg, upperdir)) {
-				print_debug(_("Upperdir:%s\n"), upperdir);
-				flags |= FL_UPPER;
-			} else {
-				print_err(_("Failed to resolve upperdir:%s\n"), optarg);
-				ret = -1;
-			}
-			break;
-		case 'w':
-			if (realpath(optarg, workdir)) {
-				print_debug(_("Workdir:%s\n"), workdir);
-				flags |= FL_WORK;
-			} else {
-				print_err(_("Failed to resolve workdir:%s\n"), optarg);
-				ret = -1;
-			}
+		case 'o':
+			ovl_opts = sstrdup(optarg);
+			ovl_parse_opt(ovl_opts, &config);
+			free(ovl_opts);
 			break;
 		case 'a':
 		case 'p':
@@ -155,23 +137,35 @@ static void parse_options(int argc, char *argv[])
 			goto err_out;
 	}
 
+	/* Resolve and get each underlying directory of overlay filesystem */
+	ovl_get_dirs(&config, &lowerdir, &lower_num, &upperdir, &workdir);
+	if (upperdir)
+		flags |= FL_UPPER;
+	if (workdir)
+		flags |= FL_WORK;
+
 	if (!lower_num || (!(flags & FL_UPPER) && lower_num == 1)) {
 		print_info(_("Please specify correct lowerdirs and upperdir!\n\n"));
-		show_usage = true;
+		goto err_out;
+	}
+
+	if ((flags & FL_UPPER) && !(flags & FL_WORK)) {
+		print_info(_("Please specify correct workdir!\n\n"));
 		goto err_out;
 	}
 
 	if (opt_conflict) {
 		print_info(_("Only one of the options -p/-a, -n or -y can be specified!\n\n"));
-		show_usage = true;
 		goto err_out;
 	}
 
+	ovl_free_opt(&config);
 	return;
 
 err_out:
-	if (show_usage)
-		usage();
+	ovl_free_opt(&config);
+	ovl_clean_dirs();
+	usage();
 	exit(1);
 }
 
@@ -212,7 +206,7 @@ int main(int argc, char *argv[])
 
 out:
 	fsck_status_check(&exit_value);
-	ovl_clean_lowerdirs();
+	ovl_clean_dirs();
 
 	if (err)
 		exit_value |= FSCK_ERROR;
diff --git a/mount.c b/mount.c
index fba51e9..908cee0 100644
--- a/mount.c
+++ b/mount.c
@@ -38,19 +38,18 @@
 #include "mount.h"
 
 struct ovl_mnt_entry {
-	char *lowers;
 	char **lowerdir;
 	int lowernum;
-	char upperdir[PATH_MAX];
-	char workdir[PATH_MAX];
+	char *upperdir;
+	char *workdir;
 };
 
 /* Mount buf allocate a time */
 #define ALLOC_NUM	16
 
 extern char **lowerdir;
-extern char upperdir[];
-extern char workdir[];
+extern char *upperdir;
+extern char *workdir;
 extern int lower_num;
 
 /*
@@ -78,9 +77,10 @@ static unsigned int ovl_split_lowerdirs(char *lower)
 }
 
 /* Resolve each lower directories and check the validity */
-int ovl_resolve_lowerdirs(char *loweropt, char ***lowerdir,
-			  int *lowernum)
+static int ovl_resolve_lowerdirs(char *loweropt, char ***lowerdir,
+				 int *lowernum)
 {
+	char temp[PATH_MAX] = {0};
 	int num;
 	char **dirs;
 	char *p;
@@ -97,12 +97,12 @@ int ovl_resolve_lowerdirs(char *loweropt, char ***lowerdir,
 
 	p = loweropt;
 	for (i = 0; i < num; i++) {
-		dirs[i] = smalloc(PATH_MAX);
-		if (!realpath(p, dirs[i])) {
+		if (!realpath(p, temp)) {
 			print_err(_("Failed to resolve lowerdir:%s:%s\n"),
 				    p, strerror(errno));
 			goto err;
 		}
+		dirs[i] = sstrdup(temp);
 		print_debug(_("Lowerdir %u:%s\n"), i, dirs[i]);
 		p = strchr(p, '\0') + 1;
 	}
@@ -115,6 +115,7 @@ err:
 	for (i--; i >= 0; i--)
 		free(dirs[i]);
 	free(dirs);
+	*lowerdir = NULL;
 	*lowernum = 0;
 	return -1;
 }
@@ -146,79 +147,99 @@ static char *ovl_next_opt(char **s)
 	return sbegin;
 }
 
+static inline char *ovl_match_dump(const char *opt, const char *type)
+{
+	int len = strlen(opt) - strlen(type) + 1;
+
+	return sstrndup(opt+strlen(type), len);
+}
+
 /*
- * Split and parse opt to each directories.
- *
- * Note: FIXME: We cannot distinguish mounted directories if overlayfs was
- * mounted use relative path, so there may have misjudgment.
+ * Resolve and get each underlying directory of overlay filesystem
+ */
+int ovl_get_dirs(struct ovl_config *config, char ***lowerdir,
+		 int *lowernum, char **upperdir, char **workdir)
+{
+	char temp[PATH_MAX] = {0};
+
+	/* Resolve upperdir */
+	if (!realpath(config->upperdir, temp)) {
+		print_err(_("Faile to resolve upperdir:%s:%s\n"),
+			    config->upperdir, strerror(errno));
+		goto err_out;
+	}
+	*upperdir = sstrdup(temp);
+	print_debug(_("Upperdir: %s\n"), *upperdir);
+
+	/* Resolve workdir */
+	if (!realpath(config->workdir, temp)) {
+		print_err(_("Faile to resolve workdir:%s:%s\n"),
+			    config->workdir, strerror(errno));
+		goto err_work;
+	}
+	*workdir = sstrdup(temp);
+	print_debug(_("Workdir: %s\n"), *workdir);
+
+	/* Resolve lowerdir */
+	if (ovl_resolve_lowerdirs(config->lowerdir, lowerdir, lowernum))
+		goto err_lower;
+
+	return 0;
+
+err_lower:
+	free(*workdir);
+	*workdir = NULL;
+err_work:
+	free(*upperdir);
+	*upperdir = NULL;
+err_out:
+	return -1;
+}
+
+void ovl_free_opt(struct ovl_config *config)
+{
+	free(config->upperdir);
+	config->upperdir = NULL;
+	free(config->lowerdir);
+	config->lowerdir = NULL;
+	free(config->workdir);
+	config->workdir = NULL;
+}
+
+/*
+ * Split and parse opt to each underlying directories.
  */
-static int ovl_parse_opt(char *opt, struct ovl_mnt_entry *entry)
+void ovl_parse_opt(char *opt, struct ovl_config *config)
 {
-	char tmp[PATH_MAX] = {0};
 	char *p;
-	int len;
-	int ret;
-	int i;
 
 	while ((p = ovl_next_opt(&opt)) != NULL) {
 		if (!*p)
 			continue;
 
 		if (!strncmp(p, OPT_UPPERDIR, strlen(OPT_UPPERDIR))) {
-			len = strlen(p) - strlen(OPT_UPPERDIR) + 1;
-			strncpy(tmp, p+strlen(OPT_UPPERDIR), len);
-
-			if (!realpath(tmp, entry->upperdir)) {
-				print_err(_("Faile to resolve path:%s:%s\n"),
-					    tmp, strerror(errno));
-				ret = -1;
-				goto errout;
-			}
+			free(config->upperdir);
+			config->upperdir = ovl_match_dump(p, OPT_UPPERDIR);
 		} else if (!strncmp(p, OPT_LOWERDIR, strlen(OPT_LOWERDIR))) {
-			len = strlen(p) - strlen(OPT_LOWERDIR) + 1;
-			entry->lowers = smalloc(len);
-			strncpy(entry->lowers, p+strlen(OPT_LOWERDIR), len);
-
-			if ((ret = ovl_resolve_lowerdirs(entry->lowers,
-					&entry->lowerdir, &entry->lowernum)))
-				goto errout;
-
+			free(config->lowerdir);
+			config->lowerdir = ovl_match_dump(p, OPT_LOWERDIR);
 		} else if (!strncmp(p, OPT_WORKDIR, strlen(OPT_WORKDIR))) {
-			len = strlen(p) - strlen(OPT_WORKDIR) + 1;
-			strncpy(tmp, p+strlen(OPT_WORKDIR), len);
-
-			if (!realpath(tmp, entry->workdir)) {
-				print_err(_("Faile to resolve path:%s:%s\n"),
-					    tmp, strerror(errno));
-				ret = -1;
-				goto errout;
-			}
+			free(config->workdir);
+			config->workdir = ovl_match_dump(p, OPT_WORKDIR);
 		}
 	}
-
-errout:
-	if (entry->lowernum) {
-		for (i = 0; i < entry->lowernum; i++)
-			free(entry->lowerdir[i]);
-		free(entry->lowerdir);
-		entry->lowerdir = NULL;
-		entry->lowernum = 0;
-	}
-	free(entry->lowers);
-	entry->lowers = NULL;
-
-	return ret;
 }
 
 /* Scan current mounted overlayfs and get used underlying directories */
 static int ovl_scan_mount_init(struct ovl_mnt_entry **ovl_mnt_entries,
 			       int *ovl_mnt_count)
 {
-	struct ovl_mnt_entry *mnt_entries;
-	struct mntent *mnt;
+	struct ovl_mnt_entry *entries = NULL;
+	struct mntent *mnt = NULL;
+	struct ovl_config config = {0};
 	FILE *fp;
 	char *opt;
-	int allocated, num = 0;
+	int allocated, i = 0;
 
 	fp = setmntent(MOUNT_TAB, "r");
 	if (!fp) {
@@ -227,32 +248,32 @@ static int ovl_scan_mount_init(struct ovl_mnt_entry **ovl_mnt_entries,
 		return -1;
 	}
 
-	allocated = ALLOC_NUM;
-	mnt_entries = smalloc(sizeof(struct ovl_mnt_entry) * allocated);
+	allocated = sizeof(struct ovl_mnt_entry) * ALLOC_NUM;
+	entries = smalloc(allocated);
 
 	while ((mnt = getmntent(fp))) {
-		if (!strcmp(mnt->mnt_type, OVERLAY_NAME) ||
-		    !strcmp(mnt->mnt_type, OVERLAY_NAME_OLD)) {
+		if (strcmp(mnt->mnt_type, OVERLAY_NAME))
+			continue;
 
-			opt = sstrdup(mnt->mnt_opts);
-			if (ovl_parse_opt(opt, &mnt_entries[num])) {
-				free(opt);
-				continue;
-			}
+		opt = sstrdup(mnt->mnt_opts);
+		ovl_parse_opt(opt, &config);
 
-			num++;
-			if (num % ALLOC_NUM == 0) {
-				allocated += ALLOC_NUM;
-				mnt_entries = srealloc(mnt_entries,
-				     sizeof(struct ovl_mnt_entry) * allocated);
+		if (!ovl_get_dirs(&config,
+				 &entries[i].lowerdir, &entries[i].lowernum,
+				 &entries[i].upperdir, &entries[i].workdir)) {
+			i++;
+			if (i % ALLOC_NUM == 0) {
+				allocated += sizeof(struct ovl_mnt_entry) * ALLOC_NUM;
+				entries = srealloc(entries, allocated);
 			}
-
-			free(opt);
 		}
+
+		ovl_free_opt(&config);
+		free(opt);
 	}
 
-	*ovl_mnt_entries = mnt_entries;
-	*ovl_mnt_count = num;
+	*ovl_mnt_entries = entries;
+	*ovl_mnt_count = i;
 
 	endmntent(fp);
 	return 0;
@@ -267,7 +288,8 @@ static void ovl_scan_mount_exit(struct ovl_mnt_entry *ovl_mnt_entries,
 		for (j = 0; j < ovl_mnt_entries[i].lowernum; j++)
 			free(ovl_mnt_entries[i].lowerdir[j]);
 		free(ovl_mnt_entries[i].lowerdir);
-		free(ovl_mnt_entries[i].lowers);
+		free(ovl_mnt_entries[i].upperdir);
+		free(ovl_mnt_entries[i].workdir);
 	}
 	free(ovl_mnt_entries);
 }
@@ -279,6 +301,8 @@ static void ovl_scan_mount_exit(struct ovl_mnt_entry *ovl_mnt_entries,
  *
  * Note: fsck may modify lower layers, so even match only one directory
  *       is triggered as mounted.
+ * FIXME: We cannot distinguish mounted directories if overlayfs was
+ *        mounted use relative path, so there may have misjudgment.
  */
 int ovl_check_mount(bool *mounted)
 {
diff --git a/mount.h b/mount.h
index 7eed0d0..2cf5e6a 100644
--- a/mount.h
+++ b/mount.h
@@ -19,8 +19,16 @@
 #ifndef OVL_MOUNT_H
 #define OVL_MOUNT_H
 
-int ovl_resolve_lowerdirs(char *loweropt, char ***lowerdir,
-                          int *lowernum);
+struct ovl_config {
+	char *lowerdir;
+	char *upperdir;
+	char *workdir;
+};
+
+void ovl_parse_opt(char *opt, struct ovl_config *config);
+void ovl_free_opt(struct ovl_config *config);
+int ovl_get_dirs(struct ovl_config *config, char ***lowerdir,
+		 int *lowernum, char **upperdir, char **workdir);
 int ovl_check_mount(bool *mounted);
 
 #endif /* OVL_MOUNT_H */
-- 
2.9.5

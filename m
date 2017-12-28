From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v3 1/6] overlay: implement fsck utility
Date: Thu, 28 Dec 2017 19:40:18 +0800
Message-ID: <20171228114023.43999-2-yi.zhang@huawei.com>
References: <20171228114023.43999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20171228114023.43999-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

fsck.overlay
============

fsck.overlay is used to check and optionally repair underlying
directories of overlay-filesystem.

Check the following points:

Whiteouts
---------

A whiteout is a character device with 0/0 device number. It is used to
record the removed files or directories, When a whiteout is found in a
directory, there should be at least one directory or file with the
same name in any of the corresponding lower layers. If not exist, the
whiteout will be treated as orphan whiteout and remove.

Redirect directories
--------------------

An redirect directory is a directory with "trusted.overlay.redirect"
xattr valued to the path of the original location from the root of
the overlay. It is only used when renaming a directory and "redirect
dir" feature is enabled.
If an redirect directory is found, the following must be met:

1) The directory path pointed by redirect xattr should exist in one of
   lower layers.
2) The origin directory should be redirected only once in one layer,
   which means there is only one redirect xattr point to this origin
   directory in the specified layer.
3) A whiteout or an opaque directory with the same name to origin should
   exist in the same directory as the redirect directory.

If not, 1) The redirect xattr is invalid and need to remove 2) One of
the redirect xattr is redundant but not sure which one is, ask user or
warn in auto mode 3) Create a whiteout device or set opaque xattr to an
existing directory if the parent directory was meregd or remove xattr
if not.

Usage
=====

1. Ensure overlay filesystem is not mounted based on directories which
need to
   check.

2. Run fsck.overlay program:
   Usage:
   fsck.overlay [-l lowerdir] [-u upperdir] [-w workdir] [-avhV]

   Options:
   -l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,
                             multiple lower use ':' as separator.
   -u, --upperdir=UPPERDIR   specify upper directory of overlayfs
   -w, --workdir=WORKDIR     specify work directory of overlayfs
   -a, --auto                repair automatically (no questions)
   -v, --verbose             print more messages of overlayfs
   -h, --help                display this usage of overlayfs
   -V, --version             display version information

3. Exit value:
   0      No errors
   1      Filesystem errors corrected
   2      System should be rebooted
   4      Filesystem errors left uncorrected
   8      Operational error
   16     Usage or syntax error
   32     Checking canceled by user request
   128    Shared-library error

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 Makefile  |  31 ++++
 README.md |  79 ++++++++++
 check.c   | 489 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 check.h   |  25 ++++
 common.c  | 119 +++++++++++++++
 common.h  |  53 +++++++
 config.h  |  40 +++++
 fsck.c    | 201 ++++++++++++++++++++++++++
 lib.c     | 237 ++++++++++++++++++++++++++++++
 lib.h     | 101 +++++++++++++
 mount.c   | 330 ++++++++++++++++++++++++++++++++++++++++++
 mount.h   |  26 ++++
 12 files changed, 1731 insertions(+)
 create mode 100644 Makefile
 create mode 100644 README.md
 create mode 100644 check.c
 create mode 100644 check.h
 create mode 100644 common.c
 create mode 100644 common.h
 create mode 100644 config.h
 create mode 100644 fsck.c
 create mode 100644 lib.c
 create mode 100644 lib.h
 create mode 100644 mount.c
 create mode 100644 mount.h

diff --git a/Makefile b/Makefile
new file mode 100644
index 0000000..ced5005
--- /dev/null
+++ b/Makefile
@@ -0,0 +1,31 @@
+CFLAGS = -Wall -g
+LFLAGS = -lm
+CC = gcc
+
+all: overlay
+
+overlay: fsck.o common.o lib.o check.o mount.o
+	$(CC) $(LFLAGS) fsck.o common.o lib.o check.o mount.o -o fsck.overlay
+
+fsck.o:
+	$(CC) $(CFLAGS) -c fsck.c
+
+common.o:
+	$(CC) $(CFLAGS) -c common.c
+
+lib.o:
+	$(CC) $(CFLAGS) -c lib.c
+
+check.o:
+	$(CC) $(CFLAGS) -c check.c
+
+mount.o:
+	$(CC) $(CFLAGS) -c mount.c
+
+clean:
+	rm -f *.o fsck.overlay
+	rm -rf bin
+
+install: all
+	mkdir bin
+	cp fsck.overlay bin
diff --git a/README.md b/README.md
new file mode 100644
index 0000000..c2acb65
--- /dev/null
+++ b/README.md
@@ -0,0 +1,79 @@
+fsck.overlay
+============
+
+fsck.overlay is used to check and optionally repair underlying directories
+of overlay-filesystem.
+
+Check the following points:
+
+Whiteouts
+---------
+
+A whiteout is a character device with 0/0 device number. It is used to record
+the removed files or directories, When a whiteout is found in a directory,
+there should be at least one directory or file with the same name in any of the
+corresponding lower layers. If not exist, the whiteout will be treated as orphan
+whiteout and remove.
+
+Redirect directories
+--------------------
+
+An redirect directory is a directory with "trusted.overlay.redirect" xattr
+valued to the path of the original location from the root of the overlay. It
+is only used when renaming a directory and "redirect dir" feature is enabled.
+If an redirect directory is found, the following must be met:
+
+1) The directory path pointed by redirect xattr should exist in one of lower
+   layers.
+2) The origin directory should be redirected only once in one layer, which means
+   there is only one redirect xattr point to this origin directory in the
+   specified layer.
+3) A whiteout or an opaque directory with the same name to origin should exist
+   in the same directory as the redirect directory.
+
+If not, 1) The redirect xattr is invalid and need to remove 2) One of the
+redirect xattr is redundant but not sure which one is, ask user or warn in
+auto mode 3) Create a whiteout device or set opaque xattr to an existing
+directory if the parent directory was meregd or remove xattr if not.
+
+Usage
+=====
+
+1. Ensure overlay filesystem is not mounted based on directories which need to
+   check.
+
+2. Run fsck.overlay program:
+   Usage:
+   fsck.overlay [-l lowerdir] [-u upperdir] [-w workdir] [-avhV]
+
+   Options:
+   -l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,
+                             multiple lower use ':' as separator.
+   -u, --upperdir=UPPERDIR   specify upper directory of overlayfs
+   -w, --workdir=WORKDIR     specify work directory of overlayfs
+   -a, --auto                repair automatically (no questions)
+   -v, --verbose             print more messages of overlayfs
+   -h, --help                display this usage of overlayfs
+   -V, --version             display version information
+
+3. Exit value:
+   0      No errors
+   1      Filesystem errors corrected
+   2      System should be rebooted
+   4      Filesystem errors left uncorrected
+   8      Operational error
+   16     Usage or syntax error
+   32     Checking canceled by user request
+   128    Shared-library error
+
+Todo
+====
+
+1. Overlay filesystem mounted check. Prevent fscking when overlay is
+   online. Now, We cannot distinguish mounted directories if overlayfs was
+   mounted with relative path. Should modify kernel together to support.
+2. Check and fix invalid redirect xattr through origin xattr.
+3. Symbolic link check.
+4. Check origin/impure/nlink xattr.
+5. Check index feature consistency.
+6. ...
diff --git a/check.c b/check.c
new file mode 100644
index 0000000..efa180f
--- /dev/null
+++ b/check.c
@@ -0,0 +1,489 @@
+/*
+ * check.c - Check and fix inconsistency for all underlying layers of overlay
+ *
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <sys/xattr.h>
+#include <sys/stat.h>
+#include <linux/limits.h>
+
+#include "common.h"
+#include "lib.h"
+#include "check.h"
+
+/* Underlying information */
+struct ovl_lower_check {
+	unsigned int type;	/* check extent type */
+
+	bool exist;
+	char path[PATH_MAX];	/* exist pathname found, only valid if exist */
+	struct stat st;		/* only valid if exist */
+};
+
+/* Redirect information */
+struct ovl_redirect_entry {
+	struct ovl_redirect_entry *next;
+
+	char *origin;		/* origin directory path */
+
+	char *path;		/* redirect directory path */
+	int dirtype;		/* redirect directory layer type: OVL_UPPER or OVL_LOWER */
+	int dirnum;		/* redirect directory layer num (only valid in OVL_LOWER) */
+};
+
+/* Whiteout */
+#define WHITEOUT_DEV	0
+#define WHITEOUT_MOD	0
+
+extern char **lowerdir;
+extern char upperdir[];
+extern char workdir[];
+extern int lower_num;
+extern int flags;
+extern int status;
+
+static inline mode_t file_type(const struct stat *status)
+{
+	return status->st_mode & S_IFMT;
+}
+
+static inline bool is_whiteout(const struct stat *status)
+{
+	return (file_type(status) == S_IFCHR) && (status->st_rdev == WHITEOUT_DEV);
+}
+
+static inline bool is_dir(const struct stat *status)
+{
+	return file_type(status) == S_IFDIR;
+}
+
+static bool is_dir_xattr(const char *pathname, const char *xattrname)
+{
+	char val;
+	ssize_t ret;
+
+	ret = getxattr(pathname, xattrname, &val, 1);
+	if ((ret < 0) && !(errno == ENODATA || errno == ENOTSUP)) {
+		print_err(_("Cannot getxattr %s %s: %s\n"), pathname,
+			    xattrname, strerror(errno));
+		return false;
+	}
+
+	return (ret == 1 && val == 'y') ? true : false;
+}
+
+static inline bool ovl_is_opaque(const char *pathname)
+{
+	return is_dir_xattr(pathname, OVL_OPAQUE_XATTR);
+}
+
+static inline int ovl_remove_opaque(const char *pathname)
+{
+	return remove_xattr(pathname, OVL_OPAQUE_XATTR);
+}
+
+static inline int ovl_set_opaque(const char *pathname)
+{
+	return set_xattr(pathname, OVL_OPAQUE_XATTR, "y", 1);
+}
+
+static int ovl_get_redirect(const char *pathname, size_t dirlen,
+			    size_t filelen, char **redirect)
+{
+	char *buf = NULL;
+	ssize_t ret;
+
+	ret = get_xattr(pathname, OVL_REDIRECT_XATTR, &buf, NULL);
+	if (ret <= 0 || !buf)
+		return ret;
+
+	if (buf[0] != '/') {
+		size_t baselen = strlen(pathname)-filelen-dirlen;
+
+		buf = srealloc(buf, ret + baselen + 1);
+		memmove(buf + baselen, buf, ret);
+		memcpy(buf, pathname+dirlen, baselen);
+		ret += baselen;
+	}
+
+	ret -= 1;
+	memmove(buf, buf+1, ret);
+	buf[ret] = '\0';
+
+	*redirect = buf;
+	return 0;
+}
+
+static inline int ovl_remove_redirect(const char *pathname)
+{
+	return remove_xattr(pathname, OVL_REDIRECT_XATTR);
+}
+
+static inline int ovl_create_whiteout(const char *pathname)
+{
+	int ret;
+
+	ret = mknod(pathname, S_IFCHR | WHITEOUT_MOD, makedev(0, 0));
+	if (ret)
+		print_err(_("Cannot mknod %s:%s\n"),
+			    pathname, strerror(errno));
+	return ret;
+}
+
+static inline int ovl_ask_invalid(const char *question, const char *pathname,
+				  int action)
+{
+	print_info(_("%s: %s "), question, pathname);
+
+	return ask_question("Remove", action);
+}
+
+/*
+ * Scan each lower dir lower than 'start' and check type matching,
+ * we stop scan if we found something.
+ *
+ * skip: skip whiteout.
+ *
+ */
+static int ovl_check_lower(const char *pathname, int start,
+			   struct ovl_lower_check *chk, bool skip)
+{
+	struct stat st;
+	int i;
+
+	for (i = start; i < lower_num; i++) {
+		path_pack(chk->path, sizeof(chk->path), lowerdir[i], pathname);
+
+		if (lstat(chk->path, &st) != 0) {
+			if (errno != ENOENT && errno != ENOTDIR) {
+				print_err(_("Cannot stat %s: %s\n"),
+					    chk->path, strerror(errno));
+				return -1;
+			}
+			continue;
+		}
+		if (skip && is_whiteout(&st))
+			continue;
+
+		chk->exist = true;
+		chk->st = st;
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Scan each underlying dirs under specified dir if a whiteout is
+ * found, check it's orphan or not. In auto-mode, orphan whiteouts
+ * will be removed directly.
+ */
+static int ovl_check_whiteout(struct scan_ctx *sctx)
+{
+	const char *pathname = sctx->pathname;
+	const struct stat *st = sctx->st;
+	struct ovl_lower_check chk = {0};
+	int start;
+	int ret = 0;
+
+	/* Is a whiteout ? */
+	if (!is_whiteout(st))
+		return 0;
+
+	sctx->t_whiteouts++;
+
+	/* Is Whiteout in the bottom lower dir ? */
+	if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1)
+		goto remove;
+
+	/*
+	 * Scan each corresponding lower directroy under this layer,
+	 * check is there a file or dir with the same name.
+	 */
+	start = (sctx->dirtype == OVL_LOWER) ? sctx->num + 1 : 0;
+	ret = ovl_check_lower(path_pick(pathname, sctx->dirlen),
+			      start, &chk, true);
+	if (ret)
+		return ret;
+	if (chk.exist && !is_whiteout(&chk.st))
+		goto out;
+
+remove:
+	sctx->i_whiteouts++;
+
+	/* Remove orphan whiteout directly or ask user */
+	if (!ovl_ask_invalid("Orphan whiteout", pathname, 1))
+		return 0;
+
+	ret = unlink(pathname);
+	if (ret) {
+		print_err(_("Cannot unlink %s: %s\n"), pathname,
+			    strerror(errno));
+		return ret;
+	}
+	sctx->i_whiteouts--;
+out:
+	return ret;
+}
+
+static struct ovl_redirect_entry *redirect_list = NULL;
+
+static void ovl_redirect_entry_add(const char *path, int dirtype,
+				   int dirnum, const char *origin)
+{
+	struct ovl_redirect_entry *last, *new;
+
+	new = smalloc(sizeof(*new));
+
+	print_debug(_("Redirect entry add: [%s %s %s %d]\n"),
+		      origin, path, (dirtype == OVL_UPPER) ? "UP" : "LOW",
+		      (dirtype == OVL_UPPER) ? 0 : dirnum);
+
+	if (!redirect_list) {
+		redirect_list = new;
+	} else {
+		for (last = redirect_list; last->next; last = last->next);
+		last->next = new;
+	}
+
+	new->dirtype = dirtype;
+	new->dirnum = dirnum;
+	new->origin = sstrdup(origin);
+	new->path = sstrdup(path);
+	new->next = NULL;
+}
+
+static bool ovl_redirect_entry_find(const char *origin, int dirtype,
+				    int dirnum, char **founded)
+{
+	struct ovl_redirect_entry *entry;
+
+	if (!redirect_list)
+		return false;
+
+	for (entry = redirect_list; entry; entry = entry->next) {
+		bool same_layer;
+
+		print_debug(_("Redirect entry found:[%s %s %s %d]\n"),
+			      entry->origin, entry->path,
+			      (entry->dirtype == OVL_UPPER) ? "UP" : "LOW",
+			      (entry->dirtype == OVL_UPPER) ? 0 : entry->dirnum);
+
+		same_layer = ((entry->dirtype == dirtype) &&
+			      (dirtype == OVL_LOWER ? (entry->dirnum == dirnum) : true));
+
+		if (same_layer && !strcmp(entry->origin, origin)) {
+			*founded = entry->path;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static void ovl_redirect_free(void)
+{
+	struct ovl_redirect_entry *entry;
+
+	while (redirect_list) {
+		entry = redirect_list;
+		redirect_list = redirect_list->next;
+		free(entry->origin);
+		free(entry->path);
+		free(entry);
+	}
+}
+
+/*
+ * Get redirect origin directory stored in the xattr, check it's invlaid
+ * or not, In auto-mode, invalid redirect xattr will be removed directly.
+ * Do the follow checking:
+ * 1) Check the origin directory exist or not. If not, remove xattr.
+ * 2) Count how many directories the origin directory was redirected by.
+ *    If more than one in the same layer, there must be some inconsistency
+ *    but not sure which one is invalid, ask user or warn in auto mode.
+ * 3) Check and fix the missing whiteout or opaque in redierct parent dir.
+ */
+static int ovl_check_redirect(struct scan_ctx *sctx)
+{
+	const char *pathname = sctx->pathname;
+	struct ovl_lower_check chk = {0};
+	char redirect_rpath[PATH_MAX];
+	struct stat rst;
+	char *redirect = NULL;
+	int start;
+	int ret = 0;
+
+	/* Get redirect */
+	ret = ovl_get_redirect(pathname, sctx->dirlen,
+			       sctx->filelen, &redirect);
+	if (ret || !redirect)
+		return ret;
+
+	print_debug(_("Dir %s has redirect %s\n"), pathname, redirect);
+	sctx->t_redirects++;
+
+	/* Redirect dir in last lower dir ? */
+	if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1)
+		goto remove;
+
+	/* Scan lower directories to check redirect dir exist or not */
+	start = (sctx->dirtype == OVL_LOWER) ? sctx->num + 1 : 0;
+	ret = ovl_check_lower(redirect, start, &chk, false);
+	if (ret)
+		goto out;
+	if (chk.exist && is_dir(&chk.st)) {
+		char *tmp;
+
+		/* Check duplicate in same layer */
+		if (ovl_redirect_entry_find(chk.path, sctx->dirtype,
+					    sctx->num, &tmp)) {
+			print_info("Duplicate redirect directories found:\n");
+			print_info("origin:%s current:%s last:%s\n",
+				   chk.path, pathname, tmp);
+
+			sctx->i_redirects++;
+
+			/* Don't remove in auto mode */
+			if (ovl_ask_invalid("Duplicate redirect xattr", pathname, 0))
+				goto remove_d;
+		}
+
+		ovl_redirect_entry_add(pathname, sctx->dirtype,
+				       sctx->num, chk.path);
+
+		/* Check and fix whiteout or opaque dir */
+		path_pack(redirect_rpath, sizeof(redirect_rpath),
+			  sctx->dirname, redirect);
+		if (lstat(redirect_rpath, &rst) != 0) {
+			if (errno != ENOENT && errno != ENOTDIR) {
+				print_err(_("Cannot stat %s: %s\n"),
+					    redirect_rpath, strerror(errno));
+				goto out;
+			}
+
+			/* Found nothing, create a whiteout */
+			if ((ret = ovl_create_whiteout(redirect_rpath)))
+				goto out;
+
+			sctx->t_whiteouts++;
+
+		} else if (is_dir(&rst) && !ovl_is_opaque(redirect_rpath)) {
+			/* Found a directory but not opaqued, fix opaque xattr */
+			if ((ret = ovl_set_opaque(redirect_rpath)))
+				goto out;
+		}
+
+		goto out;
+	}
+
+remove:
+	sctx->i_redirects++;
+
+	/* Remove redirect xattr or ask user */
+	if (!ovl_ask_invalid("Invalid redirect xattr", pathname, 1))
+		goto out;
+remove_d:
+	ret = ovl_remove_redirect(pathname);
+	if (!ret)
+		sctx->i_redirects--;
+out:
+	free(redirect);
+	return ret;
+}
+
+static struct scan_operations ovl_scan_ops = {
+	.whiteout = ovl_check_whiteout,
+	.redirect = ovl_check_redirect,
+};
+
+static void ovl_scan_report(struct scan_ctx *sctx)
+{
+	if (flags & FL_VERBOSE) {
+		print_info(_("Scan %d directories, %d files, "
+			     "%d/%d whiteouts, %d/%d redirect dirs\n"),
+			     sctx->directories, sctx->files,
+			     sctx->i_whiteouts, sctx->t_whiteouts,
+			     sctx->i_redirects, sctx->t_redirects);
+	}
+
+	if (sctx->i_whiteouts)
+		print_info(_("Invalid whiteouts %d left!\n"), sctx->i_whiteouts);
+	else if (sctx->i_redirects)
+		print_info(_("Invalid redirect directories %d left!\n"), sctx->i_redirects);
+	else
+		return;
+
+	set_st_inconsistency(&status);
+}
+
+static void ovl_scan_clean(void)
+{
+	/* Clean redirect entry record */
+	ovl_redirect_free();
+}
+
+/* Scan upperdir and each lowerdirs, check and fix inconsistency */
+int ovl_scan_fix(void)
+{
+	struct scan_ctx sctx = {0};
+	int i;
+	int ret = 0;
+
+	if (flags & FL_VERBOSE)
+		print_info(_("Scan and fix: [whiteouts|redirect dir]\n"));
+
+	/* Scan every lower directories */
+	for (i = lower_num - 1; i >= 0; i--) {
+		if (flags & FL_VERBOSE)
+			print_info(_("Scan lower directory %d: %s\n"), i, lowerdir[i]);
+
+		sctx.dirname = lowerdir[i];
+		sctx.dirlen = strlen(lowerdir[i]);
+		sctx.dirtype = OVL_LOWER;
+		sctx.num = i;
+
+		ret = scan_dir(&sctx, &ovl_scan_ops);
+		if (ret)
+			goto out;
+	}
+
+	/* Scan upper directory */
+	if (flags & FL_UPPER) {
+		if (flags & FL_VERBOSE)
+			print_info(_("Scan upper directory: %s\n"), upperdir);
+
+		sctx.dirname = upperdir;
+		sctx.dirlen = strlen(upperdir);
+		sctx.dirtype = OVL_UPPER;
+
+		ret = scan_dir(&sctx, &ovl_scan_ops);
+		if (ret)
+			goto out;
+	}
+out:
+	ovl_scan_report(&sctx);
+	ovl_scan_clean();
+	return ret;
+}
diff --git a/check.h b/check.h
new file mode 100644
index 0000000..6af8c2d
--- /dev/null
+++ b/check.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef OVL_WHITECHECK_H
+#define OVL_WHITECHECK_H
+
+/* Scan upperdir and each lowerdirs, check and fix inconsistency */
+int ovl_scan_fix(void);
+
+#endif /* OVL_WHITECHECK_H */
diff --git a/common.c b/common.c
new file mode 100644
index 0000000..5ca7deb
--- /dev/null
+++ b/common.c
@@ -0,0 +1,119 @@
+/*
+ * common.c - Common things for all utilities
+ *
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdarg.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include "common.h"
+#include "config.h"
+
+extern char *program_name;
+
+/* #define DEBUG 1 */
+#ifdef DEBUG
+void print_debug(char *fmtstr, ...)
+{
+	va_list args;
+
+	va_start(args, fmtstr);
+	fprintf(stdout, "%s:[Debug]: ", program_name);
+	vfprintf(stdout, fmtstr, args);
+	va_end(args);
+}
+#else
+void print_debug (char *fmtstr, ...) {}
+#endif
+
+void print_info(char *fmtstr, ...)
+{
+	va_list args;
+
+	va_start(args, fmtstr);
+	vfprintf(stdout, fmtstr, args);
+	va_end(args);
+}
+
+void print_err(char *fmtstr, ...)
+{
+	va_list args;
+
+	va_start(args, fmtstr);
+	fprintf(stderr, "%s:[Error]: ", program_name);
+	vfprintf(stderr, fmtstr, args);
+	va_end(args);
+}
+
+void *smalloc(size_t size)
+{
+	void *new = malloc(size);
+
+	if (!new) {
+		print_err(_("malloc error:%s\n"), strerror(errno));
+		exit(1);
+	}
+
+	memset(new, 0, size);
+	return new;
+}
+
+void *srealloc(void *addr, size_t size)
+{
+	void *re = realloc(addr, size);
+
+	if (!re) {
+		print_err(_("malloc error:%s\n"), strerror(errno));
+		exit(1);
+	}
+	return re;
+}
+
+char *sstrdup(const char *src)
+{
+	char *dst = strdup(src);
+
+	if (!dst) {
+		print_err(_("strdup error:%s\n"), strerror(errno));
+		exit(1);
+	}
+
+	return dst;
+}
+
+char *sstrndup(const char *src, size_t num)
+{
+	char *dst = strndup(src, num);
+
+	if (!dst) {
+		print_err(_("strndup error:%s\n"), strerror(errno));
+		exit(1);
+	}
+
+	return dst;
+}
+
+void version(void)
+{
+	printf(_("Overlay utilities version %s\n"), PACKAGE_VERSION);
+}
diff --git a/common.h b/common.h
new file mode 100644
index 0000000..7147e05
--- /dev/null
+++ b/common.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef OVL_COMMON_H
+#define OVL_COMMON_H
+
+#ifndef __attribute__
+# if !defined __GNUC__ || __GNUC__ < 2 || (__GNUC__ == 2 && __GNUC_MINOR__ < 8) || __STRICT_ANSI__
+#  define __attribute__(x)
+# endif
+#endif
+
+#ifdef USE_GETTEXT
+#include <libintl.h>
+#define _(x)	gettext((x))
+#else
+#define _(x) 	(x)
+#endif
+
+/* Print an error message */
+void print_err(char *, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
+
+/* Print an info message */
+void print_info(char *, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
+
+/* Print an debug message */
+void print_debug(char *, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
+
+/* Safety wrapper */
+void *smalloc(size_t size);
+void *srealloc(void *addr, size_t size);
+char *sstrdup(const char *src);
+char *sstrndup(const char *src, size_t num);
+
+/* Print program version */
+void version(void);
+
+#endif /* OVL_COMMON_H */
diff --git a/config.h b/config.h
new file mode 100644
index 0000000..fa7eafa
--- /dev/null
+++ b/config.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef OVL_CONFIG_H
+#define OVL_CONFIG_H
+
+/* program version */
+#define PACKAGE_VERSION	"v1.0.0"
+
+/* overlay max lower stacks (the same to kernel overlayfs driver) */
+#define OVL_MAX_STACK 500
+
+/* File with mounted filesystems */
+#define MOUNT_TAB "/proc/mounts"
+
+/* Name of overlay filesystem type */
+#define OVERLAY_NAME "overlay"
+#define OVERLAY_NAME_OLD "overlayfs"
+
+/* Mount options */
+#define OPT_LOWERDIR "lowerdir="
+#define OPT_UPPERDIR "upperdir="
+#define OPT_WORKDIR "workdir="
+
+#endif
diff --git a/fsck.c b/fsck.c
new file mode 100644
index 0000000..d4e861a
--- /dev/null
+++ b/fsck.c
@@ -0,0 +1,201 @@
+/*
+ * fsck.c - Utility to fsck overlay
+ *
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <getopt.h>
+#include <libgen.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <linux/limits.h>
+
+#include "common.h"
+#include "config.h"
+#include "lib.h"
+#include "check.h"
+#include "mount.h"
+
+char *program_name;
+
+char **lowerdir = NULL;
+char upperdir[PATH_MAX] = {0};
+char workdir[PATH_MAX] = {0};
+int lower_num = 0;
+int flags = 0;		/* user input option flags */
+int status = 0;		/* fsck scan status */
+
+/* Cleanup lower directories buf */
+static void ovl_clean_lowerdirs(void)
+{
+	int i;
+
+	for (i = 0; i < lower_num; i++) {
+		free(lowerdir[i]);
+		lowerdir[i] = NULL;
+	}
+	free(lowerdir);
+	lowerdir = NULL;
+	lower_num = 0;
+}
+
+static void usage(void)
+{
+	print_info(_("Usage:\n\t%s [-l lowerdir] [-u upperdir] [-w workdir] "
+		    "[-avhV]\n\n"), program_name);
+	print_info(_("Options:\n"
+		    "-l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,\n"
+		    "                          multiple lower use ':' as separator\n"
+		    "-u, --upperdir=UPPERDIR   specify upper directory of overlayfs\n"
+		    "-w, --workdir=WORKDIR     specify work directory of overlayfs\n"
+		    "-a, --auto                repair automatically (no questions)\n"
+		    "-v, --verbose             print more messages of overlayfs\n"
+		    "-h, --help                display this usage of overlayfs\n"
+		    "-V, --version             display version information\n"));
+	exit(1);
+}
+
+static void parse_options(int argc, char *argv[])
+{
+	char *lowertemp;
+	int c;
+	int ret = 0;
+	bool show_usage = false;
+
+	struct option long_options[] = {
+		{"lowerdir", required_argument, NULL, 'l'},
+		{"upperdir", required_argument, NULL, 'u'},
+		{"workdir", required_argument, NULL, 'w'},
+		{"auto", no_argument, NULL, 'a'},
+		{"verbose", no_argument, NULL, 'v'},
+		{"version", no_argument, NULL, 'V'},
+		{"help", no_argument, NULL, 'h'},
+		{NULL, 0, NULL, 0}
+	};
+
+	while ((c = getopt_long(argc, argv, "l:u:w:avVh", long_options, NULL)) != -1) {
+		switch (c) {
+		case 'l':
+			lowertemp = strdup(optarg);
+			ret = ovl_resolve_lowerdirs(lowertemp, &lowerdir, &lower_num);
+			free(lowertemp);
+			break;
+		case 'u':
+			if (realpath(optarg, upperdir)) {
+				print_debug(_("Upperdir:%s\n"), upperdir);
+				flags |= FL_UPPER;
+			} else {
+				print_err(_("Failed to resolve upperdir:%s\n"), optarg);
+				ret = -1;
+			}
+			break;
+		case 'w':
+			if (realpath(optarg, workdir)) {
+				print_debug(_("Workdir:%s\n"), workdir);
+				flags |= FL_WORK;
+			} else {
+				print_err(_("Failed to resolve workdir:%s\n"), optarg);
+				ret = -1;
+			}
+			break;
+		case 'a':
+			flags |= FL_AUTO;
+			break;
+		case 'v':
+			flags |= FL_VERBOSE;
+			break;
+		case 'V':
+			version();
+			return;
+		case 'h':
+		default:
+			usage();
+			return;
+		}
+
+		if (ret)
+			goto err_out;
+	}
+
+	if (!lower_num || (!(flags & FL_UPPER) && lower_num == 1)) {
+		print_info(_("Please specify correct lowerdirs and upperdir!\n\n"));
+		show_usage = true;
+		goto err_out;
+	}
+
+	return;
+
+err_out:
+	if (show_usage)
+		usage();
+	exit(1);
+}
+
+void fsck_status_check(int *val)
+{
+	if (status & OVL_ST_INCONSISTNECY) {
+		*val |= FSCK_UNCORRECTED;
+		print_info(_("Still have unexpected inconsistency!\n"));
+	}
+
+	if (status & OVL_ST_ABORT) {
+		*val |= FSCK_ERROR;
+		print_info(_("Cannot continue, aborting\n"));
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	bool mounted = false;
+	int err = 0;
+	int exit_value = 0;
+
+	program_name = basename(argv[0]);
+
+	parse_options(argc, argv);
+
+	/* Ensure overlay filesystem not mounted */
+	if ((err = ovl_check_mount(&mounted)))
+		goto out;
+	if (mounted) {
+		set_st_abort(&status);
+		goto out;
+	}
+
+	/* Scan and fix */
+	if ((err = ovl_scan_fix()))
+		goto out;
+
+out:
+	fsck_status_check(&exit_value);
+	ovl_clean_lowerdirs();
+
+	if (err)
+		exit_value |= FSCK_ERROR;
+	if (exit_value)
+		print_info("WARNING: Filesystem check failed, may not clean\n");
+	else
+		print_info("Filesystem clean\n");
+
+	return exit_value;
+}
diff --git a/lib.c b/lib.c
new file mode 100644
index 0000000..271cafd
--- /dev/null
+++ b/lib.c
@@ -0,0 +1,237 @@
+/*
+ * lib.c - Common things for all utilities
+ *
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <errno.h>
+#include <string.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/xattr.h>
+#include <fts.h>
+
+#include "common.h"
+#include "lib.h"
+
+extern int flags;
+extern int status;
+
+static int ask_yn(const char *question, int def)
+{
+	char ans[16];
+
+	print_info(_("%s ? [%s]: \n"), question, def ? _("y") : _("n"));
+	fflush(stdout);
+	while (fgets(ans, sizeof(ans)-1, stdin)) {
+		if (ans[0] == '\n')
+			return def;
+		else if (!strcasecmp(ans, "y\n") || !strcasecmp(ans, "yes\n"))
+			return 1;
+		else if (!strcasecmp(ans, "n\n") || !strcasecmp(ans, "no\n"))
+			return 0;
+		else
+			print_info(_("Illegal answer. Please input y/n or yes/no:"));
+		fflush(stdout);
+	}
+	return def;
+}
+
+/* Ask user */
+int ask_question(const char *question, int def)
+{
+	if (flags & FL_AUTO) {
+		print_info(_("%s? %s\n"), question, def ? _("y") : _("n"));
+		return def;
+	}
+
+	return ask_yn(question, def);
+}
+
+ssize_t get_xattr(const char *pathname, const char *xattrname,
+		  char **value, bool *exist)
+{
+	char *buf = NULL;
+	ssize_t ret;
+
+	ret = getxattr(pathname, xattrname, NULL, 0);
+	if (ret < 0) {
+		if (errno == ENODATA || errno == ENOTSUP) {
+			if (exist)
+				*exist = false;
+			return 0;
+		} else {
+			goto fail;
+		}
+	}
+
+	/* Zero size value means xattr exist but value unknown */
+	if (exist)
+		*exist = true;
+	if (ret == 0 || !value)
+		return 0;
+
+	buf = smalloc(ret+1);
+	ret = getxattr(pathname, xattrname, buf, ret);
+	if (ret <= 0)
+		goto fail2;
+
+	buf[ret] = '\0';
+	*value = buf;
+	return ret;
+
+fail2:
+	free(buf);
+fail:
+	print_err(_("Cannot getxattr %s %s: %s\n"), pathname,
+		    xattrname, strerror(errno));
+	return -1;
+}
+
+int set_xattr(const char *pathname, const char *xattrname,
+		void *value, size_t size)
+{
+	int ret;
+
+	ret = setxattr(pathname, xattrname, value, size, XATTR_CREATE);
+	if (ret && errno != EEXIST)
+		goto fail;
+
+	if (errno == EEXIST) {
+		ret = setxattr(pathname, xattrname, value, size, XATTR_REPLACE);
+		if (ret)
+			goto fail;
+	}
+
+	return 0;
+fail:
+	print_err(_("Cannot setxattr %s %s: %s\n"), pathname,
+		    xattrname, strerror(errno));
+	return ret;
+}
+
+int remove_xattr(const char *pathname, const char *xattrname)
+{
+	int ret;
+	if ((ret = removexattr(pathname, xattrname)))
+		print_err(_("Cannot removexattr %s %s: %s\n"), pathname,
+			    xattrname, strerror(errno));
+	return ret;
+}
+
+char *path_pack(char *out, int len, const char *base, const char *append)
+{
+	int baselen = strlen(base);
+
+	if (!out) {
+		len = strlen(base) + strlen(append) + 2;
+		out = smalloc(len);
+	}
+
+	if (base[baselen-1] == '/' && append[0] == '/')
+		snprintf(out, len, "%s%s", base, append+1);
+	else if (base[baselen-1] != '/' && append[0] != '/')
+		snprintf(out, len, "%s/%s", base, append);
+	else
+		snprintf(out, len, "%s%s", base, append);
+
+	return out;
+}
+
+const char *path_pick(const char *path, int baselen)
+{
+	const char *p = path + baselen;
+
+	return (*p == '/') ? p+1 : p;
+}
+
+static inline int __check_entry(struct scan_ctx *sctx,
+				  int (*do_check)(struct scan_ctx *))
+{
+	return do_check ? do_check(sctx) : 0;
+}
+
+/* Scan specified directories and invoke callback */
+int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
+{
+	char *paths[2] = {(char *)sctx->dirname, NULL};
+	FTS *ftsp;
+	FTSENT *ftsent;
+	int ret = 0;
+
+	ftsp = fts_open(paths, FTS_NOCHDIR | FTS_PHYSICAL, NULL);
+	if (ftsp == NULL) {
+		print_err(_("Failed to fts open %s:%s\n"),
+			    sctx->dirname, strerror(errno));
+		return -1;
+	}
+
+	while ((ftsent = fts_read(ftsp)) != NULL) {
+		int err;
+
+		print_debug(_("Scan:%-3s %2d %7jd   %-40s %s\n"),
+			(ftsent->fts_info == FTS_D) ? "d" :
+			(ftsent->fts_info == FTS_DNR) ? "dnr" :
+			(ftsent->fts_info == FTS_DP) ? "dp" :
+			(ftsent->fts_info == FTS_F) ? "f" :
+			(ftsent->fts_info == FTS_NS) ? "ns" :
+			(ftsent->fts_info == FTS_SL) ? "sl" :
+			(ftsent->fts_info == FTS_SLNONE) ? "sln" :
+			(ftsent->fts_info == FTS_DEFAULT) ? "df" : "???",
+			ftsent->fts_level, ftsent->fts_statp->st_size,
+			ftsent->fts_path, ftsent->fts_name);
+
+		/* Fillup base context */
+		sctx->pathname = ftsent->fts_path;
+		sctx->pathlen = ftsent->fts_pathlen;
+		sctx->filename = ftsent->fts_name;
+		sctx->filelen = ftsent->fts_namelen;
+		sctx->st = ftsent->fts_statp;
+
+		switch (ftsent->fts_info) {
+		case FTS_F:
+			sctx->files++;
+			break;
+		case FTS_DEFAULT:
+			/* Check whiteouts */
+			err = __check_entry(sctx, sop->whiteout);
+			ret = (err) ? err : ret;
+			break;
+		case FTS_D:
+			/* Check redirect xattr */
+			sctx->directories++;
+			err = __check_entry(sctx, sop->redirect);
+			ret = (err) ? err : ret;
+			break;
+		case FTS_NS:
+		case FTS_DNR:
+		case FTS_ERR:
+			print_err(_("Failed to fts read %s:%s\n"),
+				    ftsent->fts_path, strerror(ftsent->fts_errno));
+			ret = -1;
+			goto out;
+		}
+	}
+out:
+	fts_close(ftsp);
+	return ret;
+}
diff --git a/lib.h b/lib.h
new file mode 100644
index 0000000..235719c
--- /dev/null
+++ b/lib.h
@@ -0,0 +1,101 @@
+/*
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef OVL_LIB_H
+#define OVL_LIB_H
+
+/* Common return value */
+#define FSCK_OK          0	/* No errors */
+#define FSCK_NONDESTRUCT 1	/* File system errors corrected */
+#define FSCK_REBOOT      2	/* System should be rebooted */
+#define FSCK_UNCORRECTED 4	/* File system errors left uncorrected */
+#define FSCK_ERROR       8	/* Operational error */
+#define FSCK_USAGE       16	/* Usage or syntax error */
+#define FSCK_CANCELED	 32	/* Aborted with a signal or ^C */
+#define FSCK_LIBRARY     128	/* Shared library error */
+
+/* Fsck status */
+#define OVL_ST_INCONSISTNECY	(1 << 0)
+#define OVL_ST_ABORT		(1 << 1)
+
+/* Option flags */
+#define FL_VERBOSE	(1 << 0)	/* verbose */
+#define FL_UPPER	(1 << 1)	/* specify upper directory */
+#define FL_WORK		(1 << 2)	/* specify work directory */
+#define FL_AUTO		(1 << 3)	/* automactically scan dirs and repair */
+
+/* Scan path type */
+#define OVL_UPPER	0
+#define OVL_LOWER	1
+#define OVL_WORKER	2
+#define OVL_PTYPE_MAX	3
+
+/* Xattr */
+#define OVL_OPAQUE_XATTR	"trusted.overlay.opaque"
+#define OVL_REDIRECT_XATTR	"trusted.overlay.redirect"
+
+
+/* Directories scan data struct */
+struct scan_ctx {
+	const char *dirname;	/* upper/lower root dir */
+	size_t dirlen;		/* strlen(dirlen) */
+	int dirtype;		/* OVL_UPPER or OVL_LOWER */
+	int num;		/* lower dir depth, lower type use only */
+
+	const char *pathname;	/* file path from the root */
+	size_t pathlen;		/* strlen(pathname) */
+	const char *filename;	/* filename */
+	size_t filelen;		/* strlen(filename) */
+	struct stat *st;	/* file stat */
+
+	int files;
+	int directories;
+	int t_whiteouts;	/* total whiteouts */
+	int i_whiteouts;	/* invalid whiteouts */
+	int t_redirects;	/* total redirect dirs */
+	int i_redirects;	/* invalid redirect dirs */
+};
+
+/* Directories scan callback operations struct */
+struct scan_operations {
+	int (*whiteout)(struct scan_ctx *);
+	int (*redirect)(struct scan_ctx *);
+};
+
+static inline void set_st_inconsistency(int *st)
+{
+	*st |= OVL_ST_INCONSISTNECY;
+}
+
+static inline void set_st_abort(int *st)
+{
+	*st |= OVL_ST_ABORT;
+}
+
+int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop);
+int ask_question(const char *question, int def);
+ssize_t get_xattr(const char *pathname, const char *xattrname,
+		  char **value, bool *exist);
+int set_xattr(const char *pathname, const char *xattrname,
+	      void *value, size_t size);
+int remove_xattr(const char *pathname, const char *xattrname);
+char *path_pack(char *out, int len, const char *base, const char *append);
+char *path_truncate(char *out, int len, const char *path, const char *filename);
+const char *path_pick(const char *path, int baselen);
+
+#endif /* OVL_LIB_H */
diff --git a/mount.c b/mount.c
new file mode 100644
index 0000000..fba51e9
--- /dev/null
+++ b/mount.c
@@ -0,0 +1,330 @@
+/*
+ * mount.c - Check mounted overlay
+ *
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <getopt.h>
+#include <libgen.h>
+#include <stdbool.h>
+#include <mntent.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <linux/limits.h>
+
+#include "common.h"
+#include "config.h"
+#include "lib.h"
+#include "check.h"
+#include "mount.h"
+
+struct ovl_mnt_entry {
+	char *lowers;
+	char **lowerdir;
+	int lowernum;
+	char upperdir[PATH_MAX];
+	char workdir[PATH_MAX];
+};
+
+/* Mount buf allocate a time */
+#define ALLOC_NUM	16
+
+extern char **lowerdir;
+extern char upperdir[];
+extern char workdir[];
+extern int lower_num;
+
+/*
+ * Split directories to individual one.
+ * (copied from linux kernel, see fs/overlayfs/super.c)
+ */
+static unsigned int ovl_split_lowerdirs(char *lower)
+{
+	unsigned int ctr = 1;
+	char *s, *d;
+
+	for (s = d = lower;; s++, d++) {
+		if (*s == '\\') {
+			s++;
+		} else if (*s == ':') {
+			*d = '\0';
+			ctr++;
+			continue;
+		}
+		*d = *s;
+		if (!*s)
+			break;
+	}
+	return ctr;
+}
+
+/* Resolve each lower directories and check the validity */
+int ovl_resolve_lowerdirs(char *loweropt, char ***lowerdir,
+			  int *lowernum)
+{
+	int num;
+	char **dirs;
+	char *p;
+	int i;
+
+	num = ovl_split_lowerdirs(loweropt);
+	if (num > OVL_MAX_STACK) {
+		print_err(_("Too many lower directories:%u, max:%u\n"),
+			    num, OVL_MAX_STACK);
+		return -1;
+	}
+
+	dirs = smalloc(sizeof(char *) * num);
+
+	p = loweropt;
+	for (i = 0; i < num; i++) {
+		dirs[i] = smalloc(PATH_MAX);
+		if (!realpath(p, dirs[i])) {
+			print_err(_("Failed to resolve lowerdir:%s:%s\n"),
+				    p, strerror(errno));
+			goto err;
+		}
+		print_debug(_("Lowerdir %u:%s\n"), i, dirs[i]);
+		p = strchr(p, '\0') + 1;
+	}
+
+	*lowerdir = dirs;
+	*lowernum = num;
+
+	return 0;
+err:
+	for (i--; i >= 0; i--)
+		free(dirs[i]);
+	free(dirs);
+	*lowernum = 0;
+	return -1;
+}
+
+/*
+ * Split and return next opt.
+ * (copied from linux kernel, see fs/overlayfs/super.c)
+ */
+static char *ovl_next_opt(char **s)
+{
+	char *sbegin = *s;
+	char *p;
+
+	if (sbegin == NULL)
+		return NULL;
+
+	for (p = sbegin; *p; p++) {
+		if (*p == '\\') {
+			p++;
+			if (!*p)
+				break;
+		} else if (*p == ',') {
+			*p = '\0';
+			*s = p + 1;
+			return sbegin;
+		}
+	}
+	*s = NULL;
+	return sbegin;
+}
+
+/*
+ * Split and parse opt to each directories.
+ *
+ * Note: FIXME: We cannot distinguish mounted directories if overlayfs was
+ * mounted use relative path, so there may have misjudgment.
+ */
+static int ovl_parse_opt(char *opt, struct ovl_mnt_entry *entry)
+{
+	char tmp[PATH_MAX] = {0};
+	char *p;
+	int len;
+	int ret;
+	int i;
+
+	while ((p = ovl_next_opt(&opt)) != NULL) {
+		if (!*p)
+			continue;
+
+		if (!strncmp(p, OPT_UPPERDIR, strlen(OPT_UPPERDIR))) {
+			len = strlen(p) - strlen(OPT_UPPERDIR) + 1;
+			strncpy(tmp, p+strlen(OPT_UPPERDIR), len);
+
+			if (!realpath(tmp, entry->upperdir)) {
+				print_err(_("Faile to resolve path:%s:%s\n"),
+					    tmp, strerror(errno));
+				ret = -1;
+				goto errout;
+			}
+		} else if (!strncmp(p, OPT_LOWERDIR, strlen(OPT_LOWERDIR))) {
+			len = strlen(p) - strlen(OPT_LOWERDIR) + 1;
+			entry->lowers = smalloc(len);
+			strncpy(entry->lowers, p+strlen(OPT_LOWERDIR), len);
+
+			if ((ret = ovl_resolve_lowerdirs(entry->lowers,
+					&entry->lowerdir, &entry->lowernum)))
+				goto errout;
+
+		} else if (!strncmp(p, OPT_WORKDIR, strlen(OPT_WORKDIR))) {
+			len = strlen(p) - strlen(OPT_WORKDIR) + 1;
+			strncpy(tmp, p+strlen(OPT_WORKDIR), len);
+
+			if (!realpath(tmp, entry->workdir)) {
+				print_err(_("Faile to resolve path:%s:%s\n"),
+					    tmp, strerror(errno));
+				ret = -1;
+				goto errout;
+			}
+		}
+	}
+
+errout:
+	if (entry->lowernum) {
+		for (i = 0; i < entry->lowernum; i++)
+			free(entry->lowerdir[i]);
+		free(entry->lowerdir);
+		entry->lowerdir = NULL;
+		entry->lowernum = 0;
+	}
+	free(entry->lowers);
+	entry->lowers = NULL;
+
+	return ret;
+}
+
+/* Scan current mounted overlayfs and get used underlying directories */
+static int ovl_scan_mount_init(struct ovl_mnt_entry **ovl_mnt_entries,
+			       int *ovl_mnt_count)
+{
+	struct ovl_mnt_entry *mnt_entries;
+	struct mntent *mnt;
+	FILE *fp;
+	char *opt;
+	int allocated, num = 0;
+
+	fp = setmntent(MOUNT_TAB, "r");
+	if (!fp) {
+		print_err(_("Fail to setmntent %s:%s\n"),
+			    MOUNT_TAB, strerror(errno));
+		return -1;
+	}
+
+	allocated = ALLOC_NUM;
+	mnt_entries = smalloc(sizeof(struct ovl_mnt_entry) * allocated);
+
+	while ((mnt = getmntent(fp))) {
+		if (!strcmp(mnt->mnt_type, OVERLAY_NAME) ||
+		    !strcmp(mnt->mnt_type, OVERLAY_NAME_OLD)) {
+
+			opt = sstrdup(mnt->mnt_opts);
+			if (ovl_parse_opt(opt, &mnt_entries[num])) {
+				free(opt);
+				continue;
+			}
+
+			num++;
+			if (num % ALLOC_NUM == 0) {
+				allocated += ALLOC_NUM;
+				mnt_entries = srealloc(mnt_entries,
+				     sizeof(struct ovl_mnt_entry) * allocated);
+			}
+
+			free(opt);
+		}
+	}
+
+	*ovl_mnt_entries = mnt_entries;
+	*ovl_mnt_count = num;
+
+	endmntent(fp);
+	return 0;
+}
+
+static void ovl_scan_mount_exit(struct ovl_mnt_entry *ovl_mnt_entries,
+				int ovl_mnt_count)
+{
+	int i,j;
+
+	for (i = 0; i < ovl_mnt_count; i++) {
+		for (j = 0; j < ovl_mnt_entries[i].lowernum; j++)
+			free(ovl_mnt_entries[i].lowerdir[j]);
+		free(ovl_mnt_entries[i].lowerdir);
+		free(ovl_mnt_entries[i].lowers);
+	}
+	free(ovl_mnt_entries);
+}
+
+/*
+ * Scan every mounted filesystem, check the overlay directories want
+ * to check is already mounted. Check and fix an online overlay is not
+ * allowed.
+ *
+ * Note: fsck may modify lower layers, so even match only one directory
+ *       is triggered as mounted.
+ */
+int ovl_check_mount(bool *mounted)
+{
+	struct ovl_mnt_entry *ovl_mnt_entries = NULL;
+	int ovl_mnt_entry_count = 0;
+	char *mounted_path = NULL;
+	int i,j,k;
+	int ret;
+
+	ret = ovl_scan_mount_init(&ovl_mnt_entries, &ovl_mnt_entry_count);
+	if (ret)
+		return ret;
+
+	/* Only check hard matching */
+	for (i = 0; i < ovl_mnt_entry_count; i++) {
+		/* Check lower */
+		for (j = 0; j < ovl_mnt_entries[i].lowernum; j++) {
+			for (k = 0; k < lower_num; k++) {
+				if (!strcmp(lowerdir[k],
+					    ovl_mnt_entries[i].lowerdir[j])) {
+					mounted_path = lowerdir[k];
+					*mounted = true;
+					goto out;
+				}
+			}
+		}
+
+		/* Check upper */
+		if (!(strcmp(upperdir, ovl_mnt_entries[i].upperdir))) {
+			mounted_path = upperdir;
+			*mounted = true;
+			goto out;
+		}
+
+		/* Check worker */
+		if (workdir[0] != '\0' && !(strcmp(workdir, ovl_mnt_entries[i].workdir))) {
+			mounted_path = workdir;
+			*mounted = true;
+			goto out;
+		}
+	}
+out:
+	ovl_scan_mount_exit(ovl_mnt_entries, ovl_mnt_entry_count);
+
+	if (*mounted)
+		print_info(_("WARNING: Dir %s is mounted\n"), mounted_path);
+
+	return 0;
+}
diff --git a/mount.h b/mount.h
new file mode 100644
index 0000000..7eed0d0
--- /dev/null
+++ b/mount.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (c) 2017 Huawei.  All Rights Reserved.
+ * Author: zhangyi (F) <yi.zhang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef OVL_MOUNT_H
+#define OVL_MOUNT_H
+
+int ovl_resolve_lowerdirs(char *loweropt, char ***lowerdir,
+                          int *lowernum);
+int ovl_check_mount(bool *mounted);
+
+#endif /* OVL_MOUNT_H */
-- 
2.9.5

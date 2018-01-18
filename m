From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v4 1/5] overlay: implement fsck utility
Date: Thu, 18 Jan 2018 11:50:52 +0800
Message-ID: <20180118035056.17358-2-yi.zhang@huawei.com>
References: <20180118035056.17358-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180118035056.17358-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com, yizhang089@gmail.com
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
2) The origin directory should be redirected only once, which means
   there is only one redirect xattr point to this origin directory in
   all layers.
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
   need to check.

2. Run fsck.overlay program:
   Usage:
   fsck.overlay [-o lowerdir=<lowers>,upperdir=<upper>,workdir=<work>] \
                [-pnyvhV]

   Options:
   -o,                       specify underlying directories of overlayfs
                             multiple lower dirs use ':' as separator
   -p,                       automatic repair (no questions)
   -n,                       make no changes to the filesystem
   -y,                       assume "yes" to all questions
   -v, --verbose             print more messages of overlayfs
   -h, --help                display this usage of overlayfs
   -V, --version             display version information

   Example:
   fsck.overlay -o lowerdir=lower,upperdir=upper,workdir=work

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
 Makefile  |  21 ++
 README.md |  87 ++++++++
 check.c   | 718 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 check.h   |  25 +++
 common.c  | 119 +++++++++++
 common.h  |  53 +++++
 config.h  |  40 ++++
 fsck.c    | 305 ++++++++++++++++++++++++++
 lib.c     | 249 ++++++++++++++++++++++
 lib.h     | 102 +++++++++
 list.h    | 114 ++++++++++
 mount.c   | 370 ++++++++++++++++++++++++++++++++
 mount.h   |  34 +++
 path.c    |  78 +++++++
 path.h    |  24 +++
 15 files changed, 2339 insertions(+)
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
 create mode 100644 list.h
 create mode 100644 mount.c
 create mode 100644 mount.h
 create mode 100644 path.c
 create mode 100644 path.h

diff --git a/Makefile b/Makefile
new file mode 100644
index 0000000..69591b8
--- /dev/null
+++ b/Makefile
@@ -0,0 +1,21 @@
+CFLAGS = -Wall -g
+LFLAGS = -lm
+CC = gcc
+
+all: overlay
+
+objects = fsck.o common.o lib.o check.o mount.o path.o
+
+overlay: $(objects)
+	$(CC) $(LFLAGS) $(objects) -o fsck.overlay
+
+.c.o:
+	$(CC) $(CFLAGS) -c $<
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
index 0000000..95dd790
--- /dev/null
+++ b/README.md
@@ -0,0 +1,87 @@
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
+2) The origin directory should be redirected only once, which means there is
+   only one redirect xattr point to this origin directory in all layers.
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
+   fsck.overlay [-o lowerdir=<lowers>,upperdir=<upper>,workdir=<work>] [-pnyvhV]
+
+   Options:
+   -o,                       specify underlying directories of overlayfs:
+                             multiple lower directories use ':' as separator
+   -p,                       automatic repair (no questions)
+   -n,                       make no changes to the filesystem
+   -y,                       assume "yes" to all questions
+   -v, --verbose             print more messages of overlayfs
+   -h, --help                display this usage of overlayfs
+   -V, --version             display version information
+
+   Example:
+   fsck.overlay -o lowerdir=lower,upperdir=upper,workdir=work
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
+Note:
+1. It is strongly recommend to run this program after modifing underlying
+   directories while overlay filesystem is offline.
+2. Enough file descriptors (more than the number of specified underlying
+   directories) are required to run this program.
+
+Todo
+====
+
+1. Overlay filesystem mounted check. Prevent fscking when overlay is
+   online. Now, We cannot distinguish mounted directories if overlayfs was
+   mounted with relative path. Should modify kernel together to support.
+2. Check and fix invalid redirect xattr through origin xattr.
+3. Check Symbolic link with absolute path in lower layer.
+4. Check validity of origin/impure/nlink xattr.
+5. Check consistency of index feature.
+6. ...
diff --git a/check.c b/check.c
new file mode 100644
index 0000000..e73307d
--- /dev/null
+++ b/check.c
@@ -0,0 +1,718 @@
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
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <libgen.h>
+#include <sys/types.h>
+#include <sys/xattr.h>
+#include <sys/stat.h>
+#include <linux/limits.h>
+
+#include "common.h"
+#include "lib.h"
+#include "check.h"
+#include "path.h"
+#include "list.h"
+
+/* Lookup context */
+struct ovl_lookup_ctx {
+	int dirfd;		/* base overlay dir descriptor */
+	const char *pathname;	/* relative path to lookup */
+	bool last;		/* in last lower layer ? */
+	bool skip;		/* skip self check */
+
+	char *redirect;		/* redirect path for next lookup */
+	bool stop;		/* stop lookup */
+
+	struct stat st;		/* target's stat(2) */
+	bool exist;		/* tatget exist or not */
+};
+
+/* Underlying target information */
+struct ovl_lookup_data {
+	bool exist;			/* tatget exist or not */
+	char pathname[PATH_MAX];	/* tatget's pathname found */
+	int stack;			/* which lower stack we found */
+	struct stat st;			/* target's stat(2) */
+};
+
+/* Redirect information */
+struct ovl_redirect_entry {
+	struct list_head list;
+	char *origin;		/* origin dir path */
+	int ostack;		/* origin dir stack */
+	char *pathname; 	/* redirect dir path */
+	int dirtype;		/* redirect dir type: OVL_UPPER or OVL_LOWER */
+	int stack;		/* redirect dir stack (valid in OVL_LOWER) */
+};
+
+/* Whiteout */
+#define WHITEOUT_DEV	0
+#define WHITEOUT_MOD	0
+
+extern char **lowerdir;
+extern char *upperdir;
+extern char *workdir;
+extern int *lowerfd;
+extern int upperfd;
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
+static bool is_dir_xattr(int dirfd, const char *pathname,
+			 const char *xattrname)
+{
+	char *val = NULL;
+	ssize_t ret;
+	bool exist;
+
+	ret = get_xattr(dirfd, pathname, xattrname, &val, NULL);
+	if (ret <= 0 || !val)
+		return false;
+
+	exist = (ret == 1 && val[0] == 'y') ? true : false;
+	free(val);
+	return exist;
+}
+
+static inline bool ovl_is_opaque(int dirfd, const char *pathname)
+{
+	return is_dir_xattr(dirfd, pathname, OVL_OPAQUE_XATTR);
+}
+
+static inline int ovl_remove_opaque(int dirfd, const char *pathname)
+{
+	return remove_xattr(dirfd, pathname, OVL_OPAQUE_XATTR);
+}
+
+static inline int ovl_set_opaque(int dirfd, const char *pathname)
+{
+	return set_xattr(dirfd, pathname, OVL_OPAQUE_XATTR, "y", 1);
+}
+
+static int ovl_get_redirect(int dirfd, const char *pathname,
+			    char **redirect)
+{
+	char *rd = NULL;
+	ssize_t ret;
+
+	ret = get_xattr(dirfd, pathname, OVL_REDIRECT_XATTR, &rd, NULL);
+	if (ret <= 0 || !rd)
+		return ret;
+
+	if (rd[0] != '/') {
+		char *tmp = sstrdup(pathname);
+
+		*redirect = joinname(dirname(tmp), rd);
+		free(tmp);
+		free(rd);
+	} else {
+		ret -= 1;
+		memmove(rd, rd+1, ret);
+		rd[ret] = '\0';
+		*redirect = rd;
+	}
+
+	return 0;
+}
+
+static inline int ovl_remove_redirect(int dirfd, const char *pathname)
+{
+	return remove_xattr(dirfd, pathname, OVL_REDIRECT_XATTR);
+}
+
+static inline int ovl_create_whiteout(int dirfd, const char *pathname)
+{
+	if (mknodat(dirfd, pathname, S_IFCHR | WHITEOUT_MOD, makedev(0, 0))) {
+		print_err(_("Cannot mknod %s:%s\n"), pathname,
+			    strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
+static inline bool ovl_is_redirect(int dirfd, const char *pathname)
+{
+	bool exist = false;
+	get_xattr(dirfd, pathname, OVL_REDIRECT_XATTR, NULL, &exist);
+	return exist;
+}
+
+static inline int ovl_ask_action(const char *description, const char *pathname,
+				 int dirtype, int stack,
+				 const char *question, int action)
+{
+	if (dirtype == OVL_UPPER)
+		print_info(_("%s: \"%s\" in %s "),
+			     description, pathname, "upperdir");
+	else
+		print_info(_("%s: \"%s\" in %s-%d "),
+			     description, pathname, "lowerdir", stack);
+
+	return ask_question(question, action);
+}
+
+static inline int ovl_ask_question(const char *question, const char *pathname,
+				   int dirtype, int stack,
+				   int action)
+{
+	if (dirtype == OVL_UPPER)
+		print_info(_("%s: \"%s\" in %s "),
+			     question, pathname, "upperdir");
+	else
+		print_info(_("%s: \"%s\" in %s-%d "),
+			     question, pathname, "lowerdir", stack);
+
+	return ask_question("", action);
+}
+
+static int ovl_lookup_single(int dirfd, const char *pathname,
+			     struct stat *st, bool *exist)
+{
+	if (fstatat(dirfd, pathname, st,
+		    AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW)) {
+		if (errno != ENOENT && errno != ENOTDIR) {
+			print_err(_("Cannot stat %s: %s\n"), pathname,
+				    strerror(errno));
+			return -1;
+		}
+		*exist = false;
+	} else {
+		*exist = true;
+	}
+	return 0;
+}
+
+static int ovl_lookup_layer(struct ovl_lookup_ctx *lctx)
+{
+	char *pathname;
+	int ret = 0;
+
+	if (!lctx->skip) {
+		if (ovl_lookup_single(lctx->dirfd, lctx->pathname,
+				      &lctx->st, &lctx->exist))
+			return -1;
+	}
+
+	/* If we found or in the bottom layer, no need to iterate */
+	if (lctx->exist || lctx->last)
+		return 0;
+
+	/*
+	 * Check if we should stop or redirect for the next layer's lookup.
+	 *
+	 * Iterate to the first item in the path. If a redirect dir was found,
+	 * change path for the next lookup. If an opaque directory or a file
+	 * was found, stop lookup.
+	 */
+	pathname = sstrdup(lctx->pathname);
+	while (strcmp(dirname(pathname), ".")) {
+		char *redirect = NULL;
+		bool exist = false;
+		struct stat st;
+
+		ret = ovl_lookup_single(lctx->dirfd, pathname, &st, &exist);
+		if (ret)
+			goto out;
+
+		if (!exist)
+			continue;
+
+		if (!is_dir(&st) || ovl_is_opaque(lctx->dirfd, pathname)) {
+			lctx->stop = true;
+			goto out;
+		}
+
+		if (ovl_is_redirect(lctx->dirfd, pathname)) {
+			ret = ovl_get_redirect(lctx->dirfd, pathname, &redirect);
+			if (ret)
+				goto out;
+
+			free(lctx->redirect);
+			lctx->redirect = joinname(redirect,
+					 basename2(lctx->pathname, pathname));
+			free(redirect);
+			goto out;
+		}
+	}
+out:
+	free(pathname);
+	return ret;
+}
+
+/*
+ * Lookup the lower layers have the same target with the specific one or not.
+ *
+ * Scan each lower directory start from the layer of 'start' and lookup target
+ * until find something (skip target founded in start layer), Iterate parent
+ * directories and check directory type, following redirect directory and
+ * terminate scan if there is a file or an opaque directory exists.
+ */
+static int ovl_lookup_lower(const char *pathname, int dirtype,
+			    int start, struct ovl_lookup_data *od)
+{
+	struct ovl_lookup_ctx lctx = {0};
+	int i;
+	int ret = 0;
+
+	if (dirtype == OVL_UPPER)
+		start = 0;
+
+	if (dirtype == OVL_UPPER) {
+		lctx.dirfd = upperfd;
+		lctx.pathname = pathname;
+		lctx.skip = true;
+
+		ret = ovl_lookup_layer(&lctx);
+		if (ret)
+			goto out;
+	}
+
+	for (i = start; !lctx.stop && i < lower_num; i++) {
+		lctx.dirfd = lowerfd[i];
+		lctx.pathname = (lctx.redirect) ? lctx.redirect : pathname;
+		lctx.skip = (dirtype == OVL_LOWER && i == start) ? true : false;
+		lctx.last = (i == lower_num - 1) ? true : false;
+
+		ret = ovl_lookup_layer(&lctx);
+		if (ret)
+			goto out;
+
+		if (lctx.exist)
+			break;
+	}
+
+	od->exist = lctx.exist;
+	if (od->exist) {
+		strncpy(od->pathname, lctx.pathname, sizeof(od->pathname));
+		od->stack = i;
+		od->st = lctx.st;
+	}
+out:
+	free(lctx.redirect);
+	return ret;
+}
+
+/*
+ * The same as ovl_lookup_lower() except start from the layer of 'start',
+ * not skip any target founded.
+ */
+static int ovl_lookup(const char *pathname, int start,
+		      struct ovl_lookup_data *od)
+{
+	struct ovl_lookup_ctx lctx = {0};
+	int i;
+	int ret = 0;
+
+	for (i = start; !lctx.stop && i < lower_num; i++) {
+		lctx.dirfd = lowerfd[i];
+		lctx.pathname = (lctx.redirect) ? lctx.redirect : pathname;
+		lctx.last = (i == lower_num - 1) ? true : false;
+
+		ret = ovl_lookup_layer(&lctx);
+		if (ret)
+			goto out;
+
+		if (lctx.exist)
+			break;
+	}
+
+	od->exist = lctx.exist;
+	if (od->exist) {
+		strncpy(od->pathname, lctx.pathname, sizeof(od->pathname));
+		od->stack = i;
+		od->st = lctx.st;
+	}
+out:
+	free(lctx.redirect);
+	return ret;
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
+	struct ovl_lookup_data od = {0};
+	int ret = 0;
+
+	/* Is a whiteout ? */
+	if (!is_whiteout(st))
+		return 0;
+
+	sctx->t_whiteouts++;
+
+	/* Is whiteout in the bottom lower dir ? */
+	if (sctx->dirtype == OVL_LOWER && sctx->stack == lower_num-1)
+		goto remove;
+
+	/*
+	 * Scan each corresponding lower directroy under this layer,
+	 * check is there a file or dir with the same name.
+	 */
+	ret = ovl_lookup_lower(pathname, sctx->dirtype, sctx->stack, &od);
+	if (ret)
+		goto out;
+
+	if (od.exist && !is_whiteout(&od.st))
+		goto out;
+
+remove:
+	sctx->i_whiteouts++;
+
+	/* Remove orphan whiteout directly or ask user */
+	if (!ovl_ask_action("Orphan whiteout", pathname, sctx->dirtype,
+			    sctx->stack, "Remove", 1))
+		return 0;
+
+	ret = unlinkat(sctx->dirfd, pathname, 0);
+	if (ret) {
+		print_err(_("Cannot unlink %s: %s\n"), pathname,
+			    strerror(errno));
+		goto out;
+	}
+	sctx->t_whiteouts--;
+	sctx->i_whiteouts--;
+out:
+	return ret;
+}
+
+LIST_HEAD(redirect_list);
+
+static void ovl_redirect_entry_add(const char *pathname, int dirtype, int stack,
+				   const char *origin, int ostack)
+{
+	struct ovl_redirect_entry *new;
+
+	new = smalloc(sizeof(*new));
+	INIT_LIST_HEAD(&new->list);
+
+	print_debug(_("Redirect entry add: [%s %s %d][%s %d]\n"),
+		      pathname, (dirtype == OVL_UPPER) ? "upper" : "lower",
+		      (dirtype == OVL_UPPER) ? 0 : stack,
+		      origin, ostack);
+
+	new->pathname = sstrdup(pathname);
+	new->dirtype = dirtype;
+	new->stack = stack;
+	new->origin = sstrdup(origin);
+	new->ostack = ostack;
+
+	list_add(&new->list, &redirect_list);
+}
+
+static bool ovl_redirect_entry_find(const char *origin, int ostack,
+				    int *dirtype, int *stack, char **pathname)
+{
+	struct ovl_redirect_entry *entry;
+	struct list_head *node;
+
+	if (list_empty(&redirect_list))
+		return false;
+
+	list_for_each(node, &redirect_list) {
+		entry = list_entry(node, struct ovl_redirect_entry, list);
+
+		if (entry->ostack == ostack && !strcmp(entry->origin, origin)) {
+			*pathname = entry->pathname;
+			*dirtype = entry->dirtype;
+			*stack = entry->stack;
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
+	struct list_head *node, *tmp;
+
+	list_for_each_safe(node, tmp, &redirect_list) {
+		entry = list_entry(node, struct ovl_redirect_entry, list);
+		list_del_init(node);
+		free(entry->origin);
+		free(entry->pathname);
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
+ *    If more than one, there must be some inconsistency but not sure
+ *    which one is invalid, ask user or warn in auto mode.
+ * 3) Check and fix the missing whiteout or opaque in redierct parent dir.
+ */
+static int ovl_check_redirect(struct scan_ctx *sctx)
+{
+	const char *pathname = sctx->pathname;
+	struct ovl_lookup_data od = {0};
+	struct stat cover_st;
+	bool cover_exist = false;
+	char *redirect = NULL;
+	int start;
+	int ret;
+
+	/* Get redirect */
+	ret = ovl_get_redirect(sctx->dirfd, pathname, &redirect);
+	if (ret || !redirect)
+		return ret;
+
+	print_debug(_("Dir \"%s\" has redirect \"%s\"\n"), pathname, redirect);
+	sctx->t_redirects++;
+
+	/* Redirect dir in last lower dir ? */
+	if (sctx->dirtype == OVL_LOWER && sctx->stack == lower_num-1)
+		goto remove;
+
+	/* Scan lower directories to check redirect dir exist or not */
+	start = (sctx->dirtype == OVL_LOWER) ? sctx->stack + 1 : 0;
+	ret = ovl_lookup(redirect, start, &od);
+	if (ret)
+		goto out;
+
+	if (od.exist && is_dir(&od.st)) {
+		int dirtype, stack;
+		char *dup;
+
+		/* Check duplicate redirect xattr */
+		if (ovl_redirect_entry_find(od.pathname, od.stack,
+					    &dirtype, &stack, &dup)) {
+			print_info("Duplicate redirect dir found:%s\n", pathname);
+			print_info("Origin:%s in lower %d, "
+				   "Previous:%s in %s %d\n",
+				   od.pathname, od.stack, dup,
+				   (dirtype == OVL_UPPER) ? "upper" : "lower",
+				   stack);
+
+			sctx->i_redirects++;
+
+			/*
+			 * Not sure which one is invalid, don't remove in
+			 * auto mode
+			 */
+			if (ovl_ask_action("Duplicate redirect xattr", pathname,
+					   sctx->dirtype, sctx->stack,
+					   "Remove", 0))
+				goto remove_d;
+		}
+
+		/* Now, this redirect xattr is valid */
+		ovl_redirect_entry_add(pathname, sctx->dirtype, sctx->stack,
+				       od.pathname, od.stack);
+
+		/* Check and fix whiteout or opaque dir */
+		ret = ovl_lookup_single(sctx->dirfd, redirect, &cover_st,
+					&cover_exist);
+		if (ret)
+			goto out;
+		if (!cover_exist) {
+			/* Found nothing, create a whiteout */
+			if (ovl_ask_action("Missing cover whiteout", pathname,
+					   sctx->dirtype, sctx->stack,
+					   "Add", 1)) {
+				ret = ovl_create_whiteout(sctx->dirfd, redirect);
+				if (ret)
+					goto out;
+
+				sctx->t_whiteouts++;
+			}
+		} else if (is_dir(&cover_st) &&
+			   !ovl_is_opaque(sctx->dirfd, redirect)) {
+
+			/* Found a directory but not opaqued, fix opaque xattr */
+			if ((ret = ovl_set_opaque(sctx->dirfd, redirect)))
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
+	if (!ovl_ask_action("Invalid redirect xattr", pathname, sctx->dirtype,
+			    sctx->stack, "Remove", 1))
+		goto out;
+remove_d:
+	ret = ovl_remove_redirect(sctx->dirfd, pathname);
+	if (ret)
+		goto out;
+
+	sctx->t_redirects--;
+	sctx->i_redirects--;
+out:
+	free(redirect);
+	return ret;
+}
+
+/*
+ * Scan Pass:
+ * -Pass one: Iterate through all directories, and check validity
+ *            of redirect directory, include duplicate redirect
+ *            directory. After this pass, the hierarchical structure
+ *            of each layer's directories becomes consistent.
+ * -Pass two: iterate through all directories, and find and check
+ *            validity of whiteouts.
+ */
+
+static struct scan_operations ovl_scan_ops[OVL_SCAN_PASS][2] = {
+	{
+		[OVL_UPPER] = {
+			.redirect = ovl_check_redirect,
+		},
+		[OVL_LOWER] = {
+			.redirect = ovl_check_redirect,
+		},
+	},/* Pass One */
+	{
+		[OVL_UPPER] = {
+			.whiteout = ovl_check_whiteout,
+		},
+		[OVL_LOWER] = {
+			.whiteout = ovl_check_whiteout,
+		},
+	}/* Pass Two */
+};
+
+static char *ovl_scan_desc[OVL_SCAN_PASS] = {
+	"Checking redirect xattr and directory tree",
+	"Checking whiteouts"
+};
+
+static void ovl_scan_clean(void)
+{
+	/* Clean redirect entry record */
+	ovl_redirect_free();
+}
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
+}
+
+static void ovl_scan_check(struct scan_ctx *sctx)
+{
+	if (sctx->i_whiteouts)
+		print_info(_("Invalid whiteouts %d left!\n"),
+			     sctx->i_whiteouts);
+	else if (sctx->i_redirects)
+		print_info(_("Invalid redirect directories %d left!\n"),
+			     sctx->i_redirects);
+	else
+		return;
+
+	set_inconsistency(&status);
+}
+
+/* Scan upperdir and each lowerdirs, check and fix inconsistency */
+int ovl_scan_fix(void)
+{
+	struct scan_ctx sctx = {0};
+	int i,j;
+	int ret;
+
+	if (flags & FL_VERBOSE)
+		print_info(_("Scan and fix: [whiteouts|redirect dir]\n"));
+
+	for (i = 0; i < OVL_SCAN_PASS; i++) {
+		if (flags & FL_VERBOSE)
+			print_info(_("Pass %d: %s\n"), i, ovl_scan_desc[i]);
+
+		sctx.directories = 0;
+		sctx.files = 0;
+
+		/* Scan every lower directories */
+		for (j = lower_num - 1; j >= 0; j--) {
+			print_debug(_("Scan lower directory %d\n"), j);
+
+			sctx.dirname = lowerdir[j];
+			sctx.dirfd = lowerfd[j];
+			sctx.dirtype = OVL_LOWER;
+			sctx.stack = j;
+
+			ret = scan_dir(&sctx, &ovl_scan_ops[i][OVL_LOWER]);
+			if (ret)
+				goto out;
+		}
+
+		/* Scan upper directory */
+		if (flags & FL_UPPER) {
+			print_debug(_("Scan upper directory\n"));
+
+			sctx.dirname = upperdir;
+			sctx.dirfd = upperfd;
+			sctx.dirtype = OVL_UPPER;
+			sctx.stack = 0;
+
+			ret = scan_dir(&sctx, &ovl_scan_ops[i][OVL_UPPER]);
+			if (ret)
+				goto out;
+		}
+
+		/* Check scan result for this pass */
+		ovl_scan_check(&sctx);
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
+#define PACKAGE_VERSION	"v0.1.0"
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
index 0000000..8ed7fb4
--- /dev/null
+++ b/fsck.c
@@ -0,0 +1,305 @@
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
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <getopt.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/resource.h>
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
+char *lowerdirs = NULL;
+char **lowerdir = NULL;
+char *upperdir = NULL;
+char *workdir = NULL;
+int *lowerfd = NULL;
+int upperfd = 0;
+int lower_num = 0;
+int flags = 0;		/* user input option flags */
+int status = 0;		/* fsck scan status */
+
+/* Open underlying dirs */
+static int ovl_open_dirs(void)
+{
+	unsigned int i;
+	struct rlimit rlim;
+	rlim_t rlim_need = lower_num + 20;
+
+	/* If RLIMIT_NOFILE limit is small than we need, try to expand limit */
+	if ((getrlimit(RLIMIT_NOFILE, &rlim))) {
+		print_err(_("Failed to getrlimit:%s\n"), strerror(errno));
+		return -1;
+	}
+	if (rlim.rlim_cur < rlim_need) {
+		print_info(_("Process fd number limit=%lu "
+			     "too small, need %lu\n"),
+			     rlim.rlim_cur, rlim_need);
+
+		rlim.rlim_cur = rlim_need;
+		if (rlim.rlim_max < rlim.rlim_cur)
+			rlim.rlim_max = rlim.rlim_cur;
+
+		if ((setrlimit(RLIMIT_NOFILE, &rlim))) {
+			print_err(_("Failed to setrlimit:%s\n"),
+				    strerror(errno));
+			return -1;
+		}
+	}
+
+	if (flags & FL_UPPER) {
+		upperfd = open(upperdir,
+			       O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC);
+		if (upperfd < 0) {
+			print_err(_("Failed to open %s:%s\n"), upperdir,
+				    strerror(errno));
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
+	close(upperfd);
+	upperfd = 0;
+	return -1;
+}
+
+/* Cleanup underlying directories buffer */
+static void ovl_clean_dirs(void)
+{
+	int i;
+
+	for (i = 0; i < lower_num; i++) {
+		if (lowerfd && lowerfd[i]) {
+			close(lowerfd[i]);
+			lowerfd[i] = 0;
+		}
+		free(lowerdir[i]);
+		lowerdir[i] = NULL;
+	}
+	free(lowerfd);
+	lowerfd = NULL;
+	free(lowerdir);
+	lowerdir = NULL;
+	lower_num = 0;
+
+	if (flags & FL_UPPER) {
+		close(upperfd);
+		upperfd = 0;
+		free(upperdir);
+		upperdir = NULL;
+	}
+	if (flags & FL_WORK) {
+		free(workdir);
+		workdir = NULL;
+	}
+}
+
+static void usage(void)
+{
+	print_info(_("Usage:\n\t%s [-o lowerdir=<lowers>,upperdir=<upper>,workdir=<work>] "
+		    "[-pnyvhV]\n\n"), program_name);
+	print_info(_("Options:\n"
+		    "-o,                       specify underlying directories of overlayfs\n"
+		    "                          multiple lower directories use ':' as separator\n"
+		    "-p,                       automatic repair (no questions)\n"
+		    "-n,                       make no changes to the filesystem\n"
+		    "-y,                       assume \"yes\" to all questions\n"
+		    "-v, --verbose             print more messages of overlayfs\n"
+		    "-h, --help                display this usage of overlayfs\n"
+		    "-V, --version             display version information\n"));
+	exit(1);
+}
+
+static void parse_options(int argc, char *argv[])
+{
+	struct ovl_config config = {0};
+	char *ovl_opts = NULL;
+	int c;
+	bool conflict = false;
+
+	struct option long_options[] = {
+		{"verbose", no_argument, NULL, 'v'},
+		{"version", no_argument, NULL, 'V'},
+		{"help", no_argument, NULL, 'h'},
+		{NULL, 0, NULL, 0}
+	};
+
+	while ((c = getopt_long(argc, argv, "o:apnyvVh",
+		long_options, NULL)) != -1) {
+
+		switch (c) {
+		case 'o':
+			ovl_opts = sstrdup(optarg);
+			ovl_parse_opt(ovl_opts, &config);
+			free(ovl_opts);
+			break;
+		case 'p':
+			if (flags & (FL_OPT_YES | FL_OPT_NO))
+				conflict = true;
+			else
+				flags |= FL_OPT_AUTO;
+			break;
+		case 'n':
+			if (flags & (FL_OPT_YES | FL_OPT_AUTO))
+				conflict = true;
+			else
+				flags |= FL_OPT_NO;
+			break;
+		case 'y':
+			if (flags & (FL_OPT_NO | FL_OPT_AUTO))
+				conflict = true;
+			else
+				flags |= FL_OPT_YES;
+			break;
+		case 'v':
+			flags |= FL_VERBOSE;
+			break;
+		case 'V':
+			version();
+			exit(0);
+		case 'h':
+		default:
+			usage();
+			return;
+		}
+	}
+
+	/* Resolve and get each underlying directory of overlay filesystem */
+	ovl_get_dirs(&config, &lowerdir, &lower_num, &upperdir, &workdir);
+	if (upperdir)
+		flags |= FL_UPPER;
+	if (workdir)
+		flags |= FL_WORK;
+
+	if (!lower_num || (!(flags & FL_UPPER) && lower_num == 1)) {
+		print_info(_("Please specify correct lowerdirs and upperdir!\n\n"));
+		goto err_out;
+	}
+
+	if ((flags & FL_UPPER) && !(flags & FL_WORK)) {
+		print_info(_("Please specify correct workdir!\n\n"));
+		goto err_out;
+	}
+
+	if (conflict) {
+		print_info(_("Only one of the options -p/-a, -n or -y "
+			     "can be specified!\n\n"));
+		goto err_out;
+	}
+
+	ovl_free_opt(&config);
+	return;
+
+err_out:
+	ovl_free_opt(&config);
+	ovl_clean_dirs();
+	usage();
+	exit(1);
+}
+
+static void fsck_status_report(int *exit)
+{
+	if (status & OVL_ST_INCONSISTNECY) {
+		*exit |= FSCK_UNCORRECTED;
+		print_info(_("Still have unexpected inconsistency!\n"));
+	}
+
+	if (status & OVL_ST_ABORT) {
+		*exit |= FSCK_ERROR;
+		print_info(_("Cannot continue, aborting\n"));
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	bool mounted = false;
+	int exit = 0;
+
+	program_name = basename(argv[0]);
+
+	parse_options(argc, argv);
+
+	/* Open all specified base dirs */
+	if (ovl_open_dirs())
+		goto err;
+
+	/* Ensure overlay filesystem not mounted */
+	if (ovl_check_mount(&mounted))
+		goto err;
+
+	if (mounted && !(flags & FL_OPT_NO)) {
+		set_abort(&status);
+		goto out;
+	}
+
+	/* Scan and fix */
+	if (ovl_scan_fix())
+		goto err;
+
+out:
+	ovl_clean_dirs();
+	fsck_status_report(&exit);
+	if (exit)
+		print_info("WARNING: Filesystem check failed, may not clean\n");
+	else
+		print_info("Filesystem clean\n");
+
+	return exit;
+
+err:
+	exit |= FSCK_ERROR;
+	goto out;
+}
diff --git a/lib.c b/lib.c
new file mode 100644
index 0000000..3d9185c
--- /dev/null
+++ b/lib.c
@@ -0,0 +1,249 @@
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
+#include <fcntl.h>
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
+#include "path.h"
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
+int ask_question(const char *question, int def)
+{
+	if (flags & FL_OPT_MASK) {
+		def = (flags & FL_OPT_YES) ? 1 : (flags & FL_OPT_NO) ? 0 : def;
+		print_info(_("%s? %s\n"), question, def ? _("y") : _("n"));
+		return def;
+	}
+
+	return ask_yn(question, def);
+}
+
+ssize_t get_xattr(int dirfd, const char *pathname, const char *xattrname,
+		  char **value, bool *exist)
+{
+	char *buf = NULL;
+	int fd;
+	ssize_t ret;
+
+	fd = openat(dirfd, pathname, O_CLOEXEC|O_NONBLOCK|O_NOFOLLOW|O_RDONLY);
+	if (fd < 0) {
+		print_err(_("Failed to openat %s: %s\n"),
+			    pathname, strerror(errno));
+		return -1;
+	}
+
+	ret = fgetxattr(fd, xattrname, NULL, 0);
+	if (ret < 0) {
+		if (errno != ENODATA && errno != ENOTSUP)
+			goto fail;
+		if (exist)
+			*exist = false;
+		ret = 0;
+		goto out;
+	}
+
+	/* Zero size value means xattr exist but value unknown */
+	if (exist)
+		*exist = true;
+	if (ret == 0 || !value)
+		goto out;
+
+	buf = smalloc(ret+1);
+	ret = fgetxattr(fd, xattrname, buf, ret);
+	if (ret <= 0)
+		goto fail2;
+
+	buf[ret] = '\0';
+	*value = buf;
+out:
+	close(fd);
+	return ret;
+
+fail2:
+	free(buf);
+fail:
+	print_err(_("Cannot fgetxattr %s %s: %s\n"), pathname,
+		    xattrname, strerror(errno));
+	goto out;
+}
+
+int set_xattr(int dirfd, const char *pathname, const char *xattrname,
+	      void *value, size_t size)
+{
+	int fd;
+	int ret;
+
+	fd = openat(dirfd, pathname, O_CLOEXEC|O_NONBLOCK|O_NOFOLLOW|O_RDONLY);
+	if (fd < 0) {
+		print_err(_("Failed to openat %s: %s\n"),
+			    pathname, strerror(errno));
+		return -1;
+	}
+
+	ret = fsetxattr(fd, xattrname, value, size, XATTR_CREATE);
+	if (ret && errno != EEXIST)
+		goto fail;
+
+	if (errno == EEXIST) {
+		ret = fsetxattr(fd, xattrname, value, size, XATTR_REPLACE);
+		if (ret)
+			goto fail;
+	}
+
+out:
+	close(fd);
+	return ret;
+fail:
+	print_err(_("Cannot fsetxattr %s %s: %s\n"), pathname,
+		    xattrname, strerror(errno));
+	goto out;
+}
+
+int remove_xattr(int dirfd, const char *pathname, const char *xattrname)
+{
+	int fd;
+	int ret;
+
+	fd = openat(dirfd, pathname, O_CLOEXEC|O_NONBLOCK|O_NOFOLLOW|O_RDONLY);
+	if (fd < 0) {
+		print_err(_("Failed to openat %s: %s\n"),
+			    pathname, strerror(errno));
+		return -1;
+	}
+
+	ret = fremovexattr(fd, xattrname);
+	if (ret)
+		print_err(_("Cannot fremovexattr %s %s: %s\n"), pathname,
+			    xattrname, strerror(errno));
+
+	close(fd);
+	return ret;
+}
+
+
+static void scan_entry_init(struct scan_ctx *sctx, FTSENT *ftsent)
+{
+	sctx->pathname = basename2(ftsent->fts_path, sctx->dirname);
+	sctx->filename = ftsent->fts_name;
+	sctx->st = ftsent->fts_statp;
+}
+
+static inline int scan_check_entry(int (*do_check)(struct scan_ctx *),
+				   struct scan_ctx *sctx)
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
+		/* Fillup base context */
+		scan_entry_init(sctx, ftsent);
+
+		print_debug(_("Scan:%-3s %2d %7jd   %-40s %-20s\n"),
+			      (ftsent->fts_info == FTS_D) ? "d" :
+			      (ftsent->fts_info == FTS_DNR) ? "dnr" :
+			      (ftsent->fts_info == FTS_DP) ? "dp" :
+			      (ftsent->fts_info == FTS_F) ? "f" :
+			      (ftsent->fts_info == FTS_NS) ? "ns" :
+			      (ftsent->fts_info == FTS_SL) ? "sl" :
+			      (ftsent->fts_info == FTS_SLNONE) ? "sln" :
+			      (ftsent->fts_info == FTS_DEFAULT) ? "df" : "???",
+			      ftsent->fts_level, ftsent->fts_statp->st_size,
+			      ftsent->fts_path, sctx->pathname);
+
+		switch (ftsent->fts_info) {
+		case FTS_F:
+			sctx->files++;
+			break;
+		case FTS_DEFAULT:
+			/* Check whiteouts */
+			ret = scan_check_entry(sop->whiteout, sctx);
+			if (ret)
+				goto out;
+			break;
+		case FTS_D:
+			sctx->directories++;
+
+			/* Check redirect xattr */
+			ret = scan_check_entry(sop->redirect, sctx);
+			if (ret)
+				goto out;
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
index 0000000..2245752
--- /dev/null
+++ b/lib.h
@@ -0,0 +1,102 @@
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
+#define FL_OPT_AUTO	(1 << 3)	/* automactically scan dirs and repair */
+#define FL_OPT_NO	(1 << 4)	/* no changes to the filesystem */
+#define FL_OPT_YES	(1 << 5)	/* yes to all questions */
+#define FL_OPT_MASK	(FL_OPT_AUTO|FL_OPT_NO|FL_OPT_YES)
+
+/* Scan pass */
+#define OVL_SCAN_PASS	2
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
+	const char *dirname;	/* overlay base dir */
+	int dirfd;		/* dir descriptor */
+	int dirtype;		/* OVL_UPPER or OVL_LOWER */
+	int stack;		/* lower depth, OVL_LOWER use only */
+
+	int files;		/* total files */
+	int directories;	/* total directories */
+	int t_whiteouts;	/* total whiteouts */
+	int i_whiteouts;	/* invalid whiteouts */
+	int t_redirects;	/* total redirect dirs */
+	int i_redirects;	/* invalid redirect dirs */
+
+	const char *pathname;	/* path relative to overlay root */
+	const char *filename;	/* filename */
+	struct stat *st;	/* file stat */
+};
+
+/* Directories scan callback operations struct */
+struct scan_operations {
+	int (*whiteout)(struct scan_ctx *);
+	int (*redirect)(struct scan_ctx *);
+};
+
+static inline void set_inconsistency(int *status)
+{
+	*status |= OVL_ST_INCONSISTNECY;
+}
+
+static inline void set_abort(int *status)
+{
+	*status |= OVL_ST_ABORT;
+}
+
+int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop);
+int ask_question(const char *question, int def);
+ssize_t get_xattr(int dirfd, const char *pathname, const char *xattrname,
+		  char **value, bool *exist);
+int set_xattr(int dirfd, const char *pathname, const char *xattrname,
+	      void *value, size_t size);
+int remove_xattr(int dirfd, const char *pathname, const char *xattrname);
+
+#endif /* OVL_LIB_H */
diff --git a/list.h b/list.h
new file mode 100644
index 0000000..5a55eac
--- /dev/null
+++ b/list.h
@@ -0,0 +1,114 @@
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
+/*
+ * This is a simple version of list functions from the Linux kernel
+ * (see include/linux/list.h)
+ */
+
+#ifndef OVL_LIST_H
+#define OVL_LIST_H
+
+struct list_head {
+        struct list_head *next, *prev;
+};
+
+#define LIST_HEAD_INIT(name) { &(name), &(name) }
+
+#define LIST_HEAD(name) \
+	struct list_head name = LIST_HEAD_INIT(name)
+
+static inline void INIT_LIST_HEAD(struct list_head *list)
+{
+        list->next = list;
+        list->prev = list;
+}
+
+static inline void __list_add(struct list_head *new,
+                              struct list_head *prev,
+                              struct list_head *next)
+{
+        next->prev = new;
+        new->next = next;
+        new->prev = prev;
+        prev->next = new;
+}
+
+static inline void list_add(struct list_head *new, struct list_head *head)
+{
+        __list_add(new, head, head->next);
+}
+
+static inline void list_add_tail(struct list_head *new, struct list_head *head)
+{
+        __list_add(new, head->prev, head);
+}
+
+static inline void __list_del(struct list_head * prev, struct list_head * next)
+{
+        next->prev = prev;
+        prev->next = next;
+}
+
+static inline void __list_del_entry(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+}
+
+static inline void list_del(struct list_head *entry)
+{
+        __list_del(entry->prev, entry->next);
+        entry->next = entry->prev = NULL;
+}
+
+/**
+ * list_del_init - deletes entry from list and reinitialize it.
+ * @entry: the element to delete from the list.
+ */
+static inline void list_del_init(struct list_head *entry)
+{
+	__list_del_entry(entry);
+	INIT_LIST_HEAD(entry);
+}
+
+/**
+ * list_empty - tests whether a list is empty
+ * @head: the list to test.
+ */
+static inline bool list_empty(const struct list_head *head)
+{
+        return head->next == head;
+}
+
+#define list_entry(ptr, type, member) \
+	((type *)((char *)(ptr)-(unsigned long)(&((type *)0)->member)))
+
+#define list_for_each(pos, head) \
+	for (pos = (head)->next; pos != (head); pos = pos->next)
+ 
+/**
+ * list_for_each_safe - iterate over a list safe against removal of list entry
+ * @pos:	 the &struct list_head to use as a loop cursor.
+ * @n: 	 another &struct list_head to use as temporary storage
+ * @head:	 the head for your list.
+ */
+#define list_for_each_safe(pos, n, head) \
+	for (pos = (head)->next, n = pos->next; pos != (head); \
+		pos = n, n = pos->next)
+
+#endif /* OVL_LIST_H */
diff --git a/mount.c b/mount.c
new file mode 100644
index 0000000..6efeca7
--- /dev/null
+++ b/mount.c
@@ -0,0 +1,370 @@
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
+	char **lowerdir;
+	int lowernum;
+	char *upperdir;
+	char *workdir;
+};
+
+/* Mount buf allocate a time */
+#define ALLOC_NUM	16
+
+extern char **lowerdir;
+extern char *upperdir;
+extern char *workdir;
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
+static int ovl_resolve_lowerdirs(char *loweropt, char ***lowerdir,
+				 int *lowernum)
+{
+	char temp[PATH_MAX] = {0};
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
+		if (!realpath(p, temp)) {
+			print_err(_("Failed to resolve lowerdir:%s:%s\n"),
+				    p, strerror(errno));
+			goto err;
+		}
+		dirs[i] = sstrdup(temp);
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
+	*lowerdir = NULL;
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
+static inline char *ovl_match_dump(const char *opt, const char *type)
+{
+	int len = strlen(opt) - strlen(type) + 1;
+
+	return sstrndup(opt+strlen(type), len);
+}
+
+/*
+ * Resolve and get each underlying directory of overlay filesystem
+ */
+int ovl_get_dirs(struct ovl_config *config, char ***lowerdir,
+		 int *lowernum, char **upperdir, char **workdir)
+{
+	char temp[PATH_MAX] = {0};
+
+	/* Resolve upperdir */
+	if (config->upperdir) {
+		if (!realpath(config->upperdir, temp)) {
+			print_err(_("Faile to resolve upperdir:%s:%s\n"),
+				    config->upperdir, strerror(errno));
+			goto err_out;
+		}
+		*upperdir = sstrdup(temp);
+		print_debug(_("Upperdir: %s\n"), *upperdir);
+	}
+
+	/* Resolve workdir */
+	if (config->workdir) {
+		if (!realpath(config->workdir, temp)) {
+			print_err(_("Faile to resolve workdir:%s:%s\n"),
+				    config->workdir, strerror(errno));
+			goto err_work;
+		}
+		*workdir = sstrdup(temp);
+		print_debug(_("Workdir: %s\n"), *workdir);
+	}
+
+	/* Resolve lowerdir */
+	if (config->lowerdir) {
+		if (ovl_resolve_lowerdirs(config->lowerdir, lowerdir, lowernum))
+			goto err_lower;
+	}
+
+	return 0;
+
+err_lower:
+	if (*workdir)
+		free(*workdir);
+	*workdir = NULL;
+err_work:
+	if (*upperdir)
+		free(*upperdir);
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
+ */
+void ovl_parse_opt(char *opt, struct ovl_config *config)
+{
+	char *p;
+
+	while ((p = ovl_next_opt(&opt)) != NULL) {
+		if (!*p)
+			continue;
+
+		if (!strncmp(p, OPT_UPPERDIR, strlen(OPT_UPPERDIR))) {
+			free(config->upperdir);
+			config->upperdir = ovl_match_dump(p, OPT_UPPERDIR);
+		} else if (!strncmp(p, OPT_LOWERDIR, strlen(OPT_LOWERDIR))) {
+			free(config->lowerdir);
+			config->lowerdir = ovl_match_dump(p, OPT_LOWERDIR);
+		} else if (!strncmp(p, OPT_WORKDIR, strlen(OPT_WORKDIR))) {
+			free(config->workdir);
+			config->workdir = ovl_match_dump(p, OPT_WORKDIR);
+		}
+	}
+}
+
+/* Scan current mounted overlayfs and get used underlying directories */
+static int ovl_scan_mount_init(struct ovl_mnt_entry **ovl_mnt_entries,
+			       int *ovl_mnt_count)
+{
+	struct ovl_mnt_entry *entries = NULL;
+	struct mntent *mnt = NULL;
+	struct ovl_config config = {0};
+	FILE *fp;
+	char *opt;
+	int allocated, i = 0;
+
+	fp = setmntent(MOUNT_TAB, "r");
+	if (!fp) {
+		print_err(_("Fail to setmntent %s:%s\n"),
+			    MOUNT_TAB, strerror(errno));
+		return -1;
+	}
+
+	allocated = sizeof(struct ovl_mnt_entry) * ALLOC_NUM;
+	entries = smalloc(allocated);
+
+	while ((mnt = getmntent(fp))) {
+		if (strcmp(mnt->mnt_type, OVERLAY_NAME))
+			continue;
+
+		opt = sstrdup(mnt->mnt_opts);
+		ovl_parse_opt(opt, &config);
+
+		if ((config.lowerdir && config.lowerdir[0] != '/') ||
+		    (config.upperdir && config.upperdir[0] != '/') ||
+		    (config.workdir && config.workdir[0] != '/'))
+			goto next;
+
+		if (!ovl_get_dirs(&config, &entries[i].lowerdir,
+				  &entries[i].lowernum,
+				  &entries[i].upperdir,
+				  &entries[i].workdir)) {
+			i++;
+			if (i % ALLOC_NUM == 0) {
+				allocated += sizeof(struct ovl_mnt_entry) * ALLOC_NUM;
+				entries = srealloc(entries, allocated);
+			}
+		}
+next:
+		ovl_free_opt(&config);
+		free(opt);
+	}
+
+	*ovl_mnt_entries = entries;
+	*ovl_mnt_count = i;
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
+		free(ovl_mnt_entries[i].upperdir);
+		free(ovl_mnt_entries[i].workdir);
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
+ * FIXME: We cannot distinguish mounted directories if overlayfs was
+ *        mounted use relative path, so there may have misjudgment.
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
+		if (upperdir && ovl_mnt_entries[i].upperdir &&
+		    !(strcmp(upperdir, ovl_mnt_entries[i].upperdir))) {
+			mounted_path = upperdir;
+			*mounted = true;
+			goto out;
+		}
+
+		/* Check worker */
+		if (workdir && ovl_mnt_entries[i].workdir &&
+		    !(strcmp(workdir, ovl_mnt_entries[i].workdir))) {
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
index 0000000..2cf5e6a
--- /dev/null
+++ b/mount.h
@@ -0,0 +1,34 @@
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
+int ovl_check_mount(bool *mounted);
+
+#endif /* OVL_MOUNT_H */
diff --git a/path.c b/path.c
new file mode 100644
index 0000000..e293217
--- /dev/null
+++ b/path.c
@@ -0,0 +1,78 @@
+/*
+ * path.c - path manipulation
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
+#include <string.h>
+
+char *joinname(const char *path, const char *name)
+{
+	int lenp = strlen(path);
+	int lenn = strlen(name);
+	int len;
+	int slash = 0;
+	char *str;
+
+	if (path[0] == '.' && lenp == 1)
+		lenp = 0;
+	if (name[0] == '.' && lenn == 1)
+		lenn = 0;
+
+	len = lenp + lenn + 1;
+	if ((lenp > 0) && (path[lenp-1] != '/') &&
+	    (lenn > 0) && (name[0] != '/')) {
+		slash = 1;
+		len++;
+	}
+
+	str = malloc(len);
+	if (!str)
+		goto out;
+
+	memcpy(str, path, lenp);
+	if (slash) {
+		str[lenp] = '/';
+		lenp++;
+	}
+	memcpy(str+lenp, name, lenn+1);
+out:
+	return str;
+}
+
+char *basename2(const char *path, const char *dir)
+{
+	static const char dot[] = ".";
+	int lend = strlen(dir);
+	const char *str;
+
+	if (dir[0] == '.')
+		lend = 0;
+
+	if (lend > 0 && (dir[lend-1] == '/'))
+		lend--;
+
+	if (!strncmp(path, dir, lend)) {
+		for (str = path + lend; *str == '/'; str++);
+		if (str[0] == '\0')
+			str = dot;
+		return (char *)str;
+	} else {
+		return (char *)path;
+	}
+}
diff --git a/path.h b/path.h
new file mode 100644
index 0000000..9ca5d36
--- /dev/null
+++ b/path.h
@@ -0,0 +1,24 @@
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
+#ifndef OVL_PATH_H
+#define OVL_PATH_H
+
+char *joinname(const char *path, const char *name);
+char *basename2(const char *path, const char *dir);
+
+#endif /* OVL_PATH_H */
-- 
2.9.5

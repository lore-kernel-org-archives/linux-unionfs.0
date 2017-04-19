From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/4] src/open_by_handle: program to exercise open_by_handle_at() syscall
Date: Wed, 19 Apr 2017 19:29:17 +0300
Message-ID: <1492619359-24763-3-git-send-email-amir73il@gmail.com>
References: <1492619359-24763-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33409 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937977AbdDSQ3N (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 12:29:13 -0400
In-Reply-To: <1492619359-24763-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

This is a clone of src/stale_handle.c test that uses generic
open_by_handle_at() syscall instead of the xfs specific ioctl.

No test is using this program yet.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .gitignore           |   1 +
 aclocal.m4           |  15 ++++++
 configure.ac         |   1 +
 include/builddefs.in |   1 +
 src/Makefile         |   4 ++
 src/open_by_handle.c | 143 +++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 165 insertions(+)
 create mode 100644 src/open_by_handle.c

diff --git a/.gitignore b/.gitignore
index 0336555..ded4a61 100644
--- a/.gitignore
+++ b/.gitignore
@@ -80,6 +80,7 @@
 /src/multi_open_unlink
 /src/nametest
 /src/nsexec
+/src/open_by_handle
 /src/permname
 /src/preallo_rw_pattern_reader
 /src/preallo_rw_pattern_writer
diff --git a/aclocal.m4 b/aclocal.m4
index f3412e1..829fa10 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -37,6 +37,21 @@ AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
       [ have_fallocate=false; AC_MSG_RESULT(no) ])
     AC_SUBST(have_fallocate)
   ])
+
+AC_DEFUN([AC_PACKAGE_WANT_OPEN_BY_HANDLE_AT],
+  [ AC_MSG_CHECKING([for open_by_handle_at])
+    AC_TRY_LINK([
+#define _GNU_SOURCE
+#include <fcntl.h>
+      ],
+      [
+          struct file_handle fh;
+          open_by_handle_at(0, &fh, 0);
+      ],
+      [ have_open_by_handle_at=true; AC_MSG_RESULT(yes) ],
+      [ have_open_by_handle_at=false; AC_MSG_RESULT(no) ])
+    AC_SUBST(have_open_by_handle_at)
+  ])
 m4_include([m4/multilib.m4])
 m4_include([m4/package_acldev.m4])
 m4_include([m4/package_aiodev.m4])
diff --git a/configure.ac b/configure.ac
index 246f92e..1285bf4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -75,6 +75,7 @@ in
 		AC_PACKAGE_WANT_DMAPI
 		AC_PACKAGE_WANT_LINUX_FIEMAP_H
 		AC_PACKAGE_WANT_FALLOCATE
+		AC_PACKAGE_WANT_OPEN_BY_HANDLE_AT
 		AC_PACKAGE_WANT_LINUX_PRCTL_H
 		AC_PACKAGE_WANT_LINUX_FS_H
 		AC_PACKAGE_WANT_SSL
diff --git a/include/builddefs.in b/include/builddefs.in
index 24f838f..2725037 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -61,6 +61,7 @@ ENABLE_SHARED = @enable_shared@
 HAVE_DB = @have_db@
 HAVE_AIO = @have_aio@
 HAVE_FALLOCATE = @have_fallocate@
+HAVE_OPEN_BY_HANDLE_AT = @have_open_by_handle_at@
 HAVE_SSL = @have_ssl@
 HAVE_DMAPI = @have_dmapi@
 HAVE_ATTR_LIST = @have_attr_list@
diff --git a/src/Makefile b/src/Makefile
index 247383c..abfd873 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -36,6 +36,10 @@ ifeq ($(HAVE_FIEMAP), true)
 LINUX_TARGETS += fiemap-tester
 endif
 
+ifeq ($(HAVE_OPEN_BY_HANDLE_AT), true)
+LINUX_TARGETS += open_by_handle
+endif
+
 ifeq ($(HAVE_FALLOCATE), true)
 LCFLAGS += -DHAVE_FALLOCATE
 endif
diff --git a/src/open_by_handle.c b/src/open_by_handle.c
new file mode 100644
index 0000000..76510ff
--- /dev/null
+++ b/src/open_by_handle.c
@@ -0,0 +1,143 @@
+/*
+ * open_by_handle.c - attempt to create a file handle and open it
+ *                    with open_by_handle_at() syscall
+ *
+ * Copyright (C) 2017 CTERA Networks. All Rights Reserved.
+ * Author: Amir Goldstein <amir73il@gmail.com>
+ *
+ * from:
+ *  stale_handle.c
+ *
+ *  Copyright (C) 2010 Red Hat, Inc. All Rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <errno.h>
+#include <linux/limits.h>
+
+#define NUMFILES 1024
+
+struct handle {
+	struct file_handle fh;
+	unsigned char fid[MAX_HANDLE_SZ];
+} handle[NUMFILES];
+
+int main(int argc, char **argv)
+{
+	int	i;
+	int	fd;
+	int	ret;
+	int	failed = 0;
+	char	fname[PATH_MAX];
+	char	*test_dir;
+	int	mount_fd, mount_id;
+
+	if (argc != 2) {
+		fprintf(stderr, "usage: open_by_handle <test_dir>\n");
+		return EXIT_FAILURE;
+	}
+
+	test_dir = argv[1];
+	mount_fd = open(test_dir, O_RDONLY|O_DIRECTORY);
+	if (mount_fd < 0) {
+		perror("open test_dir");
+		return EXIT_FAILURE;
+	}
+
+	/*
+	 * create a large number of files to force allocation of new inode
+	 * chunks on disk.
+	 */
+	for (i=0; i < NUMFILES; i++) {
+		sprintf(fname, "%s/file%06d", test_dir, i);
+		fd = open(fname, O_RDWR | O_CREAT | O_TRUNC, 0644);
+		if (fd < 0) {
+			printf("Warning (%s,%d), open(%s) failed.\n", __FILE__, __LINE__, fname);
+			perror(fname);
+			return EXIT_FAILURE;
+		}
+		close(fd);
+	}
+
+	/* sync to get the new inodes to hit the disk */
+	sync();
+
+	/* create the handles */
+	for (i=0; i < NUMFILES; i++) {
+		sprintf(fname, "%s/file%06d", test_dir, i);
+		handle[i].fh.handle_bytes = MAX_HANDLE_SZ;
+		ret = name_to_handle_at(AT_FDCWD, fname, &handle[i].fh, &mount_id, 0);
+		if (ret < 0) {
+			perror("name_to_handle");
+			return EXIT_FAILURE;
+		}
+	}
+
+	/* unlink the files */
+	for (i=0; i < NUMFILES; i++) {
+		sprintf(fname, "%s/file%06d", test_dir, i);
+		ret = unlink(fname);
+		if (ret < 0) {
+			perror("unlink");
+			return EXIT_FAILURE;
+		}
+	}
+
+	/* sync to get log forced for unlink transactions to hit the disk */
+	sync();
+
+	/* sync once more FTW */
+	sync();
+
+	/*
+	 * now drop the caches so that unlinked inodes are reclaimed and
+	 * buftarg page cache is emptied so that the inode cluster has to be
+	 * fetched from disk again for the open_by_handle() call.
+	 */
+	ret = system("echo 3 > /proc/sys/vm/drop_caches");
+	if (ret < 0) {
+		perror("drop_caches");
+		return EXIT_FAILURE;
+	}
+
+	/*
+	 * now try to open the files by the stored handles. Expecting ENOENT
+	 * for all of them.
+	 */
+	for (i=0; i < NUMFILES; i++) {
+		errno = 0;
+		fd = open_by_handle_at(mount_fd, &handle[i].fh, O_RDWR);
+		if (fd < 0 && (errno == ENOENT || errno == ESTALE)) {
+			continue;
+		}
+		if (fd >= 0) {
+			printf("open_by_handle(%d) opened an unlinked file!\n", i);
+			close(fd);
+		} else
+			printf("open_by_handle(%d) returned %d incorrectly on an unlinked file!\n", i, errno);
+		failed++;
+	}
+	if (failed)
+		return EXIT_FAILURE;
+	return EXIT_SUCCESS;
+}
-- 
2.7.4

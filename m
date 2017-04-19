From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/4] fstests: remove IRIX test program open_unlink
Date: Wed, 19 Apr 2017 19:29:16 +0300
Message-ID: <1492619359-24763-2-git-send-email-amir73il@gmail.com>
References: <1492619359-24763-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32842 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937939AbdDSQ3M (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 12:29:12 -0400
In-Reply-To: <1492619359-24763-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

It does not seem to be used by any test.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/Makefile      |   3 --
 src/open_unlink.c | 147 ------------------------------------------------------
 2 files changed, 150 deletions(-)
 delete mode 100644 src/open_unlink.c

diff --git a/src/Makefile b/src/Makefile
index e62d7a9..247383c 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -40,14 +40,11 @@ ifeq ($(HAVE_FALLOCATE), true)
 LCFLAGS += -DHAVE_FALLOCATE
 endif
 
-IRIX_TARGETS = open_unlink
-
 ifeq ($(PKG_PLATFORM),linux)
 TARGETS += $(LINUX_TARGETS)
 endif
 
 ifeq ($(PKG_PLATFORM),irix)
-TARGETS += $(IRIX_TARGETS)
 LLDLIBS += -lgen
 endif
 
diff --git a/src/open_unlink.c b/src/open_unlink.c
deleted file mode 100644
index 9f83929..0000000
--- a/src/open_unlink.c
+++ /dev/null
@@ -1,147 +0,0 @@
-/*
- * Copyright (c) 2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include <stdlib.h>
-#include <stdio.h>
-#include <unistd.h>
-#include <string.h>
-#include <errno.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <sys/attributes.h>
-#include <sys/fs/xfs_itable.h>
-
-#ifndef ATTR_PARENT
-#define ATTR_PARENT 0x0040
-#endif
-
-#define EA_LISTBUF_SZ 16384
-
-int
-main(int argc, char *argv[])
-{
-	char *path;
-	int fd;
-	char *prog = argv[0];
-	void *handle;
-	size_t hlen;
-	attrlist_cursor_t cursor;
-	attrlist_t *ea_listbuf = (attrlist_t *)malloc(EA_LISTBUF_SZ);
-	uint64_t parent_ino;
-	uint64_t link_cnt;
-	int sts;
-	int nameix;
-	attrlist_ent_t *entp;
-
-	if (argc < 2) {
-		fprintf(stderr, "%s: missing pathname argument\n", prog);
-		return 1;
-	}
-	path = argv[1];
-
-	if (argc > 2) {
-		fprintf(stderr, "%s: too many arguments\n", prog);
-		return 1;
-	}
-
-	/* if file already exists then error out */
-	if (access(path, F_OK) == 0) {
-		fprintf(stderr, "%s: file \"%s\" already exists\n", prog, path);
-		return 1;
-	}
-
-	fd = open(path, O_RDWR|O_CREAT|O_EXCL);
-	if (fd == -1) {
-		fprintf(stderr, "%s: failed to create \"%s\": %s\n", prog, path, strerror(errno));
-		return 1;
-	}
-
-
-	/* for linux libhandle version - to set libhandle fsfd cache */
-	{
-		void *fshandle;
-		size_t fshlen;
-
-		if (path_to_fshandle(path, &fshandle, &fshlen) != 0) {
-			fprintf(stderr, "%s: failed path_to_fshandle \"%s\": %s\n",
-				prog, path, strerror(errno));
-			return 1;
-		}
-	}
-
-
-	/* 
-	 * look at parentptr EAs and see if the path exists now that
-	 * it has been unlinked.
-	 */ 
-	if (fd_to_handle(fd, &handle, &hlen) != 0) {
-		fprintf(stderr, "%s: failed to fd_to_handle \"%s\": %s\n",
-			prog, path, strerror(errno));
-		return 1;
-	}
-
-	if (unlink(path) == -1) {
-		fprintf(stderr, "%s: failed to unlink \"%s\": %s\n", prog, path, strerror(errno));
-		return 1;
-	}
-
-	memset(&cursor, 0, sizeof(cursor));
-
-	/* just do one call - don't bother with continue logic */
-	sts = attr_list_by_handle(handle,
-			hlen,
-			(char*)ea_listbuf,
-			EA_LISTBUF_SZ,
-			ATTR_PARENT,
-			&cursor);
-	if (sts != 0) {
-		fprintf(stderr, "%s: failed to list attr for \"%s\": %s\n", prog, path, strerror(errno));
-		return 1;
-	}
-
-	printf("ea count = %d\n", ea_listbuf->al_count);
-
-	/*
-	 * process EA list
-	 */
-	for (nameix = 0; nameix < ea_listbuf->al_count; nameix++) {
-		entp = ATTR_ENTRY(ea_listbuf, nameix);
-
-		sts = sscanf(entp->a_name, "%llx %llx", &parent_ino, &link_cnt);
-		if (sts != 2) {
-			fprintf(stderr,
-				"inode-path for \"%s\" is corrupted\n",
-				path);
-
-			/* go onto next EA name */
-			continue;
-		}
-		/* just print the info out */
-		printf("[%d] parent_ino = %llu, link_cnt = %llu\n", nameix, parent_ino, link_cnt);
-	}
-
-
-	free_handle(handle, hlen);
-
-	if (close(fd) == -1) {
-		fprintf(stderr, "%s: failed to close \"%s\": %s\n", prog, path, strerror(errno));
-		return 1;
-	}
-
-	return 0;
-}
-- 
2.7.4

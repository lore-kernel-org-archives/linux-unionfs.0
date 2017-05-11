From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/4] src/t_dir_type: support filtering by inode number
Date: Thu, 11 May 2017 09:55:07 +0300
Message-ID: <1494485710-2400-2-git-send-email-amir73il@gmail.com>
References: <1494485710-2400-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1494485710-2400-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

usage: t_dir_type <dir> <inode number>

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 doc/auxiliary-programs.txt |  7 +++++++
 src/t_dir_type.c           | 11 ++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/doc/auxiliary-programs.txt b/doc/auxiliary-programs.txt
index 2e2060a..21ef118 100644
--- a/doc/auxiliary-programs.txt
+++ b/doc/auxiliary-programs.txt
@@ -18,6 +18,7 @@ Contents:
  - af_unix		-- Create an AF_UNIX socket
  - open_by_handle	-- open_by_handle_at syscall exercise
  - stat_test		-- statx syscall exercise
+ - t_dir_type		-- print directory entries and their file type
  - xfs_io		-- General I/O operation exercise
 
 
@@ -48,6 +49,12 @@ stat_test
 		_require_statx
 
 
+t_dir_type
+
+	The t_dir_type program exercises the getdents64() system call.
+	It prints directory entry names returned from getdents64() and
+	thier d_type, optionally filtered by type or by inode number.
+
 xfs_io
 
 	The xfs_io program can be found in the xfsprogs package and can be used
diff --git a/src/t_dir_type.c b/src/t_dir_type.c
index 344bef8..76aaa9b 100644
--- a/src/t_dir_type.c
+++ b/src/t_dir_type.c
@@ -19,9 +19,10 @@
 /*
  * t_dir_type
  *
- * print directory entries, optionally filtered by d_type
+ * print directory entries and their file type, optionally filtered by d_type
+ * or by inode number.
  *
- * ./t_dir_type <path> [u|f|d|c|b|l|p|s|w]
+ * ./t_dir_type <path> [u|f|d|c|b|l|p|s|w|<ino>]
  */
 
 #include <fcntl.h>
@@ -67,6 +68,7 @@ main(int argc, char *argv[])
 	struct linux_dirent64 *d;
 	int bpos;
 	int type = -1; /* -1 means all types */
+	uint64_t ino = 0;
 	int ret = 1;
 
 	fd = open(argv[1], O_RDONLY | O_DIRECTORY);
@@ -82,6 +84,8 @@ main(int argc, char *argv[])
 			if (DT_CHAR(type) == t)
 				break;
 		/* no match ends up with type = -1 */
+		if (type < 0)
+			ino = atoll(argv[2]);
 	}
 
 	for ( ; ; ) {
@@ -96,7 +100,8 @@ main(int argc, char *argv[])
 
 		for (bpos = 0; bpos < nread;) {
 			d = (struct linux_dirent64 *) (buf + bpos);
-			if (type < 0 || type == (int)d->d_type) {
+			if ((type < 0 || type == (int)d->d_type) &&
+			    (!ino || ino == d->d_ino)) {
 				ret = 0;
 				printf("%s %c\n", d->d_name, DT_CHAR(d->d_type));
 			}
-- 
2.7.4

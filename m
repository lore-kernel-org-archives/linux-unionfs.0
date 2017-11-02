From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/7] open_by_handle: test directory file handle
Date: Thu,  2 Nov 2017 12:15:36 +0200
Message-ID: <1509617739-15744-5-git-send-email-amir73il@gmail.com>
References: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

usage: open_by_handle -cp <test_dir> [N]
usage: open_by_handle  -p <test_dir> [N]
usage: open_by_handle -dp <test_dir> [N]

With -p flag, create/delete also the test_dir itself and try to open by
handle also test_dir itself after droping caches and use dir fd to test
faccessat() of a file inside dir.
mount_fd argument to open_by_handle_at() is open fd of test_dir's parent.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/open_by_handle.c | 114 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 101 insertions(+), 13 deletions(-)

diff --git a/src/open_by_handle.c b/src/open_by_handle.c
index 581dc05..e8edcf5 100644
--- a/src/open_by_handle.c
+++ b/src/open_by_handle.c
@@ -27,13 +27,13 @@
 
 /*
 
-usage: open_by_handle [-cludmrwa] <test_dir> [num_files]
+usage: open_by_handle [-cludmrwap] <test_dir> [num_files]
 
 Examples:
 
-1. Create test set of N files and try to get their NFS handles:
+1. Create test set of of test_dir with N files and try to get their NFS handles:
 
-   open_by_handle -c <test_dir> [N]
+   open_by_handle -cp <test_dir> [N]
 
    This is used by new helper _require_exportfs() to check
    if filesystem supports exportfs
@@ -41,7 +41,7 @@ Examples:
 2. Get file handles for existing test set, drop caches and try to
    open all files by handle:
 
-   open_by_handle <test_dir> [N]
+   open_by_handle -p <test_dir> [N]
 
 3. Get file handles for existing test set, write data to files,
    drop caches, open all files by handle, read and verify written
@@ -50,9 +50,10 @@ Examples:
    open_by_handle -rwa <test_dir> [N]
 
 4. Get file handles for existing test set, unlink all test files,
-   drop caches, try to open all files by handle and expect ESTALE:
+   remove test_dir, drop caches, try to open all files by handle
+   and expect ESTALE:
 
-   open_by_handle -d <test_dir> [N]
+   open_by_handle -dp <test_dir> [N]
 
 5. Get file handles for existing test set, rename all test files,
    drop caches, try to open all files by handle (should work):
@@ -85,17 +86,18 @@ Examples:
 #include <sys/types.h>
 #include <errno.h>
 #include <linux/limits.h>
+#include <libgen.h>
 
 #define MAXFILES 1024
 
 struct handle {
 	struct file_handle fh;
 	unsigned char fid[MAX_HANDLE_SZ];
-} handle[MAXFILES];
+} handle[MAXFILES], dir_handle;
 
 void usage(void)
 {
-	fprintf(stderr, "usage: open_by_handle [-cludmrwa] <test_dir> [num_files]\n");
+	fprintf(stderr, "usage: open_by_handle [-cludmrwap] <test_dir> [num_files]\n");
 	fprintf(stderr, "\n");
 	fprintf(stderr, "open_by_handle -c <test_dir> [N] - create N test files under test_dir, try to get file handles and exit\n");
 	fprintf(stderr, "open_by_handle    <test_dir> [N] - get file handles of test files, drop caches and try to open by handle\n");
@@ -106,6 +108,7 @@ void usage(void)
 	fprintf(stderr, "open_by_handle -u <test_dir> [N] - unlink (hardlinked) test files, drop caches and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -d <test_dir> [N] - unlink test files and hardlinks, drop caches and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -m <test_dir> [N] - rename test files, drop caches and try to open by handle\n");
+	fprintf(stderr, "open_by_handle -p <test_dir>     - create/delete and try to open by handle also test_dir itself\n");
 	exit(EXIT_FAILURE);
 }
 
@@ -113,20 +116,22 @@ int main(int argc, char **argv)
 {
 	int	i, c;
 	int	fd;
-	int	ret;
+	int	ret = 0;
 	int	failed = 0;
+	char	dname[PATH_MAX];
 	char	fname[PATH_MAX];
 	char	fname2[PATH_MAX];
 	char	*test_dir;
+	char	*mount_dir;
 	int	mount_fd, mount_id;
 	int	numfiles = 1;
 	int	create = 0, delete = 0, nlink = 1, move = 0;
-	int	rd = 0, wr = 0, wrafter = 0;
+	int	rd = 0, wr = 0, wrafter = 0, parent = 0;
 
 	if (argc < 2 || argc > 4)
 		usage();
 
-	while ((c = getopt(argc, argv, "cludmrwa")) != -1) {
+	while ((c = getopt(argc, argv, "cludmrwap")) != -1) {
 		switch (c) {
 		case 'c':
 			create = 1;
@@ -157,6 +162,9 @@ int main(int argc, char **argv)
 		case 'm':
 			move = 1;
 			break;
+		case 'p':
+			parent = 1;
+			break;
 		default:
 			fprintf(stderr, "illegal option '%s'\n", argv[optind]);
 		case 'h':
@@ -173,9 +181,27 @@ int main(int argc, char **argv)
 		usage();
 	}
 
-	mount_fd = open(test_dir, O_RDONLY|O_DIRECTORY);
+	if (parent) {
+		strcpy(dname, test_dir);
+		/*
+		 * -p flag implies that test_dir is NOT a mount point,
+		 * so its parent can be used as mount_fd for open_by_handle_at.
+		 */
+		mount_dir = dirname(dname);
+		if (create)
+			ret = mkdir(test_dir, 0700);
+		if (ret < 0 && errno != EEXIST) {
+			strcat(dname, ": mkdir");
+			perror(dname);
+			return EXIT_FAILURE;
+		}
+	} else {
+		mount_dir = test_dir;
+	}
+
+	mount_fd = open(mount_dir, O_RDONLY|O_DIRECTORY);
 	if (mount_fd < 0) {
-		perror(test_dir);
+		perror(mount_dir);
 		return EXIT_FAILURE;
 	}
 
@@ -216,6 +242,16 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (parent) {
+		dir_handle.fh.handle_bytes = MAX_HANDLE_SZ;
+		ret = name_to_handle_at(AT_FDCWD, test_dir, &dir_handle.fh, &mount_id, 0);
+		if (ret < 0) {
+			strcat(dname, ": name_to_handle");
+			perror(dname);
+			return EXIT_FAILURE;
+		}
+	}
+
 	/* write data to files */
 	for (i=0; wr && i < numfiles; i++) {
 		sprintf(fname, "%s/file%06d", test_dir, i);
@@ -281,6 +317,15 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (parent && delete && !nlink) {
+		ret = rmdir(test_dir);
+		if (ret < 0) {
+			strcat(dname, ": rmdir");
+			perror(dname);
+			return EXIT_FAILURE;
+		}
+	}
+
 	/* sync to get log forced for unlink transactions to hit the disk */
 	sync();
 
@@ -339,6 +384,49 @@ int main(int argc, char **argv)
 		}
 		failed++;
 	}
+
+	if (parent) {
+		fd = open_by_handle_at(mount_fd, &dir_handle.fh, O_RDONLY|O_DIRECTORY);
+		if (fd >= 0) {
+			if (!nlink) {
+				printf("open_by_handle(%s) opened an unlinked dir!\n", dname);
+				return EXIT_FAILURE;
+			} else {
+				/*
+				 * Sanity check dir fd - expect to access orig file IFF
+				 * it was not unlinked nor renamed.
+				 */
+				strcpy(fname, "file000000");
+				ret = faccessat(fd, fname, F_OK, 0);
+				if ((ret == 0) != (!delete && !move) ||
+				    ((ret < 0) && errno != ENOENT)) {
+					strcat(fname, ": unexpected result from faccessat");
+					perror(fname);
+					return EXIT_FAILURE;
+				}
+				/*
+				 * Expect to access link file if ran test with -l flag
+				 * (nlink > 1), -m flag (orig moved to link name) or
+				 * -u flag (which implied previous -l run).
+				 */
+				strcpy(fname2, "link000000");
+				ret = faccessat(fd, fname2, F_OK, 0);
+				if (ret < 0 && (nlink > 1 || delete || move ||
+						errno != ENOENT)) {
+					strcat(fname2, ": unexpected result from faccessat");
+					perror(fname2);
+					return EXIT_FAILURE;
+				}
+			}
+			close(fd);
+		} else if (nlink || !(errno == ENOENT || errno == ESTALE)) {
+			printf("open_by_handle(%s) returned %d incorrectly on %s dir!\n",
+					dname, errno,
+					nlink ? "a linked" : "an unlinked");
+			return EXIT_FAILURE;
+		}
+	}
+
 	if (failed)
 		return EXIT_FAILURE;
 	return EXIT_SUCCESS;
-- 
2.7.4

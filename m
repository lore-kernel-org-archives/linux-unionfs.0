From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5/7] open_by_handle: test file handles of open files
Date: Thu,  2 Nov 2017 12:15:37 +0200
Message-ID: <1509617739-15744-6-git-send-email-amir73il@gmail.com>
References: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

usage: open_by_handle -dk <test_dir> [N]

Get file handles for existing test set, keep open file handles for all
test files, unlink all test files, drop caches and try to open all files
by handle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/open_by_handle.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/src/open_by_handle.c b/src/open_by_handle.c
index e8edcf5..dbc5b0f 100644
--- a/src/open_by_handle.c
+++ b/src/open_by_handle.c
@@ -27,7 +27,7 @@
 
 /*
 
-usage: open_by_handle [-cludmrwap] <test_dir> [num_files]
+usage: open_by_handle [-cludmrwapk] <test_dir> [num_files]
 
 Examples:
 
@@ -55,12 +55,18 @@ Examples:
 
    open_by_handle -dp <test_dir> [N]
 
-5. Get file handles for existing test set, rename all test files,
+5. Get file handles for existing test set, keep open file handles for all
+   test files, unlink all test files, drop caches and try to open all files
+   by handle (should work):
+
+   open_by_handle -dk <test_dir> [N]
+
+6. Get file handles for existing test set, rename all test files,
    drop caches, try to open all files by handle (should work):
 
    open_by_handle -m <test_dir> [N]
 
-6. Get file handles for existing test set, hardlink all test files,
+7. Get file handles for existing test set, hardlink all test files,
    then unlink the original files, drop caches and try to open all
    files by handle (should work):
 
@@ -97,10 +103,11 @@ struct handle {
 
 void usage(void)
 {
-	fprintf(stderr, "usage: open_by_handle [-cludmrwap] <test_dir> [num_files]\n");
+	fprintf(stderr, "usage: open_by_handle [-cludmrwapk] <test_dir> [num_files]\n");
 	fprintf(stderr, "\n");
 	fprintf(stderr, "open_by_handle -c <test_dir> [N] - create N test files under test_dir, try to get file handles and exit\n");
 	fprintf(stderr, "open_by_handle    <test_dir> [N] - get file handles of test files, drop caches and try to open by handle\n");
+	fprintf(stderr, "open_by_handle -k <test_dir> [N] - get file handles of files that are kept open, drop caches and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -w <test_dir> [N] - write data to test files before open by handle\n");
 	fprintf(stderr, "open_by_handle -r <test_dir> [N] - read data from test files after open by handle and verify written data\n");
 	fprintf(stderr, "open_by_handle -a <test_dir> [N] - write data to test files after open by handle\n");
@@ -127,11 +134,12 @@ int main(int argc, char **argv)
 	int	numfiles = 1;
 	int	create = 0, delete = 0, nlink = 1, move = 0;
 	int	rd = 0, wr = 0, wrafter = 0, parent = 0;
+	int	keepopen = 0;
 
 	if (argc < 2 || argc > 4)
 		usage();
 
-	while ((c = getopt(argc, argv, "cludmrwap")) != -1) {
+	while ((c = getopt(argc, argv, "cludmrwapk")) != -1) {
 		switch (c) {
 		case 'c':
 			create = 1;
@@ -165,6 +173,9 @@ int main(int argc, char **argv)
 		case 'p':
 			parent = 1;
 			break;
+		case 'k':
+			keepopen = 1;
+			break;
 		default:
 			fprintf(stderr, "illegal option '%s'\n", argv[optind]);
 		case 'h':
@@ -213,7 +224,7 @@ int main(int argc, char **argv)
 		sprintf(fname2, "%s/link%06d", test_dir, i);
 		fd = open(fname, O_RDWR | O_CREAT | O_TRUNC, 0644);
 		if (fd < 0) {
-			strcat(fname, ": open");
+			strcat(fname, ": open(O_CREAT)");
 			perror(fname);
 			return EXIT_FAILURE;
 		}
@@ -240,6 +251,15 @@ int main(int argc, char **argv)
 			perror(fname);
 			return EXIT_FAILURE;
 		}
+		if (keepopen) {
+			/* Open without close to keep unlinked files around */
+			fd = open(fname, O_RDONLY);
+			if (fd < 0) {
+				strcat(fname, ": open(O_RDONLY)");
+				perror(fname);
+				return EXIT_FAILURE;
+			}
+		}
 	}
 
 	if (parent) {
@@ -350,7 +370,7 @@ int main(int argc, char **argv)
 	for (i=0; i < numfiles; i++) {
 		errno = 0;
 		fd = open_by_handle_at(mount_fd, &handle[i].fh, wrafter ? O_RDWR : O_RDONLY);
-		if (nlink && fd >= 0) {
+		if ((nlink || keepopen) && fd >= 0) {
 			if (rd) {
 				char buf[4] = {0};
 				int size = read(fd, buf, 4);
@@ -370,7 +390,7 @@ int main(int argc, char **argv)
 			}
 			close(fd);
 			continue;
-		} else if (!nlink && fd < 0 && (errno == ENOENT || errno == ESTALE)) {
+		} else if (!nlink && !keepopen && fd < 0 && (errno == ENOENT || errno == ESTALE)) {
 			continue;
 		}
 		sprintf(fname, "%s/file%06d", test_dir, i);
@@ -378,9 +398,10 @@ int main(int argc, char **argv)
 			printf("open_by_handle(%s) opened an unlinked file!\n", fname);
 			close(fd);
 		} else {
-			printf("open_by_handle(%s) returned %d incorrectly on %s file!\n",
+			printf("open_by_handle(%s) returned %d incorrectly on %s%s file!\n",
 					fname, errno,
-					nlink ? "a linked" : "an unlinked");
+					nlink ? "a linked" : "an unlinked",
+					keepopen ? " open" : "");
 		}
 		failed++;
 	}
-- 
2.7.4

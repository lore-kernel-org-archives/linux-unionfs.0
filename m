Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 4/5] open_by_handle: add -s option to sleep and keep files open by handle
Date: Thu, 29 Mar 2018 15:06:49 +0300
Message-Id: <1522325210-17900-5-git-send-email-amir73il@gmail.com>
In-Reply-To: <1522325210-17900-1-git-send-email-amir73il@gmail.com>
References: <1522325210-17900-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

This feature is needed for tests that need to open file by handle and
then perform operations while that file is open. This will be used by
an overlay test to keep disconnected dentries in dcache.

Usage: open_by_handle -s <test_dir>

On success, the program will run until it gets a terminating signal.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/open_by_handle.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/src/open_by_handle.c b/src/open_by_handle.c
index d3beb78..f5be235 100644
--- a/src/open_by_handle.c
+++ b/src/open_by_handle.c
@@ -27,7 +27,7 @@
 
 /*
 
-usage: open_by_handle [-cludmrwapknh] [<-i|-o> <handles_file>] <test_dir> [num_files]
+usage: open_by_handle [-cludmrwapknhs] [<-i|-o> <handles_file>] <test_dir> [num_files]
 
 Examples:
 
@@ -48,9 +48,9 @@ Examples:
    open_by_handle -p -o <handles_file> <test_dir> [N]
 
 4. Read file handles from file and open files by handle without
-   dropping caches beforehand:
+   dropping caches beforehand. Sleep afterhand to keep files open:
 
-   open_by_handle -np -i <handles_file> <test_dir> [N]
+   open_by_handle -nps -i <handles_file> <test_dir> [N]
 
 5. Get file handles for existing test set, write data to files,
    drop caches, open all files by handle, read and verify written
@@ -112,7 +112,7 @@ struct handle {
 
 void usage(void)
 {
-	fprintf(stderr, "usage: open_by_handle [-cludmrwapknh] [<-i|-o> <handles_file>] <test_dir> [num_files]\n");
+	fprintf(stderr, "usage: open_by_handle [-cludmrwapknhs] [<-i|-o> <handles_file>] <test_dir> [num_files]\n");
 	fprintf(stderr, "\n");
 	fprintf(stderr, "open_by_handle -c <test_dir> [N] - create N test files under test_dir, try to get file handles and exit\n");
 	fprintf(stderr, "open_by_handle    <test_dir> [N] - get file handles of test files, drop caches and try to open by handle\n");
@@ -128,6 +128,7 @@ void usage(void)
 	fprintf(stderr, "open_by_handle -p <test_dir>     - create/delete and try to open by handle also test_dir itself\n");
 	fprintf(stderr, "open_by_handle -i <handles_file> <test_dir> [N] - read test files handles from file and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -o <handles_file> <test_dir> [N] - get file handles of test files and write handles to file\n");
+	fprintf(stderr, "open_by_handle -s <test_dir> [N] - wait in sleep loop after opening files by handle to keep them open\n");
 	exit(EXIT_FAILURE);
 }
 
@@ -148,12 +149,12 @@ int main(int argc, char **argv)
 	int	numfiles = 1;
 	int	create = 0, delete = 0, nlink = 1, move = 0;
 	int	rd = 0, wr = 0, wrafter = 0, parent = 0;
-	int	keepopen = 0, drop_caches = 1;
+	int	keepopen = 0, drop_caches = 1, sleep_loop = 0;
 
 	if (argc < 2)
 		usage();
 
-	while ((c = getopt(argc, argv, "cludmrwapknhi:o:")) != -1) {
+	while ((c = getopt(argc, argv, "cludmrwapknhi:o:s")) != -1) {
 		switch (c) {
 		case 'c':
 			create = 1;
@@ -209,6 +210,9 @@ int main(int argc, char **argv)
 				return EXIT_FAILURE;
 			}
 			break;
+		case 's':
+			sleep_loop = 1;
+			break;
 		default:
 			fprintf(stderr, "illegal option '%s'\n", argv[optind]);
 		case 'h':
@@ -478,7 +482,8 @@ int main(int argc, char **argv)
 				perror(fname);
 				return EXIT_FAILURE;
 			}
-			close(fd);
+			if (!sleep_loop)
+				close(fd);
 			continue;
 		} else if (!nlink && !keepopen && fd < 0 && (errno == ENOENT || errno == ESTALE)) {
 			continue;
@@ -529,7 +534,8 @@ int main(int argc, char **argv)
 					return EXIT_FAILURE;
 				}
 			}
-			close(fd);
+			if (!sleep_loop)
+				close(fd);
 		} else if (nlink || !(errno == ENOENT || errno == ESTALE)) {
 			printf("open_by_handle(%s) returned %d incorrectly on %s dir!\n",
 					dname, errno,
@@ -540,5 +546,13 @@ int main(int argc, char **argv)
 
 	if (failed)
 		return EXIT_FAILURE;
+
+	/*
+	 * Sleep keeping files open by handle - the program need to be killed
+	 * to release the open files.
+	 */
+	while (sleep_loop)
+		sleep(1);
+
 	return EXIT_SUCCESS;
 }
-- 
2.7.4

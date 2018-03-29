Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/5] open_by_handle: add -n option to suppress drop caches
Date: Thu, 29 Mar 2018 15:06:48 +0300
Message-Id: <1522325210-17900-4-git-send-email-amir73il@gmail.com>
In-Reply-To: <1522325210-17900-1-git-send-email-amir73il@gmail.com>
References: <1522325210-17900-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

By default, open_by_handle drops inode and page caches before trying
to open by file handles. Add an option to suppress drop caches for
testing open by handle with warm caches.

Usage: open_by_handle -n <test_dir> [N]

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/open_by_handle.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/src/open_by_handle.c b/src/open_by_handle.c
index 7dfb395..d3beb78 100644
--- a/src/open_by_handle.c
+++ b/src/open_by_handle.c
@@ -27,7 +27,7 @@
 
 /*
 
-usage: open_by_handle [-cludmrwapkh] [<-i|-o> <handles_file>] <test_dir> [num_files]
+usage: open_by_handle [-cludmrwapknh] [<-i|-o> <handles_file>] <test_dir> [num_files]
 
 Examples:
 
@@ -43,36 +43,39 @@ Examples:
 
    open_by_handle -p <test_dir> [N]
 
-3. Get file handles for existing test set and write them to a file.
-   Read file handles from file and open files by handle:
+3. Get file handles for existing test set and write them to a file:
 
    open_by_handle -p -o <handles_file> <test_dir> [N]
-   open_by_handle -p -i <handles_file> <test_dir> [N]
 
-4. Get file handles for existing test set, write data to files,
+4. Read file handles from file and open files by handle without
+   dropping caches beforehand:
+
+   open_by_handle -np -i <handles_file> <test_dir> [N]
+
+5. Get file handles for existing test set, write data to files,
    drop caches, open all files by handle, read and verify written
    data, write new data to file:
 
    open_by_handle -rwa <test_dir> [N]
 
-5. Get file handles for existing test set, unlink all test files,
+6. Get file handles for existing test set, unlink all test files,
    remove test_dir, drop caches, try to open all files by handle
    and expect ESTALE:
 
    open_by_handle -dp <test_dir> [N]
 
-6. Get file handles for existing test set, keep open file handles for all
+7. Get file handles for existing test set, keep open file handles for all
    test files, unlink all test files, drop caches and try to open all files
    by handle (should work):
 
    open_by_handle -dk <test_dir> [N]
 
-7. Get file handles for existing test set, rename all test files,
+8. Get file handles for existing test set, rename all test files,
    drop caches, try to open all files by handle (should work):
 
    open_by_handle -m <test_dir> [N]
 
-8. Get file handles for existing test set, hardlink all test files,
+9. Get file handles for existing test set, hardlink all test files,
    then unlink the original files, drop caches and try to open all
    files by handle (should work):
 
@@ -109,10 +112,11 @@ struct handle {
 
 void usage(void)
 {
-	fprintf(stderr, "usage: open_by_handle [-cludmrwapkh] [<-i|-o> <handles_file>] <test_dir> [num_files]\n");
+	fprintf(stderr, "usage: open_by_handle [-cludmrwapknh] [<-i|-o> <handles_file>] <test_dir> [num_files]\n");
 	fprintf(stderr, "\n");
 	fprintf(stderr, "open_by_handle -c <test_dir> [N] - create N test files under test_dir, try to get file handles and exit\n");
 	fprintf(stderr, "open_by_handle    <test_dir> [N] - get file handles of test files, drop caches and try to open by handle\n");
+	fprintf(stderr, "open_by_handle -n <test_dir> [N] - get file handles of test files and try to open by handle without drop caches\n");
 	fprintf(stderr, "open_by_handle -k <test_dir> [N] - get file handles of files that are kept open, drop caches and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -w <test_dir> [N] - write data to test files before open by handle\n");
 	fprintf(stderr, "open_by_handle -r <test_dir> [N] - read data from test files after open by handle and verify written data\n");
@@ -144,12 +148,12 @@ int main(int argc, char **argv)
 	int	numfiles = 1;
 	int	create = 0, delete = 0, nlink = 1, move = 0;
 	int	rd = 0, wr = 0, wrafter = 0, parent = 0;
-	int	keepopen = 0;
+	int	keepopen = 0, drop_caches = 1;
 
 	if (argc < 2)
 		usage();
 
-	while ((c = getopt(argc, argv, "cludmrwapkhi:o:")) != -1) {
+	while ((c = getopt(argc, argv, "cludmrwapknhi:o:")) != -1) {
 		switch (c) {
 		case 'c':
 			create = 1;
@@ -186,6 +190,9 @@ int main(int argc, char **argv)
 		case 'k':
 			keepopen = 1;
 			break;
+		case 'n':
+			drop_caches = 0;
+			break;
 		case 'i':
 			infile = optarg;
 			in_fd = open(infile, O_RDONLY);
@@ -438,10 +445,12 @@ int main(int argc, char **argv)
 	 * buftarg page cache is emptied so that the inode cluster has to be
 	 * fetched from disk again for the open_by_handle() call.
 	 */
-	ret = system("echo 3 > /proc/sys/vm/drop_caches");
-	if (ret < 0) {
-		perror("drop_caches");
-		return EXIT_FAILURE;
+	if (drop_caches) {
+		ret = system("echo 3 > /proc/sys/vm/drop_caches");
+		if (ret < 0) {
+			perror("drop_caches");
+			return EXIT_FAILURE;
+		}
 	}
 
 	/*
-- 
2.7.4

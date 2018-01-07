From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/7] open_by_handle: store and load file handles from file
Date: Sun,  7 Jan 2018 20:07:19 +0200
Message-ID: <1515348445-1403-2-git-send-email-amir73il@gmail.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

usage:
 open_by_handle -p -o <handles_file> <test_dir> [N]
 open_by_handle -p -i <handles_file> <test_dir> [N]

This will be used to test decoding of file handles after various
file systems operations including mount cycle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/open_by_handle.c | 110 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 85 insertions(+), 25 deletions(-)

diff --git a/src/open_by_handle.c b/src/open_by_handle.c
index dbc5b0f..f9dfefc 100644
--- a/src/open_by_handle.c
+++ b/src/open_by_handle.c
@@ -43,30 +43,36 @@ Examples:
 
    open_by_handle -p <test_dir> [N]
 
-3. Get file handles for existing test set, write data to files,
+3. Get file handles for existing test set and write them to a file.
+   Read file handles from file and open files by handle:
+
+   open_by_handle -p -o <handles_file> <test_dir> [N]
+   open_by_handle -p -i <handles_file> <test_dir> [N]
+
+4. Get file handles for existing test set, write data to files,
    drop caches, open all files by handle, read and verify written
    data, write new data to file:
 
    open_by_handle -rwa <test_dir> [N]
 
-4. Get file handles for existing test set, unlink all test files,
+5. Get file handles for existing test set, unlink all test files,
    remove test_dir, drop caches, try to open all files by handle
    and expect ESTALE:
 
    open_by_handle -dp <test_dir> [N]
 
-5. Get file handles for existing test set, keep open file handles for all
+6. Get file handles for existing test set, keep open file handles for all
    test files, unlink all test files, drop caches and try to open all files
    by handle (should work):
 
    open_by_handle -dk <test_dir> [N]
 
-6. Get file handles for existing test set, rename all test files,
+7. Get file handles for existing test set, rename all test files,
    drop caches, try to open all files by handle (should work):
 
    open_by_handle -m <test_dir> [N]
 
-7. Get file handles for existing test set, hardlink all test files,
+8. Get file handles for existing test set, hardlink all test files,
    then unlink the original files, drop caches and try to open all
    files by handle (should work):
 
@@ -103,7 +109,7 @@ struct handle {
 
 void usage(void)
 {
-	fprintf(stderr, "usage: open_by_handle [-cludmrwapk] <test_dir> [num_files]\n");
+	fprintf(stderr, "usage: open_by_handle [-cludmrwapk] [<-i|-o> <handles_file>] <test_dir> [num_files]\n");
 	fprintf(stderr, "\n");
 	fprintf(stderr, "open_by_handle -c <test_dir> [N] - create N test files under test_dir, try to get file handles and exit\n");
 	fprintf(stderr, "open_by_handle    <test_dir> [N] - get file handles of test files, drop caches and try to open by handle\n");
@@ -116,6 +122,8 @@ void usage(void)
 	fprintf(stderr, "open_by_handle -d <test_dir> [N] - unlink test files and hardlinks, drop caches and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -m <test_dir> [N] - rename test files, drop caches and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -p <test_dir>     - create/delete and try to open by handle also test_dir itself\n");
+	fprintf(stderr, "open_by_handle -i <handles_file> <test_dir> [N] - read test files handles from file and try to open by handle\n");
+	fprintf(stderr, "open_by_handle -o <handles_file> <test_dir> [N] - get file handles of test files and write handles to file\n");
 	exit(EXIT_FAILURE);
 }
 
@@ -131,15 +139,16 @@ int main(int argc, char **argv)
 	char	*test_dir;
 	char	*mount_dir;
 	int	mount_fd, mount_id;
+	int	in_fd = 0, out_fd = 0;
 	int	numfiles = 1;
 	int	create = 0, delete = 0, nlink = 1, move = 0;
 	int	rd = 0, wr = 0, wrafter = 0, parent = 0;
 	int	keepopen = 0;
 
-	if (argc < 2 || argc > 4)
+	if (argc < 2)
 		usage();
 
-	while ((c = getopt(argc, argv, "cludmrwapk")) != -1) {
+	while ((c = getopt(argc, argv, "cludmrwapki:o:")) != -1) {
 		switch (c) {
 		case 'c':
 			create = 1;
@@ -176,13 +185,27 @@ int main(int argc, char **argv)
 		case 'k':
 			keepopen = 1;
 			break;
+		case 'i':
+			in_fd = open(optarg, O_RDONLY);
+			if (in_fd < 0) {
+				perror(optarg);
+				return EXIT_FAILURE;
+			}
+			break;
+		case 'o':
+			out_fd = creat(optarg, 0644);
+			if (out_fd < 0) {
+				perror(optarg);
+				return EXIT_FAILURE;
+			}
+			break;
 		default:
 			fprintf(stderr, "illegal option '%s'\n", argv[optind]);
 		case 'h':
 			usage();
 		}
 	}
-        if (optind == argc || optind > 2)
+        if (optind == argc)
             usage();
 	test_dir = argv[optind++];
 	if (optind < argc)
@@ -192,11 +215,14 @@ int main(int argc, char **argv)
 		usage();
 	}
 
-	if (parent) {
+	if (parent && !in_fd) {
 		strcpy(dname, test_dir);
 		/*
 		 * -p flag implies that test_dir is NOT a mount point,
 		 * so its parent can be used as mount_fd for open_by_handle_at.
+		 * -i flag implies that test_dir IS a mount point, because we
+		 *  are testing open by handle of dir, which may have been
+		 *  deleted or renamed.
 		 */
 		mount_dir = dirname(dname);
 		if (create)
@@ -241,15 +267,24 @@ int main(int argc, char **argv)
 	/* sync to get the new inodes to hit the disk */
 	sync();
 
-	/* create the handles */
+	/* create/read the handles */
 	for (i=0; i < numfiles; i++) {
 		sprintf(fname, "%s/file%06d", test_dir, i);
-		handle[i].fh.handle_bytes = MAX_HANDLE_SZ;
-		ret = name_to_handle_at(AT_FDCWD, fname, &handle[i].fh, &mount_id, 0);
-		if (ret < 0) {
-			strcat(fname, ": name_to_handle");
-			perror(fname);
-			return EXIT_FAILURE;
+		if (in_fd) {
+			ret = read(in_fd, (char *)&handle[i], sizeof(*handle));
+			if (ret < sizeof(*handle)) {
+				strcat(fname, ": read handle");
+				perror(fname);
+				return EXIT_FAILURE;
+			}
+		} else {
+			handle[i].fh.handle_bytes = MAX_HANDLE_SZ;
+			ret = name_to_handle_at(AT_FDCWD, fname, &handle[i].fh, &mount_id, 0);
+			if (ret < 0) {
+				strcat(fname, ": name_to_handle");
+				perror(fname);
+				return EXIT_FAILURE;
+			}
 		}
 		if (keepopen) {
 			/* Open without close to keep unlinked files around */
@@ -260,15 +295,40 @@ int main(int argc, char **argv)
 				return EXIT_FAILURE;
 			}
 		}
+		if (out_fd) {
+			ret = write(out_fd, (char *)&handle[i], sizeof(*handle));
+			if (ret < sizeof(*handle)) {
+				strcat(fname, ": write handle");
+				perror(fname);
+				return EXIT_FAILURE;
+			}
+		}
 	}
 
 	if (parent) {
-		dir_handle.fh.handle_bytes = MAX_HANDLE_SZ;
-		ret = name_to_handle_at(AT_FDCWD, test_dir, &dir_handle.fh, &mount_id, 0);
-		if (ret < 0) {
-			strcat(dname, ": name_to_handle");
-			perror(dname);
-			return EXIT_FAILURE;
+		if (in_fd) {
+			ret = read(in_fd, (char *)&dir_handle, sizeof(*handle));
+			if (ret < sizeof(*handle)) {
+				strcat(dname, ": read handle");
+				perror(dname);
+				return EXIT_FAILURE;
+			}
+		} else {
+			dir_handle.fh.handle_bytes = MAX_HANDLE_SZ;
+			ret = name_to_handle_at(AT_FDCWD, test_dir, &dir_handle.fh, &mount_id, 0);
+			if (ret < 0) {
+				strcat(dname, ": name_to_handle");
+				perror(dname);
+				return EXIT_FAILURE;
+			}
+		}
+		if (out_fd) {
+			ret = write(out_fd, (char *)&dir_handle, sizeof(*handle));
+			if (ret < sizeof(*handle)) {
+				strcat(dname, ": write handle");
+				perror(dname);
+				return EXIT_FAILURE;
+			}
 		}
 	}
 
@@ -289,8 +349,8 @@ int main(int argc, char **argv)
 		close(fd);
 	}
 
-	/* after creating test set only check that fs supports exportfs */
-	if (create)
+	/* If creating test set or saving files handles, we are done */
+	if (create || out_fd)
 		return EXIT_SUCCESS;
 
 	/* hardlink the files */
-- 
2.7.4

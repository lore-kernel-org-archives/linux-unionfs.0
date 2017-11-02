From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/7] open_by_handle: test content of open file handle
Date: Thu,  2 Nov 2017 12:15:35 +0200
Message-ID: <1509617739-15744-4-git-send-email-amir73il@gmail.com>
References: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

usage: open_by_handle -rwa <test_dir> [N]

Get file handles for existing test set, write data to files,
drop caches, open all files by handle, read data and verify old data,
write new data to files.

This is needed for testing that overlay decoded file handles are not
pointing the lower inodes after new data is already written to upper
inodes after copy up.

open_by_handle -a is needed for testing copy up of disconnected overlay
decoded file handles (to index dir).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/open_by_handle.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 63 insertions(+), 7 deletions(-)

diff --git a/src/open_by_handle.c b/src/open_by_handle.c
index 8b12df3..581dc05 100644
--- a/src/open_by_handle.c
+++ b/src/open_by_handle.c
@@ -27,7 +27,7 @@
 
 /*
 
-usage: open_by_handle [-cludm] <test_dir> [num_files]
+usage: open_by_handle [-cludmrwa] <test_dir> [num_files]
 
 Examples:
 
@@ -43,17 +43,23 @@ Examples:
 
    open_by_handle <test_dir> [N]
 
-3. Get file handles for existing test set, unlink all test files,
+3. Get file handles for existing test set, write data to files,
+   drop caches, open all files by handle, read and verify written
+   data, write new data to file:
+
+   open_by_handle -rwa <test_dir> [N]
+
+4. Get file handles for existing test set, unlink all test files,
    drop caches, try to open all files by handle and expect ESTALE:
 
    open_by_handle -d <test_dir> [N]
 
-4. Get file handles for existing test set, rename all test files,
+5. Get file handles for existing test set, rename all test files,
    drop caches, try to open all files by handle (should work):
 
    open_by_handle -m <test_dir> [N]
 
-5. Get file handles for existing test set, hardlink all test files,
+6. Get file handles for existing test set, hardlink all test files,
    then unlink the original files, drop caches and try to open all
    files by handle (should work):
 
@@ -89,10 +95,13 @@ struct handle {
 
 void usage(void)
 {
-	fprintf(stderr, "usage: open_by_handle [-cludm] <test_dir> [num_files]\n");
+	fprintf(stderr, "usage: open_by_handle [-cludmrwa] <test_dir> [num_files]\n");
 	fprintf(stderr, "\n");
 	fprintf(stderr, "open_by_handle -c <test_dir> [N] - create N test files under test_dir, try to get file handles and exit\n");
 	fprintf(stderr, "open_by_handle    <test_dir> [N] - get file handles of test files, drop caches and try to open by handle\n");
+	fprintf(stderr, "open_by_handle -w <test_dir> [N] - write data to test files before open by handle\n");
+	fprintf(stderr, "open_by_handle -r <test_dir> [N] - read data from test files after open by handle and verify written data\n");
+	fprintf(stderr, "open_by_handle -a <test_dir> [N] - write data to test files after open by handle\n");
 	fprintf(stderr, "open_by_handle -l <test_dir> [N] - create hardlinks to test files, drop caches and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -u <test_dir> [N] - unlink (hardlinked) test files, drop caches and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -d <test_dir> [N] - unlink test files and hardlinks, drop caches and try to open by handle\n");
@@ -112,15 +121,28 @@ int main(int argc, char **argv)
 	int	mount_fd, mount_id;
 	int	numfiles = 1;
 	int	create = 0, delete = 0, nlink = 1, move = 0;
+	int	rd = 0, wr = 0, wrafter = 0;
 
 	if (argc < 2 || argc > 4)
 		usage();
 
-	while ((c = getopt(argc, argv, "cludm")) != -1) {
+	while ((c = getopt(argc, argv, "cludmrwa")) != -1) {
 		switch (c) {
 		case 'c':
 			create = 1;
 			break;
+		case 'w':
+			/* Write data before open_by_handle_at() */
+			wr = 1;
+			break;
+		case 'r':
+			/* Read data after open_by_handle_at() */
+			rd = 1;
+			break;
+		case 'a':
+			/* Write data after open_by_handle_at() */
+			wrafter = 1;
+			break;
 		case 'l':
 			nlink = 2;
 			break;
@@ -194,6 +216,23 @@ int main(int argc, char **argv)
 		}
 	}
 
+	/* write data to files */
+	for (i=0; wr && i < numfiles; i++) {
+		sprintf(fname, "%s/file%06d", test_dir, i);
+		fd = open(fname, O_WRONLY, 0644);
+		if (fd < 0) {
+			strcat(fname, ": open");
+			perror(fname);
+			return EXIT_FAILURE;
+		}
+		if (write(fd, "aaaa", 4) != 4) {
+			strcat(fname, ": write before");
+			perror(fname);
+			return EXIT_FAILURE;
+		}
+		close(fd);
+	}
+
 	/* after creating test set only check that fs supports exportfs */
 	if (create)
 		return EXIT_SUCCESS;
@@ -265,8 +304,25 @@ int main(int argc, char **argv)
 	 */
 	for (i=0; i < numfiles; i++) {
 		errno = 0;
-		fd = open_by_handle_at(mount_fd, &handle[i].fh, O_RDWR);
+		fd = open_by_handle_at(mount_fd, &handle[i].fh, wrafter ? O_RDWR : O_RDONLY);
 		if (nlink && fd >= 0) {
+			if (rd) {
+				char buf[4] = {0};
+				int size = read(fd, buf, 4);
+				if (size < 0) {
+					strcat(fname, ": read");
+					perror(fname);
+					return EXIT_FAILURE;
+				}
+				if (size < 4 || memcmp(buf, "aaaa", 4)) {
+					printf("open_by_handle(%s) returned stale data '%.*s'!\n", fname, size, buf);
+				}
+			}
+			if (wrafter && write(fd, "aaaa", 4) != 4) {
+				strcat(fname, ": write after");
+				perror(fname);
+				return EXIT_FAILURE;
+			}
 			close(fd);
 			continue;
 		} else if (!nlink && fd < 0 && (errno == ENOENT || errno == ESTALE)) {
-- 
2.7.4

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/7] open_by_handle: test file handles of renamed files
Date: Thu,  2 Nov 2017 12:15:34 +0200
Message-ID: <1509617739-15744-3-git-send-email-amir73il@gmail.com>
References: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:46209 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933301AbdKBKPA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 06:15:00 -0400
In-Reply-To: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

usage: open_by_handle -m <test_dir> [N]

Get file handles for existing test set, rename all test files,
drop cache and try to open all files by handle.

This is needed for testing that overlayfs can find the upper
inode from lower file handle even when upper is not in the same
path as lower.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/open_by_handle.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/src/open_by_handle.c b/src/open_by_handle.c
index 52973c6..8b12df3 100644
--- a/src/open_by_handle.c
+++ b/src/open_by_handle.c
@@ -27,7 +27,7 @@
 
 /*
 
-usage: open_by_handle [-c|-l|-u|-d] <test_dir> [num_files]
+usage: open_by_handle [-cludm] <test_dir> [num_files]
 
 Examples:
 
@@ -48,7 +48,12 @@ Examples:
 
    open_by_handle -d <test_dir> [N]
 
-4. Get file handles for existing test set, hardlink all test files,
+4. Get file handles for existing test set, rename all test files,
+   drop caches, try to open all files by handle (should work):
+
+   open_by_handle -m <test_dir> [N]
+
+5. Get file handles for existing test set, hardlink all test files,
    then unlink the original files, drop caches and try to open all
    files by handle (should work):
 
@@ -84,13 +89,14 @@ struct handle {
 
 void usage(void)
 {
-	fprintf(stderr, "usage: open_by_handle [-c|-l|-u|-d] <test_dir> [num_files]\n");
+	fprintf(stderr, "usage: open_by_handle [-cludm] <test_dir> [num_files]\n");
 	fprintf(stderr, "\n");
 	fprintf(stderr, "open_by_handle -c <test_dir> [N] - create N test files under test_dir, try to get file handles and exit\n");
 	fprintf(stderr, "open_by_handle    <test_dir> [N] - get file handles of test files, drop caches and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -l <test_dir> [N] - create hardlinks to test files, drop caches and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -u <test_dir> [N] - unlink (hardlinked) test files, drop caches and try to open by handle\n");
 	fprintf(stderr, "open_by_handle -d <test_dir> [N] - unlink test files and hardlinks, drop caches and try to open by handle\n");
+	fprintf(stderr, "open_by_handle -m <test_dir> [N] - rename test files, drop caches and try to open by handle\n");
 	exit(EXIT_FAILURE);
 }
 
@@ -105,12 +111,12 @@ int main(int argc, char **argv)
 	char	*test_dir;
 	int	mount_fd, mount_id;
 	int	numfiles = 1;
-	int	create = 0, delete = 0, nlink = 1;
+	int	create = 0, delete = 0, nlink = 1, move = 0;
 
 	if (argc < 2 || argc > 4)
 		usage();
 
-	while ((c = getopt(argc, argv, "clud")) != -1) {
+	while ((c = getopt(argc, argv, "cludm")) != -1) {
 		switch (c) {
 		case 'c':
 			create = 1;
@@ -126,6 +132,9 @@ int main(int argc, char **argv)
 			delete = 1;
 			nlink = 0;
 			break;
+		case 'm':
+			move = 1;
+			break;
 		default:
 			fprintf(stderr, "illegal option '%s'\n", argv[optind]);
 		case 'h':
@@ -201,6 +210,18 @@ int main(int argc, char **argv)
 		}
 	}
 
+	/* rename the files */
+	for (i=0; move && i < numfiles; i++) {
+		sprintf(fname, "%s/file%06d", test_dir, i);
+		sprintf(fname2, "%s/link%06d", test_dir, i);
+		ret = rename(fname, fname2);
+		if (ret < 0) {
+			strcat(fname2, ": rename");
+			perror(fname2);
+			return EXIT_FAILURE;
+		}
+	}
+
 	/* unlink the files */
 	for (i=0; delete && i < numfiles; i++) {
 		sprintf(fname, "%s/file%06d", test_dir, i);
-- 
2.7.4

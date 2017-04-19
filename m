From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/4] src/open_by_handle: flexible usage options
Date: Wed, 19 Apr 2017 19:29:18 +0300
Message-ID: <1492619359-24763-4-git-send-email-amir73il@gmail.com>
References: <1492619359-24763-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34727 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934068AbdDSQ3P (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 12:29:15 -0400
In-Reply-To: <1492619359-24763-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

More usage options for testing open_by_handle, which are needed
for testing stable handles across copy up in overlayfs.

usage: open_by_handle [-c|-l|-u|-d] <test_dir> [num_files]

Examples:

1. Create test set of N files and try to get their NFS handles:

   open_by_handle -c <test_dir> [N]

   This is used by new helper _require_exportfs() to check
   if filesystem supports exportfs

2. Get file handles for existing test set, drop caches and try to
   open all files by handle:

   open_by_handle <test_dir> [N]

3. Get file handles for existing test set, unlink all test files,
   drop caches, try to open all files by handle and expect ESTALE:

   open_by_handle -d <test_dir> [N]

4. Get file handles for existing test set, hardlink all test files,
   then unlink the original files, drop caches and try to open all
   files by handle (should work):

   open_by_handle -l <test_dir> [N]
   open_by_handle -u <test_dir> [N]

   This test is done with 2 invocations of the program, first to
   hardlink (-l) and then to unlink the originals (-u), because
   we would like to be able to perform the hardlinks on overlay
   lower layer and unlink on upper layer.

   NOTE that open_by_handle -u doesn't check if the files are
   hardlinked, it just assumes that they are.  If they are not
   then the test will fail, because file handles would be stale.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc                    |  10 +++
 doc/auxiliary-programs.txt   |  16 ++++-
 doc/requirement-checking.txt |   7 ++
 src/open_by_handle.c         | 156 +++++++++++++++++++++++++++++++++++++------
 4 files changed, 167 insertions(+), 22 deletions(-)

diff --git a/common/rc b/common/rc
index 685b859..a706920 100644
--- a/common/rc
+++ b/common/rc
@@ -2857,6 +2857,16 @@ _require_freeze()
 	[ $result -eq 0 ] || _notrun "$FSTYP does not support freezing"
 }
 
+# Does NFS export work on this fs?
+_require_exportfs()
+{
+	_require_test_program "open_by_handle"
+	mkdir -p "$TEST_DIR"/exportfs_test
+	$here/src/open_by_handle -c "$TEST_DIR"/exportfs_test 2>&1 \
+		|| _notrun "$FSTYP does not support NFS export"
+}
+
+
 # Does shutdown work on this fs?
 _require_scratch_shutdown()
 {
diff --git a/doc/auxiliary-programs.txt b/doc/auxiliary-programs.txt
index 17797b0..2e2060a 100644
--- a/doc/auxiliary-programs.txt
+++ b/doc/auxiliary-programs.txt
@@ -15,9 +15,10 @@ note the dependency with:
 
 Contents:
 
- - af_unix	-- Create an AF_UNIX socket
- - stat_test	-- statx syscall exercise
- - xfs_io	-- General I/O operation exercise
+ - af_unix		-- Create an AF_UNIX socket
+ - open_by_handle	-- open_by_handle_at syscall exercise
+ - stat_test		-- statx syscall exercise
+ - xfs_io		-- General I/O operation exercise
 
 
 ==================
@@ -28,6 +29,15 @@ af_unix
 
 	The af_unix program creates an AF_UNIX socket at the given location.
 
+open_by_handle
+
+	The open_by_handle program exercises the open_by_handle_at() system
+	call.  It can check if file handles are valid or stale after certain
+	filesystem operations.
+
+	See also:
+		_require_exportfs
+
 stat_test
 
 	The stat_test program is primarily designed to exercise the statx()
diff --git a/doc/requirement-checking.txt b/doc/requirement-checking.txt
index 730c7ac..95d10e6 100644
--- a/doc/requirement-checking.txt
+++ b/doc/requirement-checking.txt
@@ -15,6 +15,7 @@ they have.  This is done with _require_<xxx> macros, which may take parameters.
  (2) Filesystem capability requirements.
 
 	_require_chattr <letters>
+	_require_exportfs
 
  (3) System call requirements.
 
@@ -86,6 +87,12 @@ _require_chattr <letters>
      tests to see if setting the append-only and immutable attributes on a file
      (chattr +a +i) is supported.
 
+_require_exportfs
+
+     The test requires that the $TEST_DEV filesystem supports NFS export.
+     The test also requires the use of the open_by_handle_at() system call and
+     will be skipped if it isn't available in the kernel.
+
 
 ========================
 SYSTEM CALL REQUIREMENTS
diff --git a/src/open_by_handle.c b/src/open_by_handle.c
index 76510ff..63ebdac 100644
--- a/src/open_by_handle.c
+++ b/src/open_by_handle.c
@@ -25,6 +25,46 @@
  *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
  */
 
+/*
+
+usage: open_by_handle [-c|-l|-u|-d] <test_dir> [num_files]
+
+Examples:
+
+1. Create test set of N files and try to get their NFS handles:
+
+   open_by_handle -c <test_dir> [N]
+
+   This is used by new helper _require_exportfs() to check
+   if filesystem supports exportfs
+
+2. Get file handles for existing test set, drop caches and try to
+   open all files by handle:
+
+   open_by_handle <test_dir> [N]
+
+3. Get file handles for existing test set, unlink all test files,
+   drop caches, try to open all files by handle and expect ESTALE:
+
+   open_by_handle -d <test_dir> [N]
+
+4. Get file handles for existing test set, hardlink all test files,
+   then unlink the original files, drop caches and try to open all
+   files by handle (should work):
+
+   open_by_handle -l <test_dir> [N]
+   open_by_handle -u <test_dir> [N]
+
+   This test is done with 2 invocations of the program, first to
+   hardlink (-l) and then to unlink the originals (-u), because
+   we would like to be able to perform the hardlinks on overlay
+   lower layer and unlink on upper layer.
+
+   NOTE that open_by_handle -u doesn't check if the files are
+   hardlinked, it just assumes that they are.  If they are not
+   then the test will fail, because file handles would be stale.
+*/
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -35,41 +75,85 @@
 #include <errno.h>
 #include <linux/limits.h>
 
-#define NUMFILES 1024
+#define MAXFILES 1024
 
 struct handle {
 	struct file_handle fh;
 	unsigned char fid[MAX_HANDLE_SZ];
-} handle[NUMFILES];
+} handle[MAXFILES];
+
+void usage(void)
+{
+	fprintf(stderr, "usage: open_by_handle [-c|-l|-u|-d] <test_dir> [num_files]\n");
+	fprintf(stderr, "\n");
+	fprintf(stderr, "open_by_handle -c <test_dir> [N] - create N test files under test_dir, try to get file handles and exit\n");
+	fprintf(stderr, "open_by_handle    <test_dir> [N] - get file handles of test files, drop caches and try to open by handle\n");
+	fprintf(stderr, "open_by_handle -l <test_dir> [N] - create hardlinks to test files, drop caches and try to open by handle\n");
+	fprintf(stderr, "open_by_handle -u <test_dir> [N] - unlink (hardlinked) test files, drop caches and try to open by handle\n");
+	fprintf(stderr, "open_by_handle -d <test_dir> [N] - unlink test files and hardlinks, drop caches and try to open by handle\n");
+	exit(EXIT_FAILURE);
+}
 
 int main(int argc, char **argv)
 {
-	int	i;
+	int	i, c;
 	int	fd;
 	int	ret;
 	int	failed = 0;
 	char	fname[PATH_MAX];
+	char	fname2[PATH_MAX];
 	char	*test_dir;
 	int	mount_fd, mount_id;
+	int	numfiles = 1;
+	int	create = 0, delete = 0, nlink = 1;
 
-	if (argc != 2) {
-		fprintf(stderr, "usage: open_by_handle <test_dir>\n");
-		return EXIT_FAILURE;
+	if (argc < 2 || argc > 4)
+		usage();
+
+	while ((c = getopt(argc, argv, "clud")) != -1) {
+		switch (c) {
+		case 'c':
+			create = 1;
+			break;
+		case 'l':
+			nlink = 2;
+			break;
+		case 'u':
+			delete = 1;
+			nlink = 1;
+			break;
+		case 'd':
+			delete = 1;
+			nlink = 0;
+			break;
+		default:
+			fprintf(stderr, "illegal option '%s'\n", argv[optind]);
+		case 'h':
+			usage();
+		}
+	}
+        if (optind == argc || optind > 2)
+            usage();
+	test_dir = argv[optind++];
+	if (optind < argc)
+		numfiles = atoi(argv[optind]);
+	if (!numfiles || numfiles > MAXFILES) {
+		fprintf(stderr, "illegal value '%s' for num_files\n", argv[optind]);
+		usage();
 	}
 
-	test_dir = argv[1];
 	mount_fd = open(test_dir, O_RDONLY|O_DIRECTORY);
 	if (mount_fd < 0) {
-		perror("open test_dir");
+		perror(test_dir);
 		return EXIT_FAILURE;
 	}
 
 	/*
-	 * create a large number of files to force allocation of new inode
-	 * chunks on disk.
+	 * Create the test files and remove leftover hardlinks from previous run
 	 */
-	for (i=0; i < NUMFILES; i++) {
+	for (i=0; create && i < numfiles; i++) {
 		sprintf(fname, "%s/file%06d", test_dir, i);
+		sprintf(fname2, "%s/link%06d", test_dir, i);
 		fd = open(fname, O_RDWR | O_CREAT | O_TRUNC, 0644);
 		if (fd < 0) {
 			printf("Warning (%s,%d), open(%s) failed.\n", __FILE__, __LINE__, fname);
@@ -77,13 +161,19 @@ int main(int argc, char **argv)
 			return EXIT_FAILURE;
 		}
 		close(fd);
+		/* blow up leftovers hardlinks if they exist */
+		ret = unlink(fname2);
+		if (ret < 0 && errno != ENOENT) {
+			perror("unlink");
+			return EXIT_FAILURE;
+		}
 	}
 
 	/* sync to get the new inodes to hit the disk */
 	sync();
 
 	/* create the handles */
-	for (i=0; i < NUMFILES; i++) {
+	for (i=0; i < numfiles; i++) {
 		sprintf(fname, "%s/file%06d", test_dir, i);
 		handle[i].fh.handle_bytes = MAX_HANDLE_SZ;
 		ret = name_to_handle_at(AT_FDCWD, fname, &handle[i].fh, &mount_id, 0);
@@ -93,14 +183,37 @@ int main(int argc, char **argv)
 		}
 	}
 
+	/* after creating test set only check that fs supports exportfs */
+	if (create)
+		return EXIT_SUCCESS;
+
+	/* hardlink the files */
+	for (i=0; nlink > 1 && i < numfiles; i++) {
+		sprintf(fname, "%s/file%06d", test_dir, i);
+		sprintf(fname2, "%s/link%06d", test_dir, i);
+		ret = link(fname, fname2);
+		if (ret < 0) {
+			perror("link");
+			return EXIT_FAILURE;
+		}
+	}
+
 	/* unlink the files */
-	for (i=0; i < NUMFILES; i++) {
+	for (i=0; delete && i < numfiles; i++) {
 		sprintf(fname, "%s/file%06d", test_dir, i);
+		sprintf(fname2, "%s/link%06d", test_dir, i);
 		ret = unlink(fname);
 		if (ret < 0) {
 			perror("unlink");
 			return EXIT_FAILURE;
 		}
+		/* with -d flag, delete the hardlink if it exists */
+		if (!nlink)
+			ret = unlink(fname2);
+		if (ret < 0 && errno != ENOENT) {
+			perror("unlink");
+			return EXIT_FAILURE;
+		}
 	}
 
 	/* sync to get log forced for unlink transactions to hit the disk */
@@ -121,20 +234,25 @@ int main(int argc, char **argv)
 	}
 
 	/*
-	 * now try to open the files by the stored handles. Expecting ENOENT
-	 * for all of them.
+	 * now try to open the files by the stored handles. Expecting ESTALE
+	 * if all files and their hardlinks have been unlinked.
 	 */
-	for (i=0; i < NUMFILES; i++) {
+	for (i=0; i < numfiles; i++) {
 		errno = 0;
 		fd = open_by_handle_at(mount_fd, &handle[i].fh, O_RDWR);
-		if (fd < 0 && (errno == ENOENT || errno == ESTALE)) {
+		if (nlink && fd >= 0) {
+			close(fd);
+			continue;
+		} else if (!nlink && fd < 0 && (errno == ENOENT || errno == ESTALE)) {
 			continue;
 		}
 		if (fd >= 0) {
 			printf("open_by_handle(%d) opened an unlinked file!\n", i);
 			close(fd);
-		} else
-			printf("open_by_handle(%d) returned %d incorrectly on an unlinked file!\n", i, errno);
+		} else {
+			printf("open_by_handle(%d) returned %d incorrectly on %s file!\n", i, errno,
+					nlink ? "a linked" : "an unlinked");
+		}
 		failed++;
 	}
 	if (failed)
-- 
2.7.4

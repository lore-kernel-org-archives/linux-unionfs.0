From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/7] generic/exportfs: test decoding file handles after cycle mount
Date: Tue, 23 Jan 2018 22:59:08 +0200
Message-ID: <1516741152-20345-4-git-send-email-amir73il@gmail.com>
References: <1516741152-20345-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1516741152-20345-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

open_by_handle can now store and load file handles from a file:

usage:
 open_by_handle -p -o <handles_file> <test_dir> [N]
 open_by_handle -p -i <handles_file> <test_dir> [N]

Add a new generic/exportfs test to use these new options to test
decoding file handles after cycle mount and after directory renames.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/open_by_handle.c  | 141 +++++++++++++++++++++++++++++++++++++++-----------
 tests/generic/477     | 107 ++++++++++++++++++++++++++++++++++++++
 tests/generic/477.out |   5 ++
 tests/generic/group   |   1 +
 4 files changed, 224 insertions(+), 30 deletions(-)
 create mode 100755 tests/generic/477
 create mode 100644 tests/generic/477.out

diff --git a/src/open_by_handle.c b/src/open_by_handle.c
index 9c13b2a..1db6a20 100644
--- a/src/open_by_handle.c
+++ b/src/open_by_handle.c
@@ -27,7 +27,7 @@
 
 /*
 
-usage: open_by_handle [-cludmrwapk] <test_dir> [num_files]
+usage: open_by_handle [-cludmrwapk] [<-i|-o> <handles_file>] <test_dir> [num_files]
 
 Examples:
 
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
 
@@ -131,15 +139,17 @@ int main(int argc, char **argv)
 	char	*test_dir;
 	char	*mount_dir;
 	int	mount_fd, mount_id;
+	char	*infile, *outfile;
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
@@ -176,13 +186,29 @@ int main(int argc, char **argv)
 		case 'k':
 			keepopen = 1;
 			break;
+		case 'i':
+			infile = optarg;
+			in_fd = open(infile, O_RDONLY);
+			if (in_fd < 0) {
+				perror(infile);
+				return EXIT_FAILURE;
+			}
+			break;
+		case 'o':
+			outfile = optarg;
+			out_fd = creat(outfile, 0644);
+			if (out_fd < 0) {
+				perror(outfile);
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
@@ -192,12 +218,34 @@ int main(int argc, char **argv)
 		usage();
 	}
 
-	if (parent) {
+	/*
+	 * The way we determine the mount_dir to be used for mount_fd argument
+	 * for open_by_handle_at() depends on other command line arguments:
+	 *
+	 * -p flag usually (see -i below) implies that test_dir is NOT a mount
+	 *    point, but a directory inside a mount point that we will create
+	 *    and/or encode/decode during the test, so we use test_dir's parent
+	 *    for mount_fd. Even when not creatig test_dir, if we would use
+	 *    test_dir as mount_fd, then drop_caches will not drop the test_dir
+	 *    dcache entry.
+	 *
+	 * If -p is not specified, we don't have a hint whether test_dir is a
+	 *    mount point or not, so we assume the worst case, that it is a
+	 *    mount point and therefore, we cannnot use parent as mount_fd,
+	 *    because parent may be on a differnt file system.
+	 *
+	 * -i flag, even with -p flag, implies that test_dir IS a mount point,
+	 *    because we are testing open by handle of dir, which may have been
+	 *    deleted or renamed and we are not creating nor encoding the
+	 *    directory file handle. -i flag is meant to be used for tests
+	 *    after encoding file handles and mount cycle the file system. If
+	 *    we would require the test to pass in with -ip the test_dir we
+	 *    want to decode and not the mount point, that would have populated
+	 *    the dentry cache and the use of -ip flag combination would not
+	 *    allow testing decode of dir file handle in cold dcache scenario.
+	 */
+	if (parent && !in_fd) {
 		strcpy(dname, test_dir);
-		/*
-		 * -p flag implies that test_dir is NOT a mount point,
-		 * so its parent can be used as mount_fd for open_by_handle_at.
-		 */
 		mount_dir = dirname(dname);
 		if (create)
 			ret = mkdir(test_dir, 0700);
@@ -241,15 +289,26 @@ int main(int argc, char **argv)
 	/* sync to get the new inodes to hit the disk */
 	sync();
 
-	/* create the handles */
+	/*
+	 * encode the file handles or read them from file (-i) and maybe store
+	 * them to a file (-o).
+	 */
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
+				fprintf(stderr, "failed reading file handle #%d from '%s'\n", i, infile);
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
@@ -260,15 +319,37 @@ int main(int argc, char **argv)
 				return EXIT_FAILURE;
 			}
 		}
+		if (out_fd) {
+			ret = write(out_fd, (char *)&handle[i], sizeof(*handle));
+			if (ret < sizeof(*handle)) {
+				fprintf(stderr, "failed writing file handle #%d to '%s'\n", i, outfile);
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
+				fprintf(stderr, "failed reading dir file handle from '%s'\n", infile);
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
+				fprintf(stderr, "failed writing dir file handle to '%s'\n", outfile);
+				return EXIT_FAILURE;
+			}
 		}
 	}
 
@@ -289,8 +370,8 @@ int main(int argc, char **argv)
 		close(fd);
 	}
 
-	/* after creating test set only check that fs supports exportfs */
-	if (create)
+	/* If creating test set or saving files handles, we are done */
+	if (create || out_fd)
 		return EXIT_SUCCESS;
 
 	/* hardlink the files */
diff --git a/tests/generic/477 b/tests/generic/477
new file mode 100755
index 0000000..581ccda
--- /dev/null
+++ b/tests/generic/477
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 477
+#
+# Check open by file handle after cycle mount.
+#
+# This test uses load and store of file handles from a temp file to test
+# decoding file handles after cycle mount and after directory renames.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2018 CTERA Networks. All Rights Reserved.
+# Author: Amir Goldstein <amir73il@gmail.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_test
+# _require_exportfs already requires open_by_handle, but let's not count on it
+_require_test_program "open_by_handle"
+_require_exportfs
+
+NUMFILES=10
+testroot=$TEST_DIR/$seq-dir
+testdir=$testroot/testdir
+
+# Create test dir and test files, encode file handles and store to tmp file
+create_test_files()
+{
+	rm -rf $testdir
+	mkdir -p $testdir
+	$here/src/open_by_handle -cwp -o $tmp.handles_file $testdir $NUMFILES
+}
+
+# Decode file handles loaded from tmp file
+test_file_handles()
+{
+	local opt=$1
+	local when=$2
+
+	echo test_file_handles after $when
+	$here/src/open_by_handle $opt -i $tmp.handles_file $TEST_DIR $NUMFILES
+}
+
+# Decode file handles of files/dir after cycle mount
+create_test_files
+_test_cycle_mount
+test_file_handles -rp "cycle mount"
+
+# Decode file handles of files/dir after rename of parent and cycle mount
+create_test_files $testdir
+rm -rf $testdir.renamed
+mv $testdir $testdir.renamed/
+_test_cycle_mount
+test_file_handles -rp "rename parent"
+
+# Decode file handles of files/dir after rename of grandparent and cycle mount
+create_test_files $testdir
+rm -rf $testroot.renamed
+mv $testroot $testroot.renamed/
+_test_cycle_mount
+test_file_handles -rp "rename grandparent"
+
+# Decode file handles of files/dir after move to new parent and cycle mount
+create_test_files $testdir
+rm -rf $testdir.new
+mkdir -p $testdir.new
+mv $testdir/* $testdir.new/
+_test_cycle_mount
+test_file_handles -r "move to new parent"
+
+status=0
+exit
diff --git a/tests/generic/477.out b/tests/generic/477.out
new file mode 100644
index 0000000..0941a77
--- /dev/null
+++ b/tests/generic/477.out
@@ -0,0 +1,5 @@
+QA output created by 477
+test_file_handles after cycle mount
+test_file_handles after rename parent
+test_file_handles after rename grandparent
+test_file_handles after move to new parent
diff --git a/tests/generic/group b/tests/generic/group
index bf5329c..cce03e9 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -479,3 +479,4 @@
 474 auto quick shutdown metadata
 475 shutdown auto log metadata
 476 auto rw
+477 auto quick exportfs
-- 
2.7.4

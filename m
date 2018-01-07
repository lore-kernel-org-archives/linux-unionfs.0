From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/7] generic/exportfs: store and load file handles from file
Date: Sun,  7 Jan 2018 20:07:22 +0200
Message-ID: <1515348445-1403-5-git-send-email-amir73il@gmail.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

For the test cases of renaming test directory and moving files
to new test directory, encoding the file handles is done after
files/dir have been renamed, so the test does not exercise decoding
file hanldes that were exported before the rename.

For those test cases, store the test set file handles to a temp
file, then move the files/dir, then try to open test set by stored
file handles.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/467     | 29 ++++++++++++++++++-----------
 tests/generic/467.out |  6 ++++--
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/tests/generic/467 b/tests/generic/467
index 56dfcbd..592ffbe 100755
--- a/tests/generic/467
+++ b/tests/generic/467
@@ -74,10 +74,10 @@ create_test_files()
 test_file_handles()
 {
 	local dir=$1
-	local opt=$2
+	shift
 
-	echo test_file_handles $* | _filter_test_dir
-	$here/src/open_by_handle $opt $dir $NUMFILES
+	echo test_file_handles $dir $* | _filter_test_dir | sed -e "s,$tmp\.,,g"
+	$here/src/open_by_handle $* $dir $NUMFILES
 }
 
 # Check stale handles to deleted files/dir
@@ -101,18 +101,25 @@ test_file_handles $testdir -ur
 create_test_files $testdir
 test_file_handles $testdir -mr
 
-# Check non-stale file handles after rename of parent
-create_test_files $testdir
-rm -rf $testdir.renamed
-mv $testdir $testdir.renamed/
-test_file_handles $testdir.renamed -rp
-
-# Check non-stale file handles after move to new parent
+# Check non-stale file handles of moved files
 create_test_files $testdir
 rm -rf $testdir.new
 mkdir -p $testdir.new
+# Store file handles before move to new testdir
+test_file_handles $testdir -o $tmp.file_handles
 mv $testdir/* $testdir.new/
-test_file_handles $testdir.new -rp
+# Check open and read from stored file handles
+# (testdir argument is the mount point and NOT the old nor new testdir)
+test_file_handles $TEST_DIR -r -i $tmp.file_handles
+
+# Check non-stale file handles of renamed dirs
+create_test_files $testdir
+rm -rf $testdir.renamed
+# Store file handles before rename of testdir
+test_file_handles $testdir -p -o $tmp.file_handles
+mv $testdir $testdir.renamed/
+# Check open, read and readdir from stored file handles
+test_file_handles $TEST_DIR -rp -i $tmp.file_handles
 
 status=0
 exit
diff --git a/tests/generic/467.out b/tests/generic/467.out
index 39d6a95..c29289e 100644
--- a/tests/generic/467.out
+++ b/tests/generic/467.out
@@ -5,5 +5,7 @@ test_file_handles TEST_DIR/467-dir -dkr
 test_file_handles TEST_DIR/467-dir -lr
 test_file_handles TEST_DIR/467-dir -ur
 test_file_handles TEST_DIR/467-dir -mr
-test_file_handles TEST_DIR/467-dir.renamed -rp
-test_file_handles TEST_DIR/467-dir.new -rp
+test_file_handles TEST_DIR/467-dir -o file_handles
+test_file_handles TEST_DIR -r -i file_handles
+test_file_handles TEST_DIR/467-dir -p -o file_handles
+test_file_handles TEST_DIR -rp -i file_handles
-- 
2.7.4

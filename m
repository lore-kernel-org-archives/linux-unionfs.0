From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6/7] generic/426: factor out helper functions
Date: Thu,  2 Nov 2017 12:15:38 +0200
Message-ID: <1509617739-15744-7-git-send-email-amir73il@gmail.com>
References: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Helper test_file_handles() outputs the sub-test command to output,
so if errors are detected in one of the sub-tests, it is easier
to know which sub-tests have failed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/426     | 40 +++++++++++++++++++++++++++++-----------
 tests/generic/426.out |  4 ++++
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/tests/generic/426 b/tests/generic/426
index 2d96c1d..68ff169 100755
--- a/tests/generic/426
+++ b/tests/generic/426
@@ -52,25 +52,43 @@ _require_test
 _require_test_program "open_by_handle"
 _require_exportfs
 
-numfiles=1024
+NUMFILES=1024
 testdir=$TEST_DIR/$seq-dir
 mkdir -p $testdir
 
+# Create empty test files in test dir
+create_test_files()
+{
+	local dir=$1
+	local opt=$2
+
+	mkdir -p $dir
+	rm -f $dir/*
+	src/open_by_handle -c $dir $NUMFILES
+}
+
+# Test encode/decode file handles
+test_file_handles()
+{
+	local dir=$1
+	local opt=$2
+
+	echo test_file_handles $* | _filter_test_dir
+	src/open_by_handle $opt $dir $NUMFILES
+}
+
 # Check stale handles to deleted files
-rm -f $testdir/*
-src/open_by_handle -c $testdir $numfiles
-src/open_by_handle -d $testdir $numfiles
+create_test_files $testdir
+test_file_handles $testdir -d
 
 # Check non-stale handles to linked files
-rm -f $testdir/*
-src/open_by_handle -c $testdir $numfiles
-src/open_by_handle    $testdir $numfiles
+create_test_files $testdir
+test_file_handles $testdir
 
 # Check non-stale handles to files that were hardlinked and original deleted
-rm -f $testdir/*
-src/open_by_handle -c $testdir $numfiles
-src/open_by_handle -l $testdir $numfiles
-src/open_by_handle -u $testdir $numfiles
+create_test_files $testdir
+test_file_handles $testdir -l
+test_file_handles $testdir -u
 
 echo "Silence is golden"
 status=0
diff --git a/tests/generic/426.out b/tests/generic/426.out
index 777cbcd..9a25123 100644
--- a/tests/generic/426.out
+++ b/tests/generic/426.out
@@ -1,2 +1,6 @@
 QA output created by 426
+test_file_handles TEST_DIR/426-dir -d
+test_file_handles TEST_DIR/426-dir
+test_file_handles TEST_DIR/426-dir -l
+test_file_handles TEST_DIR/426-dir -u
 Silence is golden
-- 
2.7.4

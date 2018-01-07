From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5/7] generic/exportfs: add a test case for renamed parent dir
Date: Sun,  7 Jan 2018 20:07:23 +0200
Message-ID: <1515348445-1403-6-git-send-email-amir73il@gmail.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39189 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754273AbeAGSGn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 7 Jan 2018 13:06:43 -0500
In-Reply-To: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Check that a dir file handle can be opened after its parent
has been renamed.

Retry decoding subdir file handle when parent is in dcache
and when parent is not in dcache.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/467     | 7 +++++++
 tests/generic/467.out | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/tests/generic/467 b/tests/generic/467
index 592ffbe..555b44b 100755
--- a/tests/generic/467
+++ b/tests/generic/467
@@ -67,6 +67,7 @@ create_test_files()
 	local opt=$2
 
 	rm -rf $dir
+	mkdir -p $dir
 	$here/src/open_by_handle -cwp $dir $NUMFILES
 }
 
@@ -114,12 +115,18 @@ test_file_handles $TEST_DIR -r -i $tmp.file_handles
 
 # Check non-stale file handles of renamed dirs
 create_test_files $testdir
+create_test_files $testdir/subdir
 rm -rf $testdir.renamed
 # Store file handles before rename of testdir
 test_file_handles $testdir -p -o $tmp.file_handles
+test_file_handles $testdir/subdir -p -o $tmp.subdir_file_handles
 mv $testdir $testdir.renamed/
 # Check open, read and readdir from stored file handles
 test_file_handles $TEST_DIR -rp -i $tmp.file_handles
+test_file_handles $TEST_DIR -rp -i $tmp.subdir_file_handles
+# Retry decoding subdir file handle when testdir is in dcache
+# (providing renamed testdir argument pins testdir to dcache)
+test_file_handles $testdir.renamed -rp -i $tmp.subdir_file_handles
 
 status=0
 exit
diff --git a/tests/generic/467.out b/tests/generic/467.out
index c29289e..dfa3240 100644
--- a/tests/generic/467.out
+++ b/tests/generic/467.out
@@ -8,4 +8,7 @@ test_file_handles TEST_DIR/467-dir -mr
 test_file_handles TEST_DIR/467-dir -o file_handles
 test_file_handles TEST_DIR -r -i file_handles
 test_file_handles TEST_DIR/467-dir -p -o file_handles
+test_file_handles TEST_DIR/467-dir/subdir -p -o subdir_file_handles
 test_file_handles TEST_DIR -rp -i file_handles
+test_file_handles TEST_DIR -rp -i subdir_file_handles
+test_file_handles TEST_DIR/467-dir.renamed -rp -i subdir_file_handles
-- 
2.7.4

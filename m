From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7/7] fstests: add test with more open by file handle use cases
Date: Thu,  2 Nov 2017 12:15:39 +0200
Message-ID: <1509617739-15744-8-git-send-email-amir73il@gmail.com>
References: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:55830 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933324AbdKBKPH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 06:15:07 -0400
In-Reply-To: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

This test is a variant of test generic/426 that tests with less
files and more use cases:
- Create test dir with non empty files with known content and verify
  their content after opening file by handle.
- Check open by handle of directory.
- Check open by handle of files that have been unlinked, but still open.
- Check open by handle of files that have been renamed in same dir,
  moved to new dir and whose parent dir has been renamed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/500     | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/500.out |  10 +++++
 tests/generic/group   |   1 +
 3 files changed, 130 insertions(+)
 create mode 100755 tests/generic/500
 create mode 100644 tests/generic/500.out

diff --git a/tests/generic/500 b/tests/generic/500
new file mode 100755
index 0000000..ab3d119
--- /dev/null
+++ b/tests/generic/500
@@ -0,0 +1,119 @@
+#! /bin/bash
+# FS QA Test No. 500
+#
+# Check open by file handle.
+# This is a variant of test generic/426 that tests with less
+# files and more use cases:
+# - open directory by file handle
+# - verify content integrity of file after opening by file handle
+# - open by file handle of unlinked open files
+# - open by file handle of renamed files
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2017 CTERA Networks. All Rights Reserved.
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
+testdir=$TEST_DIR/$seq-dir
+
+# Create test dir and non-empty test files
+create_test_files()
+{
+	local dir=$1
+	local opt=$2
+
+	rm -rf $dir
+	src/open_by_handle -cwp $dir $NUMFILES
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
+# Check stale handles to deleted files/dir
+create_test_files $testdir
+test_file_handles $testdir -dp
+
+# Check non-stale handles to linked files/dir
+create_test_files $testdir
+test_file_handles $testdir -rp
+
+# Check non-stale handles to unlinked open files
+create_test_files $testdir
+test_file_handles $testdir -dkr
+
+# Check non-stale handles to files that were hardlinked and original deleted
+create_test_files $testdir
+test_file_handles $testdir -lr
+test_file_handles $testdir -ur
+
+# Check non-stale file handles of renamed files
+create_test_files $testdir
+test_file_handles $testdir -mr
+
+# Check non-stale file handles after rename of parent
+create_test_files $testdir
+rm -rf $testdir.renamed
+mv $testdir $testdir.renamed/
+test_file_handles $testdir.renamed -rp
+
+# Check non-stale file handles after move to new parent
+create_test_files $testdir
+rm -rf $testdir.new
+mkdir -p $testdir.new
+mv $testdir/* $testdir.new/
+test_file_handles $testdir.new -rp
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/500.out b/tests/generic/500.out
new file mode 100644
index 0000000..0035d21
--- /dev/null
+++ b/tests/generic/500.out
@@ -0,0 +1,10 @@
+QA output created by 500
+test_file_handles TEST_DIR/500-dir -dp
+test_file_handles TEST_DIR/500-dir -rp
+test_file_handles TEST_DIR/500-dir -dkr
+test_file_handles TEST_DIR/500-dir -lr
+test_file_handles TEST_DIR/500-dir -ur
+test_file_handles TEST_DIR/500-dir -mr
+test_file_handles TEST_DIR/500-dir.renamed -rp
+test_file_handles TEST_DIR/500-dir.new -rp
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index fbe0a7f..0b41c15 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -468,3 +468,4 @@
 463 auto quick clone dangerous
 464 auto rw
 465 auto rw quick aio
+500 auto quick exportfs
-- 
2.7.4

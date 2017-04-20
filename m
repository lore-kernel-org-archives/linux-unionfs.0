From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 4/4] fstests: add generic test for file handles
Date: Thu, 20 Apr 2017 11:09:37 +0300
Message-ID: <1492675777-27883-1-git-send-email-amir73il@gmail.com>
References: <1492619359-24763-5-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1492619359-24763-5-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Cloned from xfs specific test xfs/238, which checks
stale file handles of deleted files.

This test uses the generic open_by_handle_at() syscall
and also tests for non-stale file handles of linked files.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/426     | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/426.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 79 insertions(+)
 create mode 100755 tests/generic/426
 create mode 100644 tests/generic/426.out

Eryu,

Avoiding unneeded spam to the list,
here is a re-send of the last patch with your requested fixes.

Thanks,
Amir.

diff --git a/tests/generic/426 b/tests/generic/426
new file mode 100755
index 0000000..d2e555f
--- /dev/null
+++ b/tests/generic/426
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test No. 426
+#
+# Check stale handles pointing to unlinked files
+# and non-stale handles pointing to linked files
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
+    cd /
+    rm -f $tmp.*
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
+# _require_exportfs already requires open_by_handle, but let's not count on it
+_require_test_program "open_by_handle"
+_require_exportfs
+
+numfiles=1024
+testdir=$TEST_DIR/$seq-dir
+mkdir -p $testdir
+
+# Check stale handles to deleted files
+rm -f $testdir/*
+src/open_by_handle -c $testdir $numfiles
+src/open_by_handle -d $testdir $numfiles
+
+# Check non-stale handles to linked files
+rm -f $testdir/*
+src/open_by_handle -c $testdir $numfiles
+src/open_by_handle    $testdir $numfiles
+
+# Check non-stale handles to files that were hardlinked and original deleted
+rm -f $testdir/*
+src/open_by_handle -c $testdir $numfiles
+src/open_by_handle -l $testdir $numfiles
+src/open_by_handle -u $testdir $numfiles
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/426.out b/tests/generic/426.out
new file mode 100644
index 0000000..777cbcd
--- /dev/null
+++ b/tests/generic/426.out
@@ -0,0 +1,2 @@
+QA output created by 426
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 6d6e4f6..f29009c 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -428,3 +428,4 @@
 423 auto quick
 424 auto quick
 425 auto quick attr
+426 auto quick exportfs
-- 
2.7.4

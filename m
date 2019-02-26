Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] generic/{436,445}: check falloc support
Date: Tue, 26 Feb 2019 16:09:01 +0200
Message-Id: <20190226140902.32219-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Eddie Horng <eddiehorng.tw@gmail.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

The sanity test case in those tests (i.e. 13..17)
are all skipped in fs with no falloc support, but the tests
are reported to pass.

For example, from 445.full:

 File system supports the default behavior.
 File system does not support fallocate.
 Allocation size: 4096
 17. Test file with unwritten extents, data-hole-data inside page
 Test skipped as fs doesn't support unwritten extents.

Explicitly check for falloc support before running those tests
so they would be properly reported as skipped.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/436   | 2 ++
 tests/generic/445   | 2 ++
 tests/generic/group | 4 ++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tests/generic/436 b/tests/generic/436
index 3ed22c96..a3ef70e5 100755
--- a/tests/generic/436
+++ b/tests/generic/436
@@ -24,6 +24,8 @@ _supported_os Linux
 
 _require_test
 _require_seek_data_hole
+# All the seek sanity test cases here do falloc
+_require_xfs_io_command "falloc"
 
 BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
 
diff --git a/tests/generic/445 b/tests/generic/445
index e697cca0..694913ae 100755
--- a/tests/generic/445
+++ b/tests/generic/445
@@ -24,6 +24,8 @@ _supported_os Linux
 
 _require_test
 _require_seek_data_hole
+# All the seek sanity test cases here do falloc
+_require_xfs_io_command "falloc"
 
 BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
 
diff --git a/tests/generic/group b/tests/generic/group
index 31011ac8..15227b67 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -438,7 +438,7 @@
 433 auto quick copy
 434 auto quick copy
 435 auto encrypt
-436 auto quick rw seek
+436 auto quick rw seek prealloc
 437 auto quick dax
 438 auto
 439 auto quick punch
@@ -447,7 +447,7 @@
 442 blockdev
 443 auto quick rw
 444 auto quick acl
-445 auto quick rw seek
+445 auto quick rw seek prealloc
 446 auto quick rw punch
 447 auto clone
 448 auto quick rw seek
-- 
2.17.1

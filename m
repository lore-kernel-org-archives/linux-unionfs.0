From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] fstests: _require_chattr() must get an input arg
Date: Wed,  5 Apr 2017 13:47:50 +0300
Message-ID: <1491389271-24726-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34688 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933219AbdDEKrr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Apr 2017 06:47:47 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

_require_chattr() was never intended to be called without an input
argument (specifying the required attribute to set).

However, calling it without input arguments did work and error
was silently discarded into full test output.

Fix the function to abort on missing input argument and fix the
only test that called _require_chattr() with no input argument.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc         | 25 ++++++++++++++-----------
 tests/overlay/027 |  2 +-
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/common/rc b/common/rc
index e1ab2c6..ae3add3 100644
--- a/common/rc
+++ b/common/rc
@@ -3134,18 +3134,21 @@ _require_test_lsattr()
 
 _require_chattr()
 {
-    attribute=$1
-
-    touch $TEST_DIR/syscalltest
-    chattr "+$attribute" $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
-    status=$?
-    chattr "-$attribute" $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
-    if [ "$status" -ne 0 ]; then
-      _notrun "file system doesn't support chattr +$attribute"
-    fi
-    cat $TEST_DIR/syscalltest.out >> $seqres.full
+	if [ -z "$1" ]; then
+		echo "Usage: _require_chattr <attr>"
+		exit 1
+	fi
+	local attribute=$1
 
-    rm -f $TEST_DIR/syscalltest.out
+	touch $TEST_DIR/syscalltest
+	chattr "+$attribute" $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
+	status=$?
+	chattr "-$attribute" $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
+	if [ "$status" -ne 0 ]; then
+		_notrun "file system doesn't support chattr +$attribute"
+	fi
+	cat $TEST_DIR/syscalltest.out >> $seqres.full
+	rm -f $TEST_DIR/syscalltest.out
 }
 
 _get_total_inode()
diff --git a/tests/overlay/027 b/tests/overlay/027
index 10111b7..90da4e7 100755
--- a/tests/overlay/027
+++ b/tests/overlay/027
@@ -57,7 +57,7 @@ rm -f $seqres.full
 _supported_fs overlay
 _supported_os Linux
 _require_scratch
-_require_chattr
+_require_chattr i
 
 # Remove all files from previous tests
 _scratch_mkfs
-- 
2.7.4

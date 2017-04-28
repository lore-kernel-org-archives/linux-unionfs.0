From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/6] overlay/017: fix some comments
Date: Fri, 28 Apr 2017 11:24:44 +0300
Message-ID: <1493367888-26550-3-git-send-email-amir73il@gmail.com>
References: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36189 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034791AbdD1IYr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 04:24:47 -0400
In-Reply-To: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Align all comments to the term 'constant inode numbers' and
explain why hardlinks are excluded from this test.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/017 | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index 7c1430d..e04690c 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -1,7 +1,7 @@
 #! /bin/bash
 # FSQA Test No. 017
 #
-# Test unstable inode number
+# Test constant inode numbers
 #
 # This simple test demonstrates a known issue with overlayfs:
 # - stat file A shows inode number X
@@ -58,9 +58,8 @@ rm -f $seqres.full
 _scratch_mkfs >>$seqres.full 2>&1
 
 # Create our test files.
-# Not dealing with hardlinks here, because there is more to test
-# then stable inode number.
-# Hardlinks will get a test of their own.
+# Not dealing with hardlinks here, when hardlinks are broken they
+# should not preserve the inode number.
 lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 mkdir $lowerdir/dir
-- 
2.7.4

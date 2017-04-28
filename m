From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 5/6] overlay/017: verify constant inode number after rename
Date: Fri, 28 Apr 2017 11:24:47 +0300
Message-ID: <1493367888-26550-6-git-send-email-amir73il@gmail.com>
References: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33159 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034798AbdD1IYs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 04:24:48 -0400
In-Reply-To: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

The test verifies constant inode number after copy up.

Verify that inode number remains constant also after rename
and drop caches (when overlayfs needs to find the lower
inodes in another location).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/017 | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index 3ff429f..fe2518b 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -8,7 +8,8 @@
 # - modify A to trigger copy up
 # - stat file A shows inode number Y != X
 #
-# Also test if d_ino of readdir entries changes after copy up.
+# Also test if d_ino of readdir entries changes after copy up
+# and if inode numbers persist after rename and drop caches.
 #
 #-----------------------------------------------------------------------
 #
@@ -114,6 +115,8 @@ _scratch_mount
 
 
 rm -f $tmp.*
+testdir=$SCRATCH_MNT/test
+mkdir -p $testdir
 
 # Record inode numbers before copy up
 record_inode_numbers $SCRATCH_MNT $tmp.before
@@ -126,6 +129,16 @@ done
 # Compare inode numbers before/after copy up
 check_inode_numbers $SCRATCH_MNT $tmp.before $tmp.after_copyup
 
+for f in $FILES; do
+	# move to another dir
+	mv $SCRATCH_MNT/$f $testdir/
+done
+
+echo 3 > /proc/sys/vm/drop_caches
+
+# Compare inode numbers before/after rename and drop caches
+check_inode_numbers $testdir $tmp.after_copyup $tmp.after_move
+
 echo "Silence is golden"
 status=0
 exit
-- 
2.7.4

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5/5] overlay/017: test persistent inode numbers after mount cycle
Date: Thu, 27 Apr 2017 18:09:35 +0300
Message-ID: <1493305775-12559-6-git-send-email-amir73il@gmail.com>
References: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33290 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934542AbdD0PJh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2017 11:09:37 -0400
In-Reply-To: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Overlayfs directory inodes are constant across copy up,
but not persistent on mount cycle.
Compare the inode numbers before and after mount cycle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/017 | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index 1cf684d..fe66f4c 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -9,7 +9,8 @@
 # - stat file A shows inode number Y != X
 #
 # Also test if d_ino of readdir entries changes after copy up
-# and if inode numbers persist after rename and drop caches.
+# and if inode numbers persist after rename, drop caches and
+# mount cycle.
 #
 #-----------------------------------------------------------------------
 #
@@ -133,6 +134,19 @@ done
 diff -u $tmp.before $tmp.after_copyup
 diff -u $tmp.after_copyup $tmp.after_move
 
+# Verify that the inode numbers survive a mount cycle
+_scratch_cycle_mount
+
+record_inode_numbers $testdir $tmp.after_cycle
+
+cat $tmp.after_move | while read ino f; do
+	find $testdir/ -inum $ino -maxdepth 1 | grep -q $f || \
+		echo "$f not found by ino $ino"
+done
+
+# Compare before..after - expect silence
+diff -u $tmp.after_move $tmp.after_cycle
+
 echo "Silence is golden"
 status=0
 exit
-- 
2.7.4

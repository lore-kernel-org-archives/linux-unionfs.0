From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 6/6] overlay/017: test persistent inode numbers after mount cycle
Date: Fri, 28 Apr 2017 11:24:48 +0300
Message-ID: <1493367888-26550-7-git-send-email-amir73il@gmail.com>
References: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35006 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033096AbdD1IYu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 04:24:50 -0400
In-Reply-To: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Overlayfs directory inodes are constant across copy up,
but not persistent on mount cycle.

Compare the inode numbers before and after mount cycle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/017 | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index fe2518b..c5671ec 100755
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
@@ -139,6 +140,12 @@ echo 3 > /proc/sys/vm/drop_caches
 # Compare inode numbers before/after rename and drop caches
 check_inode_numbers $testdir $tmp.after_copyup $tmp.after_move
 
+# Verify that the inode numbers survive a mount cycle
+_scratch_cycle_mount
+
+# Compare inode numbers before/after mount cycle
+check_inode_numbers $testdir $tmp.after_move $tmp.after_cycle
+
 echo "Silence is golden"
 status=0
 exit
-- 
2.7.4

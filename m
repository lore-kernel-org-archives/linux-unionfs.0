From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/5] overlay/017: verify constant inode number after rename
Date: Thu, 27 Apr 2017 18:09:34 +0300
Message-ID: <1493305775-12559-5-git-send-email-amir73il@gmail.com>
References: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36086 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932712AbdD0PJf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2017 11:09:35 -0400
In-Reply-To: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
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
 tests/overlay/017 | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index f3bf454..1cf684d 100755
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
@@ -94,6 +95,8 @@ _scratch_mount
 
 
 rm -f $tmp.*
+testdir=$SCRATCH_MNT/test
+mkdir -p $testdir
 
 # Test stable stat(2) st_ino
 
@@ -106,18 +109,29 @@ for f in $FILES; do
 done
 
 # Record inode numbers after copy up
-record_inode_numbers $SCRATCH_MNT $tmp.after
+record_inode_numbers $SCRATCH_MNT $tmp.after_copyup
+
+for f in $FILES; do
+	# move to another dir
+	mv $SCRATCH_MNT/$f $testdir/
+done
+
+echo 3 > /proc/sys/vm/drop_caches
+
+# Record inode numbers after rename and drop caches
+record_inode_numbers $testdir $tmp.after_move
 
 # Test stable readdir(3)/getdents(2) d_ino
 
 # find by inode number - expect to find file by inode number
 cat $tmp.before | while read ino f; do
-	find $SCRATCH_MNT/ -inum $ino -maxdepth 1 | grep -q $f || \
+	find $testdir/ -inum $ino -maxdepth 1 | grep -q $f || \
 		echo "$f not found by ino $ino"
 done
 
 # Compare before..after - expect silence
-diff $tmp.before $tmp.after
+diff -u $tmp.before $tmp.after_copyup
+diff -u $tmp.after_copyup $tmp.after_move
 
 echo "Silence is golden"
 status=0
-- 
2.7.4

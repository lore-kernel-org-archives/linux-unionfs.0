From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 4/6] overlay/017: create helpers to record and check inode numbers
Date: Fri, 28 Apr 2017 11:24:46 +0300
Message-ID: <1493367888-26550-5-git-send-email-amir73il@gmail.com>
References: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33143 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034792AbdD1IYr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 04:24:47 -0400
In-Reply-To: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Use helpers to records and check inode numbers so we can repeat
the same test after rename and mount cycle.

Suggested-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/017 | 57 ++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 15 deletions(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index 779907d..3ff429f 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -72,32 +72,59 @@ mknod $lowerdir/blkdev b 1 1
 mknod $lowerdir/fifo p
 $here/src/af_unix $lowerdir/socket
 
+FILES="dir file symlink chrdev blkdev fifo socket"
+
+# Record inode numbers in format <ino> <basename>
+function record_inode_numbers()
+{
+	dir=$1
+	outfile=$2
+
+	for f in $FILES; do
+		ls -id $dir/$f
+	done | \
+	while read ino file; do
+		echo $ino `basename $file` >> $outfile
+	done
+}
+
+# Check inode numbers match recorder inode numbers
+function check_inode_numbers()
+{
+	dir=$1
+	before=$2
+	after=$2
+
+	record_inode_numbers $dir $after
+
+	# Test constant stat(2) st_ino -
+	#   Compare before..after - expect silence
+	# We use diff -u so out.bad will tell us which stage failed
+	diff -u $before $after
+
+	# Test constant readdir(3)/getdents(2) d_ino -
+	#   Expect to find file by inode number
+	cat $before | while read ino f; do
+		find $dir/ -maxdepth 1 -inum $ino | grep -q $f || \
+			echo "$f not found by ino $ino (from $before)"
+	done
+}
 
 _scratch_mount
 
 
 rm -f $tmp.*
 
-# Test stable stat(2) st_ino
+# Record inode numbers before copy up
+record_inode_numbers $SCRATCH_MNT $tmp.before
 
-# Record inode numbers before and after copy up
-for f in dir file symlink chrdev blkdev fifo socket; do
-	ls -id $SCRATCH_MNT/$f >> $tmp.before
+for f in $FILES; do
 	# chown -h modifies all those file types
 	chown -h 100 $SCRATCH_MNT/$f
-	ls -id $SCRATCH_MNT/$f >> $tmp.after
-done
-
-# Test stable readdir(3)/getdents(2) d_ino
-
-# find by inode number - expect to find file by inode number
-cat $tmp.before | while read ino f; do
-	find $SCRATCH_MNT/ -maxdepth 1 -inum $ino | grep -q $f || \
-		echo "$f not found by ino $ino"
 done
 
-# Compare before..after - expect silence
-diff $tmp.before $tmp.after
+# Compare inode numbers before/after copy up
+check_inode_numbers $SCRATCH_MNT $tmp.before $tmp.after_copyup
 
 echo "Silence is golden"
 status=0
-- 
2.7.4

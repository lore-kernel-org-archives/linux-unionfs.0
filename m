From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/5] overlay/017: create a helper to record inode number
Date: Thu, 27 Apr 2017 18:09:33 +0300
Message-ID: <1493305775-12559-4-git-send-email-amir73il@gmail.com>
References: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34910 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932171AbdD0PJe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2017 11:09:34 -0400
In-Reply-To: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

helper records inode number and file basename, so the output
is independant of the files full path. This is needed for adding
rename test.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/017 | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index 66a028f..f3bf454 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -41,6 +41,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
+	cd /
 	rm -f $tmp.*
 }
 
@@ -72,22 +73,41 @@ mknod $lowerdir/blkdev b 1 1
 mknod $lowerdir/fifo p
 $here/src/af_unix $lowerdir/socket
 
+FILES="dir file symlink chrdev blkdev fifo socket"
+
+# record inode numbers in format <ino> <basename>
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
 
 _scratch_mount
 
 
-rm -f $tmp.before $tmp.after
+rm -f $tmp.*
 
 # Test stable stat(2) st_ino
 
-# Record inode numbers before and after copy up
-for f in dir file symlink chrdev blkdev fifo socket; do
-	ls -id $SCRATCH_MNT/$f >> $tmp.before
+# Record inode numbers before copy up
+record_inode_numbers $SCRATCH_MNT $tmp.before
+
+for f in $FILES; do
 	# chown -h modifies all those file types
 	chown -h 100 $SCRATCH_MNT/$f
-	ls -id $SCRATCH_MNT/$f >> $tmp.after
 done
 
+# Record inode numbers after copy up
+record_inode_numbers $SCRATCH_MNT $tmp.after
+
 # Test stable readdir(3)/getdents(2) d_ino
 
 # find by inode number - expect to find file by inode number
-- 
2.7.4

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/5] overlay/017: use af_unix to create socket test file
Date: Thu, 27 Apr 2017 18:09:32 +0300
Message-ID: <1493305775-12559-3-git-send-email-amir73il@gmail.com>
References: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34803 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932150AbdD0PJd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2017 11:09:33 -0400
In-Reply-To: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/017 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index d6ba2ae..66a028f 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -34,6 +34,7 @@ seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
+here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
@@ -51,6 +52,7 @@ _cleanup()
 _supported_fs overlay
 _supported_os Linux
 _require_scratch
+_require_test_program "af_unix"
 
 rm -f $seqres.full
 
@@ -68,6 +70,7 @@ ln -s $lowerdir/file $lowerdir/symlink
 mknod $lowerdir/chrdev c 1 1
 mknod $lowerdir/blkdev b 1 1
 mknod $lowerdir/fifo p
+$here/src/af_unix $lowerdir/socket
 
 
 _scratch_mount
@@ -78,7 +81,7 @@ rm -f $tmp.before $tmp.after
 # Test stable stat(2) st_ino
 
 # Record inode numbers before and after copy up
-for f in dir file symlink chrdev blkdev fifo; do
+for f in dir file symlink chrdev blkdev fifo socket; do
 	ls -id $SCRATCH_MNT/$f >> $tmp.before
 	# chown -h modifies all those file types
 	chown -h 100 $SCRATCH_MNT/$f
-- 
2.7.4

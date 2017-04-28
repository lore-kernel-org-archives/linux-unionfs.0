From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/6] overlay/017: silence test output
Date: Fri, 28 Apr 2017 11:24:43 +0300
Message-ID: <1493367888-26550-2-git-send-email-amir73il@gmail.com>
References: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36182 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033676AbdD1IYm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 04:24:42 -0400
In-Reply-To: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Change test to output golden silence on success.

We are going to run the same check several times,
so instead of cloning the test output, cloning the
silence will be more conveniet.

Generalize cleanup of temp files for the same reason.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/017     | 7 +++++--
 tests/overlay/017.out | 7 +------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index 5ca3040..7c1430d 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -40,6 +40,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
+	cd /
 	rm -f $tmp.*
 }
 
@@ -73,7 +74,7 @@ mknod $lowerdir/fifo p
 _scratch_mount
 
 
-rm -f $tmp.before $tmp.after
+rm -f $tmp.*
 
 # Test stable stat(2) st_ino
 
@@ -89,11 +90,13 @@ done
 
 # find by inode number - expect to find file by inode number
 cat $tmp.before | while read ino f; do
-	find $f -inum $ino -maxdepth 0 | _filter_scratch
+	find $SCRATCH_MNT/ -maxdepth 1 -inum $ino | grep -q $f || \
+		echo "$f not found by ino $ino"
 done
 
 # Compare before..after - expect silence
 diff $tmp.before $tmp.after
 
+echo "Silence is golden"
 status=0
 exit
diff --git a/tests/overlay/017.out b/tests/overlay/017.out
index 1f277c5..8222844 100644
--- a/tests/overlay/017.out
+++ b/tests/overlay/017.out
@@ -1,7 +1,2 @@
 QA output created by 017
-SCRATCH_MNT/dir
-SCRATCH_MNT/file
-SCRATCH_MNT/symlink
-SCRATCH_MNT/chrdev
-SCRATCH_MNT/blkdev
-SCRATCH_MNT/fifo
+Silence is golden
-- 
2.7.4

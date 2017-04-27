From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/5] overlay/017: silence test output
Date: Thu, 27 Apr 2017 18:09:31 +0300
Message-ID: <1493305775-12559-2-git-send-email-amir73il@gmail.com>
References: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33209 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756036AbdD0PJb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2017 11:09:31 -0400
In-Reply-To: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Change test to output golden silence on success.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/017     | 4 +++-
 tests/overlay/017.out | 7 +------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index 5ca3040..d6ba2ae 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -89,11 +89,13 @@ done
 
 # find by inode number - expect to find file by inode number
 cat $tmp.before | while read ino f; do
-	find $f -inum $ino -maxdepth 0 | _filter_scratch
+	find $SCRATCH_MNT/ -inum $ino -maxdepth 1 | grep -q $f || \
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

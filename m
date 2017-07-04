From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/6] overlay/018: print hardlink content to golden output
Date: Tue,  4 Jul 2017 14:20:30 +0300
Message-ID: <1499167234-22779-3-git-send-email-amir73il@gmail.com>
References: <1499167234-22779-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33700 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbdGDLU1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Jul 2017 07:20:27 -0400
In-Reply-To: <1499167234-22779-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

diff may skips comparing content of files with identical st_ino/st_dev.
Overlayfs stat(2) may return same st_dev/st_ino for hardlink copy ups,
but it does not mean that read(2) will return the same content.

Convert the test to output hardlink files content to golden output
instead of using diff.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/018     | 12 ++++++------
 tests/overlay/018.out |  9 ++++++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/tests/overlay/018 b/tests/overlay/018
index 527b9d1..7570a16 100755
--- a/tests/overlay/018
+++ b/tests/overlay/018
@@ -57,7 +57,7 @@ _scratch_mkfs >>$seqres.full 2>&1
 # Create 2 hardlinked files in lower
 lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
-echo "patient zero" >> $lowerdir/foo
+echo "zero" >> $lowerdir/foo
 ln $lowerdir/foo $lowerdir/bar
 
 
@@ -91,16 +91,16 @@ bar=$SCRATCH_MNT/bar
 
 FILES="$foo $bar"
 
+echo "== Before copy up =="
+cat $FILES
 record_ino_nlink $tmp.before
 
 # Modify content of one of the hardlinks
-echo "mutated" >> $foo
+echo "one" >> $foo
 
+echo "== After write one =="
+cat $FILES
 check_ino_nlink $tmp.before $tmp.after
 
-# Compare content of files - expect silence
-diff $foo $bar
-
-echo "Silence is golden"
 status=0
 exit
diff --git a/tests/overlay/018.out b/tests/overlay/018.out
index 8849e30..784e8bc 100644
--- a/tests/overlay/018.out
+++ b/tests/overlay/018.out
@@ -1,2 +1,9 @@
 QA output created by 018
-Silence is golden
+== Before copy up ==
+zero
+zero
+== After write one ==
+zero
+one
+zero
+one
-- 
2.7.4

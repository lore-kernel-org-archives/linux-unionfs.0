From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/6] overlay/018: test broken hardlinks after mount cycle
Date: Tue,  4 Jul 2017 14:20:31 +0300
Message-ID: <1499167234-22779-4-git-send-email-amir73il@gmail.com>
References: <1499167234-22779-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33705 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752284AbdGDLUX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Jul 2017 07:20:23 -0400
In-Reply-To: <1499167234-22779-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

This test checks if overlayfs hardlinks are preserved across
copy up.  Check if they are preserved also after copy up and
mount cycle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/018     | 13 +++++++++++--
 tests/overlay/018.out |  5 +++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tests/overlay/018 b/tests/overlay/018
index 7570a16..46097a9 100755
--- a/tests/overlay/018
+++ b/tests/overlay/018
@@ -96,11 +96,20 @@ cat $FILES
 record_ino_nlink $tmp.before
 
 # Modify content of one of the hardlinks
-echo "one" >> $foo
+# Intentionally modify the last hardlink in $FILES, so after mount cycle
+# when reading the first file in $FILES, last file won't be in inode/dcache
+echo "one" >> $bar
 
 echo "== After write one =="
 cat $FILES
-check_ino_nlink $tmp.before $tmp.after
+check_ino_nlink $tmp.before $tmp.after_one
+
+# Verify that the hardlinks survive a mount cycle
+_scratch_cycle_mount
+
+echo "== After mount cycle =="
+cat $FILES
+check_ino_nlink $tmp.after_one $tmp.after_cycle
 
 status=0
 exit
diff --git a/tests/overlay/018.out b/tests/overlay/018.out
index 784e8bc..5b74ee1 100644
--- a/tests/overlay/018.out
+++ b/tests/overlay/018.out
@@ -7,3 +7,8 @@ zero
 one
 zero
 one
+== After mount cycle ==
+zero
+one
+zero
+one
-- 
2.7.4

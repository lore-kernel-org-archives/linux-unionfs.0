From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 4/7] overlay/018: test lower hardlinks re-unite on copy up
Date: Tue,  4 Jul 2017 14:40:31 +0300
Message-ID: <1499168434-23859-5-git-send-email-amir73il@gmail.com>
References: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33136 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752131AbdGDLkY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Jul 2017 07:40:24 -0400
In-Reply-To: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Test that when two lower hardlinks are copied up, they end up
as two upper hardlinks of the same upper inode.

Drop caches before copy up so there is no knowledge of the
copied up hardlink in inode/dcache.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/018     | 10 ++++++++++
 tests/overlay/018.out |  7 +++++++
 2 files changed, 17 insertions(+)

diff --git a/tests/overlay/018 b/tests/overlay/018
index 46097a9..41855dc 100755
--- a/tests/overlay/018
+++ b/tests/overlay/018
@@ -111,5 +111,15 @@ echo "== After mount cycle =="
 cat $FILES
 check_ino_nlink $tmp.after_one $tmp.after_cycle
 
+# Drop caches to get the copied up hardlink out of cache
+echo 3 > /proc/sys/vm/drop_caches
+
+# Modify content of the other hardlink
+echo "two" >> $foo
+
+echo "== After write two =="
+cat $FILES
+check_ino_nlink $tmp.after_one $tmp.after_two
+
 status=0
 exit
diff --git a/tests/overlay/018.out b/tests/overlay/018.out
index 5b74ee1..adc7f72 100644
--- a/tests/overlay/018.out
+++ b/tests/overlay/018.out
@@ -12,3 +12,10 @@ zero
 one
 zero
 one
+== After write two ==
+zero
+one
+two
+zero
+one
+two
-- 
2.7.4

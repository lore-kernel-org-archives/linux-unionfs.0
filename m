From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/6] overlay/018: test lower hardlinks re-unite on copy up
Date: Tue,  4 Jul 2017 14:20:32 +0300
Message-ID: <1499167234-22779-5-git-send-email-amir73il@gmail.com>
References: <1499167234-22779-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1499167234-22779-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Test that when two lower hardlinks are copied up, they end up
as two upper hardlinks of the same upper inode.

Drop caches before copy up so there is no knowledge of the
copied up hardlink in inode/dcache.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/018     | 10 ++++++++++
 tests/overlay/018.out |  7 +++++++
 tests/overlay/group   |  1 +
 3 files changed, 18 insertions(+)

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
diff --git a/tests/overlay/group b/tests/overlay/group
index 28df5b6..2baba3a 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -34,3 +34,4 @@
 029 auto quick
 030 auto quick perms
 031 auto quick whiteout
+032 auto quick copyup hardlink
-- 
2.7.4

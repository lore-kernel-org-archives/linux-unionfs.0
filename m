From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/4] overlay/017: require and enable redirect_dir
Date: Fri, 26 Jan 2018 09:59:08 +0200
Message-ID: <1516953548-15679-5-git-send-email-amir73il@gmail.com>
References: <1516953548-15679-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1516953548-15679-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This test renames a merge directory so it needs to enable redirect_dir
feature, which is not enabled by default.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/017   | 6 ++++--
 tests/overlay/group | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index 03955d0..e7e8925 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -57,6 +57,7 @@ _supported_os Linux
 _require_scratch
 _require_test_program "af_unix"
 _require_test_program "t_dir_type"
+_require_scratch_feature redirect_dir
 
 rm -f $seqres.full
 
@@ -111,7 +112,8 @@ function check_inode_numbers()
 	done
 }
 
-_scratch_mount
+# Enable redirect_dir for renaming a merge directory
+_scratch_mount -o "redirect_dir=on"
 
 
 rm -f $tmp.*
@@ -140,7 +142,7 @@ echo 3 > /proc/sys/vm/drop_caches
 check_inode_numbers $testdir $tmp.after_copyup $tmp.after_move
 
 # Verify that the inode numbers survive a mount cycle
-_scratch_cycle_mount
+_scratch_cycle_mount "redirect_dir=on"
 
 # Compare inode numbers before/after mount cycle
 check_inode_numbers $testdir $tmp.after_move $tmp.after_cycle
diff --git a/tests/overlay/group b/tests/overlay/group
index 7e541e4..edea64a 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -19,7 +19,7 @@
 014 auto quick copyup
 015 auto quick whiteout
 016 auto quick copyup
-017 auto quick copyup
+017 auto quick copyup redirect
 018 auto quick copyup hardlink
 019 auto stress
 020 auto quick copyup perms
-- 
2.7.4

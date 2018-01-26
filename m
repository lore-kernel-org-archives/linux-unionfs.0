From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/4] overlay: consider index dir with whiteouts clean
Date: Fri, 26 Jan 2018 09:59:07 +0200
Message-ID: <1516953548-15679-4-git-send-email-amir73il@gmail.com>
References: <1516953548-15679-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37395 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752119AbeAZH6N (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 26 Jan 2018 02:58:13 -0500
In-Reply-To: <1516953548-15679-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Several tests check that index dir is empty after upper entries have
been unlinked. With nfs_export=on, index will contain a whiteout index
entry in that case so, allow chardevs when checking for clean index dir.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/033 | 8 ++++++--
 tests/overlay/034 | 8 ++++++--
 tests/overlay/048 | 4 +++-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/tests/overlay/033 b/tests/overlay/033
index 30780c6..3e67500 100755
--- a/tests/overlay/033
+++ b/tests/overlay/033
@@ -69,7 +69,6 @@ report_nlink()
 # Create lower hardlinks
 create_hardlinks()
 {
-	lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 	mkdir -p $lowerdir
 	touch $lowerdir/0
 	ln $lowerdir/0 $lowerdir/1
@@ -123,9 +122,14 @@ test_hardlinks()
 	rm $SCRATCH_MNT/2
 
 	# Verify that orphan index is cleaned when dropping nlink to zero
-	ls $OVL_BASE_SCRATCH_MNT/$OVL_WORK/index
+	# With nfs_export=on index will contain a whiteout index entry, so allow
+	# chardev entries in index dir.
+	find $workdir/index -mindepth 1 -type c -o -print
 }
 
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+
 # Remove all files from previous tests
 _scratch_mkfs
 
diff --git a/tests/overlay/034 b/tests/overlay/034
index dc354c6..d9f9798 100755
--- a/tests/overlay/034
+++ b/tests/overlay/034
@@ -67,11 +67,13 @@ _require_scratch
 # Without overlay index feature hardlinks are broken on copy up
 _require_scratch_feature index
 
+lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+
 # Remove all files from previous tests
 _scratch_mkfs
 
 # Create lower hardlink
-lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 touch $lowerdir/0
 ln $lowerdir/0 $lowerdir/1
@@ -103,7 +105,9 @@ rm $SCRATCH_MNT/4
 
 # Verify that orphan index is cleaned on mount
 _scratch_cycle_mount index=on
-ls $OVL_BASE_SCRATCH_MNT/$OVL_WORK/index
+# With nfs_export=on index will contain a whiteout index entry, so allow
+# chardev entries in index dir.
+find $workdir/index -mindepth 1 -type c -o -print
 
 echo "Silence is golden"
 status=0
diff --git a/tests/overlay/048 b/tests/overlay/048
index 4b2c58f..3ce6270 100755
--- a/tests/overlay/048
+++ b/tests/overlay/048
@@ -111,7 +111,9 @@ test_hardlinks_offline()
 	report_nlink "unlink last lower"
 
 	# Verify that orphan index is cleaned when dropping nlink to zero
-	ls $workdir/index
+	# With nfs_export=on index will contain a whiteout index entry, so allow
+	# chardev entries in index dir.
+	find $workdir/index -mindepth 1 -type c -o -print
 }
 
 lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
-- 
2.7.4

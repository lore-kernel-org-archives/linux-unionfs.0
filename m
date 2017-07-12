From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] overlay: enable the index feature for overlay/hardlink tests
Date: Wed, 12 Jul 2017 12:43:25 +0300
Message-ID: <1499852605-27759-3-git-send-email-amir73il@gmail.com>
References: <1499852605-27759-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34541 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750738AbdGLJnP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jul 2017 05:43:15 -0400
In-Reply-To: <1499852605-27759-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Overlayfs hardlink test are expected to fail if overlayfs does not
support the inodes index feature, so don't un them if kernel does
not support the feature.

If the feature is supported, enable it with the index=on mount option
for the hardlink tests, regardless of the build time default determined
by kernel config option CONFIG_OVERLAY_FS_INDEX.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/018 | 8 +++++---
 tests/overlay/032 | 4 +++-
 tests/overlay/033 | 8 +++++---
 tests/overlay/034 | 9 ++++++---
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/tests/overlay/018 b/tests/overlay/018
index 41855dc..456f907 100755
--- a/tests/overlay/018
+++ b/tests/overlay/018
@@ -10,7 +10,7 @@
 #
 #-----------------------------------------------------------------------
 #
-# Copyright (C) 2016 CTERA Networks. All Rights Reserved.
+# Copyright (C) 2016-2017 CTERA Networks. All Rights Reserved.
 # Author: Amir Goldstein <amir73il@gmail.com>
 #
 # This program is free software; you can redistribute it and/or
@@ -49,6 +49,7 @@ _cleanup()
 _supported_fs overlay
 _supported_os Linux
 _require_scratch
+_require_fs_feature index
 
 rm -f $seqres.full
 
@@ -81,7 +82,8 @@ function check_ino_nlink()
 	diff -u $before $after
 }
 
-_scratch_mount
+# Enable overlay index feature to prevent breaking hardlinks on copy up
+_scratch_mount -o index=on
 
 
 rm -f $tmp.*
@@ -105,7 +107,7 @@ cat $FILES
 check_ino_nlink $tmp.before $tmp.after_one
 
 # Verify that the hardlinks survive a mount cycle
-_scratch_cycle_mount
+_scratch_cycle_mount index=on
 
 echo "== After mount cycle =="
 cat $FILES
diff --git a/tests/overlay/032 b/tests/overlay/032
index d986ef2..b610bc2 100755
--- a/tests/overlay/032
+++ b/tests/overlay/032
@@ -53,6 +53,7 @@ rm -f $seqres.full
 _supported_fs overlay
 _supported_os Linux
 _require_scratch
+_require_fs_feature index
 
 # Remove all files from previous tests
 _scratch_mkfs
@@ -71,7 +72,8 @@ $XFS_IO_PROG -fc "pwrite 1g 4k" $lowerdir/zero >> $seqres.full
 ln $lowerdir/zero $lowerdir/one
 ln $lowerdir/zero $lowerdir/two
 
-_scratch_mount
+# Enable overlay index feature to prevent breaking hardlinks on copy up
+_scratch_mount -o index=on
 
 do_cmd()
 {
diff --git a/tests/overlay/033 b/tests/overlay/033
index 3c21624..2213a10 100755
--- a/tests/overlay/033
+++ b/tests/overlay/033
@@ -50,6 +50,7 @@ rm -f $seqres.full
 _supported_fs overlay
 _supported_os Linux
 _require_scratch
+_require_fs_feature index
 
 report_nlink()
 {
@@ -122,7 +123,7 @@ test_hardlinks()
 	rm $SCRATCH_MNT/2
 
 	# Verify that orphan index is cleaned when dropping nlink to zero
-	ls $OVL_BASE_SCRATCH_MNT/$OVL_WORK/index 2>/dev/null
+	ls $OVL_BASE_SCRATCH_MNT/$OVL_WORK/index
 }
 
 # Remove all files from previous tests
@@ -131,7 +132,8 @@ _scratch_mkfs
 # Create lower hardlinks
 create_hardlinks
 
-_scratch_mount
+# Enable overlay index feature to prevent breaking hardlinks on copy up
+_scratch_mount -o index=on
 # Test hardlinks with warm dcache
 DCACHETEMP=warm
 test_hardlinks
@@ -140,7 +142,7 @@ test_hardlinks
 _scratch_unmount
 _scratch_mkfs
 create_hardlinks
-_scratch_mount
+_scratch_mount -o index=on
 
 # Test hardlinks with cold dcache
 DCACHETEMP=cold
diff --git a/tests/overlay/034 b/tests/overlay/034
index 2b4ca73..dba984b 100755
--- a/tests/overlay/034
+++ b/tests/overlay/034
@@ -64,6 +64,8 @@ rm -f $seqres.full
 _supported_fs overlay
 _supported_os Linux
 _require_scratch
+# Without overlay index feature hardlinks are broken on copy up
+_require_fs_feature index
 
 # Remove all files from previous tests
 _scratch_mkfs
@@ -74,7 +76,8 @@ mkdir -p $lowerdir
 touch $lowerdir/0
 ln $lowerdir/0 $lowerdir/1
 
-_scratch_mount
+# Enable overlay index feature to prevent breaking hardlinks on copy up
+_scratch_mount -o index=on
 
 # Copy up lower hardlink - overlay inode nlink 2 is copied from lower
 touch $SCRATCH_MNT/0
@@ -99,8 +102,8 @@ rm $SCRATCH_MNT/1
 rm $SCRATCH_MNT/4
 
 # Verify that orphan index is cleaned on mount
-_scratch_cycle_mount
-ls $OVL_BASE_SCRATCH_MNT/$OVL_WORK/index 2>/dev/null
+_scratch_cycle_mount index=on
+ls $OVL_BASE_SCRATCH_MNT/$OVL_WORK/index
 
 echo "Silence is golden"
 status=0
-- 
2.7.4

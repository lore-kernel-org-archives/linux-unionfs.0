From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 03/10] fstests: canonicalize mount points on every config section
Date: Thu, 16 Feb 2017 21:57:01 +0200
Message-ID: <1487275028-29885-4-git-send-email-amir73il@gmail.com>
References: <1487275028-29885-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35979 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933136AbdBPT5Y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Feb 2017 14:57:24 -0500
In-Reply-To: <1487275028-29885-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Create helper _canonicalize_mountpoint() to check and canonicalize
a mount point path.
Use helper to canonicalize TEST_DIR and SCRATCH_MNT after parse
of every config section.

This is needed for overlay base fs mount.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/config | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/common/config b/common/config
index fa89f42..bfd6429 100644
--- a/common/config
+++ b/common/config
@@ -454,6 +454,20 @@ _check_device()
 	fi
 }
 
+# check and return a canonical mount point path
+_canonicalize_mountpoint()
+{
+	local name=$1
+	local dir=$2
+
+	if [ ! -d "$dir" ]; then
+		_fatal "common/config: $name ($dir) is not a directory"
+	fi
+
+	# this follows symlinks and removes all trailing "/"s
+	readlink -e "$dir"
+}
+
 # Parse config section options. This function will parse all the configuration
 # within a single section which name is passed as an argument. For section
 # name format see comments in get_config_sections().
@@ -542,10 +556,7 @@ get_next_config() {
 	fi
 
 	_check_device TEST_DEV required $TEST_DEV
-	if [ ! -d "$TEST_DIR" ]; then
-		echo "common/config: Error: \$TEST_DIR ($TEST_DIR) is not a directory"
-		exit 1
-	fi
+	export TEST_DIR=`_canonicalize_mountpoint TEST_DIR $TEST_DIR`
 
 	# a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of its dev
 	# to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
@@ -560,10 +571,7 @@ get_next_config() {
 	fi
 
 	_check_device SCRATCH_DEV optional $SCRATCH_DEV
-	if [ ! -z "$SCRATCH_MNT" -a ! -d "$SCRATCH_MNT" ]; then
-		echo "common/config: Error: \$SCRATCH_MNT ($SCRATCH_MNT) is not a directory"
-		exit 1
-	fi
+	export SCRATCH_MNT=`_canonicalize_mountpoint SCRATCH_MNT $SCRATCH_MNT`
 
 	if [ -n "$USE_EXTERNAL" ]; then
 		_check_device TEST_RTDEV optional $TEST_RTDEV
@@ -590,12 +598,12 @@ if [ -z "$CONFIG_INCLUDED" ]; then
 	[ -z "$TEST_FS_MOUNT_OPTS" ] && _test_mount_opts
 	[ -z "$MKFS_OPTIONS" ] && _mkfs_opts
 	[ -z "$FSCK_OPTIONS" ] && _fsck_opts
+else
+	# canonicalize the mount points
+	# this follows symlinks and removes all trailing "/"s
+	export TEST_DIR=`_canonicalize_mountpoint TEST_DIR $TEST_DIR`
+	export SCRATCH_MNT=`_canonicalize_mountpoint SCRATCH_MNT $SCRATCH_MNT`
 fi
 
-# canonicalize the mount points
-# this follows symlinks and removes all trailing "/"s
-export TEST_DIR=`readlink -e "$TEST_DIR"`
-export SCRATCH_MNT=`readlink -e "$SCRATCH_MNT"`
-
 # make sure this script returns success
 /bin/true
-- 
2.7.4

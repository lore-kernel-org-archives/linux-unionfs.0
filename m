From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/3] overlay/041: use user defined overlay mount option
Date: Sun, 19 Nov 2017 13:56:29 +0200
Message-ID: <1511092589-29179-4-git-send-email-amir73il@gmail.com>
References: <1511092589-29179-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:43854 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdKSLzz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Nov 2017 06:55:55 -0500
In-Reply-To: <1511092589-29179-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Mount non-samefs dirs with OVERLAY_MOUNT_OPTIONS, so user can opt-in
for constant inode numbers on non-samefs setup (i.e. -o xino) when it
is implemented.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/041 | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tests/overlay/041 b/tests/overlay/041
index 11efacb..4152107 100755
--- a/tests/overlay/041
+++ b/tests/overlay/041
@@ -68,7 +68,8 @@ _scratch_mkfs
 upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 
-_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
+_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir \
+			$OVERLAY_MOUNT_OPTIONS
 
 test_dir=$SCRATCH_MNT/test_dir/
 
@@ -184,7 +185,8 @@ _scratch_mkfs
 upperdir=$OVL_BASE_SCRATCH_MNT/ovl-upper
 workdir=$OVL_BASE_SCRATCH_MNT/ovl-work
 
-_overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir
+_overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir \
+			$OVERLAY_MOUNT_OPTIONS
 
 # Copy up test_dir
 touch $test_dir/test_file
-- 
2.7.4

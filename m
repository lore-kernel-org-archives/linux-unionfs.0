From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/5] overlay/014: fix test with inodes index enabled
Date: Tue, 11 Jul 2017 22:52:03 +0300
Message-ID: <1499802726-11045-3-git-send-email-amir73il@gmail.com>
References: <1499802726-11045-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35801 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933409AbdGKTv6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 15:51:58 -0400
In-Reply-To: <1499802726-11045-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

When overlayfs is configured with CONFIG_OVERLAY_FS_INDEX=y,
workdir from previous overlay mount cannot be reused in a new
overlay mount that uses a different upper dir.

Fix the test to use a different workdir when mounting with a
different upper dir.

This change has not effect on older kernels and overlay
configured without CONFIG_OVERLAY_FS_INDEX.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/014 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/overlay/014 b/tests/overlay/014
index 40d10f5..6a551b7 100755
--- a/tests/overlay/014
+++ b/tests/overlay/014
@@ -63,12 +63,13 @@ lowerdir1=$OVL_BASE_SCRATCH_MNT/lower1
 lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
 upperdir=$OVL_BASE_SCRATCH_MNT/upper
 workdir=$OVL_BASE_SCRATCH_MNT/workdir
-mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
+workdir2=$OVL_BASE_SCRATCH_MNT/workdir2
+mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir $workdir2
 mkdir -p $lowerdir1/testdir/d
 
 # mount overlay with $lowerdir2 as upperdir, and remove & recreate testdir,
 # make testdir on $lowerdir2 opaque
-_overlay_mount_dirs $lowerdir1 $lowerdir2 $workdir $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
+_overlay_mount_dirs $lowerdir1 $lowerdir2 $workdir2 $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
 rm -rf $SCRATCH_MNT/testdir
 mkdir -p $SCRATCH_MNT/testdir/visibledir
 # unmount overlayfs but not base fs
-- 
2.7.4

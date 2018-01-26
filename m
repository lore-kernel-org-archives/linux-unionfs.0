From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/4] overlay/036: fix upper/lower dir mismatch
Date: Fri, 26 Jan 2018 09:59:06 +0200
Message-ID: <1516953548-15679-3-git-send-email-amir73il@gmail.com>
References: <1516953548-15679-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:46481 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbeAZH6L (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 26 Jan 2018 02:58:11 -0500
In-Reply-To: <1516953548-15679-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Mount option index=on checks on mount that upper dir is not being
reused with a different lower dir than the first lower dir it was
mounted with. This behavior is verified by test overlay/037.

In this test however, it is not desired to fail mount on mismatch of
upper/lower, so use the matching upper/lower dirs in this test.

The mismatch went unnoticed because the index=off mounts do not verify
lower dir and the index=on mounts fails on EBUSY (dir in use by another
live mount) before failing on ESTALE (upper/lower dir mismatch).

Never the less, fix the mismatch, so a change in the kernel between
the two sanity checks (EBUSY vs. ESTALE) won't break the test.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/036 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/overlay/036 b/tests/overlay/036
index e0c13ae..e04aaee 100755
--- a/tests/overlay/036
+++ b/tests/overlay/036
@@ -90,7 +90,7 @@ _overlay_mount_dirs $lowerdir $upperdir $workdir \
 
 # Try to mount another overlay with the same upperdir
 # with index=off - expect success
-_overlay_mount_dirs $lowerdir2 $upperdir $workdir2 \
+_overlay_mount_dirs $lowerdir $upperdir $workdir2 \
 		    overlay0 $SCRATCH_MNT -oindex=off && \
 		    $UMOUNT_PROG $SCRATCH_MNT
 
@@ -102,7 +102,7 @@ _overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
 
 # Try to mount another overlay with the same upperdir
 # with index=on - expect EBUSY
-_overlay_mount_dirs $lowerdir2 $upperdir $workdir2 \
+_overlay_mount_dirs $lowerdir $upperdir $workdir2 \
 	    overlay2 $SCRATCH_MNT -oindex=on 2>&1 | _filter_busy_mount
 
 # Try to mount another overlay with the same workdir
-- 
2.7.4

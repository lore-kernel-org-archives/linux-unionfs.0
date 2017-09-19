From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] overlay/014: correct comment relating to workdir reuse
Date: Tue, 19 Sep 2017 14:39:43 +0300
Message-ID: <1505821184-3913-2-git-send-email-amir73il@gmail.com>
References: <1505821184-3913-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36295 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbdISLjP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Sep 2017 07:39:15 -0400
In-Reply-To: <1505821184-3913-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Clarification: EBUSY is what you get when trying to use the same
upperdir/workdir with two different *concurent* overlayfs mounts.
The EBUSY case is independent of the inodes index feature.

This is not the case in this test, but rather the case of trying
to reuse the same workdir with different upper dirs on *subsequent*
overlayfs mounts.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/014 | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tests/overlay/014 b/tests/overlay/014
index f228b15..cd76835 100755
--- a/tests/overlay/014
+++ b/tests/overlay/014
@@ -63,10 +63,9 @@ lowerdir1=$OVL_BASE_SCRATCH_MNT/lower1
 lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
 upperdir=$OVL_BASE_SCRATCH_MNT/upper
 workdir=$OVL_BASE_SCRATCH_MNT/workdir
-# When overlay inode index feature is enabled, using an upper layer path and/or
-# a workdir path that are already used by another overlay mount is not allowed
-# and will fail with EBUSY, so create another workdir for the second overlay
-# mount
+# When overlay inode index feature is enabled, a workdir cannot be reused
+# with a different upperdir. workdir2 in this test is used as the workdir
+# when lowerdir2 is used as the upperdir.
 workdir2=$OVL_BASE_SCRATCH_MNT/workdir2
 mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir $workdir2
 mkdir -p $lowerdir1/testdir/d
-- 
2.7.4

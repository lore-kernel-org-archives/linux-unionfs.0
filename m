From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/3] overlay/042: remove wrong check for empty index
Date: Tue, 28 Nov 2017 18:42:02 +0200
Message-ID: <1511887322-29254-4-git-send-email-amir73il@gmail.com>
References: <1511887322-29254-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:46139 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932071AbdK1QmE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:42:04 -0500
In-Reply-To: <1511887322-29254-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

The check for empty index in this test was wrongly copied from test
overlay/034. In test overlay/034 lower file starts as a hardlink, so
nlink accounting is done from the first copy up and index can be cleaned
on last upper hardlink unlink. In this test, lower starts as
non-hardlink, so first copy up does not perform nlink accounting and
therefore, union nlink count does not drop to 0 at the end of the test
and the index is not expected to be cleaned.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/042 | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tests/overlay/042 b/tests/overlay/042
index dae5198..8967ff3 100755
--- a/tests/overlay/042
+++ b/tests/overlay/042
@@ -129,10 +129,6 @@ rm $SCRATCH_MNT/2
 rm $SCRATCH_MNT/3
 rm $SCRATCH_MNT/4
 
-# Verify that orphan index is cleaned on mount
-_scratch_cycle_mount index=on
-ls $OVL_BASE_SCRATCH_MNT/$OVL_WORK/index
-
 echo "Silence is golden"
 status=0
 exit
-- 
2.7.4

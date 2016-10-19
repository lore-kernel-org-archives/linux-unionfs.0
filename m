From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/3] overlay/013: adjust test expectation to kernel v4.8
Date: Wed, 19 Oct 2016 11:52:33 +0300
Message-ID: <1476867153-17368-3-git-send-email-amir73il@gmail.com>
References: <1476867153-17368-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:36066 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942637AbcJSOfg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Oct 2016 10:35:36 -0400
In-Reply-To: <1476867153-17368-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Xiong Zhou <xzhou@redhat.com>
Cc: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Commit 4d0c5ba (vfs: do get_write_access() on upper layer of overlayfs)
that was merged for kernel v4.8 changes the behavior of execve+truncate
in a subtle way.

When file is executed from lower and then truncated, the truncation is
allowed, becasue it only affects the size of the copied up file and does
not affect the VM mapping of the executed lower file.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/013     | 1 -
 tests/overlay/013.out | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/overlay/013 b/tests/overlay/013
index e92eeec..e99e10a 100755
--- a/tests/overlay/013
+++ b/tests/overlay/013
@@ -69,6 +69,5 @@ $SCRATCH_MNT/test_lower
 $SCRATCH_MNT/test_upper
 
 # success, all done
-echo "Silence is golden"
 status=0
 exit
diff --git a/tests/overlay/013.out b/tests/overlay/013.out
index 3e66423..b2c7cc7 100644
--- a/tests/overlay/013.out
+++ b/tests/overlay/013.out
@@ -1,2 +1,2 @@
 QA output created by 013
-Silence is golden
+truncate(test_lower) should have failed
-- 
2.7.4

From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 2/3] generic/079: use _require_test_program
Date: Thu,  6 Apr 2017 08:49:19 +0300
Message-ID: <1491457760-9240-2-git-send-email-amir73il@gmail.com>
References: <1491457760-9240-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:32881 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753424AbdDFFtR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Apr 2017 01:49:17 -0400
In-Reply-To: <1491457760-9240-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

use _require_test_program helper and specify both +i and +a
to _required_chattr, because test sets them both.

Also remove unneeded _scratch_unmount from _cleanup.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/079 | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tests/generic/079 b/tests/generic/079
index 5cceeba..c2db6bf 100755
--- a/tests/generic/079
+++ b/tests/generic/079
@@ -37,7 +37,6 @@ _cleanup()
     cd /
     echo "*** cleaning up"
     $timmutable -r $SCRATCH_MNT/$seq
-    _scratch_unmount
 }
 
 # get standard environment, filters and checks
@@ -48,11 +47,10 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-_require_chattr i
+_require_chattr ia
+_require_test_program "t_immutable"
 _require_scratch
 
-[ -x $timmutable ] || _notrun "t_immutable was not built for this platform"
-
 # real QA test starts here
 _scratch_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
-- 
2.7.4

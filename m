From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 2/3] generic/079: use _require_test_program
Date: Thu,  6 Apr 2017 08:43:53 +0300
Message-ID: <1491457434-7359-2-git-send-email-amir73il@gmail.com>
References: <1491457434-7359-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33206 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755332AbdDFFnu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Apr 2017 01:43:50 -0400
In-Reply-To: <1491457434-7359-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

use _require_test_program helper and remove unneeded _scratch_unmount
from _cleanup.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/079 | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tests/generic/079 b/tests/generic/079
index 97b4812..c2db6bf 100755
--- a/tests/generic/079
+++ b/tests/generic/079
@@ -37,7 +37,6 @@ _cleanup()
     cd /
     echo "*** cleaning up"
     $timmutable -r $SCRATCH_MNT/$seq
-    _scratch_unmount
 }
 
 # get standard environment, filters and checks
@@ -49,10 +48,9 @@ _supported_fs generic
 _supported_os Linux
 
 _require_chattr ia
+_require_test_program "t_immutable"
 _require_scratch
 
-[ -x $timmutable ] || _notrun "t_immutable was not built for this platform"
-
 # real QA test starts here
 _scratch_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
-- 
2.7.4

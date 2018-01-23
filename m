From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v5 6/7] overlay: skip check for tests finished with corrupt filesystem
Date: Tue, 23 Jan 2018 15:34:51 +0800
Message-ID: <20180123073452.19074-7-yi.zhang@huawei.com>
References: <20180123073452.19074-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4276 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751164AbeAWH0n (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 Jan 2018 02:26:43 -0500
In-Reply-To: <20180123073452.19074-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

No post-test check of the overlay dirs is required if case leaves
corrupt filesystem after test. We shoud use _require_scratch_nocheck()
instead of _require_scratch() in these cases.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/019 | 2 +-
 tests/overlay/031 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/overlay/019 b/tests/overlay/019
index 3e2bc4e..575aaf7 100755
--- a/tests/overlay/019
+++ b/tests/overlay/019
@@ -46,7 +46,7 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+_require_scratch_nocheck
 
 # Remove all files from previous tests
 _scratch_mkfs
diff --git a/tests/overlay/031 b/tests/overlay/031
index 186b409..90a06af 100755
--- a/tests/overlay/031
+++ b/tests/overlay/031
@@ -67,7 +67,7 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+_require_scratch_nocheck
 
 # remove all files from previous runs
 _scratch_mkfs
-- 
2.5.0

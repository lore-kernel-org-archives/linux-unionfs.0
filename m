Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v5 4/5] overlay: skip check for tests finished with corrupt filesystem
Date: Thu, 1 Mar 2018 20:13:46 +0800
Message-ID: <20180301121347.5824-5-yi.zhang@huawei.com>
In-Reply-To: <20180301121347.5824-1-yi.zhang@huawei.com>
References: <20180301121347.5824-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

No post-test check of the overlay dirs is required if case leaves
corrupt filesystem after test. We shoud use _require_scratch_nocheck()
instead of _require_scratch() in these cases.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/019 | 2 +-
 tests/overlay/031 | 2 +-
 tests/overlay/049 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
diff --git a/tests/overlay/049 b/tests/overlay/049
index ef00138..1dafc46 100755
--- a/tests/overlay/049
+++ b/tests/overlay/049
@@ -72,7 +72,7 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+_require_scratch_nocheck
 _require_scratch_feature redirect_dir
 
 # remove all files from previous runs
-- 
2.5.0

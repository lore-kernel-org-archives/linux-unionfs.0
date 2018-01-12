From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v3 7/7] overlay/019: fix fs check failure
Date: Fri, 12 Jan 2018 20:05:33 +0800
Message-ID: <20180112120533.6099-8-yi.zhang@huawei.com>
References: <20180112120533.6099-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180112120533.6099-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

This is a stability test, fsstress will create a lot of orphan
whiteouts in lowerdir, which will lead to inconsistency of overlay
image and fs check failure. No need to check this manual craft
file system, so just skip fs check.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/019 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.9.5

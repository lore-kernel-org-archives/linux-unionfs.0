From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstest PATCH v4 5/7] overlay/003: fix fs check failure
Date: Thu, 18 Jan 2018 12:00:31 +0800
Message-ID: <20180118040033.19555-6-yi.zhang@huawei.com>
References: <20180118040033.19555-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180118040033.19555-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

_check_overlay_scratch_fs() will check lowerdir of overlay filesystem,
this case remove this directory after test will lead to check failure,
and it is not really necessary to remove this directory, so keep this
directory.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/003 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/overlay/003 b/tests/overlay/003
index f980edb..154531e 100755
--- a/tests/overlay/003
+++ b/tests/overlay/003
@@ -92,7 +92,6 @@ ls ${SCRATCH_MNT}/
 # unmount overlayfs but not base fs
 $UMOUNT_PROG $SCRATCH_MNT
 
-rm -rf $lowerdir
 echo "Silence is golden"
 # success, all done
 status=0
-- 
2.9.5

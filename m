From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v3 5/7] overlay/003: fix fs check failure
Date: Fri, 12 Jan 2018 20:05:31 +0800
Message-ID: <20180112120533.6099-6-yi.zhang@huawei.com>
References: <20180112120533.6099-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4189 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933055AbeALL7n (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Jan 2018 06:59:43 -0500
In-Reply-To: <20180112120533.6099-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

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

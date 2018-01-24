From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v6 6/8] overlay/003: fix fs check failure
Date: Wed, 24 Jan 2018 15:33:42 +0800
Message-ID: <20180124073344.31970-7-yi.zhang@huawei.com>
References: <20180124073344.31970-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:47834 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S932192AbeAXHZ2 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Jan 2018 02:25:28 -0500
In-Reply-To: <20180124073344.31970-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

_check_overlay_scratch_fs() will check lowerdir of overlay filesystem,
this case remove this directory after test will lead to check failure,
and it is not really necessary to remove this directory, so keep this
directory.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
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

From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH] ovl: fix inconsistent d_ino for merge dir
Date: Sat, 30 Dec 2017 15:49:15 +0800
Message-ID: <20171230074915.33685-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:56947 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750955AbdL3Hlw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 30 Dec 2017 02:41:52 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 43F35E32327C3
        for <linux-unionfs@vger.kernel.org>; Sat, 30 Dec 2017 15:41:46 +0800 (CST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Current ovl_getattr() (stat(2)) return lower's d_ino for merge
directory (No any extended attribute) but ovl_iterate()
(getdents(2)) return upper's d_ino.

This patch correct inconsistent d_ino for this case, change to
return lower's d_ino in ovl_iterate() for merge dir.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/overlayfs/readdir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 8c98578..9548712 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -136,6 +136,11 @@ static bool ovl_calc_d_ino(struct ovl_readdir_data *rdd,
 	    ovl_test_flag(OVL_IMPURE, d_inode(rdd->dentry)))
 		return true;
 
+	/* Recalc d_ino for all dir in merge dir (contains merge subdirs) */
+	if (p->type == DT_DIR &&
+	    OVL_TYPE_MERGE(ovl_path_type(rdd->dentry)))
+		return true;
+
 	return false;
 }
 
-- 
2.5.0

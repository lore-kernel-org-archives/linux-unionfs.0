From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] ovl: fix return value of ovl_fill_super
Date: Fri, 18 Nov 2016 23:02:46 +0800
Message-ID: <94af12abde2c71fe42b4ba340cf93faaed4909e7.1479481211.git.geliangtang@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36272 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752730AbcKRPC5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 18 Nov 2016 10:02:57 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

If kcalloc() failed, the return value of ovl_fill_super() is -EINVAL,
not -ENOMEM. So this patch sets this value to -ENOMEM before calling
kcalloc(), and sets it back to -EINVAL after calling kcalloc().

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 fs/overlayfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 19d31ce..1afdf77 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -754,10 +754,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_free_lowertmp;
 	}
 
+	err = -ENOMEM;
 	stack = kcalloc(stacklen, sizeof(struct path), GFP_KERNEL);
 	if (!stack)
 		goto out_free_lowertmp;
 
+	err = -EINVAL;
 	lower = lowertmp;
 	for (numlower = 0; numlower < stacklen; numlower++) {
 		err = ovl_lower_dir(lower, &stack[numlower], ufs,
-- 
2.9.3

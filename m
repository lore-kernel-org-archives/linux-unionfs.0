From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 22/23] ovl: use d_splice_alias() in place of d_add() in lookup
Date: Thu,  4 Jan 2018 18:40:17 +0200
Message-ID: <1515084018-25134-23-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:40464 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753481AbeADQjx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:53 -0500
Received: by mail-wr0-f195.google.com with SMTP id p17so2023751wre.7
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:53 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

This is required for NFS export.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 80233d5587b7..a69cedf06000 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -990,9 +990,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	dput(index);
 	kfree(stack);
 	kfree(d.redirect);
-	d_add(dentry, inode);
-
-	return NULL;
+	return d_splice_alias(inode, dentry);
 
 out_free_oe:
 	dentry->d_fsdata = NULL;
-- 
2.7.4

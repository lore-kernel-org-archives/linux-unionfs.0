From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 21/23] ovl: grab i_count reference of lower inode
Date: Thu,  4 Jan 2018 18:40:16 +0200
Message-ID: <1515084018-25134-22-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:37319 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753532AbeADQjw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:52 -0500
Received: by mail-wr0-f193.google.com with SMTP id f8so2019729wre.4
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:52 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

An overlay inode with elevated i_count may outlive its overlay dentry.
Since the only reference to OVL_I(inode)->lower was held by the lower
dentry object in the overlay dentry (oe->lowerstack[0]), releasing the
overlay dentry could leave a live inode with reference to freed lower
inode.

This may materialize to a bug when a disconnected dentry is obtained
from decoding an NFS file handle and a new allocated real inode has
the same address as the freed inode in OVL_I(inode)->lower, by which
the overlay inode is hashed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 1 +
 fs/overlayfs/util.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 96136528861f..f152b817e4d0 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -216,6 +216,7 @@ static void ovl_destroy_inode(struct inode *inode)
 	struct ovl_inode *oi = OVL_I(inode);
 
 	dput(oi->__upperdentry);
+	iput(oi->lower);
 	kfree(oi->redirect);
 	ovl_dir_cache_free(inode);
 	mutex_destroy(&oi->lock);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index ce4ac3846b14..d6fe01ece7e8 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -291,7 +291,7 @@ void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 	if (upperdentry)
 		OVL_I(inode)->__upperdentry = upperdentry;
 	if (lowerdentry)
-		OVL_I(inode)->lower = d_inode(lowerdentry);
+		OVL_I(inode)->lower = igrab(d_inode(lowerdentry));
 
 	ovl_copyattr(d_inode(upperdentry ?: lowerdentry), inode);
 }
-- 
2.7.4

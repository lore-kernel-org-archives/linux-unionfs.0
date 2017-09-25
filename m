From: Hirofumi Nakagawa <nklabs@gmail.com>
Subject: [PATCH] ovl: add NULL check in ovl_alloc_inode
Date: Tue, 26 Sep 2017 03:09:53 +0900
Message-ID: <20170925180953.10587-1-nklabs@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33496 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935034AbdIYSIt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2017 14:08:49 -0400
Received: by mail-pg0-f68.google.com with SMTP id i130so5261763pgc.0
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Sep 2017 11:08:49 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Cc: Hirofumi Nakagawa <nklabs@gmail.com>

This was detected by fault injection test

Signed-off-by: Hirofumi Nakagawa <nklabs@gmail.com>
---
 fs/overlayfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index fd5ea4facc62..701aa2f3536d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -174,6 +174,9 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 {
 	struct ovl_inode *oi = kmem_cache_alloc(ovl_inode_cachep, GFP_KERNEL);
 
+	if (!oi)
+		return NULL;
+
 	oi->cache = NULL;
 	oi->redirect = NULL;
 	oi->version = 0;
-- 
2.14.1

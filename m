From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 14/23] ovl: index all files on copy up with 'verify=on'
Date: Thu,  4 Jan 2018 18:40:09 +0200
Message-ID: <1515084018-25134-15-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35305 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753310AbeADQjo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:44 -0500
Received: by mail-wm0-f68.google.com with SMTP id a79so4454301wma.0
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:44 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

With the 'verify' feature enabled, all files are indexed on copy up.
The copy up origin inode of an indexed non-dir can be used as a unique
identifier of the overlay object.

This is going to be used for NFS export.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0254d7f0d401..f40351dcea7b 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -491,6 +491,10 @@ bool ovl_need_index(struct dentry *dentry)
 	if (!lower || !ovl_indexdir(dentry->d_sb))
 		return false;
 
+	/* Index all files for unique origin verification */
+	if (!d_is_dir(lower) && ovl_verify(dentry->d_sb))
+		return true;
+
 	/* Index only lower hardlinks on copy up */
 	if (!d_is_dir(lower) && d_inode(lower)->i_nlink > 1)
 		return true;
-- 
2.7.4

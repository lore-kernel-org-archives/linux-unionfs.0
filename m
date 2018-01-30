From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: check ERR_PTR() return value from ovl_lookup_real()
Date: Tue, 30 Jan 2018 14:42:07 +0200
Message-ID: <1517316127-27555-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:45652 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751801AbeA3MlF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 Jan 2018 07:41:05 -0500
Received: by mail-wr0-f193.google.com with SMTP id 16so10954479wry.12
        for <linux-unionfs@vger.kernel.org>; Tue, 30 Jan 2018 04:41:05 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-unionfs@vger.kernel.org

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 061701540349 ("ovl: lookup indexed ancestor of lower dir")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
Miklos,

Another fix, for yet another issue reported by 0-day robot.
At least it looks like the smatch checker got to the last patch ;-).

All 3 fixes over overlayfs-next are push to branch ovl-nfs-export
on my github.

Thanks,
Amir.

 fs/overlayfs/export.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index bb94ce9da5c8..07d70255095b 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -355,8 +355,8 @@ static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
 		dput(upper);
 	}
 
-	if (!this)
-		return NULL;
+	if (IS_ERR_OR_NULL(this))
+		return this;
 
 	if (WARN_ON(ovl_dentry_real_at(this, layer->idx) != real)) {
 		dput(this);
-- 
2.7.4

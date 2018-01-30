From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: check ERR_PTR() return value from ovl_encode_fh()
Date: Tue, 30 Jan 2018 13:54:45 +0200
Message-ID: <1517313285-23948-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:39219 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbeA3Lxo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 Jan 2018 06:53:44 -0500
Received: by mail-wr0-f196.google.com with SMTP id f6so9188106wra.6
        for <linux-unionfs@vger.kernel.org>; Tue, 30 Jan 2018 03:53:44 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 8ed5eec9d6c4 ("ovl: encode pure upper file handles")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

Another fix on top on overlayfs-next, for an issue reported by 0-day robot.

If you are going to squash this one and the other regression fix to
overlayfs-next, just keep in mind that overlayfs-next has already been
merged with Al's for-next branch on linux-next tree to resolve a conflict.

Thanks,
Amir.

 fs/overlayfs/export.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index b65ea49de457..bb94ce9da5c8 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -108,6 +108,9 @@ static int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
 
 	/* Encode an upper or origin file handle */
 	fh = ovl_encode_fh(origin ?: ovl_dentry_upper(dentry), !origin);
+	err = PTR_ERR(fh);
+	if (IS_ERR(fh))
+		goto fail;
 
 	err = -EOVERFLOW;
 	if (fh->len > buflen)
-- 
2.7.4

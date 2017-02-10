From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ovl: Avoid some memory allocation
Date: Fri, 10 Feb 2017 22:18:14 +0100
Message-ID: <20170210211814.18257-1-christophe.jaillet@wanadoo.fr>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:39855 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbdBJVSW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Feb 2017 16:18:22 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reorder code to avoid allocating and then freeing some memory in an error
handling path.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/overlayfs/namei.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 023bb0b03352..ba80ebb8a104 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -35,13 +35,13 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 			return 0;
 		goto fail;
 	}
+	if (res == 0)
+		goto invalid;
+
 	buf = kzalloc(prelen + res + strlen(post) + 1, GFP_TEMPORARY);
 	if (!buf)
 		return -ENOMEM;
 
-	if (res == 0)
-		goto invalid;
-
 	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, buf, res);
 	if (res < 0)
 		goto fail;
-- 
2.9.3

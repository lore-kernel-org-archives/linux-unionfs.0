From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: update ctx->pos on impure dir iteration
Date: Wed, 29 Nov 2017 07:35:21 +0200
Message-ID: <1511933721-4720-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:41944 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdK2Fef (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Nov 2017 00:34:35 -0500
Received: by mail-wm0-f68.google.com with SMTP id g75so3744603wme.0
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Nov 2017 21:34:34 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>, linux-unionfs@vger.kernel.org

This fixes a regression with readdir of impure dir in overlayfs
that is shared to VM via 9p fs.

Reported-by: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
Cc: <stable@vger.kernel.org> #4.14
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 502dc0966f91..b98f1efe50c1 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -663,7 +663,10 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 			return PTR_ERR(rdt.cache);
 	}
 
-	return iterate_dir(od->realfile, &rdt.ctx);
+	err = iterate_dir(od->realfile, &rdt.ctx);
+	ctx->pos = rdt.ctx.pos;
+
+	return err;
 }
 
 
-- 
2.7.4

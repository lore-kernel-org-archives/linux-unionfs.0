From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix overlay: warning prefix
Date: Wed, 22 Nov 2017 20:27:34 +0200
Message-ID: <1511375254-15206-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38666 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751472AbdKVS0u (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Nov 2017 13:26:50 -0500
Received: by mail-wr0-f195.google.com with SMTP id z75so14036147wrc.5
        for <linux-unionfs@vger.kernel.org>; Wed, 22 Nov 2017 10:26:49 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Conform two stray warning messages to the standard overlayfs: prefix.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c     | 3 ++-
 fs/overlayfs/readdir.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 5ec5ee8e0589..0ce535e7519e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -887,7 +887,8 @@ static int ovl_set_redirect(struct dentry *dentry, bool samedir)
 		spin_unlock(&dentry->d_lock);
 	} else {
 		kfree(redirect);
-		pr_warn_ratelimited("overlay: failed to set redirect (%i)\n", err);
+		pr_warn_ratelimited("overlayfs: failed to set redirect (%i)\n",
+				    err);
 		/* Fall back to userspace copy-up */
 		err = -EXDEV;
 	}
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 362561457cdb..7fc142d183e8 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -499,7 +499,7 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 	return err;
 
 fail:
-	pr_warn_ratelimited("overlay: failed to look up (%s) for ino (%i)\n",
+	pr_warn_ratelimited("overlayfs: failed to look up (%s) for ino (%i)\n",
 			    p->name, err);
 	goto out;
 }
-- 
2.7.4

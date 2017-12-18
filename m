From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix another overlay: warning prefix
Date: Mon, 18 Dec 2017 14:25:56 +0200
Message-ID: <1513599956-29976-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:42140 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933607AbdLRMZQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Dec 2017 07:25:16 -0500
Received: by mail-wm0-f65.google.com with SMTP id b199so28977872wme.1
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Dec 2017 04:25:16 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

You just sneaked another one in...

Amir.

 fs/overlayfs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index beb945e1963c..9cf15463754c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -693,7 +693,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		 */
 		err = -EPERM;
 		if (d.redirect && !ofs->config.redirect_follow) {
-			pr_warn_ratelimited("overlay: refusing to follow redirect for (%pd2)\n", dentry);
+			pr_warn_ratelimited("overlayfs: refusing to follow redirect for (%pd2)\n",
+					    dentry);
 			goto out_put;
 		}
 
-- 
2.7.4

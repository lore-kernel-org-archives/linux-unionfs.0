From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH] ovl: fix overlay: warning prefix
Date: Wed, 10 Jan 2018 17:17:34 +0800
Message-ID: <1515575854-67252-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mr11p00im-asmtp004.me.com ([17.110.69.135]:24612 "EHLO
        mr11p00im-asmtp004.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965494AbeAJKSh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 05:18:37 -0500
Received: from process-dkim-sign-daemon.mr11p00im-asmtp004.me.com by
 mr11p00im-asmtp004.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2C00D0012SUF00@mr11p00im-asmtp004.me.com> for
 linux-unionfs@vger.kernel.org; Wed, 10 Jan 2018 09:18:09 +0000 (GMT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

Conform one stray warning message to the standard overlayfs: prefix.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
 fs/overlayfs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index beb945e..d0a801b 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -693,7 +693,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		 */
 		err = -EPERM;
 		if (d.redirect && !ofs->config.redirect_follow) {
-			pr_warn_ratelimited("overlay: refusing to follow redirect for (%pd2)\n", dentry);
+			pr_warn_ratelimited("overlayfs: refusing to follow redirect for (%pd2)\n", dentry);
 			goto out_put;
 		}
 
-- 
1.8.3.1

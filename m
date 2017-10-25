From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 01/13] ovl: Put upperdentry if ovl_check_origin() fails
Date: Wed, 25 Oct 2017 15:09:23 -0400
Message-ID: <1508958575-14086-2-git-send-email-vgoyal@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932287AbdJYTJn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Oct 2017 15:09:43 -0400
In-Reply-To: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

If ovl_check_origin() fails, we should put upperdentry. We have a reference
on it by now. So goto out_put_upper instead of out.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 88ff1da..aec543d 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -633,7 +633,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			err = ovl_check_origin(upperdentry, roe->lowerstack,
 					       roe->numlower, &stack, &ctr);
 			if (err)
-				goto out;
+				goto out_put_upper;
 		}
 
 		if (d.redirect) {
-- 
2.5.5

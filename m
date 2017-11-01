From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/1] ovl: Put upperdentry if ovl_check_origin() fails
Date: Wed,  1 Nov 2017 15:37:22 -0400
Message-ID: <20171101193722.10228-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751587AbdKATho (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 15:37:44 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com, stable@vger.kernel.org

If ovl_check_origin() fails, we should put upperdentry. We have a reference
on it by now. So goto out_put_upper instead of out.

Fixes: a9d019573e88 ("ovl: lookup non-dir copy-up-origin by file handle")
Cc: <stable@vger.kernel.org> #4.12
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a12dc10bf726..bc6d5c5a3443 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -630,7 +630,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			err = ovl_check_origin(upperdentry, roe->lowerstack,
 					       roe->numlower, &stack, &ctr);
 			if (err)
-				goto out;
+				goto out_put_upper;
 		}
 
 		if (d.redirect) {
-- 
2.13.6

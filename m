From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] ovl: Return -ENOMEM if an allocation fails ovl_lookup()
Date: Fri, 22 Sep 2017 23:45:18 +0300
Message-ID: <20170922204518.cqagl2vlh7jiwt6y@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36580 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752263AbdIVUpa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 Sep 2017 16:45:30 -0400
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, kernel-janitors@vger.kernel.org

The error code is missing here so it means we return ERR_PTR(0) or NULL.
The other error paths all return an error code so this probably should
as well.

Fixes: 02b69b284cd7 ("ovl: lookup redirects")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c3addd1114f1..beb8a988df51 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -634,6 +634,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 
 		if (d.redirect) {
+			err = -ENOMEM;
 			upperredirect = kstrdup(d.redirect, GFP_KERNEL);
 			if (!upperredirect)
 				goto out_put_upper;

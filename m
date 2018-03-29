Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751907AbeC2TjD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Mar 2018 15:39:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 23/28] ovl: Remove redirect when data of a metacopy file is copied up
Date: Thu, 29 Mar 2018 15:38:49 -0400
Message-Id: <20180329193854.13814-24-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

When a metacopy file is no longer a metacopy and data has been copied up,
remove REDIRECT xattr. Its not needed anymore.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0c8d2755bd25..fbaf5fbfdf88 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -774,9 +774,18 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	err = vfs_removexattr(upperpath.dentry, OVL_XATTR_METACOPY);
 	if (err)
 		return err;
+	/*
+	 * A metacopy files does not need redirect xattr once data has
+	 * been copied up.
+	 */
+	err = vfs_removexattr(upperpath.dentry, OVL_XATTR_REDIRECT);
+	if (err && err != -ENODATA && err != -EOPNOTSUPP)
+		return err;
 
+	/* We must be holding ovl_inode->lock if we are here */
+	ovl_dentry_set_redirect(c->dentry, NULL);
 	ovl_set_upperdata(d_inode(c->dentry));
-	return err;
+	return 0;
 }
 
 static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
-- 
2.13.6


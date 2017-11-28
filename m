From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v8 03/15] ovl: ovl_check_setxattr() get rid of redundant -EOPNOTSUPP check
Date: Tue, 28 Nov 2017 10:59:47 -0500
Message-ID: <20171128155959.20114-4-vgoyal@redhat.com>
References: <20171128155959.20114-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754025AbdK1QAM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:00:12 -0500
In-Reply-To: <20171128155959.20114-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

At mount time we check if upper supports xattr or not and set ofs->noxattr
field accordingly. But in ovl_check_setxattr() still seems to have logic
which expects that ovl_do_setxattr() can return -EOPNOTSUPP. Not sure when
and how can we hit this code. Feels redundant to me. So I am removing
this code.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/util.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index d6bb1c9f5e7a..77dc00438d54 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -365,21 +365,12 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 		       const char *name, const void *value, size_t size,
 		       int xerr)
 {
-	int err;
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 
 	if (ofs->noxattr)
 		return xerr;
 
-	err = ovl_do_setxattr(upperdentry, name, value, size, 0);
-
-	if (err == -EOPNOTSUPP) {
-		pr_warn("overlayfs: cannot set %s xattr on upper\n", name);
-		ofs->noxattr = true;
-		return xerr;
-	}
-
-	return err;
+	return ovl_do_setxattr(upperdentry, name, value, size, 0);
 }
 
 int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
-- 
2.13.6

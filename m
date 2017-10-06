From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/8] ovl: ovl_check_setxattr() get rid of redundant -EOPNOTSUPP check
Date: Fri,  6 Oct 2017 13:47:10 -0400
Message-ID: <1507312037-30909-2-git-send-email-vgoyal@redhat.com>
References: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39156 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752204AbdJFRrX (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 13:47:23 -0400
In-Reply-To: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

At mount time we check if upper supports xattr or not and set ofs->noxattr
field accordingly. But in ovl_check_setxattr() still seems to have logic
which expects that ovl_do_setxattr() can return -EOPNOTSUPP. Not sure when
and how can we hit this code. Feels redundant to me. So I am removing
this code.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/util.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 117794582f9f..792a5f5f27e0 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -348,21 +348,12 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
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
2.13.5

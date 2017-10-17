From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 02/11] ovl: ovl_check_setxattr() get rid of redundant -EOPNOTSUPP check
Date: Tue, 17 Oct 2017 17:05:49 -0400
Message-ID: <1508274358-17456-3-git-send-email-vgoyal@redhat.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20639 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760998AbdJQVG1 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 17:06:27 -0400
In-Reply-To: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
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
index b9b239fa5cfd..a4ce1c9944f0 100644
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

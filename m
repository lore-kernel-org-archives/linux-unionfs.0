From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 03/14] ovl: use d_splice_alias() in place of d_add() in lookup
Date: Tue, 17 Oct 2017 19:44:20 +0300
Message-ID: <1508258671-10800-4-git-send-email-amir73il@gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:44316 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937034AbdJQQoC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 12:44:02 -0400
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

This is required for NFS export.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index e2b47d6494fd..0619a789809e 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -895,9 +895,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	dput(index);
 	kfree(stack);
 	kfree(d.redirect);
-	d_add(dentry, inode);
-
-	return NULL;
+	return d_splice_alias(inode, dentry);
 
 out_free_oe:
 	dentry->d_fsdata = NULL;
-- 
2.7.4

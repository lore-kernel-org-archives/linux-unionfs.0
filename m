From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/3] ovl: fix wrong error handling of ovl_set_impure()
Date: Wed, 17 May 2017 00:12:39 +0300
Message-ID: <1494969161-30267-2-git-send-email-amir73il@gmail.com>
References: <1494969161-30267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36169 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753022AbdEPVMc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2017 17:12:32 -0400
Received: by mail-wr0-f196.google.com with SMTP id v42so15377912wrc.3
        for <linux-unionfs@vger.kernel.org>; Tue, 16 May 2017 14:12:31 -0700 (PDT)
In-Reply-To: <1494969161-30267-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 5ad6ccf..9b221cf 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -973,13 +973,13 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		if (ovl_type_origin(old) && !ovl_type_merge(new->d_parent)) {
 			err = ovl_set_impure(new->d_parent, new_upperdir);
 			if (err)
-				goto out_dput;
+				goto out_revert_creds;
 		}
 		if (!overwrite && ovl_type_origin(new) &&
 		    !ovl_type_merge(old->d_parent)) {
 			err = ovl_set_impure(old->d_parent, old_upperdir);
 			if (err)
-				goto out_dput;
+				goto out_revert_creds;
 		}
 	}
 
-- 
2.7.4

Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43748 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754033AbeCFUyR (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Mar 2018 15:54:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v12 14/17] ovl: Set redirect on metacopy files upon rename
Date: Tue,  6 Mar 2018 15:54:05 -0500
Message-Id: <20180306205408.23383-15-vgoyal@redhat.com>
In-Reply-To: <20180306205408.23383-1-vgoyal@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Set redirect on metacopy files upon rename. This will help find data dentry
in lower dirs.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/dir.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index cdeae4bdbfce..b955f6fede06 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1048,9 +1048,11 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			err = ovl_set_redirect(old, samedir);
 		else if (!old_opaque && ovl_type_merge(new->d_parent))
 			err = ovl_set_opaque_xerr(old, olddentry, -EXDEV);
-		if (err)
-			goto out_dput;
-	}
+	} else if (ovl_is_metacopy_dentry(old))
+			err = ovl_set_redirect(old, false);
+	if (err)
+		goto out_dput;
+
 	if (!overwrite && new_is_dir) {
 		if (ovl_type_merge_or_lower(new))
 			err = ovl_set_redirect(new, samedir);
@@ -1058,7 +1060,10 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			err = ovl_set_opaque_xerr(new, newdentry, -EXDEV);
 		if (err)
 			goto out_dput;
-	}
+	} else if (!overwrite && ovl_is_metacopy_dentry(new))
+			err = ovl_set_redirect(new, false);
+	if (err)
+		goto out_dput;
 
 	err = ovl_do_rename(old_upperdir->d_inode, olddentry,
 			    new_upperdir->d_inode, newdentry, flags);
-- 
2.13.6


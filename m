From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 22/23] ovl: fix nlink leak in ovl_rename()
Date: Wed, 14 Jun 2017 10:26:41 +0300
Message-ID: <1497425202-16270-23-git-send-email-amir73il@gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35103 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754280AbdFNH1B (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:27:01 -0400
Received: by mail-wr0-f194.google.com with SMTP id z45so6095733wrb.2
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 00:27:00 -0700 (PDT)
In-Reply-To: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

This patch fixes an overlay inode nlink leak in the case where
ovl_rename() renames over a non-dir.

This is not so critical, because overlay inode doesn't rely on
nlink dropping to zero for inode deletion.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f87cef27741f..cec89d33ab1e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -890,6 +890,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	bool old_opaque;
 	bool new_opaque;
 	bool cleanup_whiteout = false;
+	bool new_drop_nlink = false;
 	bool overwrite = !(flags & RENAME_EXCHANGE);
 	bool is_dir = d_is_dir(old);
 	bool new_is_dir = d_is_dir(new);
@@ -951,6 +952,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			flags |= RENAME_EXCHANGE;
 			cleanup_whiteout = true;
 		}
+		if (!new_is_dir && new->d_inode)
+			new_drop_nlink = true;
 	}
 
 	old_upperdir = ovl_dentry_upper(old->d_parent);
@@ -1045,6 +1048,9 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	if (cleanup_whiteout)
 		ovl_cleanup(old_upperdir->d_inode, newdentry);
 
+	if (new_drop_nlink)
+		drop_nlink(new->d_inode);
+
 	ovl_dentry_version_inc(old->d_parent);
 	ovl_dentry_version_inc(new->d_parent);
 
-- 
2.7.4

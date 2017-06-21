From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 23/25] ovl: fix nlink leak in ovl_rename()
Date: Wed, 21 Jun 2017 15:28:54 +0300
Message-ID: <1498048136-28218-24-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:32901 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdFUM3S (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:29:18 -0400
Received: by mail-wr0-f193.google.com with SMTP id x23so26120363wrb.0
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 05:29:18 -0700 (PDT)
In-Reply-To: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
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
index 7bcb5a19e514..45120e9d8bbd 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -892,6 +892,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	bool old_opaque;
 	bool new_opaque;
 	bool cleanup_whiteout = false;
+	bool new_drop_nlink = false;
 	bool overwrite = !(flags & RENAME_EXCHANGE);
 	bool is_dir = d_is_dir(old);
 	bool new_is_dir = d_is_dir(new);
@@ -927,6 +928,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		err = ovl_copy_up(new);
 		if (err)
 			goto out_drop_write;
+	} else if (!new_is_dir && new->d_inode) {
+		new_drop_nlink = true;
 	}
 
 	old_cred = ovl_override_creds(old->d_sb);
@@ -1047,6 +1050,9 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	if (cleanup_whiteout)
 		ovl_cleanup(old_upperdir->d_inode, newdentry);
 
+	if (new_drop_nlink)
+		drop_nlink(new->d_inode);
+
 	ovl_dentry_version_inc(old->d_parent);
 	ovl_dentry_version_inc(new->d_parent);
 
-- 
2.7.4

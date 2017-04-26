From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 11/16] ovl: redirect non-dir by path on rename
Date: Thu, 27 Apr 2017 00:35:13 +0300
Message-ID: <1493242518-15266-12-git-send-email-amir73il@gmail.com>
References: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35969 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754422AbdDZVf2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 17:35:28 -0400
In-Reply-To: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When a non-dir COPYUP type entry is being renamed, set its
overlay.redirect xattr, just the same as when renaming a lower
or merge directory.

This will be used to find the copy up original of non-dir inodes
in case the lower layers do not support lookup by file handle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index bfabc65..7372c15 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -795,6 +795,13 @@ static bool ovl_type_merge_or_lower(struct dentry *dentry)
 	return OVL_TYPE_MERGE(type) || !OVL_TYPE_UPPER(type);
 }
 
+static bool ovl_type_copyup(struct dentry *dentry)
+{
+	enum ovl_path_type type = ovl_path_type(dentry);
+
+	return OVL_TYPE_COPYUP(type);
+}
+
 static bool ovl_can_move(struct dentry *dentry)
 {
 	return ovl_redirect_dir(dentry->d_sb) ||
@@ -1022,6 +1029,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			err = ovl_set_opaque(old, olddentry);
 		if (err)
 			goto out_dput;
+	} else if (ovl_type_copyup(old)) {
+		err = ovl_set_redirect(old, samedir);
 	}
 	if (!overwrite && new_is_dir) {
 		if (ovl_type_merge_or_lower(new))
@@ -1030,6 +1039,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			err = ovl_set_opaque(new, newdentry);
 		if (err)
 			goto out_dput;
+	} else if (!overwrite && ovl_type_copyup(new)) {
+		err = ovl_set_redirect(new, samedir);
 	}
 
 	err = ovl_do_rename(old_upperdir->d_inode, olddentry,
-- 
2.7.4

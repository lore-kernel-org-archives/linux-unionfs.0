From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 12/16] ovl: constant st_ino/st_dev across copy up
Date: Thu, 27 Apr 2017 00:35:14 +0300
Message-ID: <1493242518-15266-13-git-send-email-amir73il@gmail.com>
References: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36455 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030876AbdDZVff (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 17:35:35 -0400
In-Reply-To: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When getting attributes for overlay inode of path type COPYUP,
get the inode and dev numbers from the copy up origin inode.

This results in constant and persistent st_ino/st_dev representation
of files in overlay mount before and after copy up as well as after
mount cycle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 17b8418..3615a52 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -60,15 +60,25 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 static int ovl_getattr(const struct path *path, struct kstat *stat,
 		       u32 request_mask, unsigned int flags)
 {
-	struct dentry *dentry = path->dentry;
+	struct dentry *lower, *dentry = path->dentry;
 	struct path realpath;
 	const struct cred *old_cred;
+	enum ovl_path_type type;
 	int err;
 
-	ovl_path_real(dentry, &realpath);
+	type = ovl_path_real(dentry, &realpath);
 	old_cred = ovl_override_creds(dentry->d_sb);
 	err = vfs_getattr(&realpath, stat, request_mask, flags);
 	revert_creds(old_cred);
+	if (err)
+		return err;
+
+	lower = ovl_dentry_lower(dentry);
+	if (OVL_TYPE_COPYUP(type) && lower) {
+		stat->dev = lower->d_sb->s_dev;
+		stat->ino = lower->d_inode->i_ino;
+	}
+
 	return err;
 }
 
-- 
2.7.4

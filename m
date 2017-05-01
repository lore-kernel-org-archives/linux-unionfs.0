From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 10/15] ovl: constant st_ino/st_dev across copy up
Date: Mon,  1 May 2017 16:42:01 +0300
Message-ID: <1493646126-10101-11-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34378 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1166093AbdEANmQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:16 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When all layers are on the same underlying filesystem, let stat(2)
return st_dev/st_ino values of the copy up origin inode if it is
known.

This results in constant st_ino/st_dev representation of files in an
overlay mount before and after copy up.

When the underlying filesystem support NFS exportfs, the result is also
persistent st_ino/st_dev representation before and after mount cycle.

Lower hardlinks are broken on copy up to differnt upper files, so we
cannot use the lower origin st_ino for those different files, even for
the same fs case.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 17b8418..9c0c4e1 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -69,7 +69,32 @@ static int ovl_getattr(const struct path *path, struct kstat *stat,
 	old_cred = ovl_override_creds(dentry->d_sb);
 	err = vfs_getattr(&realpath, stat, request_mask, flags);
 	revert_creds(old_cred);
-	return err;
+	if (err)
+		return err;
+
+	/*
+	 * When all layers are on the same fs, we use st_ino of the copy up
+	 * origin, if we know it.
+	 * This guaranties constant st_dev/st_ino across copy up.
+	 *
+	 * When redirect_fh is enabled, this also guaranties persistent
+	 * st_ino/st_dev across mount cycle.
+	 */
+	if (ovl_same_sb(dentry->d_sb)) {
+		struct dentry *lower = ovl_dentry_lower(dentry);
+
+		/*
+		 * Lower hardlinks are broken on copy up to differnt upper
+		 * files, so we cannot use the lower origin st_ino for those
+		 * different files, even for the same fs case.
+		 */
+		if (lower && lower->d_inode->i_nlink == 1) {
+			stat->dev = lower->d_sb->s_dev;
+			stat->ino = lower->d_inode->i_ino;
+		}
+	}
+
+	return 0;
 }
 
 int ovl_permission(struct inode *inode, int mask)
-- 
2.7.4

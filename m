From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 11/13] ovl: fix du --one-file-system on overlay mount
Date: Mon, 17 Apr 2017 02:59:41 +0300
Message-ID: <1492387183-18847-12-git-send-email-amir73il@gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35603 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756876AbdDPX7w (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Apr 2017 19:59:52 -0400
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Overlay directory inodes report overlay bdev and overlay ino to stat(2).
Overlay regular file inodes report real bdev and real ino to stat(2).

This results in wrong results from command du -x on an overlay mount,
because the regular files are not accounted for the overlay bdev usage.

The reasons for this inconsistecy is:
1. The overlay ino is not persistent, so real ino is used
2. The tupple overlay bdev and real ino is not unique, so real bdev is
   used

In case all overlay layers are on the same underlying fs, the tupple
from reason 2 above is unique, so use this tupple for regular files and
symlinks to produce the correct result from du -x.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 42fa243..1951865 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -69,6 +69,17 @@ static int ovl_getattr(const struct path *path, struct kstat *stat,
 	old_cred = ovl_override_creds(dentry->d_sb);
 	err = vfs_getattr(&realpath, stat, request_mask, flags);
 	revert_creds(old_cred);
+	if (err)
+		return err;
+
+	/*
+	 * When all layers are on same fs, the tupple overlay bdev
+	 * and real inode ino is unique, so it is preferred to expose
+	 * overlay bdev for overlay inodes for things like du -x.
+	 */
+	if (ovl_same_sb(dentry->d_sb))
+		stat->dev = dentry->d_sb->s_dev;
+
 	return err;
 }
 
-- 
2.7.4

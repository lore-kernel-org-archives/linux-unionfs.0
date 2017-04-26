From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 13/16] ovl: persistent inode number for directories
Date: Thu, 27 Apr 2017 00:35:15 +0300
Message-ID: <1493242518-15266-14-git-send-email-amir73il@gmail.com>
References: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35466 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030881AbdDZVfg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 17:35:36 -0400
In-Reply-To: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

stat(2) on overlay directories reports the overlay temp inode
number, which is constant across copy up, but is not persistent.

When all layers are on the same fs, report the upper most lower inode
(a.k.a stable inode) number for directories.

This inode number is persistent, unique across the overlay mount and
constant across copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 7372c15..da65c02 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -154,8 +154,23 @@ static int ovl_dir_getattr(const struct path *path, struct kstat *stat,
 	if (err)
 		return err;
 
+	/*
+	 * Always use the overlay bdev for directories, so 'find -xdev' will
+	 * scan the entire overlay mount and won't cross the overlay mount
+	 * boundaries.
+	 */
 	stat->dev = dentry->d_sb->s_dev;
-	stat->ino = dentry->d_inode->i_ino;
+	/*
+	 * When all layers are not on the same fs, the pair real inode numbers
+	 * and overlay bdev is not unique, so use the non persistent overlay
+	 * inode number.
+	 * When all layers are on the same fs, use the stable inode number,
+	 * which is persistent, unique and constant across copy up.
+	 */
+	if (!ovl_same_sb(dentry->d_sb))
+		stat->ino = dentry->d_inode->i_ino;
+	else if (OVL_TYPE_UPPER(type) && OVL_TYPE_MERGE(type))
+		stat->ino = ovl_dentry_lower(dentry)->d_inode->i_ino;
 
 	/*
 	 * It's probably not worth it to count subdirs to get the
-- 
2.7.4

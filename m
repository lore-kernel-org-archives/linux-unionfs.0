From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 11/15] ovl: persistent inode number for directories
Date: Mon,  1 May 2017 16:42:02 +0300
Message-ID: <1493646126-10101-12-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35713 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S642154AbdEANmS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:18 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

stat(2) on overlay directories reports the overlay temp inode
number, which is constant across copy up, but is not persistent.

When all layers are on the same fs, report the copy up origin inode
number for directories.

This inode number is persistent, unique across the overlay mount and
constant across copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index bfabc65..17aa007 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -154,8 +154,24 @@ static int ovl_dir_getattr(const struct path *path, struct kstat *stat,
 	if (err)
 		return err;
 
+	/*
+	 * Always use the overlay st_dev for directories, so 'find -xdev' will
+	 * scan the entire overlay mount and won't cross the overlay mount
+	 * boundaries.
+	 */
 	stat->dev = dentry->d_sb->s_dev;
-	stat->ino = dentry->d_inode->i_ino;
+	/*
+	 * When all layers are not on the same fs, the pair real st_ino and
+	 * overlay st_dev is not unique, so use the non persistent overlay
+	 * st_ino.
+	 *
+	 * When all layers are on the same fs, use the copy up origin st_ino,
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

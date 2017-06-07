From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 20/20] ovl: constant inode number for hardlinks
Date: Wed,  7 Jun 2017 10:51:24 +0300
Message-ID: <1496821884-5178-21-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34874 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbdFGHvo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 03:51:44 -0400
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When inodes index feature is enabled, it is safe to return the copy up
origin st_ino for indexed upper hardlinks, because all indexed upper
hardlinks are represented by the same overlay inode as the copy up
origin.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 6e85a2a7fcdc..8a30dc6cd42d 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -96,11 +96,14 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 
 			WARN_ON_ONCE(stat->dev != lowerstat.dev);
 			/*
-			 * Lower hardlinks are broken on copy up to different
+			 * Lower hardlinks may be broken on copy up to different
 			 * upper files, so we cannot use the lower origin st_ino
 			 * for those different files, even for the same fs case.
+			 * Indexed upper inodes are safe and non-hardlinked
+			 * origin inodes are safe.
 			 */
-			if (is_dir || lowerstat.nlink == 1)
+			if (is_dir || lowerstat.nlink == 1 ||
+			    OVL_TYPE_INDEX(type))
 				stat->ino = lowerstat.ino;
 		}
 		stat->dev = dentry->d_sb->s_dev;
-- 
2.7.4

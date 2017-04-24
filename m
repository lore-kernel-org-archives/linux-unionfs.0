From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 11/11] ovl: fix du --one-file-system on overlay mount
Date: Mon, 24 Apr 2017 12:14:16 +0300
Message-ID: <1493025256-27188-12-git-send-email-amir73il@gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35330 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167700AbdDXJO1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Apr 2017 05:14:27 -0400
In-Reply-To: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Overlay directory inodes report overlay bdev to stat(2).
Overlay non-dir inodes report real bdev and real ino to stat(2).

Due to the different bdev values for dir and non-dir inodes, when executing
the command du -x on an overlay mount, the result is wrong because non-dirs
are not accounted for in the overlay bdev usage.

The reasons for this bdev inconsistecy is:
1. The overlay ino is not persistent, so real ino is used for non-dirs
2. The tupple overlay bdev and real ino is not unique, so real bdev is
   used for non-dirs

In case all overlay layers are on the same underlying fs, the tupple
from reason 2 above is unique, so use this tupple for non-dirs to get
the correct result from du -x.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3615a52..39c3bb0 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -78,6 +78,13 @@ static int ovl_getattr(const struct path *path, struct kstat *stat,
 		stat->dev = lower->d_sb->s_dev;
 		stat->ino = lower->d_inode->i_ino;
 	}
+	/*
+	 * When all layers are on same fs, the tupple overlay bdev
+	 * and real inode ino is unique, so it is preferred to expose
+	 * overlay bdev for overlay inodes for things like du -x.
+	 */
+	if (ovl_same_sb(dentry->d_sb))
+		stat->dev = dentry->d_sb->s_dev;
 
 	return err;
 }
-- 
2.7.4

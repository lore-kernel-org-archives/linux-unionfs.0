From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: [PATCH] ovl: copy new uid/gid into overlayfs runtime inode
Date: Sun, 31 Jan 2016 16:21:29 +0300
Message-ID: <145424648900.10573.4331586687947621230.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:36237 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319AbcAaNVf (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 31 Jan 2016 08:21:35 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>

Overlayfs must update uid/gid after chown, otherwise functions
like inode_owner_or_capable() will check user against stale uid.
Catched by xfstests generic/087, it chowns file and calls utimes.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 fs/overlayfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 49e204560655..a4ff5d0d7db9 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -65,6 +65,8 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 
 		inode_lock(upperdentry->d_inode);
 		err = notify_change(upperdentry, attr, NULL);
+		if (!err)
+			ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
 		inode_unlock(upperdentry->d_inode);
 	}
 	ovl_drop_write(dentry);

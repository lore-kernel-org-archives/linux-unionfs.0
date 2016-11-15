From: Quorum Laval <quorum.laval@gmail.com>
Subject: [PATCH 2/2] ovl: use kernel facility for updating access time
Date: Tue, 15 Nov 2016 17:54:54 +0100
Message-ID: <1479228894-10533-2-git-send-email-quorum.laval@gmail.com>
References: <1479228894-10533-1-git-send-email-quorum.laval@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32996 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752445AbcKOQzI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Nov 2016 11:55:08 -0500
In-Reply-To: <1479228894-10533-1-git-send-email-quorum.laval@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: Quorum Laval <quorum.laval@gmail.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

Use fsstack_copy_attr_atime() instead of direct assignement.

Signed-off-by: Quorum Laval <quorum.laval@gmail.com>
---
 fs/overlayfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 540caa6..083cbdb 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -329,7 +329,7 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags)
 	ovl_path_upper(alias, &upperpath);
 	if (upperpath.dentry) {
 		touch_atime(&upperpath);
-		inode->i_atime = d_inode(upperpath.dentry)->i_atime;
+		fsstack_copy_attr_atime(inode, d_inode(upperpath.dentry));
 	}
 
 	dput(alias);
-- 
2.7.4

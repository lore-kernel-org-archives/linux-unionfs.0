From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ovl: avoid setting uninitialized creds
Date: Mon, 19 Sep 2016 14:38:46 +0200
Message-ID: <20160919123859.1335236-1-arnd@arndb.de>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:53528 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754542AbcISMjK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Sep 2016 08:39:10 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andreas Gruenbacher <agruenba@redhat.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

If the call to ovl_copy_up() fails, we now call revert_creds on
an uninitialized structure after a recent patch, as found
by "gcc -Wmayby-uninitialized":

fs/overlayfs/inode.c: In function 'ovl_open_maybe_copy_up':
fs/overlayfs/inode.c:39:2: error: 'old_cred' may be used uninitialized in this function [-Werror=maybe-uninitialized]
fs/overlayfs/inode.c:22:21: note: 'old_cred' was declared here

This changes the code back to not call revert_creds unless
we have already called ovl_override_creds().

Fixes: 54249cd03956 ("ovl: during copy up, switch to mounter's creds early")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/overlayfs/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index af87c7c109b7..65375f9c5563 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -30,13 +30,14 @@ static int ovl_copy_up_truncate(struct dentry *dentry)
 	old_cred = ovl_override_creds(dentry->d_sb);
 	err = vfs_getattr(&lowerpath, &stat);
 	if (err)
-		goto out_dput_parent;
+		goto out_revert;
 
 	stat.size = 0;
 	err = ovl_copy_up_one(parent, dentry, &lowerpath, &stat);
 
-out_dput_parent:
+out_revert:
 	revert_creds(old_cred);
+out_dput_parent:
 	dput(parent);
 	return err;
 }
-- 
2.9.0

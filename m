From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix regression in fsnotify of overlay merge dir
Date: Sun, 28 Jan 2018 01:49:17 +0200
Message-ID: <1517096957-23723-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:52667 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbeA0XsS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 27 Jan 2018 18:48:18 -0500
Received: by mail-wm0-f65.google.com with SMTP id g1so7611458wmg.2
        for <linux-unionfs@vger.kernel.org>; Sat, 27 Jan 2018 15:48:17 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Niklas Cassel <niklas.cassel@axis.com>, Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org

A re-factoring patch in NFS export series has passed the wrong argument
to ovl_get_inode() causing a regression in the very recent fix to
fsnotify of overlay merge dir.

The regression has caused merge directory inodes to be hashed by upper
instead of lower real inode, when NFS export and directory indexing is
disabled. That caused an inotify watch to become obsolete after directory
copy up and drop caches.

I modified new LTP test inotify07 to catch this regression.
The regression also caused multiple redirect dirs to same origin not to
be detected on lookup with NFS export disabled. An xfstest was added to
cover this case.

Fixes: 0aceb53e73be ("ovl: do not pass overlay dentry to ovl_get_inode()")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

Apparently, I've already managed to regress the fsnotify watch fix.
It was only regressed for nfs_export=off case, so I had missed it before.

With this fix in-place, I am going to re-post the xfstest for multiple
redirect to same origin, because it is now going to be detected on lookup
by the default overlayfs configuration (no index, no nfs export).

Thanks,
Amir.

 fs/overlayfs/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c5449efd96d5..d5a060ede8d1 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -976,8 +976,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		upperdentry = dget(index);
 
 	if (upperdentry || ctr) {
-		inode = ovl_get_inode(dentry->d_sb, upperdentry, origin, index,
-				      ctr);
+		inode = ovl_get_inode(dentry->d_sb, upperdentry,
+				      stack[0].dentry, index, ctr);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
-- 
2.7.4

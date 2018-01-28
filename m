From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] ovl: fix regression in fsnotify of overlay merge dir
Date: Sun, 28 Jan 2018 02:35:48 +0200
Message-ID: <1517099748-28812-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:54373 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752051AbeA1Aes (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 27 Jan 2018 19:34:48 -0500
Received: by mail-wm0-f67.google.com with SMTP id i186so7688591wmi.4
        for <linux-unionfs@vger.kernel.org>; Sat, 27 Jan 2018 16:34:48 -0800 (PST)
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

LTP test inotify07 was improved to catch this regression.
The regression also caused multiple redirect dirs to same origin not to
be detected on lookup with NFS export disabled. An xfstest was added to
cover this case.

Fixes: 0aceb53e73be ("ovl: do not pass overlay dentry to ovl_get_inode()")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

Sorry, sent the wrong version.
This is the correct fix.

Thanks,
Amir.

 fs/overlayfs/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c5449efd96d5..de3e6da1d5a5 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -976,6 +976,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		upperdentry = dget(index);
 
 	if (upperdentry || ctr) {
+		if (ctr)
+			origin = stack[0].dentry;
 		inode = ovl_get_inode(dentry->d_sb, upperdentry, origin, index,
 				      ctr);
 		err = PTR_ERR(inode);
-- 
2.7.4

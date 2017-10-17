From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 02/14] ovl: grab i_count reference of lower inode
Date: Tue, 17 Oct 2017 19:44:19 +0300
Message-ID: <1508258671-10800-3-git-send-email-amir73il@gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:57051 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933109AbdJQQoA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 12:44:00 -0400
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

An overlay inode with elevated i_count may outlive its overlay dentry.
Since the only reference to OVL_I(inode)->lower was held by the lower
dentry object in the overlay dentry (oe->lowerstack[0]), releasing the
overlay dentry could leave a live inode with reference to freed lower
inode.

This may materialize to a bug when a disconnected dentry is obtained
from decoding an NFS file handle and a new allocated real inode has
the same address as the freed inode in OVL_I(inode)->lower, by which
the overlay inode is hashed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 1 +
 fs/overlayfs/util.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f3ad8107fec2..3c98991eebcd 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -197,6 +197,7 @@ static void ovl_destroy_inode(struct inode *inode)
 	struct ovl_inode *oi = OVL_I(inode);
 
 	dput(oi->__upperdentry);
+	iput(oi->lower);
 	kfree(oi->redirect);
 	ovl_dir_cache_free(inode);
 	mutex_destroy(&oi->lock);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index c668f9e26c3e..568ea4d4529d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -260,7 +260,7 @@ void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 	if (upperdentry)
 		OVL_I(inode)->__upperdentry = upperdentry;
 	if (lowerdentry)
-		OVL_I(inode)->lower = d_inode(lowerdentry);
+		OVL_I(inode)->lower = igrab(d_inode(lowerdentry));
 
 	ovl_copyattr(d_inode(upperdentry ?: lowerdentry), inode);
 }
-- 
2.7.4

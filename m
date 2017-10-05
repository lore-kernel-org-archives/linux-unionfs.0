From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: grab i_count reference of lower inode
Date: Thu,  5 Oct 2017 23:10:22 +0300
Message-ID: <1507234222-28214-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:45905 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752104AbdJEUJv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 5 Oct 2017 16:09:51 -0400
Received: by mail-wm0-f66.google.com with SMTP id q124so4142136wmb.0
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Oct 2017 13:09:51 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

An overlay inode with elevated i_count may outlive its overlay dentry.
Since the only reference to OVL_I(inode)->lower was held by the lower
dentry object in the overlay dentry (oe->lowerstack[0]), releasing the
overlay dentry could leave a live inode with reference to freed lower
inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

This missing refcount may be hard to expose with current kernel and
I even doubt if it is a bug at all.
If it is a bug, then I suppose it existed even before index feature,
but index feature did shift this aleged bug to lower inode reference.

I think it will take NFS export to manifest that as a real life bug,
by resurecting an overlay inode with a disconnected dentry, but it may
be worth fixing now for the sake of correctness or in case I am missing
how a bug can be manifested?

I wanated to add:
   Fixes: 25b7713afe50 ("ovl: use i_private only as a key")
   Cc: <stable@vger.kernel.org> # v4.13

But given the state of ovl_real_inode() before that commit,
I am not sure if that fix should be tagged as a regression
and if it should be forwarded to stable?

Amir.

 fs/overlayfs/super.c | 1 +
 fs/overlayfs/util.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d161f97d6e86..2c7977d0c95d 100644
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
index 904c60b4e759..25fc2ed17200 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -253,7 +253,7 @@ void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 	if (upperdentry)
 		OVL_I(inode)->__upperdentry = upperdentry;
 	if (lowerdentry)
-		OVL_I(inode)->lower = d_inode(lowerdentry);
+		OVL_I(inode)->lower = igrab(d_inode(lowerdentry));
 
 	ovl_copyattr(d_inode(upperdentry ?: lowerdentry), inode);
 }
-- 
2.7.4

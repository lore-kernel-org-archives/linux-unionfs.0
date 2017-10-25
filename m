From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 02/13] ovl: Create origin xattr on copy up for all files
Date: Wed, 25 Oct 2017 15:09:24 -0400
Message-ID: <1508958575-14086-3-git-send-email-vgoyal@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932332AbdJYTJn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Oct 2017 15:09:43 -0400
In-Reply-To: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

Right now my understanding is that origin xattr is created for all copied
up files if index=on. And if index=off, then we create it for all type
of files except hardlinks (nlink != 1).

With metadata only copy up, I will still require origin xattr to copy up
data later, so create it even for hardlinks even with index=off.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index c441f93..8a8f538 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -470,9 +470,6 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	/*
 	 * Store identifier of lower inode in upper inode xattr to
 	 * allow lookup of the copy up origin inode.
-	 *
-	 * Don't set origin when we are breaking the association with a lower
-	 * hard link.
 	 */
 	if (c->origin) {
 		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
@@ -538,9 +535,6 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 	    c->stat.nlink > 1)
 		indexed = true;
 
-	if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || indexed)
-		c->origin = true;
-
 	if (indexed) {
 		c->destdir = ovl_indexdir(c->dentry->d_sb);
 		err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
@@ -596,6 +590,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		.parent = parent,
 		.dentry = dentry,
 		.workdir = ovl_workdir(dentry),
+		.origin = true,
 	};
 
 	if (WARN_ON(!ctx.workdir))
-- 
2.5.5

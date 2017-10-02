From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/7] Create origin xattr on copy up for all files
Date: Mon,  2 Oct 2017 09:39:59 -0400
Message-ID: <1506951605-31440-2-git-send-email-vgoyal@redhat.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbdJBNkO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Oct 2017 09:40:14 -0400
In-Reply-To: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

Right now my understanding is that origin xattr is created for all copied
up files if index=on. And if index=off, then we create it for all type
of files except hardlinks (nlink != 1).

With metadata only copy up, I will still require origin xattr to copy up
data later, so create it even for hardlinks even with index=off. I am
hoping it does not break anything because we do OVL_INDEX test before
using inode number of origin.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index aad97b30d5e6..f1b15e5c37d3 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -538,9 +538,6 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 	    c->stat.nlink > 1)
 		indexed = true;
 
-	if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || indexed)
-		c->origin = true;
-
 	if (indexed) {
 		c->destdir = ovl_indexdir(c->dentry->d_sb);
 		err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
@@ -598,6 +595,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		.parent = parent,
 		.dentry = dentry,
 		.workdir = ovl_workdir(dentry),
+		.origin = true,
 	};
 
 	if (WARN_ON(!ctx.workdir))
-- 
2.13.5

From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v10 12/18] ovl: Setup origin chain for lower regular files
Date: Mon, 22 Jan 2018 13:39:58 -0500
Message-ID: <20180122184004.26026-13-vgoyal@redhat.com>
References: <20180122184004.26026-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53076 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751113AbeAVSkO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 13:40:14 -0500
In-Reply-To: <20180122184004.26026-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

So far we look for origin only if upper dentry is found. And we look for
origin chain if metacopy feature is enabled.

But with midlayer metacopy support it is possible that a no upper dentry
is there and lower itself is metacopy inode. In that case also we need to
setup origin chain and keep track of which inode is data inode so that
later we can copy up the data from data inode.

So this patch, introduces logic to setup origin chain when upper dentry
is not present. As of now only metacopy feature needs it so it is done
only if metacopy feature is enabled.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index d4ad9408749f..99f896e7bcf2 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -802,6 +802,24 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
+	if (origin_chain && !upperdentry && ctr && !d.is_dir) {
+		int nr_origins = 0;
+		struct ovl_path *stackptr = &stack[1];
+		/*
+		 * If upper is present, we already followed origin. If not,
+		 * follow origin now.
+		 */
+		i = ovl_find_layer(ofs, &stack[0]);
+		i++;
+		err = ovl_check_origin(stack[0].dentry, &roe->lowerstack[i],
+				       ofs->numlower - i, &stackptr,
+				       &nr_origins, true);
+		if (err)
+			goto out_put;
+
+		ctr += nr_origins;
+	}
+
 	oe = ovl_alloc_entry(ctr);
 	err = -ENOMEM;
 	if (!oe)
-- 
2.13.6

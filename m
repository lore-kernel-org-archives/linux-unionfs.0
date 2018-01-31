From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v11 13/18] ovl: Setup origin chain for lower regular files
Date: Wed, 31 Jan 2018 16:13:24 -0500
Message-ID: <20180131211329.16328-14-vgoyal@redhat.com>
References: <20180131211329.16328-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752865AbeAaVNo (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 16:13:44 -0500
In-Reply-To: <20180131211329.16328-1-vgoyal@redhat.com>
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
 fs/overlayfs/namei.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index e26c0bdf0381..f8685f530b57 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -854,6 +854,20 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
+	if (ofs->config.metacopy && !upperdentry && ctr && !d.is_dir) {
+		/*
+		 * If upper is present, we already followed origin. If not,
+		 * follow origin now.
+		 */
+		i = ovl_find_layer(ofs, &stack[0]);
+		i++;
+		err = ovl_get_metacopy_chain(ofs, NULL,
+					   &roe->lowerstack[i],
+					   ofs->numlower - i, stack, &ctr);
+		if (err < 0)
+			goto out_put;
+	}
+
 	oe = ovl_alloc_entry(ctr);
 	err = -ENOMEM;
 	if (!oe)
-- 
2.13.6

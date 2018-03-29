Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39490 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751906AbeC2TjD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Mar 2018 15:39:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 19/28] ovl: Treat metacopy dentries as type OVL_PATH_MERGE
Date: Thu, 29 Mar 2018 15:38:45 -0400
Message-Id: <20180329193854.13814-20-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Right now OVL_PATH_MERGE is used only for merged directories.
But conceptually, a metacopy dentry (backed by a lower data dentry) is
a merged entity as well.

So mark metacopy dentries as OVL_PATH_MERGE and ovl_rename() makes use
of this property later to set redirect on a metacopy file.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 927960aa57ee..29f7336ade88 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -118,7 +118,7 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
 		 */
 		if (oe->numlower) {
 			type |= __OVL_PATH_ORIGIN;
-			if (d_is_dir(dentry))
+			if (d_is_dir(dentry) || !ovl_has_upperdata(dentry))
 				type |= __OVL_PATH_MERGE;
 		}
 	} else {
-- 
2.13.6


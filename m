Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 21/30] ovl: Treat metacopy dentries as type OVL_PATH_MERGE
Date: Mon,  7 May 2018 13:40:53 -0400
Message-Id: <20180507174102.24086-22-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Right now OVL_PATH_MERGE is used only for merged directories.
But conceptually, a metacopy dentry (backed by a lower data dentry) is
a merged entity as well.

So mark metacopy dentries as OVL_PATH_MERGE and ovl_rename() makes use
of this property later to set redirect on a metacopy file.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index eb6453e5cfa6..92ead380f3ec 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -134,7 +134,8 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
 		 */
 		if (oe->numlower) {
 			type |= __OVL_PATH_ORIGIN;
-			if (d_is_dir(dentry))
+			if (d_is_dir(dentry) ||
+			    !ovl_has_upperdata(d_inode(dentry)))
 				type |= __OVL_PATH_MERGE;
 		}
 	} else {
-- 
2.13.6

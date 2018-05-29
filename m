From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 19/28] ovl: Treat metacopy dentries as type OVL_PATH_MERGE
Date: Tue, 29 May 2018 16:46:03 +0200
Message-ID: <20180529144612.16675-20-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Right now OVL_PATH_MERGE is used only for merged directories.  But
conceptually, a metacopy dentry (backed by a lower data dentry) is a merged
entity as well.

So mark metacopy dentries as OVL_PATH_MERGE and ovl_rename() makes use of
this property later to set redirect on a metacopy file.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 73939e08d8bf..61ace2de3019 100644
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
2.14.3

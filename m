From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 14/28] ovl: Add helper ovl_inode_realdata()
Date: Tue, 29 May 2018 16:45:58 +0200
Message-ID: <20180529144612.16675-15-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Add an helper to retrieve real data inode associated with overlay inode.
This helper will ignore all metacopy inodes and will return only the real
inode which has data.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 558a1b444286..dcd600201ec8 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -229,6 +229,7 @@ struct inode *ovl_inode_upper(struct inode *inode);
 struct inode *ovl_inode_lower(struct inode *inode);
 struct inode *ovl_inode_lowerdata(struct inode *inode);
 struct inode *ovl_inode_real(struct inode *inode);
+struct inode *ovl_inode_realdata(struct inode *inode);
 struct ovl_dir_cache *ovl_dir_cache(struct inode *inode);
 void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache);
 void ovl_dentry_set_flag(unsigned long flag, struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 63311c536216..73939e08d8bf 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -256,6 +256,18 @@ struct inode *ovl_inode_lowerdata(struct inode *inode)
 	return OVL_I(inode)->lowerdata ?: ovl_inode_lower(inode);
 }
 
+/* Return real inode which contains data. Does not return metacopy inode */
+struct inode *ovl_inode_realdata(struct inode *inode)
+{
+	struct inode *upperinode;
+
+	upperinode = ovl_inode_upper(inode);
+	if (upperinode && ovl_has_upperdata(inode))
+		return upperinode;
+
+	return ovl_inode_lowerdata(inode);
+}
+
 struct ovl_dir_cache *ovl_dir_cache(struct inode *inode)
 {
 	return OVL_I(inode)->cache;
-- 
2.14.3

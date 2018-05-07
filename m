Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 16/30] ovl: Add helper ovl_inode_real_data()
Date: Mon,  7 May 2018 13:40:48 -0400
Message-Id: <20180507174102.24086-17-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Add an helper to retrieve real data inode associated with overlay inode.
This helper will ignore all metacopy inodes and will return only the
real inode which has data.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8c68387efe87..2dabe5f11d22 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -236,6 +236,7 @@ struct inode *ovl_inode_upper(struct inode *inode);
 struct inode *ovl_inode_lower(struct inode *inode);
 struct inode *ovl_inode_lowerdata(struct inode *inode);
 struct inode *ovl_inode_real(struct inode *inode);
+struct inode *ovl_inode_realdata(struct inode *inode);
 struct ovl_dir_cache *ovl_dir_cache(struct inode *inode);
 void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache);
 void ovl_dentry_set_flag(unsigned long flag, struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 90ea0a1622c7..eb6453e5cfa6 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -268,6 +268,18 @@ struct inode *ovl_inode_lowerdata(struct inode *inode)
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
-- 
2.13.6

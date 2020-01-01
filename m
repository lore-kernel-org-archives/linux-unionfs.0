Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/7] ovl: factor out helper ovl_get_root()
Date: Wed,  1 Jan 2020 19:58:10 +0200
Message-Id: <20200101175814.14144-4-amir73il@gmail.com>
In-Reply-To: <20200101175814.14144-1-amir73il@gmail.com>
References: <20200101175814.14144-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Allocates and initializes the root dentry and inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 2afa60ab9133..18db065d73b3 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1581,6 +1581,34 @@ static int ovl_check_overlapping_layers(struct super_block *sb,
 	return 0;
 }
 
+static struct dentry *ovl_get_root(struct super_block *sb,
+				   struct dentry *upperdentry,
+				   struct ovl_entry *oe)
+{
+	struct dentry *root;
+
+	root = d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
+	if (!root)
+		return NULL;
+
+	root->d_fsdata = oe;
+
+	if (upperdentry) {
+		ovl_dentry_set_upper_alias(root);
+		if (ovl_is_impuredir(upperdentry))
+			ovl_set_flag(OVL_IMPURE, d_inode(root));
+	}
+
+	/* Root is always merge -> can have whiteouts */
+	ovl_set_flag(OVL_WHITEOUTS, d_inode(root));
+	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
+	ovl_set_upperdata(d_inode(root));
+	ovl_inode_init(d_inode(root), upperdentry, ovl_dentry_lower(root),
+		       NULL);
+
+	return root;
+}
+
 static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct path upperpath = { };
@@ -1697,25 +1725,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_flags |= SB_POSIXACL;
 
 	err = -ENOMEM;
-	root_dentry = d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
+	root_dentry = ovl_get_root(sb, upperpath.dentry, oe);
 	if (!root_dentry)
 		goto out_free_oe;
 
-	root_dentry->d_fsdata = oe;
-
 	mntput(upperpath.mnt);
-	if (upperpath.dentry) {
-		ovl_dentry_set_upper_alias(root_dentry);
-		if (ovl_is_impuredir(upperpath.dentry))
-			ovl_set_flag(OVL_IMPURE, d_inode(root_dentry));
-	}
-
-	/* Root is always merge -> can have whiteouts */
-	ovl_set_flag(OVL_WHITEOUTS, d_inode(root_dentry));
-	ovl_dentry_set_flag(OVL_E_CONNECTED, root_dentry);
-	ovl_set_upperdata(d_inode(root_dentry));
-	ovl_inode_init(d_inode(root_dentry), upperpath.dentry,
-		       ovl_dentry_lower(root_dentry), NULL);
 
 	sb->s_root = root_dentry;
 
-- 
2.17.1

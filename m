From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 13/28] ovl: Store lower data inode in ovl_inode
Date: Tue, 29 May 2018 16:45:57 +0200
Message-ID: <20180529144612.16675-14-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Right now ovl_inode stores inode pointer for lower inode.  This helps with
quickly getting lower inode given overlay inode (ovl_inode_lower()).

Now with metadata only copy-up, we can have metacopy inode in middle layer
as well and inode containing data can be different from ->lower.  I need to
be able to open the real file in ovl_open_realfile() and for that I need to
quickly find the lower data inode.

Hence store lower data inode also in ovl_inode.  Also provide an helper
ovl_inode_lowerdata() to access this field.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c     |  2 +-
 fs/overlayfs/namei.c     |  2 ++
 fs/overlayfs/overlayfs.h |  4 +++-
 fs/overlayfs/ovl_entry.h |  5 ++++-
 fs/overlayfs/super.c     |  8 ++++++--
 fs/overlayfs/util.c      | 12 +++++++++++-
 6 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 6a6693150c37..d4e643e9098b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -864,7 +864,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 		}
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
-	ovl_inode_init(inode, upperdentry, lowerdentry);
+	ovl_inode_init(inode, upperdentry, lowerdentry, oip->lowerdata);
 
 	if (upperdentry && ovl_is_impuredir(upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index fcf0eb40d94b..b28b255ea8e2 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1080,6 +1080,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			.index = index,
 			.numlower = ctr,
 			.redirect = upperredirect,
+			.lowerdata = (ctr > 1 && !d.is_dir) ?
+				      stack[ctr - 1].dentry : NULL,
 		};
 
 		inode = ovl_get_inode(dentry->d_sb, &oip);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index ae06fd531b75..558a1b444286 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -227,6 +227,7 @@ struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
 struct inode *ovl_inode_lower(struct inode *inode);
+struct inode *ovl_inode_lowerdata(struct inode *inode);
 struct inode *ovl_inode_real(struct inode *inode);
 struct ovl_dir_cache *ovl_dir_cache(struct inode *inode);
 void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache);
@@ -246,7 +247,7 @@ bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
-		    struct dentry *lowerdentry);
+		    struct dentry *lowerdentry, struct dentry *lowerdata);
 void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
 void ovl_dir_modified(struct dentry *dentry, bool impurity);
 u64 ovl_dentry_version_get(struct dentry *dentry);
@@ -361,6 +362,7 @@ struct ovl_inode_params {
 	struct dentry *index;
 	unsigned int numlower;
 	char *redirect;
+	struct dentry *lowerdata;
 };
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index da65118a0567..6d02ab1f8811 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -90,7 +90,10 @@ static inline struct ovl_entry *OVL_E(struct dentry *dentry)
 }
 
 struct ovl_inode {
-	struct ovl_dir_cache *cache;
+	union {
+		struct ovl_dir_cache *cache;	/* directory */
+		struct inode *lowerdata;	/* regular file */
+	};
 	const char *redirect;
 	u64 version;
 	unsigned long flags;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d96530717702..e0326a686f45 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -187,6 +187,7 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->flags = 0;
 	oi->__upperdentry = NULL;
 	oi->lower = NULL;
+	oi->lowerdata = NULL;
 	mutex_init(&oi->lock);
 
 	return &oi->vfs_inode;
@@ -205,8 +206,11 @@ static void ovl_destroy_inode(struct inode *inode)
 
 	dput(oi->__upperdentry);
 	iput(oi->lower);
+	if (S_ISDIR(inode->i_mode))
+		ovl_dir_cache_free(inode);
+	else
+		iput(oi->lowerdata);
 	kfree(oi->redirect);
-	ovl_dir_cache_free(inode);
 	mutex_destroy(&oi->lock);
 
 	call_rcu(&inode->i_rcu, ovl_i_callback);
@@ -1509,7 +1513,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root_dentry);
 	ovl_set_upperdata(d_inode(root_dentry));
 	ovl_inode_init(d_inode(root_dentry), upperpath.dentry,
-		       ovl_dentry_lower(root_dentry));
+		       ovl_dentry_lower(root_dentry), NULL);
 
 	sb->s_root = root_dentry;
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 4f9c2ecee74c..63311c536216 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -247,6 +247,14 @@ struct inode *ovl_inode_real(struct inode *inode)
 	return ovl_inode_upper(inode) ?: ovl_inode_lower(inode);
 }
 
+/* Return inode which contains lower data. Do not return metacopy */
+struct inode *ovl_inode_lowerdata(struct inode *inode)
+{
+	if (WARN_ON(!S_ISREG(inode->i_mode)))
+		return NULL;
+
+	return OVL_I(inode)->lowerdata ?: ovl_inode_lower(inode);
+}
 
 struct ovl_dir_cache *ovl_dir_cache(struct inode *inode)
 {
@@ -381,7 +389,7 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
 }
 
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
-		    struct dentry *lowerdentry)
+		    struct dentry *lowerdentry, struct dentry *lowerdata)
 {
 	struct inode *realinode = d_inode(upperdentry ?: lowerdentry);
 
@@ -389,6 +397,8 @@ void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 		OVL_I(inode)->__upperdentry = upperdentry;
 	if (lowerdentry)
 		OVL_I(inode)->lower = igrab(d_inode(lowerdentry));
+	if (lowerdata)
+		OVL_I(inode)->lowerdata = igrab(d_inode(lowerdata));
 
 	ovl_copyattr(realinode, inode);
 	ovl_copyflags(realinode, inode);
-- 
2.14.3

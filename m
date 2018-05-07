Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752495AbeEGRlM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 May 2018 13:41:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 15/30] ovl: Store lower data inode in ovl_inode
Date: Mon,  7 May 2018 13:40:47 -0400
Message-Id: <20180507174102.24086-16-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Right now ovl_inode stores inode pointer for lower inode. This helps
with quickly getting lower inode given overlay inode (ovl_inode_lower()).

Now with metadata only copy-up, we can have metacopy inode in middle
layer as well and inode containing data can be different from ->lower.
I need to be able to open the real file in ovl_open_realfile() and
for that I need to quickly find the lower data inode.

Hence store lower data inode also in ovl_inode. Also provide an
helper ovl_inode_lowerdata() to access this field.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/export.c    |  2 +-
 fs/overlayfs/inode.c     |  2 +-
 fs/overlayfs/namei.c     |  7 +++++--
 fs/overlayfs/overlayfs.h |  3 ++-
 fs/overlayfs/ovl_entry.h |  6 +++++-
 fs/overlayfs/super.c     |  8 ++++++--
 fs/overlayfs/util.c      | 10 +++++++++-
 7 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 52a09a9f74b7..77d98aa7f118 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -301,7 +301,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	struct inode *inode;
 	struct ovl_entry *oe;
 	struct ovl_inode_params oip = {sb, NULL, lowerpath, index, !!lower,
-				       NULL};
+				       NULL, NULL};
 
 	/* We get overlay directory dentries with ovl_lookup_real() */
 	if (d_is_dir(upper ?: lower))
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 5d461cd57b48..949ddc7c6f59 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -855,7 +855,7 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
 		}
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
-	ovl_inode_init(inode, upperdentry, lowerdentry);
+	ovl_inode_init(inode, upperdentry, lowerdentry, oip->lowerdata);
 
 	if (upperdentry && ovl_is_impuredir(upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b2ff08985e29..a2556f981d3e 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1076,10 +1076,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		upperdentry = dget(index);
 
 	if (upperdentry || ctr) {
+		struct dentry *lowerdata = NULL;
 		struct ovl_inode_params oip = {dentry->d_sb, upperdentry,
 					       stack, index, ctr,
-					       upperredirect};
-
+					       upperredirect, NULL};
+		if (ctr > 1 && !d.is_dir)
+			lowerdata = stack[ctr - 1].dentry;
+		oip.lowerdata = lowerdata;
 		inode = ovl_get_inode(&oip);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6d64796e0060..8c68387efe87 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -234,6 +234,7 @@ struct dentry *ovl_dentry_realdata(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
 struct inode *ovl_inode_lower(struct inode *inode);
+struct inode *ovl_inode_lowerdata(struct inode *inode);
 struct inode *ovl_inode_real(struct inode *inode);
 struct ovl_dir_cache *ovl_dir_cache(struct inode *inode);
 void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache);
@@ -253,7 +254,7 @@ bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
-		    struct dentry *lowerdentry);
+		    struct dentry *lowerdentry, struct dentry *lowerdata);
 void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
 void ovl_dir_modified(struct dentry *dentry, bool impurity);
 u64 ovl_dentry_version_get(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 422896406048..f72d6191357e 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -90,7 +90,10 @@ static inline struct ovl_entry *OVL_E(struct dentry *dentry)
 }
 
 struct ovl_inode {
-	struct ovl_dir_cache *cache;
+	union {
+		struct ovl_dir_cache *cache;
+		struct inode *lowerdata;
+	};
 	const char *redirect;
 	u64 version;
 	unsigned long flags;
@@ -109,6 +112,7 @@ struct ovl_inode_params {
 	struct dentry *index;
 	unsigned int numlower;
 	char *redirect;
+	struct dentry *lowerdata;
 };
 
 static inline struct ovl_inode *OVL_I(struct inode *inode)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1213c035e9ad..ce90b6e3ce76 100644
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
@@ -1510,7 +1514,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root_dentry);
 	ovl_set_upperdata(d_inode(root_dentry));
 	ovl_inode_init(d_inode(root_dentry), upperpath.dentry,
-		       ovl_dentry_lower(root_dentry));
+		       ovl_dentry_lower(root_dentry), NULL);
 
 	sb->s_root = root_dentry;
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7b7d4623df16..90ea0a1622c7 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -262,6 +262,12 @@ struct inode *ovl_inode_real(struct inode *inode)
 	return ovl_inode_upper(inode) ?: ovl_inode_lower(inode);
 }
 
+/* Return inode which containers lower data. Do not return metacopy */
+struct inode *ovl_inode_lowerdata(struct inode *inode)
+{
+	return OVL_I(inode)->lowerdata ?: ovl_inode_lower(inode);
+}
+
 
 struct ovl_dir_cache *ovl_dir_cache(struct inode *inode)
 {
@@ -396,7 +402,7 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
 }
 
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
-		    struct dentry *lowerdentry)
+		    struct dentry *lowerdentry, struct dentry *lowerdata)
 {
 	struct inode *realinode = d_inode(upperdentry ?: lowerdentry);
 
@@ -404,6 +410,8 @@ void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 		OVL_I(inode)->__upperdentry = upperdentry;
 	if (lowerdentry)
 		OVL_I(inode)->lower = igrab(d_inode(lowerdentry));
+	if (lowerdata)
+		OVL_I(inode)->lowerdata = igrab(d_inode(lowerdata));
 
 	ovl_copyattr(realinode, inode);
 	ovl_copyflags(realinode, inode);
-- 
2.13.6


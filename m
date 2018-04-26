Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752353AbeDZTKk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 14/31] ovl: Store lower data inode in ovl_inode
Date: Thu, 26 Apr 2018 15:09:56 -0400
Message-Id: <20180426191013.13219-15-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
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
 fs/overlayfs/export.c    |  3 ++-
 fs/overlayfs/inode.c     |  5 +++--
 fs/overlayfs/namei.c     |  5 ++++-
 fs/overlayfs/overlayfs.h |  6 ++++--
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     |  4 +++-
 fs/overlayfs/util.c      | 10 +++++++++-
 7 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index e1f6546b6c84..d43d926ae68e 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -305,7 +305,8 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	if (d_is_dir(upper ?: lower))
 		return ERR_PTR(-EIO);
 
-	inode = ovl_get_inode(sb, dget(upper), lowerpath, index, !!lower, NULL);
+	inode = ovl_get_inode(sb, dget(upper), lowerpath, index, !!lower, NULL,
+			      NULL);
 	if (IS_ERR(inode)) {
 		dput(upper);
 		return ERR_CAST(inode);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 9d17f15480de..a6cd57741a1f 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -802,7 +802,8 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
 
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			    struct ovl_path *lowerpath, struct dentry *index,
-			    unsigned int numlower, char *redirect)
+			    unsigned int numlower, char *redirect,
+			    struct dentry *lowerdata)
 {
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
@@ -861,7 +862,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 		}
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
-	ovl_inode_init(inode, upperdentry, lowerdentry);
+	ovl_inode_init(inode, upperdentry, lowerdentry, lowerdata);
 
 	if (upperdentry && ovl_is_impuredir(upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 682f0d402986..b25e32cf5916 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1070,8 +1070,11 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		upperdentry = dget(index);
 
 	if (upperdentry || ctr) {
+		struct dentry *lowerdata = NULL;
+		if (ctr > 1 && !d.is_dir)
+			lowerdata = stack[ctr - 1].dentry;
 		inode = ovl_get_inode(dentry->d_sb, upperdentry, stack, index,
-				      ctr, upperredirect);
+				      ctr, upperredirect, lowerdata);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 29b28ee50b0f..29c3498a7e61 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -234,6 +234,7 @@ struct dentry *ovl_dentry_real_data(struct dentry *dentry);
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
 void ovl_dentry_version_inc(struct dentry *dentry, bool impurity);
 u64 ovl_dentry_version_get(struct dentry *dentry);
@@ -373,7 +374,8 @@ struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper);
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			    struct ovl_path *lowerpath, struct dentry *index,
-			    unsigned int numlower, char *redirect);
+			    unsigned int numlower, char *redirect,
+			    struct dentry *lowerdata);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index da65118a0567..83e031e31ff9 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -97,6 +97,7 @@ struct ovl_inode {
 	struct inode vfs_inode;
 	struct dentry *__upperdentry;
 	struct inode *lower;
+	struct inode *lowerdata;
 
 	/* synchronize copy up and more */
 	struct mutex lock;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 6f5e7ccc3d8f..b81ec9d22ac5 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -182,6 +182,7 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->flags = 0;
 	oi->__upperdentry = NULL;
 	oi->lower = NULL;
+	oi->lowerdata = NULL;
 	mutex_init(&oi->lock);
 
 	return &oi->vfs_inode;
@@ -200,6 +201,7 @@ static void ovl_destroy_inode(struct inode *inode)
 
 	dput(oi->__upperdentry);
 	iput(oi->lower);
+	iput(oi->lowerdata);
 	kfree(oi->redirect);
 	ovl_dir_cache_free(inode);
 	mutex_destroy(&oi->lock);
@@ -1505,7 +1507,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root_dentry);
 	ovl_set_upperdata(d_inode(root_dentry));
 	ovl_inode_init(d_inode(root_dentry), upperpath.dentry,
-		       ovl_dentry_lower(root_dentry));
+		       ovl_dentry_lower(root_dentry), NULL);
 
 	sb->s_root = root_dentry;
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 338de6bdae07..58aa14a02bb0 100644
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


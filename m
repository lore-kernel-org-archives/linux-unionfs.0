Return-Path: <vgoyal@redhat.com>
Date: Tue, 8 May 2018 09:47:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 15/30] ovl: Store lower data inode in ovl_inode
Message-ID: <20180508134717.GE3501@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
 <20180507174102.24086-16-vgoyal@redhat.com>
 <CAOQ4uxheo=KOskjqUOkQ8KHR-F+j+wROW9hRfq=MgPe6q7D2nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxheo=KOskjqUOkQ8KHR-F+j+wROW9hRfq=MgPe6q7D2nA@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 07, 2018 at 09:59:00PM +0300, Amir Goldstein wrote:
> On Mon, May 7, 2018 at 8:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Right now ovl_inode stores inode pointer for lower inode. This helps
> > with quickly getting lower inode given overlay inode (ovl_inode_lower()).
> >
> > Now with metadata only copy-up, we can have metacopy inode in middle
> > layer as well and inode containing data can be different from ->lower.
> > I need to be able to open the real file in ovl_open_realfile() and
> > for that I need to quickly find the lower data inode.
> >
> > Hence store lower data inode also in ovl_inode. Also provide an
> > helper ovl_inode_lowerdata() to access this field.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> After fixing some nits below

Here is the new version of patch.

Subject: ovl: Store lower data inode in ovl_inode

Right now ovl_inode stores inode pointer for lower inode. This helps
with quickly getting lower inode given overlay inode (ovl_inode_lower()).

Now with metadata only copy-up, we can have metacopy inode in middle
layer as well and inode containing data can be different from ->lower.
I need to be able to open the real file in ovl_open_realfile() and
for that I need to quickly find the lower data inode. 

Hence store lower data inode also in ovl_inode. Also provide an
helper ovl_inode_lowerdata() to access this field.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     |    2 +-
 fs/overlayfs/namei.c     |    2 ++
 fs/overlayfs/overlayfs.h |    3 ++-
 fs/overlayfs/ovl_entry.h |    6 +++++-
 fs/overlayfs/super.c     |    8 ++++++--
 fs/overlayfs/util.c      |   10 +++++++++-
 6 files changed, 25 insertions(+), 6 deletions(-)

Index: rhvgoyal-linux/fs/overlayfs/ovl_entry.h
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/ovl_entry.h	2018-05-07 16:48:20.399350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/ovl_entry.h	2018-05-07 16:55:48.911350785 -0400
@@ -90,7 +90,10 @@ static inline struct ovl_entry *OVL_E(st
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
@@ -108,6 +111,7 @@ struct ovl_inode_params {
 	struct dentry *index;
 	unsigned int numlower;
 	char *redirect;
+	struct dentry *lowerdata;
 };
 
 static inline struct ovl_inode *OVL_I(struct inode *inode)
Index: rhvgoyal-linux/fs/overlayfs/inode.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/inode.c	2018-05-07 16:48:20.400350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/inode.c	2018-05-07 16:55:01.997350785 -0400
@@ -856,7 +856,7 @@ struct inode *ovl_get_inode(struct super
 		}
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
-	ovl_inode_init(inode, upperdentry, lowerdentry);
+	ovl_inode_init(inode, upperdentry, lowerdentry, oip->lowerdata);
 
 	if (upperdentry && ovl_is_impuredir(upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
Index: rhvgoyal-linux/fs/overlayfs/util.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/util.c	2018-05-07 16:48:20.402350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/util.c	2018-05-07 16:55:02.683350785 -0400
@@ -262,6 +262,12 @@ struct inode *ovl_inode_real(struct inod
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
@@ -396,7 +402,7 @@ void ovl_dentry_set_redirect(struct dent
 }
 
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
-		    struct dentry *lowerdentry)
+		    struct dentry *lowerdentry, struct dentry *lowerdata)
 {
 	struct inode *realinode = d_inode(upperdentry ?: lowerdentry);
 
@@ -404,6 +410,8 @@ void ovl_inode_init(struct inode *inode,
 		OVL_I(inode)->__upperdentry = upperdentry;
 	if (lowerdentry)
 		OVL_I(inode)->lower = igrab(d_inode(lowerdentry));
+	if (lowerdata)
+		OVL_I(inode)->lowerdata = igrab(d_inode(lowerdata));
 
 	ovl_copyattr(realinode, inode);
 	ovl_copyflags(realinode, inode);
Index: rhvgoyal-linux/fs/overlayfs/overlayfs.h
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/overlayfs.h	2018-05-07 16:48:20.403350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/overlayfs.h	2018-05-07 16:55:02.683350785 -0400
@@ -234,6 +234,7 @@ struct dentry *ovl_dentry_realdata(struc
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
 struct inode *ovl_inode_lower(struct inode *inode);
+struct inode *ovl_inode_lowerdata(struct inode *inode);
 struct inode *ovl_inode_real(struct inode *inode);
 struct ovl_dir_cache *ovl_dir_cache(struct inode *inode);
 void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache);
@@ -253,7 +254,7 @@ bool ovl_redirect_dir(struct super_block
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
-		    struct dentry *lowerdentry);
+		    struct dentry *lowerdentry, struct dentry *lowerdata);
 void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
 void ovl_dir_modified(struct dentry *dentry, bool impurity);
 u64 ovl_dentry_version_get(struct dentry *dentry);
Index: rhvgoyal-linux/fs/overlayfs/super.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/super.c	2018-05-07 16:48:20.405350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/super.c	2018-05-07 16:55:02.443350785 -0400
@@ -187,6 +187,7 @@ static struct inode *ovl_alloc_inode(str
 	oi->flags = 0;
 	oi->__upperdentry = NULL;
 	oi->lower = NULL;
+	oi->lowerdata = NULL;
 	mutex_init(&oi->lock);
 
 	return &oi->vfs_inode;
@@ -205,8 +206,11 @@ static void ovl_destroy_inode(struct ino
 
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
@@ -1510,7 +1514,7 @@ static int ovl_fill_super(struct super_b
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root_dentry);
 	ovl_set_upperdata(d_inode(root_dentry));
 	ovl_inode_init(d_inode(root_dentry), upperpath.dentry,
-		       ovl_dentry_lower(root_dentry));
+		       ovl_dentry_lower(root_dentry), NULL);
 
 	sb->s_root = root_dentry;
 
Index: rhvgoyal-linux/fs/overlayfs/namei.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/namei.c	2018-05-07 16:48:23.302350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/namei.c	2018-05-07 16:55:02.379350785 -0400
@@ -1082,6 +1082,8 @@ struct dentry *ovl_lookup(struct inode *
 			.index = index,
 			.numlower = ctr,
 			.redirect = upperredirect,
+			.lowerdata = (ctr > 1 && !d.is_dir) ?
+				      stack[ctr - 1].dentry : NULL,
 		};
 
 		inode = ovl_get_inode(dentry->d_sb, &oip);

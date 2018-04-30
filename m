Return-Path: <vgoyal@redhat.com>
Date: Mon, 30 Apr 2018 15:32:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v14 09/31] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Message-ID: <20180430193201.GC7960@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
 <20180426191013.13219-10-vgoyal@redhat.com>
 <CAOQ4uxg5xDZJVuys69QtGBRGcs3=zfkJQoZgTZRp+cG+GGVzEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg5xDZJVuys69QtGBRGcs3=zfkJQoZgTZRp+cG+GGVzEQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Apr 28, 2018 at 01:14:24AM -0700, Amir Goldstein wrote:

[..]
> > @@ -836,6 +836,15 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
> >         if (index)
> >                 ovl_set_flag(OVL_INDEX, inode);
> >
> > +       if (upperdentry) {
> > +               err = ovl_check_metacopy_xattr(upperdentry);
> > +               if (err < 0)
> > +                       goto out_err;
> > +               metacopy = err;
> > +               if (!metacopy)
> > +                       ovl_set_flag(OVL_UPPERDATA, inode);
> > +       }
> > +
> 
> There is no reason to ovl_check_metacopy_xattr again here, right?
> so it should get the same treatment as upperredirect.
> This would make 3 new arguments to ovl_get_inode added by your patch set.
> 
> How about initializing this struct during lookup and passing it into
> ovl_get_inode()?:

How about just creating another structure to pass in parameters to
ovl_get_inode() and then let it extract relevant info and initialize
inode.  Something like this.

---
 fs/overlayfs/export.c    |    6 ++++--
 fs/overlayfs/inode.c     |   26 +++++++++++++-------------
 fs/overlayfs/namei.c     |    6 ++++--
 fs/overlayfs/overlayfs.h |    5 +----
 fs/overlayfs/ovl_entry.h |   10 ++++++++++
 5 files changed, 32 insertions(+), 21 deletions(-)

Index: rhvgoyal-linux/fs/overlayfs/ovl_entry.h
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/ovl_entry.h	2018-04-30 14:45:57.945867987 -0400
+++ rhvgoyal-linux/fs/overlayfs/ovl_entry.h	2018-04-30 14:53:48.275867987 -0400
@@ -103,6 +103,16 @@ struct ovl_inode {
 	struct mutex lock;
 };
 
+struct ovl_inode_params {
+	struct super_block *sb;
+	struct dentry *upperdentry;
+	struct ovl_path *lowerpath;
+	struct dentry *index;
+	unsigned int numlower;
+	char *redirect;
+	struct dentry *lowerdata;
+};
+
 static inline struct ovl_inode *OVL_I(struct inode *inode)
 {
 	return container_of(inode, struct ovl_inode, vfs_inode);
Index: rhvgoyal-linux/fs/overlayfs/namei.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/namei.c	2018-04-30 14:32:37.608867987 -0400
+++ rhvgoyal-linux/fs/overlayfs/namei.c	2018-04-30 15:27:28.393867987 -0400
@@ -1072,10 +1072,12 @@ struct dentry *ovl_lookup(struct inode *
 
 	if (upperdentry || ctr) {
 		struct dentry *lowerdata = NULL;
+		struct ovl_inode_params oip = {dentry->d_sb, upperdentry, stack,					       index, ctr, upperredirect};
 		if (ctr > 1 && !d.is_dir)
 			lowerdata = stack[ctr - 1].dentry;
-		inode = ovl_get_inode(dentry->d_sb, upperdentry, stack, index,
-				      ctr, upperredirect, lowerdata);
+
+		oip.lowerdata = lowerdata;
+		inode = ovl_get_inode(&oip);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
Index: rhvgoyal-linux/fs/overlayfs/inode.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/inode.c	2018-04-30 14:45:51.749867987 -0400
+++ rhvgoyal-linux/fs/overlayfs/inode.c	2018-04-30 15:20:20.009867987 -0400
@@ -800,16 +800,16 @@ static bool ovl_hash_bylower(struct supe
 	return true;
 }
 
-struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
-			    struct ovl_path *lowerpath, struct dentry *index,
-			    unsigned int numlower, char *redirect,
-			    struct dentry *lowerdata)
+struct inode *ovl_get_inode(struct ovl_inode_params *oip)
 {
+	struct dentry *upperdentry = oip->upperdentry;
+	struct ovl_path *lowerpath = oip->lowerpath;
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
 	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
-	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
-	int fsid = bylower ? lowerpath->layer->fsid : 0;
+	bool bylower = ovl_hash_bylower(oip->sb, upperdentry, lowerdentry,
+					oip->index);
+	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
 	bool is_dir, metacopy = false;
 	unsigned long ino = 0;
 	int err = -ENOMEM;
@@ -827,7 +827,7 @@ struct inode *ovl_get_inode(struct super
 						      upperdentry);
 		unsigned int nlink = is_dir ? 1 : realinode->i_nlink;
 
-		inode = iget5_locked(sb, (unsigned long) key,
+		inode = iget5_locked(oip->sb, (unsigned long) key,
 				     ovl_inode_test, ovl_inode_set, key);
 		if (!inode)
 			goto out_err;
@@ -844,7 +844,7 @@ struct inode *ovl_get_inode(struct super
 			}
 
 			dput(upperdentry);
-			kfree(redirect);
+			kfree(oip->redirect);
 			goto out;
 		}
 
@@ -855,19 +855,19 @@ struct inode *ovl_get_inode(struct super
 		ino = key->i_ino;
 	} else {
 		/* Lower hardlink that will be broken on copy up */
-		inode = new_inode(sb);
+		inode = new_inode(oip->sb);
 		if (!inode) {
 			err = -ENOMEM;
 			goto out_err;
 		}
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
-	ovl_inode_init(inode, upperdentry, lowerdentry, lowerdata);
+	ovl_inode_init(inode, upperdentry, lowerdentry, oip->lowerdata);
 
 	if (upperdentry && ovl_is_impuredir(upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
 
-	if (index)
+	if (oip->index)
 		ovl_set_flag(OVL_INDEX, inode);
 
 	if (upperdentry) {
@@ -879,14 +879,14 @@ struct inode *ovl_get_inode(struct super
 			ovl_set_flag(OVL_UPPERDATA, inode);
 	}
 
-	OVL_I(inode)->redirect = redirect;
+	OVL_I(inode)->redirect = oip->redirect;
 
 	if (bylower)
 		ovl_set_flag(OVL_CONST_INO, inode);
 
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
-		if (((upperdentry && lowerdentry) || numlower > 1) ||
+		if (((upperdentry && lowerdentry) || oip->numlower > 1) ||
 		    ovl_check_origin_xattr(upperdentry ?: lowerdentry)) {
 			ovl_set_flag(OVL_WHITEOUTS, inode);
 		}
Index: rhvgoyal-linux/fs/overlayfs/overlayfs.h
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/overlayfs.h	2018-04-30 14:32:37.608867987 -0400
+++ rhvgoyal-linux/fs/overlayfs/overlayfs.h	2018-04-30 15:07:09.204867987 -0400
@@ -375,10 +375,7 @@ bool ovl_is_private_xattr(const char *na
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper);
-struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
-			    struct ovl_path *lowerpath, struct dentry *index,
-			    unsigned int numlower, char *redirect,
-			    struct dentry *lowerdata);
+struct inode *ovl_get_inode(struct ovl_inode_params *oip);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
Index: rhvgoyal-linux/fs/overlayfs/export.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/export.c	2018-04-30 09:41:53.656867987 -0400
+++ rhvgoyal-linux/fs/overlayfs/export.c	2018-04-30 15:26:45.957867987 -0400
@@ -300,13 +300,15 @@ static struct dentry *ovl_obtain_alias(s
 	struct dentry *dentry;
 	struct inode *inode;
 	struct ovl_entry *oe;
+	struct ovl_inode_params oip = {sb, NULL, lowerpath, index, !!lower,
+				       NULL, NULL};
 
 	/* We get overlay directory dentries with ovl_lookup_real() */
 	if (d_is_dir(upper ?: lower))
 		return ERR_PTR(-EIO);
 
-	inode = ovl_get_inode(sb, dget(upper), lowerpath, index, !!lower, NULL,
-			      NULL);
+	oip.upperdentry = dget(upper);
+	inode = ovl_get_inode(&oip);
 	if (IS_ERR(inode)) {
 		dput(upper);
 		return ERR_CAST(inode);

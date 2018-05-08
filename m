Return-Path: <vgoyal@redhat.com>
Date: Tue, 8 May 2018 09:45:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 01/30] ovl: Pass argument to ovl_get_inode() in a
 structure
Message-ID: <20180508134505.GD3501@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
 <20180507174102.24086-2-vgoyal@redhat.com>
 <CAOQ4uxiP4LTDaGPTbiMDp4CMRQKo3DzaTspJfj=zrePxgqPpHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiP4LTDaGPTbiMDp4CMRQKo3DzaTspJfj=zrePxgqPpHw@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 07, 2018 at 10:26:15PM +0300, Amir Goldstein wrote:
> On Mon, May 7, 2018 at 8:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > ovl_get_inode() right now has 5 parameters. Soon this patch series will
> > add 2 more and suddenly argument list starts looking too long.
> >
> > Hence pass arguments to ovl_get_inode() in a structure and it looks
> > little cleaner.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> After fixing some nits

Here is the new version of patch.

Subject: ovl: Pass argument to ovl_get_inode() in a structure

ovl_get_inode() right now has 5 parameters. Soon this patch series will
add 2 more and suddenly argument list starts looking too long.

Hence pass arguments to ovl_get_inode() in a structure and it looks
little cleaner.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    |    8 +++++++-
 fs/overlayfs/inode.c     |   20 +++++++++++---------
 fs/overlayfs/namei.c     |   10 ++++++++--
 fs/overlayfs/overlayfs.h |    5 ++---
 fs/overlayfs/ovl_entry.h |    7 +++++++
 5 files changed, 35 insertions(+), 15 deletions(-)

Index: rhvgoyal-linux/fs/overlayfs/ovl_entry.h
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/ovl_entry.h	2018-05-07 16:30:06.874350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/ovl_entry.h	2018-05-07 16:42:22.396350785 -0400
@@ -101,6 +101,13 @@ struct ovl_inode {
 	struct mutex lock;
 };
 
+struct ovl_inode_params {
+	struct dentry *upperdentry;
+	struct ovl_path *lowerpath;
+	struct dentry *index;
+	unsigned int numlower;
+};
+
 static inline struct ovl_inode *OVL_I(struct inode *inode)
 {
 	return container_of(inode, struct ovl_inode, vfs_inode);
Index: rhvgoyal-linux/fs/overlayfs/namei.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/namei.c	2018-05-07 16:30:06.874350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/namei.c	2018-05-07 16:42:22.398350785 -0400
@@ -1004,8 +1004,14 @@ struct dentry *ovl_lookup(struct inode *
 		upperdentry = dget(index);
 
 	if (upperdentry || ctr) {
-		inode = ovl_get_inode(dentry->d_sb, upperdentry, stack, index,
-				      ctr);
+		struct ovl_inode_params oip = {
+			.upperdentry = upperdentry,
+			.lowerpath = stack,
+			.index = index,
+			.numlower = ctr,
+		};
+
+		inode = ovl_get_inode(dentry->d_sb, &oip);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
Index: rhvgoyal-linux/fs/overlayfs/inode.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/inode.c	2018-05-07 16:30:06.874350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/inode.c	2018-05-07 16:42:22.395350785 -0400
@@ -792,15 +792,17 @@ static bool ovl_hash_bylower(struct supe
 	return true;
 }
 
-struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
-			    struct ovl_path *lowerpath, struct dentry *index,
-			    unsigned int numlower)
+struct inode *ovl_get_inode(struct super_block *sb,
+			    struct ovl_inode_params *oip)
 {
+	struct dentry *upperdentry = oip->upperdentry;
+	struct ovl_path *lowerpath = oip->lowerpath;
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
 	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
-	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
-	int fsid = bylower ? lowerpath->layer->fsid : 0;
+	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry,
+					oip->index);
+	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
 	bool is_dir;
 	unsigned long ino = 0;
 
@@ -817,8 +819,8 @@ struct inode *ovl_get_inode(struct super
 						      upperdentry);
 		unsigned int nlink = is_dir ? 1 : realinode->i_nlink;
 
-		inode = iget5_locked(sb, (unsigned long) key,
-				     ovl_inode_test, ovl_inode_set, key);
+		inode = iget5_locked(sb, (unsigned long) key, ovl_inode_test,
+				     ovl_inode_set, key);
 		if (!inode)
 			goto out_nomem;
 		if (!(inode->i_state & I_NEW)) {
@@ -854,12 +856,12 @@ struct inode *ovl_get_inode(struct super
 	if (upperdentry && ovl_is_impuredir(upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
 
-	if (index)
+	if (oip->index)
 		ovl_set_flag(OVL_INDEX, inode);
 
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
-		if (((upperdentry && lowerdentry) || numlower > 1) ||
+		if (((upperdentry && lowerdentry) || oip->numlower > 1) ||
 		    ovl_check_origin_xattr(upperdentry ?: lowerdentry)) {
 			ovl_set_flag(OVL_WHITEOUTS, inode);
 		}
Index: rhvgoyal-linux/fs/overlayfs/overlayfs.h
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/overlayfs.h	2018-05-07 16:30:06.874350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/overlayfs.h	2018-05-07 16:37:45.222350785 -0400
@@ -345,9 +345,8 @@ bool ovl_is_private_xattr(const char *na
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper);
-struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
-			    struct ovl_path *lowerpath, struct dentry *index,
-			    unsigned int numlower);
+struct inode *ovl_get_inode(struct super_block *sb,
+			    struct ovl_inode_params *oip);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
Index: rhvgoyal-linux/fs/overlayfs/export.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/export.c	2018-05-07 16:30:06.874350785 -0400
+++ rhvgoyal-linux/fs/overlayfs/export.c	2018-05-07 16:41:57.905350785 -0400
@@ -300,12 +300,18 @@ static struct dentry *ovl_obtain_alias(s
 	struct dentry *dentry;
 	struct inode *inode;
 	struct ovl_entry *oe;
+	struct ovl_inode_params oip = {
+		.lowerpath = lowerpath,
+		.index = index,
+		.numlower = !!lower
+	};
 
 	/* We get overlay directory dentries with ovl_lookup_real() */
 	if (d_is_dir(upper ?: lower))
 		return ERR_PTR(-EIO);
 
-	inode = ovl_get_inode(sb, dget(upper), lowerpath, index, !!lower);
+	oip.upperdentry = dget(upper);
+	inode = ovl_get_inode(sb, &oip);
 	if (IS_ERR(inode)) {
 		dput(upper);
 		return ERR_CAST(inode);

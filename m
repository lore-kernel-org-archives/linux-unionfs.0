From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Bug#836211: dpkg: Cannot upgrade some packages on overlayfs:
 Invalid cross-device link
Date: Mon, 5 Sep 2016 10:28:59 +0200
Message-ID: <20160905082859.GM25404@veci.piliscsaba.szeredi.hu>
References: <147265657047.31705.7496372748096616425.reportbug@felipepc>
 <20160902113633.5kbibrlwlhhlppyr@home.ouaza.com>
 <CAJfpegu-JhRpDmzx1=fLsnL+=FTsAX21Up5A6s4eQFDPZ2ET3g@mail.gmail.com>
 <20160902130353.tzrthpcakf5hk54n@gaara.hadrons.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36130 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751627AbcIEI3E (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Sep 2016 04:29:04 -0400
Received: by mail-wm0-f44.google.com with SMTP id b187so8128669wme.1
        for <linux-unionfs@vger.kernel.org>; Mon, 05 Sep 2016 01:29:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160902130353.tzrthpcakf5hk54n@gaara.hadrons.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Guillem Jover <guillem@debian.org>, 836211@bugs.debian.org, Raphael Hertzog <hertzog@debian.org>, Felipe Sateler <fsateler@debian.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Sep 02, 2016 at 03:03:54PM +0200, Guillem Jover wrote:
> Hi!
> 
> On Fri, 2016-09-02 at 14:30:58 +0200, Miklos Szeredi wrote:
> > You are the first to report that this quirk actually causes problems
> > in real life.
> > 
> > I have plans to fix this by adding a "redirector" attribute so that
> > copied up directories (and perhaps files) can refer to lower directory
> > that is found at a different location relative to the root of the
> > overlay from the location of the upper directory.
> > 
> > Maybe an example can make this more clear:
> > 
> > lower/foo/bar/baz
> > upper/foo/bar <- whiteout
> > upper/moved/here <- redirects to "foo/bar"
> > 
> > will result in the tree:
> > 
> > overlay/moved/here/baz
> 
> That'd be very much appreciated, thanks!

Toy patch attached.  Passes minimal test.

It does not deal with multi-layer setups when one of the lower layers was
previously an upper layer (generally overlayfs does support this, so this patch
will need to deal with that case).

You can help by

 - review it
 - improve it
 - test it
 - break it
 - write test cases in xfstests

Thanks,
Miklos

---
 fs/overlayfs/dir.c       |   42 ++++++++++++++++++++--
 fs/overlayfs/overlayfs.h |    1 
 fs/overlayfs/super.c     |   89 +++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 119 insertions(+), 13 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -764,6 +764,31 @@ static int ovl_rmdir(struct inode *dir,
 	return ovl_do_remove(dentry, true);
 }
 
+static bool ovl_can_move(struct dentry *dentry, enum ovl_path_type type)
+{
+//	return !d_is_dir(dentry) || !OVL_TYPE_MERGE_OR_LOWER(type);
+	return true;
+}
+
+static int ovl_set_redirect(struct dentry *dentry)
+{
+	char *buf = __getname();
+	char *path;
+	int err;
+
+	if (!buf)
+		return -ENOMEM;
+
+	path = dentry_path_raw(dentry, buf, PATH_MAX);
+
+	printk(KERN_WARNING "redirect: <%s>\n", path);
+	err = ovl_do_setxattr(ovl_dentry_upper(dentry), OVL_XATTR_REDIRECT,
+			      path, strlen(path), 0);
+	__putname(buf);
+
+	return err;
+}
+
 static int ovl_rename2(struct inode *olddir, struct dentry *old,
 		       struct inode *newdir, struct dentry *new,
 		       unsigned int flags)
@@ -798,7 +823,7 @@ static int ovl_rename2(struct inode *old
 	/* Don't copy up directory trees */
 	old_type = ovl_path_type(old);
 	err = -EXDEV;
-	if (OVL_TYPE_MERGE_OR_LOWER(old_type) && is_dir)
+	if (!ovl_can_move(old, old_type))
 		goto out;
 
 	if (new->d_inode) {
@@ -811,7 +836,7 @@ static int ovl_rename2(struct inode *old
 
 		new_type = ovl_path_type(new);
 		err = -EXDEV;
-		if (!overwrite && OVL_TYPE_MERGE_OR_LOWER(new_type) && new_is_dir)
+		if (!overwrite && !ovl_can_move(new, new_type))
 			goto out;
 
 		err = 0;
@@ -883,7 +908,6 @@ static int ovl_rename2(struct inode *old
 
 	trap = lock_rename(new_upperdir, old_upperdir);
 
-
 	olddentry = lookup_one_len(old->d_name.name, old_upperdir,
 				   old->d_name.len);
 	err = PTR_ERR(olddentry);
@@ -920,11 +944,23 @@ static int ovl_rename2(struct inode *old
 	if (newdentry == trap)
 		goto out_dput;
 
+	printk(KERN_WARNING "is_dir: %i, old_opaque: %i, old_type: %i\n",
+	       is_dir, old_opaque, old_type);
+	if (is_dir && OVL_TYPE_MERGE_OR_LOWER(old_type)) {
+		err = ovl_set_redirect(old);
+		if (err)
+			goto out_dput;
+	}
 	if (is_dir && !old_opaque && new_opaque) {
 		err = ovl_set_opaque(olddentry);
 		if (err)
 			goto out_dput;
 	}
+	if (!overwrite && new_is_dir && OVL_TYPE_MERGE_OR_LOWER(new_type)) {
+		err = ovl_set_redirect(new);
+		if (err)
+			goto out_dput;
+	}
 	if (!overwrite && new_is_dir && old_opaque && !new_opaque) {
 		err = ovl_set_opaque(newdentry);
 		if (err)
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -26,6 +26,7 @@ enum ovl_path_type {
 
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
+#define OVL_XATTR_REDIRECT OVL_XATTR_PREFIX "redirect"
 
 #define OVL_ISUPPER_MASK 1UL
 
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -285,6 +285,33 @@ static bool ovl_is_opaquedir(struct dent
 	return false;
 }
 
+static int ovl_check_redirect(struct dentry *dentry, char **bufp)
+{
+	struct inode *inode = dentry->d_inode;
+	int res;
+
+	if (!S_ISDIR(inode->i_mode) || !inode->i_op->getxattr)
+		return false;
+
+	res = inode->i_op->getxattr(dentry, inode, OVL_XATTR_REDIRECT, NULL, 0);
+	if (res > 0) {
+		char *buf = kzalloc(res + 1, GFP_KERNEL);
+
+		if (!buf)
+			return -ENOMEM;
+
+		res = inode->i_op->getxattr(dentry, inode, OVL_XATTR_REDIRECT,
+					    buf, res);
+		if (res < 0)
+			return res;
+
+		kfree(*bufp);
+		*bufp = buf;
+	}
+
+	return 0;
+}
+
 static void ovl_dentry_release(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
@@ -465,6 +492,9 @@ int ovl_path_next(int idx, struct dentry
 	return (idx < oe->numlower) ? idx + 1 : -1;
 }
 
+extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
+			   const char *, unsigned int, struct path *);
+
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags)
 {
@@ -478,6 +508,7 @@ struct dentry *ovl_lookup(struct inode *
 	struct dentry *this, *prev = NULL;
 	unsigned int i;
 	int err;
+	char *redirect = NULL;
 
 	upperdir = ovl_upperdentry_dereference(poe);
 	if (upperdir) {
@@ -498,11 +529,18 @@ struct dentry *ovl_lookup(struct inode *
 				upperopaque = true;
 			} else if (poe->numlower && ovl_is_opaquedir(this)) {
 				upperopaque = true;
+			} else if (d_is_dir(this)) {
+				err = ovl_check_redirect(this, &redirect);
+				if (err)
+					goto out;
 			}
 		}
 		upperdentry = prev = this;
 	}
 
+	if (redirect)
+		poe = dentry->d_sb->s_root->d_fsdata;
+
 	if (!upperopaque && poe->numlower) {
 		err = -ENOMEM;
 		stack = kcalloc(poe->numlower, sizeof(struct path), GFP_KERNEL);
@@ -514,16 +552,45 @@ struct dentry *ovl_lookup(struct inode *
 		bool opaque = false;
 		struct path lowerpath = poe->lowerstack[i];
 
-		this = ovl_lookup_real(dentry->d_sb,
-				       lowerpath.dentry, &dentry->d_name);
-		err = PTR_ERR(this);
-		if (IS_ERR(this)) {
-			/*
-			 * If it's positive, then treat ENAMETOOLONG as ENOENT.
-			 */
-			if (err == -ENAMETOOLONG && (upperdentry || ctr))
-				continue;
-			goto out_put;
+		if (!redirect) {
+			this = ovl_lookup_real(dentry->d_sb,
+					       lowerpath.dentry, &dentry->d_name);
+			err = PTR_ERR(this);
+			if (IS_ERR(this)) {
+				/*
+				 * If it's positive, then treat ENAMETOOLONG as ENOENT.
+				 */
+				if (err == -ENAMETOOLONG && (upperdentry || ctr))
+					continue;
+				goto out_put;
+			}
+		} else {
+			struct path thispath;
+
+			err = vfs_path_lookup(lowerpath.dentry, lowerpath.mnt,
+					      redirect, 0, &thispath);
+
+			if (err) {
+				if (err == -ENOENT)
+					this = NULL;
+				else if (err == -ENAMETOOLONG)
+					this = NULL;
+			} else {
+				this = thispath.dentry;
+				mntput(thispath.mnt);
+				if (err == -ENOENT) {
+					dput(this);
+					this = NULL;
+				} else if (!this->d_inode) {
+					dput(this);
+					this = NULL;
+				} else if (ovl_dentry_weird(this)) {
+					dput(this);
+					err = -EREMOTE;
+				}
+			}
+			if (err)
+				goto out_put;
 		}
 		if (!this)
 			continue;
@@ -592,6 +659,7 @@ struct dentry *ovl_lookup(struct inode *
 	oe->__upperdentry = upperdentry;
 	memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
 	kfree(stack);
+	kfree(redirect);
 	dentry->d_fsdata = oe;
 	d_add(dentry, inode);
 
@@ -606,6 +674,7 @@ struct dentry *ovl_lookup(struct inode *
 out_put_upper:
 	dput(upperdentry);
 out:
+	kfree(redirect);
 	return ERR_PTR(err);
 }
 

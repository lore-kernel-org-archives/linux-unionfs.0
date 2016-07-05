From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 5/5] overlayfs: Use vfs_getxattr_noperm() for real inode
Date: Tue, 5 Jul 2016 17:16:38 -0400
Message-ID: <20160705211638.GH17987@redhat.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
 <1467733854-6314-6-git-send-email-vgoyal@redhat.com>
 <b62a4ca9-3f75-b662-108b-1dec85c40ba1@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b62a4ca9-3f75-b662-108b-1dec85c40ba1@schaufler-ca.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, pmoore@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jul 05, 2016 at 01:29:39PM -0700, Casey Schaufler wrote:
> On 7/5/2016 8:50 AM, Vivek Goyal wrote:
> > ovl_getxattr() currently uses vfs_getxattr() on realinode. This fails
> > if mounter does not have DAC/MAC permission to access getxattr.
> >
> > Specifically this becomes a problem when selinux is trying to initialize
> > overlay inode and does ->getxattr(overlay_inode). A task might trigger
> > initialization of overlay inode and we will access real inode xattr in the
> > context of mounter and if mounter does not have permissions, then inode
> > selinux context initialization fails and inode is labeled as unlabeled_t.
> >
> > One way to deal with it is to let SELinux do getxattr checks both on
> > overlay inode and underlying inode and overlay can call vfs_getxattr_noperm()
> > to make sure when selinux is trying to initialize label on inode, it does
> > not go through checks on lower levels and initialization is successful.
> > And after inode initialization, SELinux will make sure task has getatttr
> > permission.
> >
> > One issue with this approach is that it does not work for directories as
> > d_real() returns the overlay dentry for directories and not the underlying
> > directory dentry.
> >
> > Another way to deal with it to introduce another function pointer in
> > inode_operations, say getxattr_noperm(), which is responsible to get
> > xattr without any checks. SELinux initialization code will call this
> > first if it is available on inode. So user space code path will call
> > ->getxattr() and that will go through checks and SELinux internal
> > initialization will call ->getxattr_noperm() and that will not
> > go through checks.
> >
> > For now, I am just converting ovl_getxattr() to get xattr without
> > any checks on underlying inode. That means it is possible for
> > a task to get xattr of a file/dir on lower/upper through overlay mount
> > while it is not possible outside overlay mount.
> >
> > If this is a major concern, I can look into implementing getxattr_noperm().
> 
> This is a major concern.

Hmm.., In that case I will write patch to provide another inode operation
getxattr_noperm() and a wrapper which falls back to getxattr() if noperm
variant is not defined. That should take care of this issue.

Thanks
Vivek
> 
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/inode.c  |  7 +------
> >  fs/xattr.c            | 28 +++++++++++++++++++---------
> >  include/linux/xattr.h |  1 +
> >  3 files changed, 21 insertions(+), 15 deletions(-)
> >
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index 36dfd86..a5d3320 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -233,16 +233,11 @@ ssize_t ovl_getxattr(struct dentry *dentry, struct inode *inode,
> >  		     const char *name, void *value, size_t size)
> >  {
> >  	struct dentry *realdentry = ovl_dentry_real(dentry);
> > -	ssize_t sz;
> > -	const struct cred *old_cred;
> >  
> >  	if (ovl_is_private_xattr(name))
> >  		return -ENODATA;
> >  
> > -	old_cred = ovl_override_creds(dentry->d_sb);
> > -	sz = vfs_getxattr(realdentry, name, value, size);
> > -	revert_creds(old_cred);
> > -	return size;
> > +	return vfs_getxattr_noperm(realdentry, name, value, size);
> >  }
> >  
> >  ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
> > diff --git a/fs/xattr.c b/fs/xattr.c
> > index 4beafc4..973e18c 100644
> > --- a/fs/xattr.c
> > +++ b/fs/xattr.c
> > @@ -209,19 +209,11 @@ vfs_getxattr_alloc(struct dentry *dentry, const char *name, char **xattr_value,
> >  }
> >  
> >  ssize_t
> > -vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
> > +vfs_getxattr_noperm(struct dentry *dentry, const char *name, void *value, size_t size)
> >  {
> >  	struct inode *inode = dentry->d_inode;
> >  	int error;
> >  
> > -	error = xattr_permission(inode, name, MAY_READ);
> > -	if (error)
> > -		return error;
> > -
> > -	error = security_inode_getxattr(dentry, name);
> > -	if (error)
> > -		return error;
> > -
> >  	if (!strncmp(name, XATTR_SECURITY_PREFIX,
> >  				XATTR_SECURITY_PREFIX_LEN)) {
> >  		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
> > @@ -242,6 +234,24 @@ nolsm:
> >  
> >  	return error;
> >  }
> > +EXPORT_SYMBOL_GPL(vfs_getxattr_noperm);
> > +
> > +ssize_t
> > +vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
> > +{
> > +	struct inode *inode = dentry->d_inode;
> > +	int error;
> > +
> > +	error = xattr_permission(inode, name, MAY_READ);
> > +	if (error)
> > +		return error;
> > +
> > +	error = security_inode_getxattr(dentry, name);
> > +	if (error)
> > +		return error;
> > +
> > +	return vfs_getxattr_noperm(dentry, name, value, size);
> > +}
> >  EXPORT_SYMBOL_GPL(vfs_getxattr);
> >  
> >  ssize_t
> > diff --git a/include/linux/xattr.h b/include/linux/xattr.h
> > index 94079ba..832a6b6 100644
> > --- a/include/linux/xattr.h
> > +++ b/include/linux/xattr.h
> > @@ -47,6 +47,7 @@ struct xattr {
> >  
> >  ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
> >  ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
> > +ssize_t vfs_getxattr_noperm(struct dentry *, const char *, void *, size_t);
> >  ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
> >  int __vfs_setxattr_noperm(struct dentry *, const char *, const void *, size_t, int);
> >  int vfs_setxattr(struct dentry *, const char *, const void *, size_t, int);

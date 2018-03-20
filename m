Return-Path: <vgoyal@redhat.com>
Date: Tue, 20 Mar 2018 16:35:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v12 15/17] ovl: Remove redirect when data of a metacopy
 file is copied up
Message-ID: <20180320203540.GA4066@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
 <20180306205408.23383-16-vgoyal@redhat.com>
 <CAOQ4uxhey5gG+oB1BUM465-S29rBgU90T8iAwE3Nb5KxWoWepA@mail.gmail.com>
 <20180320192619.GB2857@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180320192619.GB2857@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Mar 20, 2018 at 03:26:19PM -0400, Vivek Goyal wrote:
> On Wed, Mar 07, 2018 at 10:21:30AM +0200, Amir Goldstein wrote:
> > On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > When a metacopy file is no longer a metacopy and data has been copied up,
> > > remove REDIRECT xattr. Its not needed anymore.
> > >
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  fs/overlayfs/copy_up.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > >
> > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > > index 0c8d2755bd25..704febd2e2fa 100644
> > > --- a/fs/overlayfs/copy_up.c
> > > +++ b/fs/overlayfs/copy_up.c
> > > @@ -775,6 +775,15 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
> > >         if (err)
> > >                 return err;
> > >
> > > +       /*
> > > +        * A metacopy files does not need redirect xattr once data has
> > > +        * been copied up.
> > > +        */
> > > +       err = vfs_removexattr(upperpath.dentry, OVL_XATTR_REDIRECT);
> > > +       if (err && err != -ENODATA && err != -EOPNOTSUPP)
> > > +               return err;
> > > +
> > > +       err = 0;
> > >         ovl_set_upperdata(d_inode(c->dentry));
> > >         return err;
> > 
> > By intuition, I would say that removing redirect should be done after setting
> > upperdata flag. Not sure if it really matters in real life.
> > Maybe when racing a lookup of a metacopy hardlink and copy up data of
> > an upper alias?
> > 
> > Also, it would make sense to also ovl_dentry_set_redirect(c->dentry, NULL)
> > probably use a helper ovl_clear_redirect() for the locking.
> > 
> > But that highlights a serious problem with current patches -
> > Access to OVL_I(inode)->redirect is protected with parent mutex in ovl_lookup()
> > and additionally with dentry->d_lock in ovl_rename()
> > That is sufficient for directories which can only have a single dentry
> > alias to an
> > inode but not at all sufficient for non-directories.
> 
> Hi Amir, 
> 
> I think I have got the locking of ovl_inode right now. Given this
> situation, I am looking at ovl_lookup() and wondering, why certain
> properties which belong to inode are still being initialized during
> dentry initialization (That too without any lock). That sounds wrong.
> 
> For example.
> 
> ovl_lookup() {
> 	if (index)
> 		ovl_set_flag(OVL_INDEX, inode);
> }
> 
> This is ovl_inode() property and should be initialized when inode is
> created first time in cache? And updated later in copy up path as index
> is created later. What's the reason to update inode property in
> ovl_lookup() if inode is alreday in cache.

IOW, will a patch as below fly?

---
 fs/overlayfs/export.c |    3 ---
 fs/overlayfs/inode.c  |    3 +++
 fs/overlayfs/namei.c  |    2 --
 3 files changed, 3 insertions(+), 5 deletions(-)

Index: rhvgoyal-linux/fs/overlayfs/inode.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/inode.c	2018-03-20 16:32:30.137452244 -0400
+++ rhvgoyal-linux/fs/overlayfs/inode.c	2018-03-20 16:32:56.000452244 -0400
@@ -760,6 +760,9 @@ struct inode *ovl_get_inode(struct super
 	if (upperdentry && ovl_is_impuredir(upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
 
+	if (index)
+		ovl_set_flag(OVL_INDEX, inode);
+
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
 		if (((upperdentry && lowerdentry) || numlower > 1) ||
Index: rhvgoyal-linux/fs/overlayfs/namei.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/namei.c	2018-03-20 16:32:30.137452244 -0400
+++ rhvgoyal-linux/fs/overlayfs/namei.c	2018-03-20 16:32:56.005452244 -0400
@@ -985,8 +985,6 @@ struct dentry *ovl_lookup(struct inode *
 			goto out_free_oe;
 
 		OVL_I(inode)->redirect = upperredirect;
-		if (index)
-			ovl_set_flag(OVL_INDEX, inode);
 	}
 
 	revert_creds(old_cred);
Index: rhvgoyal-linux/fs/overlayfs/export.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/export.c	2018-03-20 16:32:54.067452244 -0400
+++ rhvgoyal-linux/fs/overlayfs/export.c	2018-03-20 16:33:37.893452244 -0400
@@ -311,9 +311,6 @@ static struct dentry *ovl_obtain_alias(s
 		return ERR_CAST(inode);
 	}
 
-	if (index)
-		ovl_set_flag(OVL_INDEX, inode);
-
 	dentry = d_find_any_alias(inode);
 	if (!dentry) {
 		dentry = d_alloc_anon(inode->i_sb);

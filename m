Return-Path: <vgoyal@redhat.com>
Date: Wed, 11 Apr 2018 11:59:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v13 22/28] ovl: Set redirect on upper inode when it is
 linked
Message-ID: <20180411155948.GD4568@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
 <20180329193854.13814-23-vgoyal@redhat.com>
 <CAOQ4uxh3yfxb6vnDHa8dheSuMcY48momQZE7kqOBi6_477B+3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh3yfxb6vnDHa8dheSuMcY48momQZE7kqOBi6_477B+3A@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 30, 2018 at 10:04:40AM +0300, Amir Goldstein wrote:
> On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > When we create a hardlink to a metacopy upper file, first the redirect
> > on that inode. Path based lookup will not work with newly created link
> > and redirect will solve that issue.
> >
> > Also use absolute redirect as two hardlinks could be in different directores
> > and relative redirect will not work.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/dir.c | 18 ++++++++++++++----
> >  1 file changed, 14 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index 7c0a02d9f6bd..ccbe061fc4ba 100644
> > --- a/fs/overlayfs/dir.c
> > +++ b/fs/overlayfs/dir.c
> > @@ -24,6 +24,8 @@ module_param_named(redirect_max, ovl_redirect_max, ushort, 0644);
> >  MODULE_PARM_DESC(ovl_redirect_max,
> >                  "Maximum length of absolute redirect xattr value");
> >
> > +static int ovl_set_redirect(struct dentry *dentry, bool samedir);
> > +
> >  int ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
> >  {
> >         int err;
> > @@ -468,6 +470,9 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
> >         const struct cred *old_cred;
> >         struct cred *override_cred;
> >         struct dentry *parent = dentry->d_parent;
> > +       struct dentry *hardlink_upper;
> > +
> > +       hardlink_upper = hardlink ? ovl_dentry_upper(hardlink) : NULL;
> >
> >         err = ovl_copy_up(parent);
> >         if (err)
> > @@ -502,12 +507,18 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
> >                 put_cred(override_creds(override_cred));
> >                 put_cred(override_cred);
> >
> > +               if (hardlink && ovl_is_metacopy_dentry(hardlink)) {
> > +                       err = ovl_set_redirect(hardlink, false);
> 
> Like with rename, redirect could be set much sooner in ovl_link()
> if all the locks were contained within ovl_set_redirect().
> I think code will be simpler overall, but can't say for sure...

For now, I am not taking any locks in ovl_set_redirect(). I think VFS
locking along with d_lock seems sufficient for the current use case.

So leaving it untouched for now.

Vivek
> 
> 
> > +                       if (err)
> > +                               goto out_revert_creds;
> > +               }
> > +
> >                 if (!ovl_dentry_is_whiteout(dentry))
> >                         err = ovl_create_upper(dentry, inode, attr,
> > -                                               hardlink);
> > +                                              hardlink_upper);
> >                 else
> >                         err = ovl_create_over_whiteout(dentry, inode, attr,
> > -                                                       hardlink);
> > +                                                      hardlink_upper);
> >         }
> >  out_revert_creds:
> >         revert_creds(old_cred);
> > @@ -606,8 +617,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
> >         inode = d_inode(old);
> >         ihold(inode);
> >
> > -       err = ovl_create_or_link(new, inode, NULL, ovl_dentry_upper(old),
> > -                                ovl_type_origin(old));
> > +       err = ovl_create_or_link(new, inode, NULL, old, ovl_type_origin(old));
> >         if (err)
> >                 iput(inode);
> >
> > --
> > 2.13.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

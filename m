Return-Path: <vgoyal@redhat.com>
Date: Wed, 7 Mar 2018 10:19:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v12 16/17] ovl: Set redirect on upper inode when it is
 linked
Message-ID: <20180307151957.GF5350@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
 <20180306205408.23383-17-vgoyal@redhat.com>
 <CAOQ4uxjAwUk7n_kBZKic9snMw4Sz_ad-a4AJ4h4hNzniQv9+9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjAwUk7n_kBZKic9snMw4Sz_ad-a4AJ4h4hNzniQv9+9Q@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 07, 2018 at 10:02:20AM +0200, Amir Goldstein wrote:
> On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > When we create a hardlink to a metacopy upper file, first the redirect
> > on that inode. Path based lookup will not work with newly created link
> > and redirect will solve that issue.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/dir.c | 18 ++++++++++++++----
> >  1 file changed, 14 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> > index b955f6fede06..da5c4b8ee919 100644
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
> 
> IMO it would be nicer to pass overlay hardlink dentry all the way to
> ovl_create_real() and then just:
> 
>         if (hardlink) {
>                 err = ovl_do_link(ovl_dentry_upper(hardlink), dir,
> newdentry, debug);

Ok, I will look into it and modify if it does not turn out to be
significant change.

Vivek
> 
> Thanks,
> Amir.

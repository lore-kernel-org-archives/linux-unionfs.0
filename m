Return-Path: <vgoyal@redhat.com>
Date: Thu, 10 May 2018 09:14:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Message-ID: <20180510131428.GA2728@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
 <20180507174102.24086-11-vgoyal@redhat.com>
 <CAJfpegvzDAMx66TMhHTacYEUpowRcEYKkFuhD+TQoV83MfXPmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvzDAMx66TMhHTacYEUpowRcEYKkFuhD+TQoV83MfXPmQ@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 10, 2018 at 11:19:23AM +0200, Miklos Szeredi wrote:
> On Mon, May 7, 2018 at 7:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > This patch modifies ovl_lookup() and friends to lookup metacopy dentries.
> > It also allows for presence of metacopy dentries in lower layer.
> >
> > During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
> > set OVL_UPPERDATA bit in flags.
> >
> > We don't support metacopy feature with nfs_export. So in nfs_export code,
> > we set OVL_UPPERDATA flag set unconditionally if upper inode exists.
> >
> > Do not follow metacopy origin if we find a metacopy only inode and metacopy
> > feature is not enabled for that mount. Like redirect, this can have security
> > implications where an attacker could hand craft upper and try to gain
> > access to file on lower which it should not have to begin with.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/export.c    |   3 ++
> >  fs/overlayfs/inode.c     |  11 ++++-
> >  fs/overlayfs/namei.c     | 108 +++++++++++++++++++++++++++++++++++++++++------
> >  fs/overlayfs/overlayfs.h |   1 +
> >  fs/overlayfs/util.c      |  22 ++++++++++
> >  5 files changed, 130 insertions(+), 15 deletions(-)
> >
> > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > index 0549286cc55e..52a09a9f74b7 100644
> > --- a/fs/overlayfs/export.c
> > +++ b/fs/overlayfs/export.c
> > @@ -314,6 +314,9 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
> >                 return ERR_CAST(inode);
> >         }
> >
> > +       if (upper)
> > +               ovl_set_flag(OVL_UPPERDATA, inode);
> > +
> >         dentry = d_find_any_alias(inode);
> >         if (!dentry) {
> >                 dentry = d_alloc_anon(inode->i_sb);
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index c128d5d54d0f..83b276ce0240 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -770,7 +770,7 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
> >         bool bylower = ovl_hash_bylower(oip->sb, upperdentry, lowerdentry,
> >                                         oip->index);
> >         int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
> > -       bool is_dir;
> > +       bool is_dir, metacopy = false;
> >         unsigned long ino = 0;
> >         int err = -ENOMEM;
> >
> > @@ -830,6 +830,15 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
> >         if (oip->index)
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
> >         OVL_I(inode)->redirect = oip->redirect;
> >
> >         /* Check for non-merge dir that may have whiteouts */
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index 8fd817bf5529..b2ff08985e29 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -24,6 +24,7 @@ struct ovl_lookup_data {
> >         bool stop;
> >         bool last;
> >         char *redirect;
> > +       bool metacopy;
> >  };
> >
> >  static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
> > @@ -253,19 +254,29 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
> >                 goto put_and_out;
> >         }
> >         if (!d_can_lookup(this)) {
> > -               d->stop = true;
> > -               if (d->is_dir)
> > +               if (d->is_dir) {
> > +                       d->stop = true;
> >                         goto put_and_out;
> > -
> > +               }
> >                 /*
> >                  * NB: handle failure to lookup non-last element when non-dir
> >                  * redirects become possible
> >                  */
> >                 WARN_ON(!last_element);
> 
> This warning now triggers if we have a metacopy inode on upper
> (d->is_dir == false) but lookup on lower layer fails in the middle
> because a path element is not a directory (contrary to the comment,
> this is not related to redirects, but to non-dir "merge" objects,
> which we call metacopy).

Hi Miklos,

Ok, got it. I hand crafted a redirect xattr on upper and could trigger
this warning.

> 
> I think we should handle this case together with the d->is_dir case
> above: stop and get out.   Lookup should handle the case where we
> failed to find the data dentry.  

Agreed. Will change it.

if (d->is_dir || !last_element) {
	d->stop  = true;
	goto put_and_out;	
}

> BTW, I think EIO is more appropriate
> for this than ESTALE.  The former means (among other things)
> filesystem image is corrupted.  The latter means some inconsistencies
> were found when performing an operation.   They are similar, but while
> EIO is permanent (until the source of the error is corrected) ESTALE
> can go away (e.g. if redoing the lookup or mounting the filesystem
> fresh).

Ok. Thanks for explaining this subtle difference between -EIO and -ESTALE.
I was wondering what to return in what situation.

> 
> > +               err = ovl_check_metacopy_xattr(this);
> > +               if (err < 0)
> > +                       goto out_err;
> > +               d->stop = !err;
> > +               d->metacopy = !!err;
> >                 goto out;
> >         }
> > -       if (last_element)
> > +       if (last_element) {
> > +               if (d->metacopy) {
> > +                       err = -ESTALE;
> 
> Again, just stop and get out and caller will detect the error.

Will do.

> 
> > +                       goto out_err;
> > +               }
> >                 d->is_dir = true;
> > +       }
> >         if (d->last)
> >                 goto out;
> >
> > @@ -823,7 +834,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >         struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> >         struct ovl_entry *poe = dentry->d_parent->d_fsdata;
> >         struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
> > -       struct ovl_path *stack = NULL;
> > +       struct ovl_path *stack = NULL, *origin_path = NULL;
> >         struct dentry *upperdir, *upperdentry = NULL;
> >         struct dentry *origin = NULL;
> >         struct dentry *index = NULL;
> > @@ -834,6 +845,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >         struct dentry *this;
> >         unsigned int i;
> >         int err;
> > +       bool metacopy = false;
> >         struct ovl_lookup_data d = {
> >                 .name = dentry->d_name,
> >                 .is_dir = false,
> > @@ -841,6 +853,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >                 .stop = false,
> >                 .last = ofs->config.redirect_follow ? false : !poe->numlower,
> >                 .redirect = NULL,
> > +               .metacopy = false,
> >         };
> >
> >         if (dentry->d_name.len > ofs->namelen)
> > @@ -859,7 +872,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >                         goto out;
> >                 }
> >                 if (upperdentry && !d.is_dir) {
> > -                       BUG_ON(!d.stop || d.redirect);
> > +                       unsigned int origin_ctr = 0;
> > +                       BUG_ON(d.redirect);
> >                         /*
> >                          * Lookup copy up origin by decoding origin file handle.
> >                          * We may get a disconnected dentry, which is fine,
> > @@ -870,9 +884,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >                          * number - it's the same as if we held a reference
> >                          * to a dentry in lower layer that was moved under us.
> >                          */
> > -                       err = ovl_check_origin(ofs, upperdentry, &stack, &ctr);
> > +                       err = ovl_check_origin(ofs, upperdentry, &origin_path,
> > +                                              &origin_ctr);
> >                         if (err)
> >                                 goto out_put_upper;
> > +
> > +                       if (d.metacopy)
> > +                               metacopy = true;
> >                 }
> >
> >                 if (d.redirect) {
> > @@ -913,7 +931,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >                  * If no origin fh is stored in upper of a merge dir, store fh
> >                  * of lower dir and set upper parent "impure".
> >                  */
> > -               if (upperdentry && !ctr && !ofs->noxattr) {
> > +               if (upperdentry && !ctr && !ofs->noxattr && d.is_dir) {
> >                         err = ovl_fix_origin(dentry, this, upperdentry);
> >                         if (err) {
> >                                 dput(this);
> > @@ -925,18 +943,36 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >                  * When "verify_lower" feature is enabled, do not merge with a
> >                  * lower dir that does not match a stored origin xattr. In any
> >                  * case, only verified origin is used for index lookup.
> > +                *
> > +                * For non-dir dentry, make sure dentry found by lookup
> > +                * matches the origin stored in upper. Otherwise its an
> > +                * error.
> 
> Umm, why we need to be so strict?  This would  break the case where
> the layers are copied with xattr intact, but the origin pointer will
> obviously be "wrong", which shouldn't be a problem, since that's only
> needed to get a unique st_ino, nothing else.

Hmm...., right this breaks the case of copied up layer. The very reason
we moved to using path based lookup for metacopy data dentry.

So if we have a origin on upper for metacopy file which does not match
lower dentry found using path based lookup, we can ignore the origin
information and don't lookup for index either. That also means that
inode will be reported of upper. Given we will not use index, that
probably will mean broken hardlinks and some strange corner cases. I will
make this change and run the tests on copied layers and see what breaks.


> 
> >                  */
> > -               if (upperdentry && !ctr && ovl_verify_lower(dentry->d_sb)) {
> > +               if (upperdentry && !ctr &&
> > +                   ((d.is_dir && ovl_verify_lower(dentry->d_sb)) ||
> > +                    (!d.is_dir && origin_path))) {
> >                         err = ovl_verify_origin(upperdentry, this, false);
> >                         if (err) {
> >                                 dput(this);
> > -                               break;
> > +                               if (d.is_dir)
> > +                                       break;
> > +                               goto out_put;
> >                         }
> > -
> > -                       /* Bless lower dir as verified origin */
> > +                       /* Bless lower as verified origin */
> >                         origin = this;
> >                 }
> >
> > +               if (d.metacopy)
> > +                       metacopy = true;
> > +               /*
> > +                * Do not store intermediate metacopy dentries in chain,
> > +                * except top most lower metacopy dentry
> 
> I don't get it.  We need the bottom most metacopy dentry, not the
> topmost.  Am I missing something?

We are supporting mid layer metacopy dentries. That means there can be
a chain of metacopy dentries in lower layers and then data dentry at the
end (non-metacopy). We store both the ends of chain in lowerstack.

So if upper is metacopy but lower is not, then lowerstack[0] is data
dentry.

But if upper is metacoy and lower is metacopy as well, then
lowerstack[0] is topmost metacopy dentry in chain and lowerstack[1] is bottom
most data dentry (non-metacopy).

Storing topmost metacopy dentry in lower layers helps with verifying
origin logic and looking up index and gels with rest of the logic.

> 
> We also need to check file type here, only regular file makes sense as
> metacopy, so if it's something else, then get out with EIO.

Ok, will do.

> 
> > +                */
> > +               if (d.metacopy && ctr) {
> > +                       dput(this);
> > +                       continue;
> > +               }
> > +
> >                 stack[ctr].dentry = this;
> >                 stack[ctr].layer = lower.layer;
> >                 ctr++;
> > @@ -968,13 +1004,49 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >                 }
> >         }
> >
> > +       if (metacopy) {
> > +               /*
> > +                * Found a metacopy dentry but did not find corresponding
> > +                * data dentry
> > +                */
> > +               if (d.metacopy) {
> > +                       err = -ESTALE;
> 
> -EIO.

Will do.

Thanks
Vivek

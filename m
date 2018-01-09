From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v9 08/15] ovl: Copy up only metadata during copy up where
 it makes sense
Date: Tue, 9 Jan 2018 15:34:47 -0500
Message-ID: <20180109203447.GB11430@redhat.com>
References: <20171129155448.32721-1-vgoyal@redhat.com>
 <20171129155448.32721-9-vgoyal@redhat.com>
 <CAJfpegsXEgz6=y7eLe5kJLKHtCyEP5LxzXkg2zB5JjgNJ3=bfg@mail.gmail.com>
 <20180108170313.GD9910@redhat.com>
 <CAJfpegt3iQmcC-BQfrcELD9s+JEWahfFPpEDVung+KPqZEtYDw@mail.gmail.com>
 <20180109132637.GA11430@redhat.com>
 <CAOQ4uxg5jRPdhpGFHoYyQLiGXy_V8aUZCHPET=vzAgfy5URhzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751513AbeAIUes (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 15:34:48 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg5jRPdhpGFHoYyQLiGXy_V8aUZCHPET=vzAgfy5URhzg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 09, 2018 at 03:33:48PM +0200, Amir Goldstein wrote:
> On Tue, Jan 9, 2018 at 3:26 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Jan 09, 2018 at 11:49:11AM +0100, Miklos Szeredi wrote:
> >> On Mon, Jan 8, 2018 at 6:03 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Mon, Jan 08, 2018 at 11:35:09AM +0100, Miklos Szeredi wrote:
> >> >> On Wed, Nov 29, 2017 at 4:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> >> > If it makes sense to copy up only metadata during copy up, do it. This
> >> >> > is done for regular files which are not opened for WRITE and have origin
> >> >> > being saved.
> >> >> >
> >> >> > Right now ->metacopy is set to 0 always. Last patch in the series will
> >> >> > remove the hard coded statement and enable metacopy feature.
> >> >> >
> >> >> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> >> >> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> >> >> > ---
> >> >> >  fs/overlayfs/copy_up.c | 38 +++++++++++++++++++++++++++++++-------
> >> >> >  1 file changed, 31 insertions(+), 7 deletions(-)
> >> >> >
> >> >> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> >> >> > index 31711edf5bde..c5804b87f3c7 100644
> >> >> > --- a/fs/overlayfs/copy_up.c
> >> >> > +++ b/fs/overlayfs/copy_up.c
> >> >> > @@ -232,6 +232,26 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
> >> >> >         return err;
> >> >> >  }
> >> >> >
> >> >> > +static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
> >> >> > +                                 int flags)
> >> >> > +{
> >> >> > +       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> >> >> > +
> >> >> > +       /* TODO: Will enable metacopy in last patch of series */
> >> >> > +       return false;
> >> >> > +
> >> >> > +       if (!ofs->config.metacopy)
> >> >> > +               return false;
> >> >> > +
> >> >> > +       if (!S_ISREG(mode))
> >> >> > +               return false;
> >> >> > +
> >> >> > +       if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
> >> >> > +               return false;
> >> >> > +
> >> >> > +       return true;
> >> >> > +}
> >> >> > +
> >> >> >  struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper)
> >> >> >  {
> >> >> >         struct ovl_fh *fh;
> >> >> > @@ -305,11 +325,8 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
> >> >> >                         return PTR_ERR(fh);
> >> >> >         }
> >> >> >
> >> >> > -       /*
> >> >> > -        * Do not fail when upper doesn't support xattrs.
> >> >> > -        */
> >> >> >         err = ovl_check_setxattr(dentry, upper, OVL_XATTR_ORIGIN, fh,
> >> >> > -                                fh ? fh->len : 0, 0);
> >> >> > +                                fh ? fh->len : 0, -EOPNOTSUPP);
> >> >> >         kfree(fh);
> >> >> >
> >> >> >         return err;
> >> >> > @@ -326,6 +343,7 @@ struct ovl_copy_up_ctx {
> >> >> >         struct qstr destname;
> >> >> >         struct dentry *workdir;
> >> >> >         bool tmpfile;
> >> >> > +       bool metacopy;
> >> >> >  };
> >> >> >
> >> >> >  static int ovl_link_up(struct ovl_copy_up_ctx *c)
> >> >> > @@ -453,10 +471,14 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> >> >> >          *
> >> >> >          */
> >> >> >         err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
> >> >> > -       if (err)
> >> >> > -               return err;
> >> >> > +       if (err) {
> >> >> > +               if (err != -EOPNOTSUPP)
> >> >> > +                       return err;
> >> >> > +               /* Upper does not support xattr. Copy up data as well */
> >> >> > +               c->metacopy = false;
> >> >>
> >> >> Isn't this supposed to be checked in ovl_get_super()?
> >> >
> >> > Hi Miklos,
> >> >
> >> > Right. I think I was confused by code in ovl_check_setxattr().
> >> >
> >> > int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
> >> >                        const char *name, const void *value, size_t size,
> >> >                        int xerr)
> >> > {
> >> >         int err;
> >> >         struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> >> >
> >> >         if (ofs->noxattr)
> >> >                 return xerr;
> >> >
> >> >         err = ovl_do_setxattr(upperdentry, name, value, size, 0);
> >> >
> >> >         if (err == -EOPNOTSUPP) {
> >> >                 pr_warn("overlayfs: cannot set %s xattr on upper\n", name);
> >> >                 ofs->noxattr = true;
> >> >                 return xerr;
> >> >         }
> >> >
> >> >         return err;
> >> > }
> >> >
> >> > ofs->noxattr will be set at mount time. Still we check for -EOPNOTSUPP
> >> > and set ofs->noxattr again. Is there a situation where this can happen.
> >> > Is it intentional. Can we get rid of this code.
> >> >
> >> > To take care of this situation, I put that code. That is at mount time
> >> > xattr was fine and hence ofs->noxattr=false. But later somehow we
> >> > encountered -EOPNOTSUPP while doing ovl_set_origin(). Current code
> >> > does not fail copy up operation and I tried to retain same behavior.
> >> > That is just disable metacopy in such case but continue.
> >> >
> >> > So if we don't expect all this to happen at all, then I can get rid
> >> > of this -EOPNOTSUPP check both from ovl_check_setxattr() as well
> >> > as ovl_copy_up_inode().
> >>
> >> It would be really weird to encounter this, so I think possibly a
> >> WARN_ON(err == -EOPNOTSUPP) is enough to make sure reality matches our
> >> expectations.
> >
> > Hi Miklos,
> >
> > Effectively that's what current code is doing. Only difference is that it
> > does a pr_warn() instead of WARN_ON().
> >
> > So that means I leave current code as it is. Or replace pr_warn() with
> > WARN_ON(). Something like.
> >
> > if (WARN_ON(err == -EOPNOTSUPP)) {
> >         ofs->noxattr = true;
> >         return xerr;
> > }
> >
> 
> That gives less informative IMO than the pr_warn, because maybe
> EOPNOTSUPP can be returned for a specific xattr name by some fs
> and as far as the stack trace of WARN_ON, I think if we know the name
> of the xattr, we probably already know the overlay code path anyway...

I just realized that in this patch series I already removed this special
handling of -EOPNOTSUPP in patch3.

"[PATCH v9 03/15] ovl: ovl_check_setxattr() get rid of redundant -EOPNOTSUPP check"

Vivek
> 
> Amir.

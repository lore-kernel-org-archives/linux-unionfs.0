From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/7] ovl: Copy up only metadata during copy up where it
 makes sense
Date: Tue, 3 Oct 2017 10:39:49 -0400
Message-ID: <20171003143949.GC14308@redhat.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
 <1506951605-31440-4-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxhSHBxBDPwEhxE4a6LUDvSeQBt1k-6S-aDTu9n=fEoPcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751460AbdJCOju (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Oct 2017 10:39:50 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhSHBxBDPwEhxE4a6LUDvSeQBt1k-6S-aDTu9n=fEoPcg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Oct 02, 2017 at 10:21:05PM +0300, Amir Goldstein wrote:
> On Mon, Oct 2, 2017 at 4:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > If it makes sense to copy up only metadata during copy up, do it. This
> > is done for regular files which are not opened for WRITE and have origin
> > being saved.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c | 27 +++++++++++++++++++--------
> >  1 file changed, 19 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index cdc4d79a1249..b2d9ed81e9ff 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -306,11 +306,8 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
> >                         return PTR_ERR(fh);
> >         }
> >
> > -       /*
> > -        * Do not fail when upper doesn't support xattrs.
> > -        */
> >         err = ovl_check_setxattr(dentry, upper, OVL_XATTR_ORIGIN, fh,
> > -                                fh ? fh->len : 0, 0);
> > +                                fh ? fh->len : 0, -EOPNOTSUPP);
> >         kfree(fh);
> >
> >         return err;
> > @@ -328,6 +325,7 @@ struct ovl_copy_up_ctx {
> >         struct dentry *workdir;
> >         bool tmpfile;
> >         bool origin;
> > +       bool metadata_only;
> >  };
> >
> >  static int ovl_link_up(struct ovl_copy_up_ctx *c)
> > @@ -464,11 +462,15 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> >          */
> >         if (c->origin) {
> >                 err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
> > -               if (err)
> > -                       return err;
> > +               if (err) {
> > +                       if (err != -EOPNOTSUPP)
> > +                               return err;
> > +                       /* Upper does not support xattr. Copy up data as well */
> > +                       c->metadata_only = false;
> > +               }
> >         }
> >
> > -       if (S_ISREG(c->stat.mode)) {
> > +       if (S_ISREG(c->stat.mode) && !c->metadata_only) {
> >                 struct path upperpath;
> >
> 
> I would set the meta inode size here. see:
> https://github.com/amir73il/linux/commits/ovl-rocopyup
> 

Hi Amir,

Ok. So instead of having a zero size file in upper, set the size to same
as lower file. Just that there will not be any data blocks in upper file
yet? Will do.

Vivek

> >                 ovl_path_upper(c->dentry, &upperpath);
> > @@ -596,6 +598,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
> >                 .dentry = dentry,
> >                 .workdir = ovl_workdir(dentry),
> >                 .origin = true,
> > +               .metadata_only = true,
> >         };
> >
> >         if (WARN_ON(!ctx.workdir))
> > @@ -616,9 +619,17 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
> >         if (err)
> >                 return err;
> >
> > +       if (!S_ISREG(ctx.stat.mode))
> > +               ctx.metadata_only = false;
> > +
> >         /* maybe truncate regular file. this has no effect on dirs */
> > -       if (flags & O_TRUNC)
> > +       if (flags & O_TRUNC) {
> >                 ctx.stat.size = 0;
> > +               ctx.metadata_only = false;
> > +       }
> > +
> > +       if (flags & (OPEN_FMODE(flags) & FMODE_WRITE))
> > +               ctx.metadata_only = false;
> >
> >         if (S_ISLNK(ctx.stat.mode)) {
> >                 ctx.link = vfs_get_link(ctx.lowerpath.dentry, &done);
> > --
> > 2.13.5
> >

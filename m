From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 4/7] ovl: Set xattr OVL_XATTR_METACOPY on upper file
Date: Tue, 3 Oct 2017 11:10:20 -0400
Message-ID: <20171003151020.GD14308@redhat.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
 <1506951605-31440-5-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxj43mpk4nH-ont+pB7wdBTUEki=x_b5p1xY4P9NgOSgjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751832AbdJCPKV (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Oct 2017 11:10:21 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj43mpk4nH-ont+pB7wdBTUEki=x_b5p1xY4P9NgOSgjQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Oct 02, 2017 at 10:28:30PM +0300, Amir Goldstein wrote:
> On Mon, Oct 2, 2017 at 4:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Presence of OVL_XATTR_METACOPY reflects that file has been copied up
> > with metadata only and data needs to be copied up later from lower.
> > So this xattr is set when a metadata copy takes place and cleared when
> > data copy takes place.
> >
> > We also use a bit in ovl_inode->flags to cache OVL_METACOPY which reflects
> > whether ovl inode has only metadata copied up.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c   | 42 ++++++++++++++++++++++++++++++++++++++++--
> >  fs/overlayfs/inode.c     |  3 ++-
> >  fs/overlayfs/overlayfs.h |  5 ++++-
> >  fs/overlayfs/util.c      | 21 +++++++++++++++++++--
> >  4 files changed, 65 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index b2d9ed81e9ff..d76a4272b43e 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -439,6 +439,26 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
> >         goto out;
> >  }
> >
> > +static int ovl_copy_up_data_inode(struct ovl_copy_up_ctx *c)
> > +{
> > +       struct path upperpath;
> > +       int err;
> > +
> > +       ovl_path_upper(c->dentry, &upperpath);
> > +       BUG_ON(upperpath.dentry == NULL);
> > +
> > +       err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
> > +       if (err)
> > +               return err;
> > +
> > +       err= vfs_removexattr(upperpath.dentry, OVL_XATTR_METACOPY);
> > +       if (err)
> > +               return err;
> > +
> > +        ovl_clear_flag(OVL_METACOPY, d_inode(c->dentry));
> > +       return err;
> > +}
> > +
> >  static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> >  {
> >         int err;
> > @@ -482,6 +502,13 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
> >                         return err;
> >         }
> >
> > +       if (c->metadata_only) {
> > +               err = ovl_check_setxattr(c->dentry, temp, OVL_XATTR_METACOPY,
> > +                                        NULL, 0, -EOPNOTSUPP);
> > +               if (err)
> > +                       return err;
> > +       }
> > +
> >         return 0;
> >  }
> >
> > @@ -511,6 +538,9 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
> >                 goto out_cleanup;
> >
> >         ovl_inode_update(d_inode(c->dentry), newdentry);
> > +       if (c->metadata_only) {
> > +               ovl_set_flag(OVL_METACOPY, d_inode(c->dentry));
> > +       }
> >  out:
> >         dput(temp);
> >         return err;
> > @@ -638,7 +668,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
> >         }
> >         ovl_do_check_copy_up(ctx.lowerpath.dentry);
> >
> > -       err = ovl_copy_up_start(dentry);
> > +       err = ovl_copy_up_start(dentry, flags);
> >         /* err < 0: interrupted, err > 0: raced with another copy-up */
> >         if (unlikely(err)) {
> >                 if (err > 0)
> > @@ -648,6 +678,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
> >                         err = ovl_do_copy_up(&ctx);
> >                 if (!err && !ovl_dentry_has_upper_alias(dentry))
> >                         err = ovl_link_up(&ctx);
> > +               if (!err && ovl_dentry_needs_data_copy_up(dentry, flags))
> > +                       err = ovl_copy_up_data_inode(&ctx);
> 
> I think it would simplify life cycle of copy up if ovl_copy_up_data_inode()
> is always before ovl_link_up() and that ovl_dentry_has_upper_alias()
> means "has a concrete upper alias with data".

Hmm..., I think I don't understand the suggestion.  So will upper alias will
not be created until and unless data copy up happens?

IOW, say I have file lower-file.txt in lower/ and also a hard link, say
lower-link.txt

lower-file.txt
lower-link.txt

Now if do "chown vivek lower-file.txt", then lower-file.txt will be copied
up metadata only and an alias will be created. So are you saying that we
should not create an alias till actual data copy happens?

What about regular files with no links.

Vivek

> 
> index feature already supports an upper index without any upper aliases
> (a property that I use in the ro-copyup patches).
> 
> Amir.

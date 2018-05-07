Return-Path: <vgoyal@redhat.com>
Date: Mon, 7 May 2018 16:37:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 01/30] ovl: Pass argument to ovl_get_inode() in a
 structure
Message-ID: <20180507203736.GA5634@redhat.com>
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
> 
> > ---
> >  fs/overlayfs/export.c    |  4 +++-
> >  fs/overlayfs/inode.c     | 19 ++++++++++---------
> >  fs/overlayfs/namei.c     |  6 ++++--
> >  fs/overlayfs/overlayfs.h |  4 +---
> >  fs/overlayfs/ovl_entry.h |  8 ++++++++
> >  5 files changed, 26 insertions(+), 15 deletions(-)
> >
> > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > index 425a94672300..867946adcbc5 100644
> > --- a/fs/overlayfs/export.c
> > +++ b/fs/overlayfs/export.c
> > @@ -300,12 +300,14 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
> >         struct dentry *dentry;
> >         struct inode *inode;
> >         struct ovl_entry *oe;
> > +       struct ovl_inode_params oip = {sb, NULL, lowerpath, index, !!lower};
> 
> {
>    .index = index,
> ...

Will fix this.

> 
> >
> >         /* We get overlay directory dentries with ovl_lookup_real() */
> >         if (d_is_dir(upper ?: lower))
> >                 return ERR_PTR(-EIO);
> >
> > -       inode = ovl_get_inode(sb, dget(upper), lowerpath, index, !!lower);
> > +       oip.upperdentry = dget(upper);
> > +       inode = ovl_get_inode(&oip);
> >         if (IS_ERR(inode)) {
> >                 dput(upper);
> >                 return ERR_CAST(inode);
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index 7abcf96e94fc..2fe9538fffc9 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -792,15 +792,16 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
> >         return true;
> >  }
> >
> > -struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
> > -                           struct ovl_path *lowerpath, struct dentry *index,
> > -                           unsigned int numlower)
> > +struct inode *ovl_get_inode(struct ovl_inode_params *oip)
> 
> IMO, sb should not be part of ovl_inode_params
> it should be passed as a separate arg

Will do.

> and ovl_inode_params
> should be passed to ovl_inode_init() as well.

I want to avoid making this change as part of this series. Right now it
has 3 args and my patches add one more. Four arguments are not a lot. And
even if we pass oip, only 3 will go in it. inode param remains outside
of it.

And it is being called from super.c as well as inode.c. So while fixable,
but it increases the code further. At this point of time, trying to limit
the changes to which are really needed and are easy to do.

Vivek

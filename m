Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20180903061211.20830-1-amir73il@gmail.com> <20180903061211.20830-2-amir73il@gmail.com>
 <CAJfpegs_MTifkPKX4g9Z-BOe4pGjYJFno9B3tp-96znLJ7hW1A@mail.gmail.com>
In-Reply-To: <CAJfpegs_MTifkPKX4g9Z-BOe4pGjYJFno9B3tp-96znLJ7hW1A@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 24 Oct 2018 18:29:24 +0300
Message-ID: <CAOQ4uxjgZD4SFUaMFyo8Vy-pG59yKHKe79qg_Vra3=mxRujvNg@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: relax requirement for non null uuid of lower fs
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 24, 2018 at 5:16 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Sep 3, 2018 at 8:12 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> > We use uuid to associate an overlay lower file handle with a lower layer,
> > so we can accept lower fs with null uuid as long as all lower layers with
> > null uuid are on the same fs.
> >
> > This change allows enabling index and nfs_export features for the setup of
> > single lower fs of type squashfs - squashfs supports file handles, but has
> > a null uuid. This change also allows enabling index and nfs_export
> > features for nested overlayfs, where the lower overlay has nfs_export
> > enabled.
>
> Shouldn't overlayfs generate an uuid for the nested case?  Not quite
> sure what's the best way to do that, though...
>

They way I chose to handle that is patch 3/3.
Overlay does not generate a uuid for the nested case, but it encodes file
handles with uuid of nested underlying, so for example, when verifying
lower origin on mount we don't know for sure that last mount use exact
same overlay configuration, but we do know if used the same upper root
dir (because root dir is a special case that encodes an upper file handle).

> >
> > Enabling the index feature with single lower squashfs fixes the
> > unionmount-testsuite test:
> >   ./run --ov --squashfs --verify
> >
> > As a by-product, if, like the lower squashfs, upper fs also uses the
> > generic export_encode_fh() implementation to export 32bit inode file
> > handles (e.g. ext4), then the xino_auto config/module/mount option will
> > enable unique overlay inode numbers.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/super.c | 23 +++++++++++++++++++++--
> >  fs/overlayfs/util.c  |  3 +--
> >  2 files changed, 22 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 2e0fc93c2c06..069e441e24eb 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1174,11 +1174,14 @@ static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
> >  }
> >
> >  /* Get a unique fsid for the layer */
> > -static int ovl_get_fsid(struct ovl_fs *ofs, struct super_block *sb)
> > +static int ovl_get_fsid(struct ovl_fs *ofs, struct vfsmount *mnt)
> >  {
> > +       struct super_block *sb = mnt->mnt_sb;
> >         unsigned int i;
> >         dev_t dev;
> >         int err;
> > +       bool need_uuid = ofs->config.nfs_export ||
> > +                        (ofs->config.index && ofs->upper_mnt);
> >
> >         /* fsid 0 is reserved for upper fs even with non upper overlay */
> >         if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
> > @@ -1187,6 +1190,22 @@ static int ovl_get_fsid(struct ovl_fs *ofs, struct super_block *sb)
> >         for (i = 0; i < ofs->numlowerfs; i++) {
> >                 if (ofs->lower_fs[i].sb == sb)
> >                         return i + 1;
> > +
> > +               /*
> > +                * We use uuid to associate an overlay lower file handle with a
> > +                * lower layer, so we can accept lower fs with null uuid as long
> > +                * as all lower layers with null uuid are on the same fs.
> > +                */
> > +               if (need_uuid &&
> > +                   uuid_equal(&ofs->lower_fs[i].sb->s_uuid, &sb->s_uuid)) {
> > +                       need_uuid = false;
> > +                       ofs->config.index = false;
> > +                       ofs->config.nfs_export = false;
> > +                       pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
> > +                               uuid_is_null(&sb->s_uuid) ? "null" :
> > +                                                           "conflicting",
> > +                               mnt->mnt_root);
>
> mnt->mnt_root is wrong here: this is path->mnt resolved from the
> lowerdir, not the one cloned from that path.
>
> Fixed so ovl_get_lower_layers() passes in the path, not just the mount.
>
> Also made this a separate loop from the one finding a matching fs, as
> it's logically a different step and not needed in the case when the fs
> is found.
>
> Updated but untested patch attached.
>

Tested. looks good.

Thanks,
Amir.

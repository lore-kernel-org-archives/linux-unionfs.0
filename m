Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20180903061211.20830-1-amir73il@gmail.com> <20180903061211.20830-3-amir73il@gmail.com>
 <CAJfpegsp875XA96r_u_uteiN85WMQ7G4A5ogWPTt+aJG2XgVcQ@mail.gmail.com>
 <CAOQ4uxh+iO87Urj8sUAPHXdBpLzT45gNPFKWGD6M6ALRc0ALAQ@mail.gmail.com> <CAJfpegva+XA0K6eDvPaJnqw01vc_90dZ5j0BvsUoY+5C2W91jQ@mail.gmail.com>
In-Reply-To: <CAJfpegva+XA0K6eDvPaJnqw01vc_90dZ5j0BvsUoY+5C2W91jQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 24 Oct 2018 19:11:31 +0300
Message-ID: <CAOQ4uxh-n6sDNn2qGqgJ7Tu6X8Fwpr8i_kS6vyuaKg3mgJGP6Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: disable xino for some nested overlay cases
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 24, 2018 at 6:19 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, Oct 24, 2018 at 5:03 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Wed, Oct 24, 2018 at 5:30 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >>
> >> On Mon, Sep 3, 2018 at 8:12 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> >> > There are three possible cases when overlayfs is used as lower
> >> > layer for a nested overlay mount:
> >> >
> >> > 1. lower overlay is non-samefs with xino enabled
> >> > 2. lower overlay is non-samefs with xino disabled
> >> > 3. lower overlay is samefs
> >> >
> >> > In the first case, lower layer uses high inode number bits, so they are
> >> > not available for the nested overlay and xino should be disabled.
> >> >
> >> > In the second case, inode numbers of lower layer are not in a single
> >> > address space, so there is no use enabling xino in nested overlay.
> >> >
> >> > In the last case (samefs) the lower layer inode number address space
> >> > is that of the underlying real fs, so we can assign fsid of the lower
> >> > layer according the the real underlying fs.
> >> >
> >> > In the private case of all lower overlay layers on the same fs, which is
> >> > also the upper fs of the nested overlay, the nested overlay itself is
> >> > treated as "samefs", because inode numbers in all layers are from the
> >> > same address space.
> >> >
> >> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> > ---
> >> >  fs/overlayfs/overlayfs.h |  8 ++++++++
> >> >  fs/overlayfs/super.c     | 25 +++++++++++++++++++++++--
> >> >  2 files changed, 31 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> >> > index f61839e1054c..d32fe09a222f 100644
> >> > --- a/fs/overlayfs/overlayfs.h
> >> > +++ b/fs/overlayfs/overlayfs.h
> >> > @@ -418,3 +418,11 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
> >> >
> >> >  /* export.c */
> >> >  extern const struct export_operations ovl_export_operations;
> >> > +
> >> > +/* super.c */
> >> > +extern struct file_system_type ovl_fs_type;
> >> > +
> >> > +static inline bool ovl_is_overlay_fs(struct super_block *sb)
> >> > +{
> >> > +       return sb->s_type == &ovl_fs_type;
> >> > +}
> >>
> >> Special casing like that is, well, ugly.
> >>
> >> Generic solution (which would work in the face of other stacking fs)
> >> would be to have a "ino-space-id" in the super block that would be
> >> assigned to a unique number for all distinct filesystems, but stacking
> >> fs would be able to reset it to the origin filesystem's id if
> >> appropriate.
> >>
> >> What do you think about that?
> >>
[...]
>
> I was thinking of the special case of all - real underlying layers of
> nested and outer overlay - being on the same fs.  I thought this patch
> was about using the samefs info from the nested overlay to allow using
> the samefs logics for the outer overlay as well.
>

Ah. Is it really worth the trouble?
What are the chances of use case other than nested overlayfs
will really present itself?
IMO it is not *that* ugly to "special case" your own fs type, but
it's your definition of "ugly" that counts.

Let me know if you want me to add s_ino_dev at this time.
When non-zero, it is meant to fill stat->dev instead of s_dev,
which is what we do in samefs case, so in theory we could
replace most current callers of ovl_same_sb() with:

dev_t ovl_same_dev(struct super_block *sb)
{
    return sb->s_ino_dev;
}

Thanks,
Amir.

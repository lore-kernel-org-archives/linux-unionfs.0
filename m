MIME-Version: 1.0
In-Reply-To: <20180903061211.20830-3-amir73il@gmail.com>
References: <20180903061211.20830-1-amir73il@gmail.com>
	<20180903061211.20830-3-amir73il@gmail.com>
Date: Wed, 24 Oct 2018 16:30:47 +0200
Message-ID: <CAJfpegsp875XA96r_u_uteiN85WMQ7G4A5ogWPTt+aJG2XgVcQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: disable xino for some nested overlay cases
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Sep 3, 2018 at 8:12 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> There are three possible cases when overlayfs is used as lower
> layer for a nested overlay mount:
>
> 1. lower overlay is non-samefs with xino enabled
> 2. lower overlay is non-samefs with xino disabled
> 3. lower overlay is samefs
>
> In the first case, lower layer uses high inode number bits, so they are
> not available for the nested overlay and xino should be disabled.
>
> In the second case, inode numbers of lower layer are not in a single
> address space, so there is no use enabling xino in nested overlay.
>
> In the last case (samefs) the lower layer inode number address space
> is that of the underlying real fs, so we can assign fsid of the lower
> layer according the the real underlying fs.
>
> In the private case of all lower overlay layers on the same fs, which is
> also the upper fs of the nested overlay, the nested overlay itself is
> treated as "samefs", because inode numbers in all layers are from the
> same address space.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/overlayfs.h |  8 ++++++++
>  fs/overlayfs/super.c     | 25 +++++++++++++++++++++++--
>  2 files changed, 31 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index f61839e1054c..d32fe09a222f 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -418,3 +418,11 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
>
>  /* export.c */
>  extern const struct export_operations ovl_export_operations;
> +
> +/* super.c */
> +extern struct file_system_type ovl_fs_type;
> +
> +static inline bool ovl_is_overlay_fs(struct super_block *sb)
> +{
> +       return sb->s_type == &ovl_fs_type;
> +}

Special casing like that is, well, ugly.

Generic solution (which would work in the face of other stacking fs)
would be to have a "ino-space-id" in the super block that would be
assigned to a unique number for all distinct filesystems, but stacking
fs would be able to reset it to the origin filesystem's id if
appropriate.

What do you think about that?

Thanks,
Miklos

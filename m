Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1523932965-25792-1-git-send-email-cgxu519@gmx.com>
References: <1523932965-25792-1-git-send-email-cgxu519@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 17 Apr 2018 14:04:55 +0300
Message-ID: <CAOQ4uxh-fBE0hFXu9KGOQwAad9O6OQMkt3+nMCXObxk+2JUYmA@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: refactor lowerstack related functions
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Apr 17, 2018 at 5:42 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
> Introduce __ovl_path_lower() to handle lowerstack related things
> and refactor ovl_dentry_lower()/ovl_layer_lower() based on it.
>
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
>  fs/overlayfs/overlayfs.h |  1 +
>  fs/overlayfs/util.c      | 35 +++++++++++++++++++++++++++++++----
>  2 files changed, 32 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index e0b7de7..abb5cf4 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -215,6 +215,7 @@ static inline struct dentry *ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
>  enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
>  struct dentry *ovl_dentry_upper(struct dentry *dentry);
>  struct dentry *ovl_dentry_lower(struct dentry *dentry);
> +struct vfsmount *ovl_mnt_lower(struct dentry *dentry);
>  struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
>  struct dentry *ovl_dentry_real(struct dentry *dentry);
>  struct dentry *ovl_i_dentry_upper(struct inode *inode);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 6f10780..a3459e6 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -157,8 +157,8 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
>         struct ovl_entry *oe = dentry->d_fsdata;
>
>         if (oe->numlower) {
> -               path->mnt = oe->lowerstack[0].layer->mnt;
> -               path->dentry = oe->lowerstack[0].dentry;
> +               path->mnt = ovl_mnt_lower(dentry);
> +               path->dentry = ovl_dentry_lower(dentry);
>         } else {
>                 *path = (struct path) { };
>         }
> @@ -181,18 +181,45 @@ struct dentry *ovl_dentry_upper(struct dentry *dentry)
>         return ovl_upperdentry_dereference(OVL_I(d_inode(dentry)));
>  }
>
> +struct ovl_path *__ovl_path_lower(struct ovl_entry *oe, int layer)

The name is going to be confused with ovl_path_lower, but
I don't have a better suggestion.
For the @layer arg I propose two options.
Either @idx for layer index, like other helpers
Or simply @i for lower layer index, because it doesn't make much sense
to request idx=0 (upper) from a helper called xxx_lower().
If you choose to stay with @idx convention, you should add
if (WARN_ON(idx < 1)) return NULL;

> +{
> +       if (layer > oe->numlower)
> +               return NULL;
> +
> +       return &oe->lowerstack[layer - 1];
> +}
> +
> +struct vfsmount *ovl_mnt_lower(struct dentry *dentry)
> +{
> +       struct ovl_entry *oe = dentry->d_fsdata;
> +       struct ovl_path *path = __ovl_path_lower(oe, 1);
> +
> +       if (path)
> +               return path->layer->mnt;
> +       else
> +               return NULL;
> +}
> +
>  struct dentry *ovl_dentry_lower(struct dentry *dentry)
>  {
>         struct ovl_entry *oe = dentry->d_fsdata;
> +       struct ovl_path *path = __ovl_path_lower(oe, 1);
>
> -       return oe->numlower ? oe->lowerstack[0].dentry : NULL;
> +       if (path)
> +               return path->dentry;
> +       else
> +               return NULL;
>  }
>
>  struct ovl_layer *ovl_layer_lower(struct dentry *dentry)
>  {
>         struct ovl_entry *oe = dentry->d_fsdata;
> +       struct ovl_path *path = __ovl_path_lower(oe, 1);
>
> -       return oe->numlower ? oe->lowerstack[0].layer : NULL;
> +       if (path)
> +               return path->layer;
> +       else
> +               return NULL;
>  }
>


I am not yet convinced that this re-factoring is needed,
but if you keep it, please preserve the style:

      struct ovl_path *op = __ovl_path_lower(OVL_E(dentry), 1);

      return op ? op->layer : NULL;


Thanks,
Amir.

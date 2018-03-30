Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-14-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-14-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 09:01:12 +0300
Message-ID: <CAOQ4uxhkvO2nfNOsvSKcJ6XhRn2kD3HWJHAtc_Qh38W+mqY88Q@mail.gmail.com>
Subject: Re: [PATCH v13 13/28] ovl: Add helper ovl_dentry_lowerdata() to get
 lower data dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Now we have the notion of data dentry and metacopy dentry. ovl_dentry_lower()
> will return lower dentry at idx 0, but it could be either data or metacopy

will return the upper most lower dentry. (idx 0 means upper).

> dentry. Now we support metacopy dentries in lower layers so it is possible
> that lowerstack[0] is metacopy dentry while lowerstack[1] is actual data
> dentry.
>
> So add an helper which returns lowest most dentry which is supposed to be
> data dentry.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/overlayfs.h |  1 +
>  fs/overlayfs/util.c      | 14 ++++++++++++++
>  2 files changed, 15 insertions(+)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 4eb4b765887f..214d9f08c574 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -226,6 +226,7 @@ void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
>  enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
>  struct dentry *ovl_dentry_upper(struct dentry *dentry);
>  struct dentry *ovl_dentry_lower(struct dentry *dentry);
> +struct dentry *ovl_dentry_lowerdata(struct dentry *dentry);
>  struct dentry *ovl_dentry_real(struct dentry *dentry);
>  struct dentry *ovl_i_dentry_upper(struct inode *inode);
>  struct inode *ovl_inode_upper(struct inode *inode);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index fd98329e820c..394674c4c820 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -186,6 +186,20 @@ struct dentry *ovl_dentry_lower(struct dentry *dentry)
>         return oe->numlower ? oe->lowerstack[0].dentry : NULL;
>  }
>
> +/*
> + * ovl_dentry_lower() could return either a data dentry or metacopy dentry
> + * dependig on what is stored in lowerstack[0]. At times we need to find
> + * lower dentry which has data (and not metacopy dntry). This helper
> + * returns the lower data dentry.
> + */
> +struct dentry *ovl_dentry_lowerdata(struct dentry *dentry)
> +{
> +       struct ovl_entry *oe = dentry->d_fsdata;
> +       int idx = oe->numlower - 1;

Please stick with convention of layer->idx that idx 0 is upper.

> +
> +       return idx >= 0 ? oe->lowerstack[idx].dentry : NULL;
> +}
> +
>  struct dentry *ovl_dentry_real(struct dentry *dentry)
>  {
>         return ovl_dentry_upper(dentry) ?: ovl_dentry_lower(dentry);
> --
> 2.13.6
>

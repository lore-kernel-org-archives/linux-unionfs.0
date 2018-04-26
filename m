Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180426191013.13219-16-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-16-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 26 Apr 2018 13:35:05 -0700
Message-ID: <CAOQ4uxiXd5ogotyu1B1JLN1e0WZqRk79b6FqmxQhU=6=Nti2vg@mail.gmail.com>
Subject: Re: [PATCH v14 15/31] ovl: Add helper ovl_inode_real_data()
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 12:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Add an helper to retrieve real data inode associated with overlay inode.
> This helper will ignore all metacopy inodes and will return only the
> real inode which has data.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Suggest to rename to ovl_inode_realdata

> ---
>  fs/overlayfs/overlayfs.h |  1 +
>  fs/overlayfs/util.c      | 12 ++++++++++++
>  2 files changed, 13 insertions(+)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 29c3498a7e61..e24af484967f 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -236,6 +236,7 @@ struct inode *ovl_inode_upper(struct inode *inode);
>  struct inode *ovl_inode_lower(struct inode *inode);
>  struct inode *ovl_inode_lowerdata(struct inode *inode);
>  struct inode *ovl_inode_real(struct inode *inode);
> +struct inode *ovl_inode_real_data(struct inode *inode);
>  struct ovl_dir_cache *ovl_dir_cache(struct inode *inode);
>  void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache);
>  void ovl_dentry_set_flag(unsigned long flag, struct dentry *dentry);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 58aa14a02bb0..c7a1bd40dc6a 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -268,6 +268,18 @@ struct inode *ovl_inode_lowerdata(struct inode *inode)
>         return OVL_I(inode)->lowerdata ?: ovl_inode_lower(inode);
>  }
>
> +/* Return real inode which contains data. Does not return metacopy inode */
> +struct inode *ovl_inode_real_data(struct inode *inode)
> +{
> +       struct inode *upperinode;
> +
> +       upperinode = ovl_inode_upper(inode);
> +       if (upperinode && ovl_has_upperdata(inode))
> +               return upperinode;
> +
> +       return ovl_inode_lowerdata(inode);
> +}
> +
>
>  struct ovl_dir_cache *ovl_dir_cache(struct inode *inode)
>  {
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

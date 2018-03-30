Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-2-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-2-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 07:59:25 +0300
Message-ID: <CAOQ4uxiL9F4OxiSWBT5POxy8=K=Tkwm3j4cPGRzfnC7qF7C6=Q@mail.gmail.com>
Subject: Re: [PATCH v13 01/28] ovl: Set OVL_INDEX flag in ovl_get_inode()
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> All the inode/ovl_inode initialization should happen in ovl_get_inode().
> This is especially useful when multiple dentries are pointing to same
> inode and inode is already in the cash. In that case, we don't have to

s/in the cash/in cache/

> initialize the OVL_INDEX. We don't even take ovl_inode->lock in ovl_lookup()
> and that can run into issues for the case of shared inode.
>
> So move OVL_INDEX flag setting in ovl_get_inode().
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/export.c | 3 ---
>  fs/overlayfs/inode.c  | 3 +++
>  fs/overlayfs/namei.c  | 2 --
>  3 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 87bd4148f4fb..9868c173068e 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -311,9 +311,6 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>                 return ERR_CAST(inode);
>         }
>
> -       if (index)
> -               ovl_set_flag(OVL_INDEX, inode);
> -
>         dentry = d_find_any_alias(inode);
>         if (!dentry) {
>                 dentry = d_alloc_anon(inode->i_sb);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 3b1bd469accd..06ef9a7a7d1a 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -760,6 +760,9 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>         if (upperdentry && ovl_is_impuredir(upperdentry))
>                 ovl_set_flag(OVL_IMPURE, inode);
>
> +       if (index)
> +               ovl_set_flag(OVL_INDEX, inode);
> +
>         /* Check for non-merge dir that may have whiteouts */
>         if (is_dir) {
>                 if (((upperdentry && lowerdentry) || numlower > 1) ||
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index f55c00bf9e17..ec92fa2f7d5f 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1005,8 +1005,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         goto out_free_oe;
>
>                 OVL_I(inode)->redirect = upperredirect;
> -               if (index)
> -                       ovl_set_flag(OVL_INDEX, inode);
>         }
>
>         revert_creds(old_cred);
> --
> 2.13.6
>

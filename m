Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-3-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-3-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 07:57:16 +0300
Message-ID: <CAOQ4uxhM-Fg1R0MjmTyuaVnWg5BsZHUW0H0hEY2cHqU36vLpBA@mail.gmail.com>
Subject: Re: [PATCH v13 02/28] ovl: Initialize ovl_inode->redirect in ovl_get_inode()
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> All the inode/ovl_inode properties ideally should be initialized in
> ovl_get_inode(). Otherwise this can be a problem for the cases where
> multiple dentries point to same inode (hardlinks, disconnected dentries).
>
> As of now this is not a problem as redirects are used only for directories
> which don't share inode. But soon I want to use redirects for regular files
> also and there it will become an issue.
>
> Hence, move ->redirect initialization in ovl_get_inode().
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/export.c    | 2 +-
>  fs/overlayfs/inode.c     | 5 ++++-
>  fs/overlayfs/namei.c     | 4 +---
>  fs/overlayfs/overlayfs.h | 2 +-
>  4 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 9868c173068e..e668329f7361 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -305,7 +305,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>         if (d_is_dir(upper ?: lower))
>                 return ERR_PTR(-EIO);
>
> -       inode = ovl_get_inode(sb, dget(upper), lower, index, !!lower);

I'd leave a TODO comment here for fixing metacopy+NFS export support
You may add the comment in later patch, just don't forget.

> +       inode = ovl_get_inode(sb, dget(upper), lower, index, !!lower, NULL);
>         if (IS_ERR(inode)) {
>                 dput(upper);
>                 return ERR_CAST(inode);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 06ef9a7a7d1a..2e7ee09c7831 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -704,7 +704,7 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
>
>  struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>                             struct dentry *lowerdentry, struct dentry *index,
> -                           unsigned int numlower)
> +                           unsigned int numlower, char *redirect)
>  {
>         struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
>         struct inode *inode;
> @@ -741,6 +741,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>                         }
>
>                         dput(upperdentry);
> +                       kfree(redirect);
>                         goto out;
>                 }
>
> @@ -763,6 +764,8 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>         if (index)
>                 ovl_set_flag(OVL_INDEX, inode);
>
> +       OVL_I(inode)->redirect = redirect;
> +
>         /* Check for non-merge dir that may have whiteouts */
>         if (is_dir) {
>                 if (((upperdentry && lowerdentry) || numlower > 1) ||
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ec92fa2f7d5f..0b325e65864c 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -999,12 +999,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 if (ctr)
>                         origin = stack[0].dentry;
>                 inode = ovl_get_inode(dentry->d_sb, upperdentry, origin, index,
> -                                     ctr);
> +                                     ctr, upperredirect);
>                 err = PTR_ERR(inode);
>                 if (IS_ERR(inode))
>                         goto out_free_oe;
> -
> -               OVL_I(inode)->redirect = upperredirect;
>         }
>
>         revert_creds(old_cred);
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 225ff1171147..a65ce7fd1b6e 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -330,7 +330,7 @@ struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
>                                bool is_upper);
>  struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>                             struct dentry *lowerdentry, struct dentry *index,
> -                           unsigned int numlower);
> +                           unsigned int numlower, char *redirect);
>  static inline void ovl_copyattr(struct inode *from, struct inode *to)
>  {
>         to->i_uid = from->i_uid;
> --
> 2.13.6
>

Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180507174102.24086-16-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com> <20180507174102.24086-16-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 7 May 2018 21:59:00 +0300
Message-ID: <CAOQ4uxheo=KOskjqUOkQ8KHR-F+j+wROW9hRfq=MgPe6q7D2nA@mail.gmail.com>
Subject: Re: [PATCH v15 15/30] ovl: Store lower data inode in ovl_inode
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 7, 2018 at 8:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now ovl_inode stores inode pointer for lower inode. This helps
> with quickly getting lower inode given overlay inode (ovl_inode_lower()).
>
> Now with metadata only copy-up, we can have metacopy inode in middle
> layer as well and inode containing data can be different from ->lower.
> I need to be able to open the real file in ovl_open_realfile() and
> for that I need to quickly find the lower data inode.
>
> Hence store lower data inode also in ovl_inode. Also provide an
> helper ovl_inode_lowerdata() to access this field.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

After fixing some nits below

> ---
>  fs/overlayfs/export.c    |  2 +-
>  fs/overlayfs/inode.c     |  2 +-
>  fs/overlayfs/namei.c     |  7 +++++--
>  fs/overlayfs/overlayfs.h |  3 ++-
>  fs/overlayfs/ovl_entry.h |  6 +++++-
>  fs/overlayfs/super.c     |  8 ++++++--
>  fs/overlayfs/util.c      | 10 +++++++++-
>  7 files changed, 29 insertions(+), 9 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 52a09a9f74b7..77d98aa7f118 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -301,7 +301,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>         struct inode *inode;
>         struct ovl_entry *oe;
>         struct ovl_inode_params oip = {sb, NULL, lowerpath, index, !!lower,
> -                                      NULL};
> +                                      NULL, NULL};

You should convert to new initialization standard for structs, i.e.:
{
    .index = index,
    ...

and no need to initialize NULL members.


>
>         /* We get overlay directory dentries with ovl_lookup_real() */
>         if (d_is_dir(upper ?: lower))
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 5d461cd57b48..949ddc7c6f59 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -855,7 +855,7 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
>                 }
>         }
>         ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
> -       ovl_inode_init(inode, upperdentry, lowerdentry);
> +       ovl_inode_init(inode, upperdentry, lowerdentry, oip->lowerdata);

Would make senses to pass oip to ovl_inode_init() as well.

>
>         if (upperdentry && ovl_is_impuredir(upperdentry))
>                 ovl_set_flag(OVL_IMPURE, inode);
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index b2ff08985e29..a2556f981d3e 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1076,10 +1076,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 upperdentry = dget(index);
>
>         if (upperdentry || ctr) {
> +               struct dentry *lowerdata = NULL;

You don't seem to need this helper var.

>                 struct ovl_inode_params oip = {dentry->d_sb, upperdentry,
>                                                stack, index, ctr,
> -                                              upperredirect};
> -
> +                                              upperredirect, NULL};
> +               if (ctr > 1 && !d.is_dir)
> +                       lowerdata = stack[ctr - 1].dentry;
> +               oip.lowerdata = lowerdata;
>                 inode = ovl_get_inode(&oip);
>                 err = PTR_ERR(inode);
>                 if (IS_ERR(inode))
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 6d64796e0060..8c68387efe87 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -234,6 +234,7 @@ struct dentry *ovl_dentry_realdata(struct dentry *dentry);
>  struct dentry *ovl_i_dentry_upper(struct inode *inode);
>  struct inode *ovl_inode_upper(struct inode *inode);
>  struct inode *ovl_inode_lower(struct inode *inode);
> +struct inode *ovl_inode_lowerdata(struct inode *inode);
>  struct inode *ovl_inode_real(struct inode *inode);
>  struct ovl_dir_cache *ovl_dir_cache(struct inode *inode);
>  void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache);
> @@ -253,7 +254,7 @@ bool ovl_redirect_dir(struct super_block *sb);
>  const char *ovl_dentry_get_redirect(struct dentry *dentry);
>  void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
>  void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
> -                   struct dentry *lowerdentry);
> +                   struct dentry *lowerdentry, struct dentry *lowerdata);
>  void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
>  void ovl_dir_modified(struct dentry *dentry, bool impurity);
>  u64 ovl_dentry_version_get(struct dentry *dentry);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 422896406048..f72d6191357e 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -90,7 +90,10 @@ static inline struct ovl_entry *OVL_E(struct dentry *dentry)
>  }
>
>  struct ovl_inode {
> -       struct ovl_dir_cache *cache;
> +       union {
> +               struct ovl_dir_cache *cache;
> +               struct inode *lowerdata;


Please leave comments for union members
... cache; /* directory */
... lowerdata; /* regular file */

Thanks,
Amir.

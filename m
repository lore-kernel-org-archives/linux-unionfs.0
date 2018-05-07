Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180507174102.24086-2-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com> <20180507174102.24086-2-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 7 May 2018 22:26:15 +0300
Message-ID: <CAOQ4uxiP4LTDaGPTbiMDp4CMRQKo3DzaTspJfj=zrePxgqPpHw@mail.gmail.com>
Subject: Re: [PATCH v15 01/30] ovl: Pass argument to ovl_get_inode() in a structure
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 7, 2018 at 8:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> ovl_get_inode() right now has 5 parameters. Soon this patch series will
> add 2 more and suddenly argument list starts looking too long.
>
> Hence pass arguments to ovl_get_inode() in a structure and it looks
> little cleaner.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

After fixing some nits

> ---
>  fs/overlayfs/export.c    |  4 +++-
>  fs/overlayfs/inode.c     | 19 ++++++++++---------
>  fs/overlayfs/namei.c     |  6 ++++--
>  fs/overlayfs/overlayfs.h |  4 +---
>  fs/overlayfs/ovl_entry.h |  8 ++++++++
>  5 files changed, 26 insertions(+), 15 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 425a94672300..867946adcbc5 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -300,12 +300,14 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>         struct dentry *dentry;
>         struct inode *inode;
>         struct ovl_entry *oe;
> +       struct ovl_inode_params oip = {sb, NULL, lowerpath, index, !!lower};

{
   .index = index,
...

>
>         /* We get overlay directory dentries with ovl_lookup_real() */
>         if (d_is_dir(upper ?: lower))
>                 return ERR_PTR(-EIO);
>
> -       inode = ovl_get_inode(sb, dget(upper), lowerpath, index, !!lower);
> +       oip.upperdentry = dget(upper);
> +       inode = ovl_get_inode(&oip);
>         if (IS_ERR(inode)) {
>                 dput(upper);
>                 return ERR_CAST(inode);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 7abcf96e94fc..2fe9538fffc9 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -792,15 +792,16 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
>         return true;
>  }
>
> -struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
> -                           struct ovl_path *lowerpath, struct dentry *index,
> -                           unsigned int numlower)
> +struct inode *ovl_get_inode(struct ovl_inode_params *oip)

IMO, sb should not be part of ovl_inode_params
it should be passed as a separate arg and ovl_inode_params
should be passed to ovl_inode_init() as well.

Thanks,
Amir.

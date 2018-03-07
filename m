Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180306205408.23383-11-vgoyal@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-11-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Mar 2018 09:19:07 +0200
Message-ID: <CAOQ4uxgaWsz9Ea6H-B_jxGeToX19fNR-ySuF5gn1CPPy_BB2jA@mail.gmail.com>
Subject: Re: [PATCH v12 10/17] ovl: Copy up meta inode data from lowest data inode
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> So far lower could not be a meta inode. So whenever it was time to copy
> up data of a meta inode, we could copy it up from top most lower dentry.
>
> But now lower itself can be a metacopy inode. That means data copy up
> needs to take place from a data inode in metacopy inode chain. Find
> lower data inode in the chain and use that for data copy up.
>
> Introduced a helper called ovl_path_lowerdata() to find the lower
> data inode chain.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/copy_up.c   | 14 ++++++++++----
>  fs/overlayfs/overlayfs.h |  1 +
>  fs/overlayfs/util.c      | 14 ++++++++++++++
>  3 files changed, 25 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 9801ae7baa5d..0c8d2755bd25 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -585,13 +585,15 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>         }
>
>         if (S_ISREG(c->stat.mode) && !c->metacopy) {
> -               struct path upperpath;
> +               struct path upperpath, datapath;
>
>                 ovl_path_upper(c->dentry, &upperpath);
>                 BUG_ON(upperpath.dentry != NULL);
>                 upperpath.dentry = temp;
>
> -               err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
> +               ovl_path_lowerdata(c->dentry, &datapath);
> +               BUG_ON(datapath.dentry == NULL);
> +               err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
>                 if (err)
>                         return err;
>         }
> @@ -754,14 +756,18 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
>  /* Copy up data of an inode which was copied up metadata only in the past. */
>  static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>  {
> -       struct path upperpath;
> +       struct path upperpath, datapath;
>         int err;
>
>         ovl_path_upper(c->dentry, &upperpath);
>         if (WARN_ON(upperpath.dentry == NULL))
>                 return -EIO;
>
> -       err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
> +       ovl_path_lowerdata(c->dentry, &datapath);
> +       if (WARN_ON(datapath.dentry == NULL))
> +               return -EIO;
> +
> +       err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
>         if (err)
>                 return err;
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index b48bd73786f1..d999813f9aeb 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -221,6 +221,7 @@ bool ovl_dentry_weird(struct dentry *dentry);
>  enum ovl_path_type ovl_path_type(struct dentry *dentry);
>  void ovl_path_upper(struct dentry *dentry, struct path *path);
>  void ovl_path_lower(struct dentry *dentry, struct path *path);
> +void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
>  enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
>  struct dentry *ovl_dentry_upper(struct dentry *dentry);
>  struct dentry *ovl_dentry_lower(struct dentry *dentry);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 19b936b0a551..22df74cb1def 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -148,6 +148,20 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
>         }
>  }
>

A comment here why  ovl_path_lowerdata is needed would be nice.

> +void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
> +{
> +       struct ovl_entry *oe = dentry->d_fsdata;
> +       int idx = oe->numlower - 1;
> +
> +       if (!oe->numlower) {
> +               *path = (struct path) { };
> +               return;
> +       }
> +
> +       path->mnt = oe->lowerstack[idx].layer->mnt;
> +       path->dentry = oe->lowerstack[idx].dentry;
> +}
> +
>  enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
>  {
>         enum ovl_path_type type = ovl_path_type(dentry);
> --
> 2.13.6
>

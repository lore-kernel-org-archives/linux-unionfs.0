Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190130155304.GA12407@redhat.com>
In-Reply-To: <20190130155304.GA12407@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 30 Jan 2019 20:08:45 +0200
Message-ID: <CAOQ4uxirTQErU0qqKPGZ43aGPuEb1bWpB2ZEBRmC=vXHpSHU2g@mail.gmail.com>
Subject: Re: [PATCH][V2] overlayfs: Do not lose security.capability xattr over
 metadata file copy-up
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Jan 30, 2019 at 5:53 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> If a file has been copied up metadata only, and later data is copied up,
> upper loses any security.capability xattr it has (underlying filesystem
> clears it as upon file write).
>
> From a user's point of view, this is just a file copy-up and that should
> not result in losing security.capability xattr. Hence, before data copy
> up, save security.capability xattr (if any) and restore it on upper after
> data copy up is complete.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c   |   24 ++++++++++++++++++
>  fs/overlayfs/overlayfs.h |    1
>  fs/overlayfs/util.c      |   60 +++++++++++++++++++++++++++++++++--------------
>  3 files changed, 67 insertions(+), 18 deletions(-)
>
> Index: rhvgoyal-linux/fs/overlayfs/util.c
> ===================================================================
> --- rhvgoyal-linux.orig/fs/overlayfs/util.c     2019-01-30 09:38:40.343380525 -0500
> +++ rhvgoyal-linux/fs/overlayfs/util.c  2019-01-30 10:16:58.774380525 -0500
> @@ -863,31 +863,63 @@ bool ovl_is_metacopy_dentry(struct dentr
>         return (oe->numlower > 1);
>  }
>
> -char *ovl_get_redirect_xattr(struct dentry *dentry, int padding)
> +size_t ovl_getxattr(struct dentry *dentry, char *name, void **value,
> +                               size_t *size, int padding)
>  {
>         int res;
> -       char *s, *next, *buf = NULL;
> +       void *buf = NULL;
>
> -       res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, NULL, 0);
> +       res = vfs_getxattr(dentry, name, NULL, 0);
>         if (res < 0) {
>                 if (res == -ENODATA || res == -EOPNOTSUPP)
> -                       return NULL;
> +                       return 0;
>                 goto fail;
>         }
>
> -       buf = kzalloc(res + padding + 1, GFP_KERNEL);
> -       if (!buf)
> -               return ERR_PTR(-ENOMEM);
> -
>         if (res == 0)
>                 goto invalid;
>
> -       res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, buf, res);
> +       buf = kzalloc(res + padding, GFP_KERNEL);
> +       if (!buf)
> +               return -ENOMEM;
> +
> +       res = vfs_getxattr(dentry, name, buf, res);
>         if (res < 0)
>                 goto fail;
> +
>         if (res == 0)
>                 goto invalid;
>
> +       *value = buf;
> +       if (size)
> +               *size = res;
> +
> +       return res;
> +
> +err_free:
> +       kfree(buf);
> +       return res;
> +fail:
> +       pr_warn_ratelimited("overlayfs: failed to get xattr %s: err=%i)\n", name, res);
> +       goto err_free;
> +invalid:
> +       pr_warn_ratelimited("overlayfs: invalid xattr %s \n", name);
> +       res = -EINVAL;
> +       goto err_free;
> +}
> +
> +char *ovl_get_redirect_xattr(struct dentry *dentry, int padding)
> +{
> +       int res;
> +       char *s, *next, *buf = NULL;
> +
> +       res = ovl_getxattr(dentry, OVL_XATTR_REDIRECT, (void **)&buf, NULL,
> +               padding + 1);
> +       if (!res)
> +               return NULL;
> +       if (res < 0)
> +               return ERR_PTR(res);
> +

ERR_PTR(0) is NULL
two cases above can be squashed together.

otherwise looks ok.

Thanks,
Amir.

Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180306205408.23383-10-vgoyal@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-10-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Mar 2018 09:07:22 +0200
Message-ID: <CAOQ4uxgMO6pMQh2tb4tVpQgXDoG7pwOFjo=uGL_BkAYW20ZrHQ@mail.gmail.com>
Subject: Re: [PATCH v12 09/17] ovl: Do not mark a non dir as _OVL_PATH_MERGE
 in ovl_path_type()
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> With the addition of an origin chain for regular files, it is possible
> that we don't have an upperdentry and oe->numlower > 1 for non-dir. So
> mark a path __OVL_TYPE_MERGE only if it is a directory.
>

Okay, but what's wrong with marking a non-dir as TYPE MERGE?
It is, after all, a sort of merged entry.

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 7929cc872df6..19b936b0a551 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -122,7 +122,7 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
>                                 type |= __OVL_PATH_MERGE;
>                 }
>         } else {
> -               if (oe->numlower > 1)
> +               if (oe->numlower > 1 && d_is_dir(dentry))
>                         type |= __OVL_PATH_MERGE;
>         }
>         return type;
> --
> 2.13.6
>

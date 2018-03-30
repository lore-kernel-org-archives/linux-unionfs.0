Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-20-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-20-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 09:52:36 +0300
Message-ID: <CAOQ4uxg3g4ZFi6eVyZ1NbMUPZ4ZAXzmoiAykMZmj1k1upW6aAA@mail.gmail.com>
Subject: Re: [PATCH v13 19/28] ovl: Treat metacopy dentries as type OVL_PATH_MERGE
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now OVL_PATH_MERGE is used only for merged directories.
> But conceptually, a metacopy dentry (backed by a lower data dentry) is
> a merged entity as well.
>
> So mark metacopy dentries as OVL_PATH_MERGE and ovl_rename() makes use
> of this property later to set redirect on a metacopy file.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 927960aa57ee..29f7336ade88 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -118,7 +118,7 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
>                  */
>                 if (oe->numlower) {
>                         type |= __OVL_PATH_ORIGIN;
> -                       if (d_is_dir(dentry))
> +                       if (d_is_dir(dentry) || !ovl_has_upperdata(dentry))
>                                 type |= __OVL_PATH_MERGE;
>                 }
>         } else {
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v7 13/14] ovl: Fix encryption/compression status of a
 metacopy only file
Date: Fri, 17 Nov 2017 11:15:43 +0200
Message-ID: <CAOQ4uxijZAO3Z4vke4M7W1eW6nwSHfvFuBboo-En_+oL33jM-A@mail.gmail.com>
References: <20171116220335.13448-1-vgoyal@redhat.com> <20171116220335.13448-14-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:47091 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965309AbdKQJPo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2017 04:15:44 -0500
Received: by mail-yw0-f195.google.com with SMTP id r186so984833ywe.13
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2017 01:15:44 -0800 (PST)
In-Reply-To: <20171116220335.13448-14-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 17, 2017 at 12:03 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If file is metacopy only, it is possible that lower is encrypted while
> other is not. In that case, report file as encrypted (despite the fact
> that only data is encrypted while metadata is not).
>
> Similarly if lower is compressed, report that in stat for a metacopy
> only file.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/inode.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 7af8a292d54d..fe2d62cc07a7 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -66,6 +66,22 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
>         return err;
>  }
>
> +#define OVL_STATX_ATTR_MASK    (STATX_ATTR_ENCRYPTED | STATX_ATTR_COMPRESSED)

nit: add newline

> +static void ovl_stat_fix_attributes(struct kstat *ustat, struct kstat *lstat) {
> +       unsigned int attr_mask, attr;
> +
> +       attr_mask = lstat->attributes_mask & OVL_STATX_ATTR_MASK;
> +       if (!attr_mask)
> +               return;
> +
> +       attr = lstat->attributes & attr_mask;
> +       if (!attr)
> +               return;
> +
> +       ustat->attributes_mask |= attr_mask;
> +       ustat->attributes |= attr;
> +}
> +
>  int ovl_getattr(const struct path *path, struct kstat *stat,
>                 u32 request_mask, unsigned int flags)
>  {
> @@ -123,8 +139,10 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>                         else
>                                 stat->dev = ovl_get_pseudo_dev(dentry);
>
> -                       if (metacopy)
> +                       if (metacopy) {
>                                 stat->blocks = lowerstat.blocks;
> +                               ovl_stat_fix_attributes(stat, &lowerstat);
> +                       }
>                 }
>                 if (samefs) {
>                         /*
> --
> 2.13.6
>

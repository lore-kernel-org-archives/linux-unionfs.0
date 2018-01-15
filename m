From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 05/17] ovl: encode non-indexed upper file handles
Date: Mon, 15 Jan 2018 12:58:58 +0100
Message-ID: <CAJfpegvAHw2f31JqnTuKaUaZvv3DpwvDYW9Q2LJj-kGL6tzkmQ@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com> <1515086449-26563-6-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35830 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752357AbeAOL7A (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 06:59:00 -0500
Received: by mail-qt0-f194.google.com with SMTP id u10so13798399qtg.2
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jan 2018 03:58:59 -0800 (PST)
In-Reply-To: <1515086449-26563-6-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Thu, Jan 4, 2018 at 6:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> We only need to encode origin if there is a chance that the same object was
> encoded pre copy up and then we need to stay consistent with the same
> encoding also after copy up.
>
> In case a non-pure upper is not indexed, then it was copied up before NFS
> export support was enabled. In that case, we don't need to worry about
> staying consistent with pre copy up encoding and we encode an upper file
> handle.
>
> This mitigates the problem that with no index, we cannot find an upper
> inode from origin inode, so we cannot decode a non-indexed upper from
> origin file handle.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/export.c | 28 +++++++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 48ae02f3acb8..919d43aaa387 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -19,6 +19,28 @@
>  #include <linux/ratelimit.h>
>  #include "overlayfs.h"
>
> +/*
> + * We only need to encode origin if there is a chance that the same object was
> + * encoded pre copy up and then we need to stay consistent with the same
> + * encoding also after copy up. If non-pure upper is not indexed, then it was
> + * copied up before NFS export was enabled. In that case we don't need to worry
> + * about staying consistent with pre copy up encoding and we encode an upper
> + * file handle.
> + */
> +static bool ovl_should_encode_origin(struct dentry *dentry)
> +{
> +       /* Root dentry was born upper */
> +       if (dentry == dentry->d_sb->s_root)
> +               return false;

Root can be lower, no (when there's no upper layer at all)?  The
comment is confusing at best.

> +
> +       /* Decoding a non-indexed upper from origin is not implemented */
> +       if (ovl_dentry_upper(dentry) &&
> +           !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
> +               return false;
> +
> +       return true;
> +}
> +
>  int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
>  {
>         struct dentry *upper = ovl_dentry_upper(dentry);
> @@ -26,11 +48,7 @@ int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
>         struct ovl_fh *fh = NULL;
>         int err;
>
> -       /*
> -        * Overlay root dir inode is encoded as an upper file handle upper,
> -        * because root dir dentry is born upper and not indexed.
> -        */
> -       if (dentry == dentry->d_sb->s_root)
> +       if (!ovl_should_encode_origin(dentry))
>                 origin = NULL;
>
>         err = -EACCES;
> --
> 2.7.4
>

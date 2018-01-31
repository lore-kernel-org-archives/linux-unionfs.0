From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v11 14/18] ovl: Do not mark a non dir as _OVL_PATH_MERGE
 in ovl_path_type()
Date: Thu, 1 Feb 2018 01:51:29 +0200
Message-ID: <CAOQ4uxhLx9_Uh9+JNG8WCOCsd_N+a_bm-WEE9-8b0uDYmCz_ww@mail.gmail.com>
References: <20180131211329.16328-1-vgoyal@redhat.com> <20180131211329.16328-15-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:35466 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754395AbeAaXva (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 18:51:30 -0500
Received: by mail-yw0-f193.google.com with SMTP id u21so9015192ywc.2
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 15:51:30 -0800 (PST)
In-Reply-To: <20180131211329.16328-15-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Jan 31, 2018 at 11:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> With the addition of an origin chain for regular files, it is possible
> that we don't have an upperdentry and oe->numlower > 1 for non-dir. So
> mark a path __OVL_TYPE_MERGE only if it is a directory.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 3b509b691032..e717d561019d 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -106,7 +106,7 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

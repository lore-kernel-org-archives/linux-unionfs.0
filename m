From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v11 11/18] ovl: Allocate bigger stack for origin
Date: Thu, 1 Feb 2018 02:07:07 +0200
Message-ID: <CAOQ4uxhT_pCOphCUgXjB45dgEu4p9=-ndGj+HaBECDyt8V4VWQ@mail.gmail.com>
References: <20180131211329.16328-1-vgoyal@redhat.com> <20180131211329.16328-12-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:41489 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753577AbeBAAHI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 19:07:08 -0500
Received: by mail-yw0-f195.google.com with SMTP id b129so9035054ywa.8
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 16:07:08 -0800 (PST)
In-Reply-To: <20180131211329.16328-12-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Jan 31, 2018 at 11:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now there is only one origin for upper dentry and we allocate space
> to hold only one ovl_path. But with metacopy support, it is possible that
> lower origin is a metacopy itself and we will continue the search for
> lower most data entry and install that too in lower stack so that this
> entry can be used for copy up later.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 27a069cd2bf4..ddb73b5a06d4 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -361,7 +361,8 @@ static int ovl_check_origin(struct dentry *upperdentry,
>
>         BUG_ON(*ctrp);
>         if (!*stackp)
> -               *stackp = kmalloc(sizeof(struct ovl_path), GFP_KERNEL);
> +               *stackp = kmalloc(sizeof(struct ovl_path) * numlower,
> +                                 GFP_KERNEL);

I guess you forgot to change that size to 2...

Amir.

From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix dir cache leak for ovl_cache_get
Date: Thu, 4 May 2017 10:48:08 +0300
Message-ID: <CAOQ4uxinf7VO+=LnUkBjgCAQvUB-4nwP6vMPM4Orcq2FvgQdKg@mail.gmail.com>
References: <1493881633-3451-1-git-send-email-rockdotlee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36594 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbdEDHsK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 May 2017 03:48:10 -0400
Received: by mail-io0-f193.google.com with SMTP id x86so1927535ioe.3
        for <linux-unionfs@vger.kernel.org>; Thu, 04 May 2017 00:48:09 -0700 (PDT)
In-Reply-To: <1493881633-3451-1-git-send-email-rockdotlee@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Rock Lee <rockdotlee@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

On Thu, May 4, 2017 at 10:07 AM, Rock Lee <rockdotlee@gmail.com> wrote:
> In ovl_cache_get, there is a chance that ovl_dentry_version_get and
> cache->version are not equal. Before set the cache to NULL, free it
> first.
>

This is not a leak. dir cache is refcounted and freed on
ovl_dir_{release|reset}() -> ovl_cache_put()

> Signed-off-by: Rock Lee <rockdotlee@gmail.com>
> ---
>  fs/overlayfs/readdir.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index f241b4e..b3af3d3 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -331,6 +331,8 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
>                 cache->refcount++;
>                 return cache;
>         }
> +
> +       kfree(cache);
>         ovl_set_dir_cache(dentry, NULL);
>
>         cache = kzalloc(sizeof(struct ovl_dir_cache), GFP_KERNEL);
> --
> 1.9.1
>

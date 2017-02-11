From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH] ovl: Avoid some memory allocation
Date: Sat, 11 Feb 2017 12:05:36 +0100
Message-ID: <589EF000.7050808@bfs.de>
References: <20170210211814.18257-1-christophe.jaillet@wanadoo.fr>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx02-sz.bfs.de ([194.94.69.103]:64183 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752936AbdBKLFk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 11 Feb 2017 06:05:40 -0500
In-Reply-To: <20170210211814.18257-1-christophe.jaillet@wanadoo.fr>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org



Am 10.02.2017 22:18, schrieb Christophe JAILLET:
> Reorder code to avoid allocating and then freeing some memory in an error
> handling path.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  fs/overlayfs/namei.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 023bb0b03352..ba80ebb8a104 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -35,13 +35,13 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
>  			return 0;
>  		goto fail;
>  	}
> +	if (res == 0)
> +		goto invalid;
> +


perhaps:

   if (res == -ENODATA || res == -EOPNOTSUPP)
	return 0;
	
   if (ret < 0)
	goto fail;

   if (ret == 0)
	goto invalid;

I think its better to read, i guess the author also as we can find this
pattern after the other vfs_getxattr() also.

re,
 wh

>  	buf = kzalloc(prelen + res + strlen(post) + 1, GFP_TEMPORARY);
>  	if (!buf)
>  		return -ENOMEM;
>  
> -	if (res == 0)
> -		goto invalid;
> -
>  	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, buf, res);
>  	if (res < 0)
>  		goto fail;

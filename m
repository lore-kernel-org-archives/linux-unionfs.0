From: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
Subject: Re: [PATCH] ovl: update ctx->pos on impure dir iteration
Date: Wed, 29 Nov 2017 07:46:42 -0600
Message-ID: <20171129134642.GA17605@miguelinux-clr.zpn.intel.com>
References: <1511933721-4720-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:36296 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753568AbdK2Nqo (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Nov 2017 08:46:44 -0500
Content-Disposition: inline
In-Reply-To: <1511933721-4720-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

On Wed, Nov 29, 2017 at 07:35:21AM +0200, Amir Goldstein wrote:
> This fixes a regression with readdir of impure dir in overlayfs
> that is shared to VM via 9p fs.
> 
> Reported-by: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
> Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
> Cc: <stable@vger.kernel.org> #4.14
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/readdir.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 502dc0966f91..b98f1efe50c1 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -663,7 +663,10 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
>  			return PTR_ERR(rdt.cache);
>  	}
>  
> -	return iterate_dir(od->realfile, &rdt.ctx);
> +	err = iterate_dir(od->realfile, &rdt.ctx);
> +	ctx->pos = rdt.ctx.pos;
> +
> +	return err;
>  }

This fix the issue with 9P and Overlay

Tested-by: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>


-- 
Thanks,

Miguel Bernal Marin                     Open Source Technology Center
https://clearlinux.org                              Intel Corporation

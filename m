From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/1] ovl: Put upperdentry if ovl_check_origin() fails
Date: Wed, 8 Nov 2017 09:27:57 -0500
Message-ID: <20171108142757.GA21988@redhat.com>
References: <20171101193722.10228-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8498 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751839AbdKHO16 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Nov 2017 09:27:58 -0500
Content-Disposition: inline
In-Reply-To: <20171101193722.10228-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, stable@vger.kernel.org

On Wed, Nov 01, 2017 at 03:37:22PM -0400, Vivek Goyal wrote:
> If ovl_check_origin() fails, we should put upperdentry. We have a reference
> on it by now. So goto out_put_upper instead of out.
> 
> Fixes: a9d019573e88 ("ovl: lookup non-dir copy-up-origin by file handle")
> Cc: <stable@vger.kernel.org> #4.12
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Hi Amir, Miklos,

Does this patch look fine? I think its a simple bug fix and should go
in 4.15.

Vivek
> ---
>  fs/overlayfs/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index a12dc10bf726..bc6d5c5a3443 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -630,7 +630,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  			err = ovl_check_origin(upperdentry, roe->lowerstack,
>  					       roe->numlower, &stack, &ctr);
>  			if (err)
> -				goto out;
> +				goto out_put_upper;
>  		}
>  
>  		if (d.redirect) {
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

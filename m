From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 14/23] ovl: index all files on copy up with 'verify=on'
Date: Tue, 9 Jan 2018 11:45:51 -0500
Message-ID: <20180109164551.GA11872@redhat.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-15-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58042 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751322AbeAIQpw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 11:45:52 -0500
Content-Disposition: inline
In-Reply-To: <1515084018-25134-15-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

On Thu, Jan 04, 2018 at 06:40:09PM +0200, Amir Goldstein wrote:
> With the 'verify' feature enabled, all files are indexed on copy up.
> The copy up origin inode of an indexed non-dir can be used as a unique
> identifier of the overlay object.
> 
> This is going to be used for NFS export.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/util.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 0254d7f0d401..f40351dcea7b 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -491,6 +491,10 @@ bool ovl_need_index(struct dentry *dentry)
>  	if (!lower || !ovl_indexdir(dentry->d_sb))
>  		return false;
>  
> +	/* Index all files for unique origin verification */
> +	if (!d_is_dir(lower) && ovl_verify(dentry->d_sb))
> +		return true;

If all files are indexd up with verify=on, what is this check about
"!d_is_dir()"?

Vivek

> +
>  	/* Index only lower hardlinks on copy up */
>  	if (!d_is_dir(lower) && d_inode(lower)->i_nlink > 1)
>  		return true;
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

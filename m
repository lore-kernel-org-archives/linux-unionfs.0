From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v9 14/15] ovl: Fix encryption/compression status of a
 metacopy only file
Date: Thu, 18 Jan 2018 09:24:53 -0500
Message-ID: <20180118142453.GA5769@redhat.com>
References: <20171129155448.32721-1-vgoyal@redhat.com>
 <20171129155448.32721-15-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756532AbeAROYy (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jan 2018 09:24:54 -0500
Content-Disposition: inline
In-Reply-To: <20171129155448.32721-15-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

On Wed, Nov 29, 2017 at 10:54:47AM -0500, Vivek Goyal wrote:
> If file is metacopy only, it is possible that lower is encrypted while
> other is not. In that case, report file as encrypted (despite the fact
> that only data is encrypted while metadata is not).
> 
> Similarly if lower is compressed, report that in stat for a metacopy
> only file.
> 

Hi Amir,

Thinking more about this patch. Taking union of lower and upper attributes
(encryption and compressed) does not feel right.

Right now if lower is compressed and upper is not (metacopy), then we will
report file as compressed. But if lower is not compressed while upper is,
still we will report file as compressed. So there is an anomaly here. 

I think, compression and encryption primarily represent the data state.
So always report the state from inode which has file data (lower). And
don't take union with upper metacopy only inode. Because state in
upper inode does not matter till data is copied up.

This will also simplify my implementation when supporting metacopy in 
middle layer. That way I don't have to do getattr() on all intermediate
metacopy inodes in the chain and take a union. Instead I can go to lowest
most data inode and take encryption and compression attributes from there.

I am not sure why did we decide to take union of lower and upper attrs.
Right now it does not seem to make sense to me.

Thanks
Vivek

> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/inode.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 605308a9d60f..0b83efaac9e0 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -66,6 +66,24 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
>  	return err;
>  }
>  
> +#define OVL_STATX_ATTR_MASK	(STATX_ATTR_ENCRYPTED | STATX_ATTR_COMPRESSED)
> +
> +static void ovl_stat_fix_attributes(struct kstat *ustat, struct kstat *lstat)
> +{
> +	unsigned int attr_mask, attr;
> +
> +	attr_mask = lstat->attributes_mask & OVL_STATX_ATTR_MASK;
> +	if (!attr_mask)
> +		return;
> +
> +	attr = lstat->attributes & attr_mask;
> +	if (!attr)
> +		return;
> +
> +	ustat->attributes_mask |= attr_mask;
> +	ustat->attributes |= attr;
> +}
> +
>  int ovl_getattr(const struct path *path, struct kstat *stat,
>  		u32 request_mask, unsigned int flags)
>  {
> @@ -123,8 +141,10 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>  			else
>  				stat->dev = ovl_get_pseudo_dev(dentry);
>  
> -			if (metacopy)
> +			if (metacopy) {
>  				stat->blocks = lowerstat.blocks;
> +				ovl_stat_fix_attributes(stat, &lowerstat);
> +			}
>  		}
>  		if (samefs) {
>  			/*
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

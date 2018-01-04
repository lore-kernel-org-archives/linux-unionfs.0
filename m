From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH v2] ovl: fix inconsistent d_ino for legacy merge dir
Date: Thu, 4 Jan 2018 11:24:01 +0800
Message-ID: <041195ec-841a-9eb8-5b99-32b2fb5f2407@huawei.com>
References: <1515009394-21015-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:35690 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751338AbeADDku (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 22:40:50 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 66338183CB6F5
        for <linux-unionfs@vger.kernel.org>; Thu,  4 Jan 2018 11:24:01 +0800 (CST)
In-Reply-To: <1515009394-21015-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On 2018/1/4 3:56, Amir Goldstein Wrote:
> For a merge dir that was copied up before v4.12 or that was hand crafted
> offline (e.g. mkdir {upper/lower}/dir), upper dir does not contain the
> 'trusted.overlay.origin' xattr.  In that case, stat(2) on the merge dir
> returns the lower dir st_ino, but getdents(2) returns the upper dir d_ino.
> 
> After this change, on merge dir lookup, missing origin xattr on upper
> dir will be fixed and 'impure' xattr will be fixed on parent of the legacy
> merge dir.
> 
> Suggested-by: zhangyi (F) <yi.zhang@huawei.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Zhangyi,
> 
> A slightly differnt patch. This time with ovl_want_write()
> and using different helpers.
> 
> Please re-review and test.
> 

Looks good to me.

Reviewed-by: zhangyi (F) <yi.zhang@huawei.com>

> Thanks,
> Amir.
> 
>  fs/overlayfs/copy_up.c   |  4 ++--
>  fs/overlayfs/namei.c     | 33 +++++++++++++++++++++++++++++++++
>  fs/overlayfs/overlayfs.h |  2 ++
>  3 files changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index eb3b8d39fb61..206ececd5ae7 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -288,8 +288,8 @@ struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper)
>  	return fh;
>  }
>  
> -static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
> -			  struct dentry *upper)
> +int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
> +		   struct dentry *upper)
>  {
>  	const struct ovl_fh *fh = NULL;
>  	int err;
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 9cf15463754c..71db9a966d88 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -584,6 +584,27 @@ static int ovl_find_layer(struct ovl_fs *ofs, struct ovl_path *path)
>  	return i;
>  }
>  
> +/* Fix missing 'origin' xattr */
> +static int ovl_fix_origin(struct dentry *dentry, struct dentry *lower,
> +			  struct dentry *upper)
> +{
> +	int err;
> +
> +	if (ovl_check_origin_xattr(upper))
> +		return 0;
> +
> +	err = ovl_want_write(dentry);
> +	if (err)
> +		return err;
> +
> +	err = ovl_set_origin(dentry, lower, upper);
> +	if (!err)
> +		err = ovl_set_impure(dentry->d_parent, upper->d_parent);
> +
> +	ovl_drop_write(dentry);
> +	return err;
> +}
> +
>  struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  			  unsigned int flags)
>  {
> @@ -674,6 +695,18 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  		if (!this)
>  			continue;
>  
> +		/*
> +		 * If no origin fh is stored in upper of a merge dir, store fh
> +		 * of lower dir and set upper parent "impure".
> +		 */
> +		if (upperdentry && !ctr && !ofs->noxattr) {
> +			err = ovl_fix_origin(dentry, this, upperdentry);
> +			if (err) {
> +				dput(this);
> +				goto out_put;
> +			}
> +		}
> +
>  		stack[ctr].dentry = this;
>  		stack[ctr].layer = lower.layer;
>  		ctr++;
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index b489099ccd49..d1cfa69c98b5 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -322,3 +322,5 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags);
>  int ovl_copy_xattr(struct dentry *old, struct dentry *new);
>  int ovl_set_attr(struct dentry *upper, struct kstat *stat);
>  struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper);
> +int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
> +		   struct dentry *upper);
> 

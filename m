From: hujianyang <hujianyang@huawei.com>
Subject: Re: linux / overlay / OpenWrt / problems with full working dir
Date: Tue, 19 May 2015 17:55:03 +0800
Message-ID: <555B0877.3030807@huawei.com>
References: <20150519075120.GL28644@medion.lan> <20150519090339.GB9960@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:62896 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbbESJ63 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 19 May 2015 05:58:29 -0400
In-Reply-To: <20150519090339.GB9960@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Bastian Bittorf <bittorf@bluebottle.com>, linux-unionfs@vger.kernel.org

Hi Miklos,

On 2015/5/19 17:03, Miklos Szeredi wrote:
> 
> ---
>  fs/overlayfs/copy_up.c |    3 +++
>  fs/overlayfs/dir.c     |    9 +++++++++
>  fs/overlayfs/super.c   |   12 +++++++++---
>  3 files changed, 21 insertions(+), 3 deletions(-)
> 
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -300,6 +300,9 @@ int ovl_copy_up_one(struct dentry *paren
>  	struct cred *override_cred;
>  	char *link = NULL;
>  
> +	if (WARN_ON(!workdir))
> +		return -EROFS;
> +

When will this condition occur?

>  	ovl_path_upper(parent, &parentpath);
>  	upperdir = parentpath.dentry;
>  
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -222,6 +222,9 @@ static struct dentry *ovl_clear_empty(st
>  	struct kstat stat;
>  	int err;
>  
> +	if (WARN_ON(!workdir))
> +		return ERR_PTR(-EROFS);
> +
>  	err = ovl_lock_rename_workdir(workdir, upperdir);
>  	if (err)
>  		goto out;
> @@ -322,6 +325,9 @@ static int ovl_create_over_whiteout(stru
>  	struct dentry *newdentry;
>  	int err;
>  
> +	if (WARN_ON(!workdir))
> +		return -EROFS;
> +
>  	err = ovl_lock_rename_workdir(workdir, upperdir);
>  	if (err)
>  		goto out;
> @@ -506,6 +512,9 @@ static int ovl_remove_and_whiteout(struc
>  	struct dentry *opaquedir = NULL;
>  	int err;
>  
> +	if (WARN_ON(!workdir))
> +		return -EROFS;
> +
>  	if (is_dir) {
>  		opaquedir = ovl_check_empty_and_clear(dentry);
>  		err = PTR_ERR(opaquedir);
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -740,9 +740,15 @@ static int ovl_fill_super(struct super_b
>  	ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
>  	err = PTR_ERR(ufs->workdir);
>  	if (IS_ERR(ufs->workdir)) {
> -		pr_err("overlayfs: failed to create directory %s/%s\n",
> -		       ufs->config.workdir, OVL_WORKDIR_NAME);
> -		goto out_put_lower_mnt;
> +		if (err == -ENOSPC || err == -EROFS) {

Since upper fs should not be R/O after commit 71cbad7e694ee81,
could the return value here be -EROFS?

> +			pr_warning("overlayfs: failed to work directory (%s), mounting read-only\n", err == ENOSPC ? "ENOSPC" : "EROFS");
> +			sb->s_flags |= MS_RDONLY;
> +			ufs->workdir = NULL;
> +		} else {
> +			pr_err("overlayfs: failed to create directory %s/%s\n",
> +			       ufs->config.workdir, OVL_WORKDIR_NAME);
> +			goto out_put_lower_mnt;
> +		}
>  	}
>  
>  	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 

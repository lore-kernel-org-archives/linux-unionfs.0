From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH 2/3] ovl: set origin xattr for merge dir on lookup
Date: Wed, 8 Nov 2017 14:59:01 +0800
Message-ID: <03198975-d870-d49e-f807-01f3d805d001@huawei.com>
References: <1510090740-7216-1-git-send-email-amir73il@gmail.com>
 <1510090740-7216-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [45.249.212.32] ([45.249.212.32]:55880 "EHLO huawei.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753851AbdKHHAR (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Nov 2017 02:00:17 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BE26FF075A5F0
        for <linux-unionfs@vger.kernel.org>; Wed,  8 Nov 2017 14:59:59 +0800 (CST)
In-Reply-To: <1510090740-7216-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, Miao Xie <miaoxie@huawei.com>

On 2017/11/8 5:38, Amir Goldstein Wrote:
> For old existing merge dirs whose "origin" xattr was not set at copy up
> time, we amend the situation on lookup.
> 
> If no origin fh is stored in upper of a merge dir, store fh of upper most
> lower dir or 'null' fh if lower does not support file handles. We do this
> so we can filter out whiteouts in case lower dir is removed offline and
> then upper dir becomes a pure upper in a future mount.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/namei.c     | 61 ++++++++++++++++++++++++++++++++++++++++--------
>  fs/overlayfs/overlayfs.h |  2 +-
>  fs/overlayfs/super.c     |  4 ++--
>  3 files changed, 54 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 322c6214114f..65606a0a124c 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -87,6 +87,8 @@ static int ovl_acceptable(void *ctx, struct dentry *dentry)
>  	return 1;
>  }
>  
> +static struct ovl_fh ovl_null_fh;
> +
>  static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
>  {
>  	int res;
> @@ -100,7 +102,7 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
>  	}
>  	/* Zero size value means "copied up but origin unknown" */
>  	if (res == 0)
> -		return NULL;
> +		goto null_fh;
>  
>  	fh  = kzalloc(res, GFP_KERNEL);
>  	if (!fh)
> @@ -118,12 +120,12 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
>  
>  	/* Treat larger version and unknown flags as "origin unknown" */
>  	if (fh->version > OVL_FH_VERSION || fh->flags & ~OVL_FH_FLAG_ALL)
> -		goto out;
> +		goto null_fh;
>  
>  	/* Treat endianness mismatch as "origin unknown" */
>  	if (!(fh->flags & OVL_FH_FLAG_ANY_ENDIAN) &&
>  	    (fh->flags & OVL_FH_FLAG_BIG_ENDIAN) != OVL_FH_FLAG_CPU_ENDIAN)
> -		goto out;
> +		goto null_fh;
>  
>  	return fh;
>  
> @@ -131,6 +133,10 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
>  	kfree(fh);
>  	return NULL;
>  
> +null_fh:
> +	kfree(fh);
> +	return &ovl_null_fh;
> +
>  fail:
>  	pr_warn_ratelimited("overlayfs: failed to get origin (%i)\n", res);
>  	goto out;
> @@ -149,6 +155,9 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
>  	if (IS_ERR_OR_NULL(fh))
>  		return (struct dentry *)fh;
>  
> +	if (fh == &ovl_null_fh)
> +		return NULL;
> +
>  	/*
>  	 * Make sure that the stored uuid matches the uuid of the lower
>  	 * layer where file handle will be decoded.
> @@ -333,6 +342,10 @@ static int ovl_verify_origin_fh(struct dentry *dentry, const struct ovl_fh *fh)
>  	if (IS_ERR(ofh))
>  		return PTR_ERR(ofh);
>  
> +	/* NULL fh (no lower fh support) and stored 'null' fh is a match */
> +	if (ofh == &ovl_null_fh)
> +		return fh ? -ESTALE : 0;
> +

Is -ESTALE -> -ENODATA better ?

Consider the case: We set 'null' fh in merged upper dir on a 'file handle' not supported
base filesystem, then we copy or tar all underlying directories to another base filesystem which is
'file handle' supported and mount overlayfs again. I think we can update upperdir's fh instead of
return fail.

At the same time, consider the opposite side, all directories move from a base filesystem which 'file
handle' supported to a not supported one. It will trigger NULL pointer crash in ovl_verify_origin_fh()
because fh is NULL but ofh was existed. Following change good ?

-	if (!ofh)
+	if (!ofh || !fh)
		return -ENODATA;

Thanks,
Yi.

>  	if (fh->len != ofh->len || memcmp(fh, ofh, fh->len))
>  		err = -ESTALE;
>  
> @@ -345,24 +358,40 @@ static int ovl_verify_origin_fh(struct dentry *dentry, const struct ovl_fh *fh)
>   *
>   * If @set is true and there is no stored file handle, encode and store origin
>   * file handle in OVL_XATTR_ORIGIN.
> + * If @strict is true, then the stored file handle must be non 'null'.
> + * If @strict is false, then a stored 'null' file handle and lower with no file
> + * handle support is considered a match.
>   *
>   * Return 0 on match, -ESTALE on mismatch, < 0 on error.
>   */
>  int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
> -		      bool is_upper, bool set)
> +		      bool is_upper, bool set, bool strict)
>  {
>  	struct inode *inode;
> -	struct ovl_fh *fh;
> +	const struct ovl_fh *fh = NULL;
>  	int err;
>  
> -	fh = ovl_encode_fh(origin, is_upper);
> -	err = PTR_ERR(fh);
> -	if (IS_ERR(fh))
> +	/*
> +	 * When lower layer doesn't support export operations store a 'null' fh,
> +	 * so we can use the overlay.origin xattr to distignuish between a copy
> +	 * up and a pure upper inode.
> +	 */
> +	err = -EOPNOTSUPP;
> +	if (ovl_can_decode_fh(origin->d_sb)) {
> +		fh = ovl_encode_fh(origin, is_upper);
> +		err = PTR_ERR(fh);
> +		if (IS_ERR(fh))
> +			goto fail;
> +	} else if (strict) {
>  		goto fail;
> +	}
>  
>  	err = ovl_verify_origin_fh(dentry, fh);
> -	if (set && err == -ENODATA)
> -		err = ovl_do_setxattr(dentry, OVL_XATTR_ORIGIN, fh, fh->len, 0);
> +	if (set && err == -ENODATA) {
> +		err = ovl_do_setxattr(dentry, OVL_XATTR_ORIGIN, fh,
> +				      fh ? fh->len : 0, 0);
> +	}
> +
>  	if (err)
>  		goto fail;
>  
> @@ -662,6 +691,18 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  		if (!this)
>  			continue;
>  
> +		/*
> +		 * If no origin fh is stored in upper of a merge dir, store fh
> +		 * of upper most lower dir or 'null' fh if lower does not
> +		 * support file handles. We do this so we can filter out
> +		 * whiteouts in case lower dir is removed offline and this upper
> +		 * becomes a pure upper in a future mount.
> +		 */
> +		if (this && upperdentry && !ctr) {
> +			(void)ovl_verify_origin(upperdentry, this,
> +						false, true, false);
> +		}
> +
>  		stack[ctr].dentry = this;
>  		stack[ctr].layer = lower.layer;
>  		ctr++;
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index bee51296db38..df925188394f 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -252,7 +252,7 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
>  
>  /* namei.c */
>  int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
> -		      bool is_upper, bool set);
> +		      bool is_upper, bool set, bool strict);
>  int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
>  		     unsigned int numlower);
>  int ovl_get_index_name(struct dentry *origin, struct qstr *name);
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index af4d3e876398..f8bba4f8b940 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1120,7 +1120,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  		/* Verify lower root is upper root origin */
>  		err = ovl_verify_origin(upperpath.dentry,
>  					oe->lowerstack[0].dentry,
> -					false, true);
> +					false, true, true);
>  		if (err) {
>  			pr_err("overlayfs: failed to verify upper root origin\n");
>  			goto out_free_oe;
> @@ -1131,7 +1131,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  		if (ufs->indexdir) {
>  			/* Verify upper root is index dir origin */
>  			err = ovl_verify_origin(ufs->indexdir, upperpath.dentry,
> -						true, true);
> +						true, true, true);
>  			if (err)
>  				pr_err("overlayfs: failed to verify index dir origin\n");
>  
> 

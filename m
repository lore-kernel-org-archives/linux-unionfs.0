From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v7 5/8] ovl: relax same fs constraint for constant st_ino
Date: Mon, 6 Nov 2017 15:43:03 -0500
Message-ID: <20171106204303.GA23294@redhat.com>
References: <1509655091-13630-1-git-send-email-amir73il@gmail.com>
 <1509655091-13630-6-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52216 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932551AbdKFUnE (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Nov 2017 15:43:04 -0500
Content-Disposition: inline
In-Reply-To: <1509655091-13630-6-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org

On Thu, Nov 02, 2017 at 10:38:08PM +0200, Amir Goldstein wrote:
> For the case of all layers not on the same fs, return the copy up origin
> inode st_dev/st_ino for non-dir from stat(2).
> 
> This guaranties constant st_dev/st_ino for non-dir across copy up.
> Like the same fs case, st_ino of non-dir is also persistent.
> 
> If the st_dev/st_ino for copied up object would have been the same as
> that of the real underlying lower file, running diff on underlying lower
> file and overlay copied up file would result in diff reporting that the
> two files are equal when in fact, they may have different content.
> 
> Therefore, unlike the same fs case, st_dev is not persistent because it
> uses the unique anonymous bdev allocated for the lower layer.

I have a stupid question. I thought st_dev is allocated dynamically and
is not persistent across reboot. Is that not the case? If yes, then
it is not persistent for same fs case as well. If yes, above does not
make sense.

Vivek

> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/inode.c | 49 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 29 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 607a50c50042..d06de98808f6 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -74,6 +74,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>  	struct path realpath;
>  	const struct cred *old_cred;
>  	bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
> +	bool samefs = ovl_same_sb(dentry->d_sb);
>  	int err;
>  
>  	type = ovl_path_real(dentry, &realpath);
> @@ -83,16 +84,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>  		goto out;
>  
>  	/*
> -	 * When all layers are on the same fs, all real inode number are
> -	 * unique, so we use the overlay st_dev, which is friendly to du -x.
> -	 *
> -	 * We also use st_ino of the copy up origin, if we know it.
> -	 * This guaranties constant st_dev/st_ino across copy up.
> +	 * For non-dir or same fs, we use st_ino of the copy up origin, if we
> +	 * know it. This guaranties constant st_dev/st_ino across copy up.
>  	 *
>  	 * If filesystem supports NFS export ops, this also guaranties
>  	 * persistent st_ino across mount cycle.
>  	 */
> -	if (ovl_same_sb(dentry->d_sb)) {
> +	if (!is_dir || samefs) {
>  		if (OVL_TYPE_ORIGIN(type)) {
>  			struct kstat lowerstat;
>  			u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
> @@ -103,7 +101,6 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>  			if (err)
>  				goto out;
>  
> -			WARN_ON_ONCE(stat->dev != lowerstat.dev);
>  			/*
>  			 * Lower hardlinks may be broken on copy up to different
>  			 * upper files, so we cannot use the lower origin st_ino
> @@ -115,27 +112,39 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>  			if (is_dir || lowerstat.nlink == 1 ||
>  			    ovl_test_flag(OVL_INDEX, d_inode(dentry)))
>  				stat->ino = lowerstat.ino;
> +
> +			if (samefs)
> +				WARN_ON_ONCE(stat->dev != lowerstat.dev);
> +			else
> +				stat->dev = ovl_get_pseudo_dev(dentry);
>  		}
> -		stat->dev = dentry->d_sb->s_dev;
> -	} else if (is_dir) {
> +		if (samefs) {
> +			/*
> +			 * When all layers are on the same fs, all real inode
> +			 * number are unique, so we use the overlay st_dev,
> +			 * which is friendly to du -x.
> +			 */
> +			stat->dev = dentry->d_sb->s_dev;
> +		} else if (!OVL_TYPE_UPPER(type)) {
> +			/*
> +			 * For non-samefs setup, to make sure that st_dev/st_ino
> +			 * pair is unique across the system, we use a unique
> +			 * anonymous st_dev for lower layer inode.
> +			 */
> +			stat->dev = ovl_get_pseudo_dev(dentry);
> +		}
> +	} else {
>  		/*
> -		 * If not all layers are on the same fs the pair {real st_ino;
> -		 * overlay st_dev} is not unique, so use the non persistent
> -		 * overlay st_ino.
> -		 *
>  		 * Always use the overlay st_dev for directories, so 'find
>  		 * -xdev' will scan the entire overlay mount and won't cross the
>  		 * overlay mount boundaries.
> +		 *
> +		 * If not all layers are on the same fs the pair {real st_ino;
> +		 * overlay st_dev} is not unique, so use the non persistent
> +		 * overlay st_ino for directories.
>  		 */
>  		stat->dev = dentry->d_sb->s_dev;
>  		stat->ino = dentry->d_inode->i_ino;
> -	} else if (!OVL_TYPE_UPPER(type)) {
> -		/*
> -		 * For non-samefs setup, to make sure that st_dev/st_ino pair
> -		 * is unique across the system, we use a unique anonymous
> -		 * st_dev for lower layer inode.
> -		 */
> -		stat->dev = ovl_get_pseudo_dev(dentry);
>  	}
>  
>  	/*
> -- 
> 2.7.4

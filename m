From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] ovl: fix EIO from lookup of non-indexed upper
Date: Fri, 13 Oct 2017 09:34:56 -0400
Message-ID: <20171013133456.GA26536@redhat.com>
References: <1507824184-6244-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753446AbdJMNe5 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 13 Oct 2017 09:34:57 -0400
Content-Disposition: inline
In-Reply-To: <1507824184-6244-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, "# v4 . 13" <stable@vger.kernel.org>

On Thu, Oct 12, 2017 at 07:03:04PM +0300, Amir Goldstein wrote:
> Commit fbaf94ee3cd5 ("ovl: don't set origin on broken lower hardlink")
> attempt to avoid the condition of non-indexed upper inode with lower
> hardlink as origin. If this condition is found, lookup returns EIO.
> 
> The protection of commit mentioned above does not cover the case of lower
> that is not a hardlink when it is copied up (with either index=off/on)
> and then lower is hardlinked while overlay is offline.
> 
> Changes to lower layer while overlayfs is offline should not result in
> unexpected behavior, so a permanent EIO error after creating a link in
> lower layer should not be considered as correct behavior.
> 
> This fix replaces EIO error with a warning in cases where upper has
> origin but no index is found, or index is found that does not match upper
> inode. In those cases, lookup will not fail and the returned overlay
> inode will be hashed by upper inode instead of by lower origin inode.
> 
> Fixes: 359f392ca53e ("ovl: lookup index entry for copy up origin")
> Cc: <stable@vger.kernel.org> # v4.13
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Miklos,
> 
> Following a discussion with Vivek about metacopy feature and the option
> of setting ORIGIN for non-indexed lower hardlinks on copy up, I came to
> a conclusion that the current EIO behavior is not quite tollerant to lower
> changes as one would hope and that it should be fixed in stable kernels.
> 
> I've implemented an xfstest to test the EIO behavior has been fixed [1].
> 
> Amir.
> 
> [1] https://github.com/amir73il/xfstests/commits/overlayfs-devel
> 
>  fs/overlayfs/inode.c     | 20 ++++++++++++++++----
>  fs/overlayfs/namei.c     | 22 ++++++++++++----------
>  fs/overlayfs/overlayfs.h |  3 ++-
>  3 files changed, 30 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index a619addecafc..321511ed8c42 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -598,18 +598,30 @@ static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
>  	return true;
>  }
>  
> -struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry)
> +struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
> +			    struct dentry *index)
>  {
>  	struct dentry *lowerdentry = ovl_dentry_lower(dentry);
>  	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
>  	struct inode *inode;
> +	/* Already indexed or could be indexed on copy up? */
> +	bool indexed = (index || (ovl_indexdir(dentry->d_sb) && !upperdentry));

Hi Amir,

Looks like current code hashes inodes of lowerdentry even if nlink=1
(index=on, upperdentry=NULL). IIUC this will never be indexed. 

So I am wondering why do we hash inodes of lower when nlink=1. When is it
used.

Vivek

> +
> +	if (WARN_ON(upperdentry && indexed && !lowerdentry))
> +		return ERR_PTR(-EIO);
>  
>  	if (!realinode)
>  		realinode = d_inode(lowerdentry);
>  
> -	if (!S_ISDIR(realinode->i_mode) &&
> -	    (upperdentry || (lowerdentry && ovl_indexdir(dentry->d_sb)))) {
> -		struct inode *key = d_inode(lowerdentry ?: upperdentry);
> +	/*
> +	 * Copy up origin (lower) may exist for non-indexed upper, but we must
> +	 * not use lower as hash key in that case.
> +	 * Hash inodes that are or could be indexed by origin inode and
> +	 * non-indexed upper inodes that could be hard linked by upper inode.
> +	 */
> +	if (!S_ISDIR(realinode->i_mode) && (upperdentry || indexed)) {
> +		struct inode *key = d_inode(indexed ? lowerdentry :
> +						      upperdentry);
>  		unsigned int nlink;
>  
>  		inode = iget5_locked(dentry->d_sb, (unsigned long) key,
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 654bea1a5ac9..88ff1daeb3d7 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -517,17 +517,14 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
>  	inode = d_inode(index);
>  	if (d_is_negative(index)) {
>  		if (upper && d_inode(origin)->i_nlink > 1) {
> -			pr_warn_ratelimited("overlayfs: hard link with origin but no index (ino=%lu).\n",
> -					    d_inode(origin)->i_ino);
> -			goto fail;
> +			pr_warn_ratelimited("overlayfs: hard link with origin but no index (%pd2).\n",
> +					    upper);
>  		}
> -
> -		dput(index);
> -		index = NULL;
> +		goto out_dput;
>  	} else if (upper && d_inode(upper) != inode) {
> -		pr_warn_ratelimited("overlayfs: wrong index found (index=%pd2, ino=%lu, upper ino=%lu).\n",
> -				    index, inode->i_ino, d_inode(upper)->i_ino);
> -		goto fail;
> +		pr_warn_ratelimited("overlayfs: broken hard link - ignoring index (%pd2).\n",
> +				    upper);
> +		goto out_dput;
>  	} else if (ovl_dentry_weird(index) || ovl_is_whiteout(index) ||
>  		   ((inode->i_mode ^ d_inode(origin)->i_mode) & S_IFMT)) {
>  		/*
> @@ -547,6 +544,11 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
>  	kfree(name.name);
>  	return index;
>  
> +out_dput:
> +	dput(index);
> +	index = NULL;
> +	goto out;
> +
>  fail:
>  	dput(index);
>  	index = ERR_PTR(-EIO);
> @@ -709,7 +711,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  		upperdentry = dget(index);
>  
>  	if (upperdentry || ctr) {
> -		inode = ovl_get_inode(dentry, upperdentry);
> +		inode = ovl_get_inode(dentry, upperdentry, index);
>  		err = PTR_ERR(inode);
>  		if (IS_ERR(inode))
>  			goto out_free_oe;
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index c706a6f99928..d9a0edd4e57e 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -286,7 +286,8 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
>  bool ovl_is_private_xattr(const char *name);
>  
>  struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
> -struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry);
> +struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
> +			    struct dentry *index);
>  static inline void ovl_copyattr(struct inode *from, struct inode *to)
>  {
>  	to->i_uid = from->i_uid;
> -- 
> 2.7.4

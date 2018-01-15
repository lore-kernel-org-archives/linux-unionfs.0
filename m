From: Niklas Cassel <niklas.cassel@axis.com>
Subject: Re: [PATCH] ovl: hash directory inodes for fsnotify
Date: Mon, 15 Jan 2018 12:43:13 +0100
Message-ID: <20180115114313.GC7399@axis.com>
References: <1515947740-16120-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:46354 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754444AbeAOLnQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 06:43:16 -0500
Content-Disposition: inline
In-Reply-To: <1515947740-16120-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org

Hello Amir, Miklos

Thanks for fixing this so swiftly, much appreciated.

When testing, I included the follow up patch.

Tested-by: Niklas Cassel <niklas.cassel@axis.com>

On Sun, Jan 14, 2018 at 06:35:40PM +0200, Amir Goldstein wrote:
> fsnotify pins a watched directory inode in cache, but if directory dentry
> is released, new lookup will allocate a new dentry and a new inode.
> Directory events will be notified on the new inode, while fsnotify listener
> is watching the old pinned inode.
> 
> Hash all directory inodes to reuse the pinned inode on lookup. Pure upper
> dirs are hashes by real upper inode, merge and lower dirs are hashed by
> real lower inode.
> 
> The reference to lower inode was being held by the lower dentry object
> in the overlay dentry (oe->lowerstack[0]). Releasing the overlay dentry
> may drop lower inode refcount to zero. Add a refcount on behalf of the
> overlay inode to prevent that.
> 
> As a by-product, hashing directory inodes also detects multiple
> redirected dirs to the same lower dir and uncovered redirected dir
> target on and returns -ESTALE on lookup.
> 
> The reported issue dates back to initial version of overlayfs, but this
> patch depends on ovl_inode code that was introduced in kernel v4.13.
> 
> Cc: <stable@vger.kernel.org> #v4.13
> Reported-by: Niklas Cassel <niklas.cassel@axis.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Miklos,
> 
> Following the inotify issue report [1] from Niklas, I took the patch
> 'hash directory inodes for NFS export' and applied it on top of my
> ovl-fixes [2] branch, without the NFS export condition.
> 
> Because fixing the reported issue also requires the patch 'grab i_count
> reference of lower inode', I squashed them together, so applying a fix
> to stable kernels will be less error prone.
> 
> I wrote an LTP test [3] to verify the issue and the fix.
> 
> Amir.
> 
> [1] https://marc.info/?l=linux-unionfs&m=151581833424827&w=2
> [2] https://github.com/amir73il/linux/commits/ovl-fixes
> [3] https://github.com/amir73il/ltp/commits/inotify-drop-caches
> 
>  fs/overlayfs/inode.c | 31 +++++++++++++++++++++++--------
>  fs/overlayfs/super.c |  1 +
>  fs/overlayfs/util.c  |  4 ++--
>  3 files changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 00b6b294272a..090f9735f4ed 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -551,7 +551,8 @@ unsigned int ovl_get_nlink(struct dentry *lowerdentry,
>  	char buf[13];
>  	int err;
>  
> -	if (!lowerdentry || !upperdentry || d_inode(lowerdentry)->i_nlink == 1)
> +	if (!lowerdentry || !upperdentry || d_is_dir(lowerdentry) ||
> +	    d_inode(lowerdentry)->i_nlink == 1)
>  		return fallback;
>  
>  	err = vfs_getxattr(upperdentry, OVL_XATTR_NLINK, &buf, sizeof(buf) - 1);
> @@ -606,6 +607,16 @@ static int ovl_inode_set(struct inode *inode, void *data)
>  static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
>  			     struct dentry *upperdentry)
>  {
> +	if (S_ISDIR(inode->i_mode)) {
> +		/* Real lower dir moved to upper layer under us? */
> +		if (!lowerdentry && ovl_inode_lower(inode))
> +			return false;
> +
> +		/* Lookup of an uncovered redirect origin? */
> +		if (!upperdentry && ovl_inode_upper(inode))
> +			return false;
> +	}
> +
>  	/*
>  	 * Allow non-NULL lower inode in ovl_inode even if lowerdentry is NULL.
>  	 * This happens when finding a copied up overlay inode for a renamed
> @@ -633,6 +644,7 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
>  	struct inode *inode;
>  	/* Already indexed or could be indexed on copy up? */
>  	bool indexed = (index || (ovl_indexdir(dentry->d_sb) && !upperdentry));
> +	struct dentry *origin = indexed ? lowerdentry : NULL;
>  
>  	if (WARN_ON(upperdentry && indexed && !lowerdentry))
>  		return ERR_PTR(-EIO);
> @@ -641,14 +653,17 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
>  		realinode = d_inode(lowerdentry);
>  
>  	/*
> -	 * Copy up origin (lower) may exist for non-indexed upper, but we must
> -	 * not use lower as hash key in that case.
> -	 * Hash inodes that are or could be indexed by origin inode and
> -	 * non-indexed upper inodes that could be hard linked by upper inode.
> +	 * Copy up origin (lower) may exist for non-indexed non-dir upper, but
> +	 * we must not use lower as hash key in that case.
> +	 * Hash non-dir that is or could be indexed by origin inode.
> +	 * Hash dir that is or could be merged by origin inode.
> +	 * Hash pure upper and non-indexed non-dir by upper inode.
>  	 */
> -	if (!S_ISDIR(realinode->i_mode) && (upperdentry || indexed)) {
> -		struct inode *key = d_inode(indexed ? lowerdentry :
> -						      upperdentry);
> +	if (S_ISDIR(realinode->i_mode))
> +		origin = lowerdentry;
> +
> +	if (upperdentry || origin) {
> +		struct inode *key = d_inode(origin ?: upperdentry);
>  		unsigned int nlink;
>  
>  		inode = iget5_locked(dentry->d_sb, (unsigned long) key,
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 5f6d2385c0b3..3387e6d639a5 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -211,6 +211,7 @@ static void ovl_destroy_inode(struct inode *inode)
>  	struct ovl_inode *oi = OVL_I(inode);
>  
>  	dput(oi->__upperdentry);
> +	iput(oi->lower);
>  	kfree(oi->redirect);
>  	ovl_dir_cache_free(inode);
>  	mutex_destroy(&oi->lock);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index d6bb1c9f5e7a..06119f34a69d 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -257,7 +257,7 @@ void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
>  	if (upperdentry)
>  		OVL_I(inode)->__upperdentry = upperdentry;
>  	if (lowerdentry)
> -		OVL_I(inode)->lower = d_inode(lowerdentry);
> +		OVL_I(inode)->lower = igrab(d_inode(lowerdentry));
>  
>  	ovl_copyattr(d_inode(upperdentry ?: lowerdentry), inode);
>  }
> @@ -273,7 +273,7 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
>  	 */
>  	smp_wmb();
>  	OVL_I(inode)->__upperdentry = upperdentry;
> -	if (!S_ISDIR(upperinode->i_mode) && inode_unhashed(inode)) {
> +	if (inode_unhashed(inode)) {
>  		inode->i_private = upperinode;
>  		__insert_inode_hash(inode, (unsigned long) upperinode);
>  	}
> -- 
> 2.7.4
> 

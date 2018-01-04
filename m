From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 05/23] ovl: pass ovl_layer array to
 ovl_check_origin_fh()
Date: Thu, 4 Jan 2018 17:35:25 -0500
Message-ID: <20180104223525.GC2808@redhat.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-6-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752552AbeADWf0 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 17:35:26 -0500
Content-Disposition: inline
In-Reply-To: <1515084018-25134-6-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

On Thu, Jan 04, 2018 at 06:40:00PM +0200, Amir Goldstein wrote:
> Pass the fs instance lower_layer array instead of lowerstack array to
> ovl_check_origin_fh(), because the dentry member of ovl_path plays no
> part in this helper.
> 
> This change simplifies the argument list of ovl_check_origin(),
> ovl_cleanup_index() and ovl_verify_index().
> 
> We pass lower_layer array and numlower and not struct ovl_fs to
> ovl_check_origin_fh(), because we are going to use this helper for
> decoding upper layer file handles for NFS export support.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/namei.c     | 25 +++++++++++--------------
>  fs/overlayfs/overlayfs.h |  9 ++++-----
>  fs/overlayfs/readdir.c   | 12 ++++++------
>  fs/overlayfs/super.c     |  5 +----
>  4 files changed, 22 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 4cc8fb64c879..46a3e31b0225 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -292,16 +292,14 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
>  
>  
>  static int ovl_check_origin_fh(struct ovl_fh *fh, struct dentry *upperdentry,
> -			       struct ovl_path *lower, unsigned int numlower,
> +			       struct ovl_layer *layers, unsigned int numlayers,
>  			       struct ovl_path **stackp)

I was thinking if this will lead to decoding in all lower layers (as opposed
to only some depending on how many lower layers ovl_entry has stored). But
looks like we already do decoding in all the lower layers of fs (both for
origin and index). So this is not a concern. 

Vivek

>  {
> -	struct vfsmount *mnt;
>  	struct dentry *origin = NULL;
>  	int i;
>  
> -	for (i = 0; i < numlower; i++) {
> -		mnt = lower[i].layer->mnt;
> -		origin = ovl_decode_fh(fh, mnt);
> +	for (i = 0; i < numlayers; i++) {
> +		origin = ovl_decode_fh(fh, layers[i].mnt);
>  		if (origin)
>  			break;
>  	}
> @@ -321,7 +319,7 @@ static int ovl_check_origin_fh(struct ovl_fh *fh, struct dentry *upperdentry,
>  		dput(origin);
>  		return -ENOMEM;
>  	}
> -	**stackp = (struct ovl_path){.dentry = origin, .layer = lower[i].layer};
> +	**stackp = (struct ovl_path){.dentry = origin, .layer = &layers[i]};
>  
>  	return 0;
>  
> @@ -333,8 +331,7 @@ static int ovl_check_origin_fh(struct ovl_fh *fh, struct dentry *upperdentry,
>  	return -EIO;
>  }
>  
> -static int ovl_check_origin(struct dentry *upperdentry,
> -			    struct ovl_path *lower, unsigned int numlower,
> +static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
>  			    struct ovl_path **stackp, unsigned int *ctrp)
>  {
>  	struct ovl_fh *fh = ovl_get_origin_fh(upperdentry);
> @@ -343,7 +340,8 @@ static int ovl_check_origin(struct dentry *upperdentry,
>  	if (IS_ERR_OR_NULL(fh))
>  		return PTR_ERR(fh);
>  
> -	err = ovl_check_origin_fh(fh, upperdentry, lower, numlower, stackp);
> +	err = ovl_check_origin_fh(fh, upperdentry, ofs->lower_layers,
> +				  ofs->numlower, stackp);
>  	kfree(fh);
>  
>  	if (err) {
> @@ -423,8 +421,7 @@ int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
>   * OVL_XATTR_ORIGIN and that origin file handle can be decoded to lower path.
>   * Return 0 on match, -ESTALE on mismatch or stale origin, < 0 on error.
>   */
> -int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
> -		     unsigned int numlower)
> +int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
>  {
>  	struct ovl_fh *fh = NULL;
>  	size_t len;
> @@ -471,7 +468,8 @@ int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
>  	if (err)
>  		goto fail;
>  
> -	err = ovl_check_origin_fh(fh, index, lower, numlower, &stack);
> +	err = ovl_check_origin_fh(fh, index, ofs->lower_layers,
> +				  ofs->numlower, &stack);
>  	if (err)
>  		goto fail;
>  
> @@ -689,8 +687,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  			 * number - it's the same as if we held a reference
>  			 * to a dentry in lower layer that was moved under us.
>  			 */
> -			err = ovl_check_origin(upperdentry, roe->lowerstack,
> -					       roe->numlower, &stack, &ctr);
> +			err = ovl_check_origin(ofs, upperdentry, &stack, &ctr);
>  			if (err)
>  				goto out_put_upper;
>  		}
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index d1cfa69c98b5..d55afb6646b0 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -251,11 +251,11 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
>  /* namei.c */
>  int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
>  		      bool is_upper, bool set);
> -int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
> -		     unsigned int numlower);
> +int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
>  int ovl_get_index_name(struct dentry *origin, struct qstr *name);
>  int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
> -struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
> +struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> +			  unsigned int flags);
>  bool ovl_lower_positive(struct dentry *dentry);
>  
>  /* readdir.c */
> @@ -267,8 +267,7 @@ void ovl_dir_cache_free(struct inode *inode);
>  int ovl_check_d_type_supported(struct path *realpath);
>  void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
>  			 struct dentry *dentry, int level);
> -int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
> -			 struct ovl_path *lower, unsigned int numlower);
> +int ovl_indexdir_cleanup(struct ovl_fs *ofs);
>  
>  /* inode.c */
>  int ovl_set_nlink_upper(struct dentry *dentry);
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 001c79297bc5..0cdd1ad0b4f6 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -1023,13 +1023,13 @@ void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
>  	}
>  }
>  
> -int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
> -			 struct ovl_path *lower, unsigned int numlower)
> +int ovl_indexdir_cleanup(struct ovl_fs *ofs)
>  {
>  	int err;
> +	struct dentry *indexdir = ofs->indexdir;
>  	struct dentry *index = NULL;
> -	struct inode *dir = dentry->d_inode;
> -	struct path path = { .mnt = mnt, .dentry = dentry };
> +	struct inode *dir = indexdir->d_inode;
> +	struct path path = { .mnt = ofs->upper_mnt, .dentry = indexdir };
>  	LIST_HEAD(list);
>  	struct rb_root root = RB_ROOT;
>  	struct ovl_cache_entry *p;
> @@ -1053,13 +1053,13 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
>  			if (p->len == 2 && p->name[1] == '.')
>  				continue;
>  		}
> -		index = lookup_one_len(p->name, dentry, p->len);
> +		index = lookup_one_len(p->name, indexdir, p->len);
>  		if (IS_ERR(index)) {
>  			err = PTR_ERR(index);
>  			index = NULL;
>  			break;
>  		}
> -		err = ovl_verify_index(index, lower, numlower);
> +		err = ovl_verify_index(ofs, index);
>  		/* Cleanup stale and orphan index entries */
>  		if (err && (err == -ESTALE || err == -ENOENT))
>  			err = ovl_cleanup(dir, index);
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 2b58620eedf0..994d35628acf 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1062,10 +1062,7 @@ static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
>  
>  		/* Cleanup bad/stale/orphan index entries */
>  		if (!err)
> -			err = ovl_indexdir_cleanup(ofs->indexdir,
> -						   ofs->upper_mnt,
> -						   oe->lowerstack,
> -						   oe->numlower);
> +			err = ovl_indexdir_cleanup(ofs);
>  	}
>  	if (err || !ofs->indexdir)
>  		pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

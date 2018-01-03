From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 2/2] nfsd: store stat times in fill_pre_wcc() instead
 of inode times
Date: Wed, 03 Jan 2018 10:41:02 -0500
Message-ID: <1514994062.3458.14.camel@kernel.org>
References: <1514992475-8142-1-git-send-email-amir73il@gmail.com>
         <1514992475-8142-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751290AbeACPlE (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 10:41:04 -0500
In-Reply-To: <1514992475-8142-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, "J . Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, 2018-01-03 at 17:14 +0200, Amir Goldstein wrote:
> The time values in stat and inode may differ for overlayfs and stat time
> values are the correct ones to use. This is also consistent with the fact
> that fill_post_wcc() also stores stat time values.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/nfsd/nfs3xdr.c | 31 ++++++++++++++++++++++++++++++-
>  fs/nfsd/nfs4xdr.c |  2 +-
>  fs/nfsd/nfsfh.h   | 28 ++++++----------------------
>  3 files changed, 37 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
> index 2758480555fa..1a70581e1cb2 100644
> --- a/fs/nfsd/nfs3xdr.c
> +++ b/fs/nfsd/nfs3xdr.c
> @@ -251,6 +251,34 @@ encode_wcc_data(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
>  }
>  
>  /*
> + * Fill in the pre_op attr for the wcc data
> + */
> +void fill_pre_wcc(struct svc_fh *fhp)
> +{
> +	struct inode    *inode;
> +	struct kstat	stat;
> +	__be32 err;
> +
> +	if (fhp->fh_pre_saved)
> +		return;
> +
> +	inode = d_inode(fhp->fh_dentry);
> +	err = fh_getattr(fhp, &stat);
> +	if (err) {
> +		/* Grab the times from inode anyway */
> +		stat.mtime = inode->i_mtime;
> +		stat.ctime = inode->i_ctime;
> +		stat.size  = inode->i_size;
> +	}
> +

Might be best to instead just not supply pre/post op attrs if the
getattr fails? They are technically optional with v3 -- we can just set
the attributes_follow bit to false there.

For v4, it's a little more complicated. Scraping it out of the inode
might be necessary for the cases where we need a change_info4.

Either way, it'd be good to know that these getattrs are failing if this
occurs. Maybe a KERN_WARNING printk or something might be good there?


> +	fhp->fh_pre_mtime = stat.mtime;
> +	fhp->fh_pre_ctime = stat.ctime;
> +	fhp->fh_pre_size  = stat.size;
> +	fhp->fh_pre_change = nfsd4_change_attribute(&stat, inode);
> +	fhp->fh_pre_saved = true;
> +}
> +
> +/*
>   * Fill in the post_op attr for the wcc data
>   */
>  void fill_post_wcc(struct svc_fh *fhp)
> @@ -261,7 +289,8 @@ void fill_post_wcc(struct svc_fh *fhp)
>  		printk("nfsd: inode locked twice during operation.\n");
>  
>  	err = fh_getattr(fhp, &fhp->fh_post_attr);
> -	fhp->fh_post_change = nfsd4_change_attribute(d_inode(fhp->fh_dentry));
> +	fhp->fh_post_change = nfsd4_change_attribute(&fhp->fh_post_attr,
> +						     d_inode(fhp->fh_dentry));
>  	if (err) {
>  		fhp->fh_post_saved = false;
>  		/* Grab the ctime anyway - set_change_info might use it */
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index 2c61c6b8ae09..fbe11ad9b9ff 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -1991,7 +1991,7 @@ static __be32 *encode_change(__be32 *p, struct kstat *stat, struct inode *inode,
>  		*p++ = cpu_to_be32(convert_to_wallclock(exp->cd->flush_time));
>  		*p++ = 0;
>  	} else if (IS_I_VERSION(inode)) {
> -		p = xdr_encode_hyper(p, nfsd4_change_attribute(inode));
> +		p = xdr_encode_hyper(p, nfsd4_change_attribute(stat, inode));
>  	} else {
>  		*p++ = cpu_to_be32(stat->ctime.tv_sec);
>  		*p++ = cpu_to_be32(stat->ctime.tv_nsec);
> diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
> index 43f31cf49bae..99be87b50ebe 100644
> --- a/fs/nfsd/nfsfh.h
> +++ b/fs/nfsd/nfsfh.h
> @@ -252,36 +252,20 @@ fh_clear_wcc(struct svc_fh *fhp)
>   * By using both ctime and the i_version counter we guarantee that as
>   * long as time doesn't go backwards we never reuse an old value.
>   */
> -static inline u64 nfsd4_change_attribute(struct inode *inode)
> +static inline u64 nfsd4_change_attribute(struct kstat *stat,
> +					 struct inode *inode)
>  {
>  	u64 chattr;
>  
> -	chattr =  inode->i_ctime.tv_sec;
> +	chattr =  stat->ctime.tv_sec;
>  	chattr <<= 30;
> -	chattr += inode->i_ctime.tv_nsec;
> +	chattr += stat->ctime.tv_nsec;
>  	chattr += inode->i_version;
>  	return chattr;
>  }
>  
> -/*
> - * Fill in the pre_op attr for the wcc data
> - */
> -static inline void
> -fill_pre_wcc(struct svc_fh *fhp)
> -{
> -	struct inode    *inode;
> -
> -	inode = d_inode(fhp->fh_dentry);
> -	if (!fhp->fh_pre_saved) {
> -		fhp->fh_pre_mtime = inode->i_mtime;
> -		fhp->fh_pre_ctime = inode->i_ctime;
> -		fhp->fh_pre_size  = inode->i_size;
> -		fhp->fh_pre_change = nfsd4_change_attribute(inode);
> -		fhp->fh_pre_saved = true;
> -	}
> -}
> -
> -extern void fill_post_wcc(struct svc_fh *);
> +extern void fill_pre_wcc(struct svc_fh *fhp);
> +extern void fill_post_wcc(struct svc_fh *fhp);
>  #else
>  #define fh_clear_wcc(ignored)
>  #define fill_pre_wcc(ignored)

-- 
Jeff Layton <jlayton@kernel.org>

From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/5] ovl: relax same fs constrain for constant st_ino
Date: Thu, 01 Jun 2017 18:00:45 +0530
Message-ID: <1507928.BJF3V1jpy0@localhost.localdomain>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com> <1496307779-2766-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55139 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751056AbdFAMbg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Jun 2017 08:31:36 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v51CTUSO082049
        for <linux-unionfs@vger.kernel.org>; Thu, 1 Jun 2017 08:31:35 -0400
Received: from e23smtp05.au.ibm.com (e23smtp05.au.ibm.com [202.81.31.147])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2atf4jcknn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Jun 2017 08:31:35 -0400
Received: from localhost
        by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 1 Jun 2017 22:31:21 +1000
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
        by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v51CV7Cx4784406
        for <linux-unionfs@vger.kernel.org>; Thu, 1 Jun 2017 22:31:15 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
        by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v51CUgRr009168
        for <linux-unionfs@vger.kernel.org>; Thu, 1 Jun 2017 22:30:43 +1000
In-Reply-To: <1496307779-2766-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

On Thursday, June 1, 2017 2:32:56 PM IST Amir Goldstein wrote:
> For the case of all layers not on the same fs, use the copy up
> origin st_ino/st_dev for non-dir, if we know it.
> 
> This guarantied constant and persistent st_ino/st_dev for non-dir,
> but not system-wide uniqueness, like in the same fs case.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/inode.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index d613e2c41242..5f285c179bbd 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -65,6 +65,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>  	struct path realpath;
>  	const struct cred *old_cred;
>  	bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
> +	bool samefs = ovl_same_sb(dentry->d_sb);
>  	int err;
> 
>  	type = ovl_path_real(dentry, &realpath);
> @@ -74,16 +75,16 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
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
> +	 *
> +	 * When all layers are on the same fs, all real inode number are
> +	 * unique, so we use the overlay st_dev, which is friendly to du -x.
>  	 */
> -	if (ovl_same_sb(dentry->d_sb)) {
> +	if (!is_dir || samefs) {
>  		if (OVL_TYPE_ORIGIN(type)) {
>  			struct kstat lowerstat;
>  			u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
> @@ -94,7 +95,6 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>  			if (err)
>  				goto out;
> 
> -			WARN_ON_ONCE(stat->dev != lowerstat.dev);
>  			/*
>  			 * Lower hardlinks are broken on copy up to different
>  			 * upper files, so we cannot use the lower origin st_ino
> @@ -102,17 +102,23 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>  			 */
>  			if (is_dir || lowerstat.nlink == 1)
>  				stat->ino = lowerstat.ino;
> +
> +			if (samefs)
> +				WARN_ON_ONCE(stat->dev != lowerstat.dev);
> +			else
> +				stat->dev = lowerstat.dev;
>  		}
> -		stat->dev = dentry->d_sb->s_dev;
> -	} else if (is_dir) {
> +		if (samefs)
> +			stat->dev = dentry->d_sb->s_dev;
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
> 

Hi Amir,

The following question is not directly related to your patch. 

With this patch applied, we have the following code snippet inside
ovl_getattr(),

       if (!is_dir || samefs) {
                if (OVL_TYPE_ORIGIN(type)) {
                        struct kstat lowerstat;
                        u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);

                        ovl_path_lower(dentry, &realpath);
                        err = vfs_getattr(&realpath, &lowerstat,
                                          lowermask, flags);
                        if (err)
                                goto out;

When invoking vfs_getattr() on a non-dir file, the code assumes that the
copy-up origin inode always exists in lowerdir. Are we assuming that after an
overlayfs filesystem has been unmounted, the lower filesystem should never be
manipulated (e.g. deleting the file which was the copy-up origin)? If the
copy-up origin file gets deleted, On a later mount of the overlayfs
filesystem, calls to stat(2) for the corresponding upperdir file will fail
because of vfs_getattr() returning an error code.

-- 
chandan

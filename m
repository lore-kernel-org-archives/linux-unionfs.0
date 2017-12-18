From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3] ovl: Check link ability between upperdir and workdir
Date: Mon, 18 Dec 2017 11:02:51 -0500
Message-ID: <20171218160251.GA7474@redhat.com>
References: <1513601748-57439-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57080 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935396AbdLRQCw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Dec 2017 11:02:52 -0500
Content-Disposition: inline
In-Reply-To: <1513601748-57439-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org

On Mon, Dec 18, 2017 at 08:55:48PM +0800, Chengguang Xu wrote:
> Inspired by encountering unexpected write error when
> upperdir and workdir having different project ids.

Can you please make this problem descrition little better. By
these two lines I really don't understand what's the problem
you are trying to solve. All I understood was that upperdir
and workdir had different project id. But not sure what
problem it led to and why.

In fact your first patch changelong was little better. It
atleast said that you encounter "-EXDEV". So is it rename
which fails. So rename is not allowed between two directories
having different project ids?

Vivek

> So if upper filesystem supports O_TMPFILE, try to check
> link ability between upperdir and workdir and print a
> warning message if check fails.
> The failure of check does not directly lead to read-only
> mounting because in some use cases may only write to
> upperdir and do not modify anything on lowerdirs.
> 
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
> 
> Changes since v2:
> - Add comment about motivation.
> - Modify warning message.
> 
> Changes since v1:
> - Check link ablity between upperdir and workdir instead of checking
> project ids of upperdir and workdir.
> - Print a warning message instead of falling to readonly mode.
> 
>  fs/overlayfs/super.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 76440fe..7d6bd82 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -929,7 +929,7 @@ static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
>  
>  static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>  {
> -	struct dentry *temp;
> +	struct dentry *uppertemp, *worktemp;
>  	int err;
>  
>  	ofs->workdir = ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false);
> @@ -953,12 +953,28 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>  	if (!err)
>  		pr_warn("overlayfs: upper fs needs to support d_type.\n");
>  
> -	/* Check if upper/work fs supports O_TMPFILE */
> -	temp = ovl_do_tmpfile(ofs->workdir, S_IFREG | 0);
> -	ofs->tmpfile = !IS_ERR(temp);
> -	if (ofs->tmpfile)
> -		dput(temp);
> -	else
> +	/*
> +	 * Check if upper/work fs supports O_TMPFILE and if support, check
> +	 * link ability between upperdir and workdir, this is inspired by
> +	 * encountering unexpected write error when upperdir and workdir
> +	 * having different project ids.
> +	 */
> +	uppertemp = ovl_do_tmpfile(ofs->upper_mnt->mnt_root, S_IFREG | 0);
> +	ofs->tmpfile = !IS_ERR(uppertemp);
> +	if (ofs->tmpfile) {
> +		worktemp = ovl_lookup_temp(ofs->workdir);
> +		if (!IS_ERR(worktemp)) {
> +			inode_lock_nested(ofs->workdir->d_inode, I_MUTEX_PARENT);
> +			err = ovl_do_link(uppertemp, ofs->workdir->d_inode, worktemp, true);
> +			inode_unlock(ofs->workdir->d_inode);
> +			if (err)
> +				pr_warn("overlayfs: cannot link files between upperdir and workdir, it may cause write error.\n");
> +			else
> +				ovl_cleanup(ofs->workdir->d_inode, worktemp);
> +			dput(worktemp);
> +		}
> +		dput(uppertemp);
> +	} else
>  		pr_warn("overlayfs: upper fs does not support tmpfile.\n");
>  
>  	/*
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

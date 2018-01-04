From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 02/23] ovl: ignore index mount option when no upper
 layer
Date: Thu, 4 Jan 2018 13:42:20 -0500
Message-ID: <20180104184220.GA6313@redhat.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750990AbeADSmX (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 13:42:23 -0500
Content-Disposition: inline
In-Reply-To: <1515084018-25134-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

On Thu, Jan 04, 2018 at 06:39:57PM +0200, Amir Goldstein wrote:
> For non-upper overlay mount, the value of index mount option is moot.
> When mounter tries to set this mount options, emit a warning and leave
> the value at the default so it won't show up in /proc/mounts.

I am curious, what should show in /proc/mounts. Current code seems to
print this only if it is different from default.

So if detfault is index=on, and user specifies index=off (with no upper),
it should still show in /proc/mounts?

Thanks
Vivek

> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/super.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 5d5e2b39ba69..7e33c83c5a07 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -496,12 +496,18 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  		}
>  	}
>  
> -	/* Workdir is useless in non-upper mount */
> -	if (!config->upperdir && config->workdir) {
> -		pr_info("overlayfs: option \"workdir=%s\" is useless in a non-upper mount, ignore\n",
> -			config->workdir);
> -		kfree(config->workdir);
> -		config->workdir = NULL;
> +	if (!config->upperdir) {
> +		/* Workdir is useless in non-upper mount */
> +		if (config->workdir) {
> +			pr_info("overlayfs: option \"workdir=%s\" is useless in a non-upper mount, ignore\n",
> +				config->workdir);
> +			kfree(config->workdir);
> +			config->workdir = NULL;
> +		}
> +		if (config->index != ovl_index_def) {
> +			pr_info("overlayfs: option \"index\" is useless in a non-upper mount, ignore\n");
> +			config->index = ovl_index_def;
> +		}
>  	}
>  
>  	return ovl_parse_redirect_mode(config, config->redirect_mode);
> @@ -698,7 +704,8 @@ static int ovl_lower_dir(const char *name, struct path *path,
>  	 * The inodes index feature needs to encode and decode file
>  	 * handles, so it requires that all layers support them.
>  	 */
> -	if (ofs->config.index && !ovl_can_decode_fh(path->dentry->d_sb)) {
> +	if (ofs->config.upperdir && ofs->config.index &&
> +	    !ovl_can_decode_fh(path->dentry->d_sb)) {
>  		ofs->config.index = false;
>  		pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off.\n", name);
>  	}
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

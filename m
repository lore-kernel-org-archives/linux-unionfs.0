From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 10/35] ovl: deal with overlay files in ovl_d_real()
Date: Mon, 7 May 2018 09:17:16 -0400
Message-ID: <20180507131716.GA18454@redhat.com>
References: <20180507083807.28792-1-mszeredi@redhat.com>
 <20180507083807.28792-11-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180507083807.28792-11-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, May 07, 2018 at 10:37:42AM +0200, Miklos Szeredi wrote:
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/super.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index e8551c97de51..ad6a5baf226b 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -97,6 +97,10 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>  	struct dentry *real;
>  	int err;
>  
> +	/* It's an overlay file */
> +	if (inode && d_inode(dentry) == inode)
> +		return dentry;
> +

Hi Miklos,

inode == d_inode(dentry) check is being done again in following code. We
probably can get rid of it now.

        if (!d_is_reg(dentry)) {
                if (!inode || inode == d_inode(dentry))
                        return dentry;
                goto bug;
        }

Vivek

>  	if (flags & D_REAL_UPPER)
>  		return ovl_dentry_upper(dentry);
>  
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

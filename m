From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 16/28] ovl: Do not expose metacopy only dentry from
 d_real()
Date: Wed, 30 May 2018 17:05:56 -0400
Message-ID: <20180530210556.GD2717@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
 <20180529144612.16675-17-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144612.16675-17-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 04:46:00PM +0200, Miklos Szeredi wrote:
> From: Vivek Goyal <vgoyal@redhat.com>
> 
> Metacopy dentry/inode is internal to overlay and is never exposed outside
> of it.  Exception is metacopy upper file used for fsync().  Modify d_real()
> to look for dentries/inode which have data, but also allow matching upper
> inode without data for the fsync case.
> 

Hi Miklos,

I am not able to see how in fsync() path d_real() gets called. If we
decide to do fsync() on upper metacopy, then opening upper will not
go through d_real(). And we never issue fsync() on lower.

So I am scratching my head while trying to understand the d_real() and
fsync() connection.

Thanks
Vivek

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/super.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index e0326a686f45..6687d547ec6b 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -101,10 +101,13 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>  	}
>  
>  	real = ovl_dentry_upper(dentry);
> -	if (real && (!inode || inode == d_inode(real)))
> +	if (real && (inode == d_inode(real)))
>  		return real;
>  
> -	real = ovl_dentry_lower(dentry);
> +	if (real && !inode && ovl_has_upperdata(d_inode(dentry)))
> +		return real;
> +
> +	real = ovl_dentry_lowerdata(dentry);
>  	if (!real)
>  		goto bug;
>  
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH V2] ovl: Pass ovl_get_nlink() parameters in right order
Date: Mon, 27 Nov 2017 16:26:12 -0500
Message-ID: <20171127212612.GD22007@redhat.com>
References: <20171127184613.GB22007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56510 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752051AbdK0V0N (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Nov 2017 16:26:13 -0500
Content-Disposition: inline
In-Reply-To: <20171127184613.GB22007@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Nov 27, 2017 at 01:46:13PM -0500, Vivek Goyal wrote:
> Right now we seem to be passing index as "lowerdentry" and origin.dentry
> as "upperdentry". IIUC, we should pass these parameters in reversed order
> and this looks like a bug.
> 

Hi,

Don't merge this patch yet. I think this breaks overlay/042 and does not
cleanup orphan index. Trying to debug it.

Vivek

> Fixes: caf70cb2ba5d ("ovl: cleanup orphan index entries")
> Cc: <stable@vger.kernel.org> #4.13
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 625ed8066570..5ef69bc09e0c 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -435,7 +435,7 @@ int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
>  
>  	/* Check if index is orphan and don't warn before cleaning it */
>  	if (d_inode(index)->i_nlink == 1 &&
> -	    ovl_get_nlink(index, origin.dentry, 0) == 0)
> +	    ovl_get_nlink(origin.dentry, index, 0) == 0)
>  		err = -ENOENT;
>  
>  	dput(origin.dentry);

Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751231AbeEQT0i (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 May 2018 15:26:38 -0400
Date: Thu, 17 May 2018 15:26:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] ovl: copy up files with incompatible xattrs
Message-ID: <20180517192638.GA4979@redhat.com>
References: <20180416143525.8328-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180416143525.8328-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-unionfs@vger.kernel.org, rgoldwyn@suse.com, Fabian Vogt <fvogt@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Apr 16, 2018 at 09:35:25AM -0500, Goldwyn Rodrigues wrote:
> From: Fabian Vogt <fvogt@suse.com>
> 
> xattrs are not guarantees to be compatible across different filesystems.
> Operations which lead to copying of files to the upper layer fail with an
> "Operation not supported" error from the filesystem if a xattr could not be
> written in the upper layer. We can safely ignore "system" xattrs.
> 
> One easy to hit example is using NFS as a read-only lower layer and !NFS as
> upper layer to store changes. Files on NFS can have the "system.nfs4_acl"

I don't know much about nfs4_acl. But name suggests that it stored ACLs
there. So if we ignore these over copy up, does that mean we are not
enforcing ACL policy over copy up. So say some user which was not able
to read a file when it was on lower, might be able to read it after
copy up?

Or I have completely misunderstood it?

Vivek

> xattr set to make the full information available to userspace, but it cannot
> be written to on other filesystems.
> 
> Signed-off-by: Fabian Vogt <fvogt@suse.com>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/overlayfs/copy_up.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index d855f508fa20..e7662e9664be 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -125,6 +125,10 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
>  			continue; /* Discard */
>  		}
>  		error = vfs_setxattr(new, name, value, size, 0);
> +		if (error == -EOPNOTSUPP && strncmp("system.", name, 7) == 0) {
> +			error = 0;
> +			continue; /* Discard */
> +		}
>  		if (error)
>  			break;
>  	}
> -- 
> 2.16.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

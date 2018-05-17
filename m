Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751017AbeEQSkH (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 May 2018 14:40:07 -0400
Subject: Re: [PATCH] ovl: copy up files with incompatible xattrs
References: <20180416143525.8328-1-rgoldwyn@suse.de>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <d5aecf6f-e9c6-e421-5506-8b29945b3160@suse.de>
Date: Thu, 17 May 2018 13:40:02 -0500
MIME-Version: 1.0
In-Reply-To: <20180416143525.8328-1-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: amir73il@gmail.com, linux-unionfs@vger.kernel.org, mszeredi@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

Any comments on this?

On 04/16/2018 09:35 AM, Goldwyn Rodrigues wrote:
> From: Fabian Vogt <fvogt@suse.com>
> 
> xattrs are not guarantees to be compatible across different filesystems.
> Operations which lead to copying of files to the upper layer fail with an
> "Operation not supported" error from the filesystem if a xattr could not be
> written in the upper layer. We can safely ignore "system" xattrs.
> 
> One easy to hit example is using NFS as a read-only lower layer and !NFS as
> upper layer to store changes. Files on NFS can have the "system.nfs4_acl"
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
> 

-- 
Goldwyn

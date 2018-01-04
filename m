From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 1/2] nfsd: encode stat->mtime for getattr instead of
 inode->i_mtime
Date: Thu, 04 Jan 2018 08:11:01 -0500
Message-ID: <1515071461.20282.5.camel@kernel.org>
References: <1514992475-8142-1-git-send-email-amir73il@gmail.com>
         <1514992475-8142-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751827AbeADNLE (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 08:11:04 -0500
In-Reply-To: <1514992475-8142-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, "J . Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, 2018-01-03 at 17:14 +0200, Amir Goldstein wrote:
> The values of stat->mtime and inode->i_mtime may differ for overlayfs
> and stat->mtime is the correct value to use when encoding getattr.
> This is also consistent with the fact that other attr times are also
> encoded from stat values.
> 
> Both callers of lease_get_mtime() already have the value of stat->mtime,
> so the only needed change is that lease_get_mtime() will not overwrite
> this value with inode->i_mtime in case the inode does not have an
> exclusive lease.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/locks.c       | 6 ++----
>  fs/nfsd/nfsxdr.c | 1 +
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 21b4dfa289ee..d6ff4beb70ce 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1554,9 +1554,9 @@ int __break_lease(struct inode *inode, unsigned int mode, unsigned int type)
>  EXPORT_SYMBOL(__break_lease);
>  
>  /**
> - *	lease_get_mtime - get the last modified time of an inode
> + *	lease_get_mtime - update modified time of an inode with exclusive lease
>   *	@inode: the inode
> - *      @time:  pointer to a timespec which will contain the last modified time
> + *      @time:  pointer to a timespec which contains the last modified time
>   *
>   * This is to force NFS clients to flush their caches for files with
>   * exclusive leases.  The justification is that if someone has an
> @@ -1580,8 +1580,6 @@ void lease_get_mtime(struct inode *inode, struct timespec *time)
>  
>  	if (has_lease)
>  		*time = current_time(inode);
> -	else
> -		*time = inode->i_mtime;
>  }
>  
>  EXPORT_SYMBOL(lease_get_mtime);
> diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
> index 644a0342f0e0..79b6064f8977 100644
> --- a/fs/nfsd/nfsxdr.c
> +++ b/fs/nfsd/nfsxdr.c
> @@ -188,6 +188,7 @@ encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
>  	*p++ = htonl((u32) stat->ino);
>  	*p++ = htonl((u32) stat->atime.tv_sec);
>  	*p++ = htonl(stat->atime.tv_nsec ? stat->atime.tv_nsec / 1000 : 0);
> +	time = stat->mtime;
>  	lease_get_mtime(d_inode(dentry), &time); 
>  	*p++ = htonl((u32) time.tv_sec);
>  	*p++ = htonl(time.tv_nsec ? time.tv_nsec / 1000 : 0); 

This looks like a clear improvement. AFAICT, in all cases we pass
lease_get_mtime a value from a previous getattr operation. We should
prefer that one to inode->i_mtime.

The lease_get_mtime prototype is now rather awkward though. It might be
nice to clean that up, eventually, but that can be done later.

Reviewed-by: Jeff Layton <jlayton@kernel.org>

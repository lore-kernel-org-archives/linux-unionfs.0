From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/4] ovl: declare index feature backward compatible
Date: Fri, 10 Nov 2017 09:21:59 -0500
Message-ID: <20171110142159.GB16917@redhat.com>
References: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
 <1508839381-24750-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750987AbdKJOWA (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 09:22:00 -0500
Content-Disposition: inline
In-Reply-To: <1508839381-24750-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

On Tue, Oct 24, 2017 at 01:02:59PM +0300, Amir Goldstein wrote:
> Kconfig description on OVERLAY_FS_INDEX states that "the inodes index
> feature is read-only backward compatible" and that mounting an overlay
> with index enabled, disabled and then enabled again "will have
> unexpected results."
> 
> Commit d1712d8fef03 ("ovl: fix EIO from lookup of non-indexed upper")
> makes the results of this enable/disable/enable maneuver just as
> expected and the results of a plain enable of index feature on existing
> overlay - some hardlinks may have already been broken and new hardlinks
> will not be broken on copy up.
> 
> Now that there is a dedicated config option to opt-in in for backward
> incompatible index feature, remove the backward compatibility clause from
> Kconfig description of OVERLAY_FS_INDEX.

What if user does OVERLAY_FS_INDEX_INCOMPAT=n, then this text is still
relevant?

Vivek
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/Kconfig | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index e5e6dec7d177..02295e10ffbe 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -37,13 +37,6 @@ config OVERLAY_FS_INDEX
>  	  The inodes index feature prevents breaking of lower hardlinks on copy
>  	  up.
>  
> -	  Note, that the inodes index feature is read-only backward compatible.
> -	  That is, mounting an overlay which has an index dir on a kernel that
> -	  doesn't support this feature read-only, will not have any negative
> -	  outcomes.  However, mounting the same overlay with an old kernel
> -	  read-write and then mounting it again with a new kernel, will have
> -	  unexpected results.
> -
>  config OVERLAY_FS_INDEX_INCOMPAT
>  	bool "Overlayfs: support incompatible index feature"
>  	depends on OVERLAY_FS_INDEX
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

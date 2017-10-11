From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/4] overlay: use default overlay mount options
 _overlay_mount_dirs()
Date: Wed, 11 Oct 2017 19:33:31 +0800
Message-ID: <20171011113331.GV10593@eguan.usersys.redhat.com>
References: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
 <1506495852-7295-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751945AbdJKLdd (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2017 07:33:33 -0400
Content-Disposition: inline
In-Reply-To: <1506495852-7295-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Sep 27, 2017 at 10:04:10AM +0300, Amir Goldstein wrote:
> Tests that use _overlay_mount_dirs() should also use the
> default overlay mount options.
> Move mount options from overlay_mount() into _overlay_mount_dirs()
> and use helper common_dev_mount_opts() to get options.
> 
> OVERLAY_MOUNT_OPTIONS is assigned to MOUNT_OPTIONS, so
> there is no need to use OVERLAY_MOUNT_OPTIONS directly.

Agreed, all the fs-specific mount options should be assigned to
MOUNT_OPTIONS in common/config at test init time, if MOUNT_OPTIONS is
not specified. We should always use MOUNT_OPTIONS or TEST_FS_MOUNT_OPTS
in other places.

Thanks,
Eryu

> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> 
> Use common_dev_mount_opts in _overlay_mount_dirs()
> ---
>  common/rc | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 1a61549..b30c4b9 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -342,7 +342,7 @@ _overlay_mount_dirs()
>  	shift 3
>  
>  	$MOUNT_PROG -t overlay -o lowerdir=$lowerdir -o upperdir=$upperdir \
> -		    -o workdir=$workdir $*
> +		    -o workdir=$workdir `_common_dev_mount_options $*`
>  }
>  
>  _overlay_mkdirs()
> @@ -367,9 +367,8 @@ _overlay_mount()
>  
>  	_overlay_mkdirs $dir
>  
> -	_overlay_mount_dirs $dir/$OVL_LOWER $dir/$OVL_UPPER \
> -			    $dir/$OVL_WORK $OVERLAY_MOUNT_OPTIONS \
> -			    $SELINUX_MOUNT_OPTIONS $* $dir $mnt
> +	_overlay_mount_dirs $dir/$OVL_LOWER $dir/$OVL_UPPER $dir/$OVL_WORK \
> +				$* $dir $mnt
>  }
>  
>  _overlay_base_test_mount()
> -- 
> 2.7.4
> 

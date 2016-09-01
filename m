From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] common/rc: introduce _overlay_mount_dirs helper
Date: Thu, 1 Sep 2016 10:16:29 +1000
Message-ID: <20160901001629.GA30056@dastard>
References: <1470741381-32610-1-git-send-email-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:55131 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753880AbcIAAQg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Aug 2016 20:16:36 -0400
Content-Disposition: inline
In-Reply-To: <1470741381-32610-1-git-send-email-eguan@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

On Tue, Aug 09, 2016 at 07:16:20PM +0800, Eryu Guan wrote:
> Introduce a new _overlay_mount_dirs() helper to do the actual
> overlay mount operation and factor _overlay_scratch_mount and
> _overlay_mount code to use a single implemention of
> _overlay_mount_dirs(). Also convert all bare mount of overlay in
> tests to use it.
> 
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  common/rc         | 21 +++++++++++++++------
>  tests/overlay/005 |  6 ++----
>  tests/overlay/010 |  5 ++---
>  3 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index b19b698..6c1c3ff 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -266,6 +266,18 @@ _scratch_mount_options()
>  					$SCRATCH_DEV $SCRATCH_MNT
>  }
>  
> +# helper function to do the actual overlayfs mount operation
> +_overlay_mount_dirs()
> +{
> +	local lowerdir=$1
> +	local upperdir=$2
> +	local workdir=$3
> +	shift 3
> +
> +	$MOUNT_PROG -t overlay -o lowerdir=$lowerdir -o upperdir=$upperdir \
> +		    -o workdir=$workdir $*
> +}
> +
>  # Given a dir, set up 3 subdirectories and mount on the given mnt.
>  # The dir is used as the mount device so it can be seen from df or mount
>  _overlay_mount()
> @@ -293,12 +305,9 @@ _overlay_mount()
>  	mkdir -p $dir/$OVERLAY_LOWER_DIR
>  	mkdir -p $dir/$OVERLAY_WORK_DIR
>  
> -	$MOUNT_PROG -t overlay $SELINUX_MOUNT_OPTIONS \
> -		    -o lowerdir=$dir/$OVERLAY_LOWER_DIR \
> -		    -o upperdir=$dir/$OVERLAY_UPPER_DIR \
> -		    -o workdir=$dir/$OVERLAY_WORK_DIR   \
> -		    $OVERLAY_MOUNT_OPTIONS $* \
> -		    $dir $mnt
> +	_overlay_mount_dirs $dir/$OVERLAY_LOWER_DIR $dir/$OVERLAY_UPPER_DIR \
> +			    $dir/$OVERLAY_WORK_DIR $OVERLAY_MOUNT_OPTIONS $* \
> +			    $dir $mnt

This drops SELINUX_MOUNT_OPTIONS from the mount options. I'd suggest
this option should be moved inside _overlay_mount_dirs() so they are
always applied to overlayfs mounts if set.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

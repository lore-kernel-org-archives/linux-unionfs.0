From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/3] common/rc: add scratch shutdown support for
 overlayfs
Date: Fri, 8 Dec 2017 11:05:45 +1100
Message-ID: <20171208000545.GK5858@dastard>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:16151 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752095AbdLHAHz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Dec 2017 19:07:55 -0500
Content-Disposition: inline
In-Reply-To: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: eguan@redhat.com, amir73il@gmail.com, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

On Thu, Dec 07, 2017 at 10:22:05AM +0800, Chengguang Xu wrote:
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>

Commit message explaining why overlay requires special handling?

> ---
> 
> Changes since v1:
> _scratch_shutdown() does not call notrun.
> 
>  common/rc | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 4c053a5..911dba3 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -382,6 +382,15 @@ _scratch_cycle_mount()
>      _scratch_mount "$opts"
>  }
>  
> +_scratch_shutdown()
> +{
> +	if [ $FSTYP = "overlay" ]; then
> +		src/godown -f $OVL_BASE_SCRATCH_MNT
> +	else
> +		src/godown -f $SCRATCH_MNT
> +	fi
> +}
> +
>  _test_mount()
>  {
>      if [ "$FSTYP" == "overlay" ]; then
> @@ -2908,8 +2917,19 @@ _require_scratch_shutdown()
>  
>  	_scratch_mkfs > /dev/null 2>&1
>  	_scratch_mount
> -	src/godown -f $SCRATCH_MNT 2>&1 \
> -		|| _notrun "$FSTYP does not support shutdown"
> +
> +	if [ $FSTYP = "overlay" ]; then
> +		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
> +			_notrun "$SCRATCH_DEV is not a block device"
> +		else
> +			src/godown -f $OVL_BASE_SCRATCH_MNT 2>&1 \
> +			|| _notrun "Underlying filesystem does not support shutdown"
> +		fi
> +	else
> +		src/godown -f $SCRATCH_MNT 2>&1 \
> +			|| _notrun "$FSTYP does not support shutdown"
> +	fi

Comment explaining why overlay requires special handling.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

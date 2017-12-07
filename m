From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 1/3] common/rc: add scratch shutdown support for
 overlayfs
Date: Thu, 7 Dec 2017 13:31:22 +0800
Message-ID: <20171207053122.GB2749@eguan.usersys.redhat.com>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdLGFbY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Dec 2017 00:31:24 -0500
Content-Disposition: inline
In-Reply-To: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: amir73il@gmail.com, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

On Thu, Dec 07, 2017 at 10:22:05AM +0800, Chengguang Xu wrote:
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>

Thanks a lot for all the revisions!

Better to have some commit log to describe this change.

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

Make "-f" optional? e.g.

	src/godown $* $SCRATCH_MNT

then call could decide if the test want to flush the log on shutdown, by
calling "_scratch_shutdown" or "_scratch_shutdown -f".

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

Better to leave some comments here to describe that we don't want to
shutdown other filesystems accidently.

Thanks,
Eryu

> +		else
> +			src/godown -f $OVL_BASE_SCRATCH_MNT 2>&1 \
> +			|| _notrun "Underlying filesystem does not support shutdown"
> +		fi
> +	else
> +		src/godown -f $SCRATCH_MNT 2>&1 \
> +			|| _notrun "$FSTYP does not support shutdown"
> +	fi
> +
>  	_scratch_unmount
>  }
>  
> -- 
> 1.8.3.1
> 

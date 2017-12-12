From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 1/3] common/rc: add scratch shutdown support for
 overlayfs
Date: Tue, 12 Dec 2017 17:16:22 +0800
Message-ID: <20171212091622.GQ2749@eguan.usersys.redhat.com>
References: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752007AbdLLJQZ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Dec 2017 04:16:25 -0500
Content-Disposition: inline
In-Reply-To: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: amir73il@gmail.com, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

On Tue, Dec 12, 2017 at 11:09:37AM +0800, Chengguang Xu wrote:
> OverlayFS overrides SCRATCH_MNT variable to it's own,
> so adjust target to underlying filesystem(OVL_BASE_SCRATCH_MNT)
> when running shutdown on overlayfs.
> 
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
> 
> Changes since v2:
> 1. Make option for _scratch_shutdown(), so caller can 
> specify option when calling.
> 2. Add comment for why overlay requires special handling.
> 3. Add commit log.
> 
> Changes since v1:
> _scratch_shutdown() does not call notrun.
> 
>  common/rc | 37 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 4c053a5..a5c4ace 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -382,6 +382,24 @@ _scratch_cycle_mount()
>      _scratch_mount "$opts"
>  }
>  
> +_scratch_shutdown()
> +{
> +	if [ $FSTYP = "overlay" ]; then
> +		# In lagacy overlay usage, it may specify directory as 

Trailing whitespace in above line.

> +		# SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
> +		# will be null, so check OVL_BASE_SCRATCH_DEV before
> +		# running shutdown to avoid shutting down base fs accidently.
> +		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
> +			echo -n "Ignore shutdown because "
> +			echo "$SCRATCH_DEV is not a block device"

Hmm, I think a '_fail "<message>"' would be more appropriate here, so
that test fails and exits immediately. Test should call
_require_scratch_shutdown first before calling _scratch_shutdown, if
not, it indicates a useage error of the helper, we need to prompt the
test writer to call _require_scratch_shutdown first in error message.

> +		else
> +			src/godown $* $OVL_BASE_SCRATCH_MNT
> +		fi
> +	else
> +		src/godown $* $SCRATCH_MNT
> +	fi
> +}
> +
>  _test_mount()
>  {
>      if [ "$FSTYP" == "overlay" ]; then
> @@ -2908,8 +2926,23 @@ _require_scratch_shutdown()
>  
>  	_scratch_mkfs > /dev/null 2>&1
>  	_scratch_mount
> -	src/godown -f $SCRATCH_MNT 2>&1 \
> -		|| _notrun "$FSTYP does not support shutdown"
> +
> +	if [ $FSTYP = "overlay" ]; then
> +		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
> +			# In lagacy overlay usage, it may specify directory as 

Trailing whitespace in above line.

> +			# SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
> +			# will be null, so check OVL_BASE_SCRATCH_DEV before
> +			# running shutdown to avoid shutting down base fs accidently.
> +			_notrun "$SCRATCH_DEV is not a block device"
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

Sorry for not bringing this up earlier, but I think we need to convert
all existing direct callers of 'godown' to use this new helper,
otherwise tests will call godown on an overlay merged dir and result in
test failure as:

+/root/xfstests/src/godown: error on xfsctl(GOINGDOWN) of "/mnt/scratch/ovl-mnt": Inappropriate ioctl for device

You can go through all tests in 'shutdown' group in generic dir. But I
noticed that not all tests in 'shutdown' group can be converted to
_scratch_shutdown straightforwardly, e.g. generic/042 and generic/050,
they require $SCRATCH_DEV to be a local device file (either block device
or char device (ubifs uses char device)) rather than a dir or an NFS
export, we need an additional _require rule in both of the tests, so
that they won't run on overlay:

_require_local_device $SCRATCH_DEV

Other tests in 'shutdown' group can be converted easily.

Thanks,
Eryu

>  
> -- 
> 1.8.3.1
> 

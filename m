Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:18044 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726062AbfE2QKP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 May 2019 12:10:15 -0400
Subject: Re: [PATCH v3 2/4] overlay: fix _repair_scratch_fs
References: <20190528151723.12525-1-amir73il@gmail.com>
 <20190528151723.12525-3-amir73il@gmail.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <7cf2a5b5-ab05-ecec-32ef-00c2a401aa12@huawei.com>
Date: Thu, 30 May 2019 00:10:06 +0800
MIME-Version: 1.0
In-Reply-To: <20190528151723.12525-3-amir73il@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On 2019/5/28 23:17, Amir Goldstein Wrote:
> _repair_scratch_fs did not do the right thing for overlay.
> Implement and call _repair_overlay_scratch_fs to repair
> overlay filesystem and then fall through to repair base filesystem.
> 
> The only tests currentrly calling _repair_scratch_fs on a
> ./check -overlay run are generic/330 generic/332 in case the
> base fs supports reflink. The rest of the tests calling
> _repair_scratch_fs require that $SCRATCH_DEV is a block device.
> 
> Suggested-by: zhangyi (F) <yi.zhang@huawei.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/overlay | 17 +++++++++++++++++
>  common/rc      | 13 +++++++++++--
>  2 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/common/overlay b/common/overlay
> index b526f24d..a71c2035 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -320,3 +320,20 @@ _check_overlay_scratch_fs()
>  		"$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT" \
>  		$OVL_BASE_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
>  }
> +
> +_repair_overlay_scratch_fs()
> +{
> +	_overlay_fsck_dirs $OVL_BASE_SCRATCH_MNT/$OVL_LOWER \
> +		$OVL_BASE_SCRATCH_MNT/$OVL_UPPER \
> +		$OVL_BASE_SCRATCH_MNT/$OVL_WORK -y
> +	local res=$?
> +	case $res in
> +	$FSCK_OK|$FSCK_NONDESTRUCT)
> +		res=0
> +		;;
> +	*)
> +		_dump_err2 "fsck.overlay failed, err=$res"
> +		;;
> +	esac
> +	return $res
> +}
> diff --git a/common/rc b/common/rc
> index cedc1cfa..d0aa36a0 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1112,8 +1112,17 @@ _repair_scratch_fs()
>  	return $res
>          ;;
>      *)
> -        # Let's hope fsck -y suffices...
> -        fsck -t $FSTYP -y $SCRATCH_DEV 2>&1
> +	local dev=$SCRATCH_DEV
> +	local fstyp=$FSTYP
> +	if [ $FSTYP = "overlay" -a -n "$OVL_BASE_SCRATCH_DEV" ]; then
> +		_repair_overlay_scratch_fs
> +		# Fall through to repair base fs
> +		dev=$OVL_BASE_SCRATCH_DEV
> +		fstyp=$OVL_BASE_FSTYP
> +		$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT
> +	fi
> +	# Let's hope fsck -y suffices...
> +	fsck -t $fstyp -y $dev 2>&1
>  	local res=$?
>  	case $res in
>  	$FSCK_OK|$FSCK_NONDESTRUCT|$FSCK_REBOOT)
> 

It seems that maybe better to return the error code if one of the two repairs
failed. But the $res is not used now, so it's not a big deal.

Reviewed-by: zhangyi (F) <yi.zhang@huawei.com>

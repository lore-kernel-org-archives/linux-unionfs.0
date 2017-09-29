From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 6/6] overlay: deduplicate code in overlay mount helpers
Date: Fri, 29 Sep 2017 09:44:35 +0800
Message-ID: <20170929014435.GW8034@eguan.usersys.redhat.com>
References: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
 <1506599710-9751-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751082AbdI2Boh (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Sep 2017 21:44:37 -0400
Content-Disposition: inline
In-Reply-To: <1506599710-9751-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Sep 28, 2017 at 02:55:10PM +0300, Amir Goldstein wrote:
> factor out helpers _overlay_base_mount() and _overlay_base_umount()
> to reduce code duplication.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Eryu,
> 
> Appologies for the rolling series, but since you said you are looking
> into re-factoring mount option handling, I figured you may want to take
> this additional cleanup as well.

No problem, thanks for all the work! However, I haven't got some time to
test this patchset yet (but will start testing today), and the mount
option handling seems quite complicated from my quick look last week, I
may need some time to think more about it and play with this patchset.
But it's public holiday next week here in China, I may take more time
than expected :)

Thanks,
Eryu

> 
> Beyond reducing code duplication, this change puts the difference in
> mount options for base test fs and base scratch fs in wrapper functions
> and leaves the common code free of those differences.
> 
> Amir.
> 
>  common/overlay | 66 ++++++++++++++++++++++++++--------------------------------
>  1 file changed, 29 insertions(+), 37 deletions(-)
> 
> diff --git a/common/overlay b/common/overlay
> index c3bb9ee..79097ba 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -53,23 +53,31 @@ _overlay_mount()
>  				$* $dir $mnt
>  }
>  
> -_overlay_base_test_mount()
> +_overlay_base_mount()
>  {
> -	if [ -z "$OVL_BASE_TEST_DEV" -o -z "$OVL_BASE_TEST_DIR" ] || \
> -		_check_mounted_on OVL_BASE_TEST_DEV $OVL_BASE_TEST_DEV \
> -				OVL_BASE_TEST_DIR $OVL_BASE_TEST_DIR
> -	then
> +	local devname=$1
> +	local mntname=$2
> +	local dev=$3
> +	local mnt=$4
> +	shift 4
> +
> +	if [ -z "$dev" -o -z "$mnt" ] || \
> +		_check_mounted_on $devname $dev $mntname $mnt; then
>  		# no base fs or already mounted
>  		return 0
> -	elif [ $? -ne 1 ]
> -	then
> +	elif [ $? -ne 1 ]; then
>  		# base fs mounted but not on mount point
>  		return 1
>  	fi
>  
> -	_mount $TEST_FS_MOUNT_OPTS \
> -		$SELINUX_MOUNT_OPTIONS \
> -		$OVL_BASE_TEST_DEV $OVL_BASE_TEST_DIR
> +	_mount $* $dev $mnt
> +}
> +
> +_overlay_base_test_mount()
> +{
> +	_overlay_base_mount OVL_BASE_TEST_DEV OVL_BASE_TEST_DIR \
> +			"$OVL_BASE_TEST_DEV" "$OVL_BASE_TEST_DIR" \
> +			$TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS
>  }
>  
>  _overlay_test_mount()
> @@ -80,28 +88,9 @@ _overlay_test_mount()
>  
>  _overlay_base_scratch_mount()
>  {
> -	if [ -z "$OVL_BASE_SCRATCH_DEV" -o -z "$OVL_BASE_SCRATCH_MNT" ] || \
> -		_check_mounted_on OVL_BASE_SCRATCH_DEV $OVL_BASE_SCRATCH_DEV \
> -				OVL_BASE_SCRATCH_MNT $OVL_BASE_SCRATCH_MNT
> -	then
> -		# no base fs or already mounted
> -		return 0
> -	elif [ $? -ne 1 ]
> -	then
> -		# base fs mounted but not on mount point
> -		return 1
> -	fi
> -
> -	_mount $OVL_BASE_MOUNT_OPTIONS \
> -		$SELINUX_MOUNT_OPTIONS \
> -		$OVL_BASE_SCRATCH_DEV $OVL_BASE_SCRATCH_MNT
> -}
> -
> -_overlay_base_scratch_unmount()
> -{
> -	[ -n "$OVL_BASE_SCRATCH_DEV" -a -n "$OVL_BASE_SCRATCH_MNT" ] || return 0
> -
> -	$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT
> +	_overlay_base_mount OVL_BASE_SCRATCH_DEV OVL_BASE_SCRATCH_MNT \
> +			"$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT" \
> +			$OVL_BASE_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
>  }
>  
>  _overlay_scratch_mount()
> @@ -110,23 +99,26 @@ _overlay_scratch_mount()
>  		_overlay_mount $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
>  }
>  
> -_overlay_base_test_unmount()
> +_overlay_base_unmount()
>  {
> -	[ -n "$OVL_BASE_TEST_DEV" -a -n "$OVL_BASE_TEST_DIR" ] || return 0
> +	local dev=$1
> +	local mnt=$2
> +
> +	[ -n "$dev" -a -n "$mnt" ] || return 0
>  
> -	$UMOUNT_PROG $OVL_BASE_TEST_DIR
> +	$UMOUNT_PROG $mnt
>  }
>  
>  _overlay_test_unmount()
>  {
>  	$UMOUNT_PROG $TEST_DIR
> -	_overlay_base_test_unmount
> +	_overlay_base_unmount "$OVL_BASE_TEST_DEV" "$OVL_BASE_TEST_DIR"
>  }
>  
>  _overlay_scratch_unmount()
>  {
>  	$UMOUNT_PROG $SCRATCH_MNT
> -	_overlay_base_scratch_unmount
> +	_overlay_base_unmount "$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT"
>  }
>  
>  # Require a specific overlayfs feature
> -- 
> 2.7.4
> 

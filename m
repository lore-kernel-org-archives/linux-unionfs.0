Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Mon, 26 Feb 2018 22:51:01 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [xfstests PATCH v4 2/5] overlay: hook filesystem check helper
Message-ID: <20180226145101.GB6209@localhost.localdomain>
References: <20180222021834.26145-1-yi.zhang@huawei.com>
 <20180222021834.26145-3-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180222021834.26145-3-yi.zhang@huawei.com>
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: eguan@redhat.com, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi zhangyi,

I was testing v4 patchset with various overlay configs and results all
look good, thanks! But I found more minor issues that can be improved.

On Thu, Feb 22, 2018 at 10:18:31AM +0800, zhangyi (F) wrote:
> Hook filesystem check helper to _check_test_fs and _check_scratch_fs for
> constants underlying dirs of overlay filesystem, and introduce scratch

"for constants underlying..." looks confusing, do you mean

... for checking consistency of underlying dirs of overlay filesystem

?

> check helpers for optionally lower/upper/work dirs. These helpers works

I'm not sure I understand what "optionally" means here..

> only if fsck.overlay exists.
> 
> This patch introduce OVERLAY_FSCK_OPTIONS use for check overlayfs like
> OVERLAY_MOUNT_OPTIONS, and also introduce a mount point check helper in
> common/rc to detect a dir is a mount point or not.
> 
> [ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  README.overlay |  10 ++++-
>  common/config  |   4 ++
>  common/overlay | 125 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc      |  18 ++++++++-
>  4 files changed, 153 insertions(+), 4 deletions(-)
> 
> diff --git a/README.overlay b/README.overlay
> index dfb8234..9feaa6a 100644
> --- a/README.overlay
> +++ b/README.overlay
> @@ -22,6 +22,10 @@ the base fs should be pre-formatted before starting the -overlay run.
>  An easy way to accomplish this is by running './check <some test>' once,
>  before running './check -overlay'.
>  
> +'./check -overlay' support check overlay test and scratch dirs,
> +OVERLAY_FSCK_OPTIONS should be set instead of FSCK_OPTIONS if fsck
> +options need to given directly.
> +
>  Because of the lack of mkfs support, multi-section config files are only
>  partly supported with './check -overlay'. Only multi-section files that
>  do not change FSTYP and MKFS_OPTIONS can be safely used with -overlay.
> @@ -40,7 +44,9 @@ run overlay tests on the same base fs, but with different mount options:
>   MOUNT_OPTIONS="-o pquota"
>   TEST_FS_MOUNT_OPTS="-o noatime"
>   OVERLAY_MOUNT_OPTIONS="-o redirect_dir=off"
> + OVERLAY_FSCK_OPTIONS="-n"
>  
>  In the example above, MOUNT_OPTIONS will be used to mount the base scratch fs,
> -TEST_FS_MOUNT_OPTS will be used to mount the base test fs and
> -OVERLAY_MOUNT_OPTIONS will be used to mount both test and scratch overlays.
> +TEST_FS_MOUNT_OPTS will be used to mount the base test fs,
> +OVERLAY_MOUNT_OPTIONS will be used to mount both test and scratch overlay and
> +OVERLAY_FSCK_OPTIONS will be used to check both test and scratch overlay.
> diff --git a/common/config b/common/config
> index 71115bd..20f0e5f 100644
> --- a/common/config
> +++ b/common/config
> @@ -566,6 +566,10 @@ _overlay_config_override()
>  	# Set SCRATCH vars to overlay base and mount dirs inside base fs
>  	export SCRATCH_DEV="$OVL_BASE_SCRATCH_MNT"
>  	export SCRATCH_MNT="$OVL_BASE_SCRATCH_MNT/$OVL_MNT"
> +
> +	# Set fsck options, use default if user not set directly.
> +	export FSCK_OPTIONS="$OVERLAY_FSCK_OPTIONS"
> +	[ -z "$FSCK_OPTIONS" ] && _fsck_opts
>  }
>  
>  _overlay_config_restore()
> diff --git a/common/overlay b/common/overlay
> index a8b0e93..29f9bf8 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -190,3 +190,128 @@ _overlay_fsck_dirs()
>  	$FSCK_OVERLAY_PROG -o lowerdir=$lowerdir -o upperdir=$upperdir \
>  			   -o workdir=$workdir $*
>  }
> +
> +_overlay_check_dirs()
> +{
> +	local lowerdir=$1
> +	local upperdir=$2
> +	local workdir=$3
> +	local err=0
> +
> +	_overlay_fsck_dirs $* $FSCK_OPTIONS >>$tmp.fsck 2>&1
> +	if [ $? -ne 0 ]; then
> +		_log_err "_overlay_check_fs: overlayfs on $lowerdir,$upperdir,$workdir is inconsistent"
> +
> +		echo "*** fsck.overlay output ***"	>>$seqres.full
> +		cat $tmp.fsck				>>$seqres.full
> +		echo "*** end fsck.overlay output"	>>$seqres.full
> +
> +		echo "*** mount output ***"		>>$seqres.full
> +		_mount					>>$seqres.full
> +		echo "*** end mount output"		>>$seqres.full
> +
> +		err=1
> +	fi
> +	rm -f $tmp.fsck
> +
> +	return $err
> +}
> +
> +# Check the same mnt/dev of _check_overlay_scratch_fs, but check
> +# optionally lower/upper/work dirs of overlay filesystem, such as
> +# multiple lower layers.

These comments look confusing to me too. I think you mean
_overlay_check_scratch_dirs is similar to _check_overlay_scratch_fs, but
it needs lower/upper/work dirs provided as arguments, it's useful for
non-default setups such as multiple lower layers.

> +_overlay_check_scratch_dirs()

I don't think we need it either (sorry I missed it in previous reviews),
just call _overlay_check_dirs directly with proper arguments in patch
5/5 (and umount first if necessary). We already have many helpers for
checking overlayfs, this one just makes it more confusing.

(At least this helper should be introduced in patch 5/5, along with its
first usage.)

Thanks,
Eryu

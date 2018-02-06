From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests PATCH v2 2/5] overlay: hook filesystem check helper
Date: Tue, 6 Feb 2018 23:53:25 +0800
Message-ID: <20180206155325.GS18267@eguan.usersys.redhat.com>
References: <20180131102759.40997-1-yi.zhang@huawei.com>
 <20180131102759.40997-3-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43280 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751424AbeBFPx2 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Feb 2018 10:53:28 -0500
Content-Disposition: inline
In-Reply-To: <20180131102759.40997-3-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com, yangerkun@huawei.com

On Wed, Jan 31, 2018 at 06:27:56PM +0800, zhangyi (F) wrote:
> Hook filesystem check helper to _check_test_fs and _check_scratch_fs for
> constants underlying dirs of overlay filesystem, and introduce scratch
> check helpers for optionally lower/upper/work dirs. These helpers works
> only if fsck.overlay exists.
> 
> [ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  common/overlay | 128 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc      |   4 +-
>  2 files changed, 130 insertions(+), 2 deletions(-)
> 
> diff --git a/common/overlay b/common/overlay
> index d741a7e..0e45ddd 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -152,6 +152,14 @@ _require_scratch_overlay_feature()
>  	_scratch_unmount
>  }
>  
> +# Require the same scratch device as _require_scratch, but do not check
> +# the constants OVL_LOWER/OVL_UPPER/OVL_WORK dirs, should use together
> +# with optionally lower/upper/work dirs and do check explicitly after test.
> +_require_overlay_scratch_dirs()
> +{
> +	_require_scratch_nocheck
> +}
> +

After looking at previous review comments, I know that this new function
was suggested by Amir, but I don't think we really need it, IMHO it just
adds another layer and complexity (sorry again on the late review..).
I'd just call _require_scratch_nocheck in tests with proper comments (as
we use multiple lower layers and the default _check_overlay_scratch_fs
just can't handle it).

>  # Helper function to check underlying dirs of overlay filesystem
>  _overlay_fsck_dirs()
>  {
> @@ -165,3 +173,123 @@ _overlay_fsck_dirs()
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
> +# Check the same mnt/dev of _check_overlay_scratch_fs, but check optionally
> +# lower/upper/work dirs of overlay filesystem, should use together with
> +# _require_overlay_scratch_dirs

So the last sentence of above comments made me confused, why should we
use it together with _require_overlay_scratch_dirs and how? That's my
first impression reading these comments..

> +_overlay_check_scratch_dirs()
> +{
> +	local lowerdir=$1
> +	local upperdir=$2
> +	local workdir=$3
> +	shift 3
> +
> +	# Need to umount overlay for scratch dir check
> +	local ovl_mounted=`_is_mounted $SCRATCH_MNT`
> +	[ -z "$ovl_mounted" ] || $UMOUNT_PROG $SCRATCH_MNT
> +
> +	# Check dirs with extra overlay options
> +	_overlay_check_dirs $lowerdir $upperdir $workdir $*
> +	local ret=$?
> +
> +	if [ $ret -eq 0 -a -n "$ovl_mounted" ]; then
> +		# overlay was mounted, remount with extra mount options
> +		_overlay_scratch_mount_dirs $lowerdir $upperdir \
> +					    $workdir $*
> +		ret=$?
> +	fi
> +
> +	return $ret
> +}
> +
> +_overlay_check_fs()
> +{
> +	# Aligns arguments for _overlay_base_mount
> +	local ovl_mnt=$1
> +	shift 1
> +
> +	local base_dev=$3
> +	local base_mnt=$4

I think we need more comments on the arguments.

> +
> +	[ "$FSTYP" = overlay ] || return 0
> +
> +	# Base fs needs to be mounted to check overlay dirs
> +	local base_fstype=""
> +	local ovl_mounted=""
> +
> +	[ -z "$base_dev" ] || \
> +		base_fstype=`_fs_type $base_dev`
> +
> +	# If base fstype is set, base fs is mounted, mount otherwise

This comment is not clear enough, I think it's better to explain why we
do things differently here not what we do in the code.

> +	if [ -z "$base_fstype" ]; then

Need to check if "$base_dev" is empty or not, i.e. if we're using legacy
overlay setup or overlay with base devices:

	if [ -n "$base_dev" -a -z "$base_fstype" ]; then

Otherwise we call into _overlay_base_mount wrongly here when testing
with legacy overlay setup, and check prints weired messages (because
$base_dev is empty):

...
OVL_BASE_TEST_DEV=/mnt/ovl/test is mounted but not on OVL_BASE_TEST_DIR=-o - aborting
Already mounted result:
/mnt/ovl/test /mnt/testarea/test
overlay/006 1s ... 0s
OVL_BASE_SCRATCH_DEV=/mnt/ovl/scratch is mounted but not on OVL_BASE_SCRATCH_MNT=-o - aborting
Already mounted result:
/mnt/ovl/scratch /mnt/testarea/scratch
Ran: overlay/006
Passed all 1 tests

> +		_overlay_base_mount $*
> +	else
> +		# Need to umount overlay for dir check
> +		ovl_mounted=`_is_mounted $ovl_mnt`
> +		[ -z "$ovl_mounted" ] || $UMOUNT_PROG $ovl_mnt
> +	fi
> +
> +	_overlay_check_dirs $base_mnt/$OVL_LOWER $base_mnt/$OVL_UPPER \
> +			    $base_mnt/$OVL_WORK
> +	local ret=$?
> +
> +	if [ -z "$base_fstype" ]; then
> +		_overlay_base_unmount "$base_dev" "$base_mnt"

Looks like we need to check $base_dev too here.

> +	elif [ $ret -eq 0 -a -n "$ovl_mounted" ]; then
> +		# overlay was mounted, remount besides extra mount options
> +		_overlay_mount $base_mnt $ovl_mnt
> +		ret=$?
> +	fi
> +
> +	if [ $ret != 0 ]; then
> +		status=1
> +		if [ "$iam" != "check" ]; then
> +			exit 1
> +		fi
> +		return 1
> +	fi
> +
> +	return 0
> +}
> +
> +_check_overlay_test_fs()
> +{
> +	_overlay_check_fs "$TEST_DIR" \
> +		OVL_BASE_TEST_DEV OVL_BASE_TEST_DIR \
> +		"$OVL_BASE_TEST_DEV" "$OVL_BASE_TEST_DIR" \
> +		$TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS

Using $TEST_FS_MOUNT_OPTS doesn't look correct to me, the mount options
provided here are meant for mounting base test device, and
TEST_FS_MOUNT_OPTS is meant for mounting overlay. (I know that you're
copying from _overlay_base_test_mount(), and I think that's a bug in the
existing code.)

The problem is that both TEST_FS_MOUNT_OPTS and MOUNT_OPTIONS should be
set to OVERLAY_MOUNT_OPTIONS if it's not empty. But currently only
MOUNT_OPTIONS is set in common/config::_mount_opts, TEST_FS_MOUNT_OPTS
isn't set in common/config::_test_mount_opts.

But, as mentioned above, this is a different issue, using
OVL_BASE_MOUNT_OPTIONS for both _check_overlay_test|scratch_fs should be
fine for now. But if you can fix the bug too in next version of this
patchset, it'd be great!

Thanks,
Eryu

> +}
> +
> +_check_overlay_scratch_fs()
> +{
> +	_overlay_check_fs "$SCRATCH_MNT" \
> +		OVL_BASE_SCRATCH_DEV OVL_BASE_SCRATCH_MNT \
> +		"$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT" \
> +		$OVL_BASE_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
> +}
> diff --git a/common/rc b/common/rc
> index 3351f00..7b84bb5 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2585,7 +2585,7 @@ _check_test_fs()
>  	# no way to check consistency for GlusterFS
>  	;;
>      overlay)
> -	# no way to check consistency for overlay
> +	_check_overlay_test_fs
>  	;;
>      pvfs2)
>  	;;
> @@ -2643,7 +2643,7 @@ _check_scratch_fs()
>  	# no way to check consistency for GlusterFS
>  	;;
>      overlay)
> -	# no way to check consistency for overlay
> +	_check_overlay_scratch_fs
>  	;;
>      pvfs2)
>  	;;
> -- 
> 2.5.0
> 

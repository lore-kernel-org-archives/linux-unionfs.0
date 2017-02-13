From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 1/9] fstests: sanity check that test partitions are
 not mounted elsewhere
Date: Mon, 13 Feb 2017 19:10:53 +0800
Message-ID: <20170213111053.GF24562@eguan.usersys.redhat.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <1486932224-17075-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752287AbdBMLKz (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Feb 2017 06:10:55 -0500
Content-Disposition: inline
In-Reply-To: <1486932224-17075-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Sun, Feb 12, 2017 at 10:43:36PM +0200, Amir Goldstein wrote:
> When $TEST_DEV is mounted at a different location then $TEST_DIR,
> _require_test() aborts the test with an error:
>  TEST_DEV=/dev/sda5 is mounted but not on TEST_DIR=/mnt/test
> 
> There are several problems with current sanity check:
> 1. the output of the error is mixed into out.bad and hard to see
> 2. the test partition is unmounted at the end of the test regardless
>    of the fact that it not pass the sanity that we have exclusivity
> 3. scratch partition has a similar sanity check in _require_scratch(),
>    but we may not get to it, because $SCRATCH_DEV is unmounted prior
>    to running the tests (which could unmount another mount point).
> 
> To solve all these problems, introduce a helper _check_mounted_on().
> It checks if a device is mounted on a given mount point and optionally
> checks the mounted fs type.
> 
> The sanity checks in _require_scratch() and _require_test() are
> converted to use the helper and gain the check for correct fs type.
> 
> The helper is used in init_rc() to sanity check both test and scratch
> partitions, before tests are run and before $SCRATCH_DEV is unmounted.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/rc | 83 +++++++++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 49 insertions(+), 34 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 76515e2..d831b17 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1319,6 +1319,43 @@ _supported_os()
>      _notrun "not suitable for this OS: $HOSTOS"
>  }
>  
> +# check if a FS on a device is mounted
> +# if so, verify that it is mounted on mount point
> +# if fstype is given as argument, verify that it is also
> +# mounted with correct fs type
> +#
> +_check_mounted_on()
> +{
> +	local devname=$1
> +	local dev=$2
> +	local mntname=$3
> +	local mnt=$4
> +	local type=$5
> +
> +	# Note that we use -F here so grep doesn't try to interpret an NFS over
> +	# IPv6 server as a regular expression
> +	local mount_rec=`_mount | grep -F "$dev"`
> +	[ -n "$mount_rec" ] || return 1
> +
> +	# if it's mounted, make sure its on $mnt
> +	if ! (echo $mount_rec | grep -q "$mnt")
> +	then
> +		echo "$devname=$dev is mounted but not on $mntname=$mnt - aborting"
> +		echo "Already mounted result:"
> +		echo $mount_rec
> +		exit 1
> +	fi
> +
> +	if [ -n "$type" -a "`_fs_type $dev`" != "$type" ]
> +	then
> +		echo "$devname=$dev is mounted but not a type $type filesystem"
> +		# raw $DF_PROG cannot handle NFS/CIFS/overlay correctly
> +		_df_device $dev
> +		exit 1
> +	fi
> +	return 0
> +}
> +
>  # this test needs a scratch partition - check we're ok & unmount it
>  # No post-test check of the device is required. e.g. the test intentionally
>  # finishes the test with the filesystem in a corrupt state
> @@ -1373,21 +1410,9 @@ _require_scratch_nocheck()
>  		 ;;
>      esac
>  
> -    # mounted?
> -    # Note that we use -F here so grep doesn't try to interpret an NFS over
> -    # IPv6 server as a regular expression.
> -    mount_rec=`_mount | grep -F $SCRATCH_DEV`
> -    if [ "$mount_rec" ]
> +    if _check_mounted_on SCRATCH_DEV $SCRATCH_DEV SCRATCH_MNT $SCRATCH_MNT
>      then
> -        # if it's mounted, make sure its on $SCRATCH_MNT
> -        if ! echo $mount_rec | grep -q $SCRATCH_MNT
> -        then
> -            echo "\$SCRATCH_DEV=$SCRATCH_DEV is mounted but not on \$SCRATCH_MNT=$SCRATCH_MNT - aborting"
> -            echo "Already mounted result:"
> -            echo $mount_rec
> -            exit 1
> -        fi
> -        # and then unmount it
> +        # if it's mounted, unmount it
>          if ! _scratch_unmount
>          then
>              echo "failed to unmount $SCRATCH_DEV"
> @@ -1458,21 +1483,8 @@ _require_test()
>  		 ;;
>      esac
>  
> -    # mounted?
> -    # Note that we use -F here so grep doesn't try to interpret an NFS over
> -    # IPv6 server as a regular expression.
> -    mount_rec=`_mount | grep -F $TEST_DEV`
> -    if [ "$mount_rec" ]
> +    if ! _check_mounted_on TEST_DEV $TEST_DEV TEST_DIR $TEST_DIR
>      then
> -        # if it's mounted, make sure its on $TEST_DIR
> -        if ! echo $mount_rec | grep -q $TEST_DIR
> -        then
> -            echo "\$TEST_DEV=$TEST_DEV is mounted but not on \$TEST_DIR=$TEST_DIR - aborting"
> -            echo "Already mounted result:"
> -            echo $mount_rec
> -            exit 1
> -        fi
> -    else
>  	out=`_mount_or_remount_rw "$MOUNT_OPTIONS" $TEST_DEV $TEST_DIR`
>  	if [ $? -ne 1 ]; then
>  		echo $out
> @@ -3075,13 +3087,16 @@ init_rc()
>  		fi
>  	fi
>  
> -	if [ "`_fs_type $TEST_DEV`" != "$FSTYP" ]
> -	then
> -		echo "common/rc: Error: \$TEST_DEV ($TEST_DEV) is not a MOUNTED $FSTYP filesystem"
> -		# raw $DF_PROG cannot handle NFS/CIFS/overlay correctly
> -		_df_device $TEST_DEV
> -		exit 1
> +	# Sanity check that TEST partition is not mounted at another mount point
> +	# or as another fs type
> +	_check_mounted_on TEST_DEV $TEST_DEV TEST_DIR $TEST_DIR $FSTYP
> +	if [ -n "$SCRATCH_DEV" ]; then
> +		# Sanity check that SCRATCH partition is not mounted at another
> +		# mount point, because it is about to be unmounted and formatted.
> +		# Another fs type for scratch is fine (bye bye old fs type).
> +		_check_mounted_on SCRATCH_DEV $SCRATCH_DEV SCRATCH_MNT $SCRATCH_MNT
>  	fi

My test configs look like:

TEST_DEV=/dev/sda5
SCRATCH_DEV=/dev/sda6
TEST_DIR=/mnt/testarea/test
SCRATCH_MNT=/mnt/testarea/scratch

and if I mount SCRATCH_DEV at /mnt/xfs (or some other mountpoints rather
than SCRATCH_MNT), ./check -overlay overlay/??? isn't able to detect
this mis-configuration.

[root@dhcp-66-86-11 xfstests]# ./check  -overlay overlay/002
FSTYP         -- overlay
PLATFORM      -- Linux/x86_64 dhcp-66-86-11 4.10.0-rc7
MKFS_OPTIONS  -- /mnt/testarea/scratch
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 -o lowerdir=/mnt/testarea/scratch/ovl-lower,upperdir=/mnt/testarea/scratch/ovl-upper,workdir=/mnt/testarea/scratch/ovl-work

[root@dhcp-66-86-11 xfstests]#

And nothing useful was printed. This is because my rootfs has no
filetype support, but the _notrun message is redirected to a file in
check, as

"if ! _scratch_mkfs >$tmp.err 2>&1"

Adding _check_mounted_on against OVL_BASE_TEST/SCRATCH_DEV here could
fix it for me.

Thanks,
Eryu

> +
>  	# Figure out if we need to add -F ("foreign", deprecated) option to xfs_io
>  	$XFS_IO_PROG -c stat $TEST_DIR 2>&1 | grep -q "is not on an XFS filesystem" && \
>  		export XFS_IO_PROG="$XFS_IO_PROG -F"
> -- 
> 2.7.4
> 

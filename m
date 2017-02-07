From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 3/3] overlay: mount/unmount base fs before/after
 running tests
Date: Tue, 7 Feb 2017 20:47:12 +0800
Message-ID: <20170207124712.GL1859@eguan.usersys.redhat.com>
References: <1485507365-29012-1-git-send-email-amir73il@gmail.com>
 <1485507365-29012-4-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485507365-29012-4-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jan 27, 2017 at 10:56:05AM +0200, Amir Goldstein wrote:
> Optionally configure TEST/SCRATCH_BASE_DEV, for overlay base fs
> to be mounted/unmounted before/after running tests. For example:
> 
> +export TEST_BASE_DEV=/dev/mapper/base-test
> export TEST_BASE_MNT=/mnt/base/test
> +export SCRATCH_BASE_DEV=/dev/mapper/base-scratch
> export SCRATCH_BASE_MNT=/mnt/base/scratch
> export TEST_DIR=/mnt/test
> export SCRATCH_MNT=/mnt/scratch
> export FSTYP=overlay
> 
> With this change, the base fs is mounted before running tests,
> unmounted after running tests and recycled on _test_cycle_mount
> along with the overlay mounts.
> This helps catching overlayfs bugs related to leaking objects in
> underlying (base) fs.
> 
> The standard way that overlay tests work is:
> - _scratch_mkfs
> - setup lower/upper dir files
> - _scratch_mount (or custom overlay mount)
> - (sometimes) _scratch_unmount/_scratch_mount recycle
> 
> To preserve expected tests behavior, the semantics are:
> - _scratch_mkfs mounts the base fs, cleans the lower/upper dirs and
>   keeps base fs mounted.
> - _scratch_mount mounts or recycles base fs and mounts overlay
> - _scratch_unmount unmounts overlay and base fs

I think we should do some validation on *_BASE_DEV first, to see if they
could be mounted; if they're mounted already, check if they're mounted
at the expected place (*_BASE_MNT). Otherwise I see test failures, which
are hard to tell which part went wrong just from the failure diff
message.

e.g. I tried clearing filesystem signatures (wipefs -a), mounting
SCRATCH_BASE_DEV to other random dirs, I saw failures like:

overlay/002 1s ... [failed, exit status 1] - output mismatch (see /root/workspace/xfstests/results//overlay/002.out.bad)
    --- tests/overlay/002.out   2016-07-01 23:17:01.029000000 +0800
    +++ /root/workspace/xfstests/results//overlay/002.out.bad   2017-02-07 18:47:22.425000000 +0800
    @@ -1,3 +1,3 @@
     QA output created by 002
    -wrote 65536/65536 bytes at offset 0
    -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    +umount: /mnt/ovl/scratch: not mounted
    +failed to unmount /mnt/ovl/scratch/ovl
    ...
    (Run 'diff -u tests/overlay/002.out /root/workspace/xfstests/results//overlay/002.out.bad'  to see the entire diff)
overlay/003 1s ... - output mismatch (see /root/workspace/xfstests/results//overlay/003.out.bad)
    --- tests/overlay/003.out   2016-07-01 23:17:01.029000000 +0800
    +++ /root/workspace/xfstests/results//overlay/003.out.bad   2017-02-07 18:47:23.041000000 +0800
    @@ -1,2 +1,12 @@
     QA output created by 003
    +mount: wrong fs type, bad option, bad superblock on /dev/sda6,
    +       missing codepage or helper program, or other error
    +
    +       In some cases useful info is found in syslog - try
    +       dmesg | tail or so.
    +mount: wrong fs type, bad option, bad superblock on /dev/sda6,
    ...
    (Run 'diff -u tests/overlay/003.out /root/workspace/xfstests/results//overlay/003.out.bad'  to see the entire diff)

And since overlayfs configuration is going to be a bit more complex
after this patchset, can you please update README to document overlayfs
test as well? (Sorry, I forgot to write doc when I introduced overlayfs
support..)

Thanks a lot for all your effort!

Eryu

> 
> Tests that use _scratch_unmount to unmount a custom overlay mount
> and expect to have access to overlay base dir, were converted to use
> explicit umount $SCRATCH_MNT instead.
> ---
>  common/config     |  6 +++++-
>  common/rc         | 42 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/003 |  3 ++-
>  tests/overlay/004 |  3 ++-
>  tests/overlay/014 |  5 +++--
>  5 files changed, 54 insertions(+), 5 deletions(-)
> 
> diff --git a/common/config b/common/config
> index db5721c..f431a8d 100644
> --- a/common/config
> +++ b/common/config
> @@ -35,7 +35,9 @@
>  # RMT_TAPE_DEV -    the remote tape device for the xfsdump tests
>  # RMT_IRIXTAPE_DEV- the IRIX remote tape device for the xfsdump tests
>  # RMT_TAPE_USER -   remote user for tape device
> +# TEST_BASE_DEV -   device for base fs containing overlay test dirs
>  # TEST_BASE_MNT -   mount point for base fs of overlay test dirs
> +# SCRATCH_BASE_DEV- device for base fs containing overlay scratch dirs
>  # SCRATCH_BASE_MNT- mount point for base fs of overlay scratch dirs
>  #
>  # - These can be added to $HOST_CONFIG_DIR (witch default to ./config)
> @@ -470,11 +472,12 @@ _config_overlay()
>  	[ -z "$TEST_DEV" ] || export TEST_BASE_DIR="$TEST_DEV"
>  	[ -z "$SCRATCH_DEV" ] || export SCRATCH_BASE_DIR="$SCRATCH_DEV"
>  
> -	# 2. set SCRATCH/TEST_BASE_MNT to configure base fs.
> +	# 2. set SCRATCH/TEST_BASE_DEV/MNT to configure base fs.
>  	#    SCRATCH/TEST_DEV are derived from SCRATCH/TEST_BASE_MNT
>  	#    and therein, overlay fs directories will be created.
>  	[ -n "$TEST_BASE_MNT" ] || return
>  
> +	_check_device TEST_BASE_DEV optional $TEST_BASE_DEV
>  	if [ ! -d "$TEST_BASE_MNT" ]; then
>  		echo "common/config: Error: \$TEST_BASE_MNT ($TEST_BASE_MNT) is not a directory"
>  		exit 1
> @@ -486,6 +489,7 @@ _config_overlay()
>  
>  	[ -n "$SCRATCH_BASE_MNT" ] || return
>  
> +	_check_device SCRATCH_BASE_DEV optional $SCRATCH_BASE_DEV
>  	if [ ! -d "$SCRATCH_BASE_MNT" ]; then
>  		echo "common/config: Error: \$SCRATCH_BASE_MNT ($SCRATCH_BASE_MNT) is not a directory"
>  		exit 1
> diff --git a/common/rc b/common/rc
> index f5ab869..5033ed4 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -320,24 +320,62 @@ _overlay_mount()
>  			    $SELINUX_MOUNT_OPTIONS $* $dir $mnt
>  }
>  
> +_overlay_test_base_mount()
> +{
> +	if [ -n "$TEST_BASE_DEV" -a -n "$TEST_BASE_MNT" ]; then
> +		_mount $TEST_BASE_MOUNT_OPTIONS \
> +			$SELINUX_MOUNT_OPTIONS \
> +			$TEST_BASE_DEV $TEST_BASE_MNT
> +	fi
> +}
> +
>  _overlay_test_mount()
>  {
> +	_overlay_test_base_mount
>  	_overlay_mount $TEST_BASE_DIR $TEST_DIR $*
>  }
>  
> +_overlay_scratch_base_mount()
> +{
> +	if [ -n "$SCRATCH_BASE_DEV" -a -n "$SCRATCH_BASE_MNT" ]; then
> +		_mount $SCRATCH_BASE_MOUNT_OPTIONS \
> +			$SELINUX_MOUNT_OPTIONS \
> +			$SCRATCH_BASE_DEV $SCRATCH_BASE_MNT
> +	fi
> +}
> +
> +_overlay_scratch_base_unmount()
> +{
> +	if [ -n "$SCRATCH_BASE_DEV" -a -n "$SCRATCH_BASE_MNT" ]; then
> +		$UMOUNT_PROG $SCRATCH_BASE_MNT
> +	fi
> +}
> +
>  _overlay_scratch_mount()
>  {
> +	# base fs may be mounted after overlay mkfs
> +	_overlay_scratch_base_unmount 2>/dev/null
> +	_overlay_scratch_base_mount
>  	_overlay_mount $SCRATCH_BASE_DIR $SCRATCH_MNT $*
>  }
>  
> +_overlay_test_base_unmount()
> +{
> +	if [ -n "$TEST_BASE_DEV" -a -n "$TEST_BASE_MNT" ]; then
> +		$UMOUNT_PROG $TEST_BASE_MNT
> +	fi
> +}
> +
>  _overlay_test_unmount()
>  {
>  	$UMOUNT_PROG $TEST_DIR
> +	_overlay_test_base_unmount
>  }
>  
>  _overlay_scratch_unmount()
>  {
>  	$UMOUNT_PROG $SCRATCH_MNT
> +	_overlay_scratch_base_unmount
>  }
>  
>  _scratch_mount()
> @@ -643,7 +681,11 @@ _scratch_cleanup_files()
>  	overlay)
>  		# Avoid rm -rf /* if we messed up
>  		[ -n "$SCRATCH_BASE_DIR" ] || return
> +		# overlay 'mkfs' needs to make sure base fs is mounted and clean
> +		_overlay_scratch_base_unmount 2>/dev/null
> +		_overlay_scratch_base_mount
>  		rm -rf $SCRATCH_BASE_DIR/*
> +		# leave base fs mouted so tests can setup lower dir
>  		;;
>  	*)
>  		[ -n "$SCRATCH_MNT" ] || return
> diff --git a/tests/overlay/003 b/tests/overlay/003
> index bb59700..81aea85 100755
> --- a/tests/overlay/003
> +++ b/tests/overlay/003
> @@ -89,7 +89,8 @@ rm -rf ${SCRATCH_MNT}/*
>  # nothing should be listed
>  ls ${SCRATCH_MNT}/
>  
> -_scratch_unmount
> +# unmount overlayfs but not base fs
> +$UMOUNT_PROG $SCRATCH_MNT
>  
>  rm -rf $lowerdir
>  echo "Silence is golden"
> diff --git a/tests/overlay/004 b/tests/overlay/004
> index 6d78f9f..26ac547 100755
> --- a/tests/overlay/004
> +++ b/tests/overlay/004
> @@ -85,7 +85,8 @@ _user_do "chmod g+t ${SCRATCH_MNT}/attr_file2 > /dev/null 2>&1"
>  _user_do "chmod u-X ${SCRATCH_MNT}/attr_file2 > /dev/null 2>&1"
>  stat -c %a ${SCRATCH_MNT}/attr_file2
>  
> -_scratch_unmount
> +# unmount overlayfs but not base fs
> +$UMOUNT_PROG $SCRATCH_MNT
>  
>  # check mode bits of the file that has been copied up, and
>  # the file that should not have been copied up.
> diff --git a/tests/overlay/014 b/tests/overlay/014
> index 7426c31..6519432 100755
> --- a/tests/overlay/014
> +++ b/tests/overlay/014
> @@ -73,7 +73,8 @@ mkdir -p $lowerdir1/testdir/d
>  _overlay_mount_dirs $lowerdir1 $lowerdir2 $workdir $SCRATCH_BASE_DIR $SCRATCH_MNT
>  rm -rf $SCRATCH_MNT/testdir
>  mkdir -p $SCRATCH_MNT/testdir/visibledir
> -_scratch_unmount
> +# unmount overlayfs but not base fs
> +$UMOUNT_PROG $SCRATCH_MNT
>  
>  # mount overlay again, with lowerdir1 and lowerdir2 as multiple lowerdirs,
>  # and create a new file in testdir, triggers copyup from lowerdir,
> @@ -84,7 +85,7 @@ touch $SCRATCH_MNT/testdir/visiblefile
>  
>  # umount and mount overlay again, buggy kernel treats the copied-up dir as
>  # opaque, visibledir is not seen in merged dir.
> -_scratch_unmount
> +$UMOUNT_PROG $SCRATCH_MNT
>  _overlay_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir \
>  		    $SCRATCH_BASE_DIR $SCRATCH_MNT
>  ls $SCRATCH_MNT/testdir
> -- 
> 2.7.4
> 

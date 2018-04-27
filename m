Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Fri, 27 Apr 2018 10:43:04 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2 4/4] overlay/04{1,3,4}: enable xino feature
Message-ID: <20180427024304.GL11384@desktop>
References: <1524722007-30891-1-git-send-email-amir73il@gmail.com>
 <1524722007-30891-5-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524722007-30891-5-git-send-email-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 25, 2018 at 11:53:27PM -0600, Amir Goldstein wrote:
> These tests check for constant inode number on copy up with nonsamefs
> layer configuration. This problem is fixes only when opting-in with the
> xino=on mount option, so let the tests enable the mount option on new
> kernels and notrun on old kernels.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/041 | 16 ++++++++++++----
>  tests/overlay/043 | 16 ++++++++++++----
>  tests/overlay/044 | 16 ++++++++++++----
>  3 files changed, 36 insertions(+), 12 deletions(-)
> 
> diff --git a/tests/overlay/041 b/tests/overlay/041
> index f3be746..78f8179 100755
> --- a/tests/overlay/041
> +++ b/tests/overlay/041
> @@ -70,7 +70,15 @@ _scratch_mkfs
>  upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
>  workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
>  
> -_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
> +# Enabling xino in this test requires that base filesystem inode numbers will
> +# not use bit 63 in inode number of the test files, because bit 63 is used by
> +# overlayfs to indicate the layer. Let's just assume that this is true for all
> +# tested filesystems and if we are wrong, the test may fail.
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o xino=on ||
> +	_notrun "mount overlay with xino failed"

The _notrun message seems to indicate there's a failure (I can see that
it's copied from _require_scratch_dax), which may confuse users. I can
change it to something like below on commit, if you have better messages
please advise :)

	_notrun "cannot mount overlay with xino=on option"

> +# Not using _check_scratch_fs_option because it uses grep -w
> +_fs_options $SCRATCH_DEV | grep -q "xino=on" || \
> +	_notrun "failed to enable xino"

	_notrun "cannot enable xino feature"

Thanks,
Eryu

>  
>  test_dir=$SCRATCH_MNT/test_dir/
>  
> @@ -171,7 +179,7 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
>  $UMOUNT_PROG $SCRATCH_MNT
>  
>  # check overlayfs
> -_overlay_check_scratch_dirs $lowerdir $upperdir $workdir
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o xino=on
>  
>  # Verify pure lower residing in dir which has another lower layer
>  middir=$OVL_BASE_TEST_DIR/$seq-ovl-mid
> @@ -186,7 +194,7 @@ mkdir -p $lowerdir/test_dir/pure_lower_dir/subdir
>  
>  _scratch_mkfs
>  
> -_overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir
> +_overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir -o xino=on
>  
>  # Copy up test_dir
>  touch $test_dir/test_file
> @@ -209,7 +217,7 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
>  	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for subdir"
>  
>  # check overlayfs
> -_overlay_check_scratch_dirs "$middir:$lowerdir" $upperdir $workdir
> +_overlay_check_scratch_dirs "$middir:$lowerdir" $upperdir $workdir -o xino=on
>  
>  echo "Silence is golden"
>  status=0
> diff --git a/tests/overlay/043 b/tests/overlay/043
> index f70ee7f..c865b51 100755
> --- a/tests/overlay/043
> +++ b/tests/overlay/043
> @@ -85,8 +85,16 @@ _scratch_mkfs >>$seqres.full 2>&1
>  upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
>  workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
>  
> -# Enable redirect_dir for renaming a merge directory
> -_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o redirect_dir=on
> +# Enable redirect_dir for renaming a merge directory.
> +# Enabling xino in this test requires that base filesystem inode numbers will
> +# not use bit 63 in inode number of the test files, because bit 63 is used by
> +# overlayfs to indicate the layer. Let's just assume that this is true for all
> +# tested filesystems and if we are wrong, the test may fail.
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o redirect_dir=on,xino=on || \
> +	_notrun "mount overlay with xino failed"
> +# Not using _check_scratch_fs_option because it uses grep -w
> +_fs_options $SCRATCH_DEV | grep -q "xino=on" || \
> +	_notrun "failed to enable xino"
>  
>  FILES="dir file symlink chrdev blkdev fifo socket"
>  
> @@ -153,13 +161,13 @@ check_inode_numbers $testdir $tmp.after_copyup $tmp.after_move
>  
>  # Verify that the inode numbers survive a mount cycle
>  $UMOUNT_PROG $SCRATCH_MNT
> -_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o redirect_dir=on
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o redirect_dir=on,xino=on
>  
>  # Compare inode numbers before/after mount cycle
>  check_inode_numbers $testdir $tmp.after_move $tmp.after_cycle
>  
>  # check overlayfs
> -_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o redirect_dir=on
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o redirect_dir=on,xino=on
>  
>  echo "Silence is golden"
>  status=0
> diff --git a/tests/overlay/044 b/tests/overlay/044
> index 2ab3035..bcc30ac 100755
> --- a/tests/overlay/044
> +++ b/tests/overlay/044
> @@ -99,8 +99,16 @@ _scratch_mkfs >>$seqres.full 2>&1
>  upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
>  workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
>  
> -# Enable overlay index feature to prevent breaking hardlinks on copy up
> -_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on
> +# Enable overlay index feature to prevent breaking hardlinks on copy up.
> +# Enabling xino in this test requires that base filesystem inode numbers will
> +# not use bit 63 in inode number of the test files, because bit 63 is used by
> +# overlayfs to indicate the layer. Let's just assume that this is true for all
> +# tested filesystems and if we are wrong, the test may fail.
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on,xino=on || \
> +	_notrun "mount overlay with xino failed"
> +# Not using _check_scratch_fs_option because it uses grep -w
> +_fs_options $SCRATCH_DEV | grep -q "xino=on" || \
> +	_notrun "failed to enable xino"
>  
>  rm -f $tmp.*
>  
> @@ -124,8 +132,8 @@ check_ino_nlink $SCRATCH_MNT $tmp.before $tmp.after_one
>  
>  # Verify that the hardlinks survive a mount cycle
>  $UMOUNT_PROG $SCRATCH_MNT
> -_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o index=on
> -_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o index=on,xino=on
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on,xino=on
>  
>  echo "== After mount cycle =="
>  cat $FILES
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Wed, 25 Apr 2018 13:48:07 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 2/2] overlay/04{1,3,4}: enable xino feature
Message-ID: <20180425054807.GG11384@desktop>
References: <1524061018-20413-1-git-send-email-amir73il@gmail.com>
 <1524061018-20413-3-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524061018-20413-3-git-send-email-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 18, 2018 at 05:16:58PM +0300, Amir Goldstein wrote:
> These tests check for constant inode number on copy up with nonsamefs
> layer configuration. This problem is fixes only when opting-in with the
> xino=on mount option, so let the tests enable the mount option on new
> kernels and notrun on old kernels.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/041 | 15 +++++++++++----
>  tests/overlay/043 | 13 ++++++++++---
>  tests/overlay/044 | 15 +++++++++++----
>  3 files changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/tests/overlay/041 b/tests/overlay/041
> index 4e72348..9de61f7 100755
> --- a/tests/overlay/041
> +++ b/tests/overlay/041
> @@ -70,7 +70,14 @@ _scratch_mkfs
>  upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
>  workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
>  
> -_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
> +# enabling xino in this test requires that base filesystem inode numbers will
> +# not use bit 63 in inode number of the test files, because bit 63 is used by
> +# overlayfs to indicate the layer. Let's just assume that this is true for all
> +# tested filesystems and if we are wrong, the test may fail
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o xino=on ||
> +	_notrun "mount overlay with xino failed"
> +_check_scratch_fs_option "xino" || \
> +	_notrun "faild to enable xino"
>  
>  test_dir=$SCRATCH_MNT/test_dir/
>  
> @@ -171,7 +178,7 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
>  _scratch_unmount
>  
>  # check overlayfs
> -_overlay_check_scratch_dirs $lowerdir $upperdir $workdir
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o xino=on
>  
>  # Verify pure lower residing in dir which has another lower layer
>  middir=$OVL_BASE_TEST_DIR/$seq-ovl-mid
> @@ -189,7 +196,7 @@ _scratch_mkfs
>  upperdir=$OVL_BASE_SCRATCH_MNT/ovl-upper
>  workdir=$OVL_BASE_SCRATCH_MNT/ovl-work
>  
> -_overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir
> +_overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir -o xino=on
>  
>  # Copy up test_dir
>  touch $test_dir/test_file
> @@ -212,7 +219,7 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
>  	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for subdir"
>  
>  # check overlayfs
> -_overlay_check_scratch_dirs "$middir:$lowerdir" $upperdir $workdir
> +_overlay_check_scratch_dirs "$middir:$lowerdir" $upperdir $workdir -o xino=on

041 fails the fsck.overlay check, but I think that's a different issue.

*** fsck.overlay output ***
fsck.overlay:[Error]: Faile to resolve upperdir:/mnt/scratch/ovl-upper:No such file or directory
Please specify correct lowerdirs and upperdir!

Usage:
        fsck.overlay [-o lowerdir=<lowers>,upperdir=<upper>,workdir=<work>] [-pnyvhV]

Options:
-o,                       specify underlying directories of overlayfs
                          multiple lower directories use ':' as separator
-p,                       automatic repair (no questions)
-n,                       make no changes to the filesystem
-y,                       assume "yes" to all questions
-v, --verbose             print more messages of overlayfs
-h, --help                display this usage of overlayfs
-V, --version             display version information
*** end fsck.overlay output

>  
>  echo "Silence is golden"
>  status=0
> diff --git a/tests/overlay/043 b/tests/overlay/043
> index 46df686..66771c0 100755
> --- a/tests/overlay/043
> +++ b/tests/overlay/043
> @@ -83,7 +83,14 @@ _scratch_mkfs >>$seqres.full 2>&1
>  upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
>  workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
>  
> -_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
> +# enabling xino in this test requires that base filesystem inode numbers will
> +# not use bit 63 in inode number of the test files, because bit 63 is used by
> +# overlayfs to indicate the layer. Let's just assume that this is true for all
> +# tested filesystems and if we are wrong, the test may fail
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o xino=on || \
> +	_notrun "mount overlay with xino failed"
> +_check_scratch_fs_option "xino" || \
> +	_notrun "faild to enable xino"

043 still fails for me, kernel is v4.17-rc2

[root@fedoravm xfstests]# diff -u tests/overlay/043.out /root/workspace/xfstests/results//xfs_4k/overlay/043.out.bad
--- tests/overlay/043.out       2018-02-25 15:15:00.135387405 +0800
+++ /root/workspace/xfstests/results//xfs_4k/overlay/043.out.bad        2018-04-25 13:44:24.378262790 +0800
@@ -1,2 +1,11 @@
 QA output created by 043
+--- /tmp/29215.after_copyup    2018-04-25 13:44:23.888271267 +0800
++++ /tmp/29215.after_move      2018-04-25 13:44:24.115267339 +0800
+@@ -1,4 +1,4 @@
+-9223372036888371331 dir
++50333121 dir
+ 9223372036871553155 file
+ 9223372036871553156 symlink
+ 9223372036871553157 chrdev
+dir not found by ino 9223372036888371331 (from /tmp/29215.after_copyup)
 Silence is golden

I used ext4 as underlying filesystem, but xfs failed too.

>  
>  FILES="dir file symlink chrdev blkdev fifo socket"
>  
> @@ -150,13 +157,13 @@ check_inode_numbers $testdir $tmp.after_copyup $tmp.after_move
>  
>  # Verify that the inode numbers survive a mount cycle
>  $UMOUNT_PROG $SCRATCH_MNT
> -_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o xino=on
>  
>  # Compare inode numbers before/after mount cycle
>  check_inode_numbers $testdir $tmp.after_move $tmp.after_cycle
>  
>  # check overlayfs
> -_overlay_check_scratch_dirs $lowerdir $upperdir $workdir
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o xino=on
>  
>  echo "Silence is golden"
>  status=0
> diff --git a/tests/overlay/044 b/tests/overlay/044
> index 2ab3035..0e74128 100755
> --- a/tests/overlay/044
> +++ b/tests/overlay/044
> @@ -99,8 +99,15 @@ _scratch_mkfs >>$seqres.full 2>&1
>  upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
>  workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
>  
> -# Enable overlay index feature to prevent breaking hardlinks on copy up
> -_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on
> +# Enable overlay index feature to prevent breaking hardlinks on copy up.
> +# enabling xino in this test requires that base filesystem inode numbers will
> +# not use bit 63 in inode number of the test files, because bit 63 is used by
> +# overlayfs to indicate the layer. Let's just assume that this is true for all
> +# tested filesystems and if we are wrong, the test may fail
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on,xino=on || \
> +	_notrun "mount overlay with xino failed"
> +_check_scratch_fs_option "xino" || \
> +	_notrun "faild to enable xino"
>  
>  rm -f $tmp.*
>  
> @@ -124,8 +131,8 @@ check_ino_nlink $SCRATCH_MNT $tmp.before $tmp.after_one
>  
>  # Verify that the hardlinks survive a mount cycle
>  $UMOUNT_PROG $SCRATCH_MNT
> -_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o index=on
> -_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o index=on,xino=on
> +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on,xino=on

044 passes!

Thanks,
Eryu

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

From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests PATCH v2 5/5] overlay: correct scratch dirs check
Date: Wed, 7 Feb 2018 00:11:38 +0800
Message-ID: <20180206161138.GT18267@eguan.usersys.redhat.com>
References: <20180131102759.40997-1-yi.zhang@huawei.com>
 <20180131102759.40997-6-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752185AbeBFQLk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Feb 2018 11:11:40 -0500
Content-Disposition: inline
In-Reply-To: <20180131102759.40997-6-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, miaoxie@huawei.com, yangerkun@huawei.com

On Wed, Jan 31, 2018 at 06:27:59PM +0800, zhangyi (F) wrote:
> Tests that use _overlay_scratch_mount_dirs instead of _scratch_mount
> should use _require_overlay_scratch_dirs instead of _require_scratch.

This commit log just describes what to do but not why, I guess it's
because these tests are either mounting with multiple lower dirs or
mounting with non-default lower/upper/work dir, so
_check_overlay_scratch_fs won't handle these cases correctly, we need to
call _overlay_check_scratch_dirs with the correct arguments.

> Those tests can optionally call _overlay_check_scratch_dirs at the end
> of the test or before _scratch_umount to umount $SCRATCH_MNT and
> run the checker.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  tests/overlay/005 |  6 +++++-
>  tests/overlay/010 |  6 +++++-
>  tests/overlay/014 | 10 +++++++++-
>  tests/overlay/035 |  6 +++++-
>  tests/overlay/036 |  5 ++++-
>  tests/overlay/037 |  6 +++++-
>  tests/overlay/038 | 10 +++++++++-
>  tests/overlay/041 | 10 +++++++++-
>  tests/overlay/043 |  6 +++++-
>  tests/overlay/044 | 13 +++++++++++--
>  10 files changed, 67 insertions(+), 11 deletions(-)
> 
> diff --git a/tests/overlay/005 b/tests/overlay/005
> index 17992a3..f502d3f 100755
> --- a/tests/overlay/005
> +++ b/tests/overlay/005
> @@ -54,7 +54,7 @@ rm -f $seqres.full
>  # Modify as appropriate.
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +_require_overlay_scratch_dirs

As mentioned in previous reply, just use _require_scratch_nocheck for
such cases with comments why.

>  _require_loop
>  
>  # Remove all files from previous tests
> @@ -102,6 +102,10 @@ $XFS_IO_PROG -f -c "o" ${SCRATCH_MNT}/test_file \
>  # unmount overlayfs
>  $UMOUNT_PROG $SCRATCH_MNT
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# do check optionally dirs after test

Such comments (and similar comments below) don't provide any additional
information. And with proper comments for _require_scratch_nocheck, I
think we could remove the comments here.

> +_overlay_check_scratch_dirs $lowerd $upperd $workd
> +
>  # unmount undelying xfs, this tiggers panic if memleak happens
>  $UMOUNT_PROG ${OVL_BASE_SCRATCH_MNT}/uppermnt
>  $UMOUNT_PROG ${OVL_BASE_SCRATCH_MNT}/lowermnt
> diff --git a/tests/overlay/010 b/tests/overlay/010
> index f55ebec..f3b50d7 100755
> --- a/tests/overlay/010
> +++ b/tests/overlay/010
> @@ -48,7 +48,7 @@ rm -f $seqres.full
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +_require_overlay_scratch_dirs
>  
>  # Remove all files from previous tests
>  _scratch_mkfs
> @@ -70,6 +70,10 @@ mknod $lowerdir2/testdir/a c 0 0
>  _overlay_scratch_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
>  rm -rf $SCRATCH_MNT/testdir
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# do check optionally dirs after test
> +_overlay_check_scratch_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
> +
>  # success, all done
>  echo "Silence is golden"
>  status=0
> diff --git a/tests/overlay/014 b/tests/overlay/014
> index 9f308d3..069d8b6 100755
> --- a/tests/overlay/014
> +++ b/tests/overlay/014
> @@ -53,7 +53,7 @@ rm -f $seqres.full
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +_require_overlay_scratch_dirs
>  
>  # Remove all files from previous tests
>  _scratch_mkfs
> @@ -78,6 +78,10 @@ mkdir -p $SCRATCH_MNT/testdir/visibledir
>  # unmount overlayfs but not base fs
>  $UMOUNT_PROG $SCRATCH_MNT
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# do check optionally dirs after each test
> +_overlay_check_scratch_dirs $lowerdir1 $lowerdir2 $workdir2
> +
>  # mount overlay again, with lowerdir1 and lowerdir2 as multiple lowerdirs,
>  # and create a new file in testdir, triggers copyup from lowerdir,
>  # copyup should not copy overlayfs private xattr
> @@ -90,6 +94,10 @@ $UMOUNT_PROG $SCRATCH_MNT
>  _overlay_scratch_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
>  ls $SCRATCH_MNT/testdir
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# do check optionally dirs after each test
> +_overlay_check_scratch_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
> +
>  # success, all done
>  status=0
>  exit
> diff --git a/tests/overlay/035 b/tests/overlay/035
> index 0544774..bc73013 100755
> --- a/tests/overlay/035
> +++ b/tests/overlay/035
> @@ -51,7 +51,7 @@ rm -f $seqres.full
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +_require_overlay_scratch_dirs
>  _require_chattr i
>  
>  # Remove all files from previous tests
> @@ -81,6 +81,10 @@ _overlay_scratch_mount_dirs $lowerdir2 $upperdir $workdir
>  touch $SCRATCH_MNT/bar 2>&1 | _filter_scratch
>  _scratch_remount rw 2>&1 | _filter_ro_mount
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# do check optionally dirs after test
> +_overlay_check_scratch_dirs $lowerdir2 $upperdir $workdir
> +
>  # success, all done
>  status=0
>  exit
> diff --git a/tests/overlay/036 b/tests/overlay/036
> index e0c13ae..ca5adbd 100755
> --- a/tests/overlay/036
> +++ b/tests/overlay/036
> @@ -69,7 +69,7 @@ rm -f $seqres.full
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +_require_overlay_scratch_dirs
>  _require_scratch_feature index
>  
>  # Remove all files from previous tests
> @@ -110,6 +110,9 @@ _overlay_mount_dirs $lowerdir2 $upperdir $workdir2 \
>  _overlay_mount_dirs $lowerdir2 $upperdir2 $workdir \
>  	    overlay3 $SCRATCH_MNT -oindex=on 2>&1 | _filter_busy_mount
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# but which will not lead to inconsistency after this mount test,
> +# so do not check optionally dirs after test

It's not clear where does the inconsistency come from and why it's
expected (as we don't do fsck after test).

>  
>  # success, all done
>  status=0
> diff --git a/tests/overlay/037 b/tests/overlay/037
> index 6710dda..60290a1 100755
> --- a/tests/overlay/037
> +++ b/tests/overlay/037
> @@ -55,7 +55,7 @@ rm -f $seqres.full
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +_require_overlay_scratch_dirs
>  _require_scratch_feature index
>  
>  # Remove all files from previous tests
> @@ -87,6 +87,10 @@ $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
>  # Mount overlay with original lowerdir, upperdir, workdir and index=on - expect success
>  _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -oindex=on
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# but which will not lead to inconsistency after this mount test,
> +# so do not check optionally dirs after test
> +

Same here.

Thanks,
Eryu

>  # success, all done
>  status=0
>  exit
> diff --git a/tests/overlay/038 b/tests/overlay/038
> index bd87156..aa20cbc 100755
> --- a/tests/overlay/038
> +++ b/tests/overlay/038
> @@ -46,7 +46,7 @@ _cleanup()
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +_require_overlay_scratch_dirs
>  _require_attrs
>  _require_test_program "t_dir_type"
>  
> @@ -161,6 +161,10 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
>  [[ $subdir_d == "subdir d" ]] || \
>  	echo "Merged dir: Invalid d_ino reported for subdir"
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# do check after each test
> +_check_scratch_fs
> +
>  _scratch_unmount
>  
>  # Verify pure lower residing in dir which has another lower layer
> @@ -202,6 +206,10 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
>  [[ $subdir_d == "subdir d" ]] || \
>  	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for subdir"
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# do check optionally dirs after each test
> +_overlay_check_scratch_dirs "$middir:$lowerdir" $upperdir $workdir
> +
>  echo "Silence is golden"
>  status=0
>  exit
> diff --git a/tests/overlay/041 b/tests/overlay/041
> index 4152107..607908a 100755
> --- a/tests/overlay/041
> +++ b/tests/overlay/041
> @@ -48,7 +48,7 @@ _cleanup()
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +_require_overlay_scratch_dirs
>  _require_test
>  _require_attrs
>  _require_test_program "t_dir_type"
> @@ -167,6 +167,10 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
>  [[ $subdir_d == "subdir d" ]] || \
>  	echo "Merged dir: Invalid d_ino reported for subdir"
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# do check optionally dirs after each test
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir
> +
>  _scratch_unmount
>  
>  # Verify pure lower residing in dir which has another lower layer
> @@ -208,6 +212,10 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
>  [[ $subdir_d == "subdir d" ]] || \
>  	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for subdir"
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# do check optionally dirs after each test
> +_overlay_check_scratch_dirs "$middir:$lowerdir" $upperdir $workdir
> +
>  echo "Silence is golden"
>  status=0
>  exit
> diff --git a/tests/overlay/043 b/tests/overlay/043
> index 858b6a9..76e0dd9 100755
> --- a/tests/overlay/043
> +++ b/tests/overlay/043
> @@ -56,7 +56,7 @@ _cleanup()
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +_require_overlay_scratch_dirs
>  _require_test
>  _require_test_program "af_unix"
>  _require_test_program "t_dir_type"
> @@ -155,6 +155,10 @@ _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir \
>  # Compare inode numbers before/after mount cycle
>  check_inode_numbers $testdir $tmp.after_move $tmp.after_cycle
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# do check optionally dirs after test
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir
> +
>  echo "Silence is golden"
>  status=0
>  exit
> diff --git a/tests/overlay/044 b/tests/overlay/044
> index 9c0ff04..65591f9 100755
> --- a/tests/overlay/044
> +++ b/tests/overlay/044
> @@ -49,7 +49,7 @@ _cleanup()
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +_require_overlay_scratch_dirs
>  _require_test
>  _require_scratch_feature index
>  _require_test_program "t_dir_type"
> @@ -122,8 +122,13 @@ echo "== After write one =="
>  cat $FILES
>  check_ino_nlink $SCRATCH_MNT $tmp.before $tmp.after_one
>  
> -# Verify that the hardlinks survive a mount cycle
>  $UMOUNT_PROG $SCRATCH_MNT
> +
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# do check optionally dirs after each test
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir "-o index=on"
> +
> +# Verify that the hardlinks survive a mount cycle
>  _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir \
>  			    $OVERLAY_MOUNT_OPTIONS
>  
> @@ -141,5 +146,9 @@ echo "== After write two =="
>  cat $FILES
>  check_ino_nlink $SCRATCH_MNT $tmp.after_one $tmp.after_two
>  
> +# We called _require_overlay_scratch_dirs instead of _require_scratch,
> +# do check optionally dirs after test
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir
> +
>  status=0
>  exit
> -- 
> 2.5.0
> 

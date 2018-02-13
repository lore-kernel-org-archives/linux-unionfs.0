From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [xfstests PATCH v3 5/6] overlay: correct scratch dirs check
Date: Tue, 13 Feb 2018 10:58:02 +0200
Message-ID: <CAOQ4uxg1k6Rz6u3RKNQy12sQe9kaKxqnsmaN+S5WeSns-_UJHA@mail.gmail.com>
References: <20180213070832.43159-1-yi.zhang@huawei.com> <20180213070832.43159-6-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180213070832.43159-6-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Feb 13, 2018 at 9:08 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Tests that use _overlay_scratch_mount_dirs instead of _scratch_mount
> should use _require_overlay_scratch_dirs instead of _require_scratch
> because these tests are either mounting with multiple lower dirs or
> mounting with non-default lower/upper/work dir, so
> _check_overlay_scratch_fs won't handle these cases correctly, we need
> to call _overlay_check_scratch_dirs with the correct arguments.
>
> This patch modify these tests to optionally call
> _overlay_check_scratch_dirs at the end of the test or before
> _scratch_umount to umount $SCRATCH_MNT and run the checker.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Usually, you should remove Reviewed-by when patch has changed considerably.
Anyway, you may restore Reviewed-by after addressing minor comments below.

[...]

> --- a/tests/overlay/038
> +++ b/tests/overlay/038
> @@ -46,7 +46,9 @@ _cleanup()
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +# Use non-default scratch underlying overlay dirs, we need to check
> +# them explicity after test.
> +_require_scratch_nocheck
>  _require_attrs
>  _require_test_program "t_dir_type"
>
> @@ -161,6 +163,9 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
>  [[ $subdir_d == "subdir d" ]] || \
>         echo "Merged dir: Invalid d_ino reported for subdir"
>
> +# check overlayfs
> +_check_scratch_fs
> +
>  _scratch_unmount
>

Every time this pattern repeats, it is better to _check after _unmount.
Otherwise _check would need to unmount and mount for no reason.

>  # Verify pure lower residing in dir which has another lower layer
> @@ -202,6 +207,9 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
>  [[ $subdir_d == "subdir d" ]] || \
>         echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for subdir"
>
> +# check overlayfs
> +_overlay_check_scratch_dirs "$middir:$lowerdir" $upperdir $workdir
> +
>  echo "Silence is golden"
>  status=0
>  exit
> diff --git a/tests/overlay/041 b/tests/overlay/041
> index 11efacb..da50e0b 100755
> --- a/tests/overlay/041
> +++ b/tests/overlay/041
> @@ -48,7 +48,9 @@ _cleanup()
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +# Use non-default scratch underlying overlay dirs, we need to check
> +# them explicity after test.
> +_require_scratch_nocheck
>  _require_test
>  _require_attrs
>  _require_test_program "t_dir_type"
> @@ -166,6 +168,9 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
>  [[ $subdir_d == "subdir d" ]] || \
>         echo "Merged dir: Invalid d_ino reported for subdir"
>
> +# check overlayfs
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir
> +

Here as well.

>  _scratch_unmount
>
>  # Verify pure lower residing in dir which has another lower layer
> @@ -206,6 +211,9 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
>  [[ $subdir_d == "subdir d" ]] || \
>         echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for subdir"
>
> +# check overlayfs
> +_overlay_check_scratch_dirs "$middir:$lowerdir" $upperdir $workdir
> +
>  echo "Silence is golden"
>  status=0
>  exit
> diff --git a/tests/overlay/043 b/tests/overlay/043
> index 699c4e1..46df686 100755
> --- a/tests/overlay/043
> +++ b/tests/overlay/043
> @@ -56,7 +56,9 @@ _cleanup()
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +# Use non-default scratch underlying overlay dirs, we need to check
> +# them explicity after test.
> +_require_scratch_nocheck
>  _require_test
>  _require_test_program "af_unix"
>  _require_test_program "t_dir_type"
> @@ -153,6 +155,9 @@ _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
>  # Compare inode numbers before/after mount cycle
>  check_inode_numbers $testdir $tmp.after_move $tmp.after_cycle
>
> +# check overlayfs
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir
> +
>  echo "Silence is golden"
>  status=0
>  exit
> diff --git a/tests/overlay/044 b/tests/overlay/044
> index e57f6f7..2ab3035 100755
> --- a/tests/overlay/044
> +++ b/tests/overlay/044
> @@ -49,7 +49,9 @@ _cleanup()
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +# Use non-default scratch underlying overlay dirs, we need to check
> +# them explicity after test.
> +_require_scratch_nocheck
>  _require_test
>  _require_scratch_feature index
>  _require_test_program "t_dir_type"
> @@ -122,6 +124,7 @@ check_ino_nlink $SCRATCH_MNT $tmp.before $tmp.after_one
>
>  # Verify that the hardlinks survive a mount cycle
>  $UMOUNT_PROG $SCRATCH_MNT
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o index=on
>  _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir -o index=on
>
>  echo "== After mount cycle =="
> @@ -138,5 +141,8 @@ echo "== After write two =="
>  cat $FILES
>  check_ino_nlink $SCRATCH_MNT $tmp.after_one $tmp.after_two
>
> +# check overlayfs
> +_overlay_check_scratch_dirs $lowerdir $upperdir $workdir -o index=on
> +
>  status=0
>  exit
> diff --git a/tests/overlay/051 b/tests/overlay/051
> index ae7844d..b888f1e 100755
> --- a/tests/overlay/051
> +++ b/tests/overlay/051
> @@ -61,8 +61,10 @@ _cleanup()
>  _supported_fs overlay
>  _supported_os Linux
>  _require_test
> -_require_scratch
>  _require_test_program "open_by_handle"
> +# Use non-default scratch underlying overlay dirs, we need to check
> +# them explicity after test.
> +_require_scratch_nocheck
>  # We need to require both features together, because nfs_export cannot
>  # be enabled when index is disabled
>  _require_scratch_overlay_features index nfs_export
> @@ -128,6 +130,13 @@ unmount_dirs()
>         $UMOUNT_PROG $SCRATCH_MNT
>  }
>
> +# Check underlying dirs of overlayfs
> +check_dirs()
> +{
> +       _overlay_check_scratch_dirs $middle:$lower $upper $work \
> +                               -o "index=on,nfs_export=on"

Please embed this check inside unmount_dirs() instead of adding
check_dirs calls - the reason - I tried to keep diff between
05${i} and 05${i+1} to the implementation of the helpers, so that if
one test is updated  it is easier to update its ^samefs flavor.

Thanks,
Amir.

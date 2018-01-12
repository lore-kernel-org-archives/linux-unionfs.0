From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 6/7] overlay/010: fix fs check failure
Date: Fri, 12 Jan 2018 21:10:53 +0200
Message-ID: <CAOQ4uxixmJgQY7JtgJB5MxQQRE6h3-mqKvxTzEwXPjpeWH_MJw@mail.gmail.com>
References: <20180112120533.6099-1-yi.zhang@huawei.com> <20180112120533.6099-7-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180112120533.6099-7-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jan 12, 2018 at 2:05 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> This test use ovl_lower.1/ovl_lower.2 and ovl_upper in scratch
> filesystem as underlying directories of overlay filesystem, but
> _check_overlay_scratch_fs() only check ovl_lower and ovl_upper
> directories. So whiteout "testdir" in ovl_upper becomes an orphan
> whiteout, which will lead to fsck.overlay check failure.
>
> This patch change to invoke _overlay_check_dirs() to check real
> test dirs instead of pre-defined common dirs.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Looks correct

Amir.

> ---
>  tests/overlay/010 | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/tests/overlay/010 b/tests/overlay/010
> index f55ebec..d6b7180 100755
> --- a/tests/overlay/010
> +++ b/tests/overlay/010
> @@ -48,17 +48,17 @@ rm -f $seqres.full
>  # real QA test starts here
>  _supported_fs overlay
>  _supported_os Linux
> -_require_scratch
> +_require_scratch_nocheck
>
>  # Remove all files from previous tests
>  _scratch_mkfs
>
>  # Need two lower dirs in this test, and we mount overlay ourselves,
>  # create upper and workdir as well
> -lowerdir1=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER.1
> -lowerdir2=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER.2
> -upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> -workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> +lowerdir1=$OVL_BASE_SCRATCH_MNT/lower1
> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
> +workdir=$OVL_BASE_SCRATCH_MNT/work
>  mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
>
>  # One lowerdir contains test dir and test files, the other contains whiteout
> @@ -70,6 +70,7 @@ mknod $lowerdir2/testdir/a c 0 0
>  _overlay_scratch_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
>  rm -rf $SCRATCH_MNT/testdir
>
> +_overlay_check_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
>  # success, all done
>  echo "Silence is golden"
>  status=0
> --
> 2.9.5
>

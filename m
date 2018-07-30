Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180728084242.33918-2-yi.zhang@huawei.com>
References: <20180728084242.33918-1-yi.zhang@huawei.com> <20180728084242.33918-2-yi.zhang@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 30 Jul 2018 08:38:37 +0300
Message-ID: <CAOQ4uxjLi2VaP_3YiUkLfgkwXfOtnoXYNM1X6RCPW0AkhvwQDw@mail.gmail.com>
Subject: Re: [xfstests PATCH 1/3] overlay: correct fsck.overlay exit code
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Jul 28, 2018 at 11:42 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> fsck.overlay should return correct exit code to show the file system
> status after fsck, instead of return 0 means consistency and !0 means
> inconsistency or something bad happened.
>
> Fix the following three exit code after running fsck.overlay:
>
> - Return FSCK_OK if the input file system is consistent,
> - Return FSCK_NONDESTRUCT if the file system inconsistent errors
>   corrected,
> - Return FSCK_UNCORRECTED if the file system still have inconsistent
>   errors.
>
> This patch also correct the input underlying dirs for some "valid" test
> cases, avoid return unexpected exit code which caused by other unrelated
> inconsistency.

... and also adds more test coverage (impure dir) ..
too many changes at once.
Please separate the exit code change from the rest of the changes.

Usually, Eryu doesn't like adding coverage to existing test, but since
there are "not so many" testers of fsck.overlay, maybe he can make an
exception, but you do need to declare this change in commit message.

>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  common/config     | 10 +++++++++
>  tests/overlay/045 | 59 +++++++++++++++++++++++++++++++++-------------------
>  tests/overlay/046 | 62 ++++++++++++++++++++++++++++++++++---------------------
>  tests/overlay/056 | 22 ++++++++++++++------
>  4 files changed, 102 insertions(+), 51 deletions(-)
>
> diff --git a/common/config b/common/config
> index 2f1f272..6e83fca 100644
> --- a/common/config
> +++ b/common/config
> @@ -194,6 +194,16 @@ export CHECKBASHISMS_PROG="$(type -P checkbashisms)"
>  export XFS_INFO_PROG="$(type -P xfs_info)"
>  export DUPEREMOVE_PROG="$(type -P duperemove)"
>
> +# Export exit code used by fsck-type programs
> +export FSCK_OK=0
> +export FSCK_NONDESTRUCT=1
> +export FSCK_REBOOT=2
> +export FSCK_UNCORRECTED=4
> +export FSCK_ERROR=8
> +export FSCK_USAGE=16
> +export FSCK_CANCELED=32
> +export FSCK_LIBRARY=128
> +

While this is common to e2fsck, I don't think it is "common" enough,
so maybe keep those values in a less central file (i.e. common/fsck)
and name e2fsprogs and fsck.overlayfs (other?) specifically.

>  # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
>  # newer systems have udevadm command but older systems like RHEL5 don't.
>  # But if neither one is available, just set it to "sleep 1" to wait for lv to
> diff --git a/tests/overlay/045 b/tests/overlay/045
> index acc7087..04db626 100755
> --- a/tests/overlay/045
> +++ b/tests/overlay/045
> @@ -37,6 +37,7 @@ _require_attrs
>  _require_command "$FSCK_OVERLAY_PROG" fsck.overlay
>
>  OVL_XATTR_OPAQUE_VAL=y
> +OVL_XATTR_IMPURE_VAL=y
>
>  # remove all files from previous tests
>  _scratch_mkfs
> @@ -69,6 +70,15 @@ make_opaque_dir()
>         $SETFATTR_PROG -n $OVL_XATTR_OPAQUE -v $OVL_XATTR_OPAQUE_VAL $target
>  }
>
> +# Create impure directories
> +make_impure_dir()
> +{
> +       for dir in $*; do
> +               mkdir -p $dir
> +               $SETFATTR_PROG -n $OVL_XATTR_IMPURE -v $OVL_XATTR_IMPURE_VAL $dir
> +       done
> +}
> +
>  # Create a redirect directory
>  make_redirect_dir()
>  {
> @@ -79,6 +89,19 @@ make_redirect_dir()
>         $SETFATTR_PROG -n $OVL_XATTR_REDIRECT -v $value $target
>  }
>
> +# Run fsck.overlay and check return value
> +run_fsck()
> +{
> +       local expect=$1
> +       shift 1
> +
> +       _overlay_fsck_dirs $* >> $seqres.full 2>&1
> +       fsck_ret=$?
> +
> +       [[ "$fsck_ret" == "$expect" ]] || \
> +               echo "fsck return unexpected:$expect,$fsck_ret"
> +}
> +

This helper repeats in every overlay/fsck test.
Move it to be a common function?

Thanks,
Amir.

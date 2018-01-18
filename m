From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [xfstest PATCH v4 1/7] overlay: add filesystem check helper
Date: Thu, 18 Jan 2018 10:11:22 +0200
Message-ID: <CAOQ4uxjixUZHa482=5cXxbgjCumH489Qi53-3+-vU-SbgOYqLg@mail.gmail.com>
References: <20180118040033.19555-1-yi.zhang@huawei.com> <20180118040033.19555-2-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180118040033.19555-2-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jan 18, 2018 at 6:00 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Add filesystem check helpers for the upcoming fsck.overlay utility,
> and hook them to _check_test_fs and _check_scratch_fs. This helper
> works only if fsck.overlay exists.
>
> [ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  common/config  |  1 +
>  common/overlay | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc      |  4 +--
>  3 files changed, 91 insertions(+), 2 deletions(-)
>
> diff --git a/common/config b/common/config
> index d0fbfe5..0505b71 100644
> --- a/common/config
> +++ b/common/config
> @@ -236,6 +236,7 @@ case "$HOSTOS" in
>          export MKFS_REISER4_PROG="`set_prog_path mkfs.reiser4`"
>         export E2FSCK_PROG="`set_prog_path e2fsck`"
>         export TUNE2FS_PROG="`set_prog_path tune2fs`"
> +       export FSCK_OVERLAY_PROG="`set_prog_path fsck.overlay`"
>          ;;
>  esac
>
> diff --git a/common/overlay b/common/overlay
> index 1da4ab1..8c9528f 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -151,3 +151,91 @@ _require_scratch_overlay_feature()
>                 _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
>         _scratch_unmount
>  }
> +
> +# Require the same scratch device as _require_scratch, but do not check
> +# the constants OVL_LOWER/OVL_UPPER/OVL_WORK dirs, should use together
> +# with optionally lower/upper/work dirs and check explicitly after test.
> +_require_overlay_scratch_dirs()
> +{
> +       _require_scratch_nocheck
> +}
> +

I think you better introduce this helper along with the patch that uses it,
along with maybe _overlay_check_scratch_dirs(), which unlike _overlay_check_dirs
needs to umount $SCRATCH_MNT.

> +_overlay_fsck_dirs()
> +{
> +       local lowerdir=$1
> +       local upperdir=$2
> +       local workdir=$3
> +       local options=$4
> +
> +       [[ ! -x "$FSCK_OVERLAY_PROG" ]] && return 0
> +
> +       $FSCK_OVERLAY_PROG -o lowerdir=$lowerdir -o upperdir=$upperdir \
> +                          -o workdir=$workdir $options
> +}
> +
> +_overlay_check_dirs()
> +{
> +       local lowerdir=$1
> +       local upperdir=$2
> +       local workdir=$3
> +       local err=0
> +
> +       _overlay_fsck_dirs $* $FSCK_OPTIONS >>$tmp.fsck 2>&1
> +       if [ $? -ne 0 ]; then
> +               _log_err "_overlay_check_fs: overlayfs on $lowerdir,$upperdir,$workdir is inconsistent"
> +               echo "*** fsck.overlay output ***"      >>$seqres.full
> +               cat $tmp.fsck                           >>$seqres.full
> +               echo "*** end fsck.overlay output"      >>$seqres.full
> +
> +               echo "*** mount output ***"             >>$seqres.full
> +               _mount                                  >>$seqres.full
> +               echo "*** end mount output"             >>$seqres.full
> +               err=1
> +       fi
> +       rm -f $tmp.fsck
> +
> +       if [ $err != 0 ]; then
> +               status=1
> +               if [ "$iam" != "check" ]; then
> +                       exit 1
> +               fi
> +               return 1
> +       fi
> +
> +       return 0
> +}
> +
> +_overlay_check_fs()
> +{
> +       local base_dev=$3
> +       local base_mnt=$4
> +
> +       [ "$FSTYP" = overlay ] || return 0
> +
> +       # Base fs needs to be mounted to check overlay dirs
> +       local mounted=""
> +       [ -z "$base_dev" ] || mounted=`_is_mounted $base_dev`
> +       [ -n "$mounted" ] || _overlay_base_mount $*
> +
> +       # No need to umount overlay for dir checks with default -n option
> +       _overlay_check_dirs $base_mnt/$OVL_LOWER $base_mnt/$OVL_UPPER \
> +                           $base_mnt/$OVL_WORK
> +       local ret=$?
> +
> +       [ -n "$mounted" ] || _overlay_base_unmount "$base_dev" "$base_mnt"
> +       return $ret
> +}
> +
> +_check_overlay_test_fs()
> +{
> +       _overlay_check_fs OVL_BASE_TEST_DEV OVL_BASE_TEST_DIR \
> +               "$OVL_BASE_TEST_DEV" "$OVL_BASE_TEST_DIR" \
> +               $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS
> +}
> +
> +_check_overlay_scratch_fs()
> +{
> +       _overlay_check_fs OVL_BASE_SCRATCH_DEV OVL_BASE_SCRATCH_MNT \
> +               "$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT" \
> +               $OVL_BASE_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
> +}
> diff --git a/common/rc b/common/rc
> index 9216efd..a49f736 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2537,7 +2537,7 @@ _check_test_fs()
>         # no way to check consistency for GlusterFS
>         ;;
>      overlay)
> -       # no way to check consistency for overlay
> +       _check_overlay_test_fs
>         ;;
>      pvfs2)
>         ;;
> @@ -2592,7 +2592,7 @@ _check_scratch_fs()
>         # no way to check consistency for GlusterFS
>         ;;
>      overlay)
> -       # no way to check consistency for overlay
> +       _check_overlay_scratch_fs
>         ;;
>      pvfs2)
>         ;;
> --
> 2.9.5
>

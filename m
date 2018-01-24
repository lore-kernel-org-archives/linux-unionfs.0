From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [xfstests PATCH v6 2/8] overlay: add filesystem check helper
Date: Wed, 24 Jan 2018 11:31:36 +0200
Message-ID: <CAOQ4uxjwrFDKn6iYTNLA02z-GvG-X+72Vs4TYs1sL0_8wiuksg@mail.gmail.com>
References: <20180124073344.31970-1-yi.zhang@huawei.com> <20180124073344.31970-3-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:44086 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932606AbeAXJbi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Jan 2018 04:31:38 -0500
In-Reply-To: <20180124073344.31970-3-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On Wed, Jan 24, 2018 at 9:33 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Add filesystem check helpers for the upcoming fsck.overlay utility.
> Hook these helpers to _check_test_fs and _check_scratch_fs for constants
> underlying dirs of overlay filesystem, and introduce scratch check helpers
> for optionally lower/upper/work dirs. These helpers works only if
> fsck.overlay exists.
>
> [ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  common/config  |   1 +
>  common/overlay | 132 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc      |   4 +-
>  3 files changed, 135 insertions(+), 2 deletions(-)
>
> diff --git a/common/config b/common/config
> index 5f40413..71115bd 100644
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
> index 1da4ab1..ce3f279 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -151,3 +151,135 @@ _require_scratch_overlay_feature()
>                 _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
>         _scratch_unmount
>  }
> +
> +# Require the same scratch device as _require_scratch, but do not check
> +# the constants OVL_LOWER/OVL_UPPER/OVL_WORK dirs, should use together
> +# with optionally lower/upper/work dirs and do check explicitly after test.
> +_require_overlay_scratch_dirs()
> +{
> +       _require_scratch_nocheck
> +}
> +
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
> +
> +               echo "*** fsck.overlay output ***"      >>$seqres.full
> +               cat $tmp.fsck                           >>$seqres.full
> +               echo "*** end fsck.overlay output"      >>$seqres.full
> +
> +               echo "*** mount output ***"             >>$seqres.full
> +               _mount                                  >>$seqres.full
> +               echo "*** end mount output"             >>$seqres.full
> +
> +               err=1
> +       fi
> +       rm -f $tmp.fsck
> +
> +       return $err
> +}
> +
> +# Check the same mnt/dev of _check_overlay_scratch_fs, but check optionally
> +# lower/upper/work dirs of overlay filesystem, should use together with
> +# _require_overlay_scratch_dirs
> +_overlay_check_scratch_dirs()
> +{
> +       local lowerdir=$1
> +       local upperdir=$2
> +       local workdir=$3
> +
> +       # Need to umount overlay for scratch dir check
> +       local ovl_mounted=`_is_mounted $SCRATCH_MNT overlay`

Here the argument 'overlay' seem redundant because _is_mounted
can check $FSTYP

> +       [ -z "$ovl_mounted" ] || $UMOUNT_PROG $SCRATCH_MNT
> +
> +       _overlay_check_dirs $lowerdir $upperdir $workdir
> +       local ret=$?
> +
> +       if [ $ret -eq 0 -a -n "$ovl_mounted" ]; then
> +               # overlay was mounted, remount besides extra mount options
> +               _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
> +               ret=$?
> +       fi
> +
> +       return $ret
> +}
> +
> +_overlay_check_fs()
> +{
> +       local ovl_mnt=$1
> +       local base_dev=$4
> +       local base_mnt=$5
> +       shift 1
> +
> +       [ "$FSTYP" = overlay ] || return 0
> +
> +       # Base fs needs to be mounted to check overlay dirs
> +       local base_mounted=""
> +       [ -z "$base_dev" ] || base_mounted=`_is_mounted $base_dev`

That looks like I have a bug in my original implementation of _overlay_check_fs
because $FSTYP" = overlay _is_mounted here will not actually find a mounted
base dev. Need to pass $OVL_BASE_FSTYP to your improved _is_mounted
helper.
No?

> +
> +       if [ -z "$base_mounted" ]; then
> +               _overlay_base_mount $*
> +       else
> +               # Need to umount overlay for dir check
> +               local ovl_mounted=`_is_mounted $ovl_mnt overlay`
> +               [ -z "$ovl_mounted" ] || $UMOUNT_PROG $ovl_mnt
> +       fi
> +
> +       _overlay_check_dirs $base_mnt/$OVL_LOWER $base_mnt/$OVL_UPPER \
> +                           $base_mnt/$OVL_WORK
> +       local ret=$?
> +
> +       if [ -z "$base_mounted" ]; then
> +               _overlay_base_unmount "$base_dev" "$base_mnt"
> +       elif [ $ret -eq 0 -a -n "$ovl_mounted" ]; then
> +               # overlay was mounted, remount besides extra mount options
> +               _overlay_mount $base_mnt $ovl_mnt
> +               ret=$?
> +       fi
> +
> +       if [ $ret != 0 ]; then
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
> +_check_overlay_test_fs()
> +{
> +       _overlay_check_fs "$TEST_DIR" \
> +               OVL_BASE_TEST_DEV OVL_BASE_TEST_DIR \
> +               "$OVL_BASE_TEST_DEV" "$OVL_BASE_TEST_DIR" \
> +               $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS
> +}
> +
> +_check_overlay_scratch_fs()
> +{
> +       _overlay_check_fs "$SCRATCH_MNT" \
> +               OVL_BASE_SCRATCH_DEV OVL_BASE_SCRATCH_MNT \
> +               "$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_MNT" \
> +               $OVL_BASE_MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS
> +}
> diff --git a/common/rc b/common/rc
> index 2e7aee5..b2faf9a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2590,7 +2590,7 @@ _check_test_fs()
>         # no way to check consistency for GlusterFS
>         ;;
>      overlay)
> -       # no way to check consistency for overlay
> +       _check_overlay_test_fs
>         ;;
>      pvfs2)
>         ;;
> @@ -2648,7 +2648,7 @@ _check_scratch_fs()
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
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

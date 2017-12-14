From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH for xfstests 1/4] overlay: add filesystem check helper
Date: Thu, 14 Dec 2017 11:05:24 +0200
Message-ID: <CAOQ4uximBJqFpsBMLQMWTJpJsoigBnYemtb7z1h-3PPWyjrkXA@mail.gmail.com>
References: <20171214064846.21587-1-yi.zhang@huawei.com> <20171214064846.21587-2-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:46135 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbdLNJFZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 04:05:25 -0500
In-Reply-To: <20171214064846.21587-2-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>

On Thu, Dec 14, 2017 at 8:48 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Add filesystem check helpers for the upcoming fsck.overlay utility,
> and hook them to _check_test_fs and _check_scratch_fs. This helper
> works only if fsck.overlay exists.
>
> [ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  common/config  |  1 +
>  common/overlay | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc      |  4 +--
>  3 files changed, 81 insertions(+), 2 deletions(-)
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
> index 1da4ab1..689799c 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -151,3 +151,81 @@ _require_scratch_overlay_feature()
>                 _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
>         _scratch_unmount
>  }
> +
> +_overlay_fsck_dirs()
> +{
> +       local options=$1
> +       local lowerdir=$2
> +       local upperdir=$3
> +       local workdir=$4
> +
> +       [[ ! -x "$FSCK_OVERLAY_PROG" ]] && return 0
> +
> +       $FSCK_OVERLAY_PROG $options -l $lowerdir -u $upperdir -w $workdir
> +}
> +
> +_overlay_check_dirs()
> +{
> +       local lowerdir=$1
> +       local upperdir=$2
> +       local workdir=$3
> +       local err=0
> +
> +       _overlay_fsck_dirs $FSCK_OPTIONS $* >>$tmp.fsck 2>&1
> +       if [ $? -ne 0 ]; then
> +               _log_err "_overlay_check_fs: overlayfs on $lowerdir,$upperdir,$workdir is inconsistent"
> +               echo "*** fsck.overlay output ***"      >>$seqres.full
> +               cat $tmp.fsck                           >>$seqres.full
> +               echo "*** end fsck.overlay output"      >>$seqres.full
> +               echo "*** mount output ***"             >>$seqres.full
> +               _mount                                  >>$seqres.full
> +               echo "*** end mount output"             >>$seqres.full
> +               err=1
> +       fi

Maybe the tmp.fsck output reporting to seqres.full should be done in
_overlay_fsck_dirs?
I think this output could be useful for understanding fsck tests failure.

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
> index 4c053a5..0837637 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2507,7 +2507,7 @@ _check_test_fs()
>         # no way to check consistency for GlusterFS
>         ;;
>      overlay)
> -       # no way to check consistency for overlay
> +       _check_overlay_test_fs
>         ;;
>      pvfs2)
>         ;;
> @@ -2562,7 +2562,7 @@ _check_scratch_fs()
>         # no way to check consistency for GlusterFS
>         ;;
>      overlay)
> -       # no way to check consistency for overlay
> +       _check_overlay_test_fs

_check_overlay_scratch_fs

Thanks,
Amir.

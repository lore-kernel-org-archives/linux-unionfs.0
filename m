From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [xfstests PATCH 2/5] overlay: hook filesystem check helper
Date: Thu, 25 Jan 2018 10:21:17 +0200
Message-ID: <CAOQ4uxia8y4xWwcx-6bvLxqv=E4i_oytZxQQ=VHDKCH0rCKpsg@mail.gmail.com>
References: <20180125063949.12916-1-yi.zhang@huawei.com> <20180125063949.12916-3-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:44539 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbeAYIVS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 Jan 2018 03:21:18 -0500
In-Reply-To: <20180125063949.12916-3-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On Thu, Jan 25, 2018 at 8:39 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hook filesystem check helper to _check_test_fs and _check_scratch_fs for
> constants underlying dirs of overlay filesystem, and introduce scratch
> check helpers for optionally lower/upper/work dirs. These helpers works
> only if fsck.overlay exists.
>
> [ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  common/overlay | 120 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc      |   4 +-
>  2 files changed, 122 insertions(+), 2 deletions(-)
>
> diff --git a/common/overlay b/common/overlay
> index c19dabc..524976f 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -152,6 +152,14 @@ _require_scratch_overlay_feature()
>         _scratch_unmount
>  }
>
> +# Require the same scratch device as _require_scratch, but do not check
> +# the constants OVL_LOWER/OVL_UPPER/OVL_WORK dirs, should use together
> +# with optionally lower/upper/work dirs and do check explicitly after test.
> +_require_overlay_scratch_dirs()
> +{
> +       _require_scratch_nocheck
> +}
> +
>  # Helper function to check underlying dirs of overlay filesystem
>  _overlay_fsck_dirs()
>  {
> @@ -165,3 +173,115 @@ _overlay_fsck_dirs()
>         $FSCK_OVERLAY_PROG -o lowerdir=$lowerdir -o upperdir=$upperdir \
>                            -o workdir=$workdir $options
>  }
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
> +       local ovl_mounted=`_is_mounted $SCRATCH_MNT`
> +       [ -z "$ovl_mounted" ] || $UMOUNT_PROG $SCRATCH_MNT
> +
> +       _overlay_check_dirs $lowerdir $upperdir $workdir
> +       local ret=$?
> +
> +       if [ $ret -eq 0 -a -n "$ovl_mounted" ]; then
> +               # overlay was mounted, remount besides extra mount options
> +               _overlay_scratch_mount_dirs $lowerdir $upperdir $workdir

I think that 'shift 3' and passing $* to _overlay_scratch_mount_dirs
would be good practice here.
Especially, because extra mount options may affect fsck.overlay
someday. Imagine that fsck.overlay ... -oindex=on may be used to
verify consistency and rebuild index for hardlinks and -onfs_export=on may
be used to specify consistency check and rebuild of index for all
files and directories.

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

This shift 1 is confusing. Should document that it aligns arguments for
_overlay_base_mount. Probably would be nicer to shift right after assigning
ovl_mnt and then assign $3/$4 to base_dev/mnt.

Nice to review my own patch ;-)

> +
> +       [ "$FSTYP" = overlay ] || return 0
> +
> +       # Base fs needs to be mounted to check overlay dirs
> +       local base_mounted=""
> +       [ -z "$base_dev" ] || \
> +               base_mounted=`_is_mounted $base_dev $OVL_BASE_FSTYP`

Not that I am proposing to support -overlay run where FSTYP is not
defined in config file, but how does this behave in such a case?
Perhaps add || [ -z "$OVL_BASE_FSTYP" ] above?

> +
> +       if [ -z "$base_mounted" ]; then
> +               _overlay_base_mount $*
> +       else
> +               # Need to umount overlay for dir check
> +               local ovl_mounted=`_is_mounted $ovl_mnt`

Define local outside if scope.

Thanks,
Amir.

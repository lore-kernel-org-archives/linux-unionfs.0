From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [xfstests PATCH 1/4] overlay: add filesystem check helper
Date: Thu, 25 Jan 2018 10:00:24 +0200
Message-ID: <CAOQ4uxhz49=tcue+iC1NqfFjzS=TiwrmoMu+M3RvdRdK2VVQBw@mail.gmail.com>
References: <20180125063413.8720-1-yi.zhang@huawei.com> <20180125063413.8720-2-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180125063413.8720-2-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jan 25, 2018 at 8:34 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Add filesystem check helper for the upcoming fsck.overlay utility.
> This helper invoke fsck.overlay to check and optionally repair
> underlying directories of overlay filesystem.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/config  |  1 +
>  common/overlay | 14 ++++++++++++++
>  2 files changed, 15 insertions(+)
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
> index 1da4ab1..c19dabc 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -151,3 +151,17 @@ _require_scratch_overlay_feature()
>                 _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
>         _scratch_unmount
>  }
> +
> +# Helper function to check underlying dirs of overlay filesystem
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

I guess current tests do not use more than a single "options", but for
robustness,
probably better to 'shift 3' and pass $* to fsck.overlay, just like
_overlay_mount_dirs.

Thanks,
Amir.

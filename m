From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 1/3] common/rc: add scratch shutdown support for overlayfs
Date: Thu, 7 Dec 2017 04:54:04 +0200
Message-ID: <CAOQ4uxgUj8GtznejtF=3L4VMd-N2-MsgCb-+h=3OkOv5hFCvnQ@mail.gmail.com>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:45535 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751990AbdLGCyF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 21:54:05 -0500
In-Reply-To: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Dec 7, 2017 at 4:22 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
>
> Changes since v1:
> _scratch_shutdown() does not call notrun.
>
>  common/rc | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index 4c053a5..911dba3 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -382,6 +382,15 @@ _scratch_cycle_mount()
>      _scratch_mount "$opts"
>  }
>
> +_scratch_shutdown()
> +{
> +       if [ $FSTYP = "overlay" ]; then

You need the OVL_BASE_SCRATCH_DEV protection here as well.
Yes, test SHOULD have _require_scratch_shutdown() before calling
_scratch_shutdown(), but if test is not compliant worst case is that
test "fails" instead of "not run", but NOT that host fs is shutdown.

> +               src/godown -f $OVL_BASE_SCRATCH_MNT
> +       else
> +               src/godown -f $SCRATCH_MNT
> +       fi
> +}
> +
>  _test_mount()
>  {
>      if [ "$FSTYP" == "overlay" ]; then
> @@ -2908,8 +2917,19 @@ _require_scratch_shutdown()
>
>         _scratch_mkfs > /dev/null 2>&1
>         _scratch_mount
> -       src/godown -f $SCRATCH_MNT 2>&1 \
> -               || _notrun "$FSTYP does not support shutdown"
> +
> +       if [ $FSTYP = "overlay" ]; then
> +               if [ -z $OVL_BASE_SCRATCH_DEV ]; then
> +                       _notrun "$SCRATCH_DEV is not a block device"
> +               else
> +                       src/godown -f $OVL_BASE_SCRATCH_MNT 2>&1 \
> +                       || _notrun "Underlying filesystem does not support shutdown"
> +               fi
> +       else
> +               src/godown -f $SCRATCH_MNT 2>&1 \
> +                       || _notrun "$FSTYP does not support shutdown"
> +       fi
> +
>         _scratch_unmount
>  }
>
> --
> 1.8.3.1
>

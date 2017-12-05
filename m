From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] common/rc: Add syncfs check and a helper _scratch_shutdown()
Date: Tue, 5 Dec 2017 18:13:35 +0200
Message-ID: <CAOQ4uxi35dTxBJSXPjVnx7Ei+Mfud2370Pikzf6KEESpGLdFog@mail.gmail.com>
References: <2D8A66F2-6AB9-4B7D-90B0-D3B6807FB353@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:43562 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbdLEQNg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Dec 2017 11:13:36 -0500
In-Reply-To: <2D8A66F2-6AB9-4B7D-90B0-D3B6807FB353@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Dec 5, 2017 at 5:50 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
> 1. Add a check case in _require_xfs_io_command() to support syncfs.
> 2. Introduce a helper to support scratch shutdown for overlayfs.
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
> common/rc | 22 ++++++++++++++++++++--
> 1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index 4c053a5..e36ee24 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -669,6 +669,21 @@ _scratch_cleanup_files()
>         esac
> }
>
> +_scratch_shutdown()
> +{
> +
> +       case $FSTYP in
> +       overlay)

Looks good,
but first you need to check for [ -z "$OVL_BASE_SCRATCH_MNT" ]
meaning that tester is using "old" overlay config and we are not allowed to
mess with base fs.

> +               src/godown -f $OVL_BASE_SCRATCH_MNT 2>&1 \
> +                       || _notrun "Underlying filesystem does not support shutdown"
> +               ;;
> +       *)
> +               src/godown -f $SCRATCH_MNT 2>&1 \
> +                       || _notrun "$FSTYP does not support shutdown"
> +               ;;
> +       esac
> +}
> +
> _scratch_mkfs()
> {
>         local mkfs_cmd=""
> @@ -2087,6 +2102,10 @@ _require_xfs_io_command()
>         "utimes" )
>                 testio=`$XFS_IO_PROG -f -c "utimes" 0 0 0 0 $testfile 2>&1`
>                 ;;
> +       "syncfs")
> +               touch $testfile
> +               testio=`$XFS_IO_PROG -c "syncfs" $testfile 2>&1`
> +               ;;
>         *)
>                 testio=`$XFS_IO_PROG -c "help $command" 2>&1`
>         esac
> @@ -2908,8 +2927,7 @@ _require_scratch_shutdown()
>
>         _scratch_mkfs > /dev/null 2>&1
>         _scratch_mount
> -       src/godown -f $SCRATCH_MNT 2>&1 \
> -               || _notrun "$FSTYP does not support shutdown"
> +       _scratch_shutdown
>         _scratch_unmount
> }
>
> --
> 1.8.3.1

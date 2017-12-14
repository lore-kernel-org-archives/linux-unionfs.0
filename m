From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 2/3] common/rc: check syncfs support
Date: Thu, 14 Dec 2017 16:35:04 +0200
Message-ID: <CAOQ4uxhTX6Nc+4s2RKGLdB97hA6HS-XzPC4Q9pX7Gbe9S+PTeg@mail.gmail.com>
References: <1513261145-127502-1-git-send-email-cgxu519@icloud.com> <1513261145-127502-2-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:33079 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753161AbdLNOfF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 09:35:05 -0500
In-Reply-To: <1513261145-127502-2-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Dec 14, 2017 at 4:19 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
> common/rc: add a check case in _require_xfs_io_command() to support syncfs
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>

looks good.

> ---
>  common/rc | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/common/rc b/common/rc
> index fc9a4f5..da7c827 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2106,6 +2106,10 @@ _require_xfs_io_command()
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
> --
> 1.8.3.1
>

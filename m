From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 5/7] overlay/003: fix fs check failure
Date: Fri, 12 Jan 2018 21:12:29 +0200
Message-ID: <CAOQ4uxhZdqokitG7VX5OFawYASGebO4xV+-e_+0M+QXUXKKsRg@mail.gmail.com>
References: <20180112120533.6099-1-yi.zhang@huawei.com> <20180112120533.6099-6-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:43381 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964998AbeALTMa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Jan 2018 14:12:30 -0500
In-Reply-To: <20180112120533.6099-6-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On Fri, Jan 12, 2018 at 2:05 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> _check_overlay_scratch_fs() will check lowerdir of overlay filesystem,
> this case remove this directory after test will lead to check failure,
> and it is not really necessary to remove this directory, so keep this
> directory.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Looks correct,

Amir.

> ---
>  tests/overlay/003 | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/tests/overlay/003 b/tests/overlay/003
> index f980edb..154531e 100755
> --- a/tests/overlay/003
> +++ b/tests/overlay/003
> @@ -92,7 +92,6 @@ ls ${SCRATCH_MNT}/
>  # unmount overlayfs but not base fs
>  $UMOUNT_PROG $SCRATCH_MNT
>
> -rm -rf $lowerdir
>  echo "Silence is golden"
>  # success, all done
>  status=0
> --
> 2.9.5
>

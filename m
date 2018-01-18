From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [xfstest PATCH v4 5/7] overlay/003: fix fs check failure
Date: Thu, 18 Jan 2018 10:01:07 +0200
Message-ID: <CAOQ4uxiBFZek8ABfbG+czmCRkMDw-NVeD7nv8jJ9MxARaoVgNw@mail.gmail.com>
References: <20180118040033.19555-1-yi.zhang@huawei.com> <20180118040033.19555-6-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:42000 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754087AbeARIBI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jan 2018 03:01:08 -0500
In-Reply-To: <20180118040033.19555-6-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com

On Thu, Jan 18, 2018 at 6:00 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> _check_overlay_scratch_fs() will check lowerdir of overlay filesystem,
> this case remove this directory after test will lead to check failure,
> and it is not really necessary to remove this directory, so keep this
> directory.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

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

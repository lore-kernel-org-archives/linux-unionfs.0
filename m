From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [xfstests PATCH] overlay: test whiteout check in impure dir
Date: Mon, 19 Jun 2017 08:40:35 +0300
Message-ID: <CAOQ4uxgKAnLBnjF2ynTW-iLbV9m647XhnzquV37xzkBwqG-=5Q@mail.gmail.com>
References: <1497844419-23824-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:34075 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbdFSFkg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 01:40:36 -0400
In-Reply-To: <1497844419-23824-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On Mon, Jun 19, 2017 at 6:53 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> The unmerged and impure upper directories may contain invalid
> whiteouts when we umount && modify lowerdir(e.g. clean up dir) and
> remount overlay. This may lead to whiteouts exposure and rmdir
> failure.
>
> This case test impure dir's whiteouts check in ovl_iterate() and
> ovl_remove_xxx().
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Looks good

Reviewed-by: Amir Goldstein <amir73il@gmail.com>


> --- a/tests/overlay/group
> +++ b/tests/overlay/group
> @@ -33,3 +33,4 @@
>  028 auto copyup quick
>  029 auto quick
>  030 auto quick perms
> +031 auto quick

Maybe add "whiteout"

From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH v3] ovl: fix rmdir problem on impure dir
Date: Sun, 25 Jun 2017 17:19:58 +0300
Message-ID: <CAOQ4uxjg4WcZgNxD0M27xm2Wp5BRgKO5=hj-wtxwWdrXxCTVPA@mail.gmail.com>
References: <1498283869-17623-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33286 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751172AbdFYOT7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Jun 2017 10:19:59 -0400
Received: by mail-ot0-f193.google.com with SMTP id q16so9203306otb.0
        for <linux-unionfs@vger.kernel.org>; Sun, 25 Jun 2017 07:19:59 -0700 (PDT)
In-Reply-To: <1498283869-17623-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On Sat, Jun 24, 2017 at 8:57 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> If an "impure && not merged" upper dir have left whiteouts
> (last mount created), ovl cannot clear this dir when we
> removing it, which may lead to rmdir fail or temp file left
> in workdir.
>
> Simple reproducer:
>   mkdir lower upper work merge
>   mkdir -p lower/dir
>   touch lower/dir/a
>   mount -t overlay overlay -olowerdir=lower,upperdir=upper,\
>     workdir=work merge
>   rm merge/dir/a
>   umount merge
>   rm -rf lower/*
>   touch lower/dir  (*)
>   mount -t overlay overlay -olowerdir=lower,upperdir=upper,\
>     workdir=work merge
>   rm -rf merge/dir
>
> Syslog dump:
>   overlayfs: cleanup of 'work/#7' failed (-39)
>
> (*): if we are not creat this file, the result is different:
>   rm: cannot remove "dir/": Directory not empty
>
> This patch add explicitly check of OVL_XATTR_ORIGIN, use
> (merge || origin) to indicate the dir may have whiteouts.
> Finally, check and clean up the dir when deleting it.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>
> ---
> V3:
>  - use origin instead of impure flag
>  - add check in ovl_rename()
>
> V2:
>  - fix comment in ovl_remove_and_whiteout()
>  - post reproducer to xfstest
>
> ---

Sorry, completely missed the part where you don't prevent
exposing of whiteouts in readdir.
I posted a patch that can either be picked by itself of squashed with this one.


>  fs/overlayfs/dir.c       | 20 ++++++++++++++++----
>  fs/overlayfs/overlayfs.h |  1 +
>  fs/overlayfs/util.c      | 13 +++++++++++++
>  3 files changed, 30 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index a63a716..cbad42f 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -178,6 +178,14 @@ static bool ovl_type_origin(struct dentry *dentry)
>         return OVL_TYPE_ORIGIN(ovl_path_type(dentry));
>  }
>
> +static bool ovl_is_origin(struct dentry *dentry)
> +{
> +       if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
> +               return false;
> +

I am not so sure that !OVL_TYPE_UPPER should be skipped.
in case of ovl_rename() new can be lower with origin and with
whiteouts, that that lower was once used as upper.

Please extend your xfstest to check that whiteouts are not
exposed also when a former upper layer with origin is
used in a mount as a lower layer.

Thanks,
Amir.

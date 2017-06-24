From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH v3] ovl: fix rmdir problem on impure dir
Date: Sat, 24 Jun 2017 18:55:03 +0300
Message-ID: <CAOQ4uxjsc6TiMyNWuoKUk3pNa_jEa3Ov_mfFfB6jvEd+XR9xVQ@mail.gmail.com>
References: <1498283869-17623-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33165 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdFXPzE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 24 Jun 2017 11:55:04 -0400
Received: by mail-ot0-f193.google.com with SMTP id q16so7638218otb.0
        for <linux-unionfs@vger.kernel.org>; Sat, 24 Jun 2017 08:55:04 -0700 (PDT)
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

Looks good.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

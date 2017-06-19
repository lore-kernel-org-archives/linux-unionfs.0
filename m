From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH V2] ovl:fix rmdir problem on impure dir
Date: Mon, 19 Jun 2017 09:59:18 +0200
Message-ID: <CAJfpegvMjzLuP5YaTXaXTmVeFW7xEMRNOk_5nUoaSR=zRtS9MA@mail.gmail.com>
References: <1497844832-24767-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34957 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753776AbdFSH7U (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 03:59:20 -0400
Received: by mail-oi0-f50.google.com with SMTP id c189so27080874oia.2
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jun 2017 00:59:19 -0700 (PDT)
In-Reply-To: <1497844832-24767-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, Amir Goldstein <amir73il@gmail.com>, miaoxie@huawei.com

On Mon, Jun 19, 2017 at 6:00 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> There is another problem about impure upper dir which have left
> whiteout files(the first one is whiteout exposure). If an
> "impure && not merged" upper dir have left whiteout files
> (last mount created), ovl cannot clear this dir when we
> removing it, which may lead to rmdir fail or temp file left
> in workdir.
>
> Reproducer:
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
> This patch add impure flag on parent dir in ovl_remove_and_whiteout()
> to indicate the dir is impure, and then check and clean it when
> removing this dir.

I still don't like adding the impure flag because of a whiteout.
Impure dir means it contains a copied up object.  In fact a valid (but
probably not worthwhile) optimizition would be to remove the impure
flag on removal of the last copied up object.

What's wrong with testing for (origin || merge) to see if we need to
check for whiteouts?

Thanks,
Miklos

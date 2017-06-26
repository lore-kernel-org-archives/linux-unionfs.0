From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH v3] ovl: fix rmdir problem on impure dir
Date: Mon, 26 Jun 2017 13:19:42 +0300
Message-ID: <CAOQ4uxg4epd0RzZFF6swO_KgffXoUuvS1Tmeamf6Y2LCSwc5gQ@mail.gmail.com>
References: <1498283869-17623-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:34405 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdFZKTo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 26 Jun 2017 06:19:44 -0400
Received: by mail-ot0-f196.google.com with SMTP id p48so10795084otc.1
        for <linux-unionfs@vger.kernel.org>; Mon, 26 Jun 2017 03:19:43 -0700 (PDT)
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

Sorry, I keep finding more stuff...

>  {
> @@ -331,12 +339,14 @@ static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
>          * replace it with an exact replica of itself.
>          *
>          * If no upperdentry then skip clearing whiteouts.
> +        * Origined directory may have whiteouts, should clean up.
>          *
>          * Can race with copy-up, since we don't hold the upperdir mutex.
>          * Doesn't matter, since copy-up can't create a non-empty directory
>          * from an empty one.
>          */
> -       if (OVL_TYPE_UPPER(type) && OVL_TYPE_MERGE(type))
> +       if (OVL_TYPE_UPPER(type) && (OVL_TYPE_MERGE(type) ||
> +                                    ovl_is_origin(dentry)))
>                 ret = ovl_clear_empty(dentry, &list);
>

We may have been a little stupid here.
It does not matter if MERGE/ORIGIN/whatever.
We already checked for whiteout existence in ovl_check_empty_dir(),
so actually ovl_clear_empty() is needed IFF
!OVL_TYPE_UPPER(type) && !list_empty(&list).

Actually, list can be non-empty due to whiteouts in lower dir
and then ovl_cleanup_whiteouts() will report errors when trying to
cleanup those lower whiteouts (if I am reading the code correctly).
Please test case of whiteouts in both lower and upper dirs of a merge
dir. rmdir may succeed, but with errors.

To fix this properly, need another hunk of my readdir patch (that's
actually a hunk I stole off Miklos' old readdir patch) that stores the
p->idx field in the list/cache.

Then, ovl_check_empty_dir() can return a list of elements with
(p->is_whiteout && p->idx == 0) and ovl_cleanup_whiteouts() can
can be called IFF !list_empty(&list) to clean them.

Amir.

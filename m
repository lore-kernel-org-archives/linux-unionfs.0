From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH V4] ovl: fix rmdir problem on origin dir
Date: Wed, 28 Jun 2017 13:24:33 +0300
Message-ID: <CAOQ4uxjXkwBCG3fiNEg1OoS-14YsKz=QvDajvobTDoS7z9x64g@mail.gmail.com>
References: <1498641351-36052-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35762 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbdF1KYf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Jun 2017 06:24:35 -0400
Received: by mail-oi0-f67.google.com with SMTP id l130so5024254oib.2
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Jun 2017 03:24:35 -0700 (PDT)
In-Reply-To: <1498641351-36052-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On Wed, Jun 28, 2017 at 12:15 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> If an "origin && not merged" upper dir have leftover whiteouts
> (last mount created), ovl do not clear this dir when we
> deleting it, which may lead to rmdir fail or temp file left
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
> This patch add explicitly check of OVL_XATTR_ORIGIN, and filter
> out whiteouts in upperdentry in ovl_check_empty_dir(). Finally,
> check and clear the dir when deleting it.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Thanks for the attribution, but you can't sign on my behalf.
Besides, as I wrote, the p->idx bits from my patch are attributed
to Miklos anyway, who is going to sign off your patch before he
merges it anyway, so don't worry about it.

You may add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

one nits below - don't feel obliged to fix it

> ---
> Hi Amir,
>
> I pick out "idx" part from your readdir patch to filter
> out upper whiteouts in ovl_check_empty_dir(), and check
> !list_empty(&list) to call ovl_clear_empty(). I have test
> it use my xfstest/031 V2.

Excellent.

>
> BTW, I have a question, many features of overlayfs rely
> on xattr/whiteouts of underlaying dir now, but xattr may
> have some inconformity before we mount overlayfs or
> "umount --> modify underlaying dir --> mount again"
> (.e.g this whiteout case), so we cannot guarantee it's
> behavior meet users expectations. Do you think we can make
> a tools like e2fsck of Extfs in the future, let users to
> check underlaying dir before mount? I think it can do the
> following things:
>
> (1) Check invalid whiteouts and auto fix or ask user.
> (2) Check redirect/impure/opaque xattr.
(3) Check origin of merge dirs and auto fix them or ask user


I think having to create fsck.overlay is inevitable.
With the new inode index feature, a lot more can and needs to
be checked. Specifically, inodes index checks that lower root dir
matches origin stored in upper root dir and fails to mount overlay.

In order to allow mounting an indexed overlay after copying
layers (to new lower inodes), a tool must be provided to perform
'checkpoint/restart' functionality, which converts 'origin' xattr
(by fh) to 'redirect' xattr (by path) and vice versa.

As part of my TODO for overlayfs snapshots, I must deal with
the 'checkpoint' part, so I do plan to start a poor mans
implementation of an overlayfs-utils tool, but I have no plans to
maintain a proper distribution packaged tool at community standard.

If you wish to start writing a proper tool, which performs the checks
that you listed, that would be most welcome. You are welcome to
contribute the code to the project I prepared for that purpose:
https://github.com/amir73il/overlayfs

> @@ -522,6 +525,7 @@ int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
>  {
>         int err;
>         struct ovl_cache_entry *p;
> +       struct ovl_cache_entry *n;

nit: I would do *p, *n;
It's a matter of taste I suppose, because Miklos chose otherwise in
ovl_cache_free()

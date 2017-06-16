From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH] ovl:fix rmdir problem on impure dir
Date: Fri, 16 Jun 2017 09:02:43 +0300
Message-ID: <CAOQ4uxjnVfY+jqgUxrhw0nD6FHUOaqkTynOQX2cm2MaLRd+cOg@mail.gmail.com>
References: <1497585310-34952-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:35091 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdFPGCo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2017 02:02:44 -0400
Received: by mail-ot0-f196.google.com with SMTP id z48so2994824otz.2
        for <linux-unionfs@vger.kernel.org>; Thu, 15 Jun 2017 23:02:44 -0700 (PDT)
In-Reply-To: <1497585310-34952-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On Fri, Jun 16, 2017 at 6:55 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hi All:
>
> I found another problem about impure upper dir which have left
> whiteout files. If an "impure && not merged" upper dir have
> left whiteout files(last mount created), ovl cannot clear this
> dir when we removing it, which may lead to rmdir fail or temp
> file left in workdir.
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

Can you please post an xfstest with that reproducer.
A good starting point is test overlay/012

>
> syslog dump:
>   overlayfs: cleanup of 'work/#7' failed (-39)
>
> (*): if we are not creat this file, the result is different:
>   rm: cannot remove "dir/": Directory not empty
>
> This patch add impure flag on parent dir in ovl_remove_and_whiteout()
> to indicate the dir is impure, and then check and clean it when
> removing this dir.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Apart of the one comment below, you may add

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/dir.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index a63a716..9535e2d 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -336,7 +336,8 @@ static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
>          * Doesn't matter, since copy-up can't create a non-empty directory
>          * from an empty one.
>          */
> -       if (OVL_TYPE_UPPER(type) && OVL_TYPE_MERGE(type))
> +       if (OVL_TYPE_UPPER(type) && (OVL_TYPE_MERGE(type) ||
> +                                    ovl_dentry_is_impure(dentry)))
>                 ret = ovl_clear_empty(dentry, &list);
>
>  out_free:
> @@ -633,6 +634,11 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
>                         goto out;
>         }
>
> +       /* Mark parent "impure" because it may now contain non-pure upper */
> +       err = ovl_set_impure(dentry->d_parent, upperdir);
> +       if (err)
> +               goto out_dput;
> +

This should be done before ovl_whiteout().
You rather have false positive impure than the other way around.
Also please fix comment to "... may now contain whiteouts".

>         err = ovl_lock_rename_workdir(workdir, upperdir);
>         if (err)
>                 goto out_dput;
> @@ -690,8 +696,9 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
>         struct dentry *opaquedir = NULL;
>         int err;
>
> -       /* Redirect dir can be !ovl_lower_positive && OVL_TYPE_MERGE */
> -       if (is_dir && ovl_dentry_get_redirect(dentry)) {
> +       /* Redirect/Impure dir can be !ovl_lower_positive && not clean */
> +       if (is_dir && (ovl_dentry_get_redirect(dentry) ||
> +                      ovl_dentry_is_impure(dentry))) {
>                 opaquedir = ovl_check_empty_and_clear(dentry);
>                 err = PTR_ERR(opaquedir);
>                 if (IS_ERR(opaquedir))
> --
> 1.8.3.1
>

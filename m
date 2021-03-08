Return-Path: <SRS0=PSAs=IG=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5842FC433DB
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Mar 2021 12:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EA6F64F5F
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Mar 2021 12:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhCHMJ6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 07:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhCHMJt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Mar 2021 07:09:49 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BDDC06174A
        for <linux-unionfs@vger.kernel.org>; Mon,  8 Mar 2021 04:09:49 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id u20so9600398iot.9
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Mar 2021 04:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KmQ1vdfSxzmf7yFu77l/ZqK7uHdVuqEzZoHoaCwzv7U=;
        b=kWCwd2NdNiHwkpz3RHTZKnWDOzYN9aWx59IyYWbD3++YozlitXXh7oPIBct5LDRyHv
         NhpmMC3KY0mCOlBYaUE90DGVfp8SNxnZolGr4+a8L240RVzsIBYQOYN7i5Bz8GuxfkIx
         Wx3dFd0tAV5qpbb98k40e+Jjx9m6JwwOKhK+C4rDJCDmr9mqJ4z9WbATIwexUZzH3pQl
         m8t0lxFXohT3Jh5UwUw02kcBCYs20QKpXn6sLQQX464eLOanRqSTlnjAKoY6C4JW0N3x
         j5PMG8V8z1CMBC9VyWeH+vLxepl5OIGBf4GcLPZK0XzuorM712zYkUY3q25paCRf5MUN
         fCCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KmQ1vdfSxzmf7yFu77l/ZqK7uHdVuqEzZoHoaCwzv7U=;
        b=n0ZKPQlgXuHAmhVuOQ9QpJWO+OWV2nzBzbehCfSO45qMRAAaRw63VPX6oZ2B6Az4G5
         jEBEFsrI/mGCaHCsuGJ+TSpTBWzjyJMuqhIwTx3IyzkU2f4trgKR4tJJGkmUlfngR7EN
         XMVJ7TBbzl9YfoR3/41PxIwNpkxyCnakaZkz9AUXGFAY6Xoib+/YXvRm+B3EcUB3fuIt
         1Sw9mFTx0gnMzjHH6Hu0MFdtRpTVD8Y34Zy01b2pzQ37JidwWteqPiNIVquFE/QgDxio
         YPrxkyGlhWOTf6WHV/LnYbYl1uQdcI3sCzstbFhyQD6rGTim0rW5wYjCS/4ZTRTctdHt
         CIgA==
X-Gm-Message-State: AOAM532DrrK/GfDMk8s7YCbvAQsbcJQcDi9IyzxHt/OIc8j5ErVW7OhT
        2vE9n4Otv1FNrivPXJxeYYcP8OKPZb98MeY19KxHVCR68dU=
X-Google-Smtp-Source: ABdhPJwvBTPTQtvYrUgpgAkYD7YdGzqpvMav9dAnQFQ4ZBB5tkKEmPehFLhTZbroPN+s5+tZtDp/fdBTsGyQF9Q8nzo=
X-Received: by 2002:a02:ccb2:: with SMTP id t18mr23037786jap.123.1615205388627;
 Mon, 08 Mar 2021 04:09:48 -0800 (PST)
MIME-Version: 1.0
References: <20210308111717.2027030-1-cgxu519@mykernel.net>
In-Reply-To: <20210308111717.2027030-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 8 Mar 2021 14:09:37 +0200
Message-ID: <CAOQ4uxjsQ90D5ts=bwOA+KZ8m5ycdiyH49c2g+WLOnJXSa9NvA@mail.gmail.com>
Subject: Re: [PATCH] ovl: copy-up optimization for truncate
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 8, 2021 at 1:25 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Currently copy-up will copy whole lower file to upper
> regardless of the data range which is needed for further
> operation. This patch avoids unnecessary copy when truncate
> size is smaller than the file size.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

Nice!

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

This reminds me. I think this comment in ovl_nlink_start() can be removed:

         * TODO: implement metadata only index copy up when called with
         *       ovl_copy_up_flags(dentry, O_PATH).

It was added in 2017 and not removed when metacopy was implemented.
Technically, I think that truncate() could also be a metacopy, but it seems
like a corner case that is not worth the trouble...

Thanks,
Amir.


> ---
>  fs/overlayfs/copy_up.c   | 16 +++++++++-------
>  fs/overlayfs/inode.c     |  4 +++-
>  fs/overlayfs/overlayfs.h |  2 +-
>  3 files changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 0b2891c6c71e..b426a3f59636 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -866,7 +866,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>  }
>
>  static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
> -                          int flags)
> +                          int flags, loff_t size)
>  {
>         int err;
>         DEFINE_DELAYED_CALL(done);
> @@ -903,6 +903,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>         /* maybe truncate regular file. this has no effect on dirs */
>         if (flags & O_TRUNC)
>                 ctx.stat.size = 0;
> +       if (size)
> +               ctx.stat.size = size;
>
>         if (S_ISLNK(ctx.stat.mode)) {
>                 ctx.link = vfs_get_link(ctx.lowerpath.dentry, &done);
> @@ -929,7 +931,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>         return err;
>  }
>
> -static int ovl_copy_up_flags(struct dentry *dentry, int flags)
> +static int ovl_copy_up_flags(struct dentry *dentry, int flags, loff_t size)
>  {
>         int err = 0;
>         const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
> @@ -962,7 +964,7 @@ static int ovl_copy_up_flags(struct dentry *dentry, int flags)
>                         next = parent;
>                 }
>
> -               err = ovl_copy_up_one(parent, next, flags);
> +               err = ovl_copy_up_one(parent, next, flags, size);
>
>                 dput(parent);
>                 dput(next);
> @@ -994,7 +996,7 @@ int ovl_maybe_copy_up(struct dentry *dentry, int flags)
>         if (ovl_open_need_copy_up(dentry, flags)) {
>                 err = ovl_want_write(dentry);
>                 if (!err) {
> -                       err = ovl_copy_up_flags(dentry, flags);
> +                       err = ovl_copy_up_flags(dentry, flags, 0);
>                         ovl_drop_write(dentry);
>                 }
>         }
> @@ -1002,12 +1004,12 @@ int ovl_maybe_copy_up(struct dentry *dentry, int flags)
>         return err;
>  }
>
> -int ovl_copy_up_with_data(struct dentry *dentry)
> +int ovl_copy_up_with_data(struct dentry *dentry, loff_t size)
>  {
> -       return ovl_copy_up_flags(dentry, O_WRONLY);
> +       return ovl_copy_up_flags(dentry, O_WRONLY, size);
>  }
>
>  int ovl_copy_up(struct dentry *dentry)
>  {
> -       return ovl_copy_up_flags(dentry, 0);
> +       return ovl_copy_up_flags(dentry, 0, 0);
>  }
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 003cf83bf78a..5eb99e4c3c73 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -44,7 +44,9 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
>         if (!full_copy_up)
>                 err = ovl_copy_up(dentry);
>         else
> -               err = ovl_copy_up_with_data(dentry);
> +               err = ovl_copy_up_with_data(dentry,
> +                               attr->ia_size < i_size_read(d_inode(dentry)) ?
> +                               attr->ia_size : 0);
>         if (!err) {
>                 struct inode *winode = NULL;
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 95cff83786a5..1bc17ca87158 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -524,7 +524,7 @@ long ovl_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
>
>  /* copy_up.c */
>  int ovl_copy_up(struct dentry *dentry);
> -int ovl_copy_up_with_data(struct dentry *dentry);
> +int ovl_copy_up_with_data(struct dentry *dentry, loff_t size);
>  int ovl_maybe_copy_up(struct dentry *dentry, int flags);
>  int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
>                    struct dentry *new);
> --
> 2.27.0
>
>

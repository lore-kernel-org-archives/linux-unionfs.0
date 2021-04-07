Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE7BC433ED
	for <linux-unionfs@archiver.kernel.org>; Wed,  7 Apr 2021 07:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB85C613A7
	for <linux-unionfs@archiver.kernel.org>; Wed,  7 Apr 2021 07:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhDGHwl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 03:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhDGHwi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Apr 2021 03:52:38 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99625C06174A
        for <linux-unionfs@vger.kernel.org>; Wed,  7 Apr 2021 00:52:27 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id 6so5780166ilt.9
        for <linux-unionfs@vger.kernel.org>; Wed, 07 Apr 2021 00:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e99lfi5k7uVUqasilEfsWzXwvcN4L/U1PYQMjCdXvFU=;
        b=RUTrcc26+S5VL4LHOzUur2XAhh1ZvVPxUN6hdqyaROWvZqwqcmftIoov3M9VrP1REu
         wz5HyiAFciUIQ12+ho1+PvXtI4m4UhlLUuqxNmDKuF37U+o9jafuZm0/zRvO+9jTD/O2
         MHRKB5f6/38AgpzEUyas+5za8zpmoJtImeBdoWWtOBU/bbAsd78BM3My/ZFns7qH46y3
         t44K533kNJC1LKeVEIjI5661VTfuybV4CskyuRT0OXAp2VBC2Duozzb465h07vaCqZU2
         VIWXXh/GPpwpQy5JtzXVnnV5zqcDxvwEce2DhiMAhVPbqbNbixnJxs0EbbQzdEpPXY+n
         ATcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e99lfi5k7uVUqasilEfsWzXwvcN4L/U1PYQMjCdXvFU=;
        b=M9VrlmHxUBae9mgDLkud7mQp80sFfacpBEQxnN+TUG4QVg7m4qHjLk50tR0y3yJ0V4
         lE8HXF/ETA5ULT4CpeG+72TFkAQByxavu/8f/0txyXq2Zrge6O3c/2WjqVajPMv2zeIq
         dii2G7PGAWqdzbkL512A2E57vGtVUkcQ64W5CuyuQmybL4uLnXguh/HeAxESOfkN6pVx
         DEt59IbrSN9Xa7IRlcN0FHHiFKXjAt70tV0qeQdLIysHCvBaPJxHdqS8VbRoTYVeDxxf
         mttigYhhKZzlUdIai6Ahqk9zCbhs/SXg8n8kqEMiEjchCOfsbPwETRAE4eO8/uGDBADM
         Tx1A==
X-Gm-Message-State: AOAM532BCUdbh1oyIgt+7RGw1qdH/nKiQhByVNggyHM/+jT+9KbqLyyE
        PxXoaVIPbS+8YvUXd3Y3nAEeunqdWXLx8xECAXQ=
X-Google-Smtp-Source: ABdhPJz4UkaXHmDOECDfQ63Y/ttQVuhrjF16nh4hnsWfjRp6gvsXW240zrsv555Vr+jCQKt/yQTvLK5E6BvmwcrFhwc=
X-Received: by 2002:a92:2c08:: with SMTP id t8mr1782154ile.72.1617781946993;
 Wed, 07 Apr 2021 00:52:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210406120245.1338326-1-cgxu519@mykernel.net> <20210406120245.1338326-3-cgxu519@mykernel.net>
In-Reply-To: <20210406120245.1338326-3-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 7 Apr 2021 10:52:15 +0300
Message-ID: <CAOQ4uxg2Rydq1kx-rqguvC=bp4m80o7Yzy5r+HK7sqxXAVtcdA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: copy-up optimization for truncate
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 7, 2021 at 12:04 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Currently truncate operation on the file which only has
> lower will copy-up whole lower file and calling truncate(2)
> on upper file. It is not efficient for the case which
> truncates to much smaller size than lower file. This patch
> tries to avoid unnecessary data copy and truncate operation
> after copy-up.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/copy_up.c   | 18 +++++++++++-------
>  fs/overlayfs/inode.c     |  9 ++++++++-
>  fs/overlayfs/overlayfs.h |  2 +-
>  3 files changed, 20 insertions(+), 9 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index a1a9a150405a..331cc32eac95 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -874,7 +874,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>  }
>
>  static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
> -                          int flags)
> +                          int flags, loff_t size)
>  {
>         int err;
>         DEFINE_DELAYED_CALL(done);
> @@ -911,6 +911,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>         /* maybe truncate regular file. this has no effect on dirs */
>         if (flags & O_TRUNC)
>                 ctx.stat.size = 0;
> +       if (size)
> +               ctx.stat.size = size;

Not sure about this, but *maybe* instead we re-interpret O_TRUNC
internally as "either O_TRUNC or truncate()" and then:
         if (flags & O_TRUNC)
                 ctx.stat.size = size;

It would simplify the logic in ovl_copy_up_with_data().
If you do that, put a comment to clarify that special meaning.

>
>         if (S_ISLNK(ctx.stat.mode)) {
>                 ctx.link = vfs_get_link(ctx.lowerpath.dentry, &done);
> @@ -937,7 +939,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>         return err;
>  }
>
> -static int ovl_copy_up_flags(struct dentry *dentry, int flags)
> +static int ovl_copy_up_flags(struct dentry *dentry, int flags, loff_t size)
>  {
>         int err = 0;
>         const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
> @@ -970,7 +972,7 @@ static int ovl_copy_up_flags(struct dentry *dentry, int flags)
>                         next = parent;
>                 }
>
> -               err = ovl_copy_up_one(parent, next, flags);
> +               err = ovl_copy_up_one(parent, next, flags, size);
>
>                 dput(parent);
>                 dput(next);
> @@ -1002,7 +1004,7 @@ int ovl_maybe_copy_up(struct dentry *dentry, int flags)
>         if (ovl_open_need_copy_up(dentry, flags)) {
>                 err = ovl_want_write(dentry);
>                 if (!err) {
> -                       err = ovl_copy_up_flags(dentry, flags);
> +                       err = ovl_copy_up_flags(dentry, flags, 0);
>                         ovl_drop_write(dentry);
>                 }
>         }
> @@ -1010,12 +1012,14 @@ int ovl_maybe_copy_up(struct dentry *dentry, int flags)
>         return err;
>  }
>
> -int ovl_copy_up_with_data(struct dentry *dentry)
> +int ovl_copy_up_with_data(struct dentry *dentry, loff_t size)
>  {
> -       return ovl_copy_up_flags(dentry, O_WRONLY);
> +       if (size)
> +               return ovl_copy_up_flags(dentry, O_WRONLY, size);
> +       return  ovl_copy_up_flags(dentry, O_TRUNC | O_WRONLY, 0);

Best get rid of this helper and put this logic in ovl_setattr(). see below.

>  }
>
>  int ovl_copy_up(struct dentry *dentry)
>  {
> -       return ovl_copy_up_flags(dentry, 0);
> +       return ovl_copy_up_flags(dentry, 0, 0);
>  }
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index cf41bcb664bc..92f274844947 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -43,13 +43,20 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
>         if (!full_copy_up)
>                 err = ovl_copy_up(dentry);
>         else
> -               err = ovl_copy_up_with_data(dentry);
> +               err = ovl_copy_up_with_data(dentry, attr->ia_size);

You do not know that ia_size is valid here.
Instead of using this if/else and full_copy_up var, use vars 'flags'
and 'size' and call ovl_copy_up_flags().
Instead of full_copy_up = true, set flags and size.
Then you may also remove ovl_copy_up_with_data() which has no other
callers.

>         if (!err) {
>                 struct inode *winode = NULL;
>
>                 upperdentry = ovl_dentry_upper(dentry);
>
>                 if (attr->ia_valid & ATTR_SIZE) {
> +                       if (full_copy_up && !(attr->ia_valid & ~ATTR_SIZE)) {
> +                               inode_lock(upperdentry->d_inode);
> +                               ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
> +                               inode_unlock(upperdentry->d_inode);

All that this is saving is an extra notify_change() call and I am not sure it is
worth the special casing.

Also, I think that is a bug and would make xfstest overlay/013 fail.
When lower file is being executed, its true that we copy up anyway
and that it is safe to do that, but test and applications expect to get
ETXTBSY error all the same.

Please run xfstests at least the generic/quick and overlay/quick groups
with -overlay.

There are a lot of generic and overlay tests that do truncate(size), but it's
hard to say if test coverage for your change is sufficient, so unless you find
tests that cover it, you may need to write a specialized overlay truncate test.

Thanks,
Amir.

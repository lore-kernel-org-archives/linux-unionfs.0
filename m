Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45888C43460
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 13:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E9FE61108
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Apr 2021 13:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhDINvw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 09:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhDINvv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Apr 2021 09:51:51 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86740C061761
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Apr 2021 06:51:37 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id b20so2632751vsr.11
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Apr 2021 06:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=17gAB4/Xt1EcJ6duLXHgiCVFdSPwnzL/vuA8S86w0nY=;
        b=nMoosH4hAMExjqx73VwI6ccfuBMeqOOlug3s2ahPExh1d7czDmhVMSGWoyRJFWu9yw
         w/D4H+GN/48/WgLwgaPwAlgprTRjNFcMkcd8bBKhjsaI1iGtkngb6asqgGovqTvTUnp/
         gqwtCIkQ4jdzVftGhpNvjKHSEKyD8HpnHf89Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=17gAB4/Xt1EcJ6duLXHgiCVFdSPwnzL/vuA8S86w0nY=;
        b=RVOEwX+rSvqhFpx1vmv253MjpJpyEJ98SCstdKDLd+nZZyjyffq4OwakFAXm02he8W
         rft0QOnbsDar0TzO24EYSOxfpwNaOW7u8n4l7mSafJwElRgYhtAeCVh4fH5RizIXaR1q
         /hxEJ4vDBrJYKqfqdRYo5MYq2rwmATw2n4/Kkna5m7NAiTNpdvp6RSC5F4t6cMLTkvF7
         L5KlGe/iDnG1cRrvJ3m3hZvjyLvmTihngpjpNWluIsImFfUvX9Pw4l6EQ5oyqKUD5Bpp
         QadXMo+zHjza6q3Q5QoO8vsF739hL63xTbxxjKF15ChmuIzx2IyUiYYiScQqQGJ9jZwd
         0NMA==
X-Gm-Message-State: AOAM53020bBOh/0W69/w5kNOSR4k4Qm8TZflN2fD1eXDb2GgIk6t5jgR
        kUQpqzyi6Goeig+05U3WdgSIGYcct9fXKXOpnA3itw==
X-Google-Smtp-Source: ABdhPJxhsn0VhTmPepqwZIxdPE/jJRKz40lPlfAjtAlHk6AKV+A1Dipj6Ahx1cPdaWfVBS0oSfKjHovl4UqmJo8jOQ4=
X-Received: by 2002:a67:e056:: with SMTP id n22mr11332309vsl.0.1617976296786;
 Fri, 09 Apr 2021 06:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20201113065555.147276-1-cgxu519@mykernel.net> <20201113065555.147276-10-cgxu519@mykernel.net>
In-Reply-To: <20201113065555.147276-10-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Apr 2021 15:51:26 +0200
Message-ID: <CAJfpegsoDL7maNtU7P=OwFy_XPgcyiBOGFzaKRbGnhfwz-HyYw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 9/9] ovl: implement containerized syncfs for overlayfs
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Nov 13, 2020 at 7:57 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Now overlayfs can only sync dirty inode during syncfs,
> so remove unnecessary sync_filesystem() on upper file
> system.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/super.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 982b3954b47c..58507f1cd583 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -15,6 +15,8 @@
>  #include <linux/seq_file.h>
>  #include <linux/posix_acl_xattr.h>
>  #include <linux/exportfs.h>
> +#include <linux/blkdev.h>
> +#include <linux/writeback.h>
>  #include "overlayfs.h"
>
>  MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
> @@ -270,8 +272,7 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
>          * Not called for sync(2) call or an emergency sync (SB_I_SKIP_SYNC).
>          * All the super blocks will be iterated, including upper_sb.
>          *
> -        * If this is a syncfs(2) call, then we do need to call
> -        * sync_filesystem() on upper_sb, but enough if we do it when being
> +        * if this is a syncfs(2) call, it will be enough we do it when being
>          * called with wait == 1.
>          */
>         if (!wait)
> @@ -280,7 +281,11 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
>         upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
>
>         down_read(&upper_sb->s_umount);
> -       ret = sync_filesystem(upper_sb);
> +       wait_sb_inodes(upper_sb);
> +       if (upper_sb->s_op->sync_fs)
> +               ret = upper_sb->s_op->sync_fs(upper_sb, wait);
> +       if (!ret)
> +               ret = sync_blockdev(upper_sb->s_bdev);

Should this instead be __sync_blockdev(..., wait)?

Thanks,
Miklos

Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8326C12002
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jul 2021 13:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2664610D2
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jul 2021 13:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbhGUMeS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jul 2021 08:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhGUMeR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jul 2021 08:34:17 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2216C061574
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jul 2021 06:14:53 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id v186so519833vka.1
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jul 2021 06:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BsCammn3h4jNtxj8Zw1Mb6jUfKsu4I4W+UoqAu+qlzY=;
        b=BtMs3ozmUQU514MOktu2TwI10XCm5YcwhOiafrUvvSt5kgzQWEVv5yeETnTVh1Qb8P
         p5TGPFRKkvHtyaGW4nzStl1p+WIXlNxFy3hSMVN7MA/UfEgoaLT82ojcEUXaUC9bu1vY
         xkxK+6UEWHkZvKQgVwjC57gWu/QnyAef8yB58=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BsCammn3h4jNtxj8Zw1Mb6jUfKsu4I4W+UoqAu+qlzY=;
        b=srEUqhjz9t1KOwSOs4DgiiDr9ICOuT+ybH6Au5Z5L4OnXi9g6L4M87804ZRqR7h1WN
         MD9NcseFrS0DgzTmHMZelV0ywKQv70IZ9m+AK7Pm7MtmLQoBOmm61QQLcQb496su/y0R
         566/POb40MMQWM+14183xjut+oJe0NtuspwgRBr2h71LZP3cwu46D8QVn7pZI+MU858l
         62UxRtZdgL2ASKn36lGl6wc0R3OfRfVI2lWRbetPMmaDNzuEJNxsfXNUGbFsTloFdUQE
         TWOpDX58+DTERoQY9fZoKChnipAcU5Cfa/VPA894J28bsMaT4wrSzs+Oeixf4+o3W2iQ
         FBZQ==
X-Gm-Message-State: AOAM531UxOt/SJXN5yGyx+iUt9CZQ3/DDxkKZ9TeP6LOveEgvFm93sph
        3vmXRxPKVgy5wPJh51koPDvN759PKS2tDzVXmFR5kw==
X-Google-Smtp-Source: ABdhPJzZagwtOCRyARVRFIPP5WYrB+JoM+046KL9UyY8pt0SfXFEfav89cEh4SsJhREgwmCPl3Z5Z4cEEZWD1laT5Fs=
X-Received: by 2002:ac5:c5a9:: with SMTP id f9mr1879818vkl.3.1626873292657;
 Wed, 21 Jul 2021 06:14:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210424140316.485444-1-cgxu519@mykernel.net> <20210424140316.485444-2-cgxu519@mykernel.net>
In-Reply-To: <20210424140316.485444-2-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 21 Jul 2021 15:14:42 +0200
Message-ID: <CAJfpegus1AKdqhLNwgLZA1PyRrUF_4VQuNnGbM+aYOYnSBjsmQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] ovl: enhance write permission check for writable open
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 24 Apr 2021 at 16:04, Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Check upper file's write permission when open on writable mode.

This should already be done in ovl_open() -> ovl_open_realfile() ->
open_with_fake_path() -> do_dentry_open().

Do you have a test case indicating that the writecount test is not working?

Thanks,
Miklos

>
> NOTE: lower files may be shared between differnt overlayfs instances,
> so we skip the check of lower file to avoid introducing interferes.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/file.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 6e454a294046..1c3c24d07d01 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -144,12 +144,18 @@ static int ovl_real_fdget(const struct file *file, struct fd *real)
>  static int ovl_open(struct inode *inode, struct file *file)
>  {
>         struct file *realfile;
> +       struct inode *upperinode;
>         int err;
>
>         err = ovl_maybe_copy_up(file_dentry(file), file->f_flags);
>         if (err)
>                 return err;
>
> +       upperinode = ovl_inode_upper(inode);
> +       if (((file->f_mode & FMODE_WRITE) || file->f_flags & O_TRUNC) &&
> +           (upperinode && atomic_read(&upperinode->i_writecount) < 0))
> +               return -ETXTBSY;
> +
>         /* No longer need these flags, so don't pass them on to underlying fs */
>         file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
>
> --
> 2.27.0
>
>

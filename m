Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A04C433B4
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 09:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A75696143D
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 09:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbhDUJs0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 05:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbhDUJs0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Apr 2021 05:48:26 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7846FC06174A
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Apr 2021 02:47:53 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id r18so14946510vso.12
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Apr 2021 02:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e2ZBlxLbHufAzYmGElpXx3HZ28hnJe99qeXnBC5Eb7U=;
        b=Tghjc7wxRL3Ud16BL1sLl6osH3Ssy+AKiTUcDTgLEGdiYf7a7Uqe8MMMffVSOw9N8r
         HXQUXAJ6nToR6RogEt7Qn8SBY8bUborhtjuJZNNJc6XuvD0nF8Qz9qaO2Oc9J7oSHGzc
         XnbqUDxLfxTmOiE8zGeHb357dDUgiHMshdEgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e2ZBlxLbHufAzYmGElpXx3HZ28hnJe99qeXnBC5Eb7U=;
        b=XNwO0f8gr3AXWOcecChNAa2KWbZci0/pTiipVkicU7aK2MsO35hUk4lJibnHJJx0QT
         /ks9qVVbpR0M16liDMVsBfDlSMGuPm56tFoc0gyU0mCLirbIlUgSMA+76R9MvM6MXH9w
         8vauUxuUDk6SiZinoQ1Fb9N+m8XJV5+gPFPnLAi6HnOFe5VqdOEvG1WPbhZtJ1zwLUyL
         ayYRAbKuO4hXM/EPK0lXZ6VPJ44N9+HsfXKy/IEF+kjk4tCCqspKdeipQ+bDdV6SOW//
         uKLjA/otj4JRF0HpBzuWRBeEGGEl86f+R/qVr+J4RgQgseMp1jbv/Hi+8A4TxwgLKBIa
         K6DA==
X-Gm-Message-State: AOAM533euPkbaPdwbw9ViVMjb/T5eOZgAjwIzfJR/f7g2XmxizR4oRL6
        hd9ANDyaz97SLp2dB48ixMne+SeqVp2yHrFDJF7c4IvBB6NRZtha
X-Google-Smtp-Source: ABdhPJxiZ62nesj11CoYFtKMHB2hPyk91TqtkPbo7UDUghTa5eczjy9Cz9PC81tWahKVvoCXxduQgPtswl9syA07KL8=
X-Received: by 2002:a67:2786:: with SMTP id n128mr24129369vsn.9.1618998472804;
 Wed, 21 Apr 2021 02:47:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210420020738.201670-1-cgxu519@mykernel.net>
In-Reply-To: <20210420020738.201670-1-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 21 Apr 2021 11:47:42 +0200
Message-ID: <CAJfpegvfGAynZ1kz287eJHVRc6+81FzUwSq_V9E36qXCB7WtYQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: restore vma->vm_file to old file
To:     Chengguang Xu <cgxu519@mykernel.net>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 20, 2021 at 4:08 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> In the error case of ->mmap() we should also restore vma->vm_file
> to old file in order to keep correct file reference in error path.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/file.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 6e454a294046..046a7adb02c5 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -439,6 +439,7 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
>         if (ret) {
>                 /* Drop reference count from new vm_file value */
>                 fput(realfile);
> +               vma->vm_file = file;

That's interesting: commit 1527f926fd04 ("mm: mmap: fix fput in error
path v2") which went into 5.11-rc1 seems to have broke the refcounting
in overlayfs in the name of cleaning up a workaround.   Wondering if
there's any other damage done by this "fix"?

Changing refcounting rules in core kernel is no easy matter, a full
audit of ->mmap instances (>200) should have been done beforehand.

I suggest reverting this commit as a first step.

Thanks,
Miklos

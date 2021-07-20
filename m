Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4166C07E95
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 14:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6A80610A0
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 14:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238525AbhGTONp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 10:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbhGTNys (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jul 2021 09:54:48 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5C8C061574
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jul 2021 07:35:26 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id c20so8128204uar.12
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jul 2021 07:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mnB7vkp8a7Zu6EKvXc/ncjg6TcgbDNqTGQf6jJDZLho=;
        b=QatZRPIL7X5k/ynRU2lbwp8e3NdhZEXor43m6kWww4kaz6NhF3Ib9mGsGTZmuJPg6O
         jmiHnkReZQ2QOCrXMPbDRnZu/+8anJSXuTy7LsKRgUepVlT2Bz1xsqnzo7HkGNmLRLSk
         ak91IgSqZlRHk5kgkblkh8jSA0JKmI+BtGx5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mnB7vkp8a7Zu6EKvXc/ncjg6TcgbDNqTGQf6jJDZLho=;
        b=cAZA3g/aoyHr8qh1JbvQIt9XHsIK7SkaPTrNtS+bbeZrr5O53eFB5RL8ZuiRK13W8e
         vc7gs6HldFCf2TAbJNmWOzl9xPTTlLQcgy5zmhdFM3m3fKwHsNt5t45kONnX9sQUtwMq
         woJIGE//wckl5Ggn2cZifIDGQHBgHnplrh5YG22UNcY/zXTMdK98SMvCgZ7f9PbdvHQ0
         ffHRSNNGpJc0FhoZJQKt/Iv2PN94G1YSmPYpJXrCt9frJ2f99ecDJ4JAW21ZqH7XlDqM
         SRfus335E8Iwl/VREk0x4g5AacYKsh1AhtSn15smhtfHmN/SxvNlPhqwm1Ewlz+mymr3
         UGCg==
X-Gm-Message-State: AOAM530VDyloFN6RcHrICBO9JQEf4vY72xM/SLL0aGw37ehDZ3CwvNyg
        4rqjBsW0NOa/FgelnDEY8NVv0/voNaj1p48kthd88rYIkD8WbA==
X-Google-Smtp-Source: ABdhPJyFc9ArCFIyfxUfO0+DeecX1t4827noLqhqSsCDNQWPblxwBjkhVF6StZ70rZCT7HEEiaV7Tb9qOz39vcLKoWM=
X-Received: by 2002:ab0:5e92:: with SMTP id y18mr1353625uag.9.1626791725364;
 Tue, 20 Jul 2021 07:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210424140316.485444-1-cgxu519@mykernel.net>
In-Reply-To: <20210424140316.485444-1-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 20 Jul 2021 16:35:14 +0200
Message-ID: <CAJfpegsT3PaVggkcx+OdoxOCR2hWYeLs1rTr_p3nNMimnknCug@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] ovl: skip checking lower file's write permisson
 on truncate
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 24 Apr 2021 at 16:04, Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Lower files may be shared in overlayfs so strictly checking write
> perssmion on lower file will cause interferes between different
> overlayfs instances.

How so?

i_writecount on lower inode is not modified by overlayfs (at least not
in this codepath).  Which means that there should be no interference
between overlayfs instances sharing a lower directory tree.

Thanks,
Miklos



>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/inode.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 28c71978eb2e..17d1add0af1a 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -31,12 +31,6 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
>                 goto out;
>
>         if (attr->ia_valid & ATTR_SIZE) {
> -               struct inode *realinode = d_inode(ovl_dentry_real(dentry));
> -
> -               err = -ETXTBSY;
> -               if (atomic_read(&realinode->i_writecount) < 0)
> -                       goto out_drop_write;
> -
>                 /* Truncate should trigger data copy up as well */
>                 full_copy_up = true;
>         }
> --
> 2.27.0
>
>

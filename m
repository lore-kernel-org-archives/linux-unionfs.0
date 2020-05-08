Return-Path: <SRS0=CIw7=6W=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5045AC38A2A
	for <linux-unionfs@archiver.kernel.org>; Fri,  8 May 2020 18:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D03B2173E
	for <linux-unionfs@archiver.kernel.org>; Fri,  8 May 2020 18:39:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HL4hamnf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgEHSjc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 8 May 2020 14:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726817AbgEHSjc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 May 2020 14:39:32 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2A6C061A0C
        for <linux-unionfs@vger.kernel.org>; Fri,  8 May 2020 11:39:32 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id e9so2775296iok.9
        for <linux-unionfs@vger.kernel.org>; Fri, 08 May 2020 11:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3dVCshaUoREnw1jac6/ER986Y6yLBZQ44xY5IPATBbI=;
        b=HL4hamnfJ0qA+8WgonWFf2CsfLbLBn26AwbpVwbW/YSlsX3VdKVqgfMOQ+kOuOhWiJ
         3qnBpjWJkX0OoT510PxV6XmXDL0dHYoGv5wE0kTWpmE0PzqkGXVvMisSAuNjLgEDYcp3
         M7t84sC0lEkSFykv/ogbkINcF4F43zMbgFPiJF/aPznkWX/rAIZlvQDrCMO5Wpma0AAL
         EX8xmEa/9X33fpmmQgWisH5wRC/2jDvgFEDbflR6WB6nViVycM668/88w5UrVOG1nD7L
         8njsZYaOT3voqep+hBUUyV0ZDEsHOfRQ5VITniy5gwY8usgmHUaZ8OsbIcgctLtfEErx
         b6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3dVCshaUoREnw1jac6/ER986Y6yLBZQ44xY5IPATBbI=;
        b=ZectJsIFiN6DGAXsI5OG0QyXy41fLf1neTbVq0JRaMHSkBQPP4gtTarkIJ/HC/9e/1
         YXTJAbQ7KOqg105bRaTNHtIXRgMa9IXZ7ENWRtRMCMbTSFaS449QGgJ1gdvJtmI257z4
         Zhi1FsMXDf/TMt2RyLd7LRFX3T5B7eUV4JNo/a4UDSpuENeUVl6xw36kULqlt6BpP/t6
         jcTkyBrAAcAhiThvaOYWd5tbQXl6CU70uwxYEEMsl/wawCmXU5kLguKTDrOpLI7n/Yv9
         ikZch6PaB3EXsWxSUJoav6zHUmsKNXL7xrsrcC0JzUPzr6DnqYNvD2P/6Wkcn38PJqKq
         6cPA==
X-Gm-Message-State: AGi0Pua+TX5xVX++jiEMlLVl4/HLqB63zJI6bfzK5m8lBQAefbJsKv09
        LTYUwqZTbGS1So91KnCpxBi76RIkfxJ2hEbQFSDJcq77
X-Google-Smtp-Source: APiQypL3RruJLjzRQr8t+4OSjpU5zjOW+E/ItGSrpH25dpAraspRTV9YLMSk9yMi3JQv39TJRcb68msgYqkMbaX2V4A=
X-Received: by 2002:a02:4b03:: with SMTP id q3mr3943504jaa.30.1588963171699;
 Fri, 08 May 2020 11:39:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200507011900.23523-1-cgxu519@mykernel.net>
In-Reply-To: <20200507011900.23523-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 8 May 2020 21:39:20 +0300
Message-ID: <CAOQ4uxjuh6uiAsqTDqGyqAOQ7pRjeDShbdpV44M2cT4kL=rCDw@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: suppress negative dentry in lookup
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, May 7, 2020 at 4:21 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> When a file is only in a lower layer, after lookup a negative

Or in no layer at all...

> dentry will be generated in the upper layer or even worse many
> negetive dentries will be generated in upper/lower layers. These
> negative dentries will be useless after construction of overlayfs'
> own dentry and may keep in the memory long time even after unmount
> of overlayfs instance. This patch tries to kill unnecessary negative
> dentry during lookup.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/namei.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 723d17744758..cf0ec4d7bcec 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -200,7 +200,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>         int err;
>         bool last_element = !post[0];
>
> -       this = lookup_positive_unlocked(name, base, namelen);
> +       this = lookup_one_len_unlocked(name, base, namelen);
>         if (IS_ERR(this)) {
>                 err = PTR_ERR(this);
>                 this = NULL;
> @@ -209,6 +209,15 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>                 goto out_err;
>         }
>
> +       /* Borrow the check from lookup_positive_unlocked */
> +       if (d_flags_negative(smp_load_acquire(&this->d_flags))) {
> +               d_drop(this);
> +               dput(this);
> +               this = NULL;
> +               err = -ENOENT;
> +               goto out;
> +       }
> +

This is a nice improvement, but my feeling is that this low level code
belongs in a vfs helper with well documented semantics.

Thanks,
Amir.

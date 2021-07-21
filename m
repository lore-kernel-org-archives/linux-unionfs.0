Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712D0C636C9
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jul 2021 13:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4305961029
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jul 2021 13:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbhGUM3r (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jul 2021 08:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbhGUM3r (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jul 2021 08:29:47 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC63C061574
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jul 2021 06:10:24 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id m33so510994vkf.6
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jul 2021 06:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4AxcTOQKVui/NwP6DTwIb4sEEiLrG+WCJBEpOdH7Qr4=;
        b=CIOOurtYDwFoXuxepqyh9L+yIRsptxRhn9eFJgsAYDBS64TuP1wgbDi35dmkVsN3dN
         /8Dk7dQwZt3lYTCsxx6penVKY8ME9knTbRfIE38f8V35kb0U2ugXLFv+dcjdCkRspAuC
         +IbPiB2XTzBNLzyQo6ige4Car/hXQ8G0bCbj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4AxcTOQKVui/NwP6DTwIb4sEEiLrG+WCJBEpOdH7Qr4=;
        b=UJTQR4sNuH188P1txxH2luojWno1Uu+CrGhiDmazx8U9xpZ5IioPSKFHxrr/VvKwKL
         jYTkw98kpjhRhi9lvpOLfyYJguksciZv20VJb9dJkiNxlUS8A0OBn44v0yrS51hLMHiF
         o1JEg3j0aOdkniJRcFGgR+Y4O5kOTWvQUlmSUBNy0/t3/NrMyZYFSAb29FHPtNtQprCk
         lIIzdOrEtqG9YM8Xg4bUVotuV7FiA16wUELwIx7rfUa1KU64oUJNwuDOB+zXtx2iDUGB
         wWi6wVPlHAAseZB2YoujxxwYZjg3/gubN5dNXTRlHD3sZfdr7xo6LAINSrkCSK8EFTg0
         /P5Q==
X-Gm-Message-State: AOAM531b7vX2khBYrRZRKZ+8R057/Ivl1/XOZGWHLVSrNfbh8JNjhJot
        P6URzmiAcqxIAg4uQ1niY6zLMWcQ6HiIN4LbjZmY/A==
X-Google-Smtp-Source: ABdhPJxpA8+ZR4tuR/KwJMcs10fM0BO4umGfNE/M6+d+ie9XbnHUbVGO0k/0MF+Obn8rVCmmwJs2aUWWDBqh/qIgU0Y=
X-Received: by 2002:ac5:c5a9:: with SMTP id f9mr1853182vkl.3.1626873023287;
 Wed, 21 Jul 2021 06:10:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210427102826.1189410-1-amir73il@gmail.com>
In-Reply-To: <20210427102826.1189410-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 21 Jul 2021 15:10:12 +0200
Message-ID: <CAJfpegsxTjjBo08FfbuGqPPqrR71=c8SE97BiNyFnk-0D0Dgug@mail.gmail.com>
Subject: Re: [PATCH] ovl: relax lookup error on mismatch origin ftype
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Byron <ouyangxuan10@163.com>, Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 27 Apr 2021 at 12:28, Amir Goldstein <amir73il@gmail.com> wrote:
>
> We get occasional reports of lookup errors due to mismatched
> origin ftype from users that re-format a lower squashfs image.
>
> Commit 13c6ad0f45fd ("ovl: document lower modification caveats")
> tries to discourage the practice of re-formating lower layers and
> describes the expected behavior as undefined.
>
> Commit b0e0f69731cd ("ovl: restrict lower null uuid for "xino=auto"")
> limits the configurations in which origin file handles are followed.
>
> In addition to these measures, change the behavior in case of detecting
> a mismatch origin ftype in lookup to issue a warning, not follow origin,
> but not fail the lookup operation either.
>
> That should make overall more users happy without any big consequences.
>
> Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxgPq9E9xxwU2CDyHy-_yCZZeymg+3n+-6AqkGGE1YtwvQ@mail.gmail.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> I am getting tired of dealing with lower squashfs related reports.
> How about this?
>
> It passes the xfstests quick tests and no, I do not have a reproducer
> for origin mismatch, so will wait for Byron to test the patch.

Pushed a simplified variant that just changes the
ovl_check_origin_fh() return value from -EIO to -ESTALE.   Do you see
a problem with this?

Thanks,
Miklos



>
> Thanks,
> Amir.
>
>  fs/overlayfs/namei.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 71e264e2f16b..850c0a37f1f0 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -392,7 +392,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
>                             upperdentry, d_inode(upperdentry)->i_mode & S_IFMT,
>                             d_inode(origin)->i_mode & S_IFMT);
>         dput(origin);
> -       return -EIO;
> +       return -EINVAL;
>  }
>
>  static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
> @@ -408,7 +408,7 @@ static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
>         kfree(fh);
>
>         if (err) {
> -               if (err == -ESTALE)
> +               if (err == -ESTALE || err == -EINVAL)
>                         return 0;
>                 return err;
>         }
> --
> 2.25.1
>

Return-Path: <SRS0=6Laf=AC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7865C433E0
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 12:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80D9223441
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 12:51:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iZbTs1b0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730002AbgFUMvQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 21 Jun 2020 08:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729967AbgFUMvP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 21 Jun 2020 08:51:15 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A5DC061794
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jun 2020 05:51:15 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id m81so16579470ioa.1
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jun 2020 05:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h97N3k0v6bSbHizxJgQHJiDAXQlcJj+2vHgWUNVsq4I=;
        b=iZbTs1b0ifKgZMUjdUXpjRKjtAucNULLcQR0sL1F3LH4vGYO4suUXY4PJZnp/BojcP
         V0lsgpX5IxJaq6h2aIlq0a60Tvz41Unfy24xF9NBG8PnVr4SIxhbFnxWLSB7rpSTx8MS
         0neQPSTJUWGcsL2yAoxNEfHscvWBf5Gr2XO7baFnrE54HcYlPDRHxZdLgxC10/jBhwM5
         BdhaMKl1jGrbFbXdUiwR25GKXuYOUpSlPBXeNqE78Ol6wuqnkIa+ubxTc1aEpdkXPeQo
         e51hLbtORXH13YNQLiESQlUxiPO45aV74dIsn2HnYEMImkj3eQ6qXEFM+k/n58wqSOsO
         7W7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h97N3k0v6bSbHizxJgQHJiDAXQlcJj+2vHgWUNVsq4I=;
        b=npXqeHH/itwN0/sXGX6ZqfcvO2cTX4/Qe9P2CiOqw6cVqlg5w0KmwNPUdXaZVSFVs4
         ByY1evkjrbhdGGCtZj4DhhSgMfYiFQ93oXTL4sIZVNUOczAdm3h0ANmesqPrk+ptrle7
         XDtLalIyxruV0/Ym6RZM07TD1+jKiIvMus09rTGkJF8/qh2c1kjv1SuhG6oDMeIfcPWb
         5NoFECo5LHMVqkwW9adxuY9awH65oCfK1x9FWUomb2d9DGXadYQiO3kWjRCz4O6pMEk3
         8RJ3J7QdPoC8F2WPsrXXjMoTmE+AYeMknxxaHIGHeFzNBsCArHoSIt8wij2iNmZLf9xM
         Gkyg==
X-Gm-Message-State: AOAM533x88CL4jhEvmZJ/IZoYxa7nHQHw2QiY/n8JtiiLgHz/BXJZGe1
        GZNp7ix6hRyhx1PeOcOkhC75Ucfl8KokKbdqVr7YBw==
X-Google-Smtp-Source: ABdhPJyZJcGtEhVK2Ac8OxJavJxWaXOImlcf+lYViADmxibOiv5oJKKna3whQSupXbGAp2wbe453yFuxiANcGKpOJLQ=
X-Received: by 2002:a05:6638:a0a:: with SMTP id 10mr12681317jan.30.1592743874607;
 Sun, 21 Jun 2020 05:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200621124415.65064-1-her0gyugyu@gmail.com>
In-Reply-To: <20200621124415.65064-1-her0gyugyu@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 21 Jun 2020 15:51:03 +0300
Message-ID: <CAOQ4uxgXiL1AZroRAe=mqJhuxXfv57moCdNxL7yAHuV_ONLPiw@mail.gmail.com>
Subject: Re: [PATCH] ovl: change "ovl_copy_up_flags" static
To:     youngjun <her0gyugyu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jun 21, 2020 at 3:44 PM youngjun <her0gyugyu@gmail.com> wrote:
>
> "ovl_copy_up_flags" is used in copy_up.c.
> So, change it static.
>

You have changes from next patch in this one

> Signed-off-by: youngjun <her0gyugyu@gmail.com>
> ---
>  fs/overlayfs/copy_up.c   |  2 +-
>  fs/overlayfs/namei.c     | 11 ++---------
>  fs/overlayfs/overlayfs.h |  1 -
>  3 files changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 79dd052c7dbf..5e0cde85bd6b 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -895,7 +895,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>         return err;
>  }
>
> -int ovl_copy_up_flags(struct dentry *dentry, int flags)
> +static int ovl_copy_up_flags(struct dentry *dentry, int flags)
>  {
>         int err = 0;
>         const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 3566282a9199..3cad68c3efb2 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -389,7 +389,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
>  }
>
>  static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
> -                           struct ovl_path **stackp, unsigned int *ctrp)
> +                           struct ovl_path **stackp)
>  {
>         struct ovl_fh *fh = ovl_get_fh(upperdentry, OVL_XATTR_ORIGIN);
>         int err;
> @@ -406,10 +406,6 @@ static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
>                 return err;
>         }
>
> -       if (WARN_ON(*ctrp))
> -               return -EIO;
> -
> -       *ctrp = 1;
>         return 0;
>  }
>
> @@ -861,8 +857,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         goto out;
>                 }
>                 if (upperdentry && !d.is_dir) {
> -                       unsigned int origin_ctr = 0;
> -
>                         /*
>                          * Lookup copy up origin by decoding origin file handle.
>                          * We may get a disconnected dentry, which is fine,
> @@ -873,8 +867,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                          * number - it's the same as if we held a reference
>                          * to a dentry in lower layer that was moved under us.
>                          */
> -                       err = ovl_check_origin(ofs, upperdentry, &origin_path,
> -                                              &origin_ctr);
> +                       err = ovl_check_origin(ofs, upperdentry, &origin_path);
>                         if (err)
>                                 goto out_put_upper;
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index b725c7f15ff4..29bc1ec699e7 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -483,7 +483,6 @@ void ovl_aio_request_cache_destroy(void);
>  /* copy_up.c */
>  int ovl_copy_up(struct dentry *dentry);
>  int ovl_copy_up_with_data(struct dentry *dentry);
> -int ovl_copy_up_flags(struct dentry *dentry, int flags);
>  int ovl_maybe_copy_up(struct dentry *dentry, int flags);
>  int ovl_copy_xattr(struct dentry *old, struct dentry *new);
>  int ovl_set_attr(struct dentry *upper, struct kstat *stat);
> --
> 2.17.1
>

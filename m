Return-Path: <SRS0=6Laf=AC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AF8C433E0
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 13:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76311206F1
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 13:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hhr05JS/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbgFUNPZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 21 Jun 2020 09:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730071AbgFUNPY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 21 Jun 2020 09:15:24 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31718C061794
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jun 2020 06:15:24 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y5so16515635iob.12
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jun 2020 06:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OJxOsYJTbrFyWJJ9gtCmfgICZPuUWBri+FlSZuDVpGM=;
        b=hhr05JS/+EP1oLRsnl2/4pBVWg9+iAh2WjkPcviP5LkbB7bNYFrSqv2WiyC3PhBizx
         ySFss9FxPOF20Upviba6P0GZovuU4Z9/RevyoNANt927oy5pqBg1niw5nZ2C1Mipj9Ra
         7+e/+kIvAONrBa2qyV5Cwdg5Z6oSEARTkV62La7Bt5rvDtIkyVUp8QlVUpJhNwLKUf4Z
         Y5s9B6AtANm4AizIfOWi1w5LUDG18tt4H4Cp0UP0qgdyNWkL8+bQi//56dEyWcf55yD1
         Hu9AKiTQ5IB4SChlAoVkxJwq1qdjjaZAUw7FdccjHX4Xb9htYS4p46zmxDZNLbknNZ5p
         zXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OJxOsYJTbrFyWJJ9gtCmfgICZPuUWBri+FlSZuDVpGM=;
        b=DkllLCUmUD0HhXNOgbEc5STv/kq6VyjXq0Rvfs0cCjbbgHet+f93uZOOY4E9cu7Ycp
         3hBu4yI/DcgdWbb48ROx+qPWopAmniiN/x2a2AqUduRYP/3v7V7cByJ1OQ66/SsW8VN3
         ZCcXwuwLb6h/DEFzJVA3ATtQoM0BtxRpAsSI1jThj9IiOMFEH8uFOin9m6njex3SfodS
         9qL5SV78CXKOKzgKlIU8Yf315kvub1gFzRY0/DrQRn+kYmFdmNMqxHxajXO1d/CD7T7f
         WtB/vBOA/OpiHpXNDdDMjN0mXOYw8wLLS/8XUgjgMLniMopH399voW4e8j3YLoqHKRkX
         7VXw==
X-Gm-Message-State: AOAM533qI+CsG9j4x/cB98imQll3lOoQJ8jkjC98npeRNti0dWw1XZz7
        QboBun/PseaynPNX2SfTAJlomWfd5P5Xd3zRjvo=
X-Google-Smtp-Source: ABdhPJwqNCFt43qWs99BpZ7zJ2LcXa8G0bn2kIMWzvttLC6y1jqKyG0+pfzCfYRk9NLhWq+MInbJ1RsP8ydvgh+B0u0=
X-Received: by 2002:a05:6638:d96:: with SMTP id l22mr13082823jaj.120.1592745323452;
 Sun, 21 Jun 2020 06:15:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200621125001.65428-1-her0gyugyu@gmail.com>
In-Reply-To: <20200621125001.65428-1-her0gyugyu@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 21 Jun 2020 16:15:12 +0300
Message-ID: <CAOQ4uxhe-iOcm1wTAg99pZuq6Ne78gqij67FgG0tGzXMoSB7oQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: remove not used argument in ovl_check_origin
To:     youngjun <her0gyugyu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jun 21, 2020 at 3:50 PM youngjun <her0gyugyu@gmail.com> wrote:
>
> ovl_check_origin outparam 'ctrp' argument
> not used by caller. So, remove this argument
> from ovl_check_origin.
>
> Signed-off-by: youngjun <her0gyugyu@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/namei.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
>
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
> --
> 2.17.1
>

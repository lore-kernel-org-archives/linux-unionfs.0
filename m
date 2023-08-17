Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59515C2FC1F
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 12:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350929AbjHQMtY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 08:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351023AbjHQMtM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 08:49:12 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973FD2D79
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 05:49:11 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id ada2fe7eead31-44bf46b6f97so567855137.0
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 05:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692276550; x=1692881350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8TnwKUf2dwR0auF0aBpTwGzLgztWItnZyctylAChzDU=;
        b=byLAUzpZJqsNPcwObw8vhA5FHqzXo2bzRLndrRIPYfdp9aL9mQH6NbhEADxCASa8zM
         zr+fomRNQ+ZKat2XdQq8cSMkGhBcd9UnEfkNtZ3Ik0l1LDfBvLdtR+HngKVwz6fl8gGF
         b0f1YBabhcXeO43Wrz6RSFY+NIrotcC7Y1jwwbH1f88/5VQZUaHuK9QHxkeCJ3U4hCDw
         F2I6s4SVOeBaD7rLxE3OHLbTh/mwGK3N02vAwLfY5QmzGaWBQhrDFV6SlOKSd3peov0b
         fABv5I5SCYrQiOcwj7N7cUe0qstAAH/HV4gBSoA64PNH3QRaS2rBF73hcM9qGnuOdMYe
         9ldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692276550; x=1692881350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8TnwKUf2dwR0auF0aBpTwGzLgztWItnZyctylAChzDU=;
        b=OMqojESJRqmyB4KYDPia6vFoTge9tQntLpg25ywXuGp2uJJkpEW9bES8jMYV9eGmCz
         6xagu3odt6hUbO3RsZgCF6kFnJiEE9zhnSb/+cLLXee5fcXWITlIWjVz2TNBbaJJssmq
         yPdOc0pEs0XGP1rM1ssA0d2vETmTgGBRBbDeXQVRv/U6KlK4xEE0QFd6g+ydXg9501zK
         +o/KIUvpoczhxyFceqnS1B/IqT5uvhxLBFbaPwYnDrM8jwfzUpfCeOtQV4wvmFpaeCQz
         hi3b1Eb2FJ/hawMKLPXFXrtu/Dzv8F4NqTpvHIKPSDWSeaZRXVBsOedD0omHq9I2BgtA
         69AQ==
X-Gm-Message-State: AOJu0Yw2drzJzOiv5WynfNcdGrX1IAlNyEY4ZjAwXSIrFiHuyBYe0515
        hew1JJuiXQqXV66eTk5TqeU0IXfTJUMrXZVgER4=
X-Google-Smtp-Source: AGHT+IH5rkPn3gp1OZvveDOPygiGTpNKoBnSgqpe1tApzmRpgG2l/mp0SJ+AAMvWaBtGe2P3a3ml3ttIv2B2ql9Ghaw=
X-Received: by 2002:a05:6102:2250:b0:447:c7a5:c0a8 with SMTP id
 e16-20020a056102225000b00447c7a5c0a8mr1757914vsb.9.1692276550558; Thu, 17 Aug
 2023 05:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <2e308a817498e248e4a8085b50cfb12e4fd28be2.1692270188.git.alexl@redhat.com>
In-Reply-To: <2e308a817498e248e4a8085b50cfb12e4fd28be2.1692270188.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 17 Aug 2023 15:48:59 +0300
Message-ID: <CAOQ4uxiL76NZWjKR96Q_gvW45i+00PODRnay9ansVo5fNgU2_Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] ovl: Add OVL_XATTR_TRUSTED/USER_PREFIX_LEN macros
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 17, 2023 at 2:05=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> These match the ones for e.g. XATTR_TRUSTED_PREFIX_LEN.
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/overlayfs.h | 2 ++
>  fs/overlayfs/xattrs.c    | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 1283b7126b94..ef993a543b2a 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -28,7 +28,9 @@ enum ovl_path_type {
>
>  #define OVL_XATTR_NAMESPACE "overlay."
>  #define OVL_XATTR_TRUSTED_PREFIX XATTR_TRUSTED_PREFIX OVL_XATTR_NAMESPAC=
E
> +#define OVL_XATTR_TRUSTED_PREFIX_LEN (sizeof(OVL_XATTR_TRUSTED_PREFIX) -=
 1)
>  #define OVL_XATTR_USER_PREFIX XATTR_USER_PREFIX OVL_XATTR_NAMESPACE
> +#define OVL_XATTR_USER_PREFIX_LEN (sizeof(OVL_XATTR_USER_PREFIX) - 1)
>
>  enum ovl_xattr {
>         OVL_XATTR_OPAQUE,
> diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
> index edc7cc49a7c4..b8ea96606ea8 100644
> --- a/fs/overlayfs/xattrs.c
> +++ b/fs/overlayfs/xattrs.c
> @@ -10,10 +10,10 @@ bool ovl_is_private_xattr(struct super_block *sb, con=
st char *name)
>
>         if (ofs->config.userxattr)
>                 return strncmp(name, OVL_XATTR_USER_PREFIX,
> -                              sizeof(OVL_XATTR_USER_PREFIX) - 1) =3D=3D =
0;
> +                              OVL_XATTR_USER_PREFIX_LEN) =3D=3D 0;
>         else
>                 return strncmp(name, OVL_XATTR_TRUSTED_PREFIX,
> -                              sizeof(OVL_XATTR_TRUSTED_PREFIX) - 1) =3D=
=3D 0;
> +                              OVL_XATTR_TRUSTED_PREFIX_LEN) =3D=3D 0;
>  }
>
>  static int ovl_xattr_set(struct dentry *dentry, struct inode *inode, con=
st char *name,
> --
> 2.41.0
>

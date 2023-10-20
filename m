Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF48ACDB474
	for <linux-unionfs@archiver.kernel.org>; Fri, 20 Oct 2023 12:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377037AbjJTMWC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 08:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377028AbjJTMWB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Oct 2023 08:22:01 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8BFD41;
        Fri, 20 Oct 2023 05:21:59 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 46e09a7af769-6cd09f51fe0so458554a34.1;
        Fri, 20 Oct 2023 05:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697804519; x=1698409319; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WE4Xd/pUnVPUoI/kaobw+0kr+Nv0OmZQE5D3yZZFPmQ=;
        b=C9CkalTT5tRCN3mcFggOO8LwKZJYFJqjRsTmuTJ1tAUx0xiU3F9ps2iB7TTMRRRyol
         xMT5DXA5yvREAat3WXNGzAR2C/5+itTUwH8IyJl5UjuU/CzqoNGSV7IyvCWbDjx3TTOS
         IFy1+Kst9/vSQaPW659J3mtwKT8RZDPNXzz10uFZF3j3RgGgoB1tRbS62AhOIXbRQ5L2
         Xr/IXnjH7dsTQAGS/L3+gHfNCc8hA2BQ5umtuOMkg21Tru6J1dQ7itaUaimPAfupK0Nl
         W81Qy650VWi0JnaVJl3yUKsYccv9ZDhodsAaRo0QAqBLloE7yY3ZU0eQLI+gTeyu8IC7
         eKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697804519; x=1698409319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WE4Xd/pUnVPUoI/kaobw+0kr+Nv0OmZQE5D3yZZFPmQ=;
        b=k3SKjE5RkaGDV7IP3sgHRKP2x6dndqjZ2fzXS1o4Yx2SmR1wKI2v4iOeoNggwEPb3Z
         ViQf5NpeCj5+sXlTfyuXPHi4OgYaqyRCEc/wHYV235F4UcYvrWTn4IcvAc8Le1S9Lvpe
         QEuEOChVoN2DZJQXqY8Ezjb31qTvJLQPMFuVCjIynUsV2PjdvB+PYZ6ymbOKtwGRiXug
         eMrnJ+P30xCVfJYJgx6fhJ6nXBNjBTvvUKSWWyRpoxWJxhXxR3PYwndawVhLbQVV3F1B
         2imXeQxcvD+mF+mGtIR4jZpPB0pvcACGqgVDso47pYfxuzQV/jbWDiojh8sUNtfCNhI8
         67vQ==
X-Gm-Message-State: AOJu0YzrDoZBt25nDgXmws2yGQjV94Ja8W2+1gcz+fdFsDitQJyUOLIf
        eNhViaaR1ekiFTPAmV5n4AG9Z5Gn9rTB7ojleFU=
X-Google-Smtp-Source: AGHT+IGoEJxvxnBSR4wsCDq9Z7qiH9WEOCX55RcxPwstQUTFOdQShMSnX7MzdT897ET6ijpikM4es0tk4VCcRhx4neM=
X-Received: by 2002:a05:6830:4a:b0:6bd:be5:daa2 with SMTP id
 d10-20020a056830004a00b006bd0be5daa2mr1692451otp.33.1697804518615; Fri, 20
 Oct 2023 05:21:58 -0700 (PDT)
MIME-Version: 1.0
References: <20231018100815.26278-1-ddiss@suse.de>
In-Reply-To: <20231018100815.26278-1-ddiss@suse.de>
From:   Stephen Smalley <stephen.smalley.work@gmail.com>
Date:   Fri, 20 Oct 2023 08:21:47 -0400
Message-ID: <CAEjxPJ6o8T=K+FHEHdWxn1PQN=Ew+KjooXL=coS0gx4YLuEFhw@mail.gmail.com>
Subject: Re: [PATCH] RFC: selinux: don't filter copy-up xattrs while uninitialized
To:     David Disseldorp <ddiss@suse.de>, Paul Moore <paul@paul-moore.com>
Cc:     selinux@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Oct 18, 2023 at 6:08=E2=80=AFAM David Disseldorp <ddiss@suse.de> wr=
ote:
>
> Extended attribute copy-up functionality added via 19472b69d639d
> ("selinux: Implementation for inode_copy_up_xattr() hook") sees
> "security.selinux" contexts dropped, instead relying on contexts
> applied via the inode_copy_up() hook.
>
> When copy-up takes place during early boot, prior to selinux
> initialization / policy load, the context stripping can be unwanted
> and unexpected. Make filtering dependent on selinux_initialized().
>
> RFC: This changes user behaviour so is likely unacceptable. Still,
> I'd be interested in hearing other suggestions for how this could be
> addressed.

IMHO, this is fixing a bug, only affects early userspace (pre policy
load), and is likely acceptable.
But Paul will make the final call. We can't introduce and use a new
policy capability here because this is before policy has been loaded.

> ---
>  security/selinux/hooks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 2aa0e219d7217..fb3e53bb7e90c 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3527,7 +3527,7 @@ static int selinux_inode_copy_up_xattr(const char *=
name)
>          * don't then want to overwrite it by blindly copying all the low=
er
>          * xattrs up.  Instead, we have to filter out SELinux-related xat=
trs.
>          */
> -       if (strcmp(name, XATTR_NAME_SELINUX) =3D=3D 0)
> +       if (selinux_initialized() && strcmp(name, XATTR_NAME_SELINUX) =3D=
=3D 0)
>                 return 1; /* Discard */
>         /*
>          * Any other attribute apart from SELINUX is not claimed, support=
ed
> --
> 2.35.3

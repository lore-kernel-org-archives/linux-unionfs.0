Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 644F5C41513
	for <linux-unionfs@archiver.kernel.org>; Sat, 14 Oct 2023 15:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjJNPcj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 14 Oct 2023 11:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbjJNPcR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 14 Oct 2023 11:32:17 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CCDCA
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 08:32:15 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-66d0ea3e5b8so19252446d6.0
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 08:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697297534; x=1697902334; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DGcXVaGztrzOgbNFsFlrP6EDQTP+kKft2vVr37CiG6Y=;
        b=Ch42YwhNcTCOLVyjUB+l+k+Dn1Ar9AXV7oC4u1Al5zmBEhkF+M8Hxu7FAAuSlVDw77
         WLt7eWs+OshJhRGqM4rPWUBDvC2yDjHO4kpQ0h4ZoVQlX1M9IYdwjtRkYoB2+N6OHu63
         /JxXOf+q9kBf0dzVANwD3Sg7zxCAU7tUCaiDKhX6K3HIUTtiXjXVKXR7h2xImYiReYRK
         gL+wX+iCGm9SIzKWmuFv3g0XkFnGQzQD4jFkbgS784dRb9ljBVn1JnOkJqOOVdpoS1Vj
         RoUfV2XkSTBMutxjF7EKebFTFdXh/AlOyne3odBds1htKahfEnnG9RjsggIXoxeawIDl
         M2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697297534; x=1697902334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DGcXVaGztrzOgbNFsFlrP6EDQTP+kKft2vVr37CiG6Y=;
        b=HFMcsaj5215j8vIza6+mJN81yA522HYq6t4HwQcezFmh0cCzISEhXamaeG9FwbMB+D
         5LpdNYwJmlHDJ6c/UZPtD/ppGfk68Ur6s7KgpYaLSqNpXknXtKg4DAadoeOX4QrXs0Ub
         8hMfdqVlkO06FbRWg3b4GVX6Bj6jM/aP8yL6WNcEX6YFxTFV/N4mbc2DenDTNi1p8vjf
         Yj0eJDKdruu60BSFiAkpRensC/ftbnBIVG22dxtO7XBmJqiPmBuSgHLzWbcb7C/Z0Ot6
         TemtgS/1Zwpu8FPd5nxaCRW0NrJKv86HcPg3v/ewO3Fbvue0Ihz+A9Vr8zH3YKNNt3R8
         JRag==
X-Gm-Message-State: AOJu0Yw1ndRqX4rHYZavF/zuzZPTReEeJNLX4JZfTkBalN/Q3ONrFJbe
        TFBSX3afvBtfdQt+a0PZed8IKD3Hpu2H6WGZQBE=
X-Google-Smtp-Source: AGHT+IGhUp8cdcLLOJOj4x/+GnmDgwLTAeGiXEdzTIymQsIAnb2KwMV1Pwkuljm3jobjPC0BLY0v/VRKk0CD5QFAhQs=
X-Received: by 2002:a0c:b2c5:0:b0:66d:43be:7e45 with SMTP id
 d5-20020a0cb2c5000000b0066d43be7e45mr903899qvf.43.1697297534081; Sat, 14 Oct
 2023 08:32:14 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com> <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
 <CAOQ4uxiE89q62JHnxwm14FBShPORmX_h0EyDCBN-VKv6aTf5BQ@mail.gmail.com>
 <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
 <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com> <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com>
In-Reply-To: <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 14 Oct 2023 18:32:02 +0300
Message-ID: <CAOQ4uxic3NDtEt9EiP+RYKGEB=6b_PCaudQA=cXK6mWY4Cmeqg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Oct 14, 2023 at 5:09=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Sat, 14 Oct 2023 at 10:24, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > Being extra nice and displaying "a\,b" and "a\:b" for new users that
> > used new mount api explicitly to pass "a,b" and "a:b" is possible, but
> > it is not a 6.5 regression fix, so we can take the time to decide if we
> > want to do that or not.
> >
> > OK?
>
> Yeah, I'm mostly convinced by your arguments.
>
> The other issue that has to be decided pretty quickly is whether to
> leave the append mode (starting lowerdir with ':') or remove it now
> and replace it in the next cycle with a mode that doesn't play games
> with separators (i.e. adding layers one at a time).
>
> The only argument I can see for the current append is that it's
> possible to add multiple layers at once, but it's also redundant once
> we add the one-by-one append mode and I'm not convinced that it's
> worth the complexity and the mess with having to escape separators.
>
> What do you think?

I think that we can leave the string-append mode, but disallow ':' and '\'
within an appended string, so we only support adding lowerdirs one at
a time and no support for special chars in file name, so escaping is moot.

This way, we do not complicate things and leave the functionality intact.
Sure, it's going to be redundant once we add support for
FSCONFIG_SET_PATH*, but the added code to strip the ":" or "::"
prefix for FSCONFIG_SET_STRING is not really complicated.

I can add this patch if you agree (without all the possible code cleanup).

Thanks,
Amir.

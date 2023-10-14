Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A17ECCDB465
	for <linux-unionfs@archiver.kernel.org>; Sat, 14 Oct 2023 14:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbjJNOJs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 14 Oct 2023 10:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbjJNOJs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 14 Oct 2023 10:09:48 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6357BF
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 07:09:45 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9b95622c620so526671466b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 14 Oct 2023 07:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1697292584; x=1697897384; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AokQa2I/CWNbCfYcVfySYmNfGywmL4QVkpjOkxDV1NI=;
        b=C23T2ROuJtqXztQM7GIaH7ORkx7QtMN2lneJ/gg3g4bfzTei4roaHeLBwHmiPTWe+F
         EzM4w7cQYZ/Jowmf/9QnL+nXe/J0siY3coWyEnCGUpJjE5nFZydp3Qwst8takQb/v8LH
         h4yDtOnbS5vZgbg7/VTEMqxabGA7DJt/GDiS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697292584; x=1697897384;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AokQa2I/CWNbCfYcVfySYmNfGywmL4QVkpjOkxDV1NI=;
        b=tTmPQdntJEz+EpjIs8ObBHNpqBJ7a1weo1zO/WDzzFR8pNSN0kdQOz4yaepKDzWy0X
         z/lw0AMsRiUTPg8a7JcLfEaqYPF2AV9YacD3kX5g59YiYD6eI6hj9aB5LmyLRD4TgWqv
         Zp1xBYmavnFCXlBpT3/fnGEP1NuvcpEO2SQp9/6mujMekxcNynq8xiaxNC+O16jXgu0D
         C0Fjwx5CsUxBH682s2GX5lNCeGNbRVJ68DQf1DIcJ0EBRQuGuaPdLHk23WD6rUW5155j
         XxTU5I2SiCUtjNKPZ9pCOyxlImuocnLf/SM/UVAZKVIm0+xwHGqInnq9bf0r6w4K1lWH
         P9sQ==
X-Gm-Message-State: AOJu0Yy246DL4uEBqurMuIcokkrheJoavEWCiuPIwfJkw13dQZ3N2Egu
        goPmKW+bEyd1IBY4v+JrXyIwKsfgjAKnufJ6Oqf64g==
X-Google-Smtp-Source: AGHT+IGO/5KvTKnj6GDi5rfNv81Jfoda9Z1zy/igM/ycp1nkznA5GfBwl9kn/5DgxYRllvre3LdmLxJ3gmLtEz5pp2o=
X-Received: by 2002:a17:907:c205:b0:9b2:d78c:afe9 with SMTP id
 ti5-20020a170907c20500b009b2d78cafe9mr25372855ejc.49.1697292584213; Sat, 14
 Oct 2023 07:09:44 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com> <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
 <CAOQ4uxiE89q62JHnxwm14FBShPORmX_h0EyDCBN-VKv6aTf5BQ@mail.gmail.com>
 <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com> <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
In-Reply-To: <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Sat, 14 Oct 2023 16:09:32 +0200
Message-ID: <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 14 Oct 2023 at 10:24, Amir Goldstein <amir73il@gmail.com> wrote:

> Being extra nice and displaying "a\,b" and "a\:b" for new users that
> used new mount api explicitly to pass "a,b" and "a:b" is possible, but
> it is not a 6.5 regression fix, so we can take the time to decide if we
> want to do that or not.
>
> OK?

Yeah, I'm mostly convinced by your arguments.

The other issue that has to be decided pretty quickly is whether to
leave the append mode (starting lowerdir with ':') or remove it now
and replace it in the next cycle with a mode that doesn't play games
with separators (i.e. adding layers one at a time).

The only argument I can see for the current append is that it's
possible to add multiple layers at once, but it's also redundant once
we add the one-by-one append mode and I'm not convinced that it's
worth the complexity and the mess with having to escape separators.

What do you think?

Thanks,
Miklos


>
> Thanks,
> Amir.

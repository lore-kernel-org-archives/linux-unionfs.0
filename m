Return-Path: <SRS0=S/v9=A2=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EE4C433E4
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 19:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 952B320657
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 19:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="hazK3jua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGOThZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 15:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGOThY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Jul 2020 15:37:24 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668A7C061755
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 12:37:24 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d16so2499557edz.12
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 12:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PrT4uU0p/TSJ/j4uUUrNumDxtSAJ8ZGaRKNTuySfpA4=;
        b=hazK3juaBKbG3a4QTYrmXwGmNSClEsNRPLXAxKOz4v6x58OSHqEJtin7YgTxADHK80
         sEV0Q8pwMJawqQWXkyCMhgZ6hf7z3gStunqKpYhF+tk5+yUOozJmThSQG28vZHvsWzum
         RS7KF2PJ6l27cPnjEyQM4bHlHU1AJBQm9euco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PrT4uU0p/TSJ/j4uUUrNumDxtSAJ8ZGaRKNTuySfpA4=;
        b=bj/tg8Io3sd0USPf2jwtHxVvv7jlowavinztofGgMxNo26JH54NPwPRU88hj7DsNTo
         VuvSzB8wKzxTYVCLjVFqr4NaAoLNyRx0kmekDAxuhdVVW4Ov1B+ygejZ9Olu8bekJgB7
         Sv0JEb7tQNaBUStS7PCG4yFm+BgKChvbIWZtrI5Zwd1rOX4ldKrkRqhI3fmxCUtGk/Rv
         bGHtO7QLj0qX+RDMY2Yx8kKakWfNt2fN4hooKjii3zmqrNI2ovdI4PIG+pbtfCopWfhy
         k7NM+3GRQM16eLA1ZNlMAJcxY6GpMb1+pBDXfpq0yRpXPm6sdl+8HadjdYhcRRChy0ZC
         oX1g==
X-Gm-Message-State: AOAM532jnNRWF/IZ5ASJoCtHaqPvZtrf86HiVuesD65eR5J8J7gptcc8
        rEi6pQVoIzGNxgb+o57MZ1Y/hAciS39YyLZ0lRa3hA==
X-Google-Smtp-Source: ABdhPJx2KwBox+MrLaa1wCOW0HNz/A+Z78nQRU2A7Z7SP4b+AFfurpYlrkqh6FAxUBY/gGaMTscTbWZ9ftkJIJDNUvU=
X-Received: by 2002:a05:6402:1bdd:: with SMTP id ch29mr1210101edb.134.1594841843152;
 Wed, 15 Jul 2020 12:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200621143059.66313-1-her0gyugyu@gmail.com>
In-Reply-To: <20200621143059.66313-1-her0gyugyu@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 15 Jul 2020 21:37:12 +0200
Message-ID: <CAJfpeguAwn72ZGE6JJbanRmiSiGjrtWAUPu4mFVc4gUAAnooqg@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: change ovl_copy_up_flags static
To:     youngjun <her0gyugyu@gmail.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jun 21, 2020 at 4:33 PM youngjun <her0gyugyu@gmail.com> wrote:
>
> "ovl_copy_up_flags" is used in copy_up.c.
> so, change it static.
>
> Signed-off-by: youngjun <her0gyugyu@gmail.com>

Thanks, applied.

Miklos

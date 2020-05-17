Return-Path: <SRS0=O/kl=67=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B149C433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 17 May 2020 16:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D69D720643
	for <linux-unionfs@archiver.kernel.org>; Sun, 17 May 2020 16:42:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EhUbq1iO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgEQQmo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 17 May 2020 12:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgEQQmo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 17 May 2020 12:42:44 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF17BC061A0C;
        Sun, 17 May 2020 09:42:43 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d7so8008604ioq.5;
        Sun, 17 May 2020 09:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FE79B1sBhL7HCjYBuhTPYrTnaeatbUnZ5hvj8cInxOw=;
        b=EhUbq1iO+3UMjcqsJV9vy0zMiP2GtGSfbLMCCxu9iq5zkPO9wbjPKZXWqDWvEnib0M
         DAesjcHLEU46468FB2k5eRUuff8/Fld9yVIl8tJsM5s8r0j2a+f2yvC/ySCIpXPSNMXS
         MtNGbTSlFcVXEx6krRnZloxzMqCn+qz8X1gQ0rzC6TlIZH0HoTvlRPxbV5yeJiijqdOQ
         de+xpnT6zq+uKOMC5mFGiXZNxR0/6ullzAACM1HM0ga1kO926D4vUP8XQ6g9VC7bNXrf
         hRnBNqn+v3kEtWqe9ZSipGdawvRObdDoDZ0YEQRem2/YPr4YP/ZkBvKLRx+IRZSwjb7q
         9dNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FE79B1sBhL7HCjYBuhTPYrTnaeatbUnZ5hvj8cInxOw=;
        b=M9BwH0UwjhWWILjkfsr1xvXJDkH0zv66iCeiuifHfHBpkPAxWOCI8jJVt0+cjteqpR
         5QiYcQtHWidEo/2smwmSHxybyQzW9f0w4IZW24JtUeW+4oInPMizOUogzLXExNLgGcEm
         Rjx6FlfuO3q9ECQkM0YF/Dzeck9hpEEkbNmUe89z2QraUDt137ft0fjWfb+SfDJJzqOE
         Vyub++Ua1/85ph5l7FduGGAKJqSmtw8HOlszoJIF4DJwVb7u2U8jz+mZ3tLqGASmEcG2
         8NFEAYWZT1YRRsfm2/1C8g4iws2JRkn7ZPPuL3yVsxcGaGmJgEAvW6QdxSJCspKu7bI7
         iJjw==
X-Gm-Message-State: AOAM532ctd2zR/EXEE+VyM77SrkV8JryMUYt6ojgYbQoX7DtlqZlOYh3
        tz/tCac+abR4CtjrgvfCV5sIvWUmPs9L4T4/BgSEJG2L
X-Google-Smtp-Source: ABdhPJznXQDThdd0HSYSGDA6uUxS+O905+vKl/E2RCDzAMc9oAHidP7iv/507SxCL06eptT29CITPhkj/NsGNMDuJl4=
X-Received: by 2002:a5d:8c95:: with SMTP id g21mr11110931ion.72.1589733763225;
 Sun, 17 May 2020 09:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200513192338.13584-1-amir73il@gmail.com> <20200517162418.GG2704@desktop>
In-Reply-To: <20200517162418.GG2704@desktop>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 17 May 2020 19:42:32 +0300
Message-ID: <CAOQ4uxhtOSsi41z_kCA2ihCKVEg3FTxg892OHgCB22j60LQHoA@mail.gmail.com>
Subject: Re: [PATCH v5] overlay: test for whiteout inode sharing
To:     Eryu Guan <guan@eryu.me>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 17, 2020 at 7:24 PM Eryu Guan <guan@eryu.me> wrote:
>
> On Wed, May 13, 2020 at 10:23:38PM +0300, Amir Goldstein wrote:
> > From: Chengguang Xu <cgxu519@mykernel.net>
> >
> > This is a test for whiteout inode sharing feature.
> >
> > [Amir] added check for whiteout sharing support
> >        and whiteout of lower dir.
> >
> > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Chengguang,
> >
> > I decided to take a stab at Eryu's challenge ;-)
>
> Great! Thanks for the update!
>

FYI, not sure if and when that was mentioned.
inode sharing feature is now on overlayfs-next.

So are the two file handle fixes for which I posted the test:
"overlay: regression test for two file handle bugs"
(will re-post when I have the final kernel commits)

Thanks,
Amir.

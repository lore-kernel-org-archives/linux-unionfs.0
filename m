Return-Path: <SRS0=Y+g3=5M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F37EC43331
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 Mar 2020 18:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02A172083E
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 Mar 2020 18:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IdXZfipU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgC0SVR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 14:21:17 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46928 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgC0SVR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Mar 2020 14:21:17 -0400
Received: by mail-io1-f67.google.com with SMTP id i3so1641962ioo.13
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Mar 2020 11:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eUTPmdhRimYwJkCfKtCFZJQNrwezwnbAqLiHlpCbWzc=;
        b=IdXZfipUhJx0fwjvDxEmfcH9P+RvALNDFqcyNLcq1uV7lKbpIqZTwiU8TirkbnH3/8
         2DGnEXCwc7t/wAbw7oCizPcf+BO1nOrGAFOajjGaz6OH4jwBa3EKQ1szABjAApItOavk
         n5cSeMrkBwJZ7moDBzoPxQHT23+vJFK7YNW4YBWqkrupHD3i11qIRBQwcFlaSTQaCvyw
         0UMiOcz2o9fA69cbbA18pgKR6pRJaqM7ftSPqllmAEvweACWzApqNePF3tA9ZLR+NTNL
         FlG6B6yGMyZ0a6+VPy+CZYBMLmPcGP56pmACD92MbWRTMSfBZB9bKPF+25S6kJYOxR2M
         hJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eUTPmdhRimYwJkCfKtCFZJQNrwezwnbAqLiHlpCbWzc=;
        b=rHgjq68RU234cE/xLCZw4j2iZ/KQ7f6xlFiLzq8gfH0cpHFxxO/lRnHn4BJAXbGfLZ
         pMWvdPov1wuNljDRr7yA+//qehbGwcBp8wVJiBNiUXGPxQ+mTw+LXkmpWsxlvBAK9NxL
         ytlUr9k0dwZ3lFoUeQZZ3wNPpmJcq0zwoXKRQG45gZ5mH8oZA+u4UkKgApOsPDQjjLAm
         N0pXir079kxAHnZZXdcKtI8kRU9f9uU+IkISSaAonMRa49xtpGXpBjYzcp0Lc8n0hKHu
         dTZhdFKA7sDTBCJZA31Kf+3GgJJub846JxjKWQA7s34uvFc+Xwu49LwUcgrZAbQvpPqR
         bS1g==
X-Gm-Message-State: ANhLgQ3I6s+DH94ywfr0EcqFUR+gQlAUU6FAlXurLoxBPNeupzmMKMmN
        zBwoULT6j2mA1hZGLqC64M1jh6cKyyF2L5wmHms=
X-Google-Smtp-Source: ADFU+vsho/ZqcXFgQf6ia8x95jKNac8NCrveUNWUh6rsEk4h4LfVHcQbHlNoNbPNb2y08385YqGKPz+1CLWVsLbY1So=
X-Received: by 2002:a02:304a:: with SMTP id q71mr132616jaq.123.1585333276501;
 Fri, 27 Mar 2020 11:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200221143446.9099-1-amir73il@gmail.com> <CAJfpegt2bDr_2Ab4Pg-TQphyb7fkJpponsnFZnZT13wiZQ4nQw@mail.gmail.com>
In-Reply-To: <CAJfpegt2bDr_2Ab4Pg-TQphyb7fkJpponsnFZnZT13wiZQ4nQw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 27 Mar 2020 21:21:04 +0300
Message-ID: <CAOQ4uxjaCtF81QiX2J1MkakhDEHp8+fJCqD-NtLOQp3x80JbJQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Misc overlay ino issues
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Mar 27, 2020 at 6:59 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Fri, Feb 21, 2020 at 3:34 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Miklos,
> >
> > This is v2 of the ino patches.
> > v1 is here [1]. I reabsed to overlayfs-next and addressed
> > your comments on the ino collision patch.
> >
> > The branch passes overlay xfstests including the new tests 07[01]
> > that I wrote to test this series.
> >
> > Note that i_ino uses the private atomic counter not only for xino
> > overflow case, but also for non-samefs with xino disabled, but it is
> > only used for directory inodes. I don't think that should cause any
> > performance regressions and the kernel gets rid of a potentially
> > massive abuser of the global get_next_ino() pool.
>
> Pushed these to #overlayfs-next
>
> I'm running my tests, but the more the merrier.
>

Looks good on my end, including new overlay/072.

Will post it.

Thanks,
Amir.

Return-Path: <SRS0=xMp+=BI=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB048C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 29 Jul 2020 05:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E015206D4
	for <linux-unionfs@archiver.kernel.org>; Wed, 29 Jul 2020 05:51:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IBGaqRRB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgG2Fvs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 01:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgG2Fvr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Jul 2020 01:51:47 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3530C061794
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Jul 2020 22:51:47 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id v6so8056240iow.11
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Jul 2020 22:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGFrHmiFaG+4vJxCAa9nAFD+Ucgll0CQfR6hnOIOXZA=;
        b=IBGaqRRBtxYlzzkQ60L0B/HLl0eQ5TLdqS+5Sm4u24OOI2qb9NVq8PrR05tyT8NsS/
         SHtiP/ykOMe3G48tJ7Mcsz3V+pm9rqlHDRE2cEI+UNmQ3oFOUCF22KlF6diJRWhk5x0n
         HXicI5U+oIFQcrmbhR5NZPhAJBWQLDCqbEIinVkwWTh0CD1J0IIE3Yk7OQ6gkjLA4aI1
         +STgp6Q8a9QrKNmoCDhu1g0G4Cvd6U7TBBOqy4mkbJgGyoTQt5Q3BeiVkoMPgUgVC+h5
         QRg8IwlZu7J2nt2mS6OTkh46KbH0vVYwWpKd7IqmRmezVCMI1J5fQouFc1ufItEmb+ez
         ngPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aGFrHmiFaG+4vJxCAa9nAFD+Ucgll0CQfR6hnOIOXZA=;
        b=R4HUdik1BaH+EqDYJk7BQP7AHDXPEXAyCl5TVN6M8xyVWG5stTMwqOUO0APiB+o1x4
         lpFb5tVjWNO9ufeWRZWpEgpl35FeniN9c/jyUvNUkTN4R47doCNdp8A6pJGS++cj837n
         guf2yEif5DfuQUeo+1ocZzUdGCyt2sHzuybLEkDOz7iqaR74vteN8zW7JQtr5PSAdVcb
         qZy5iX8NcVgvhF6w4AMFB/kEzGVF1PWF1rUzO3N+m9K8myDc7v36CDz82Nhg6rQzOtQs
         1tN/iBZSDZAGuP5OXwzHCucIIDqRtQLs80VQpKS85lUFRyzfbUyl/tzC0Iax9iWVSf+A
         tseA==
X-Gm-Message-State: AOAM533bbbB96AOePQgEzgT5IpBWJhn0X///c6F8Bab5Xx1L2aiU64hG
        5ePahOAu2cG5Ltx41pE7nOqRSAn97a+ddA9o93I=
X-Google-Smtp-Source: ABdhPJwqY3U1nyow2ah5erfX+OVHzALXaRfvsJuCKH2x2gJ1VEPvzjE3EM5EipfennEqIbKXPGtW1k1qXq3f6D+4Wgc=
X-Received: by 2002:a6b:ba03:: with SMTP id k3mr25568718iof.72.1596001905800;
 Tue, 28 Jul 2020 22:51:45 -0700 (PDT)
MIME-Version: 1.0
References: <1750303.WlVpaa6DS8.ref@nerdopolis> <1750303.WlVpaa6DS8@nerdopolis>
 <CAOQ4uxgm8dHd2EQPgD_a7aKwFUQFKGZg9O7K_FsuJGuWH=P8pg@mail.gmail.com> <7866875.n4lXpxAzLT@nerdopolis>
In-Reply-To: <7866875.n4lXpxAzLT@nerdopolis>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 29 Jul 2020 08:51:34 +0300
Message-ID: <CAOQ4uxj3oPfbdCt1bLrSp91O_QD4cqPBxqc6ZVgS3kXXDnDBfg@mail.gmail.com>
Subject: Re: Incorrect Overlayfs documentation
To:     nerdopolis <bluescreen_avenger@verizon.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 23, 2020 at 6:51 AM nerdopolis
<bluescreen_avenger@verizon.net> wrote:
>
> On Thursday, July 16, 2020 1:03:52 PM EDT Amir Goldstein wrote:
> > On Thu, Jul 16, 2020 at 6:09 AM nerdopolis
> > <bluescreen_avenger@verizon.net> wrote:
> > >
> > > Hi
> > >
> > > A while back I opened up https://bugzilla.kernel.org/show_bug.cgi?id=195113 describing a documentation problem in
> > > https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt but for whatever reason, it hasn't been seen.
> > >
> > >
> > > The problem is that it says "The lower filesystem can be any filesystem supported by Linux"
> > > however, this is not the case, as Linux supports vfat, and vfat doesn't work as a lower filesystem
> > >
> > > So there's no way to tell what filesystems are applicable for an overlay lowerfs,
> > > and I don't think any existing userspace utilities can detect it.
> > >
> > > Could it be possible for the .txt file to be updated?
> > >
> >
> > The way it works usually in this project is you can submit a patch to fix the
> > problem:
> > https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html
> >
> > But if you don't want to go through that process, you can offer a text to
> > fix documentation.
> >
> > But I myself cannot offer anything better than:
> > "The lower filesystem can be one of many filesystem supported by Linux".
> >
> > I don't think that we want to start listing the supported filesystems in
> > documentation.
> >
> > FWIW the description of upper fs isn't uptodate either.
> >
> > Thanks,
> > Amir.
> >
> >
> Hi.
>
> Yeah, that process might be cumbersome. I guess what you have is good.
> Maybe "A wide range of filesystems supported by Linux can be the lower
> filesystem, however, not all filesystems that are mountable by Linux have the
> features needed for OverlayFS to work"
> ?
>

That sounds good to me.

CC the maintainer in case he wants to apply this documentation "patch"
himself.

Thanks,
Amir.

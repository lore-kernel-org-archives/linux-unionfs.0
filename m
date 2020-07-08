Return-Path: <SRS0=DgkE=AT=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F989C433DF
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 08:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44C6122205
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 08:50:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RpnuXJgx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgGHIum (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 04:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbgGHIul (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Jul 2020 04:50:41 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA285C08C5DC
        for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2020 01:50:41 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id e18so27687524ilr.7
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2020 01:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ouB6Cy7MdKm+GqNGbLLsc7FDSiy9EomtNcR/ksin8ac=;
        b=RpnuXJgxLoIzUDFsPHuKPeuBUwp1Sd6I/5y45RLIWLx4VZtVi+QZW943zghmpaEO3P
         fMWBtRp+aGI90K7gumQAr8DwMAmypmnX2vaZqxGwrngG2Kd6Ry/5xJSAwR2KygTIajS1
         fH1Jw4LC3IjvSyEDG+X5suTRQ210blTUiAHSDYh9o6itlGXrT778O6/cEOopxUNMxvnT
         +RMxrJ4Dh1vM1wZlTbSAiCBogRCfqKQt4fsGUjp8UlFOdJOOXUOd1/ngG4EQQov4N2CS
         rP9SyXqaVQHvF0ZFmlhov9WoHenYm1alORFhDAxOuxLs9qnhlEYnM5cnt/hO8iRhfFq5
         1ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ouB6Cy7MdKm+GqNGbLLsc7FDSiy9EomtNcR/ksin8ac=;
        b=gNbJHtp/7EpQ0z4GRcIIpfuTE5gSk6i2ESuj5DlA6xEFPCOtCMalOs180vMzWlDYro
         LR3MKhxG2IUI5iPspofzNIgPSRSls0WpLGDRkTOELPymjuTV6ikvkklOrs4JpXlk/3VR
         0AWhTtelv0otnj20J4r/eD/FWdRYvs46Ill7m4V1W+31ZCkt0dc2elBmUdwWYzKNBhzF
         Qa8rHfbfBciu3be1pEGnVhE+kMrHNzSSeDqRWyCx2+LRWV/LAI2LDx8EAImEDtA0uYzk
         y/VESmsF6LmtK+34JhHYmGDiCUyPGfjv0ts7iwGo6C09y/36J+wnZZAe25vRYusc9Gp2
         UUaA==
X-Gm-Message-State: AOAM530vLViScTDW5S0RtTkyWcLhB8MIvZfQ48SecKT8sv5D8XgDLfmg
        HTET9OC4Tm1JUQ3+u+kvCK9BLqYk0EPjhs/yu2I=
X-Google-Smtp-Source: ABdhPJz95JE69mhvbIPM+FMy5lPITn44HZ/pc2KPWUnSSAThsWocyuxa39qrrUuuNH9b/5EzLTpIobYsJjkAXksVjEQ=
X-Received: by 2002:a92:490d:: with SMTP id w13mr20944845ila.250.1594198241014;
 Wed, 08 Jul 2020 01:50:41 -0700 (PDT)
MIME-Version: 1.0
References: <32532923.JtPX5UtSzP@fgdesktop> <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
 <106271350.sqX05tTuFB@fgdesktop> <CAOQ4uxgT_cmFPm_mnpQtjWqhd=3vOAiFLdw_z6Y_=FSxr+3nfg@mail.gmail.com>
 <20200707155159.GA48341@redhat.com> <CAOQ4uxhMq_8xwCU2t+WveTGgc9MAWE2RD66q5UjQ1r09EoLzHA@mail.gmail.com>
 <20200707215309.GB48341@redhat.com> <CAOQ4uxhd+kYzaDmndCV5rgiswfHnyLjZokmUa+BVk9t31C=HWg@mail.gmail.com>
 <CAJfpegv9h7ubuGy_6K4OCdZd3R7Z4HGmCDB2L7mO5bVoGd6MSA@mail.gmail.com>
 <CAOQ4uxgaVD_DjU5DM+rXzkqpgVLWN-R+kj5ef2SBvvvCDL3d6w@mail.gmail.com> <CAJfpegur+DfoGA4e+R2okSmso59Kx0ArnkpJ03o9qM1KH5rLdg@mail.gmail.com>
In-Reply-To: <CAJfpegur+DfoGA4e+R2okSmso59Kx0ArnkpJ03o9qM1KH5rLdg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 8 Jul 2020 11:50:29 +0300
Message-ID: <CAOQ4uxiq7hkaew4LoFZkf4R73iH_pU7OHOriycLCnnywtA0O0w@mail.gmail.com>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Fabian <godi.beat@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 8, 2020 at 11:37 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, Jul 8, 2020 at 10:31 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> >
> > 1) is not problematic IMO and the simple patch I posted may be applied
> > for fixing the reported issue, but it only solved the special case of null uuid.
> > The problem still exists with re-creating lower on xfs/ext4, e.g. by
> > rm -rf and unpacking image tar.
>
> How so?  st_ino may be reused but the fh is guaranteed to be unique.
>

Doh! You are right. I was talking nonsense.
The only problem would be with re-creating an xfs/ext4 lower image
with the same uuid maybe because a basic image is cloned.

In any case, it's a corner of a corner of a corner.
I will post the patch to fix null uuid.

Thanks,
Amir.

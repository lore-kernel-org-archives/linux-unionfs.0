Return-Path: <SRS0=2h5r=7E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D5AC433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 17:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92FB620738
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 17:19:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LLqQhTtZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgEVRTc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 May 2020 13:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730471AbgEVRTb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 May 2020 13:19:31 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D565C061A0E
        for <linux-unionfs@vger.kernel.org>; Fri, 22 May 2020 10:19:31 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id m6so11386396ilq.7
        for <linux-unionfs@vger.kernel.org>; Fri, 22 May 2020 10:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u3UsF0ifNi2/jJ7cu2jAuy5cLIUsdjENcXsD1q3qSrU=;
        b=LLqQhTtZCz6Cpb8VAKPCi7oAYmOM/Ty0sohAm5vnie2+sGOE6q3i0EQUIZSRnQq265
         GJ6ZWY7wYIasTPW3mjlWVph5O50tFfEfVsdo/hXvn2P4K17NF83oERBEXLaWeHPm52Wr
         JZzS2Jr9HeNzt2sqfSKwsiR2peglOv5G1TVMJuRiddTvQI/8RfDYRBdLw/oEYOXmGiqP
         2AFDEkcuG8tE+nLd0CwOszyf0dBsyZjg8O/Ijdm9OZmtWPaZU3UmkgL9TAYiRpvU3oDj
         LEFyVSWJwlRvRSVunkx18FNJtOVrNj85sl4hHno2HbI0s1yNKiZ0OMIuf6WOTqYUFakf
         nx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u3UsF0ifNi2/jJ7cu2jAuy5cLIUsdjENcXsD1q3qSrU=;
        b=SSOlmPOShB+kp8wX3Pb7b9aGrd1GYxyUh1A/50frEkgPFq8omcyaRow1Uy11mUnQFe
         VAt9n90TptZIrdgpSmrhbb3hOz/uppo8dzpxxUWGTZGgrstmajD+Aly77L3IMmZRyXk+
         A/o74/uchmoTkntM2E5WHnimD5P2to+uX8oxLoOX18FmQI3CmuwwA7pQmsLHtKJTGzwH
         wNBo1ici/lQxSl6KwgOCmGrry3Zmfxp2V99GqhdJGDgY7adgyOpAWTnltfjPKM9uZYAM
         qKX6rOMzg4q5hEmW2Bh+RiP1qnXJEk6EvqCM/rxLmPPuq5pFkeajEq1OmahIgC1oo70h
         n4pg==
X-Gm-Message-State: AOAM5309rtSZ1RX1X/Y9oLQIFx5bsyCYDcDB8fj58/6jSdscDCrMuPm8
        /SkJn9sZd4PYeY6Sa25Nu+fGajk0BlWP25qovrA=
X-Google-Smtp-Source: ABdhPJzqWFxoL2LA7M5RqfkRPXsZqBwtlAehemJSPoW5LzM/9IQXmUQreMdDSGBTO9U8DOyJ7/Glq7i8KA54xMHtNys=
X-Received: by 2002:a92:d208:: with SMTP id y8mr14419817ily.72.1590167970546;
 Fri, 22 May 2020 10:19:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200415153032.GC239514@redhat.com> <CAOQ4uxhmxxjGGB3bBoK1OmcAWDsoNi3WdORtH7WDLOcp8=sYSQ@mail.gmail.com>
 <20200415194243.GE239514@redhat.com> <CAOQ4uxjZ4Yd3ZWi+Fe64fVkrD=XMDjF1=C=XN_PNdywbGx_gzQ@mail.gmail.com>
 <20200416125807.GB276932@redhat.com> <CAOQ4uxi=mT2JYGSXro5YW8gTE5256cxauBddYe2HXM=ZfZ=+ZA@mail.gmail.com>
 <CAOQ4uxjvtGLn=SvLXy3KU6uKbonBUznL==OjdVVjjB6sM=-mgg@mail.gmail.com>
 <20200420191453.GA21057@redhat.com> <CAOQ4uxjVU6gcQMmyMiBsVV73gik931-7QjAO9TCu+N2ik6109w@mail.gmail.com>
 <CAOQ4uxgVnT3ZXZZa4-YktZaRDpU1hHujPoEtZ2vdFmsGxj=66A@mail.gmail.com> <20200522143606.GB58162@redhat.com>
In-Reply-To: <20200522143606.GB58162@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 22 May 2020 20:19:19 +0300
Message-ID: <CAOQ4uxj8Qhw-r8E+Fb-YYnMwmApkCPXD1136CA=oNo-81rzdVQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Configure custom layers via environment variables
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > Vivek,
> >
> > I finally got around to implementing your suggestion (see [1]).
> >
> > Quoting from README:
> >
> >      When user provides UNIONMOUNT_LOWERDIR:
> >
> >      1) Path should be an existing directory whose content will be deleted.
> >      2) Path is assumed to be on a different filesystem than base dir, so
> >         --samefs setup is not supported.
> >
> >      When user provides UNIONMOUNT_BASEDIR:
> >
> >      1) Path should be an existing directory whose content will be deleted.
> >      2) If UNIONMOUNT_MNTPOINT is not provided, the overlay mount point will
> >         be created under base dir.
> >      3) If UNIONMOUNT_LOWERDIR is not provided, the lower layer dir will be
> >         created under base dir.
> >      4) If UNIONMOUNT_LOWERDIR is not provided, the test setup defaults to
> >         --samefs (i.e. lower and upper are on the same base fs).  However,
> >         if --maxfs=<M> is specified, a tmpfs instance will be created for
> >         the lower layer dir.
>
> Hi Amir,
>
> Do you want to mention a word upper dir also when UNIONMOUNT_BASEDIR. That
> is upperdir is also created under UNIONMOUNT_BASEDIR. IOW, all directories
> lower, upper and mount point are under UNIONMOUNT_BASEDIR (until and
> unless overridden by other environment variables).

Sure. I will add:

2) Upper layer and middle layers will be created under base dir

>
> For point 4, I understand that we will mount multiple instances of
> tmpfs because maxfs tests on multiple different filessytems. I am
> assuming that we will be creating lowerdir mount points under
> UNIONMOUNT_BASEDIR for --maxfs.
>

Yap.

> I think this looks pretty good. Just one more thing. Is there a way to
> specify multiple lowerdirs as well. If not, may be in future we can
> add it once somebody needs to specify multiple lowerdirs.
>

You mean a way to specify different paths/fs to lower dirs?
It doesn't make much sense in the test.
The test rotates the upper layer 0 to be middle dir 0 and creates
upper dir 1. Most of the tests never rotate upper.

Currently, the most complex configuration you can run tests with
is rotating layers that end up with:
- Lowermost layer on user configurable lowerfs (*)
- Mid layers 0..M-1 on unique tmpfs instanced
- Layers M..N on same user configurable basefs.

(*) there is also the --squashfs option which formats the readonly
lowerfs with the test files.

Would you like a way to define a user configurable path
for upper dir 0? something else?

Which real life use case is this supposed to be simulating anyway?
for me this looks too much for no good reason.
If anyone comes forward with a reason and patches we can
consider that.

Thanks,
Amir.

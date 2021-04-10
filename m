Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91859C43460
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 19:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A75F610A3
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Apr 2021 19:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbhDJTp1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 10 Apr 2021 15:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbhDJTp1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Apr 2021 15:45:27 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE75C06138A
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 12:45:11 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id y20-20020a1c4b140000b029011f294095d3so6458251wma.3
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 12:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xAXQYgdsdI7+fnqH3sSzMK1SGp7LwPYf4nhrivKsV9w=;
        b=a94qVGANYOmr/dElgBI53AssaQoDz51yrIjsRbMpAEF9THWi1q0CgCuFH3TfvqeOkH
         WfHwcYgNmtOPvG5JlLuaJgFyvaFIwqDtJOfCq3PrymP6nIPoC8GH+V3NDiLzLMfBrsDH
         3nwPoGgRDSb9ZM859KkV5MTxuoo4oyYOH1gjEGYQoR+Wwrf8Zak1rOtvKn3dNjpuQVRW
         LcuIYf5wEyxinKow72WbvtJgpMyGJS8Aq4j7Tvgg9qt9TjCqdYpKjwb9JUTe+To/lvI4
         SBliJ9s7yT0R07UW8nhsTmc+k6mnn9XfTHRZ7OJjM70cQ6I9wwg1csHqYloYV8AZ1X2f
         zeBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xAXQYgdsdI7+fnqH3sSzMK1SGp7LwPYf4nhrivKsV9w=;
        b=VFSJQH3NRaOV9Xc2vCAWFlYsmQn89z0Xmj1nzjF23jTaXZfNcu9OwQQ7xKhIKn/wft
         T3h7bdacecZyHAY7wVXJg1dvIU5YqTDTTMVwvi91UZR9hBZloIZ+1cyA6MxvyY7y7knu
         X8M5YueF23g9C2quAcZ9s0SvwPZyh91JaI7BVGad2g/aOPV9Jt0Xhu1WIgQb+s6U8znw
         6BLpGAxaqPeylXVR2LrryGVbPkeiWtygD/zVBxdZwYiGcpOXLp8sqnsabkVFjT8/JN3P
         xC+mrfhvl5Fh4SoYnqSYTosZhQg/v/1dY8apniwr2Kn4J5qrejSzfmL20/wnohom+0oZ
         Xv0g==
X-Gm-Message-State: AOAM533Lo6f3vjbyhkTiT0WPgIwkX8rMQxwUyt00v7Rm1XKfU3PtxlJd
        CU4LE/gi3JM8qjlMsTESU9/uIEMN9OexSacpOk5uKwVyf/YPqg==
X-Google-Smtp-Source: ABdhPJxRY+olPcuAI5olEedeAuoF+seL6wzX1wzA0Cv/SueCgiYtq2ftstRlwD9NThTcTx18+UPkEjsB0w1AAGU+/sE=
X-Received: by 2002:a05:600c:3650:: with SMTP id y16mr19458134wmq.182.1618083910631;
 Sat, 10 Apr 2021 12:45:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtTp0aXBssEr4ZXGX=DS_+RyGghmoANCKDdxG59QWu8LVA@mail.gmail.com>
 <CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com>
 <CAJCQCtRGdBzyskifrYLbBGAAm0g7VeC6GeD7xBN-hRqE3GAWYA@mail.gmail.com>
 <CAOQ4uxhU2KX=jKKL5EZ102z_+6KyVKAOoAzSp2K8i0PMGJUg4A@mail.gmail.com>
 <CAJCQCtTHepsUHjCUAwawC6r6txAZ=XypE5rJOizqxMx9zuR4AA@mail.gmail.com>
 <CAJCQCtQshgFBvUF2+DLm0=iHhiONu-QCRnB1uNv2dLigT+WfZg@mail.gmail.com> <CAJCQCtTg5Cz_GdSTCX-rZDmoB-PDGr2iV=quPWSofbL-Xixapw@mail.gmail.com>
In-Reply-To: <CAJCQCtTg5Cz_GdSTCX-rZDmoB-PDGr2iV=quPWSofbL-Xixapw@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 10 Apr 2021 13:44:54 -0600
Message-ID: <CAJCQCtQDyOh-EWL2QMMgNQeY6KDpHqducVRpn_63O30KuX2diQ@mail.gmail.com>
Subject: Re: btrfs+overlayfs: upper fs does not support xattr, falling back to
 index=off and metacopy=off.
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Apr 10, 2021 at 1:43 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Sat, Apr 10, 2021 at 1:42 PM Chris Murphy <lists@colorremedies.com> wrote:
> >
> > On Sat, Apr 10, 2021 at 1:36 PM Chris Murphy <lists@colorremedies.com> wrote:
> > >
> > > $ sudo mount -o remount,userxattr /home
> > > mount: /home: mount point not mounted or bad option.
> > >
> > > [   92.573364] BTRFS error (device sda6): unrecognized mount option 'userxattr'
> > >
> >
> > [   63.320831] BTRFS error (device sda6): unrecognized mount option 'user_xattr'
> >
> > And if I try it with rootflags at boot, boot fails due to mount
> > failure due to unrecognized mount option.
>
> These are all with kernel 5.12-rc6


Ohhh to tmpfs. Hmmm. I have no idea how to do that with this test
suite. I'll ask bolt folks. I'm just good at bumping into walls,
obviously.

-- 
Chris Murphy

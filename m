Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C09C4361B
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Dec 2020 16:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56CB322525
	for <linux-unionfs@archiver.kernel.org>; Tue, 15 Dec 2020 16:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbgLOQcV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 15 Dec 2020 11:32:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730895AbgLOQcT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Dec 2020 11:32:19 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA65C0617A7
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Dec 2020 08:31:39 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id 81so21035371ioc.13
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Dec 2020 08:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pqcanqDeCUNvQ26osIGtvb1Td9H8neekpZItrVL/N/Q=;
        b=sSjKrFZdXCDC9rmZY0Tc9oQQVGP0cBSo9niIsxRgk/ZwW6RRg92TEJcUpAXdAQTRzR
         wN5KjqMt5RrsK1kXwqZWJcwV93DcZSp63Pns1SO+Ouk72PNTmBbEatORh9Cghxyf3+wH
         zzEWxjjV0+5QxpLIhDqmXwDbEPUl4gx+ChNihUUASIFcIjo+aqPGeu6wu64deJwmyAHT
         Q/x+NzY+0YSURl3USmYuMzS9+fuI5LwGq/9mxiQVkZg/1lqq4GdGDD8xYK5NuI4lG++n
         lAytVDHI8JM9cAZNVLR2t+eI5VmmXdbvyjpEVab+dwzoMVYcZU9C8mHPEklvwuGNCfv3
         lm0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pqcanqDeCUNvQ26osIGtvb1Td9H8neekpZItrVL/N/Q=;
        b=oAk/pJQb63L8LOh1CjD0P5BkRnAJd8twL5GTfQynhWWE6AXyE7Ihysyn6OyvkkWWoa
         VnqkeM2HdeQlM8kWvOy7HI4uDz+XQ5PWwIXJCEOHfqIwuvfgu7M1pux1TMj48LsToxbf
         lPMUpYTnd4akkBsNtvr739v+43NMY91cIsm2bmWPdOWzawy4Y0evJzzA5oUVHrpWWC3H
         8CiPDxK7uv39Y+dTZ/MNE7c3ijQDRL7CJuQschUODDaqy4povpSvp5MgBUKdgl/U9jul
         EraBBaA+T6vFLxW+ksXcaZ8kvSqv3DY+sNDWQJjbkVHCausvh+ZcZ7wX2Hhnie7kYQtu
         JXXA==
X-Gm-Message-State: AOAM531EoMZ/dcfUouEltGbYJspRElSjA1qDO9NaRkCEeDnmoeIzBLk/
        ROwzSt3RQ15IhEslh7jJQ8aJf4UR9B8DFzKnIHA=
X-Google-Smtp-Source: ABdhPJw0TYOd1mNYxJ7nwxB1L2PqSGLYL/bEtA2kZznR0hYd5TH4lHM2KP2DGZOrUlSgaHRWEUfrO/ATljfxiJ2u6v8=
X-Received: by 2002:a5e:de08:: with SMTP id e8mr38722874iok.203.1608049898445;
 Tue, 15 Dec 2020 08:31:38 -0800 (PST)
MIME-Version: 1.0
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org> <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
In-Reply-To: <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 15 Dec 2020 18:31:26 +0200
Message-ID: <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com>
Subject: Re: failed open: No data available
To:     Michael D Labriola <michael.d.labriola@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Dec 15, 2020 at 5:33 PM Michael D Labriola
<michael.d.labriola@gmail.com> wrote:
>
> On Mon, Dec 14, 2020 at 6:06 PM Michael D Labriola <michael.d.labriola@gmail.com> wrote:
> >
> > I'm sporatically getting "no data available" as a reason to fail to
> > open files on an overlay mount.  Most obvious is during ln of backup
> > file during apt install.  Only seems to happen on copy_up from lower

How do you know that? Do you have some more tracing info?

> > layer.  Lower layer is squashfs (I've seen it happen with both the
> > default zlib and also zstd compression), upper is EXT4.
> >
> > I've only bumped into this problem recently with 5.9+ kernels.  I'm
> > gonna go see if I can reproduce in some older kernels I still have
> > installed.
>
> Rebooting into 5.4 made the problem go away and I can apt upgrade
> w/out any problems.  Rebooting an affected virtual machine into 5.8
> also fixed the problem, so it looks to be something introduced in 5.9.

There are no overlayfs changes v5.8..v5.9 nor squashfs changes.
Are you sure that your reproducer is reliable enough for the bisection?
If it is, please try to bisect the offending commit because I have no idea
where it may be.

>
> I suppose I should try 5.10 and see if this problem has already been
> fixed.
>

Wouldn't hurt.

Thanks,
Amir.

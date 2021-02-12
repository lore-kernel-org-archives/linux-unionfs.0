Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 115FFC433E6
	for <linux-unionfs@archiver.kernel.org>; Fri, 12 Feb 2021 17:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C62CC64E05
	for <linux-unionfs@archiver.kernel.org>; Fri, 12 Feb 2021 17:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhBLRGT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 12:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhBLRGJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Feb 2021 12:06:09 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A82C061756
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Feb 2021 09:05:29 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c6so619885ede.0
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Feb 2021 09:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vbgM6CUiFIt8xHPoCBnl6+eAwU0NUnOlNbcRgFEu8xc=;
        b=JrCauXpnKMsVbbP2SNACy4ovxDo2CCK7zmANn2f9FjVfAsxcWFKSbqiLMoyH8Drf8S
         gjzfpFVv4zDMbDHWzZYmjUj8quyoQ7BBFD/KAfK0+3EwjGIePrKsdpCNWQEK6lIUt59J
         lGl/TAMWUpeSRBAFgyh1uqqdAlfe1oNRv0PyGhWXZhyVYFqqajur7S8PbyH+9g5WCg4f
         X+ZrgaHzfZYmhRPvtizsaCbqz7OPZZWFALdL3EEnRtCGGuE/f0GFL14gDkftoAByGZq8
         96lW4Ogk2Hmuz20P3ov+50bu0xXWSvIXGw01XyOqHSgW+VM2fFnhUepd/BGvJJDDOnEv
         16Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vbgM6CUiFIt8xHPoCBnl6+eAwU0NUnOlNbcRgFEu8xc=;
        b=OMpynrQuXeZbs1kXBA74DCGdaxUzaPyPZ/sgjVqGT9bkPj2gnl+Y82eNUrfbta602f
         k+v8Vuh1Xynlwt56s3MeVvhnvxK2jcvImpGEcPkWdwEabLTZzH0zfzvF0PeMBmjL5XFt
         c7Jk7aatz1arbSZTDI3HVQQOmQ73ZnHftVp9rsAkWTb2azoii5I9B3K4mAis6P1I9gVE
         yl4XaU5LmSnCaZtdBAtZcLvj3VeXUDD9akhNCRGLvqKaCU2MR5hTvKjxAH61zTODhFlV
         yuydtgoDWxOok/r5dd48+UU77RE4e/2LFPhjXpKRzOOhjYl6pLinWLLoz/dGe4tEozO1
         Qhbw==
X-Gm-Message-State: AOAM530+X9xWbI6fYUOYc82CPKwSlKBI/3cQLhQA5WbmedAap+Y06SNu
        ouTpNXbttQISO2ABxibZAATcF7IDrSzOd5oxcRPL
X-Google-Smtp-Source: ABdhPJwWuFvSzfYALJEjiPAOVSinopmOKWKmCbUkR8pZEpVcRLiOYmWV0CTUXKvtRxNJtXfHLHoaFMKBMljCQDrro7o=
X-Received: by 2002:a05:6402:4389:: with SMTP id o9mr4366487edc.164.1613149527641;
 Fri, 12 Feb 2021 09:05:27 -0800 (PST)
MIME-Version: 1.0
References: <20210211180303.GE5014@redhat.com> <CAHC9VhRM6MiF1m2aFpLJKb3CFWXcXEX_SY=EnkLaq7U_X2UTZw@mail.gmail.com>
 <bb7b8304-b0fe-f6a3-b1fa-c06193f9cc02@redhat.com> <CAHC9VhS_+VT5cSXg+msEajnMYNjegKfubLO0EggaSr2p+JfSuA@mail.gmail.com>
 <36bcaeb0-547b-c8aa-e552-cca05c4103b5@redhat.com>
In-Reply-To: <36bcaeb0-547b-c8aa-e552-cca05c4103b5@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 12 Feb 2021 12:05:16 -0500
Message-ID: <CAHC9VhQ+ki_OJrUsA3dF4NOqJQ7SiccMOGrHzHmGwSTiJmQCvg@mail.gmail.com>
Subject: Re: [PATCH][v2] selinux: Allow context mounts for unpriviliged overlayfs
To:     Dan Walsh <dwalsh@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, selinux@vger.kernel.org,
        linux-unionfs@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Feb 12, 2021 at 6:58 AM Daniel Walsh <dwalsh@redhat.com> wrote:
> On 2/11/21 18:28, Paul Moore wrote:
> > It will get merged into selinux/next *after* this upcoming merge
> > window.  I'm sorry, but -rc7 is just too late for new functionality;
> > kernel changes need to soak before hitting Linus' tree and with the
> > merge window opening in about three days that simply isn't enough
> > time.  Come on Dan, even you have to know that ...
>
> Well if that is ASAP, then fine, next window. Sadly this delays us three
> months from getting this feature out and tested, but we can live with this.

It's consistent with the policy I've been following for years at this
point, regular SELinux (and audit) kernel contributors as well as
people who follow the related lists should be well aware of this by
now.  If you look at the SELinux kernel tree you'll find this
documented in the README.md file in the top level directory; here is
the relevant excerpt:

"Patches will be merged into the subsystem's next branch during the
development cycle which extends from merge window close up until the
merge window reopens. However, it is important to note that large,
complicated, or invasive patches sent late in the development cycle
may be deferred until the next cycle. As a general rule, only small
patches or critical fixes will be merged after -rc5/-rc6."

https://github.com/SELinuxProject/selinux-kernel
https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinux.git/tree/README.md

> Once it gets into a Release candidate we can push people to Rawhide to begin testing it.

As a reminder, once a patch hits the selinux/next branch it should
show up in my kernel-secnext builds within about an hour (+/- 30m
depending on the time and day).  Currently packages are only built for
Fedora Rawhide (source, x86_64, aarch64), but I still have aspirations
for providing Debian sid packages someday.

https://paul-moore.com/blog/d/2019/04/kernel_secnext_repo.html

-- 
paul moore
www.paul-moore.com

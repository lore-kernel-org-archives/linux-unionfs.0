Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A767C12002
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jul 2021 14:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78110611C1
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jul 2021 14:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbhGUNwq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jul 2021 09:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbhGUNwq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jul 2021 09:52:46 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CDCC061575
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jul 2021 07:33:22 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id 109so901096uar.10
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jul 2021 07:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IkWVkcythYa2A57t2JVt5VieMkJkdZkYOtgupvcATwk=;
        b=Dqewk0hiZoshy6laIiTp03eA4F0+shLl6tOWMXzkRPNcthNxlHH4i8o74ARNEUNZ+7
         3NDyEkJpRQxRpGH8vBJecvZ8e6Gsa50rPIrqycjlO2MqM6KLdgj6QyzWB108OZPRx5iM
         esukN23J4Fv7cY0BJwXO1FzTbwDCO2JXP05kw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IkWVkcythYa2A57t2JVt5VieMkJkdZkYOtgupvcATwk=;
        b=gkHilm7pzFwMuFq2uemcxoeegpP9KF+HA4yU4K69ZmzOr0PyLWCJ8mDMUorO8Hk99J
         SiASSqiwQOdyrDGaM7LiMUsb+2dr3IvF7CUWefL7Q+D6wYQlfx/5LH3ehyCJwtLHkmKS
         CzKUrDNqZfyDAn3jMQt1ykI31x40BkiFPvZG5G70RCUWKwihitujAGRAt1ACd2rd7OkP
         imPn5+V1NWSP0JE4JlBQBOnqUkUiTVdqfpu/sDTiNN7v93HoBLl03H8XxqMl5taZcNr2
         4hZUoTkveS9bmKAPfxs6XXTr0SNtvZcUQkRmDejq6O78YpIRqglOhNqoX5PDPVXXhHAz
         RXzQ==
X-Gm-Message-State: AOAM530LZknvvjb9+r68xTpdQZmMDph86y8n3rVmvu1AzzOBT2soOqW0
        fkc1kjpfnVC6LKAMoMXOJz5/1XohUMBobrjID1JzXg==
X-Google-Smtp-Source: ABdhPJxvsnfxq7998T7Cov7TuiW9Dv8b8yF4wKbuBa4r1NvYHLqqEOKM845UsQJI145astg2Cn3sUeH3B3xHbQgXZ10=
X-Received: by 2002:ab0:5e92:: with SMTP id y18mr7592626uag.9.1626878001654;
 Wed, 21 Jul 2021 07:33:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210427102826.1189410-1-amir73il@gmail.com> <CAJfpegsxTjjBo08FfbuGqPPqrR71=c8SE97BiNyFnk-0D0Dgug@mail.gmail.com>
 <CAOQ4uxhWrnNC0DQzXbgwFQa2n0Jj5dQxV1hS3r88_0B-s6UeiQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxhWrnNC0DQzXbgwFQa2n0Jj5dQxV1hS3r88_0B-s6UeiQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 21 Jul 2021 16:33:10 +0200
Message-ID: <CAJfpegvmNsWrgKc-=oO2zz2MQyLgk=orCzh0UMa9rY7s1U_iYQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: relax lookup error on mismatch origin ftype
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Byron <ouyangxuan10@163.com>, Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 21 Jul 2021 at 16:17, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Jul 21, 2021 at 4:10 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Tue, 27 Apr 2021 at 12:28, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > We get occasional reports of lookup errors due to mismatched
> > > origin ftype from users that re-format a lower squashfs image.
> > >
> > > Commit 13c6ad0f45fd ("ovl: document lower modification caveats")
> > > tries to discourage the practice of re-formating lower layers and
> > > describes the expected behavior as undefined.
> > >
> > > Commit b0e0f69731cd ("ovl: restrict lower null uuid for "xino=auto"")
> > > limits the configurations in which origin file handles are followed.
> > >
> > > In addition to these measures, change the behavior in case of detecting
> > > a mismatch origin ftype in lookup to issue a warning, not follow origin,
> > > but not fail the lookup operation either.
> > >
> > > That should make overall more users happy without any big consequences.
> > >
> > > Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxgPq9E9xxwU2CDyHy-_yCZZeymg+3n+-6AqkGGE1YtwvQ@mail.gmail.com/
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Miklos,
> > >
> > > I am getting tired of dealing with lower squashfs related reports.
> > > How about this?
> > >
> > > It passes the xfstests quick tests and no, I do not have a reproducer
> > > for origin mismatch, so will wait for Byron to test the patch.
> >
> > Pushed a simplified variant that just changes the
> > ovl_check_origin_fh() return value from -EIO to -ESTALE.   Do you see
> > a problem with this?
> >
>
> The only difference is if ovl_fh_to_dentry() also emits a warning,
> but since ovl_check_origin_fh() already has a warning I think that
> your simplified version is fine.

Yeah, you are right, new version could have one less warning in the
->fh_to_dentry() case, but I agree that that should not be a problem.

Thanks,
Miklos

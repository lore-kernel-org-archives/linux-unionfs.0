Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BC8C433DB
	for <linux-unionfs@archiver.kernel.org>; Wed, 24 Mar 2021 16:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9794C61A13
	for <linux-unionfs@archiver.kernel.org>; Wed, 24 Mar 2021 16:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhCXQM6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhCXQMz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Mar 2021 12:12:55 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3A4C061763
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Mar 2021 09:12:53 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id l22so11627252vsr.13
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Mar 2021 09:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i1aqrOBqQdftCwIOTcEzH4XHyHId1YuWwZA7VcY1Uhk=;
        b=fuTCMmKG11Y9w7r2to23Mefn7avFRqwK17IxAEFlu1rfOuy7sKRHjDO6lTkuhTGaJS
         H0jjwUnae/LAcNXgOrzvwSdRTQMJ4HNXX93WbOA+yUOnSVaPc9FMC58un5bPuDPfYhNn
         zVN6Yk2BEg+zGvm819sSR64pWuWfB0O1RWXnc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i1aqrOBqQdftCwIOTcEzH4XHyHId1YuWwZA7VcY1Uhk=;
        b=j21aRZ6agF/Qar1V1XsltZU/28iqANusc1bMIOXYayu1USl0Y4i2Su++lfnqw5Sl2Z
         wpdJk94zUJC/kmU3AXWa53qmKUuipsLTmZSR5/6cUZywoviStRYIP1pxDSe8OYgHm2tF
         wwSb+zHEMwQUOjfvXOudm2znok66UEXC+31J0ihr2ZKrnD99lmF1qDI4+CY3dh4BQ08o
         2nQGmRiKMnTRE4xxtYWPlnODk0nk/oRl0qRl4bGd0qdr9JnFDz/qDwFWGz4dAWl3GNdk
         +jGeHBSmMr+AvcIXnlbTciApnYiB6wB7QB8lm0B9/zEI0I0Xr5W8Q7aVjTzBFfsviWtq
         MgFQ==
X-Gm-Message-State: AOAM532Jwzn0Ha+VOeXBi01qnf5deAAWHgskeRIfcyWo2e69iokl+yAw
        6ck+wP3p2meSShUQmCOFhQmAeuV7M35+HSb3oxNBFg==
X-Google-Smtp-Source: ABdhPJxNL+KlUlMVin6wb0kpRRBsWBot5z2ZI5p9oTvVZnebt/VTIka2OZH8JyD0svn2xV44QsGVDDPsRivdsCAPZzY=
X-Received: by 2002:a67:8793:: with SMTP id j141mr2499459vsd.7.1616602372838;
 Wed, 24 Mar 2021 09:12:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210301061930.3459022-1-cgxu519@mykernel.net> <CAOQ4uxhijbRwH8BxzZ6CMqZiJB_cK6k_QWFB-sg4zH=H-n3+0w@mail.gmail.com>
In-Reply-To: <CAOQ4uxhijbRwH8BxzZ6CMqZiJB_cK6k_QWFB-sg4zH=H-n3+0w@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 24 Mar 2021 17:12:41 +0100
Message-ID: <CAJfpegsWoWA6BUaJGDEiysCcQKemA6FWurdxy_enXsSNvX=YiQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix error for ovl_fill_super()
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 1, 2021 at 8:57 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Mar 1, 2021 at 8:28 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
> >
> > There are some places should return -EINVAL instead of
> > -ENOMEM in ovl_fill_super(), so just fix it.
> >
> > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> > ---
> >  fs/overlayfs/super.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index fdd72f1a9c5e..3dda1d530a43 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -1984,6 +1984,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >         if (numlower > OVL_MAX_STACK) {
> >                 pr_err("too many lower directories, limit is %d\n",
> >                        OVL_MAX_STACK);
> > +               err = -EINVAL;
> >                 goto out_err;
> >         }
> >
> > @@ -2010,6 +2011,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >         /* alloc/destroy_inode needed for setting up traps in inode cache */
> >         sb->s_op = &ovl_super_operations;
> >
> > +       err = -EINVAL;
> >         if (ofs->config.upperdir) {
> >                 struct super_block *upper_sb;
> >
>
> OK. But we are not really being consistent in the ways we set err in this
> function, which means we will have more of these bugs in the future
> (and we have had them in the past as well...)
>
> So either set err = -EINVAL after every pr_err() in this function:
> - "missing lowerdir"
> - "too many lower dirs"
> - "missing workdir"
>
> Or always set err before the tests including err = -ENOMEM
> before allocating layers.
>
> Mixing seems worse than either choice IMO.
>
> Maybe Miklos has a better idea for tyding this up?

Thanks, applied with consistency fixup.

Miklos

Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABFEC636C8
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 15:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3934061029
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 15:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239787AbhGTPFK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 11:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241067AbhGTOj4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jul 2021 10:39:56 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7675AC0613B4
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jul 2021 08:19:28 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id bb26so4631039vkb.10
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jul 2021 08:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/bPNLgv3ptNZrl13hhcRVp4LgY43sXOXn9IaEJioYf8=;
        b=b2rcA/MYrCsJvFVsWG01S2WnFc//qTTY9mg0SCCjSLFyVOvTQP+1JCFhlm/EUQOPAt
         CS2dMqmaSqv6mUIngTfZR1V8zbIOn+8IalPddIAL+IJj+az14PXGAEDAm6ImnXvDGRya
         18YNTfrobSyVnIdOlOByrOgsaTLIa8uA0LE30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/bPNLgv3ptNZrl13hhcRVp4LgY43sXOXn9IaEJioYf8=;
        b=DiFjAmJu1egacwUvpYcuYuW7ufsAR/wGpCQkrHrX67AOSIwHg5DyG26lIxat69FJ5d
         aEkAgzuNsuJCxluFmDev0/Tn8qE0Sa7dNgwiDIqmc1Sb9R/3tEmuZ0rKfdBNdpY8zrqT
         9GHnv6Jlt7AHhhWp8GHzU06+zcxwYGurvMjFEWrbkHKpcLvk57PWiboHkO5COmSQHCoK
         uNgm311waFpxwoOoVRBaKKCVay519ICY2wgEPOojgNzjOSSFDULs3G0WzZfpuWkF2+5/
         qxPZOoUMozLzFphHquBogyAqYt/XKmHkawNIaiVizdpI4aU3gdB0f+kELs00Wdlu4ZIC
         ARJA==
X-Gm-Message-State: AOAM533U3e/IO/wR6P4e+qYx6E0yLZkIc9v6LfXr4JtxMjHUgEzAIw+M
        n7Ey+hewR/Vclt0HSPgC7bRFUBNo7FWERcw2F6tnIcasj75RvBI1
X-Google-Smtp-Source: ABdhPJxnhv9vzZQsiwe4yG3N8lyunDT6kfppBBpHjpXPp2EN4hEsmcB+0oJVtv1vOthGWPw7WiknMNdp3aTnRXcSXSM=
X-Received: by 2002:a1f:a8d2:: with SMTP id r201mr26677845vke.11.1626794367564;
 Tue, 20 Jul 2021 08:19:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210424140316.485444-1-cgxu519@mykernel.net> <CAJfpegsT3PaVggkcx+OdoxOCR2hWYeLs1rTr_p3nNMimnknCug@mail.gmail.com>
In-Reply-To: <CAJfpegsT3PaVggkcx+OdoxOCR2hWYeLs1rTr_p3nNMimnknCug@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 20 Jul 2021 17:19:16 +0200
Message-ID: <CAJfpegvmBggw3bgumMwDF_V_dgn=gvC+a+8oCgYfZ+Qu55U=vw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] ovl: skip checking lower file's write permisson
 on truncate
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 20 Jul 2021 at 16:35, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sat, 24 Apr 2021 at 16:04, Chengguang Xu <cgxu519@mykernel.net> wrote:
> >
> > Lower files may be shared in overlayfs so strictly checking write
> > perssmion on lower file will cause interferes between different
> > overlayfs instances.
>
> How so?
>
> i_writecount on lower inode is not modified by overlayfs (at least not
> in this codepath).  Which means that there should be no interference
> between overlayfs instances sharing a lower directory tree.

I'm beginning to see what you are worrying about.

So on one instance a file on lower gets executed and on another
instance sharing the lower layer the file is truncated.  The truncate
is currently denied due to the negative i_writecount on the lower
file.  Also behavior is inconsistent between open(path, O_TRUNC) and
truncate(path) even though the two should be equivalent.

Applied with the following description:

It is possible that a directory tree is shared between multiple overlay
instances as a lower layer.  In this case when one instance executes a file
residing on the lower layer, the other instance denies a truncate(2) call
on this file.

This only happens for truncate(2) and not for open(2) with the O_TRUNC
flag.

Fix this interference and inconsistency by removing the preliminary
i_writecount check before copy-up.

This means that unlike on normal filesystems truncate(argv[0]) will now
succeed.  If this ever causes a regression in a real world use case this
needs to be revisited.

One way to fix this properly would be to keep a correct i_writecount in the
overlay inode, but that is difficult due to memory mapping code only
dealing with the real file/inode.

Thanks,
Miklos

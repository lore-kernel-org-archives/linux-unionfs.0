Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C9FC433B4
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Apr 2021 07:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5F5461001
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Apr 2021 07:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhDKH3S (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 11 Apr 2021 03:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhDKH3S (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Apr 2021 03:29:18 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93631C061574
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Apr 2021 00:29:02 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id v26so10175197iox.11
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Apr 2021 00:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3TUOF8YskU7rDQUrNF+GTNqWMtnO/oRawZlC5+r6gl0=;
        b=tg5NaG993H5of47L+pVplizZIwOb5nMRxPHvsQ6vn0QEPUnp1BwWliP+lwIGg5n968
         hAAbGhgSr0UPm7DrjRqh/YYhvOpTR6a8VBz2SWNwfaScxpuBwO1vz3K/l5gaQMgjrRJF
         aK1syvGoND0UlMRBsf94ALHAJ1y5cLh0k5idVEDT3CkiVI1Euj1Rl8PLpMvxO1JZF++x
         X9HrFbKG1tvuzQEfluMJRHg8d44X7y0XqTuyMzvlj2Ldd/6UsR1pxKG+aKCRC1hcDFEm
         QDklTDxk4bekPS9hV36toFSLNMm2P3ubHvYMu7Y63pUrnUvagHT4vOVjggtt1MoiWL9V
         f+/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3TUOF8YskU7rDQUrNF+GTNqWMtnO/oRawZlC5+r6gl0=;
        b=I6zAjHfh3QB+1fRV+yywiaiFPBkLMJZEclroIQg+VhdRh+mIavc/PVm+BldB7FTs7F
         +hfcKuyX8BnFh9BuHmX1l4i8PtT3hP2oxlz9x6orqEvexvUHCSXHJp69fLsurZSzIeDO
         YTl3xpN6wjlChhC2K6S+7IJyCEpAN9H3kwkrYpPgjOslFtRTp5ZdZpOOLWfqARjfGggf
         NXCmfDZpP049AX0Mi6x0r7p6SPRlDxuFZ+7zK/q0qhJsmkCbZq20GyPCq5yzEx8IFFQV
         bMtiSK7FVIYwVUWqFFEFIjU0NLxFIIXJvy/81w69PSoPb7rBGRdrnvZTTVzHNJC/5UrE
         spKw==
X-Gm-Message-State: AOAM531pOyhWBsWPSnERmobzPh/naMx5E9FkG5cgc+VKP1tG0KJ/cwKh
        OxG3HODAGa5qXB5604zwj5HI28/tBakMo9llcCtu9FejD80=
X-Google-Smtp-Source: ABdhPJwldJV3y9UhaqOuqqJ8vyDxp9xhUiLUyB/d+ErxYGezQ7Ikv6l4rDlg3buQWEvATaNLdY7ADWoOqZHp4nccRsA=
X-Received: by 2002:a6b:7a42:: with SMTP id k2mr4282279iop.64.1618126141506;
 Sun, 11 Apr 2021 00:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtTp0aXBssEr4ZXGX=DS_+RyGghmoANCKDdxG59QWu8LVA@mail.gmail.com>
 <CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com>
 <CAJCQCtRGdBzyskifrYLbBGAAm0g7VeC6GeD7xBN-hRqE3GAWYA@mail.gmail.com>
 <CAOQ4uxhU2KX=jKKL5EZ102z_+6KyVKAOoAzSp2K8i0PMGJUg4A@mail.gmail.com>
 <CAJCQCtTHepsUHjCUAwawC6r6txAZ=XypE5rJOizqxMx9zuR4AA@mail.gmail.com>
 <CAJCQCtQshgFBvUF2+DLm0=iHhiONu-QCRnB1uNv2dLigT+WfZg@mail.gmail.com>
 <CAJCQCtTg5Cz_GdSTCX-rZDmoB-PDGr2iV=quPWSofbL-Xixapw@mail.gmail.com>
 <CAJCQCtQDyOh-EWL2QMMgNQeY6KDpHqducVRpn_63O30KuX2diQ@mail.gmail.com>
 <CAJCQCtSC36c5yNo+H2sy0o1f+XerjDSj-KYxPZS4GX6v5czUgw@mail.gmail.com>
 <CAOQ4uxjYQV6gUa3rmsoECSjrZSAJ+ENWDcs0pYrLfocM1B+gVg@mail.gmail.com> <CAJCQCtSzENaFsZ_mcDv8OANDmpbUWoo+u1RVgfZ=hpxK5hQ7bg@mail.gmail.com>
In-Reply-To: <CAJCQCtSzENaFsZ_mcDv8OANDmpbUWoo+u1RVgfZ=hpxK5hQ7bg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 11 Apr 2021 10:28:50 +0300
Message-ID: <CAOQ4uxib1YhfP3Pk5s_T7yWXg5iFtLHNMtaVAsBJVJuWdiiwcw@mail.gmail.com>
Subject: Re: btrfs+overlayfs: upper fs does not support xattr, falling back to
 index=off and metacopy=off.
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Apr 11, 2021 at 9:05 AM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Sat, Apr 10, 2021 at 11:12 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > Now I'm confused again.
>
> So am I, and in retrospect I've posted here prematurely.
>
> >
> > Your reports starts by stating:
> > "The primary problem is Bolt (Thunderbolt 3) tests that are
> > experiencing a regression when run in a container using overlayfs,"
> >
> > But you say that the problem exists with kernel 5.9.
> > When you say "regression" above, what are you referring to?
>
> Overlayfs. Now that I've tested 5.9, I'm not so sure it's a kernel regression.
>
> >
> > Did those tests pass in a previous Bolt version?
> > Did those tests ever pass in a container using overlayfs?
>
> Yes and yes.
>
> > There is surely a bug in overlayfs, but it's hard to find it without
> > minimal bisection info. I'll keep looking.
> >
> > If it's a regression with newer distro, please try to understand
> > from distro/package managers, what has changed in the container
> > setup and kernel config w.r.t a container using overlayfs.
>
> Exactly. The original report of the problem is Alpine linux, but I
> can't reproduce it on Fedora except with podman using an Alpine image
> base. As all the other suspects have fallen apart, what remains
> untested for regressions is this.
>

I'm lost in the maze of distros and containers.
Will wait for more info.
In any case, I was able to reproduce the bug in ovl_dir_version_inc()
I will post a fix soon.

But I don't see how the test case you reported can be affected.
The bug I reproduced requires an upper directory that used to be
a merge dir and whose lower dir was removed while overlayfs was
offline.

Thanks,
Amir.

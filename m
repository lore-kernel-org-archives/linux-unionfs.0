Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE619C433ED
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Apr 2021 06:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 736B460C3E
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Apr 2021 06:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhDKGFy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 11 Apr 2021 02:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhDKGFy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Apr 2021 02:05:54 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527D3C06138B
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 23:05:38 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id p19so4967792wmq.1
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Apr 2021 23:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SYoc3DFI/V5QD2HUr5x/hBgrbEl/xjHKDeDJfKURT0U=;
        b=tSjN3+cG3NzDSjg/cxbis6b3RWqj41XP2QxsnhVaSTCSQQAJxtTOwg9XZa65fmiDbg
         DOk7LcRdlzROaSqAw4kvFYmVsdjOH5FlxnEPIw0agVFCGTUmG+KbJXiJU1fNT6sT60So
         eHfPXNahtgcy3yKFj7mN5TxOFy8wfm+iJVwXfXOdXjCZV6Yy8TzdnLOHKZbVi7gZ6lda
         46uF3KiAcsrHlBkJJbyG6oL7XMHJ4PZUWa6JQUqQK3+qGaU0hJwgdHVwGfL93TsALaVP
         UWGhLjco6mqUsMa15F0WHQ6MR77QvRx8rcD6S6l1UzMi4pwCEgFQ+/M357PNENCOoxTG
         l0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SYoc3DFI/V5QD2HUr5x/hBgrbEl/xjHKDeDJfKURT0U=;
        b=DykAZyh11WQE+mfSFwALVBGiXJ7YrkiYJEZSgDdVuiuYh6dQ22Dr4LkpflCNpKy1If
         HPmjp6WTcTDXdoFK1+NHbFXHdCsaRE0LEOPx5alfIpdhXH9LwFj3ktdmQt52LXrzj/XY
         zZWbDHnwS/MSTqu5CPh9dXLXEud2dyAOY7Lj9gDmmJBDsmvrq7rwEGpk1ttoaTp6Wwde
         e+B4QwywN5Vb3ulezi5ZBMu6UciVUHgoCnB3UuxmPMDF1OVGtwmkP4eicBk5RRLCFUYb
         AsvIIjJ0BQfhyP1ZT8XKBFq8/7TWeyGpcUU7Z/Mtvy1Wi8GRY/PCZSu8BAE1NAJ1eyge
         makg==
X-Gm-Message-State: AOAM530dMroP8xeoLnL1JKt6A5MJWfB6DQpxH1Rnlc1c4pDXeqlyvEpN
        1DKeiTXd2p3gAnMLQeGZrz07a6laOUY5sqSfnVmGiA==
X-Google-Smtp-Source: ABdhPJyZweICjBIL9fC/ofxvD7Tn9qprAecZ7A6gIeekT7RRh/rpGqVK/83dks4GjZ3dEhZ+8LCZKIaPOJvfQRhZbgI=
X-Received: by 2002:a7b:c1cf:: with SMTP id a15mr13599486wmj.168.1618121136980;
 Sat, 10 Apr 2021 23:05:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtTp0aXBssEr4ZXGX=DS_+RyGghmoANCKDdxG59QWu8LVA@mail.gmail.com>
 <CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com>
 <CAJCQCtRGdBzyskifrYLbBGAAm0g7VeC6GeD7xBN-hRqE3GAWYA@mail.gmail.com>
 <CAOQ4uxhU2KX=jKKL5EZ102z_+6KyVKAOoAzSp2K8i0PMGJUg4A@mail.gmail.com>
 <CAJCQCtTHepsUHjCUAwawC6r6txAZ=XypE5rJOizqxMx9zuR4AA@mail.gmail.com>
 <CAJCQCtQshgFBvUF2+DLm0=iHhiONu-QCRnB1uNv2dLigT+WfZg@mail.gmail.com>
 <CAJCQCtTg5Cz_GdSTCX-rZDmoB-PDGr2iV=quPWSofbL-Xixapw@mail.gmail.com>
 <CAJCQCtQDyOh-EWL2QMMgNQeY6KDpHqducVRpn_63O30KuX2diQ@mail.gmail.com>
 <CAJCQCtSC36c5yNo+H2sy0o1f+XerjDSj-KYxPZS4GX6v5czUgw@mail.gmail.com> <CAOQ4uxjYQV6gUa3rmsoECSjrZSAJ+ENWDcs0pYrLfocM1B+gVg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjYQV6gUa3rmsoECSjrZSAJ+ENWDcs0pYrLfocM1B+gVg@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 11 Apr 2021 00:05:20 -0600
Message-ID: <CAJCQCtSzENaFsZ_mcDv8OANDmpbUWoo+u1RVgfZ=hpxK5hQ7bg@mail.gmail.com>
Subject: Re: btrfs+overlayfs: upper fs does not support xattr, falling back to
 index=off and metacopy=off.
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Apr 10, 2021 at 11:12 PM Amir Goldstein <amir73il@gmail.com> wrote:

> Now I'm confused again.

So am I, and in retrospect I've posted here prematurely.

>
> Your reports starts by stating:
> "The primary problem is Bolt (Thunderbolt 3) tests that are
> experiencing a regression when run in a container using overlayfs,"
>
> But you say that the problem exists with kernel 5.9.
> When you say "regression" above, what are you referring to?

Overlayfs. Now that I've tested 5.9, I'm not so sure it's a kernel regression.

>
> Did those tests pass in a previous Bolt version?
> Did those tests ever pass in a container using overlayfs?

Yes and yes.

> There is surely a bug in overlayfs, but it's hard to find it without
> minimal bisection info. I'll keep looking.
>
> If it's a regression with newer distro, please try to understand
> from distro/package managers, what has changed in the container
> setup and kernel config w.r.t a container using overlayfs.

Exactly. The original report of the problem is Alpine linux, but I
can't reproduce it on Fedora except with podman using an Alpine image
base. As all the other suspects have fallen apart, what remains
untested for regressions is this.


-- 
Chris Murphy

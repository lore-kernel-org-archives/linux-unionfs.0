Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5459CC43461
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 08:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EDF66145D
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Apr 2021 08:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbhDVIsH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 04:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbhDVIsG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Apr 2021 04:48:06 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EA4C06138B;
        Thu, 22 Apr 2021 01:47:31 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e14so13441446ils.12;
        Thu, 22 Apr 2021 01:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Icf9wzL9a21uX9Qttqnfe0T9al7xHnqPl+5L89eyGjo=;
        b=It/OR5AyuANW1xqOHr1RobjunjbfKQK5ZvMI3ZmT84gGtP9dmFYT/PA5IjkQHpARD8
         JI2bJENpZ1APDi/Y1zVavl9RdhhAmECrUQEz/zjVGAZIcy3T+eyOEm5aExoih7hSKbIl
         EJKXPpCw3A3Tj1PTcoohbuCFewe2AFakokctyGdztRsQ6SRrWtMRWtI9IhQXQhoZiYtB
         3zJKcNqaXG5VAp3QtI/9gjMHEdM5YgCtZUhj5Vnk4M1uoxors7oSRyxAKe3MOdAyYZcU
         TPPf4xSbxWMMCHhHDfqTaQ+XkW1QfJhuQq8Qc1SR35pqMNHlydB0I+jhQuxxhdGzLMpI
         ClWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Icf9wzL9a21uX9Qttqnfe0T9al7xHnqPl+5L89eyGjo=;
        b=SK8pEChN6dzW8Pqg6ZfanUXK8GpxNV8dCdx4Sdm6D02SvGQGY5+CCXj1k4tqdyo6gY
         78DFKzExPq7JtfT3hwRKhFZjWrmMWAIUSBVPEHCWvWQO9MhaPTRHY7BNCvMElCJohGta
         Hy9Nut3zH3gMt1xx2kcnpwSHtLg1grsYDRA+2wWhqeAKYe71yX2fMHJu2evddcvmh8LF
         U1Vt+0/CCpwynOcidoQgYI8CCgpPEaPk996UQcL4kYSVM5TaUzY/Xo3o6SotgyGsKHUu
         iaG3wt78VZy/nK7az7sJdVkk6Pyi+qIPeXZRdXQEDtC2dRubnqTt8cNvN01LHC81K7RL
         6Edw==
X-Gm-Message-State: AOAM5325w4ptLbjx/32MvV5RLAUS1GvpemVpJIrp8Zbw/VVGG9NpLYA1
        +aaO1m26W6RsJA+WlOoh8fk/j6Z0weoJW1LBmYc=
X-Google-Smtp-Source: ABdhPJwue+nwFjH/4wBxx/ll8rL+v4UGMwiU5b3baX7zoNAN1vzTwc86+djyLJ+QxsaSJgfKF6cArpTeZM2lVkuJ/18=
X-Received: by 2002:a05:6e02:1a21:: with SMTP id g1mr1863399ile.9.1619081250548;
 Thu, 22 Apr 2021 01:47:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210421092317.68716-1-amir73il@gmail.com> <CAOQ4uxhh305WPZ-puLONej2TLQTe54-FUtrsgp2R8ohdDcNP0A@mail.gmail.com>
 <CAJfpegtoTJRnNQnttVw54pndEqrpzfxttp=NCQ_2za859fWMqA@mail.gmail.com>
In-Reply-To: <CAJfpegtoTJRnNQnttVw54pndEqrpzfxttp=NCQ_2za859fWMqA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 22 Apr 2021 11:47:19 +0300
Message-ID: <CAOQ4uxgZemF+wYzorW8s2+4=1dRds3EKkKBs=bybdhrTC-QMJg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Test overlayfs readdir cache
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 22, 2021 at 10:53 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, Apr 22, 2021 at 8:18 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, Apr 21, 2021 at 12:23 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > Eryu,
> > >
> > > This extends the generic t_dir_offset2 test to verify
> > > some more test cases and adds a new generic test which
> > > passes on overlayfs (and other fs) on upstream kernel.
> > >
> > > The overlayfs specific test fails on upstream kernel
> > > and the fix commit is currently in linux-next.
> > > As usual, you may want to wait with merging until the fix
> > > commit hits upstream.
> > >
> > > Miklos,
> > >
> > > I had noticed in the test full logs that readdir of
> > > a merged dir behaves strangely - when seeking backwards
> > > to offsets > 0, readdir returns unlinked entries in results.
> > > The test does not fail on that behavior because the test
> > > only asserts that this is not allowed after seek to offset 0.
> > >
> > > Knowing the implementation of overlayfs readdir cache this is
> > > not surprising to me, but I wonder if this behavior is POSIX
> > > compliant, and if not, whether we should document it and/or
> > > add a failing test for it.
> > >
> >
> > I think the outcome could be worse.
> > If a copied up entry is unlinked after populating the dir cache
> > but before ovl_cache_update_ino() then ovl_cache_update_ino()
> > and subsequently the getdents call will fail with ENOENT.
> >
> > This test is not smart enough to cover this case (if it really exists).
> > I think we need to relax the case of negative lookup result in
> > ovl_cache_update_ino() and just set p->whiteout without and
> > continue with no error.
> >
> > This can solve several test cases.
> > In principle, we can "semi-reset" the merge dir cache if the dir was
> > modified after every seek, not just seek to 0.
> > By "semi-reset" I mean use the list, but force ovl_cache_update_ino()
> > to all upper entries, similar to ovl_dir_read_impure().
> >
> > OR.. we can just do that unconditionally in ovl_iterate().
> > The ovl dentry cache for the children will be populated after the first
> > ovl_iterate() anyway, so maybe the penalty is not so bad?
>
> POSIX does allow stale readdir data (not just in case of non-zero seek):
>
> "If a file is removed from or added to the directory after the most
> recent call to opendir() or rewinddir(), whether a subsequent call to
> readdir() returns an entry for that file is unspecified."
>
> If you think about the way readdir(3) is implemented by the libc, this
> is inevitable.

I see. In that case, I would defer merging this test as it assumes too much
about readdir behavior (even though applications may expect this behavior).

>
> Returning ENOENT from readdir(3) is obviously a bug.
>
> The merge case being not super high performance is perfectly okay.
> The only thing I've worried about in that case is unbound memory use,
> but apparently that hasn't been an issue in practice.
>

Okay, so I will try to reproduce the ENOENT and fix it.
In any case, even if the bug exists it's not urgent.

Thanks,
Amir.

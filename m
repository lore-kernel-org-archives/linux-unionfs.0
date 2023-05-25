Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41456C77B7A
	for <linux-unionfs@archiver.kernel.org>; Thu, 25 May 2023 16:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241760AbjEYQDX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 25 May 2023 12:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241362AbjEYQDW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 May 2023 12:03:22 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEF61AC
        for <linux-unionfs@vger.kernel.org>; Thu, 25 May 2023 09:03:17 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-757942bd912so63019485a.2
        for <linux-unionfs@vger.kernel.org>; Thu, 25 May 2023 09:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685030596; x=1687622596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fuvJpGj389meFD9Uvn5XC5tG5sYKldKKSNlV6ANQ17Q=;
        b=e66TtysH9Dpbs5hs90bWi4wKR92rK7ZZPf3cevUsQbUD59BdZCged0/1rwp5hasR5x
         7po6uTRMnEcdnlH0pMv5koOvedFKLWYdtQsl0NmBpxq+3XsaHKIF77nR8ub2iT4lhbIy
         fjGUAHyd5fLNK1YZwi8ra7MvwT6D/lk6KcyNQlXaZGmNrsTEDE7qkWFXA6O4ekp/0xkP
         6vFztFO0ZKAhzbVEhukF/kRKhn8wIW6WyR7p9GjoLZn79k6GvRqyZQJ2YHU90nXlouXL
         HzpaicYAFeWKJtN5cDlZ4ovsOQTqCjDDYpDgmpKVmCWJIFVnbyaCr/s+zFoDw2NKtTT2
         +lSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685030596; x=1687622596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fuvJpGj389meFD9Uvn5XC5tG5sYKldKKSNlV6ANQ17Q=;
        b=FEuNVEv1UsGS/kOSHzLGpzLEGj+gUIaTqy6hO5U8HcLyoQsMWz1van+1CTo6fmrNiZ
         /+xJerRE0SJ9huqoyjk4r05Sm9L4I6m9EFFDoGUSk4KQChBajMdVVCiRZh5pCDQc7cB8
         hMmoj5NeivsvVditjdYAXRCwaWA3HoPPunl0LzBP4IZ91rRQhEUcC8PJXqGPbO+sqAo1
         0ufSfRZ0fiFGyxYBRuDSuLXPGfqV04y9UZQ7V1A9EoySMzaIOEDiTs/jZbr3bT6IB7gC
         BII4G5foTIVn79OxHIk3O+X3AiOmo7u1mAG93o2WQa7IXgAd2RtYpwKS8eeu4PzHJ0og
         09Fw==
X-Gm-Message-State: AC+VfDxiq2lPlFPYM3UJC1Mx9PQZJ2kqeyGaDm4+GezU+PcOcNoF4qqg
        8GfWoLiF2/bXGeMDGAVTkl7H8vl0bgTQWYCA5IY=
X-Google-Smtp-Source: ACHHUZ6vz/Tp2J8Gz4n8WWz1ZhaTDlq50XZjMBMOfIDTd9xWzy9sQ3cJlN6/aC1W7UhEX/YXo7r5HP/X1VECpg2Sz/c=
X-Received: by 2002:a05:620a:8d14:b0:75b:23a1:8330 with SMTP id
 rb20-20020a05620a8d1400b0075b23a18330mr9187951qkn.43.1685030595786; Thu, 25
 May 2023 09:03:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
In-Reply-To: <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 25 May 2023 19:03:04 +0300
Message-ID: <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, May 25, 2023 at 6:21=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> Something that came up about this in a discussion recently was
> multi-layer composefs style images. For example, this may be a useful
> approach for multi-layer container images.
>
> In such a setup you would have one lowerdata layer, but two real
> lowerdirs, like lowerdir=3DA:B::C. In this situation a file in B may
> accidentally have the same name as a file on C, causing a redirect
> from A to end up in B instead of C.
>

I was under the impression that the names of the data blobs in C
are supposed to be content derived names (hash).
Is this not the case or is the concern about hash conflicts?

> Would it be possible to have a syntax for redirects that mean "only
> lookup in lowerdata layers. For example a double-slash path
> //some/file.
>

Anything is possible if we can define the problem that needs to be solved.
In this case, I did not understand why the problem is limited to finding a =
file
by mistake in layer B.

If there are several data layers A:B::C:D why wouldn't we have the same
problem with a file name collision between C and D?

So if there was a need to be able to redirect to a specific layer,
I would imagine that we would need to be able to address any layer
and not just "the start of data layers".

If we were looking for a syntax that is not a current valid redirect,
anything with // would work as well as anything with / that is not
an absolute path, e.g. 3:/path/to/file, so both NFS and SMB ;-)

Please describe the problem with more details and examples.

Thanks,
Amir.

> On Thu, Apr 27, 2023 at 3:06=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > Miklos,
> >
> > This v2 combines the prep patch set [1] and lazy lookup patch set [2].
> >
> > This work is motivated by Alexander's composefs use case.
> > Alexander has been developing and testing his fsverity patches over
> > my lazy-lowerdata-lookup branch [3].
> >
> > Alexander has also written tests for lazy lowerdata lookup [4].
> >
> > Note that patch #1 is a Fixes patch for stable.
> > Gao commented that the fix may not be complete, but I think it is bette=
r
> > than no fix at all.
> >
> > Regarding lazy lookup in d_real(), I am not sure if the best effort
> > lookup is the best solution, but in any case, none of this code kicks i=
n
> > without explicit opt-in to data-only layers, so the risk of breaking
> > existing setups is quite low.
> >
> > Thanks,
> > Amir.
> >
> > Changes since v1:
> > - Include the prep patch set
> > - Split remove lowerdata from add lowerdata_redirect patch
> > - Remove embedded ovl_entry stack optimization
> > - Add lazy lookup and comment in d_real_inode()
> > - Improve documentation of :: data-only layers syntax
> > - Added RVBs
> >
> > [1] https://lore.kernel.org/linux-unionfs/20230408164302.1392694-1-amir=
73il@gmail.com/
> > [2] https://lore.kernel.org/linux-unionfs/20230412135412.1684197-1-amir=
73il@gmail.com/
> > [3] https://github.com/amir73il/linux/commits/ovl-lazy-lowerdata
> > [4] https://github.com/amir73il/xfstests/commits/ovl-lazy-lowerdata
> >
> > Amir Goldstein (13):
> >   ovl: update of dentry revalidate flags after copy up
> >   ovl: use OVL_E() and OVL_E_FLAGS() accessors
> >   ovl: use ovl_numlower() and ovl_lowerstack() accessors
> >   ovl: factor out ovl_free_entry() and ovl_stack_*() helpers
> >   ovl: move ovl_entry into ovl_inode
> >   ovl: deduplicate lowerpath and lowerstack[]
> >   ovl: deduplicate lowerdata and lowerstack[]
> >   ovl: remove unneeded goto instructions
> >   ovl: introduce data-only lower layers
> >   ovl: implement lookup in data-only layers
> >   ovl: prepare to store lowerdata redirect for lazy lowerdata lookup
> >   ovl: prepare for lazy lookup of lowerdata inode
> >   ovl: implement lazy lookup of lowerdata in data-only layers
> >
> >  Documentation/filesystems/overlayfs.rst |  36 +++++
> >  fs/overlayfs/copy_up.c                  |  11 ++
> >  fs/overlayfs/dir.c                      |   3 +-
> >  fs/overlayfs/export.c                   |  41 +++---
> >  fs/overlayfs/file.c                     |  21 ++-
> >  fs/overlayfs/inode.c                    |  38 +++--
> >  fs/overlayfs/namei.c                    | 185 +++++++++++++++++++-----
> >  fs/overlayfs/overlayfs.h                |  20 ++-
> >  fs/overlayfs/ovl_entry.h                |  73 ++++++++--
> >  fs/overlayfs/super.c                    | 132 ++++++++++-------
> >  fs/overlayfs/util.c                     | 165 ++++++++++++++++-----
> >  11 files changed, 534 insertions(+), 191 deletions(-)
> >
> > --
> > 2.34.1
> >
>
>
> --
> =3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
>  Alexander Larsson                                Red Hat, Inc
>        alexl@redhat.com         alexander.larsson@gmail.com
>

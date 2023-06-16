Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961D1EB64D7
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 12:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343914AbjFPM3F (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 08:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245728AbjFPM3E (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 08:29:04 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCDC30DE
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 05:29:02 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4f62b512fe2so840119e87.1
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 05:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686918540; x=1689510540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Je4wKJDXUhPjDqsRw7g4AfFybZP9Ee4ty0VIPJuhWNU=;
        b=UUAQbu1DdPYzIvnfi3q2/DPDLAK+HjAOF1I+2utfJ2SIJGUE9aUI8BatVmZ3PTMS0Y
         265odcLk+su2t92/OpqV1CQn7xAlPmi7+oKbnrCyRHkz3D0elzDKD5sV6I/NHlxZJBoe
         7ioUthEafdAsmJCrzsmVLSqez1kWSRwBUoucM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686918540; x=1689510540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Je4wKJDXUhPjDqsRw7g4AfFybZP9Ee4ty0VIPJuhWNU=;
        b=id3gd2kik1LKvPjaCypI+rSlfoOMuRmi/dcC6VIsKdM4Oh3E+9aZ6EBBN82CTMh7/u
         SDRQHvhjVNlr/A4RkuMbaWpbO1bGwWfedcfNBN6TqdfZPkFfhSYIZnLTUCmYUK2kT4mA
         zAoGnS24VjuTx6EBHkt+E1cHFxDxTyPRD6/gjso0L+eMxX24c5AJJmZe5pMIIhrtkOza
         rQWsJUs+ve4dXrHxt5txF2a0OWqooFIaxM7ABJwbZj6GRs2ZWTXmvy8o0KgxtWNHzvFN
         IVEToPzgc1vHMzU15Uh/k2iAsNZf/8brhpvy1Dg5BWeyHi2kiPgvr8i315w83L61f7Yh
         EJMQ==
X-Gm-Message-State: AC+VfDwbWdEl/anSY3oEcV5G3JUEm+Doc7efk5CLl0fzlhy/cCVY/KHK
        dUvRqXwiR6ahGm73UWgwbDnf85Q1VSyLw7gbrOSI6A==
X-Google-Smtp-Source: ACHHUZ7qJRtRlaThg3+PgbSaW6KEOwp4gGjqX4kUeE8ctZDPNvdgDCguLBr1XEplobpmokSKRa4NygOk0gOdNKEAWkc=
X-Received: by 2002:a2e:330f:0:b0:2a8:bd1f:a377 with SMTP id
 d15-20020a2e330f000000b002a8bd1fa377mr1601160ljc.20.1686918540214; Fri, 16
 Jun 2023 05:29:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683102959.git.alexl@redhat.com> <b58e57955e122b5d6c4e087cf2dd6ed664152c7b.1683102959.git.alexl@redhat.com>
 <20230514191647.GD9528@sol.localdomain> <CAOQ4uxhEq8u37YNnqQmLbybJy1Kkg3Qk0TVtRZQP-yHt8CMmWA@mail.gmail.com>
 <CAL7ro1Hqc29w-FuRuoEfcsxiXTnqqwHP73nwvmZRuKVRsz4D9w@mail.gmail.com>
 <CAOQ4uxh_y+YO3q7dB=ALCriq31RhapOHGt+jcXTQbOC7iVqYTw@mail.gmail.com>
 <CAL7ro1GTzJy5Nv1vH0buVEXUnUk7cXBhSJB2ap8Jt_hutk7nYw@mail.gmail.com>
 <CAOQ4uxgbMD2RdEqta7a2t3uVceLuZDxOWA9SBNDAgZSdO_532Q@mail.gmail.com>
 <CAL7ro1FF_q7FEJdevWrqvugkJ9S8bU5MxcoHHrLC3D834u4+zQ@mail.gmail.com>
 <CAOQ4uxgo9LOM3minBH0vw3huxjrHmO5O-caGfhgOUGCuT0B9Vg@mail.gmail.com>
 <20230616052444.GA181948@sol.localdomain> <CAOQ4uxjBfPvDb5921vV+jO1wtgoeWenEietmK6orP7Bh+gROqw@mail.gmail.com>
 <CAL7ro1FSPYL=P+h_qUXw=NHzPx89vR24dbZc8UOtVeYMqg5xrw@mail.gmail.com>
 <CAOQ4uxjSLwx3NsrXJAir5DLjY-Xo5e7Qs5NjK1gFygsbTO3E-g@mail.gmail.com>
 <CAL7ro1EYAPZYcqAiiR7r6HX2kp4XiWby0OBCEjYodNjP4VD18A@mail.gmail.com>
 <CAOQ4uxig=DHThgTr97ga4oGmoGshxa5f+or9gbjxXZ=qTDHHgg@mail.gmail.com>
 <CAL7ro1FUPQnwiN43jRZWAgdczPgYKj2H6Scx081gS-V+sC7cqA@mail.gmail.com> <CAOQ4uxg=6rtzZObEZCPEg81orGYtv-kODaruvqY6exd=Fqw_hg@mail.gmail.com>
In-Reply-To: <CAOQ4uxg=6rtzZObEZCPEg81orGYtv-kODaruvqY6exd=Fqw_hg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 16 Jun 2023 14:28:48 +0200
Message-ID: <CAJfpegvgeb8QFc7AcTiLYyNZ5kWhbC4YrEh8A0idAPxjAhHHzA@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ovl: Validate verity xattr when resolving lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 16 Jun 2023 at 14:24, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Jun 16, 2023 at 2:33=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > On Fri, Jun 16, 2023 at 11:28=E2=80=AFAM Amir Goldstein <amir73il@gmail=
.com> wrote:
> > >
> > > On Fri, Jun 16, 2023 at 11:39=E2=80=AFAM Alexander Larsson <alexl@red=
hat.com> wrote:
> > > >
> > > > On Fri, Jun 16, 2023 at 10:12=E2=80=AFAM Amir Goldstein <amir73il@g=
mail.com> wrote:
> > > > >
> > > > >
> > > > > > I don't believe this format will actually need to change much.
> > > > > > However, I do agree
> > > > > > with the general requirement for *some* ability to move forward=
 with
> > > > > > this format,
> > > > > > so I'm gonna go with a single version byte.
> > > > > >
> > > > >
> > > > > I disagree.
> > > > > If you present a real life use case why that really matters
> > > > > then I can reconsider.
> > > >
> > > > I disagree, but I'll add them.
> > > >
> > >
> > > Let's ask for a 3rd opinion.
> > > don't add them for now, unless Miklos says that you should.
> >
> > I added them to the branch anyway for now. However, if we're going
> > full header + flags anyway, I wonder if we really need the
> > "overlay.digest" xattr at all? We could just put the header + optional
> > digest in the "overlay.metacopy" xattr, and then just read/store one
> > xattr. Right now metacopy is zero size, but adding some data to it
> > would not break ovl_check_metacopy_xattr() in older kernels.
> >
> > Basically, during the lookup we get the metacopy xattr anyway, and
> > when we do we could record in a flag that there is a digest in it,
> > then during open we don't have to look for a separate digest xattr,
> > just re-load the metacopy xattr if the flag is set. With this in place
> > we can also easily add other flags to overlay.metacopy, which imho
> > makes a ton more sense than adding flags to overlay.digest.
> >
>
> I think that is a wonderful idea.
> I like it a lot.

Agreed.

Thanks,
Miklos

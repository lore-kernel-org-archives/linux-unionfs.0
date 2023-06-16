Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D13EB64D7
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 12:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244204AbjFPMZB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 08:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345101AbjFPMYw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 08:24:52 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD9930E0
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 05:24:51 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-43f519c0888so239712137.3
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 05:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686918290; x=1689510290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Ew5hqa9EchnoEVph/du/TmA2ggMa4hebl6W/B9abKY=;
        b=N+Ie41tSwXYIjvOjgRJ3tKMmuQ3nCDxKIGLhq8jweXR5EME0TCzx9CRlWAHzL2nq5N
         Le5ZfW5KKhY4cxUmJqnTkkDfODq4RoXYPCgypEfhcdgHRtu7/R89K0i36BMUCOlLJg/3
         cJ5PCqLipSPNzpICQCjr33U4PyST5yxCgUXEWLjW/L5Vo2LLK2y5Il5KnA9KD2/irtl1
         U/UUA/Ra4RJOPggMsXVHA2RloDoN57q7dbzgKhGVjqbPYRvaOOKxE5EOouPfR+tAykW5
         iWEEbSbxVIZT75UYYhAU9g6E4VdzBI+TH1Yv0f1r1DQFRmsF5nNuzJiDnaVFn5WVxTl4
         ze3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686918290; x=1689510290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Ew5hqa9EchnoEVph/du/TmA2ggMa4hebl6W/B9abKY=;
        b=bdOtE5sqUFz1XXI4Fua7Nupa1fKcBldJsZToBzWZpMdMCNXfpmvKV48eKdknEuoJSd
         MQi2Sw3qrX5abWcag0r4TrNQ6HsRCpdfPN7izyGTRogZL0nEmlhlIxV3QhgiyxbIFKMa
         uaCHrDij1YJLYbaRH1kpNw8JWwqDem/fnfW0JOG3V7wR75z1GVL/7ic3m/yvVWSdcdF6
         1ziw8d9X9SOYEvORzv4xfFhsrfLpEvU2FuysBWGp09+uYCxD38Ugxzc2VlzhHKJLeoTg
         jVvFVKcnUBexCH+RjJN1ru/6HKqHb5+TC72mn4cAQpwIQ96MkkCEbkQ2Rh8Rdihratmu
         YCNg==
X-Gm-Message-State: AC+VfDxKZdSv8Yz/FhdqJMHAgGH9G2T+ZAk08QsqjBDerX9YeSJRNP0H
        /HDtJHDyilpWNkhtDoqy/Z9JU4wMqfOyoQ+6H7g=
X-Google-Smtp-Source: ACHHUZ6bG0MQ3SB9ELzuXgI/tGGa43ze5J1Ak5oyBV7gymOMdIhR1WcV24vDu+fZ2qheP817v+EaWjpR5YGgCH53Ml8=
X-Received: by 2002:a67:ad06:0:b0:43f:d22b:4206 with SMTP id
 t6-20020a67ad06000000b0043fd22b4206mr1569702vsl.29.1686918290056; Fri, 16 Jun
 2023 05:24:50 -0700 (PDT)
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
 <CAOQ4uxig=DHThgTr97ga4oGmoGshxa5f+or9gbjxXZ=qTDHHgg@mail.gmail.com> <CAL7ro1FUPQnwiN43jRZWAgdczPgYKj2H6Scx081gS-V+sC7cqA@mail.gmail.com>
In-Reply-To: <CAL7ro1FUPQnwiN43jRZWAgdczPgYKj2H6Scx081gS-V+sC7cqA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 16 Jun 2023 15:24:38 +0300
Message-ID: <CAOQ4uxg=6rtzZObEZCPEg81orGYtv-kODaruvqY6exd=Fqw_hg@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ovl: Validate verity xattr when resolving lowerdata
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 16, 2023 at 2:33=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Fri, Jun 16, 2023 at 11:28=E2=80=AFAM Amir Goldstein <amir73il@gmail.c=
om> wrote:
> >
> > On Fri, Jun 16, 2023 at 11:39=E2=80=AFAM Alexander Larsson <alexl@redha=
t.com> wrote:
> > >
> > > On Fri, Jun 16, 2023 at 10:12=E2=80=AFAM Amir Goldstein <amir73il@gma=
il.com> wrote:
> > > >
> > > >
> > > > > I don't believe this format will actually need to change much.
> > > > > However, I do agree
> > > > > with the general requirement for *some* ability to move forward w=
ith
> > > > > this format,
> > > > > so I'm gonna go with a single version byte.
> > > > >
> > > >
> > > > I disagree.
> > > > If you present a real life use case why that really matters
> > > > then I can reconsider.
> > >
> > > I disagree, but I'll add them.
> > >
> >
> > Let's ask for a 3rd opinion.
> > don't add them for now, unless Miklos says that you should.
>
> I added them to the branch anyway for now. However, if we're going
> full header + flags anyway, I wonder if we really need the
> "overlay.digest" xattr at all? We could just put the header + optional
> digest in the "overlay.metacopy" xattr, and then just read/store one
> xattr. Right now metacopy is zero size, but adding some data to it
> would not break ovl_check_metacopy_xattr() in older kernels.
>
> Basically, during the lookup we get the metacopy xattr anyway, and
> when we do we could record in a flag that there is a digest in it,
> then during open we don't have to look for a separate digest xattr,
> just re-load the metacopy xattr if the flag is set. With this in place
> we can also easily add other flags to overlay.metacopy, which imho
> makes a ton more sense than adding flags to overlay.digest.
>

I think that is a wonderful idea.
I like it a lot.

Thanks,
Amir.

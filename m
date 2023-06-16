Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204A9EB64D7
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 07:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243554AbjFPHvg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 03:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241738AbjFPHvc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 03:51:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8438B2965
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 00:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686901857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3yTALJgl5VwfXZyTr99YwpTRrW0V6/OKG4FhyimV7kk=;
        b=EpnvbEux7GaS7+wg9OA+YWKeZgeC7I9+zzq8yCvUf3g8owQhVvc72InyRwP27p7IwYzc+w
        XYjVPpumYuC27vuHDFnlSgfgGcy0w7C9zI4QJVI6YrDi4j64v0iy29+ZERq82aDru+WCev
        0/K0YXY7f9y1+Fnj5xPQ7P5xXRMfOvE=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-bA2Kq6s9NwSL4v1IppNEVA-1; Fri, 16 Jun 2023 03:50:56 -0400
X-MC-Unique: bA2Kq6s9NwSL4v1IppNEVA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-340bdf36dcdso4094265ab.0
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 00:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686901855; x=1689493855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3yTALJgl5VwfXZyTr99YwpTRrW0V6/OKG4FhyimV7kk=;
        b=hLvV9gd7WMVmkCX0IHLSX3RHKzYd+NxPRi2gzzqooClfH4pP4p9KrvidUpK3npcRB4
         zzJNXQLk8vprShti3xB8pcboYgZj4aE4h1hs+7EBw360ErqDh4B7VDSl9w4eZnczHZ4E
         +3ZOnN3DYyJUtbxaEpeWHInEmIOHr0R5bQWh0Ul4jfpNJLOam+wRwHy/dk9Rhw5Axhbt
         fX2b9vpc3lRaYZ+JIi8Ib0He1fBrDob3jkmxSarns3tCi3HVFR2OXGSONXYtHFuEHU6l
         TQXcMWyjMb8QbqQ71Elv4UArCaRcl+VFa/KQkMm8j0oCFU7k1u11qN2fs/xfkX+4gUFZ
         a5RA==
X-Gm-Message-State: AC+VfDz/yd2ZxotJgsRg7p7kCysbJUHFZiEWBY5AcxkU05agDpuoKt1X
        h/8v5qU/hiyF2K4IqAW5bz43O6TE64FW7XMWAs6NRmcZsSwFaCEgf0RidUpKrgHE6/k6peMTfTe
        KqhwfjAxCnl00aK/+1nZsGuFoJRJIlLZsBiyImzOEzLCravO2+Q==
X-Received: by 2002:a92:d648:0:b0:331:4f70:a2b with SMTP id x8-20020a92d648000000b003314f700a2bmr2103662ilp.5.1686901855178;
        Fri, 16 Jun 2023 00:50:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6u8kPaJAhdFTppm5aeqe/Nh0jLq0BPZdDYi0jZOv7ZP+P4/LRD6o//oF4FFAuFaYMcjFhAQqjG74sY15zemxc=
X-Received: by 2002:a92:d648:0:b0:331:4f70:a2b with SMTP id
 x8-20020a92d648000000b003314f700a2bmr2103653ilp.5.1686901854927; Fri, 16 Jun
 2023 00:50:54 -0700 (PDT)
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
In-Reply-To: <CAOQ4uxjBfPvDb5921vV+jO1wtgoeWenEietmK6orP7Bh+gROqw@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Fri, 16 Jun 2023 09:50:43 +0200
Message-ID: <CAL7ro1FSPYL=P+h_qUXw=NHzPx89vR24dbZc8UOtVeYMqg5xrw@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ovl: Validate verity xattr when resolving lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 16, 2023 at 7:55=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Fri, Jun 16, 2023 at 8:24=E2=80=AFAM Eric Biggers <ebiggers@kernel.org=
> wrote:
> >
> > On Fri, Jun 16, 2023 at 08:07:43AM +0300, Amir Goldstein wrote:
> > > > I would really like to get the overlay.verity xattr support in
> > > > upstream pretty soon, because without it I can't release a stable
> > > > version of the composefs userspace code. I don't want to release
> > > > something that is using an xattr format that is not guaranteed to b=
e
> > > > stable.
> > > >
> > >
> > > Alex,
> > >
> > > Pondering about this last sentence.
> > >
> > > The overlay.verity xattr format is already in its 3rd revision since
> > > the beginning of development.
> > >
> > > When it was bare digest, it might have made sense to have no
> > > header that describes the format.
> > >
> > > When the algo byte was added, that was already a very big hint
> > > that a proper header was in order.
> > >
> > > Now that you had to change the meaning of the byte, it is very hard
> > > to argue that the xattr format is guaranteed to be stable - in the se=
nse
> > > that it can never change again.
> > >
> > > Please add a minimal header to the overlay.verity xattr format,
> > > similar to ovl_fb, that will allow composefs/overlayfs to be
> > > maintained as the separate projects that they are.
> > >
> > > Something like this?
> > >
> > > /* On-disk format for "verity" xattr */
> > > struct ovl_verity {
> > >         u8 version;     /* 0 */
> > >         u8 len;          /* size of this header + size of digest */
> > >         u8 flags;
> > >         u8 algo;        /* digest algo */
> > >         u8 digest[];
> > > };
> > >
> > > I realize that digest size may be inferred from xattr size,
> > > but it is better to state the stored digest size explicitly and verif=
y
> > > that it matches expected xattr size.
> >
> > If it was up to me I think I'd keep it even more "minimal" just do:
> >
> >         struct ovl_verity {
> >                 u8 version;     /* 0 */
> >                 u8 algo;        /* digest algo */
> >                 u8 digest[];
> >         };
> >
> > It's up to you, though.
>
> Please keep len and flags.
> Nothing to be gained from removing them.

Something is gained by removing them: smaller images.

I have a Centos 9 developer rootfs here to test with. The basic
composefs image size for this with the current format (1 byte for algo)
is 11M. Adding one more byte (version) adds 88k (0.8%) to it and adding 3
bytes (version+flags+len) adds 240k (2.1%).

These are not huge costs, but they are not really giving any huge advantage=
s
either. I mean, the digest length can be computed already, both from
the xattr size
and the algo type. And flag-like features could be encoded in the
version byte, or,
if really needed, a version 2 header could add a flags field.

I don't believe this format will actually need to change much.
However, I do agree
with the general requirement for *some* ability to move forward with
this format,
so I'm gonna go with a single version byte.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com


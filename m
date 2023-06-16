Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2683EB64D7
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 09:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343770AbjFPJ25 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 05:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245255AbjFPJ2k (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 05:28:40 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCB1294E
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 02:27:31 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id ada2fe7eead31-43b4ffbaec6so186467137.0
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 02:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686907650; x=1689499650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hkeij4ZAwYndsVh41u8zTD0Wa2QKjossi3tYxUZI1kQ=;
        b=mL852j4Rrj3RSaQSKpiieqECkQJftSn+0ZIHYLzwOIURXf8U/6MXPI0DCbmRopBhL/
         acxlVDQmFwQqG2SAeeDXbyRpUYRPsnGjI611klWdhAm3wTKfltE6AwIJmgGkSeSWJBaC
         Z3G/tmyi1GQCSNWOjkhqPt4qzfDioP9YzqL6qJQ/ulVa9EP1Depe2Oeo4a2HbdpJRae/
         aDNEiL/meVg4xHa21z1CxbGO7H0h8koxPwBYNIHRARM0QbS7p6AcekphMQVxJS389oUn
         8uw4Qx1S4YeWTl5A5U+llIX+PNrSr5fn3l+JzyELELqLt4fxCxZQcVcLEiGo9blNH6Zs
         1yeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686907650; x=1689499650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hkeij4ZAwYndsVh41u8zTD0Wa2QKjossi3tYxUZI1kQ=;
        b=ChZAVdNxsi0s71yVSCp1ssrVDnE29rOrD6eXcHK5jX2rD91MNd94zN2o2Cz5WgV37u
         arsThrH2oD6g3VKxSoxxpbmiBZcJptUf5K6NTPEJ1Fkk4cyElxeLnIAL/CvyY//WlL//
         c5g2zuU1m6d+0xOllJeWVH56k2nVnmK/geHrsfdaEHZF/4zuLF0PdOTNNpQf9/kb1zcy
         5YccddVlX8GpTPH9/1xNilKpx2W0niEkTtyS2qj1M9bIV5Oy8IduDEZGpt98UR9Ws9k1
         Gl6dSk/4Euaivmvy7+E/AYyorPYJ6DN8ePwut5xW/cs0qAVpiedDvhe4fsgGuEQnVhQn
         U8Bw==
X-Gm-Message-State: AC+VfDyo5MUImfpfXy21DQlZxidOFDWBOAufhcqSNeYKfX3U74y6wNIp
        oyk+e4ln5wYRGuojkSTVkQw/nKX/vRg8jZzGzjc=
X-Google-Smtp-Source: ACHHUZ6h30HPLOSPfqhkoxbgEBZjf8TV/EbKIcwcVzmdergwtM0VAAFCZvDEoxkjCp7THdIAgCc34X6wxT7eSpZfKP4=
X-Received: by 2002:a67:f501:0:b0:430:7349:3de8 with SMTP id
 u1-20020a67f501000000b0043073493de8mr1300183vsn.34.1686907650220; Fri, 16 Jun
 2023 02:27:30 -0700 (PDT)
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
 <CAOQ4uxjSLwx3NsrXJAir5DLjY-Xo5e7Qs5NjK1gFygsbTO3E-g@mail.gmail.com> <CAL7ro1EYAPZYcqAiiR7r6HX2kp4XiWby0OBCEjYodNjP4VD18A@mail.gmail.com>
In-Reply-To: <CAL7ro1EYAPZYcqAiiR7r6HX2kp4XiWby0OBCEjYodNjP4VD18A@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 16 Jun 2023 12:27:18 +0300
Message-ID: <CAOQ4uxig=DHThgTr97ga4oGmoGshxa5f+or9gbjxXZ=qTDHHgg@mail.gmail.com>
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

On Fri, Jun 16, 2023 at 11:39=E2=80=AFAM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> On Fri, Jun 16, 2023 at 10:12=E2=80=AFAM Amir Goldstein <amir73il@gmail.c=
om> wrote:
> >
> > On Fri, Jun 16, 2023 at 10:50=E2=80=AFAM Alexander Larsson <alexl@redha=
t.com> wrote:
> > >
> > > On Fri, Jun 16, 2023 at 7:55=E2=80=AFAM Amir Goldstein <amir73il@gmai=
l.com> wrote:
> > > >
> > > > On Fri, Jun 16, 2023 at 8:24=E2=80=AFAM Eric Biggers <ebiggers@kern=
el.org> wrote:
> > > > >
> > > > > On Fri, Jun 16, 2023 at 08:07:43AM +0300, Amir Goldstein wrote:
> > > > > > > I would really like to get the overlay.verity xattr support i=
n
> > > > > > > upstream pretty soon, because without it I can't release a st=
able
> > > > > > > version of the composefs userspace code. I don't want to rele=
ase
> > > > > > > something that is using an xattr format that is not guarantee=
d to be
> > > > > > > stable.
> > > > > > >
> > > > > >
> > > > > > Alex,
> > > > > >
> > > > > > Pondering about this last sentence.
> > > > > >
> > > > > > The overlay.verity xattr format is already in its 3rd revision =
since
> > > > > > the beginning of development.
> > > > > >
> > > > > > When it was bare digest, it might have made sense to have no
> > > > > > header that describes the format.
> > > > > >
> > > > > > When the algo byte was added, that was already a very big hint
> > > > > > that a proper header was in order.
> > > > > >
> > > > > > Now that you had to change the meaning of the byte, it is very =
hard
> > > > > > to argue that the xattr format is guaranteed to be stable - in =
the sense
> > > > > > that it can never change again.
> > > > > >
> > > > > > Please add a minimal header to the overlay.verity xattr format,
> > > > > > similar to ovl_fb, that will allow composefs/overlayfs to be
> > > > > > maintained as the separate projects that they are.
> > > > > >
> > > > > > Something like this?
> > > > > >
> > > > > > /* On-disk format for "verity" xattr */
> > > > > > struct ovl_verity {
> > > > > >         u8 version;     /* 0 */
> > > > > >         u8 len;          /* size of this header + size of diges=
t */
> > > > > >         u8 flags;
> > > > > >         u8 algo;        /* digest algo */
> > > > > >         u8 digest[];
> > > > > > };
> > > > > >
> > > > > > I realize that digest size may be inferred from xattr size,
> > > > > > but it is better to state the stored digest size explicitly and=
 verify
> > > > > > that it matches expected xattr size.
> > > > >
> > > > > If it was up to me I think I'd keep it even more "minimal" just d=
o:
> > > > >
> > > > >         struct ovl_verity {
> > > > >                 u8 version;     /* 0 */
> > > > >                 u8 algo;        /* digest algo */
> > > > >                 u8 digest[];
> > > > >         };
> > > > >
> > > > > It's up to you, though.
> > > >
> > > > Please keep len and flags.
> > > > Nothing to be gained from removing them.
> > >
> > > Something is gained by removing them: smaller images.
> > >
> > > I have a Centos 9 developer rootfs here to test with. The basic
> > > composefs image size for this with the current format (1 byte for alg=
o)
> > > is 11M. Adding one more byte (version) adds 88k (0.8%) to it and addi=
ng 3
> > > bytes (version+flags+len) adds 240k (2.1%).
> > >
> >
> > I am not impressed.
> > This is micro optimization IMO.
>
> Most optimization is a sequence of micro optimizations.
>
> > If you want to optimize xattrs for size, you could have erofs
> > compress all trusted.overlay.* names into byte special codes.
>
> This is already supported as per:
> https://lists.ozlabs.org/pipermail/linux-erofs/2023-April/008074.html
> (Although I have not yet added it to composefs userspace)
>
> I don't see why you would not want to try to minimize both keyname and
> value size though.

Nice.
didn't know that it was already in motion.

>
> > On local disk fs, this few bytes change in xattr size won't matter one =
bit.
> >
> > > These are not huge costs, but they are not really giving any huge adv=
antages
> > > either. I mean, the digest length can be computed already, both from
> > > the xattr size
> > > and the algo type. And flag-like features could be encoded in the
> > > version byte, or,
> > > if really needed, a version 2 header could add a flags field.
> > >
> >
> > Yes it could at the cost of uglier code.
> > We will do that if we have to, but not because we failed
> > to reserve room for flags to begin with.
> > It would be a rookie on-disk format mistake to do that.
> >
> > > I don't believe this format will actually need to change much.
> > > However, I do agree
> > > with the general requirement for *some* ability to move forward with
> > > this format,
> > > so I'm gonna go with a single version byte.
> > >
> >
> > I disagree.
> > If you present a real life use case why that really matters
> > then I can reconsider.
>
> I disagree, but I'll add them.
>

Let's ask for a 3rd opinion.
don't add them for now, unless Miklos says that you should.

Thanks,
Amir.

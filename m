Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB58EB64D8
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 08:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343499AbjFPIkw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 04:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343509AbjFPIk2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 04:40:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FC82D7F
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 01:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686904782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mqUvQiB7TDCbdr55kjf0GrMtDk2XSi7gvwa19GGQzdg=;
        b=WPFnBmixskjC4NftG/CSyJPgTiRylvD3B5wn2sPvQvksiGGI0bupTLLNikLjwwIQUSJ0nP
        a3qdkOeDUKgKsipW/IsXuEbYshrJmTpWUWoF2H3IN9dCBncLiHA/+eMieBNsWNTl5PnqHR
        ohNZVsG/0S7A1UKN+/x/XQs4AQoeNaE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-4S46PymmMVCsujVA_bbRwA-1; Fri, 16 Jun 2023 04:39:41 -0400
X-MC-Unique: 4S46PymmMVCsujVA_bbRwA-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-33fd4eed094so3734785ab.1
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 01:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686904780; x=1689496780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mqUvQiB7TDCbdr55kjf0GrMtDk2XSi7gvwa19GGQzdg=;
        b=b8dw33z3K08pye/osvIUKiNUX+PWbsBmJPLFtlz6Qz76xe3mvs9hpwKZ2oyqFT0jHs
         VfyFaHDPgwXSS3euRPAapQI+/6yioyVi5cpVAkDVujngSUBly2dshR7sFK4bRiIJ5uG8
         DJowe5NarwslezrFiix3iKVCvgZGGZPjoVxKhazQG0R72TjIXk9Di6oBJCjxn/XWL22X
         fiVeER2F7GK184vPNy0OLNxuXu4f9NljATSBcOkgaJSo+5uRs17hfsZG7N5cqHlR3Wiv
         ok1OaVp0moaH+7u3C7tPMqp8OkdT+tAANDgL6IU5jsoQLx+EkmmlNwe9OWKKnNXuKMpc
         ix4A==
X-Gm-Message-State: AC+VfDzmIkng/yGejiAC8kxjnPsXvBQOm7FZcJ9w4ooe7v9VgmTWThwe
        CoDfwGZW/sutG+u3XcJNR9q5HGvtDhNq7plsha7zbMYpAu9wtkZITRwngJTqXBtx5REc+dg/sao
        SgJ+cqmwUI15FNhGgJnRgf0W3BZJkb0S3RmLVzyJcfA==
X-Received: by 2002:a92:d8c3:0:b0:338:af0b:f2bd with SMTP id l3-20020a92d8c3000000b00338af0bf2bdmr1692714ilo.5.1686904780445;
        Fri, 16 Jun 2023 01:39:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7DwSVytG4bn/08mhgzlsICHCFfV3deBhvxLr5BSCk4fo+JYY07vDeD1Iva/ryqLAR5snH+8Z3tYbueYvMG7I8=
X-Received: by 2002:a92:d8c3:0:b0:338:af0b:f2bd with SMTP id
 l3-20020a92d8c3000000b00338af0bf2bdmr1692708ilo.5.1686904780213; Fri, 16 Jun
 2023 01:39:40 -0700 (PDT)
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
 <CAL7ro1FSPYL=P+h_qUXw=NHzPx89vR24dbZc8UOtVeYMqg5xrw@mail.gmail.com> <CAOQ4uxjSLwx3NsrXJAir5DLjY-Xo5e7Qs5NjK1gFygsbTO3E-g@mail.gmail.com>
In-Reply-To: <CAOQ4uxjSLwx3NsrXJAir5DLjY-Xo5e7Qs5NjK1gFygsbTO3E-g@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Fri, 16 Jun 2023 10:39:29 +0200
Message-ID: <CAL7ro1EYAPZYcqAiiR7r6HX2kp4XiWby0OBCEjYodNjP4VD18A@mail.gmail.com>
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

On Fri, Jun 16, 2023 at 10:12=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Fri, Jun 16, 2023 at 10:50=E2=80=AFAM Alexander Larsson <alexl@redhat.=
com> wrote:
> >
> > On Fri, Jun 16, 2023 at 7:55=E2=80=AFAM Amir Goldstein <amir73il@gmail.=
com> wrote:
> > >
> > > On Fri, Jun 16, 2023 at 8:24=E2=80=AFAM Eric Biggers <ebiggers@kernel=
.org> wrote:
> > > >
> > > > On Fri, Jun 16, 2023 at 08:07:43AM +0300, Amir Goldstein wrote:
> > > > > > I would really like to get the overlay.verity xattr support in
> > > > > > upstream pretty soon, because without it I can't release a stab=
le
> > > > > > version of the composefs userspace code. I don't want to releas=
e
> > > > > > something that is using an xattr format that is not guaranteed =
to be
> > > > > > stable.
> > > > > >
> > > > >
> > > > > Alex,
> > > > >
> > > > > Pondering about this last sentence.
> > > > >
> > > > > The overlay.verity xattr format is already in its 3rd revision si=
nce
> > > > > the beginning of development.
> > > > >
> > > > > When it was bare digest, it might have made sense to have no
> > > > > header that describes the format.
> > > > >
> > > > > When the algo byte was added, that was already a very big hint
> > > > > that a proper header was in order.
> > > > >
> > > > > Now that you had to change the meaning of the byte, it is very ha=
rd
> > > > > to argue that the xattr format is guaranteed to be stable - in th=
e sense
> > > > > that it can never change again.
> > > > >
> > > > > Please add a minimal header to the overlay.verity xattr format,
> > > > > similar to ovl_fb, that will allow composefs/overlayfs to be
> > > > > maintained as the separate projects that they are.
> > > > >
> > > > > Something like this?
> > > > >
> > > > > /* On-disk format for "verity" xattr */
> > > > > struct ovl_verity {
> > > > >         u8 version;     /* 0 */
> > > > >         u8 len;          /* size of this header + size of digest =
*/
> > > > >         u8 flags;
> > > > >         u8 algo;        /* digest algo */
> > > > >         u8 digest[];
> > > > > };
> > > > >
> > > > > I realize that digest size may be inferred from xattr size,
> > > > > but it is better to state the stored digest size explicitly and v=
erify
> > > > > that it matches expected xattr size.
> > > >
> > > > If it was up to me I think I'd keep it even more "minimal" just do:
> > > >
> > > >         struct ovl_verity {
> > > >                 u8 version;     /* 0 */
> > > >                 u8 algo;        /* digest algo */
> > > >                 u8 digest[];
> > > >         };
> > > >
> > > > It's up to you, though.
> > >
> > > Please keep len and flags.
> > > Nothing to be gained from removing them.
> >
> > Something is gained by removing them: smaller images.
> >
> > I have a Centos 9 developer rootfs here to test with. The basic
> > composefs image size for this with the current format (1 byte for algo)
> > is 11M. Adding one more byte (version) adds 88k (0.8%) to it and adding=
 3
> > bytes (version+flags+len) adds 240k (2.1%).
> >
>
> I am not impressed.
> This is micro optimization IMO.

Most optimization is a sequence of micro optimizations.

> If you want to optimize xattrs for size, you could have erofs
> compress all trusted.overlay.* names into byte special codes.

This is already supported as per:
https://lists.ozlabs.org/pipermail/linux-erofs/2023-April/008074.html
(Although I have not yet added it to composefs userspace)

I don't see why you would not want to try to minimize both keyname and
value size though.

> On local disk fs, this few bytes change in xattr size won't matter one bi=
t.
>
> > These are not huge costs, but they are not really giving any huge advan=
tages
> > either. I mean, the digest length can be computed already, both from
> > the xattr size
> > and the algo type. And flag-like features could be encoded in the
> > version byte, or,
> > if really needed, a version 2 header could add a flags field.
> >
>
> Yes it could at the cost of uglier code.
> We will do that if we have to, but not because we failed
> to reserve room for flags to begin with.
> It would be a rookie on-disk format mistake to do that.
>
> > I don't believe this format will actually need to change much.
> > However, I do agree
> > with the general requirement for *some* ability to move forward with
> > this format,
> > so I'm gonna go with a single version byte.
> >
>
> I disagree.
> If you present a real life use case why that really matters
> then I can reconsider.

I disagree, but I'll add them.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com


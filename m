Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B54BC77B73
	for <linux-unionfs@archiver.kernel.org>; Sat, 27 May 2023 14:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjE0OEO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 27 May 2023 10:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbjE0OEO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 27 May 2023 10:04:14 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4E0E4
        for <linux-unionfs@vger.kernel.org>; Sat, 27 May 2023 07:04:12 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 6a1803df08f44-62606e67c0dso13534646d6.2
        for <linux-unionfs@vger.kernel.org>; Sat, 27 May 2023 07:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685196251; x=1687788251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UR3Jd63qwLXXuFvlwjR7PD4KUchJiQAZbB1n5Whe6Rs=;
        b=lCvZ6VH+rvmk6sA+E2hCDF4SkDPWlUjMnkRBlinvveq5eO4R/LjgKsv7SQJ4KNfokU
         Xx9GIRRYM61r5lXlrczjrvolfUFtcQisJrLNOyeg4ZB4lNdOHQplgQkFX3L19EAR3iZn
         i2snpAaNXn5sRuUu0TwZS4YKsgDVXfgw497S5RzrxI7TosMf/3Czipe9lsbkgKx4UgSC
         r31CadxWZcx+f53SnUwv/44XLFowtA0j4T2DK4ipV7c79sP+ZhkqprG4wEOjg0OInejh
         0Bh5/xAZSqpw3EiQHfFEowrm6LvzvTWiAlIIga9UGHR7OrQwamez1DwRsqjr3og9WmSe
         tdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685196251; x=1687788251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UR3Jd63qwLXXuFvlwjR7PD4KUchJiQAZbB1n5Whe6Rs=;
        b=jqmlRLSvJ/nLeZdfZQGj9wY0YVgyWwTrxwZVYbAcEk40gYHhSnV9FeV2DTvaqAjOkd
         LrfSS18CFzFWgeY8X1yB1ygv4JOc7qPUknNJduGS62fCQDvDyJnocJed4+GTnX9LtID7
         i8EeBibDbPYcrleVZlCPpduuNTIUJ7Ngltdi5ot2+e3yduD8DAOY/S53EvJF071rv7o8
         pb2Nye4XSoArd8HJGY/MD7cW3AkK8NhLQ5GMGJGmOAsP4jv/fW7ynSb7QAd5umqcC12R
         agrRNvrxyZA9+qXX4Xy5nJ3jkh5mjaTggImsgPk3sY2Zfrqbqx3qZsfAePwg1S97D+0x
         ZZpw==
X-Gm-Message-State: AC+VfDx74FmifDzO3s72AXKIxN+n2fSaEHFhoVQVt0mVL0NFnpOf/uF2
        fSOgPBqWaOOFe683jUey2alwxHJCg3HnAEAq0lcgclNb
X-Google-Smtp-Source: ACHHUZ7kjU9sMiBzsNPQH2TApbFU3VbN5aZsqfgUL7DmXVsTUIMvvWvdjFQWjXZ22pOX4apMhC31/I9rPQYBnpDwGpw=
X-Received: by 2002:a05:6214:5185:b0:5e8:c098:2493 with SMTP id
 kl5-20020a056214518500b005e8c0982493mr5134090qvb.50.1685196251365; Sat, 27
 May 2023 07:04:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com> <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com> <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com>
In-Reply-To: <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 27 May 2023 17:04:00 +0300
Message-ID: <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 26, 2023 at 9:27=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
> Hi,
>
> On 2023/5/26 04:36, Alexander Larsson wrote:
> > On Fri, May 26, 2023 at 7:12=E2=80=AFAM Amir Goldstein <amir73il@gmail.=
com> wrote:
> >>
> >> On Thu, May 25, 2023 at 7:59=E2=80=AFPM Giuseppe Scrivano <gscrivan@re=
dhat.com> wrote:
> >>>
> >>> Hi Amir,
> >>>
> >>> Amir Goldstein <amir73il@gmail.com> writes:
> >>>
> >>>> On Thu, May 25, 2023 at 6:21=E2=80=AFPM Alexander Larsson <alexl@red=
hat.com> wrote:
> >>>>>
> >>>>> Something that came up about this in a discussion recently was
> >>>>> multi-layer composefs style images. For example, this may be a usef=
ul
> >>>>> approach for multi-layer container images.
> >>>>>
> >>>>> In such a setup you would have one lowerdata layer, but two real
> >>>>> lowerdirs, like lowerdir=3DA:B::C. In this situation a file in B ma=
y
> >>>>> accidentally have the same name as a file on C, causing a redirect
> >>>>> from A to end up in B instead of C.
> >>>>>
> >>>>
> >>>> I was under the impression that the names of the data blobs in C
> >>>> are supposed to be content derived names (hash).
> >>>> Is this not the case or is the concern about hash conflicts?
> >>>>
> >>>>> Would it be possible to have a syntax for redirects that mean "only
> >>>>> lookup in lowerdata layers. For example a double-slash path
> >>>>> //some/file.
> >>>>>
> >>>>
> >>>> Anything is possible if we can define the problem that needs to be s=
olved.
> >>>> In this case, I did not understand why the problem is limited to fin=
ding a file
> >>>> by mistake in layer B.
> >>>>
> >>>> If there are several data layers A:B::C:D why wouldn't we have the s=
ame
> >>>> problem with a file name collision between C and D?
> >>>
> >>> the data layer is constructed in a way that files are stored by their
> >>> hash and there is control from the container runtime on how this is
> >>> built and maintained.  So a file name collision would happen only whe=
n
> >>> on a hash collision.
> >>>
> >>> Differently for the other layers we've no control on what files are i=
n
> >>> the image, unless we limit to mount only one EROFS as the first lower
> >>> layer and then all the other lower layers are data layers.
> >>>
> >>> Given your example above A:B::C:D, if both A and B are EROFS we are
> >>> limited in the files/directories that can be in B.
> >>>
> >>> e.g. we have A/foo with the following xattrs:
> >>>
> >>> trusted.overlay.metacopy=3D""
> >>> trusted.overlay.redirect=3D"/1e/de1743e73b904f16924c04fbd0b7fbfb7e45b=
8640241e7a08779e8f38fc20d"
> >>>
> >>> Now what would happen if /1e is present as a file in layer B?  It wil=
l
> >>> just cause the lookup for `foo` to fail with EIO since the redirect
> >>> didn't find any file in the layers below.
> >>>
> >>>
> >>
> >> I understand the problem and I understand why a // redirect to data-on=
ly layers
> >> would be a simple and workable solution for composefs.
> >>
> >> Unlike the rest of the changes to overlayfs that we worked on to suppo=
rt
> >> composefs, this would really be a composefs only on-disk format becaus=
e it
> >> could not be generated by overlayfs itself, so we need Miklos to chime=
 in to
> >> say if this is acceptable.
>
> An alternative way might allow data-only layers (or invisible layers) in =
the
> middle rather than as the tail?
>

Anything is possible if you can justify its worth.

> I'm not sure in the long term if it's flexible to fix data-only layers as=
 the
> bottom-most layers for future potential use cases.
>
> At a quick glance, I've seen the implementation of this patchset also
> strictly code that.   I wonder if using non-fixed invisible layers increa=
ses
> the complexity or am I still missing something?
>

The current implementation is quite simplified due to keeping data-only
layers in the tail, and even more simplified that lazy lowerdata lookup
is only in the data-only layers at the tail of the stack.
The documentation is also simpler as do the tests.

Making all the the above more complex needs justification and so far
I did not see any use case that would justify it, because the /.cfs
workaround is good enough IMO.

That leaves the question - is the design/API flexible enough to be
extended in the future if we needed to?

If we would want to support data-only layers in the middle on the
stack, which would this syntax make sense?
lowerdir=3Dlower1::data1:lower2::data2

If this syntax makes sense to everyone, then we can change the syntax
of data-only in the tail from lower1::data1:data2 to lower1::data1::data2
and enforce that after the first ::, only :: are allowed.

Miklos, any thoughts?
I have a feeling that this was your natural interpretation when you first
saw the :: syntax.

Thanks,
Amir.

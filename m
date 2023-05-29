Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE52C77B7E
	for <linux-unionfs@archiver.kernel.org>; Mon, 29 May 2023 07:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjE2HYG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 29 May 2023 03:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjE2HYF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 29 May 2023 03:24:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB54AC
        for <linux-unionfs@vger.kernel.org>; Mon, 29 May 2023 00:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685344995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pckkZm77JkSAvkVHteKxpmPACDg20vGFkUfG2N1BwDk=;
        b=QNrxpfJ46IzO5yXhDjnHnmq1zop57HBmiRyp4xNKPYsQfJdLgzqmOzjrOc1C/ZfkagRoYB
        KOpM7DXs/aYWdkARfEBlNC4gmXFHuI8XpK1wzW6MPedu8uLtYDH4oPle/nYP60nfmDIcDk
        Ognl8lerNPgKJGeQSQ/ug81hVNF48rE=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-nQ5lS6XRPjyVnp5bXHL-3g-1; Mon, 29 May 2023 03:23:11 -0400
X-MC-Unique: nQ5lS6XRPjyVnp5bXHL-3g-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-33b27ff696eso8768355ab.1
        for <linux-unionfs@vger.kernel.org>; Mon, 29 May 2023 00:23:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685344990; x=1687936990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pckkZm77JkSAvkVHteKxpmPACDg20vGFkUfG2N1BwDk=;
        b=HpTRxLdRMSngaSzN1L+to0vF7lzAgME9H6SQXv/50feIBspiArabUC5Sc9/XDmfPl4
         7ZtkKYrduM3uhFVeGl2A86ZfbdHgL4YLzpuSAfV00h19+CdD61iXlciL3PpqpBJct7uD
         0LHtFSLi5zHdg5zycUdHAlk/+emdrJd8jC/5HctXAv2VBKF+hvkpm9yLBpw1XQFsUuxd
         f0IwfAfA2LJPm2ydYOegaMKDhnYHcWJ2ramX3QHyq/DX+j8xWkeuhynam7ekPdC+TsJC
         uojf/rmAKWRC9fgnJ0W7+hzKP2gEIlpxJ/YlMWyd0Uom6F31pyMK0BMDt5in0sjqF27h
         vg6A==
X-Gm-Message-State: AC+VfDxh0E5Nj3/L5T9unyN0ppgQ5UlWc2/4jnl6ai9yeUTMMrsgm7AI
        YmMCqhqaDx5KWupHNs8SED5V9UneAU3Ge458t50se4uDK90dj+gqmxMG6g00Ek8sBPib0JZJZMf
        /b8bPIrMRGPs9zIALACUHntHV1dizBMXpmb/bsCOy0w==
X-Received: by 2002:a92:d203:0:b0:338:1b0f:28eb with SMTP id y3-20020a92d203000000b003381b0f28ebmr5487993ily.23.1685344990671;
        Mon, 29 May 2023 00:23:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ529OiGrIiy0UYe04cy3yKqtolCBZ6rvdYujFS+CoYubmh+m0yhHHMbdqS16mlzVT4wqTObepl0mcBv6l/ZWPI=
X-Received: by 2002:a92:d203:0:b0:338:1b0f:28eb with SMTP id
 y3-20020a92d203000000b003381b0f28ebmr5487986ily.23.1685344990402; Mon, 29 May
 2023 00:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com> <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com> <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 29 May 2023 09:22:59 +0200
Message-ID: <CAL7ro1Fg_2pibX2LW0LJht7f+vDfFPazz6zHSYtD9MbwO+SzXw@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 27, 2023 at 4:04=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Fri, May 26, 2023 at 9:27=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibab=
a.com> wrote:
> >
> > Hi,
> >
> > On 2023/5/26 04:36, Alexander Larsson wrote:
> > > On Fri, May 26, 2023 at 7:12=E2=80=AFAM Amir Goldstein <amir73il@gmai=
l.com> wrote:
> > >>
> > >> On Thu, May 25, 2023 at 7:59=E2=80=AFPM Giuseppe Scrivano <gscrivan@=
redhat.com> wrote:
> > >>>
> > >>> Hi Amir,
> > >>>
> > >>> Amir Goldstein <amir73il@gmail.com> writes:
> > >>>
> > >>>> On Thu, May 25, 2023 at 6:21=E2=80=AFPM Alexander Larsson <alexl@r=
edhat.com> wrote:
> > >>>>>
> > >>>>> Something that came up about this in a discussion recently was
> > >>>>> multi-layer composefs style images. For example, this may be a us=
eful
> > >>>>> approach for multi-layer container images.
> > >>>>>
> > >>>>> In such a setup you would have one lowerdata layer, but two real
> > >>>>> lowerdirs, like lowerdir=3DA:B::C. In this situation a file in B =
may
> > >>>>> accidentally have the same name as a file on C, causing a redirec=
t
> > >>>>> from A to end up in B instead of C.
> > >>>>>
> > >>>>
> > >>>> I was under the impression that the names of the data blobs in C
> > >>>> are supposed to be content derived names (hash).
> > >>>> Is this not the case or is the concern about hash conflicts?
> > >>>>
> > >>>>> Would it be possible to have a syntax for redirects that mean "on=
ly
> > >>>>> lookup in lowerdata layers. For example a double-slash path
> > >>>>> //some/file.
> > >>>>>
> > >>>>
> > >>>> Anything is possible if we can define the problem that needs to be=
 solved.
> > >>>> In this case, I did not understand why the problem is limited to f=
inding a file
> > >>>> by mistake in layer B.
> > >>>>
> > >>>> If there are several data layers A:B::C:D why wouldn't we have the=
 same
> > >>>> problem with a file name collision between C and D?
> > >>>
> > >>> the data layer is constructed in a way that files are stored by the=
ir
> > >>> hash and there is control from the container runtime on how this is
> > >>> built and maintained.  So a file name collision would happen only w=
hen
> > >>> on a hash collision.
> > >>>
> > >>> Differently for the other layers we've no control on what files are=
 in
> > >>> the image, unless we limit to mount only one EROFS as the first low=
er
> > >>> layer and then all the other lower layers are data layers.
> > >>>
> > >>> Given your example above A:B::C:D, if both A and B are EROFS we are
> > >>> limited in the files/directories that can be in B.
> > >>>
> > >>> e.g. we have A/foo with the following xattrs:
> > >>>
> > >>> trusted.overlay.metacopy=3D""
> > >>> trusted.overlay.redirect=3D"/1e/de1743e73b904f16924c04fbd0b7fbfb7e4=
5b8640241e7a08779e8f38fc20d"
> > >>>
> > >>> Now what would happen if /1e is present as a file in layer B?  It w=
ill
> > >>> just cause the lookup for `foo` to fail with EIO since the redirect
> > >>> didn't find any file in the layers below.
> > >>>
> > >>>
> > >>
> > >> I understand the problem and I understand why a // redirect to data-=
only layers
> > >> would be a simple and workable solution for composefs.
> > >>
> > >> Unlike the rest of the changes to overlayfs that we worked on to sup=
port
> > >> composefs, this would really be a composefs only on-disk format beca=
use it
> > >> could not be generated by overlayfs itself, so we need Miklos to chi=
me in to
> > >> say if this is acceptable.
> >
> > An alternative way might allow data-only layers (or invisible layers) i=
n the
> > middle rather than as the tail?
> >
>
> Anything is possible if you can justify its worth.
>
> > I'm not sure in the long term if it's flexible to fix data-only layers =
as the
> > bottom-most layers for future potential use cases.
> >
> > At a quick glance, I've seen the implementation of this patchset also
> > strictly code that.   I wonder if using non-fixed invisible layers incr=
eases
> > the complexity or am I still missing something?
> >
>
> The current implementation is quite simplified due to keeping data-only
> layers in the tail, and even more simplified that lazy lowerdata lookup
> is only in the data-only layers at the tail of the stack.
> The documentation is also simpler as do the tests.
>
> Making all the the above more complex needs justification and so far
> I did not see any use case that would justify it, because the /.cfs
> workaround is good enough IMO.
>
> That leaves the question - is the design/API flexible enough to be
> extended in the future if we needed to?
>
> If we would want to support data-only layers in the middle on the
> stack, which would this syntax make sense?
> lowerdir=3Dlower1::data1:lower2::data2
>
> If this syntax makes sense to everyone, then we can change the syntax
> of data-only in the tail from lower1::data1:data2 to lower1::data1::data2
> and enforce that after the first ::, only :: are allowed.
>
> Miklos, any thoughts?
> I have a feeling that this was your natural interpretation when you first
> saw the :: syntax.

I agree that the current limit of data only at the end is good enough
for now. But yeah, having this syntax seems to give more options long
terms, and no real disadvantages. At the very least it is not harder
to understand or worse, and as you say, probably even more natural.


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com


Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A83C7EE2E
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jun 2023 07:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238001AbjFIHYh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 03:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjFIHYg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jun 2023 03:24:36 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443911712
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Jun 2023 00:24:35 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-977d55ac17bso271809766b.3
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jun 2023 00:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686295473; x=1688887473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=peOLr9dt7GaWqU550VAlE53HzCl5yykHQ1n/UHiA40U=;
        b=nB3+DE9mCXMWIgEEqRubW+TPG/eNhbd89fOH/kIspESb4gkPNQWQLBh/3CA1x9ESdi
         YCtie9cNxBo58SYyeFFfCwQTgwn7yBM0SEfrDXSBkFeT2IWKzjHvSmbCjMb6cabW5G1p
         +nacgMGX6npR0qspa0ml/YpWUSg70JxS1Jb4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686295473; x=1688887473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=peOLr9dt7GaWqU550VAlE53HzCl5yykHQ1n/UHiA40U=;
        b=Mf31qqfFAXxlGMkPyta8v2f8lZQG+T6bhIRoWNjSvjTcZkS0szNioLgM+LnNlJ7Yra
         6uDCk1yGHUDbcBx4nhBXi+QFLH3fwyGXoU5g9nKF1j+KIuRBIh83lc/ZXn8TrQRxk7x8
         qWeWiJK+/emNktaHWCBZbSXL9YLsK2u3aXH/xWDSFEuxXrh1vcBYGx82wStvWlCZuQcL
         LUZ5UO7Sgsd9mbE85ySkeE0eA/IBlP1Xwtlya5Rll/JoyNNxGuf1PqPexUQDFvELixEO
         mtz9n/p/2k3OpM5cc4i5x84K5jNg+ESz9M+MGaNV+eX1rKlKOJ582QGP59k6+V157ksc
         GbrA==
X-Gm-Message-State: AC+VfDzkORQKZd/fKZkqbO8Hy3yEcHg89xO7WE+80nbNcBGl07vOlpmz
        RTiQkacAo2chv7+fFOr8XyVwff5nkBKCoEYG4248GK+GKb+RcJmd
X-Google-Smtp-Source: ACHHUZ6Z6pSBZh5quoZOTXALLEPsERUVs9yDDx9wDkje8yuBxiNYkzwDqVPw+YYvkTMyjBoI0XOIRQVkACgLFy6yS8c=
X-Received: by 2002:a17:907:31ce:b0:978:992e:efcf with SMTP id
 xf14-20020a17090731ce00b00978992eefcfmr1028754ejb.57.1686295473734; Fri, 09
 Jun 2023 00:24:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com> <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com> <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
 <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com> <CAOQ4uxh14O9aRiewc+nq+AL-029YGu4bb4AZpp854r78Jm=_dw@mail.gmail.com>
In-Reply-To: <CAOQ4uxh14O9aRiewc+nq+AL-029YGu4bb4AZpp854r78Jm=_dw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Jun 2023 09:24:22 +0200
Message-ID: <CAJfpegvnBrLtNcW0Oy8Y7seju96scQ0-FHoiXxx3+A3X4N_LMQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        Alexander Larsson <alexl@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 30 May 2023 at 16:15, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, May 30, 2023 at 5:08=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Sat, 27 May 2023 at 16:04, Amir Goldstein <amir73il@gmail.com> wrote=
:
> >
> > > If we would want to support data-only layers in the middle on the
> > > stack, which would this syntax make sense?
> > > lowerdir=3Dlower1::data1:lower2::data2
> > >
> > > If this syntax makes sense to everyone, then we can change the syntax
> > > of data-only in the tail from lower1::data1:data2 to lower1::data1::d=
ata2
> > > and enforce that after the first ::, only :: are allowed.
> > >
> > > Miklos, any thoughts?
> > > I have a feeling that this was your natural interpretation when you f=
irst
> > > saw the :: syntax.
> >
> > Yes, I think it's more natural to have a prefix for each data-only
> > layer.  And this is also good for extensibility, as discussed.
> >
>
> Good timing ;-)
>
> I was just about to say that I changed the syntax and pushed to:
>
> https://github.com/amir73il/linux/commits/ovl-lazy-lowerdata-v3
> https://github.com/amir73il/xfstests/commits/ovl-lazy-lowerdata
>
> The gist of the documentation of v3 is:
>
> Below the top most lower layer, any number of lower most layers may be de=
fined
> as "data-only" lower layers, using double colon ("::") separators.
> A normal lower layer is not allowed to be below a data-only layer, so sin=
gle
> colon separators are not allowed to the right of double colon ("::") sepa=
rators.
>
> For example:
>
>   mount -t overlay overlay -olowerdir=3D/l1:/l2:/l3::/do1::/do2 /merged
>
>
> Do you need me to post the v3 patches?
>
> The changes since ovl-lazy-lowerdata-v2 branch are:
> - Reabse on 6.4-rc2 + NULL deref fixes
> - Syntax change

Patches look good to me.

Pushed v3 to overlayfs-next.

It'd be interesting to hear what obstacles you encountered when trying
to implement generic lazy lookup.  I can put that into the pull
request so the information is not lost.

Thanks,
Miklos

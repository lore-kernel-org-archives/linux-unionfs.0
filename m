Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFFDC0032E
	for <linux-unionfs@archiver.kernel.org>; Wed, 25 Oct 2023 07:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjJYHIo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 03:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjJYHIn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Oct 2023 03:08:43 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10917A6
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Oct 2023 00:08:40 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9be02fcf268so776705066b.3
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Oct 2023 00:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1698217718; x=1698822518; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fe6CJmGOZ4iszcivpDDoWAgqEAdtV8qsFbvpmPSsWwA=;
        b=Sx19DaLrUIO+hlrAOF7uzr21c/OfWr3ef3oAmQpr9RN241D1ZNf/7KG3oAoS3fUA4G
         LSb/5EftcJ3MscFjBHif6dd9xZmBs0I4q6A30q8+8IxfF8AbUKw8vO8kA8La3jd5Zib6
         O97LjgDQH3B3znWAZFQ9t+p42Yw9iv8z7oVW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698217718; x=1698822518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fe6CJmGOZ4iszcivpDDoWAgqEAdtV8qsFbvpmPSsWwA=;
        b=FaZ+HkS6ORH2W0i3CosdWcfqaflJaCoN1x2iztKz6g7AdyRAXC5EI0qQR4q2UtI20c
         kMbUUnK3C+BuEnkOP1nWyFHeYMWIe683LMjWrYqUmyEADT2esW76kWNbSJN94m4wfUyO
         HTuJufaGxNXcSa+zX1uGdaZv4CKLSZlHTQHA5PRxS5UbUvrOp8ib9VdOkQGptq7x3jRM
         gTCV9e+paaUNaLImA78/sQXl+Z/QWzml+6n1lyCHvbIDRwvGTKYBVTS5mhrggXhcLeFR
         ZDF2Bo5vrDz/2Y9L/mhJq9j8W3SE2xSJx/n8oDWI1/buMG1iDP1gddTk+Q01RvfhdK0S
         f6xg==
X-Gm-Message-State: AOJu0YzgzWmbdJZoaDBp9ynYKFeL0QtzM5xgzVFGhlF8Iswr8fjRupmt
        8/Y7MepeR7IgBnbkmC1BpoltK6TralGnEgohcWl6/g==
X-Google-Smtp-Source: AGHT+IF7VIGgwEpoNSUgge10Lw6zm0vhEJ/R1PbIC4qjhopIzfujHML9REGDPGPX/tdEAgjp/THkT782EF7c9L0BaoQ=
X-Received: by 2002:a17:907:9282:b0:9bd:fc4b:6c9b with SMTP id
 bw2-20020a170907928200b009bdfc4b6c9bmr11516611ejc.36.1698217718466; Wed, 25
 Oct 2023 00:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com> <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
 <CAOQ4uxiE89q62JHnxwm14FBShPORmX_h0EyDCBN-VKv6aTf5BQ@mail.gmail.com>
 <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
 <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
 <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com>
 <CAOQ4uxic3NDtEt9EiP+RYKGEB=6b_PCaudQA=cXK6mWY4Cmeqg@mail.gmail.com>
 <CAJfpegsr3A4YgF2YBevWa6n3=AcP7hNndG6EPMu3ncvV-AM71A@mail.gmail.com>
 <CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com>
 <CAOQ4uxhg+0_S1tQv9vUpv7Yu-VRLv7U7cnxLmxig+9LmS_qW+A@mail.gmail.com>
 <CAJfpegu6cESPijvO51zjVeXA=wcw7nMaNkkNJ7+my07wq8k9FA@mail.gmail.com> <CAOQ4uxghGb-J6LSv0HNMkDg5rKCGrLK+0_LyEQ59F=XdvizVug@mail.gmail.com>
In-Reply-To: <CAOQ4uxghGb-J6LSv0HNMkDg5rKCGrLK+0_LyEQ59F=XdvizVug@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 25 Oct 2023 09:08:27 +0200
Message-ID: <CAJfpegtWf-Ccx5gKzdVKcBspGpCXQ-MjXW0qbQjJcfkbt7Cq6g@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 25 Oct 2023 at 06:40, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Oct 16, 2023 at 12:27=E2=80=AFPM Miklos Szeredi <miklos@szeredi.h=
u> wrote:
> >
> > On Sun, 15 Oct 2023 at 08:58, Amir Goldstein <amir73il@gmail.com> wrote=
:
> >
> > > +       for (nr =3D 0; nr < nr_added_lower; nr++, lowerdirs++) {
> > > +               if (nr < nr_merged_lower)
> > > +                       seq_show_option(m, "lowerdir+", *lowerdirs);
> > > +               else
> > > +                       seq_show_option(m, "datadir+", *lowerdirs);
> >
> > Good.
> >
>
> And if we are going to show lowerdir+/datadir+ in a comma separated
> string, we might as well also support them with FSCONFIG_SET_STRING
> as long as they don't need escaping.

My patch does support SET_STRING.   The difference is that string
param will be shown in mountinfo unchanged, while a path param will
be canonicalized.   It's interesting, because using string params and
legacy interfaces can hide the location of the layers.  OTOH they
allow for less cluttered mountinfo.   So I guess this difference can
be an advantage and a disadvantage too, depending on your point of
view, but it's probably not something we want to change.

>
> I think this may even be more important than supporting path params
> just to restore the feature that was retroactively disabled in 6.5.y.

Yeah, that would be a good way to split this up.

> We can later add FSCONFIG_SET_PATH support for all those params.
>
> I can take on writing the string params patch based on your POC,
> including the fstests, which are quite simple to do in bash for string pa=
rams.

Okay, thanks.

Miklos

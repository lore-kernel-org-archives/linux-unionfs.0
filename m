Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5F6CDB482
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Oct 2023 13:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbjJPNLc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 09:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbjJPNLO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Oct 2023 09:11:14 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24110D4C
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Oct 2023 06:10:47 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9ba1eb73c27so740835466b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Oct 2023 06:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1697461845; x=1698066645; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m1euf8qxyoAiymp1Z4SDAt5Ta135mr2K9vUvum141eM=;
        b=qqwnoi601IbZkfvDWVteRXLKra601qtYTAfQwr93uLkFnpYibZ3w8mXPyAGtkpdbYr
         ulGmF2fyA9XzUPBKs0gipz5a5i+snHOQB/FuxQmAZs9IUSpYTy67R8HImCHh/5VCgLVC
         iIf+uCtuhMUQtxfRjIdiZmL6iJWqNXFZcSym0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697461845; x=1698066645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m1euf8qxyoAiymp1Z4SDAt5Ta135mr2K9vUvum141eM=;
        b=P6lFJVlfuEjxrypQ63/ZVcDrYsRYZwuYdMfqV5hBNGggswpZM2whn/onfAfmYZIe50
         kPCge7DBD2ektuC9+ysQcJ3vBPSdPHNGiMJSVAs1qy1WTJna1Btd52LYexORJWJlU65L
         Gi87SP8S64ODW1PkIytQNGrgojxThHhceJimBVBXq2KjIOYo4qxB7m+o6Wz1mnH/eavz
         igLnOdLvFoMiwhXJcvbbcgRLGK3RrK6F6DW2rUppSj/5xAzifGXX0gihW5EUYP57Cd7L
         TJOUPd5y0tV1Bt1kr6T6g3FU6cNadp8uubwRlzllsDCcKBrYZLk+nsN3VWp4cpB51Gkq
         Fk5g==
X-Gm-Message-State: AOJu0YxELwIEUnEA0L2BQy4n+Mt7Qf+hGwJr7zstWjtAMC80u/QTtU3B
        bcW9wJTefJeEt6KmYlB9DWG1xQBMfajkvqRfEF90Bw==
X-Google-Smtp-Source: AGHT+IETehsosXHzqLoaFsfA3WfsxYj3BUZXD1OSeKf7ifZaiUliu+EgWqGDbYQ50MUEE+zEjV7ex4Oel9ADgIFXTkE=
X-Received: by 2002:a17:907:3f20:b0:9bf:60f9:9b7f with SMTP id
 hq32-20020a1709073f2000b009bf60f99b7fmr4767504ejc.4.1697461845285; Mon, 16
 Oct 2023 06:10:45 -0700 (PDT)
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
 <CAJfpegu6cESPijvO51zjVeXA=wcw7nMaNkkNJ7+my07wq8k9FA@mail.gmail.com> <CAOQ4uxicurA4nNeDkUarkTMujtsaOvwQ8HEMpz97N2SejBRx9Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxicurA4nNeDkUarkTMujtsaOvwQ8HEMpz97N2SejBRx9Q@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 16 Oct 2023 15:10:33 +0200
Message-ID: <CAJfpegv=UXqYQzvH6+py76MV7+5L6=3a+_J7LpHQ0VK5YYrAUA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 16 Oct 2023 at 13:56, Amir Goldstein <amir73il@gmail.com> wrote:
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
> > I did some testing and it turns out libmount still regresses on
> > 6.6-rc6 for the escaped comma case.  The reason is that libmount
> > doesn't understand escaping of commas, hence the '-oupper=3Dupper\,1'
> > will result in two fsconfig() calls: 'upper=3Dupper\'  and '1'.  Prior
> > to 6.5 these were nicely reconstructed into the original
> > 'upper=3Dupper\,1' by  legacy_parse_param().
> >
>
> Technically, I think this is a libmount regression, not a kernel regressi=
on.
> Since libmount 2.39, libmount will split the commas differently than
> overlayfs always did.

Ah, but it's not a regression after all, since the kernel un-split the
same commas until 6.5, so there was no way the libmount devs would
have observed any regression in overlayfs mount.   But arguing about
which component is the cause of the regression is not very productive.
Indeed libmount can be fixed parse overlayfs options the same way as
the kernel parsed them before 6.5, which is probably a much better
fix, than a kernel one.

Karel, is doing such filesystem specific option handling feasible?

If so, then for overlayfs please please pass an un-escaped (\char ->
char) string to fsconfig for "upperdir=3D" and "workdir=3D" options.

> I am ok with doing this experiment in 6.7.
>
> I saw that your patch converted upperdir/workdir to path type
> without unescaping.  Don't we need to keep the support for
> string type params for ->parse_monolothic()?

Yes.

> Or is this the reason for the change in fs_lookup_param()?

That just a bug.  It already supported the string type, and in that
case lookup must be done against AT_FDCWD and not against zero fd
(which is what it previously did).

Thanks,
Miklos

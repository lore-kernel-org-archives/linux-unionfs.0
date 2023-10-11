Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83D1CDB468
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Oct 2023 16:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbjJKQnu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 12:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbjJKQns (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2023 12:43:48 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A48B8
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 09:43:46 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-65d0da28fa8so266076d6.0
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 09:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697042625; x=1697647425; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WuSaa8m7cogkOeD2Y2wiUO0wtO9o2C7uz0hKnvXc/2k=;
        b=KzXE1AtCDJG1a+wjDgIWMO4rF3+/58puWMVjshMB1MUW135A5agd4aaCMp6pB/vtP+
         wNNA1DjhoDzjgTs8FJOogBFS1DYRDsEcrCuMliD4D9XmIU66fJFPX6GDKGHp47M0Q2HQ
         /NIpeNVCePgLVMXUjFpo7SuOvc6J9R2wwBJowZklOGWg0mMuqoaHQ3L/SMVbWcTRXgtY
         52qtwJJGkTyV9iO8xifn1FONGFuZt7fDsjjtPF66j/ppuRhSe8dmwGVANFEO2h3120Bw
         VcAh9GuF6/ae+QW8BtVsYYAWylxPACGGZW0jJ9gxTsg5Tx6uAfDLH2pwSKjSYwe6FF70
         Ov9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697042625; x=1697647425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WuSaa8m7cogkOeD2Y2wiUO0wtO9o2C7uz0hKnvXc/2k=;
        b=Le8BpdBkKTpPl3FXUpspO4ZtbLWLAat304+dPKMU8nNFJdQfcBq3wyzCH2ISTW4GA7
         f3Ny3V67VP8pr+l/fNQf9XbdRMGaqHPhoTyMo1hrMcZh4/oPyVa+kU2ydEPsb0tSs/5A
         9fpYjkw+1u9l3Tc8rk2AZFiaSt5W4lfsQtCRLow4oTMzFFDBFmFeyetgme1TtDmRmdvG
         sicDEWaMPVFjkD3Pss+er0jpLspz+SPq40iGNX6fY1D6G1hK7YU/gqDflsJ3iUEnQfX1
         vnyEAzJAndXUe9wTKvBbTJ1+8ElEmaA4y7iM8R5hjy7goDqftFPzGAr12v/iiyghBHMT
         Wxag==
X-Gm-Message-State: AOJu0Yyx5qMRigDbm0Kr500JDC3um+kWNiSQqqm+Pdo7LdWmjNl7rYH0
        0OzElPsroLLutvc+YtzkqCR8qcU+J5OFhOnRxgQ=
X-Google-Smtp-Source: AGHT+IELk8wK41xbWznfGyW03Z6/KFwetmgFFpjtYRCRFaeNTEAzjaSpizXkejaApIv9AJRBLZfYJH+WCOl4l9NrSHk=
X-Received: by 2002:a0c:c3ce:0:b0:65d:31e:b80c with SMTP id
 p14-20020a0cc3ce000000b0065d031eb80cmr23364761qvi.26.1697042625580; Wed, 11
 Oct 2023 09:43:45 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
 <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu> <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
 <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com>
 <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
 <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com>
 <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
 <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com>
 <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com>
 <CAJfpegt3AasPxXt-bX35LB_xP0YXvvETMX98FKJJFK5RX1Q78w@mail.gmail.com>
 <CAOQ4uxgc2YegLuZKg4WLnOCn8-e-hxHJh7LD4=w-x--Fg7fdpw@mail.gmail.com>
 <CAJfpegvLZfYtYo2rbvJOmhbHGE5hoWaoGeb5r4hiTMQOpv0GbQ@mail.gmail.com>
 <CAOQ4uxgBW03c9ZYvKKdD_n1z70fb=+-f6xYLzcZ6AWC3O04cXw@mail.gmail.com> <CAJfpegvngPP1KnM7JF4ofdmSVG0XH_NeOC+B97iJZbCgvfAWFw@mail.gmail.com>
In-Reply-To: <CAJfpegvngPP1KnM7JF4ofdmSVG0XH_NeOC+B97iJZbCgvfAWFw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 11 Oct 2023 19:43:33 +0300
Message-ID: <CAOQ4uxhapvMK5W=d7mYst=2OFPoD0JUFwGZ6-Q39bRuhF3m8PQ@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Sebastian Wick <sebastian.wick@redhat.com>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Oct 11, 2023 at 4:07=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Wed, 11 Oct 2023 at 14:07, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, Oct 11, 2023 at 1:18=E2=80=AFPM Miklos Szeredi <miklos@szeredi.=
hu> wrote:
> > >
> > > On Wed, 11 Oct 2023 at 10:45, Amir Goldstein <amir73il@gmail.com> wro=
te:
> > >
> > > >
> > > > We could add new keys:
> > > > lowerdir_first=3D,lowerdir_next=3D,lowerdatadir_next=3D
> > > > as explicit variants for the "[^:]",":","::" prefix detection
> > > > and those don't need to be unescaped.
> > >
> > > Good idea.  I'd merge "lowerdir_first" and "lowerdir_next" into
> > > "lowerdir_one" or whatever for simplicity.  I'd also consider droppin=
g
> > > the prefix detection, since it has only been in mainline for one
> > > cycle.
> > >
> >
> > OK.
> >
> > Christian,
> >
> > Do you know any userspace that already uses your new append prefixes?
> > Do we have any good reason to support "lowerdir_first"
> > so a lower dir stack could be reset before creating the sb?
>
> If that is a requirement, I suggest extending fsconfig(2) to allow
> resetting an option.
>

FWIW, I see that Christian has also implemented reset of lowerdir
stack with an empty string.

> > > > > >
> > > > > > Anyway, let's focus on what you would like best.
> > > > > > If you prefer to just fix the regression, it is doable.
> > > > > > If you prefer the upperdirfd, workdirfd, lowerdirfd API, I thin=
k we can
> > > > > > find a volunteer to write it up.
>
> Can't the existing option names be overloaded if a separate cmd
> (FSCONFIG_SET_PATH or FSCONFIG_SET_PATH_EMPTY) is used in fsconfig()?
>
> > > > BTW, it looks like we also don't display the user passed lowerdir
> > > > parameter as is in the case of escaped characters in lowerdirs.
> > > > Admittedly, that is another change of behavior from the new mount
> > > > api param parsers.
> > >
> > > And it's a bug (regardless of being a regression or not) since commas
> > > and whitespace  must be escaped on this interface, and colon too for
> > > being a separator of lower layers.
> >
> > OK. I think it should be easy to fix this bug.
> > I can look into it.
>
> Thanks.
>
> > > More fun: upperdir and workdir use seq_show_option() which escapes
> > > commas and whitespace, so any escaped characters during mount will en=
d
> > > up being double escaped.
> > >

FYI, I tried to reproduce this bug, but could not.
The reason (I think) is that the escaping provided by seq_show_option()
is not the dumb "prepend \", but it's the "convert to \octal".

It turns out that I also needed to store the lowerdir before unescaping,
so that a path like 'lower\:2' will be presented correctly (with \) in moun=
t
options.

Thanks,
Amir.

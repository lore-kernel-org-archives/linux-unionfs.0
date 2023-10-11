Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F2DCD6E68
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Oct 2023 13:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjJKNIB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 09:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234952AbjJKNH7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2023 09:07:59 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0298B0
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 06:07:56 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-9b29186e20aso1161007266b.2
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 06:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1697029675; x=1697634475; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FE1RDSKTmXxIgKbMG21DIzzhSMT42hfo+dJ4CmciWmk=;
        b=LJKLBmmluz/IZ+ptRz4Ah0CCJ/q6ZzJ0UJIt4WyIp5rUhK5f9yj4oTALn7xGGwW2ll
         3py3MyLcQxYmZ6JEvljKSIrOm7EXuCxpTkBuAQVXIjveSng6ElC3CyGGjEs3dUs+bEAt
         XgsxNSxwPuEZLxeE+ZIZ1f5QhMzb36ISzB8iw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697029675; x=1697634475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FE1RDSKTmXxIgKbMG21DIzzhSMT42hfo+dJ4CmciWmk=;
        b=tnRR89+SrFXVrXsI8FpsVSEolsKh+pzBzYb+u68LqKReQj8WNSrE2hiOEn8+kkLt93
         Vt44zEj6ANhxwUPB0ot75G61pAK5GILkQqJzDlZxg6INi34PsHGqmgycRaOJjowcF51w
         rBzBczP/S3qSRpWKeeGD2ePiWQwFsTX5GLgSB1uEX+1iwvwWt6AYVLD1UIvP2okhBNIT
         Z3ZJODmGMRfw0xIKiAloV9PX/EcEBdYuE2pL3eEsYLsy3VorU0O8pKx/xR7BFUVDmghP
         D2cSomN0CqKPN+l2/ZXXaFI7ba6l8z/Un9VN8FROadI9dL0GezzrezTCvKCTbYOyoEis
         YFNw==
X-Gm-Message-State: AOJu0YzR8BCpigvt1NSer+bRGEtBtzun+9aLVjAYpwhNRmTetGt/qP1x
        Z3p3IFrnMdn3HMllP8lkUIWnpvWgSdL1WPP4zul/tA==
X-Google-Smtp-Source: AGHT+IFw1upSmDb4v86QVBw2EO0yRDQHh1pFb++6FrkKSccNgrWtnukYHjwPP3x4GvzcK7sX2mswVsnfkIc83t3ifUY=
X-Received: by 2002:a17:907:2cf6:b0:9a5:c3fe:a4ef with SMTP id
 hz22-20020a1709072cf600b009a5c3fea4efmr17262703ejc.29.1697029675121; Wed, 11
 Oct 2023 06:07:55 -0700 (PDT)
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
 <CAJfpegvLZfYtYo2rbvJOmhbHGE5hoWaoGeb5r4hiTMQOpv0GbQ@mail.gmail.com> <CAOQ4uxgBW03c9ZYvKKdD_n1z70fb=+-f6xYLzcZ6AWC3O04cXw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgBW03c9ZYvKKdD_n1z70fb=+-f6xYLzcZ6AWC3O04cXw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 11 Oct 2023 15:07:43 +0200
Message-ID: <CAJfpegvngPP1KnM7JF4ofdmSVG0XH_NeOC+B97iJZbCgvfAWFw@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sebastian Wick <sebastian.wick@redhat.com>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 11 Oct 2023 at 14:07, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Oct 11, 2023 at 1:18=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Wed, 11 Oct 2023 at 10:45, Amir Goldstein <amir73il@gmail.com> wrote=
:
> >
> > >
> > > We could add new keys:
> > > lowerdir_first=3D,lowerdir_next=3D,lowerdatadir_next=3D
> > > as explicit variants for the "[^:]",":","::" prefix detection
> > > and those don't need to be unescaped.
> >
> > Good idea.  I'd merge "lowerdir_first" and "lowerdir_next" into
> > "lowerdir_one" or whatever for simplicity.  I'd also consider dropping
> > the prefix detection, since it has only been in mainline for one
> > cycle.
> >
>
> OK.
>
> Christian,
>
> Do you know any userspace that already uses your new append prefixes?
> Do we have any good reason to support "lowerdir_first"
> so a lower dir stack could be reset before creating the sb?

If that is a requirement, I suggest extending fsconfig(2) to allow
resetting an option.

> > > > >
> > > > > Anyway, let's focus on what you would like best.
> > > > > If you prefer to just fix the regression, it is doable.
> > > > > If you prefer the upperdirfd, workdirfd, lowerdirfd API, I think =
we can
> > > > > find a volunteer to write it up.

Can't the existing option names be overloaded if a separate cmd
(FSCONFIG_SET_PATH or FSCONFIG_SET_PATH_EMPTY) is used in fsconfig()?

> > > BTW, it looks like we also don't display the user passed lowerdir
> > > parameter as is in the case of escaped characters in lowerdirs.
> > > Admittedly, that is another change of behavior from the new mount
> > > api param parsers.
> >
> > And it's a bug (regardless of being a regression or not) since commas
> > and whitespace  must be escaped on this interface, and colon too for
> > being a separator of lower layers.
>
> OK. I think it should be easy to fix this bug.
> I can look into it.

Thanks.

> > More fun: upperdir and workdir use seq_show_option() which escapes
> > commas and whitespace, so any escaped characters during mount will end
> > up being double escaped.
> >
> > Obviously this domain is severely undertested.
>
> This is all very complicated because actual users always
> go through escaping rules of bash and libmount.
>
> For example, the output of 'mount' command unescapes the
> escaping done by seq_show_option() for /proc/mounts.
>
> That's why it is scary to change the legacy behavior and better
> to provide the new unescaped options as you suggested
> and leave all the escaping in the future to userspace.

And add a new api for retrieving fs specific mount options.  That
should be the next part after statmount(2) is done.

Thanks,
Miklos

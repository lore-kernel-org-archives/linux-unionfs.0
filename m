Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DCCEB64DA
	for <linux-unionfs@archiver.kernel.org>; Wed,  5 Jul 2023 13:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjGENMV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 09:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjGENMT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2023 09:12:19 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDCE1700
        for <linux-unionfs@vger.kernel.org>; Wed,  5 Jul 2023 06:12:18 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6b5ef64bca6so5971743a34.3
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Jul 2023 06:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688562737; x=1691154737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TW95HG18ezsCKE21BffsLUKmTOoVxM3BgdD2+LGrNCc=;
        b=XX3w+1/WRZLg7vKGgX94fVB8i30UTVbfjOuvH5wfJj6Mj1knxKCgaSA0Bs1PI2iJgw
         qRIAISzG2tvXfCXpp3L5ZB/BXm8AEh4mHEct4A2w9pDjMx1LJCcyub1sxqflZmHelE4B
         uhfuoPyX7uaUyaigYKci1WPQ0x88tjxYz999m/XHVxhzd81OdgIw3LNv7WlVAci5tkFB
         Asefcp6dgENx//gM18ZFI/YgGDW02L15vTwd3moawevuG+oL1VbSPhvPVlIMXwNEVcor
         DRLEJD1W8foPVKzIMHBn+4jFcHGteb3+Mk37xQCbKbz0s8rGBEZjTD0LRTRjdmf8ZRoh
         r0Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688562737; x=1691154737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TW95HG18ezsCKE21BffsLUKmTOoVxM3BgdD2+LGrNCc=;
        b=jfF35st+FFEfaiPN3dHT2SHPm6dDroYUfq1s6Uwbczyd04ct2JOT3FruO8mJ8yBKq7
         1bKgzDFfRRF8dIvP1CLVYzEoRu1kH474mpXD/QfbWM3e15IWo4fRQk3UphzlWZNAjpyU
         6Dz59MDHyIleyOOV1lEowIw+3Tmkz+j+1LnN222/ECmf48r1E9U9rdkR17j1msLQCfta
         kXjqYciZ5XyxwAe+sq1MCktzKjBUVIsFhJk3icDOpn7SHbI5xsdvO2ap3dGGbG/WndTd
         s4vMM6reF46LAV7BtKVq9ke4BSS7tehkjm4aiL+IQEplrYRw1JhvrrX3102JgrEa/w9J
         KyWA==
X-Gm-Message-State: ABy/qLYJhtf7KNwv1RmTm7EmnT3HflCnLK6B9DBvOIyf7Xc4Yv6ZudOE
        GKyLbiVkNGwXt0rESC8nchg/qOud7qdj4GCf6WY=
X-Google-Smtp-Source: APBJJlGK3cr95OCuO57YVhJkNSfHaJ1ONk+LELungNXO6xGtE05jGlm9I178g+YaXekyw+T6u3uhwYyF5Dj+wBbq3vk=
X-Received: by 2002:a05:6358:1b:b0:135:b4c:a490 with SMTP id
 27-20020a056358001b00b001350b4ca490mr7267989rww.10.1688562737432; Wed, 05 Jul
 2023 06:12:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687345663.git.alexl@redhat.com> <b7a2dfb80e35dda04edd942ad715dc88b784c218.1687345663.git.alexl@redhat.com>
 <20230703191355.GC1194@sol.localdomain> <CAL7ro1GpGczvGN28yVNMOw_9Uz-2SEJcRUMmvoBdmEWO5ynb7g@mail.gmail.com>
In-Reply-To: <CAL7ro1GpGczvGN28yVNMOw_9Uz-2SEJcRUMmvoBdmEWO5ynb7g@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 5 Jul 2023 16:12:06 +0300
Message-ID: <CAOQ4uxgfNrMEKyOxGV3L2sUauM47-L77PhwNYooY43kFF+fycw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] ovl: Add versioned header for overlay.metacopy xattr
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 5, 2023 at 11:07=E2=80=AFAM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Mon, Jul 3, 2023 at 9:14=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
> >
> > On Wed, Jun 21, 2023 at 01:18:26PM +0200, Alexander Larsson wrote:
> > > Historically overlay.metacopy was a zero-size xattr, and it's
> > > existence marked a metacopy file. This change adds a versioned header
> > > with a flag field, a length and a digest. The initial use-case of thi=
s
> > > will be for validating a fs-verity digest, but the flags field could
> > > also be used later for other new features.
> > >
> > > ovl_check_metacopy_xattr() now returns the size of the xattr,
> > > emulating a size of OVL_METACOPY_MIN_SIZE for empty xattrs to
> > > distinguish it from the no-xattr case.
> > >
> > > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > > ---
> > >  fs/overlayfs/namei.c     | 10 +++++-----
> > >  fs/overlayfs/overlayfs.h | 24 +++++++++++++++++++++++-
> > >  fs/overlayfs/util.c      | 37 +++++++++++++++++++++++++++++++++----
> > >  3 files changed, 61 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > > index 57adf911735f..3dd480253710 100644
> > > --- a/fs/overlayfs/namei.c
> > > +++ b/fs/overlayfs/namei.c
> > > @@ -25,7 +25,7 @@ struct ovl_lookup_data {
> > >       bool stop;
> > >       bool last;
> > >       char *redirect;
> > > -     bool metacopy;
> > > +     int metacopy;
> >
> > Should this be called 'metacopy_size' now?
>
> Honestly I don't know. That would change a lot of locations that still
> use this as "essentially" a boolean (i.e. !=3D 0 means "has metacopy"),
> and ity would make that code less compact. I guess this is up to Amir
> and Miklos. Surely we could add a comment in the struct definition
> though.
>

I agree most of the code looks nicer when this stays 'metacopy'

> > > -             err =3D ovl_check_metacopy_xattr(OVL_FS(d->sb), &path);
> > > +             err =3D ovl_check_metacopy_xattr(OVL_FS(d->sb), &path, =
NULL);
> > >               if (err < 0)
> > >                       goto out_err;
> >
> > This part is confusing because variables named 'err' conventionally con=
tain only
> > 0 or a negative errno value.  But this patch makes it possible for
> > ovl_check_metacopy_xattr() to return a positive size.
>
> It was already returning "negative, 0 or 1", so it's not fundamentally
> changed. Again, this is not my code so I'd rather Amir and Miklos
> decide such code style questions.
>

I agree. It wasn't 0 or negative before the change and I don't
think this "convention" justifies adding another var.

Thanks,
Amir,

Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C171EB64DD
	for <linux-unionfs@archiver.kernel.org>; Wed,  5 Jul 2023 08:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbjGEIIi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 04:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjGEIIh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2023 04:08:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525D9133
        for <linux-unionfs@vger.kernel.org>; Wed,  5 Jul 2023 01:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688544473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZjAnllnS92S3vOqpBo7l6W/k2CUBJSHTlRNn8Oppiz4=;
        b=Ywe7lWs9V0k3aw1x0c4CesuJJtFeU6VeinmUQ+Kv15undQfVfYLg2VRYa/AcjPK46WhDWM
        SNZUx+dMlePEU43z3RZt2gCaWzQBFcSND9E+SEpf0LUbH0LtYbsbNm8R/u+eMaALVpdvPF
        t7hKf/8Xu646AUymVN5WJg11ntSLjPY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-lnOXJF0ROWaPMUlXqztMfA-1; Wed, 05 Jul 2023 04:07:51 -0400
X-MC-Unique: lnOXJF0ROWaPMUlXqztMfA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-34606e2dcc9so13545255ab.0
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Jul 2023 01:07:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688544471; x=1691136471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZjAnllnS92S3vOqpBo7l6W/k2CUBJSHTlRNn8Oppiz4=;
        b=hCPC3bnbV3UpUZt9EVIGohzsKzCYLL9UGTJZzcwaT2V8BnHv3bMW/6DlCiNzUhtMje
         +wj702xKQGj9fjZrNoyR2yLmfGBSPQb+7kLcwvZX6+EjGlAjm51VcOcDKbJPWNeeaDqI
         dOsGZEiiTaavi4z1Gfhr6SwB3rCZCUtVrXzE8hw78c6UU3WcbjLu8jeqmoeDYTopXLpN
         JVk9UMT9Xbwd7JKZhIJNCvFw1xuK/SazQhnEFx37Ij2rIMwwBi4vHsLqDJQSv9xzwXVT
         uxAElsWbm0ZjC9hWc7SLuKwWk8KvE/Jap9jCnpQgQrvUV6l+23TUYPYJmid2tT8OOQeb
         +qHA==
X-Gm-Message-State: ABy/qLY+O4SEE1obuYGnQJPGatH+GrTicZhhc83W7guaT0KfTe9scdVJ
        MNZG04Ls1WgAuU3xgxyZ07khKxhoeDbhu/nRaUWgSIt9z4R6Hrhx4V1Sxf6+zEMfeGEkIBEPG0p
        /+Z2A5TjQjm7zFp5ca2ysyH/Aq45Psx62kLs2tnAU9Q==
X-Received: by 2002:a92:d7d1:0:b0:342:655f:6f25 with SMTP id g17-20020a92d7d1000000b00342655f6f25mr13496181ilq.31.1688544470858;
        Wed, 05 Jul 2023 01:07:50 -0700 (PDT)
X-Google-Smtp-Source: APBJJlH6iahUKCHAfmzEsw4rJkqZmgC0TqPd8lrw7+xDO9rFoaLFb6rFR8YZz8IFjmvbtQrnu5EBsxlUKgDi9bT0iTA=
X-Received: by 2002:a92:d7d1:0:b0:342:655f:6f25 with SMTP id
 g17-20020a92d7d1000000b00342655f6f25mr13496165ilq.31.1688544470652; Wed, 05
 Jul 2023 01:07:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1687345663.git.alexl@redhat.com> <b7a2dfb80e35dda04edd942ad715dc88b784c218.1687345663.git.alexl@redhat.com>
 <20230703191355.GC1194@sol.localdomain>
In-Reply-To: <20230703191355.GC1194@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 5 Jul 2023 10:07:39 +0200
Message-ID: <CAL7ro1GpGczvGN28yVNMOw_9Uz-2SEJcRUMmvoBdmEWO5ynb7g@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] ovl: Add versioned header for overlay.metacopy xattr
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 3, 2023 at 9:14=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Wed, Jun 21, 2023 at 01:18:26PM +0200, Alexander Larsson wrote:
> > Historically overlay.metacopy was a zero-size xattr, and it's
> > existence marked a metacopy file. This change adds a versioned header
> > with a flag field, a length and a digest. The initial use-case of this
> > will be for validating a fs-verity digest, but the flags field could
> > also be used later for other new features.
> >
> > ovl_check_metacopy_xattr() now returns the size of the xattr,
> > emulating a size of OVL_METACOPY_MIN_SIZE for empty xattrs to
> > distinguish it from the no-xattr case.
> >
> > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > ---
> >  fs/overlayfs/namei.c     | 10 +++++-----
> >  fs/overlayfs/overlayfs.h | 24 +++++++++++++++++++++++-
> >  fs/overlayfs/util.c      | 37 +++++++++++++++++++++++++++++++++----
> >  3 files changed, 61 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index 57adf911735f..3dd480253710 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -25,7 +25,7 @@ struct ovl_lookup_data {
> >       bool stop;
> >       bool last;
> >       char *redirect;
> > -     bool metacopy;
> > +     int metacopy;
>
> Should this be called 'metacopy_size' now?

Honestly I don't know. That would change a lot of locations that still
use this as "essentially" a boolean (i.e. !=3D 0 means "has metacopy"),
and ity would make that code less compact. I guess this is up to Amir
and Miklos. Surely we could add a comment in the struct definition
though.

> > -             err =3D ovl_check_metacopy_xattr(OVL_FS(d->sb), &path);
> > +             err =3D ovl_check_metacopy_xattr(OVL_FS(d->sb), &path, NU=
LL);
> >               if (err < 0)
> >                       goto out_err;
>
> This part is confusing because variables named 'err' conventionally conta=
in only
> 0 or a negative errno value.  But this patch makes it possible for
> ovl_check_metacopy_xattr() to return a positive size.

It was already returning "negative, 0 or 1", so it's not fundamentally
changed. Again, this is not my code so I'd rather Amir and Miklos
decide such code style questions.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com


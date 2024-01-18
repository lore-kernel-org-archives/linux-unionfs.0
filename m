Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C39241E2
	for <linux-unionfs@vger.kernel.org>; Thu, 18 Jan 2024 11:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705577967; cv=none; b=A5MWxS5OR1AnHe6SZG3BI7PZKQg67LoLkndfH0eAfElOiHucEGKVdZIja0WCxtMPU/CZET1xL9rbbJGarRGMT+hYrwvQHLuw4tHhBYsL1PYkcGkBNCJqFks4Zzi3U8ku8hc4S331B7t9/CTLDFvTEZU6umGkGpxdIfvx0eGmcRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705577967; c=relaxed/simple;
	bh=99kVtTQGqgyKdKt5z1Snj70s9KpVAmJhM85T8r2CjFA=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding; b=cgNo+HCIol7olFKuKxm9js1Iiij6ooEBFcT2GiTEo31ykiEEcBrE12gT2tmhMPdbvBdUDGXnluPKNGRquDZwIz2xla58JVKzv0ltBbjiiDJVqpnWxhBLL9255bo/WlPRB6RHYBFIdvzlqoTflP0IntI09IN6tT6CvK/cmdTKvsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=dogkC0Km; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="dogkC0Km"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a2cea0563cbso933485066b.3
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Jan 2024 03:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1705577962; x=1706182762; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HNpGQogZ6nMvhPzDXLu2EM0aCKz/G7JiTMEfiSYUfUA=;
        b=dogkC0KmP8yKfpA6eZMjsrSeXTdQn8nq01Z7MwT3E+MUFN5Nd5ECDdRTx0jzhdMGtL
         gzxrc1PQwi07xs4f3VejW0qYPCX0kslRDNIE8Tm1+J/TESojJ55Htq3psBBFRkEXa80J
         iL+ZCHX6WBeHjHGBksTvhx2N36woBvb+R0FY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705577962; x=1706182762;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HNpGQogZ6nMvhPzDXLu2EM0aCKz/G7JiTMEfiSYUfUA=;
        b=ivtyvi5+t7nKMMzOAhna9aGS2unwHTUNIfSbquJK32ikptA4fLsFVowb9DEoacz2QR
         pHnVVD3qREBnENc8um3l2IGmTT45kSH2J7PMVIL3T1bBs26XpFvUVdu5N3U/qwB6D8kL
         vQwlbvC23oJAZKJYmZ7CbvrfxZwIqe+cmoPyzfw/mAuuvbYaxYbTvheuODhsmp7oxVzW
         nLYrFziTm2fx411Jy92biMW517JSsiMNj/6FEFyKZyMGs8hj96bHsarFv76GonpmeQtw
         UxWqA7riI4CRfdKOX6GAtORncsvDLVkIDePDJ3dqVu8kF//W80lMrufmpWadUFZX12WC
         f+/w==
X-Gm-Message-State: AOJu0YyNA/8GjtmNhe6R/jvRetRWlUcK6jo757Lo9qtHHG2FdG3yoaTM
	pfs5KjJpk3QafFD03xh1+NzU5HZPTbpDnOhSkUMC4S+wVZN5NU/T7mrftptdYF9IBnHSRkDjwDM
	gmJ4sFCAKVm9VTd20UecZP73XqyhPW/7eIkXWSg==
X-Google-Smtp-Source: AGHT+IGIAFfQAtQ1ZkWClSLiycVAkl7NbcKu86Xz6RojZM2XBh7VfzBIdj0OHoL28DxfRZD6Y2FGWLJVxORXsBi7cBk=
X-Received: by 2002:a17:906:5ac4:b0:a2e:cf45:5a10 with SMTP id
 x4-20020a1709065ac400b00a2ecf455a10mr441879ejs.141.1705577961322; Thu, 18 Jan
 2024 03:39:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240118104144.465158-1-mszeredi@redhat.com> <CAOQ4uxgB3qhqtTGsvgLQ6x4taZ4m-V0MD9rXJ_zacTPrCR+bow@mail.gmail.com>
In-Reply-To: <CAOQ4uxgB3qhqtTGsvgLQ6x4taZ4m-V0MD9rXJ_zacTPrCR+bow@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 18 Jan 2024 12:39:09 +0100
Message-ID: <CAJfpegvhWwmHXzo3dd5VYLrCjUhxAesNAha-dOB+PCP8M2rM2g@mail.gmail.com>
Subject: Re: [PATCH] ovl: require xwhiteout feature flag on layer roots
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	Alexander Larsson <alexl@redhat.com>, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Jan 2024 at 12:22, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Jan 18, 2024 at 12:41=E2=80=AFPM Miklos Szeredi <mszeredi@redhat.=
com> wrote:
> >
> > Add a check on each layer for the xwhiteout feature.  This prevents
> > unnecessary checking the overlay.whiteouts xattr when reading a
> > directory if this feature is not enabled, i.e. most of the time.
>
> Does it really have a significant cost or do you just not like the
> unneeded check?

It's probably insignificant.   But I don't know and it would be hard to pro=
ve.

> IIRC, we anyway check for ORIGIN xattr and IMPURE xattr on
> readdir.

We check those on lookup, not at readdir.  Might make sense to check
XWHITEOUTS at lookup regardless of this patch, just for consistency.

> > --- a/fs/overlayfs/overlayfs.h
> > +++ b/fs/overlayfs/overlayfs.h
> > @@ -51,6 +51,7 @@ enum ovl_xattr {
> >         OVL_XATTR_PROTATTR,
> >         OVL_XATTR_XWHITEOUT,
> >         OVL_XATTR_XWHITEOUTS,
> > +       OVL_XATTR_FEATURE_XWHITEOUT,
>
> Can we not add a new OVL_XATTR_FEATURE_XWHITEOUT xattr.
>
> Setting OVL_XATTR_XWHITEOUTS on directories with xwhiteouts is
> anyway the responsibility of the layer composer.
>
> Let's just require the layer composer to set OVL_XATTR_XWHITEOUTS
> on the layer root even if it does not have any immediate xwhiteout
> children as "layer may have xwhiteouts" indication. ok?

Okay.

> > @@ -1414,6 +1414,17 @@ int ovl_fill_super(struct super_block *sb, struc=
t fs_context *fc)
> >         if (err)
> >                 goto out_free_oe;
> >
> > +       for (i =3D 0; i < ofs->numlayer; i++) {
> > +               struct path path =3D { .mnt =3D layers[i].mnt };
> > +
> > +               if (path.mnt) {
> > +                       path.dentry =3D path.mnt->mnt_root;
> > +                       err =3D ovl_path_getxattr(ofs, &path, OVL_XATTR=
_FEATURE_XWHITEOUT, NULL, 0);
> > +                       if (err >=3D 0)
> > +                               layers[i].feature_xwhiteout =3D true;
>
>
> Any reason not to do this in ovl_get_layers() when adding the layer?

Well, ovl_get_layers() is called form ovl_get_lowerstack() implying
that it's part of the lower layer setup.

Otherwise I don't see why it could not be in ovl_get_layers().   Maybe
some renaming can help.

Thanks,
Miklos

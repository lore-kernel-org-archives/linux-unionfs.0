Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711DF3CF5A
	for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 13:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705929472; cv=none; b=FXuAcd9Dzgae4AOHmHTRtUJpGTDnbERZKFlu9mt33jDcEWdCaKo59n5GVxJ0+Ob0ly2ceiP7fe6CQSAuKRvPkv6BjYS4crFD/s+xT73bIZUult7uf53mKkQkQaOH52g9elAZBw2Z4BAsfTyQiQgCrYOCdYnqXF5qpv+nX2QfLW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705929472; c=relaxed/simple;
	bh=LMl/y/GPmj2bXVefr8mukXlglRjKmyV72rArezQbJvA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iInXmG8BoyD3I/W0NRcll2BE4yrUmMvgWGpZlZY8Tm+vNsl/n5Bh9GHBCNO+8nktd7j9HDLLNcrMBpMEmROgedK3E/Gf5nSAnYox2smy75W/IDLb81BjWk9akkF+Ia0yTdbH+27NZwEbrPn+ZXrjlHxxS/Ul5Y29Um+OTVIw9YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mt9AraxF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mt9AraxF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705929469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EwOe2ACQX5G6oSHXLQGVn96IRjliI/OBhEKhhY5AWng=;
	b=Mt9AraxFgLHaP0eXBIEQ/IlvjJ8YWEGLiP8Nuq5iXqrsxa9TMaltK2croT3PQ6Onx4u438
	iGZ5KscTUbOSGPNVhpiezLfRmPdp3+0gbaVhwIA16bjxJk4bgjMFpHxK3Zg9NEOpLfb0OW
	KgAFIeyg/rw4lviE8HLzwy+DYzMuQEs=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-oT_TgFBxMTSpn04m019q-g-1; Mon, 22 Jan 2024 08:17:47 -0500
X-MC-Unique: oT_TgFBxMTSpn04m019q-g-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ccbfa17001so21642321fa.2
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 05:17:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705929466; x=1706534266;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EwOe2ACQX5G6oSHXLQGVn96IRjliI/OBhEKhhY5AWng=;
        b=Bj02UN6+IKvPodCOcJfIZsY1ZY2BOoCsz0zYuYQXU9Hx6SDFBsdaS5iLzNDQJyQUqz
         /Rq66EEINpB3v5WwDimaH8BK7DoknyXvYLpIBvGcZTKenZinm4RKhU4zM5tVNTXyIHOx
         NaD2tRrKSCzjhZm3ovxXZSWESdL60Oen7MlmjzPy7l9FXERQDVlEbc1FeBIaM0XgZxKz
         YbKeR9daeCUWoxuYtFHZkmN4GJacyc4u9apSvt+FO6TzKphiQqJFQW4/6/WpYQ7HA0cd
         OzKtl3tpaJjdgNtIvK4Qd3pE8pVFX0Tes6VyTGplVbHTtQTzSD5F255XnLDsrDqKmQNZ
         J++w==
X-Gm-Message-State: AOJu0YzbOrbvC+30tWH/ikARV7jyTqw38ag2lwYV/Q3rsoZdfWFOG8DF
	UIMz/QfnUl3u9oHjBNn21d/cbL1/KQ1oNFasL50/7AiuoWZrf6Zx4IhK5MnFOPbHEZJlYRRJAfT
	czeO2R6ze3AM97IFeVwaRJdubX0wlIFNNJWRYAPRy8p5d2m19rzngit5oHQr86Wo=
X-Received: by 2002:a2e:86cf:0:b0:2cd:ee6d:a280 with SMTP id n15-20020a2e86cf000000b002cdee6da280mr1381736ljj.38.1705929466174;
        Mon, 22 Jan 2024 05:17:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEH0DFtweiBdS/4Ad+GNm+8ADph9d8FdPSR7RUB3KQMawCtnbsuXl23XBJgVu2au4+34CnmFA==
X-Received: by 2002:a2e:86cf:0:b0:2cd:ee6d:a280 with SMTP id n15-20020a2e86cf000000b002cdee6da280mr1381733ljj.38.1705929465864;
        Mon, 22 Jan 2024 05:17:45 -0800 (PST)
Received: from [172.31.0.10] (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.gmail.com with ESMTPSA id b10-20020a2e848a000000b002cdc1beb671sm2464324ljh.12.2024.01.22.05.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 05:17:45 -0800 (PST)
Message-ID: <8f8f35ec4ec03d747fedb245ce067926c398a43c.camel@redhat.com>
Subject: Re: [PATCH v3] ovl: mark xwhiteouts directory with
 overlay.opaque='x'
From: Alexander Larsson <alexl@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Date: Mon, 22 Jan 2024 14:17:44 +0100
In-Reply-To: <CAOQ4uxhu_p1OGh8aFEq6nEpWMzFjyXOvrirhYc-apAzc6Phq6g@mail.gmail.com>
References: <20240121150532.313567-1-amir73il@gmail.com>
	 <3679657b0589ee31d09fb9db140fe57121989a69.camel@redhat.com>
	 <CAOQ4uxh5x_-1j8HViCutVkghA1Uh-va+kJshCuvB+ep7WjmOFg@mail.gmail.com>
	 <e7e1a2268a696af96d8b7f14cbb20edcee032dfb.camel@redhat.com>
	 <CAOQ4uxhu_p1OGh8aFEq6nEpWMzFjyXOvrirhYc-apAzc6Phq6g@mail.gmail.com>
Autocrypt: addr=alexl@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 (3.50.3-1.fc39) 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-01-22 at 14:52 +0200, Amir Goldstein wrote:
> On Mon, Jan 22, 2024 at 1:52=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om>
> wrote:
> >=20
> > On Mon, 2024-01-22 at 13:09 +0200, Amir Goldstein wrote:
> > > On Mon, Jan 22, 2024 at 12:14=E2=80=AFPM Alexander Larsson
> > > <alexl@redhat.com>
> > > wrote:
> > > >=20
> > > > On Sun, 2024-01-21 at 17:05 +0200, Amir Goldstein wrote:
> > > > > An opaque directory cannot have xwhiteouts, so instead of
> > > > > marking
> > > > > an
> > > > > xwhiteouts directory with a new xattr, overload
> > > > > overlay.opaque
> > > > > xattr
> > > > > for marking both opaque dir ('y') and xwhiteouts dir ('x').
> > > > >=20
> > > > > This is more efficient as the overlay.opaque xattr is checked
> > > > > during
> > > > > lookup of directory anyway.
> > > > >=20
> > > > > This also prevents unnecessary checking the xattr when
> > > > > reading a
> > > > > directory without xwhiteouts, i.e. most of the time.
> > > > >=20
> > > > > Note that the xwhiteouts marker is not checked on the upper
> > > > > layer
> > > > > and
> > > > > on the last layer in lowerstack, where xwhiteouts are not
> > > > > expected.
> > > > >=20
> > > > > Fixes: bc8df7a3dc03 ("ovl: Add an alternative type of
> > > > > whiteout")
> > > > > Cc: <stable@vger.kernel.org> # v6.7
> > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > ---
> > > > >=20
> > > > > Miklos,
> > > > >=20
> > > > > Alex has reported a problem with your suggested approach of
> > > > > requiring
> > > > > xwhiteouts xattr on layers root dir [1].
> > > > >=20
> > > > > Following counter proposal, amortizes the cost of checking
> > > > > opaque
> > > > > xattr
> > > > > on directories during lookup to also check for xwhiteouts.
> > > > >=20
> > > > > This change requires the following change to test
> > > > > overlay/084:
> > > > >=20
> > > > > --- a/tests/overlay/084
> > > > > +++ b/tests/overlay/084
> > > > > @@ -115,7 +115,8 @@ do_test_xwhiteout()
> > > > >=20
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mkdir -p $basedir/lowe=
r $basedir/upper $basedir/work
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 touch $basedir/lower/r=
egular $basedir/lower/hidden
> > > > > $basedir/upper/hidden
> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 setfattr -n $prefix.overlay=
.whiteouts -v "y"
> > > > > $basedir/upper
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 # overlay.opaque=3D"x" mean=
s directory has xwhiteout
> > > > > children
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 setfattr -n $prefix.overlay=
.opaque -v "x"
> > > > > $basedir/upper
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 setfattr -n $prefix.ov=
erlay.whiteout -v "y"
> > > > > $basedir/upper/hidden
> > > > >=20
> > > > >=20
> > > > > Alex,
> > > > >=20
> > > > > Please let us know if this change is acceptable for
> > > > > composefs.
> > > >=20
> > > > Yes, this looks very good to me. (Minor comments below)
> > > > I'll do some testing on this.
> > > >=20
> > >=20
> > > Excellent, I'll be expecting your RVB/Tested-by.
> > > >=20
> >=20
> > Yes
> > Reviewed-by: Alexander Larsson <alexl@redhat.com>
> > Tested-by: Alexander Larsson <alexl@redhat.com>
> >=20
> > for the patch in the ovl-fixes branch.
>=20
> Thanks. pushed.
>=20
> >=20
> > I tested it manually, and with xfstest (with change), and also
> > with this composefs change:
> >=20
> > https://github.com/alexlarsson/composefs/tree/new-format-version
> >=20
> > I created a lowerdir with a regular whiteout in, and after running
> > that
> > though the changed mkcomposefs I was able to mount the composefs
> > image,
> > and then mount the lowerdirs from the composefs mount, and they
> > correctly handled the whiteout both when mounted normally and with
> > userxattr.
> >=20
>=20
> I noticed you comment in composefs:
>=20
> =C2=A0* 1 - Mark xwhitouts using the new opaque=3Dx format as needed by
> Linux 6.8
>=20
> Note that this "fix" is aimed to be backported to v6.7.y, so there is
> no kernel
> version that is expected to retain support for the old format.

Yes, but the composefs format needs to be bitwise reproducible, and
this change in the image will cause a different digest for the produced
image, so we can't just change what we generate, it has to be opt in to
users and able to reproduce previous versions.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D-=3D-=3D
 Alexander Larsson                                            Red Hat,
Inc=20
       alexl@redhat.com            alexander.larsson@gmail.com=20
He's an uncontrollable zombie senator gone bad. She's a cosmopolitan=20
hypochondriac doctor from Mars. They fight crime!=20


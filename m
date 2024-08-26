Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B911E519;
	Mon, 26 Aug 2024 13:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724677418; cv=none; b=t9LePRpoWZnWBIRJlslAmKMFTs+BEw4NL71ExF85jaHvhkjGhSWBJy0xtqQeMgshl4dX6Rqozt6PXGLqGDgZx8qwR1c5tDTNIKUd1SKt7L5CUJGmOB1ICiLegXDol0J3UqCeSPR4XLDUMOtCo7pr7axsgmsedJhPIcKN8zHYnP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724677418; c=relaxed/simple;
	bh=EXpi6K9uXt7ma/n9zbVeegQjq9nYe85iBidPk9A8j1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sSCQfLHvaSxu4hUuV/M3Hw1OdrrYrUK4QyUjUjfpnOpRKZBQz8sE5L7FhwQ3S2z4hxluVj3R7fEagsVuW9JXRIGKOyiG3OzA+r50IKO96D+skL/Z6Jd5j8ro2/lXu5vODXMt+wrU3DS8cuvQvKNcex5Sncy701xLHoWO5btA4Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BYaXbeci; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BYaXbeci"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7a1df0a9281so265620285a.1;
        Mon, 26 Aug 2024 06:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724677416; x=1725282216; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wo8k4P607AhHv2HXwuEF6+EBlZF6/PH1+ohX5pU9hag=;
        b=BYaXbeciDZlKhB4MYcBIm6gNbfuZ7eMV+3GfvphbiqblljXWuwFBs+y8vkhdMvqSQ8
         ErMcv7o3u3SvWmYTkWDJ8Hjxd+SX8OZ3GKnriivZ/kpKSZN/9c6cEIrhGTjOlbRK+Xmd
         APA4fpatE/Tg5PvgRMbYwqIocTc+Jf6dZO995ZauevKX8YyJacjm6LDQ3009Uf3AM+li
         nlhMtCXcihxf/cLIu9BeBJbGdAZs7/pxCify2BBQa5fNbLXQL3Umnr204LK8/dHIXhf0
         7TUdwep+JEYd4UACGUwujvKiHRJByzqADdQXSYqL9uhl6yE9ZVRvL4g/roZpAB5AYkOe
         X6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724677416; x=1725282216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wo8k4P607AhHv2HXwuEF6+EBlZF6/PH1+ohX5pU9hag=;
        b=QjiY0DlcsTvWE8XN4JyPHm/30vUvhmKp4SceQsd29LZZjIsJTLCibe8lC5sAFAZPSM
         w9+TTYZOk2OlbbKrKB/8Zp6uRvFkrfwcpoxw0e8mHla54NhZf7qyExwUgAsGhsXouVpQ
         dH8v9WDgKAP7jxcF2ASjRKjnpt/gFXDk85zjxIy7TNsd23gdnStBb74qO01UCGhGKlw9
         tj4XmmdHvFLdDdhCohwub8P9TV+UYnaJrziX/q32H3fBYjJOGlVq8Ym9S3D1pZi/mhqO
         L2AgKbqoC8oCI/XpnLAoN7B0Xfbw5R7yFAjmUCyaFXKYOslqWCwZ+7g65VzgX9o7yaPd
         7A2A==
X-Forwarded-Encrypted: i=1; AJvYcCVC42emDKS4sykEHgYooxIexH9wSuzAW72AG8SKc2UYVq7JOgNEh41mO1ygIxHuz0ZpiZdFH7qfxZHfOY4nng==@vger.kernel.org, AJvYcCWdDKWYFhX8RKC6FSgsvV1OK7fiFFYGmjQzu/UM6tDhCR/UgzGMQyDaYUyCBVaEtl4vkIFBsUfrrjHZghc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWRqAUY49GsR0vbJKUDNdJ1nPNAqTirNCgxlIciFPNMIg9jZ8J
	CXGf71t6RGd+l9liMfiWnluLd9DpZuXJJ3+8U0+xBu6RpXxXxJqemdpSpxherjotn/OpvOy5haS
	+VlDFrYSf/NC0tEeVCFEhc1ibn2/jza69Oas=
X-Google-Smtp-Source: AGHT+IHvYGlEOqBIQ3+PllW8j7UyCLFssgKZHidNtD64NCCLvHPxO6RliZMd7/8aZe4bhGpB3DTReDi4JZqYKv9Zkds=
X-Received: by 2002:a05:620a:3724:b0:79d:69b5:aaf7 with SMTP id
 af79cd13be357-7a6896d184bmr1437103985a.11.1724677415627; Mon, 26 Aug 2024
 06:03:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240722101443.10768-1-feilv@asrmicro.com> <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
 <CAOQ4uxgbbadOC_LCYRk-muFKYH3QNVnD+ZEH+si-V1i3En66Bw@mail.gmail.com>
 <CAOQ4uxiDokEQ0ZET+adP_CpvvTCRRLTcVb9d5mYAmM1q7y2PnQ@mail.gmail.com> <5be64ae3b75e413fa47c9ecb2c4a359a@exch01.asrmicro.com>
In-Reply-To: <5be64ae3b75e413fa47c9ecb2c4a359a@exch01.asrmicro.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 26 Aug 2024 15:03:24 +0200
Message-ID: <CAOQ4uxi-9=g6B=8P71gDC3Po1oPiqc0jw8hsEeHWurkgiMRjDw@mail.gmail.com>
Subject: Re: [PATCH V2] ovl: fsync after metadata copy-up via mount option "fsync=strict"
To: =?UTF-8?B?THYgRmVp77yI5ZCV6aOe77yJ?= <feilv@asrmicro.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, 
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	=?UTF-8?B?WHUgTGlhbmdode+8iOW+kOiJr+iZju+8iQ==?= <lianghuxu@asrmicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 26, 2024 at 8:56=E2=80=AFAM Lv Fei=EF=BC=88=E5=90=95=E9=A3=9E=
=EF=BC=89 <feilv@asrmicro.com> wrote:
>
>
>
> > =E5=8F=91=E4=BB=B6=E4=BA=BA: Amir Goldstein [mailto:amir73il@gmail.com]
> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2024=E5=B9=B48=E6=9C=8823=E6=97=
=A5 19:43
> > =E6=94=B6=E4=BB=B6=E4=BA=BA: Lv Fei=EF=BC=88=E5=90=95=E9=A3=9E=EF=BC=89=
 <feilv@asrmicro.com>
> > =E6=8A=84=E9=80=81: miklos@szeredi.hu; linux-unionfs@vger.kernel.org; l=
inux-kernel@vger.kernel.org; Xu Lianghu=EF=BC=88=E5=BE=90=E8=89=AF=E8=99=8E=
=EF=BC=89 <lianghuxu@asrmicro.> com>
> > =E4=B8=BB=E9=A2=98: Re: [PATCH V2] ovl: fsync after metadata copy-up vi=
a mount option "fsync=3Dstrict"
> >
> > On Fri, Aug 23, 2024 at 11:51=E2=80=AFAM Amir Goldstein <amir73il@gmail=
.com> wrote:
> > >
> > > On Mon, Jul 22, 2024 at 3:56=E2=80=AFPM Amir Goldstein <amir73il@gmai=
l.com> wrote:
> > > >
> > > > On Mon, Jul 22, 2024 at 1:14=E2=80=AFPM Fei Lv <feilv@asrmicro.com>=
 wrote:
> > > > >
> > > > > For upper filesystem which does not enforce ordering on storing o=
f
> > > > > metadata changes(e.g. ubifs), when overlayfs file is modified for
> > > > > the first time, copy up will create a copy of the lower file and
> > > > > its parent directories in the upper layer. Permission lost of the
> > > > > new upper parent directory was observed during power-cut stress t=
est.
> > > > >
> > > > > Fix by adding new mount opion "fsync=3Dstrict", make sure
>
> There is a typo here, "opion" should be "option", please help correct bef=
ore merge.
>

No problem, but I am still waiting for Miklos to comment on this option.

> > > > > data/metadata of copied up directory written to disk before
> > > > > renaming from tmp to final destination.
> > > > >
> > > > > Signed-off-by: Fei Lv <feilv@asrmicro.com>
> > > >
> > > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > > >
> > > > but I'd also like to wait for an ACK from Miklos on this feature.
> > > >
> > > > As for timing, we are in the middle of the merge window for
> > > > 6.11-rc1, so we have some time before this can be considered for 6.=
12.
> > > > I will be on vacation for most of this development cycle, so either
> > > > Miklos will be able to queue it for 6.12 or I may be able to do nea=
r
> > > > the end of the 6.11 cycle.
> > > >
> > >
> > > Miklos,
> > >
> > > Please let me know what you think of this approach to handle ubifs up=
per.
> > > If you like it, I can queue this up for v6.12.
> > >
> > > Thanks,
> > > Amir.
> > >
> > > >
> > > > > ---
> > > > > V1 -> V2:
> > > > >  1. change open flags from "O_LARGEFILE | O_WRONLY" to "O_RDONLY"=
.
> > > > >  2. change mount option to "fsync=3Dordered/strict/volatile".
> > > > >  3. ovl_should_sync_strict() implies ovl_should_sync().
> > > > >  4. remove redundant ovl_should_sync_strict from ovl_copy_up_meta=
_inode_data.
> > > > >  5. update commit log.
> > > > >  6. update documentation overlayfs.rst.
> > > > >
> >
> > Hi Fei,
> >
> > I started to test this patch and it occured to me that we have no test =
coverage for the "volatile" feature.
> >
> > Filesystem durability tests are not easy to write and I know that you t=
ested your own use case, so I will not ask you to write a regression test a=
s a condition for merge, but if you are willing to help, it would be very n=
ice to add this test coverage.
>
> OK, I can have a try, need some time to study test suite. This is a new t=
hing for me.
>

Whenever you can.

> >
> > There is already one overlayfs test in fstests (overlay/078) which test=
s behavior of overlayfs copy up during power cut (a.k.a shutdown).
>
> Do you mean overlay/078 in kernel/git/brauner/xfstests-dev.git ?
>

Yes overlay/078, but upstream repo is
git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

> >
> > One thing that I do request is that you confirm that you tested that th=
e legacy "volatile" mount option still works as before.
>
> Yes, I tested basic function of "volatile" mount option with this patch.
>

Thanks,
Amir.

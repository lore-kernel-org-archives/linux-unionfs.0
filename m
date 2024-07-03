Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09EF1DA319
	for <linux-unionfs@vger.kernel.org>; Wed,  3 Jul 2024 15:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720019900; cv=none; b=kC1xcZoEdDcAnE7Sz/n+nzsp9YGuN3slEpIcxC3UDSlCu6vTCrmw8NPqs+lKvHhHdUoHqhSd+HNHuvAbptxTUCXWWkX2jYU3yTiIuvcQTYZCkIpaWOhIJ7HUiDeiiy0icqLHcATg0wN87/L+vRHkvgVXPj/Wvu0pTl5JGYChv44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720019900; c=relaxed/simple;
	bh=DqSYifaLKzq8YaGW+o7u6gYlJKM9hsb1CYRGR/QJJbM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Go2Dhfhg4cB/IZD6R460ERT/LfG+jIJuDuqIOQYhCmRVn4Cw3chDmp+xf88X+tuiKYeQCM3BcQUvEMvvFaNiBJnesiJ+eSXibgl+w6bS24wWY9+kuLPwyofzLYRExf+kO3M0Q/1DsmABpTYLlAkeOKlW3t9GLSCWW8IyrRGwGhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TcefQYVJ; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TcefQYVJ"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7021dffc628so1418085a34.2
        for <linux-unionfs@vger.kernel.org>; Wed, 03 Jul 2024 08:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720019898; x=1720624698; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kSyQEXE5yC3tGpfM28sPkjgZNzMfbOVegr6j7fTy7c=;
        b=TcefQYVJeGLbqzwwf/XAh4Y/C0//MEs6QrGAhAknFcHvLg10hJ0i+CcdCkFYDwlqDb
         xMt1baOVn0stOgBrlCLRPbIARjCyJ9g0F8MsBaEEcLwd7WkKTNvISDkRABbvMbPoKsBm
         21q/XHf0ggSExVSthmS5cXe3egzuzt9KXS2R11hSBFXtsGrTDbp9ZPiqoaia0mmY8H5z
         ECu9KkiR6zxhcrWwP2tc34PrCZ600JRyKAGO2+uyU2rbQMeC24vH0fp0/GyWX7pvTwcy
         uG1HHLgBMstK8xOrel82WMnuzbUg6uUHuYABqS7KlydpWUdap8KHLNLvtl7xdKPcCrhh
         pCyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720019898; x=1720624698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4kSyQEXE5yC3tGpfM28sPkjgZNzMfbOVegr6j7fTy7c=;
        b=p1a/C9LAB6/LqyQUwKufrQlntQ/KGbHyGDesUsjL0aRhWDx8K6dFzoNqrAIWmNVNJo
         xajWbKolYCGey3aeuV3SyXd0WZqUOL+/3fOzQM1vbgBWc4uVDlHgAGkBKuER0/oOgHVu
         B9sw9ULWjVslZNmpGXLMPb4lnUdjpihc2ULfVoINILKmCvfS+m21GoY/NnPoYX8Vq6tM
         IrAg4d2sFxjEZJwp+4yb5uvILs+rRMdA7+but6wnQ80suWO6aTSILUlqOqsRYJ0YNJsQ
         YPlEthXSpZ/GoovyiZGaH/liKHwIlQPkbPinjKnh+v7md0q4mxOw6aWZ+E4xxr/Yd4s5
         rpQg==
X-Forwarded-Encrypted: i=1; AJvYcCWo+f/1zLSJlKAYTV/eB3Kv8x/YvNF06OPUNooHsIg3+U+pSt2ojWCJf4F+uM10l3fZ3NrIgaDy2Z3zG5hU6jfqRWZODuLV3gRqTPRfQQ==
X-Gm-Message-State: AOJu0YyVXmWWCx8OTEqtbGBLfPlFwM4n+6AMgMGpfI9q88VsRd9x/r6W
	VLupyOoFnfikwOhob1GvDg0A/bbXYlfMUINwMu7pF1h86gItuyvTnamoPYcLgVrv+80oOTCG4BK
	MCUpaFv8ImEA8JWoi22ejPVZnQ+s=
X-Google-Smtp-Source: AGHT+IEJ7fSFg5sIR63H4X32f1VgfOcavprluC1XXH3oF/nHRFohuJV8cOoHojTQHUQS58pWniBFQ7fbI4AICLjSrxc=
X-Received: by 2002:a05:6830:1d93:b0:702:777:c413 with SMTP id
 46e09a7af769-7020777c56cmr15101971a34.0.1720019897766; Wed, 03 Jul 2024
 08:18:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240703044631.4089465-1-chengzhihao1@huawei.com>
 <CAOQ4uxg8YvWYobbx5ztjkw6ZnUVgv1JDWFYq71HQ5O22=jYTKw@mail.gmail.com> <20240703-maulwurf-beinverletzungen-dfb0ff663d78@brauner>
In-Reply-To: <20240703-maulwurf-beinverletzungen-dfb0ff663d78@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 3 Jul 2024 18:18:06 +0300
Message-ID: <CAOQ4uxjhc2f2D68emH7mdBBa4Cut7R7AjRASkDS9GQtr3MPEHQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix wrong lowerdir number check for parameter Opt_lowerdir
To: Christian Brauner <brauner@kernel.org>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>, miklos@szeredi.hu, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 3, 2024 at 4:48=E2=80=AFPM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> On Wed, Jul 03, 2024 at 02:35:49PM GMT, Amir Goldstein wrote:
> > On Wed, Jul 3, 2024 at 7:48=E2=80=AFAM Zhihao Cheng <chengzhihao1@huawe=
i.com> wrote:
> > >
> > > The max count of lowerdir is OVL_MAX_STACK[500], which is broken by
> > > commit 37f32f526438("ovl: fix memory leak in ovl_parse_param()") for
> > > parameter Opt_lowerdir. Since commit 819829f0319a("ovl: refactor laye=
r
> > > parsing helpers") and commit 24e16e385f22("ovl: add support for
> > > appending lowerdirs one by one") added check ovl_mount_dir_check() in
> > > function ovl_parse_param_lowerdir(), the 'ctx->nr' should be smaller
> > > than OVL_MAX_STACK, after commit 37f32f526438("ovl: fix memory leak i=
n
> > > ovl_parse_param()") is applied, the 'ctx->nr' is updated before the
> > > check ovl_mount_dir_check(), which leads the max count of lowerdir
> > > to become 499 for parameter Opt_lowerdir.
> > > Fix it by updating 'ctx->nr' after the check ovl_mount_dir_check().
> > >
> > > Fixes: 37f32f526438 ("ovl: fix memory leak in ovl_parse_param()")
> > > Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> > > ---
> > >  fs/overlayfs/params.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> > > index 4860fcc4611b..0d8c456aa8fa 100644
> > > --- a/fs/overlayfs/params.c
> > > +++ b/fs/overlayfs/params.c
> > > @@ -486,7 +486,6 @@ static int ovl_parse_param_lowerdir(const char *n=
ame, struct fs_context *fc)
> > >         iter =3D dup;
> > >         l =3D ctx->lower;
> > >         for (nr =3D 0; nr < nr_lower; nr++, l++) {
> > > -               ctx->nr++;
> > >                 memset(l, 0, sizeof(*l));
> > >
> > >                 err =3D ovl_mount_dir(iter, &l->path);
> > > @@ -494,9 +493,12 @@ static int ovl_parse_param_lowerdir(const char *=
name, struct fs_context *fc)
> > >                         goto out_put;
> > >
> > >                 err =3D ovl_mount_dir_check(fc, &l->path, Opt_lowerdi=
r, iter, false);
> > > -               if (err)
> > > +               if (err) {
> > > +                       path_put(&l->path);
> > >                         goto out_put;
> > > +               }
> > >
> > > +               ctx->nr++;
> > >                 err =3D -ENOMEM;
> > >                 l->name =3D kstrdup(iter, GFP_KERNEL_ACCOUNT);
> > >                 if (!l->name)
> > > --
> > > 2.39.2
> > >
> >
> > This fix looks correct, but it is not pretty IMO.
> > The cleanup on error is much cleaner in ovl_parse_layer() -> ovl_add_la=
yer()
> > I wonder if we can reuse some of those helpers instead of the current c=
ode.
> >
> > Christian, what do you think?
>
> Yeah, sounds good. Something like the completely untested below.
> Feel free to reuse in whatever form.

This looks much nicer!
I think you unintentionally dropped incrementing of ctx->nr_data
for the notorious case of ::<lowerdatadir>.

Zhihao,

Please make sure to run the fstests overlay test for lowerdatadirs
overlay/079 overlay/085 overlay/086

Thanks,
Amir.

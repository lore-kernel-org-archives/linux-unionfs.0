Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2550643D511
	for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 12:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779108517; cv=none; b=nFSQOLW249e1b1L+XVU8EzuFoCx0R8OiCSeL1b1Y0PnzwpjWGOwLY0VOTWMA7DHD4oSrOcZ+2y0tmWehFAjlSzGr3uLIbDm5GDCS9lqweprLDr8gI44ZkgP2I0wVaqQ4BXC1JwOHZ57He8XMYtZM2HZdbjCKuSC3x0ZLRdNmZJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779108517; c=relaxed/simple;
	bh=ir9awwZE8mojdaXk33IApda6a3sA6BIp9dfWav123FI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uIKt9RlJgYP2GuxZDPWU/PPY4b2DttAhPg3XCfV3nuXeiEnV5y3vMEXWX/Tbba7HWeSmBPoS6fFS91MsPgSttJKnMZBvVVYonOiRcXpT2rGEEpiD5U1VkFIaz5mhMAW4rO72dIPaKS8z2BYGzKSEiQy3jA27rQTA3Wl5DjoyAKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LzTo3F/m; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LzTo3F/m"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-44e1ebb3122so1265520f8f.2
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 05:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779108514; x=1779713314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ex8tnMi3tAlmxYwkM3DQvhatICWsapujzOUrgVSrXo0=;
        b=LzTo3F/m2CgHqSzZ5lU0iUvsXsadJ4+azksDgNzEwn9u8hgsM1Pr/AduX7J8cBgOv7
         sdOpsfo6VLz81fRhq062yCvjuYr9LXg43v3HL3G/d9kMyxZewWYnUxn94SZQPlG6rJGQ
         41omWNJ9vD/8lSh2Zwyl/qT9H7wnSBa+Bq+Lonjqwf9AMMXPL0X51vDuFk5gldKdk7Od
         cx3IduBHiLj8XMWPD30Bl2hSTbjnXP1ESANatm/PNN+SmNbWlFi3Aq6wcBurfg9jfVgz
         Zntnw6oY6KpknKtUpG2jRRg2+SSsim1ZMvfMBBc9b+2YiPA7gVLTLyJIGRf/e6p02wZZ
         ViHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779108514; x=1779713314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ex8tnMi3tAlmxYwkM3DQvhatICWsapujzOUrgVSrXo0=;
        b=H0SRzpTLNDE1Bdprk/jWkPWzmhmZyb3H6X/B3XLB38t1Wqgq9CMHxBrXuq4cDuy5HN
         6rBIuGJVkTC79a3yw6JG2WAv8M/IXv1hAXCc0z3/xvXV2JjOBa8o2maQK2SgljN5/gKd
         QXwXETFcLXI5jGm3hcUNpJ9DZ2tsXk0VSQCDGSWtcBXlYRgKtnaW8MLjtZ7ClO0rzHjY
         NkIt5zk2PppBApRHJ5TS2+od3iP1RozOksjFJctnXXCW/jri0X3O48D36hcFYm1suPaK
         rKyPVKEJnyWY2VGWc3hp2KJkXnW6NEyZfGcyG2Vg+N3E7fJkmn9er2mDH4iilDx9dQdO
         HOvA==
X-Forwarded-Encrypted: i=1; AFNElJ+DMPQj2lr82MF3oJfv83/bVCukqi/d1REHl0mOCvNKl920YmENGwW4y1J0BpEjhHy7z9bU6yo2jH8QMKGZ@vger.kernel.org
X-Gm-Message-State: AOJu0YxKCTbCIChzKX0RJnFoAWx2vNkOHkofRMCW4v2ijtumltUUExGf
	ergdt07w+WbueeNS8fC4YvtfKyVZ+jOhbqQsjwMmjBbY62fVslro7rKb
X-Gm-Gg: Acq92OEVhMa8Al9GMaoEoJNnECvlXA1QBSWkQjswrFKw/3A0kwIktfug4YswNoUrgVd
	kU5zU3Bt1XMKeHTs0r3tey6ZBXxfpGhxQ3KOeJ0Vz7dCypE0DS86aXe1j68Nks6UVR36KGhhrhK
	itp2a191blzWqSTyNDOgPqeEqbgD1fadN3GCh+A7oKB71P0d+oyOR4uLMVLXmXtBCWQDTgwqdfC
	/MUp3oAdIdkKJInfQbh9/TTLj++vhx0QIq4D5JQfWJyViNGRZwONVHxY8vzWrFnjLCTHMw9SBMn
	gYp8wpcUZWF4h6oqiKOuSsO3s1F3d+7qWCkkE6BB6ZLcSGh/+o3UAwqStd3GJNogtb/89CfxAph
	Tp+yL4XhFT6rkgLjbqoeDn9i/UzTvQJ9xGoAZVNPgliajFlDXcpOqNh4eSVDfykiDlLpbMpP4XL
	n93NyWOhXQ9SdxMIWj81tYam8556ECp/VdJRtfVIKZGH6gOoXGwdi+hAdb6LfQSZwOdkmVghI0V
	QQ=
X-Received: by 2002:a05:6000:40df:b0:45d:b14b:2409 with SMTP id ffacd0b85a97d-45e5c35dd7bmr23470665f8f.2.1779108514308;
        Mon, 18 May 2026 05:48:34 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ed30110sm40744268f8f.13.2026.05.18.05.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 05:48:33 -0700 (PDT)
Date: Mon, 18 May 2026 13:48:32 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Rasmus Villemoes <ravi@prevas.dk>, Miklos Szeredi <miklos@szeredi.hu>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Al Viro
 <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>,
 Nirmoy Das <nirmoyd@nvidia.com>, linux-unionfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
Message-ID: <20260518134832.69853809@pumpkin>
In-Reply-To: <CAOQ4uxj0sgB5B+1gzzq8fPuAPJxU=TfXMUaJtjB6vdfXUSOuqQ@mail.gmail.com>
References: <20260514200129.94862-1-amir73il@gmail.com>
	<20260515193010.056ef472@pumpkin>
	<CAOQ4uxjDeF3uDe=OTVZ3fK65dF148FRUvPx5fOqZpoFuGUsmJQ@mail.gmail.com>
	<20260516094242.77d20c92@pumpkin>
	<CAOQ4uxjX=C6WZvW1DdJ13tJj-XBWVxgE2Q9vVvHoYqiOhqW0wQ@mail.gmail.com>
	<87se7pdr7a.fsf@prevas.dk>
	<CAOQ4uxj0sgB5B+1gzzq8fPuAPJxU=TfXMUaJtjB6vdfXUSOuqQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 18 May 2026 11:52:06 +0200
Amir Goldstein <amir73il@gmail.com> wrote:

> On Mon, May 18, 2026 at 11:04=E2=80=AFAM Rasmus Villemoes <ravi@prevas.dk=
> wrote:
> >
> > On Sat, May 16 2026, Amir Goldstein <amir73il@gmail.com> wrote:
> > =20
> > > On Sat, May 16, 2026 at 10:42=E2=80=AFAM David Laight
> > > <david.laight.linux@gmail.com> wrote: =20
> > >>
> > >> On Fri, 15 May 2026 21:26:04 +0200
> > >> Amir Goldstein <amir73il@gmail.com> wrote:
> > >> =20
> > >> > On Fri, May 15, 2026 at 8:30=E2=80=AFPM David Laight
> > >> > <david.laight.linux@gmail.com> wrote: =20
> > >> > >
> > >> > > On Thu, 14 May 2026 22:01:29 +0200
> > >> > > Amir Goldstein <amir73il@gmail.com> wrote:
> > >> > > =20
> > >> ... =20
> > >> > >
> > >> > > The object code bloat would be noticeable if this were used ever=
ywhere.
> > >> > > But you could make it a bit simpler:
> > >> > >         if (__builtin_constant_p(__e))
> > >> > >                 BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));
> > >> > >         else if WARN_ON(__e && !IS_ERR_VALUE(__e))
> > >> > >                 __e =3D -MAX_ERRNO; // Or maybe -EINVAL to stop =
and other boundary errors
> > >> > >         (void *)__e; =20
> > >> >
> > >> > Yeh that's nicer thanks. =20
> > >>
> > >> Actually this might be better still (or just more succinct):
> > >>         void *__e =3D (void *)error;
> > >>         BUILD_BUG_ON(!statically_true(IS_ERR_OR_NULL(__e)); =20
> > >
> > > This condition is wrong but also my compiler does not evaluate
> > > __builtin_constant_p(IS_ERR_OR_NULL(__e)) as true.
> > >
> > > This works
> > > BUILD_BUG_ON(statically_true(!IS_ERR_VALUE(__e)));
> > >
> > > I think it is enough to statically assert on ERR_PTR(EINVAL)
> > > and no need to bother with ERR_PTR(0)
> > > =20
> > >>         if (WARN_ON(!IS_ERR_OR_NULL(__e))
> > >>                 __e =3D (void *)-EINVAL; =20
> > >
> > > Oh, anything but EINVAL please - the most overloaded error value
> > > My choice of meaningful error value would be EFAULT =20
> >
> > Could we have a dedicated "EBUG" that can be used to indicate "there's a
> > bug somewhere in the kernel, we can handle it somewhat gracefully here
> > by returning an error instead of BUG(). You can't do anything about it
> > but report that you got -EBUG from $this_syscall", instead of
> > overloading EIO, EFAULT, EINVAL or whatnot. Internally, EBUG could be a
> > macro that did ({ WARN_ONCE(); -__EBUG; }) or something, so there would
> > automatically be bread crumbs in dmesg if it is ever hit. =20
>=20
> How exactly would you use this EBUG() to write the graceful handling?
> A bit of overengineering if you ask me.
>=20
> >
> > Userspace code could also benefit from having EBUG to indicate that some
> > internal inconsistency has been detected. =20
>=20
> So what about
>=20
> #define EBUG MAX_ERRNO
>=20
> as per my suggested patch.

Your are relying on there being no 'off-by-one' errors.
They happen...

-- David

>=20
> Thanks,
> Amir.
>=20


Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F7427979A
	for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 14:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115910; cv=none; b=Cijfb+a5HOLdzSPsP9spJ4dPjsbG6VvklQGA6OblvGlYGhKPFEFMX4T2y/lwCKsQ434hDxx5cRaexeVJto9UiTSB26E3cFU202il0bmHx6Nnzafl0QnntWRb26U9XX0jJCOrCXpv5j5Q6qgsHA6GsyPla4KOgTgOPJYlflUHxa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115910; c=relaxed/simple;
	bh=8YhRvGNtrOOwICxF1Gzv/WsXSxkHqfYNm1UG+B0jt08=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=upNp/c+3TwtOYtUybuyZ0ChbDGa0ObrHfC0avmctNX4Exq2YM0bBUfnkOVRmKNxam7xYHQ4aWuW51Z77GvJ9E6SHCg9rV5In84X28q8nPO+rS+KDt2WnGwi/4XL3FQtp8P5s0YuPF5yl+LAPQx+E/nTB+WayFqKWbbPnfNv6t58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FWobbnmN; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FWobbnmN"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4890d945eb4so18679075e9.0
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 07:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779115907; x=1779720707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gBS8wbHwX/vB9UcM7E4Dc7DuA8qjN/WDE+nHyY7z+Qk=;
        b=FWobbnmNvGY0/mT28uA3BlWixHVUvaVcr/trGD5CAg/3qEQxfDtjIj8MPzx0WDOzNn
         tGDgGZ44ryuftvezh7jHpFJ9OdxSEMrnrV40v8gEORM7YUBN0KaYDJB5GqKei9LHxMLs
         Aar1mPbBO+6irIubvKA0T9TC0zV1EOfnw4vYAH5QfILH5PSl0VY0PSp4s3EjNmnqhpzD
         a/xM8C2cWOo8zi6rawrQ0yTk+9KTYc1CQZIf1IrXK6uXcSRzFpqVsV/ozDg6ss/qeEVh
         wFxM3xQOFPytz349n4r/o7HHZkxiNTBaIlURSqklHmvXqzxNWMQVrJmiGwHQxsiWg4Bf
         RQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779115907; x=1779720707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gBS8wbHwX/vB9UcM7E4Dc7DuA8qjN/WDE+nHyY7z+Qk=;
        b=UK50bz8Eq/IOPM3VS3/d3mnw6cgRSUQ5ZkJokoPhY97sImPknY15yPpyzM18Iis0GH
         bT2+LzQNTJDgTtxyhDi4xTyzlQwwDDL2kCaSvsOmseyWr6V44W8MD0GR3Rb6teb/Eg+j
         ugOTV6ZvkpTP+GlMCF7E20Q6Gc964L5Thz1FGNgqdjPDoPwmZZsUuGapYX0d1rMS5Zoi
         xN2UY8iEbei6GOW5Q8lLaYmMc0BlOttc2O0CjxQ/SUdk9y4wSriyuzisi87+B3ru0N3m
         k5xzPL3CdfTIuIRi1RI4VncAwlNkrHDvfs/SNMl7oN3dPTqJLAUKzhtqpTsfa/6sBCad
         yEYg==
X-Forwarded-Encrypted: i=1; AFNElJ+Nj3bjJyEvBHa7KNSIDUa4Fxg9DdZV6SxdfJ+wE7hPK0Vg3HbL4jAZfMlA3370s78vYjdRDn4GixI5P9dp@vger.kernel.org
X-Gm-Message-State: AOJu0YxSFTHHo/7tRHLsqrUqH9PoEoM5nIWbCT79APz6Z8v4FIY80AFS
	g7ZmAZezLsICtl37IVrJy+qfNSN9u3sZrg7C4g6tvds7H1cc6VFSW0D7Aq+zFj0O
X-Gm-Gg: Acq92OECAL7Aocjknvo8Lc+kz6zRxL+0RyC5GI2bhFUAmcEQINbvkmNiIL5htKnIimI
	tzQnAL4dp4bcy4Zp93LKqfgLICfqOT6PTyN3CvAtNIa0LMgAJ5rcHIao5NsgKjFYBGh1Cd9/9Ys
	sp/jWkBYf/YN7ySz5K7tKnoblFokBXoYzqVsB3fAIhbMF5Sz48uUvv8BpKLbqdnmV+Q6jwe7ICe
	M2K1jeEI/CBMv4GFOJGB2AcAklGci67dIQI7PdUT91rS6f2lvtgLhzSH8RKBS+Km/dk9/G+3qI7
	7OY1wzUp0pX33EgFCRNHORsm8vwERJhJa+SRr28XcYaXltXBqWieTHLLgZ0zesyacWgKPT+PC5G
	my1xqNps3q682PyQKrXpUHR8cj+EW6CyWFB5qQVJa/kPtEjOCl+eswg/xH42V6/rR7cUrcoKefu
	vkfT4uU+MDJhOUHZZZDbx4oZsA14ULjsgsC1QSvkqJO3qvMV0vNSPYcW6vYaoL6ychyZCOeq1GQ
	9I=
X-Received: by 2002:a05:600c:1515:b0:48f:fe2a:107a with SMTP id 5b1f17b1804b1-48ffe2a10b7mr78609695e9.3.1779115907014;
        Mon, 18 May 2026 07:51:47 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5cab7c5sm272733645e9.12.2026.05.18.07.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 07:51:46 -0700 (PDT)
Date: Mon, 18 May 2026 15:51:45 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi
 <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, Al Viro
 <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>,
 Nirmoy Das <nirmoyd@nvidia.com>, linux-unionfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
Message-ID: <20260518155145.01ef37ed@pumpkin>
In-Reply-To: <CAOQ4uxgy5Vut5KYC4vj_wgXiyghT2B9nd1YAV-a+hdkz5j1gqQ@mail.gmail.com>
References: <20260514200129.94862-1-amir73il@gmail.com>
	<20260518-rundschau-rohkost-e591e2d0deb9@brauner>
	<CAOQ4uxgy5Vut5KYC4vj_wgXiyghT2B9nd1YAV-a+hdkz5j1gqQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 18 May 2026 14:52:05 +0200
Amir Goldstein <amir73il@gmail.com> wrote:

> On Mon, May 18, 2026 at 2:39=E2=80=AFPM Christian Brauner <brauner@kernel=
.org> wrote:
> >
> > On Thu, May 14, 2026 at 10:01:29PM +0200, Amir Goldstein wrote: =20
> > > Code using ERR_PTR() is almost certainly intending to produce a value
> > > which qualified as IS_ERR_OR_NULL(), but this is not the case when
> > > code calls ERR_PTR(err) with positive or large negative err.
> > >
> > > Introduce a fortified variant of ERR_PTR() whose return value is
> > > guaranteed to qualify as IS_ERR_OR_NULL().
> > >
> > > We add this in a new header file err_ptr.h which includes bug.h
> > > for the build/run time assertions.
> > >
> > > Subsystems may opt-in for fortified ERR_PTR() for specific call sites
> > > or by #define ERR_PTR(err) ERR_PTR_SAFE(err).
> > >
> > > Link: https://lore.kernel.org/r/CAOQ4uxg=3DgONUh5QEW5KJcyXLDF15HbLnc9=
Ea7RKPcgtyfPasTA@mail.gmail.com/
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > --- =20
> >
> > I think this is backwards. You can of course do whatever you want in
> > overlayfs but I think as a first-class concept in err.h it's not that
> > great. Then we have to separate macros/inlines and almost no one will
> > use ERR_PTR_SAFE().
> >
> > I think the correct thing would be to add an assert into ERR_PTR() and a
> > debug-only one very likely at that and combine this with the static
> > analyzer thing mentioned in the thread below.
> >
> > diff --git a/include/linux/err.h b/include/linux/err.h
> > index 8c37be0620ab..6bf768adf157 100644
> > --- a/include/linux/err.h
> > +++ b/include/linux/err.h
> > @@ -38,6 +38,9 @@
> >   */
> >  static inline void * __must_check ERR_PTR(long error)
> >  {
> > +#ifdef CONFIG_DEBUG_INFO
> > +       WARN_ON_ONCE(!IS_ERR_VALUE(error));

If you do this, you need to change the value.
Even if just 'error | PAGE_MASK' (and check for zero).

You could just do:
	return error ? (void *)(error | ~4095ul) : NULL;
or (avoiding the conditional):
	return ((error - 1) | ~4095ul) + 1;

That will ensure the value is treated as an error value.

> > +#endif
> >         return (void *) error;
> >  }
> >
> > I'm not convinced yet about ERR_PTR_SAFE(). =20
>=20
> Maybe, but
> 1. err.h does not include bug.h, hence err_ptr.h
> 2. I think CONFIG_DEBUG_INFO is pretty common in distro kernels
> and it means its ok to bloat the kernel object sizes
> but it does not mean distro is willing to pay performance penalty
> but David may be able to share more insight about the performance
> cost of your suggested variant.

The check itself (on x86) should just be 'add $4095, error; jnc bad'.
WARN_ON() and BUG_ON() are implemented using 'ud2' (undefined opcode)
and picking up the info from the exception table.
I can't remember about WARN_ON_ONCE() - there has to be some writable
global data somewhere.
But other architectures end up adding more in line code.
In particular anything that adds a function call can badly affect
register allocation and code generation.

Not the least of the problems is the sheer number of places where
extra code can get added - especially for something that static analysis
ought to be able to detect.

-- David

>=20
> Thanks,
> Amir.


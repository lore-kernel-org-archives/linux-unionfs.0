Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028C73DE453
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 08:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794955; cv=pass; b=Nv5aIRvDhNsiUVyLKkpaTXPN9KozUK80wgnSfwH4xBhqdfCt51RYtPKQ7NvcVBPGoaItPRJ/moYEqZiQgnl13rw+PBMfTK74CuqUJNcx0oLE6pcZDoC8YndAxujCHU2tl9WuRb5X1wcYXwSREYOKcAYTtn2kB5k5TRGEwyY37jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794955; c=relaxed/simple;
	bh=aLZSqJ0URF4BgPuBzwI7e5ieUH/kEHL0hZuAQkzXJZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T0YQt2tFz3wlMx4OTiZFyibmQtu7d9R10RCqjyt8pDfKhtwL128D2tnU7OgUkG+Rdjpfz6oYa/G+CmFjlr9zr3LviDfsNrHH/0v35rDj7oTKARYkK5OJK9fJ1+/KpfZQyloU0KiH8Cz+0oFTpLsIY9chlZwALcfsadWh2gOurfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=gmooZBEP; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="gmooZBEP"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c05dcdf49so4774531cf.0
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 01:22:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784794953; cv=none;
        d=google.com; s=arc-20260327;
        b=HeFBFmABmN1zkcUleWMhqOkoSKXq+gMKtBzFAtcMW6sZRPCIhadpRBkFpnH90emR/6
         tyTA5gBwvRxbpcaw7WpIWA1elkSn4J0rGHU/fmFm0yQ6gx7pQ0gBYUw2Phukeh8sGJff
         vvs0Qv4uczmubAt4QsCDDQQR4xPGUvBRc7hmynWJVuNmPM+i2DW7mellp/GVK9ACKCye
         39Uc0H3AzDtNOJ6RtCaL8uBZmWyKPx7bX6ufTT7eCuKI93+PIe/KF3OCQkOeivBvdnCk
         hCZyXM6/t3Jbu2cZQxbQUCM0Vj/NIPZqNS2bG+phpw4RPwVrbxGTr2fINdmpfN4dIHnN
         Kbdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yrgNUo4LIyDIRSBo4rDxodSFyTnV5NyKbJ74rO2CKL8=;
        fh=bQ8Rakl824m9AFSLVv72Vauych5jMEvkh4MWXQQ96Hg=;
        b=JwXO+xCXlNEyrKZ2QVJzOeC8d/NmFXLstoRkmHPfM6n0uz7yT3o8g75V/EIBZq9HC1
         D5kJr0YJapfSvGa6PkJG/vTpONvs8s3z+weWgOYwNA3rHpwL0pW9/imU9ILHhMFMPtDJ
         2yOk+09wXjH8TByAkl+coE1GZ85VAq4JtKBUU7rXtLt+dsvOrCRHkO35V2nLDHk9lzVM
         hMGp6OTKzMmhx7VrfPDYVlRQWBsxv3lVCQP8N5M/zpp0NfRu2K/vs+GXuMi8QorjSjNw
         b4doaszq0hS3c9VGcwDLBmJcbAFaB+swaor2yxJY5Hf/JE2860fLNEnI6UOq5r/zSby4
         lO5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784794953; x=1785399753; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yrgNUo4LIyDIRSBo4rDxodSFyTnV5NyKbJ74rO2CKL8=;
        b=gmooZBEP6yxzO/jbE04k+td9SkYz+eKuMblMAwvIBzhrnGKY0ZIjzo2c0q/9VDXnD0
         AryreByxDRHFLHtY5UWu3edNIcPikUcl5SBiBdAUu0vVl3eSpKQtPxlL16yEyHF86qnx
         f04ZpSyS2xSBECpFvI/E+iBe52VtrMurWFjMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784794953; x=1785399753;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yrgNUo4LIyDIRSBo4rDxodSFyTnV5NyKbJ74rO2CKL8=;
        b=n0jiIWK9MxCxTuEDEds7FBcHGWn7XEY9emuB+FT25ojVre+Tjzy2NPKMtEogp8cOuR
         CCyeWaa/Z9yxSeVRvAj0wIsMojT0rXeY6hwnxlOV8nVvGYD7WrNI8dIHwHxgeexvlwqM
         X44D7sBggZxX0U24EljHu6klHj8xBhX5DTdbcU6SRVx3iF43pap2qJT1u6ZMDtK59tmF
         vP0v7d23W2XXv0jgnetrS1XpCSWUca8l+Z46Ftwg9Y99OIgp1aU5lGl54I73Rl9aVK7h
         uDIJdd63LJyDN6fuxkhFhhEJpaD68iL+nu7wGRYNlQeqHNJen6ALppeFxq4yW78mKpSq
         na4w==
X-Forwarded-Encrypted: i=1; AHgh+RrhrRHfQsbbfaesaYVXld+GeusQJd+4Wn15B+tEf4q3zbUiwLOpt94XmIdn1GIRQAnNMv6HlzAHsG81nrP2@vger.kernel.org
X-Gm-Message-State: AOJu0Yzsk6pyvV6ByJxfObHpMipO2dwZoGfiBeZMZaGM1cMvtGWzdc14
	z7JlX+RPbTzPxI8yPS/wmtdu2xbv6BFcixxtbNvOVrOnW98akWfl7KTgCcvbToEsK0mWok33FmP
	OlSlkzlxYTJbIHl9t5CMizh44ibEctwosIdODz9QmNWjOEUBdkMOtrMw=
X-Gm-Gg: AR+sD12FBYfgbouO4ZAr633R+Hw7WqlTiZlasdvl9L34fVyfCNCeSN6Ywyc4XUYR7Gy
	ocsOK6gtRkWV6Hx6jhbmO3BHanU8YIa40mJGmaB19vDdkgVZVfrQ3IocE7XvpCu+FEXNPUsEtFW
	VZJ6N4WX89fNo4pwsaTgEPdUHp9rIKJPsxqncDSBn/l2kOxlypgL+K7ZRzjt0VhRhjEw+dfV0vp
	kv+SJBVRKsmcd6hh/PkBZ5KirRbyDu9oDtajnFAtqxMHgGI/1LrC3J7WTbFEh61xfR5hU+itw/X
	SHScvDotwnKYMw+7UQ==
X-Received: by 2002:a05:622a:14c8:b0:51c:7b12:5fd4 with SMTP id
 d75a77b69052e-5283e012098mr18036511cf.80.1784794952935; Thu, 23 Jul 2026
 01:22:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <20260722-fundort-zogen-kormoran-09fb867f1b59@brauner>
 <CALCETrU9KdLsvZzUE-5sh7KkP5-cPh=hwErGmN=THsDatFJLfA@mail.gmail.com>
In-Reply-To: <CALCETrU9KdLsvZzUE-5sh7KkP5-cPh=hwErGmN=THsDatFJLfA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jul 2026 10:22:21 +0200
X-Gm-Features: AUfX_mw-0nrqXevHRitoGqWVZtjfkA0y47FHySyo3TiICVfrOazHUs2Vr34P9VI
Message-ID: <CAJfpegupwNTaVNZtdQTmvtz9x=ehH59hzsRT7D0=VbhOZvaqrQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2026 at 18:36, Andy Lutomirski <luto@amacapital.net> wrote:

> Other than that question, I think I generally agree with you.  The
> interesting operations here (getting an fd to something that was
> previously inaccessible) are different enough from normal path lookups
> that I think they deserve to be explicit syscalls or syscall modes,
> not magic links.

This is a super specialized use case.

I sort of agree that doing statmount() as a syscall was not a bad
idea.   But new syscall for getting a backing layer, that makes sense
on just a couple of filesystems?

And that leaves us with ioctl.   And ioclt() returning an open fd has
it's own problems, besides ioctl being a generally bad interface.

And we have all these powerful concepts and interfaces for
filesystems, why the big resistance to actually using them?.

Sure, it's easy to misuse, but I don't yet see why this particular
case would be a misuse.  Enlighten me please.

Thanks,
Miklos

Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8981C32FF
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 13:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041160; cv=none; b=KGXlyP6mvrwulQd8sPGDDajPPhKHXbIaTk2KW5Loe7YZcBrGXtiM4R3+lWM5uongAxKAI9AbAtuXp3G6eboKJQRPqfcso/qcHoa8k76B7kbT15H20eGbguMmMbMZF4bgSbVB72creqgtf6EnSmcbpA5xGPbyXD2mYCSL2xlPV/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041160; c=relaxed/simple;
	bh=n+QF1qMZIlbo5ZUwr6r26QvTuSxfrrDlWY7CjW4I6tQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M9nRT9IAvuDJqzQouxz5u066rTgEYAH7P1fNylP5AlBWs8m5SBCnygpmDjSbsdgVvrCi9zmlrvaaViuGOBG8nRlnywy0dZLmTgf0hrspR0/JE3TR8jF2HGh86pMfT0ZfFpX77r2RinNjW46PH390e4Oh8+NuIA4MF5YVkILRVUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Ygibk4j7; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Ygibk4j7"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8824888ce97so11232256d6.2
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 05:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1763041157; x=1763645957; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n+QF1qMZIlbo5ZUwr6r26QvTuSxfrrDlWY7CjW4I6tQ=;
        b=Ygibk4j7kiikVZKymYDEIbD8DfuA4mEdds2q3u/MlcxtubGnI4e1HeCLRM02NhGJvB
         RcoavAyxu2PVMkJgWH1w0rowKZ7bOpYX5G8TDCyEm0cypfXhOFYd9pGoLmePYAc0LcRS
         Yvb59dtWbW42BO2MuZZQWE+LMjnCHQ2NFjSc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763041157; x=1763645957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n+QF1qMZIlbo5ZUwr6r26QvTuSxfrrDlWY7CjW4I6tQ=;
        b=bKT35wNGGsU4Lx46yLR+eg510iVkFch7VYIzs2iWceIFHhGD7q4SdDAnUnTZAk4opa
         qdiabJtTgFZtgceopMv4/oFFS8FnKQtn4zCU7YJ4QaTY8r+ZyETvG+BbzxEU0+bcUvg2
         2C9+KZZdUv9fbpnYX6AQjnbMevdsFgq83KIt3bEwqpwHTY0xBdeNYDbtnT0ps+n6lyZn
         WTA/XR+NksxRyP6eKXIH+4ynYywbsBKCm6AhMFi1KAmQWwyZ2MoVue0EyYV3wTcKVw0h
         +A2jmx3vcqLfD0PQbIp7OKf4xKqxRZCNw3gv62PThEbL4jIZJ8BGCEwZthyyxjrDAUeb
         t/nA==
X-Forwarded-Encrypted: i=1; AJvYcCWTCKIRmtxSLQhekjimnpCViisY6Ca1Lgg268uDE3z0yDkgH9OI8IX+jmTcmgGXz5mKHfGILQGBVq2q417K@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1a7VbOTiDgnHEatSu9JNgVhuIhaZVClYxWr0Vy0CzvuKwsEjd
	LxqF4oX9FeIODXvAca6acTzFQWCsYCo3e1eBT1BVDMCby4cCQVkRxe8pmxMC7EGLyGfpftpecc/
	c7Uji7G4UbhYWGqjzwdY89QcUBThhe2Vjgc/D2RpOIg==
X-Gm-Gg: ASbGncuGs1cd27HXcnfhoWVpdQp866BtD91XpbLVem4cfpTylgHsQ0DMj59QvtRa6nk
	8miH1hBSR3PfnnTnWcK+Q8vaF9bHijVsadcZvwSyd6K0mfKBjN8unWY+STgmkd5BM+DGn2TRmVz
	50TGTAxBavxUeVAxq1XFxeOQyeiNHNHZ8TmYiluJih9cqbEwrYTwM2GRn10LcAigfI68AhzwxL7
	+VtTwcyeHyvtXOeqtnNKPis1HkYqjy4Jx+JcYiKZw2LwiDQukqXengLzh3c
X-Google-Smtp-Source: AGHT+IHG/LjC5S6TUtVX2CjbTvKRR98/1uXdm+r/2VxpDUSQrHGKdDwqjSV7QDKMdXQv9/C0Z0Lu0JYBQsKbBpDpqVE=
X-Received: by 2002:ad4:5746:0:b0:87c:152c:7b25 with SMTP id
 6a1803df08f44-882718e510cmr100650186d6.13.1763041157194; Thu, 13 Nov 2025
 05:39:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v1-0-fa9887f17061@kernel.org>
 <20251113-work-ovl-cred-guard-v1-3-fa9887f17061@kernel.org>
 <CAJfpegt9LQe_L=Ki0x6G+OMuNhzof3i4KAcGWGrDNDq3tBfMtA@mail.gmail.com> <CAOQ4uxjnmLiLzM-a1acqPpGrFYkLkdrnpuqowD=ggQ=m72zbdg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjnmLiLzM-a1acqPpGrFYkLkdrnpuqowD=ggQ=m72zbdg@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Nov 2025 14:39:05 +0100
X-Gm-Features: AWmQ_bmN0A-u3kmz-W_mEDRKhkg9WaqBxy_G-fMwYX89VUGf-XiGKVMq_OqfcWs
Message-ID: <CAJfpegvr9HJ43zvAUgA-Q+3sYaH3wpz8NdmW5ESHxk=Y8gqUNw@mail.gmail.com>
Subject: Re: [PATCH RFC 03/42] ovl: port ovl_create_or_link() to cred guard
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Nov 2025 at 14:34, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Nov 13, 2025 at 2:31=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Thu, 13 Nov 2025 at 14:02, Christian Brauner <brauner@kernel.org> wr=
ote:
> > >
> > > Use the scoped ovl cred guard.
> >
> > Would it make sense to re-post the series with --ignore-space-change?
> >
> > Otherwise it's basically impossible for a human to review patches
> > which mostly consist of indentation change.
>
> Or just post a branch where a human reviewer can review changes with
> --ignore-space-change?

And I can easily create that branch myself with b4 shazam, but then
the review is disassociated with the mail stream which is a pain.

Thanks,
Miklos

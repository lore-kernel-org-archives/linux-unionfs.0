Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FB91FF1B4
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 08:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778920968; cv=none; b=r9NFdDPMDxyUvYEaRbnQfkfKP3fQ+6TmwaDumCJjs4Um+GCtxvuejtDb1218kB1PQnqQk3sV9Ug6OEX7G6xqHkFeSwUtw1HuuEOqFNx2Ra0fzfjCmYNmhj/mwMFE/3D12YXMttbdmWEzJDSqS+NeKZORaMVR44VkqMlkn8eEXwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778920968; c=relaxed/simple;
	bh=RnkaXF+insktooUT2CslgYeWpdkUta1D3SaeHR6Tok0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fSf94jkcNNJ3EwZ8s9BH/+FxyWM4gFwnqCZU3zrWpdDNkBBnUvBn/t6dva2qlYIfE+T0kozHRccxkU4lnH0FstB8JXtRnQ6v+vVwjNpvmlf1VsN8pJVh2OOxXsa3RToTt5/vwVrOaDVh58LThJir/K3Hi+FxLCoeNyecc7B9Ejs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kxbpRZTC; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kxbpRZTC"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so6514315e9.2
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 01:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778920965; x=1779525765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GjaZvzmqJsfgwXiIBwGP+VbrW7tGLwzGVyPjpadwRZ4=;
        b=kxbpRZTCw8OfZCVwJ8ZSZ0aP0PzpgRZl5RNGr9GKPjaBWx7jd8fns0oLSn/eBogsqN
         I+Ifg9tAgC2zedQX5ifJbMyk2PDf8EPvt6Vmg9g0iWtsCnyHZ3/0nvo2adIxftyCnZGl
         /xlPWDIqowJgL2gpDzMN0Cro11Qs/V051uFP9Ocp8k4Ngy0LCI6JMQbRQ9F+IfLYc+TK
         Da8Nw+YwpoDqyzTr+9jQ7vowUPKbPhuL3FMAQGROsmOuo10Y7fF0AzFK5w+wEMBJAFXv
         4pB70/eW/v5giggt5hygWiEjOFZBOPUmybMmQ8hi2t35ueghUXgvGU5SjH6e4rHI9lLb
         KkGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778920965; x=1779525765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GjaZvzmqJsfgwXiIBwGP+VbrW7tGLwzGVyPjpadwRZ4=;
        b=c+pczAMpyZ603UrQxzZ5E7mAy/CczLIrs9lI1ZMYVxjTniO7OKJiY6cBiUPZRMLxJv
         2iKwN5iNyeFu7NNUVEMiuL/6xD3WZdj/TpiUp53qG+2vYtxVUAI8+JS6o+uU6sGENtjg
         VwuYhhk8ePBEAaiVKdvsgAcqaa3QNwj6lahaifQ886tNX+WxS1aqhe7n3K8PXjKSWe+A
         k+ITkn9M254TbBmuBuaWqQHzVwbXOg8NeDrcqPS0EYXPHFhO+pJPgq9K84yItzKa0IH1
         joaioOB9bG7/QUw7d8nPbIpWtn44XufAMd3xsrgwsmdXkxFIO8lPrcGxouQe9ueVNAx8
         FuDA==
X-Forwarded-Encrypted: i=1; AFNElJ9jIDMlULhMneLufJWJLFypgmnXdeFo4do5FH3xwRNDOWdkbllF0DoJIGXVd2BV/uMwg6DAEkV2rAIWRHoO@vger.kernel.org
X-Gm-Message-State: AOJu0YwgbhGBcrnyYkmxiD6SxeBTfb+qPAzYLYykeg31U+kqi+ql9rSF
	7X8Fg4hAS3wk2st9/VkVAa6nYwtM7pCEpU9VSYYgrEAFnL+yfv3HvPz7
X-Gm-Gg: Acq92OHn502rgluAMQ+k03uUk7FDXVgT1wGqPEtnQkIzDs5Y6+8WKBapR3EaqPbS0GE
	bKI8xW4s3o72sELmoa7BmCWPOuxgDe60rp5qcjglui6RP+PmNZbUkCGg5le189k7YLW+Ay1yRhc
	SfpFjPAMSMRPqRXyv8n/sBoD9WOvWKoc7245XwkfeipxCOxIsXWM+zWHlk7LrDDVmvbhDPxDkMY
	2ElcNmzN95UCJqyVojKK9VaF2Gv+p19XKcAxFfzXCr1YI++OoA2dzVBZzyFp4GkYIxNNy8ua2sE
	WDczUwDYMWXwa5aMpSPh4D87/tzVUER0uU/h2eUfYfDTz3m/Hl98nx32NJzfFHNb1FXcs56fdJy
	gSzsKvcuv+i5CrtonzhBOTJ5m+n7HVK2UPsG7+3NvAO7AR14sXhLlk/Oaww4Lnh3qtcGhnSGyUW
	XjkHf2nkpF4F/yEUdaowYjqm+x5MUH+NCLfhj2C1UquOSolXNfQqdJJxnYZHjr
X-Received: by 2002:a05:600c:8b4b:b0:48f:d2fc:d025 with SMTP id 5b1f17b1804b1-48fe60e14d0mr91173965e9.6.1778920964812;
        Sat, 16 May 2026 01:42:44 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe537c788sm108760745e9.12.2026.05.16.01.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 01:42:44 -0700 (PDT)
Date: Sat, 16 May 2026 09:42:42 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Al Viro
 <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>,
 Nirmoy Das <nirmoyd@nvidia.com>, linux-unionfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
Message-ID: <20260516094242.77d20c92@pumpkin>
In-Reply-To: <CAOQ4uxjDeF3uDe=OTVZ3fK65dF148FRUvPx5fOqZpoFuGUsmJQ@mail.gmail.com>
References: <20260514200129.94862-1-amir73il@gmail.com>
	<20260515193010.056ef472@pumpkin>
	<CAOQ4uxjDeF3uDe=OTVZ3fK65dF148FRUvPx5fOqZpoFuGUsmJQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 15 May 2026 21:26:04 +0200
Amir Goldstein <amir73il@gmail.com> wrote:

> On Fri, May 15, 2026 at 8:30=E2=80=AFPM David Laight
> <david.laight.linux@gmail.com> wrote:
> >
> > On Thu, 14 May 2026 22:01:29 +0200
> > Amir Goldstein <amir73il@gmail.com> wrote:
> > =20
...
> >
> > The object code bloat would be noticeable if this were used everywhere.
> > But you could make it a bit simpler:
> >         if (__builtin_constant_p(__e))
> >                 BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));
> >         else if WARN_ON(__e && !IS_ERR_VALUE(__e))
> >                 __e =3D -MAX_ERRNO; // Or maybe -EINVAL to stop and oth=
er boundary errors
> >         (void *)__e; =20
>=20
> Yeh that's nicer thanks.

Actually this might be better still (or just more succinct):
	void *__e =3D (void *)error;
	BUILD_BUG_ON(!statically_true(IS_ERR_OR_NULL(__e));
	if (WARN_ON(!IS_ERR_OR_NULL(__e))
		__e =3D (void *)-EINVAL;
	__e;

The WARN_ON() will be optimised away (valid) constants.

> > The check for constants may be fairly pointless.
> > One of the static checkers may already detect the obvious fubar ERR_PTR=
(EINVAL). =20
>=20
> True, but I figured it didn't add much overhead if we are placing
> the runtime assertions anyway?

The 'size' check in READ_ONCE() measurably slows down the kernel compilatio=
n.
But there are a lot of those.
I think I know the main reason - the extern for the 'error message function=
'.

-- David

>=20
> Thanks,
> Amir.


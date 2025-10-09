Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601BC2E0B77
	for <linux-unionfs@vger.kernel.org>; Thu,  9 Oct 2025 11:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011185; cv=none; b=jfP3aYJVjjsKtipPnPGbf8RRxcIHp5BTftBjJ9UoWfnJ0yyvAYifOMG6CgIdRpCeudSaI+jLw0BUg9nve+L4TGY6p5WHEkw4yuw/s2FT5ltENqqJI0XVKd89xzWQ3OYJ43EsaYvjG1Nv+SQ6piZFK1i0vsbY7Hqrj1uWEI7by1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011185; c=relaxed/simple;
	bh=wYVR3J6KzLGYtAA9ZkANUIfBYRZ2PuyG7ShoLRBLWh0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dz4fokZZDMf+yknVq8eK4ah2gTliT6OYrpUS8Qlo6CYJazcl8CyQY7oWvKrvhH8TD2rfePtnAG1pX2Bmxt7n3+UCs/K2c4xCaaEb9hrkZW0tyKBh4PXVhzn9gCrtQp8u8/2c+qKePAxQH4kDGxATBVthA5S0SfmMIhIk8cmC5sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lpsxiR0q; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lpsxiR0q"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b3e9d633b78so51410866b.1
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Oct 2025 04:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760011182; x=1760615982; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYVR3J6KzLGYtAA9ZkANUIfBYRZ2PuyG7ShoLRBLWh0=;
        b=lpsxiR0qsqnAQmSQclw03ElCRE/rCnn2/IuagGmO1KBeegmX1mxtRq2Y9Btm/iGdLB
         F5C7wVK+ythQFZBso8IEcVIEZpf8n5ksfU7wk7E93BPxPKVDiCI4yVN48ep+7r0FmsjH
         5sj1wpdKfgIwPZUF8Tx1XEXcQqqQd6n83qmXEfLkplPWOueXkVyl5o6+wIhbZXMmZpy7
         2YRwMf6lDyJLK4YBMeJi4dPjlJJjer+5ASDuGkkKl7unbQpX2SXaJAV7xaOjlFvjS61b
         s/oIBatXmtYvGjPj2FkwXqYfCDcDo7RgLZkQxmyhQDye7g86WfKEtKIsfJCMxE2mI6Jl
         Znkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011182; x=1760615982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wYVR3J6KzLGYtAA9ZkANUIfBYRZ2PuyG7ShoLRBLWh0=;
        b=vtl1OqBT/OYEZhcU3gO6ozLQNngH+S6Zi6JjyMp06ffY3L+CeDyW6begayv+pkjAsW
         kqNQCQOVYcPB1HW82pEFy6AohxSTPEeld72kRmTY5zw9hQC6UEb5bt0u9B3HKO6Hn4lZ
         IgzKMAq0XoXkj8AXWkfWv5KxulJRcPSHUorAIJe6eihC8O9CPFavF0bjh1ecTSZPo1Nq
         +Zdfcc2x0ylmn/QkqEGXWw7zO2m9Ma2S5ezszHFFPHHlY2l9JeZRh3oORMYbL6BW+6n4
         oAwpnUCVenYAsldv62NCpgz8ttPxWJPwxr7oODpgv1dYjUa5t/D+W66O6vwCUZ2tYTPi
         46Kw==
X-Forwarded-Encrypted: i=1; AJvYcCWmEmDm7xNTACmfcsGcHIVJuGo4gKGs4z8Ea+DvEnTlQQ+zLmbCTxjJvyTTBE9k2+XDNukVuQZV0q8BxJ6G@vger.kernel.org
X-Gm-Message-State: AOJu0YwcUqVq5924MfqE+A7cqAA91gPbwlxpXN/HVDv7QIXDAwrAzVTE
	HhnrCW57+X3mEi88jIpJr42AsSCayI/IVI8kVFBSWsDG6SMu5YCkK6Emj7RIzmxAcBQ5WgwEkwx
	hdgUkKflae0BYG/mprMzYwi7XAg3Iydw=
X-Gm-Gg: ASbGnctaU80drAFQm97h5fPx8jdFdK7fgrXhQDVJjC0b6C2WlfnjJKBtiJQjKZesjD5
	vKh2Dwu94kt8VNv38w9Z/oeC2Joo+kMupiUUW3UziEpLKq449UFCCE4Dgqb7hq1AhxWnGVpUoDr
	Hz6m4+9Vm3NbSnMMvqT78GIeTynY9aaHqglYSyg1Di8MkVawKileAxeqBpyrE+gN7SsGmPV5M/l
	IZcOmMG1QYZQkAw3gJTuEOmdw1dwpIkwTxp0RGrKKxFdZvpkFx6n+Z+H8GdEVGn
X-Google-Smtp-Source: AGHT+IHroKoc3xTqAVgK5VliNryQgNrZl6+5D+g0sybSx/HP6H+9Km+WFb0uNCZFdd4lW8F7JZ3bePMC0pvTpGDB9v0=
X-Received: by 2002:a17:906:d554:b0:aff:1586:14c2 with SMTP id
 a640c23a62f3a-b50bcbe2790mr985957066b.4.1760011181389; Thu, 09 Oct 2025
 04:59:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251009054148.21842-1-heo@mykernel.net> <CAJfpegtWcfaDooNgO9sxX2c30cfVJNibX4oev=3ZEJLrr4GrmQ@mail.gmail.com>
In-Reply-To: <CAJfpegtWcfaDooNgO9sxX2c30cfVJNibX4oev=3ZEJLrr4GrmQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 9 Oct 2025 13:59:28 +0200
X-Gm-Features: AS18NWDiFnPpXVFTKcj_1LbgEutDiGs-JBw1ksJ0JZOO20mRle5guJfbn56lX5w
Message-ID: <CAOQ4uxhLXa9zGbr+VfQvC+o7_65MRBt6Y-GN9NRmUs3kXK=7CA@mail.gmail.com>
Subject: Re: [PATCH] ovl: remove redundant IOCB_DIO_CALLER_COMP clearing
To: Christian Brauner <brauner@kernel.org>
Cc: Seong-Gwang Heo <heo@mykernel.net>, linux-unionfs@vger.kernel.org, 
	Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 9, 2025 at 11:56=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 9 Oct 2025 at 07:42, Seong-Gwang Heo <heo@mykernel.net> wrote:
> >
> > The backing_file_write_iter() function, which is called
> > immediately after this code, already contains identical
> > logic to clear the IOCB_DIO_CALLER_COMP flag along with
> > the same explanatory comment. There is no need to duplicate
> > this operation in the overlayfs code.
> >
> > Signed-off-by: Seong-Gwang Heo <heo@mykernel.net>
>
> Fixes: a6293b3e285c ("fs: factor out backing_file_{read,write}_iter() hel=
pers")
> Acked-by: Miklos Szeredi <mszeredi@redhat.com>
>

Thanks Seong-Gwang!

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Christian,

Could you pick up this fix for the next vfs fixes PR?

Thanks,
Amir.

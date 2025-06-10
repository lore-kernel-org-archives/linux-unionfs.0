Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288AE247285;
	Tue, 10 Jun 2025 18:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749579949; cv=none; b=jkR91486wb+3IKal1UyqIH6WYgBtueHUut6HDt9W+RAevhxGWHCncVm3kxHnxSrG/DUcrwO6dJUXbQxLt/hDWOgdYMaatZffzC+AIqbnjZZhAVX9t4glfLTnMawuVD8BKd8m4jKA36lG+z6pI8ccjncaV3vo+p9B3TBaMda+j7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749579949; c=relaxed/simple;
	bh=cqT+DpGDDQqt3yiUM2mJGhZ9RqyX56gNQKYP8OGW4wU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DrGujHJDTFA+rFpf6y/vJxi7rV0+imG5W5vXx1yA5O4Ha3HPPNSgHK4qxr2nCenCNAi/ExdtNxzGHTiqeqdB1HcRr1DCaz0G4txzaZXes4SfSRV7zHBn5DWscfpZnhb5oEU0W6FzQAPubRVwSfpNcBw5pWuYKZiZ6p4fC1q5grc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bn5+IyQ/; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bn5+IyQ/"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ade326e366dso646247766b.3;
        Tue, 10 Jun 2025 11:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749579946; x=1750184746; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6CfpEGx07hfTCNQ2LVj1osFjwjX2WBArDhsNDFG6KSc=;
        b=Bn5+IyQ/acURmey9xnqVxfhrOOxe8AcojmR1rrIKXTLtasJbPnkAhQYBcL8UBuBBQ3
         2jpKFuNXnzc4P9I8//BPAs2ZwEUEjITVsnUSIxtYg5y4L0nS5dQgv+Z0uqiSL6YIZ0Lc
         I/kljs025dvG4aEzJaFKld3wB513MhmWgaqNZW7rPq6fB4T3xaltI1of49GqTVVOWen4
         esjMreCd1t6WPuxRQs+hU1dV4PHhAvCYPzEEvSoKqfeqAD62UCsCwIcGKvJyzxOy0Yc9
         QwM2/D1Wu6h1McgaJJZgoy//w81B3chTJ7Q6GocNRaRHf4Eih2aCLW6J7nUNVxAcAJoi
         +zFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749579946; x=1750184746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6CfpEGx07hfTCNQ2LVj1osFjwjX2WBArDhsNDFG6KSc=;
        b=okE4qdDqJ50WV5e+77nEGfaIgspTAeMpGBLl7OSdOjAVefgyBMckYjuYHZ9Ht5oabL
         ZjjdJDVgGhT9MkjUPGFFw2hKElmenWAZmAyQV9tEqGyc6/LqXAv6rHq+LKiLcCMkf4XW
         EhRfqtlrJ4idRueUFdihbwtRyh26Za4h9dEGkz1EAkvdzdcZynOKxNnOpBNul8xBzmtA
         Hehoz3F0gD/8yHkbDI3oQ0UrwHzB4XE5WxvEHwFmOWnadd0jKvp7NzPqjcx+Yb1oJRcw
         8o9IrBzmNb4Eh7eIDctg25wdgeBTemDjxDAk7iQ21gkvKO7DxkSBGPuxodqriL/Vprdl
         BC9w==
X-Forwarded-Encrypted: i=1; AJvYcCW2NicgvJ2if06z8kCAh1AGw0fFTpg/MeLwrnA4to35q9a3NNwiKUCkfaNN03C0aXuT/2dFQTZV@vger.kernel.org, AJvYcCXXJq29AS6RKskelnUQvF62LbYC00vpTrovkGBp56g4ZEygfeH3GlyrT8kR89PF4RVKeknWPbfgcQtbMaXfGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm75efISrdJuZFpyuYoJGbuoYfDnVgUjNuGflii6hKsJiGF5y0
	T2nSmdZ2bdWGGhPe7u0yIqGTttJu7p726I0PYxB6BSaVWapt3eDw78F+CwfkBJQs06PyyLji/qb
	31aqxHmmxSF45OyUr+5AeEsU3/5VmbWo=
X-Gm-Gg: ASbGncvEErcizswVk1LEiL+5Bbjnv+7fs8YISkF5UECkL3Y3UTg5ffx/eH9wIBojrGs
	N2mPmim1XIpHc7/D0VWdlA5/a2UFn74V9iFpp21I4NQrT6MeZhbtgON3U1KzUuP9ka6s8Gf7Ndw
	asxRQlUKE8UuupN6Pcr83yD99cP/QbSuew1Bb7vfYOfu+WnZ+CD8xE4A==
X-Google-Smtp-Source: AGHT+IF22wpKSHAIR03Kjjn6VJkC9oQJ4dRRlB9bY+bkkUvZCnkz/6fU1Uq6uJB/WBql1Lpx9vZsHjdHuVVbL75Wcbg=
X-Received: by 2002:a17:906:7307:b0:add:f0a2:d5d8 with SMTP id
 a640c23a62f3a-ade893e8e3bmr47158466b.11.1749579945987; Tue, 10 Jun 2025
 11:25:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250609151915.2638057-1-amir73il@gmail.com> <d24bba45-681c-4446-aa7e-b020889aeaf6@igalia.com>
In-Reply-To: <d24bba45-681c-4446-aa7e-b020889aeaf6@igalia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Jun 2025 20:25:33 +0200
X-Gm-Features: AX0GCFuk53z_Z-sMs9kFgVMQtuSop3vfzfH0PXSZoKGGRZN5gLjPJ1AGilm4JZY
Message-ID: <CAOQ4uxhhiVd7cb2o=-adKJ6Q792Y1x9jPLZgAL9PeLSFnvtNCA@mail.gmail.com>
Subject: Re: [PATCH 0/3] fstests overlay updates for 6.16-rc1
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2025 at 8:00=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@iga=
lia.com> wrote:
>
> Hi Amir,
>
> Em 09/06/2025 12:19, Amir Goldstein escreveu:
> > Zorro,
> >
> > Please find two new tests by Miklos to cover ian overlayfs feature
> > merged to 6.16-rc1. Those tests do notrun on older kernels.
>
> Using this patchset on top of 6.16-rc1 I still found that overlay/012
> still doesn't work in my setup:
>
> $ sudo FSTYPE=3Dext4 TEST_DIR=3D/tmp/dir1 TEST_DEV=3D/dev/vdb
> SCRATCH_DEV=3D/dev/vdc SCRATCH_MNT=3D/tmp/dir2 ./check -overlay overlay/0=
12
> ...
>      -rm: cannot remove 'SCRATCH_MNT/test': Stale file handle
>      +rm: cannot remove 'SCRATCH_MNT/test': Is a directory
>
> Here's a smaller reproducer for 012:
>
> ```
> mkdir -p /tmp/dir2/ovl-lower/test /tmp/dir2/ovl-upper /tmp/dir2/ovl-work
> tmp/dir2/ovl-mnt
>
> sudo mount -t overlay
> -olowerdir=3D/tmp/dir2/ovl-lower,upperdir=3D/tmp/dir2/ovl-upper,workdir=
=3D/tmp/dir2/ovl-work
> /tmp/dir2 /tmp/dir2/ovl-mnt
>
> rmdir /tmp/dir2/ovl-mnt/test
> touch /tmp/dir2/ovl-mnt/test
> rm /tmp/dir2/ovl-upper/test
> # rm /tmp/dir2/ovl-mnt/test (bug happens here)
> ```
>
> Before executing the last line, if you run ls you can see that test is a
> file:
>
> $ ls -la dir2/ovl-mnt/test
> -rw-r--r-- 0 user user 0 Jun 10 17:54 dir2/ovl-mnt/test
>
> After trying to remove the file, the previous ls command is empty now:
>
> $ rm dir2/ovl-mnt/test
> rm: cannot remove 'dir2/ovl-mnt/test': Is a directory
> $ ls -la dir2/ovl-mnt/test
> total 0
> drwxr-xr-x 2 user user 40 Jun 10 17:54 .
> drwxr-xr-x 1 user user 40 Jun 10 17:55 ..
>
> But running it in a upper level shows the file as a directory:
>
> $ ls -la dir2/ovl-mnt/
> total 0
> drwxr-xr-x 1 user user  40 Jun 10 17:55 .
> drwxr-xr-x 6 user user 120 Jun 10 17:54 ..
> drwxr-xr-x 2 user user  40 Jun 10 17:54 test
>
>

This is a kernel 6.16-rc1 regression.

See https://lore.kernel.org/linux-fsdevel/20250605101530.2336320-1-amir73il=
@gmail.com/

Thanks,
Amir.

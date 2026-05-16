Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05C43D5659
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 12:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778935344; cv=none; b=c9HlZCoJKj1Mh9xnAwoUulOqAZSkCiVf4l9Rd5iEamXPx2we3SdBuYEgyZYw+eLstvMnAgYt0mC8gF/RveMbpEXaHUUYnWO2qsLjFSV4tB1qQr5FoLfpZ8xf4AS2gaWdK9fyy3oXS3gL+K1fGFKhD+czM9YJlFSXBEaulnD2ZRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778935344; c=relaxed/simple;
	bh=dyTCV1iXv8a3jiKteV4rJPmHzjcbFZlSYh0yDLAXMx0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ViUsemD35jEw4fsckyuY3DQ/TlCOYaMCTUJXSnIrmQK9ILPL5sQ8ltKV7lsGQpORe/Zuq0aiyvCC3gFvmEcAaRX3UJlwxrDOrHGglx+imhXs4CIw5G49VcbufrB1RnJ39lYCf3XcKG+2d7EXJP6UVokjuC+SbnJNLE4Mp9OSfdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qnOPkoAD; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qnOPkoAD"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso4677385e9.2
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 05:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778935341; x=1779540141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=18WmkI7S0iBiBQjk0+zjD5psJsNEfkb8RPNasAp7J/0=;
        b=qnOPkoADzr8TrubvJak2i4ShMr5iizDY48306bHbdQdlwgcZI67VGrk9BLYnVNyHTB
         3JloSaLXuCQuHD0K4EqvuZpPUjEWSjrXxdEfVZpLpePTu4JI/ba0W3zJMbz7qyA3jHz2
         U2ZRpfNd3ysar5cq6uvHo6kT9Ep0x9q5AbgmZ0ji834PdWw3ZlFMP06aFJP3Y35ySCSl
         Sz42MiFal8OW38HAbYVcRnQM/PKV4imuf0JG45HX64GVkKbhKdEIW3kJkUFK8ZMxatdk
         AXR4T5eUcA9bo76JVogOBboIx2QVNYyuGaJB7vfKnFkW51CBGlnIIjmPsh4P1A8M1eQU
         sMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778935341; x=1779540141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=18WmkI7S0iBiBQjk0+zjD5psJsNEfkb8RPNasAp7J/0=;
        b=l5GbSp3UoMfW2Fh5SovSLYs+M6SqJLTKVIiP8FZBLaeXTyM51n3YXlj1sX7VVoC/KQ
         Qo90oXx4Hy3uSdM8m3W4rN7FfaU3vyUkYpvxxuk4viKhD+NPAU/PdcsmhMYorFc1sZyD
         OeMrVMu6I4mZtlCT24DoXpyMr0CWqofkmTTvWWhuqBJ6GAGsu7CTd32Dz4DHJRTY5C2z
         W1GtWy03hnNpb+3xGkkvtqkrbHOpN97/cQiLVdXtzV6aV0Pz1w7k0OnGcNCRnKFYODvK
         zpFVt7pbKgHTbmajs8FCXxPlyKpLiw09OaC0l1AQuu/v3LWJ7yPrsTleEU+Ih5bSGqd0
         TM8A==
X-Forwarded-Encrypted: i=1; AFNElJ/JQ7FvMfyoyFACh7yQ/Yi4P1RmJx0UXmd/yntGd1ct+WcgnDXynz/eOPmYG0H0R6SmlRSD4LY0kle7UTPW@vger.kernel.org
X-Gm-Message-State: AOJu0YzUWjBQEI+KvuREoaBDbj1uE+2kEZEMEY2CEPuURSCU+vatid5H
	vvEEQerIomiTouvrGBSSnubhHiOL8wAG//tJiU1z2YFnRUlHhF9xqc95
X-Gm-Gg: Acq92OErZOHkvnrnjBiLx9MR2D42qMUljFPBQ/9b6EbPy8tvhhtUQxsgtZnbrNsJU5E
	bpFp9d8WxGQwypeJXVzw5vtouXtUVmitd6jagEvIgY2B1DSFMrw4qpNWs4nuU2iTv2CvmS+SCe5
	raIt8V3324XdURlsmfkebGCzUGVPfKX8FcK86WHuxPstfjp6CrXJs3aS3FCKkpTolAejnAfwtsg
	c5rBPUFd7UcigIkd54onkdBv+5jXBSYJ8JPWo9n/Z+BwhOvZxld17ygvjsBXRCigJ2KGGZGWYTx
	1RnJ5g0jUtvQIrUqX2aLq6rQqwa5OHHANnoWmkoeI3GA2eUG+ohQeFMCAnLMhQTCwbbJ6n6z+Lb
	z2nRyTFRJjJJaxkyri6wQY/E9B1Yysz3+TWnCf2yBD3dEayZ8LuntCxkgh2FBh/+tsCwFJe9UP0
	qdWoGwSSk/G2JpTnOMGtQ0XgWpAaWCfqleKNLRhYvZX3tjf5VVBrXuEhpE+Gmk
X-Received: by 2002:a05:600c:470e:b0:48e:8741:fd3d with SMTP id 5b1f17b1804b1-48fe60ea21dmr103750935e9.14.1778935341258;
        Sat, 16 May 2026 05:42:21 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5cab882sm131037005e9.13.2026.05.16.05.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 05:42:20 -0700 (PDT)
Date: Sat, 16 May 2026 13:42:19 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Al Viro
 <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>,
 Nirmoy Das <nirmoyd@nvidia.com>, linux-unionfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
Message-ID: <20260516134219.30a30927@pumpkin>
In-Reply-To: <CAOQ4uxjX=C6WZvW1DdJ13tJj-XBWVxgE2Q9vVvHoYqiOhqW0wQ@mail.gmail.com>
References: <20260514200129.94862-1-amir73il@gmail.com>
	<20260515193010.056ef472@pumpkin>
	<CAOQ4uxjDeF3uDe=OTVZ3fK65dF148FRUvPx5fOqZpoFuGUsmJQ@mail.gmail.com>
	<20260516094242.77d20c92@pumpkin>
	<CAOQ4uxjX=C6WZvW1DdJ13tJj-XBWVxgE2Q9vVvHoYqiOhqW0wQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 16 May 2026 13:39:11 +0200
Amir Goldstein <amir73il@gmail.com> wrote:

> On Sat, May 16, 2026 at 10:42=E2=80=AFAM David Laight
> <david.laight.linux@gmail.com> wrote:
> >
> > On Fri, 15 May 2026 21:26:04 +0200
> > Amir Goldstein <amir73il@gmail.com> wrote:
> > =20
> > > On Fri, May 15, 2026 at 8:30=E2=80=AFPM David Laight
> > > <david.laight.linux@gmail.com> wrote: =20
> > > >
> > > > On Thu, 14 May 2026 22:01:29 +0200
> > > > Amir Goldstein <amir73il@gmail.com> wrote:
> > > > =20
> > ... =20
> > > >
> > > > The object code bloat would be noticeable if this were used everywh=
ere.
> > > > But you could make it a bit simpler:
> > > >         if (__builtin_constant_p(__e))
> > > >                 BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));
> > > >         else if WARN_ON(__e && !IS_ERR_VALUE(__e))
> > > >                 __e =3D -MAX_ERRNO; // Or maybe -EINVAL to stop and=
 other boundary errors
> > > >         (void *)__e; =20
> > >
> > > Yeh that's nicer thanks. =20
> >
> > Actually this might be better still (or just more succinct):
> >         void *__e =3D (void *)error;
> >         BUILD_BUG_ON(!statically_true(IS_ERR_OR_NULL(__e)); =20
>=20
> This condition is wrong but also my compiler does not evaluate
> __builtin_constant_p(IS_ERR_OR_NULL(__e)) as true.
>=20
> This works
> BUILD_BUG_ON(statically_true(!IS_ERR_VALUE(__e)));

Yes, it is easy to get those wrong - especially when typing quickly.

>=20
> I think it is enough to statically assert on ERR_PTR(EINVAL)
> and no need to bother with ERR_PTR(0)

Then the tests don't match - which looks funny.
IS_ERR_VALUE(val) should be: val +=3D 4095; jump_carry ...
and IS_ERR_OR_NULL(val): val--; val +=3D 4096; jump_carry ...
but I can't remember whether gcc manages to do that.

>=20
> >         if (WARN_ON(!IS_ERR_OR_NULL(__e))
> >                 __e =3D (void *)-EINVAL; =20
>=20
> Oh, anything but EINVAL please - the most overloaded error value
> My choice of meaningful error value would be EFAULT
> because without the safe helper we would be returning an address
> which is in most likelihood bad, so better be explicit about it.

I'm not sure about EFAULT; it is only really used for user copy failures.
IIRC at least one Unix (I've forgotten which) generates SIGSEGV when a
system call return of EFAULT.

There is also the 'problem' of PANIC_ON_WARN which is set by a lot
of distributions.
That (sort of) means than you might as well use BUG_ON() and get the
associated slightly smaller code size.
On x86-64 (and maybe a few others) both BUG_ON() and WARN_ON() just
execute UD2 (an undefined instruction) and the trap handler finds the
associated info and does the printk().
That makes the code smaller than pr_warn().
Someone needs to add a 'I_REALLY_MEAN_WARN_ON()' that never panics.
(And maybe with an option to not dump all the stack.)

-- David

>=20
> >         __e;
> >
> > The WARN_ON() will be optimised away (valid) constants.
> > =20
>=20
> Yeh this looks nice I'll use this:
>=20
> #define ERR_PTR_SAFE(error) ({                                  \
>         void *__e =3D (void *)(long)(error);                      \
>         BUILD_BUG_ON(statically_true(!IS_ERR_VALUE(__e)));      \
>         if (WARN_ON(!IS_ERR_OR_NULL(__e)))                      \
>                 __e =3D (void *)(long)-EFAULT;                    \
>         __e;                                                    \
> })
>=20
>=20
> Thanks!
> Amir.


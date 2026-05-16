Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368DF33E35F
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 20:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778963982; cv=pass; b=Z+ge1pjKtXRDQm/hDZ+E8I4b0sNm4KrpiTXj02wZd2U9EZ3wiHK2R/ZzPJATT12Gff64ASX8y0RKcVPeonfDiJMDU/MqzaO3bBPyQaiEhDLDykCRoyZ0bqV1KySt9xKAS3LwuuMf6wdGdNOV/A7yY/dypDJqrKNjW1YulB3n06s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778963982; c=relaxed/simple;
	bh=NpUiG2LWfRf8x3SP/cPw1njC6/ttXMyWGTY3THWBtik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ret/zuC7LBtlrSwLrbTDHVbISIZkXhmiF2CxjeGhAgsmU3xdXsg29L26b+EtfwzBGjV2jmJyQHd7bdi0xEP7BBNNa7GgcMRrFbP6SKIMhjWrvyRu7gdfpMWPahFVa+fEM2jDR6oqkLmO/787GDgFrtVRzmX4ii85TNTN1nxXkD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PvSO/p8W; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PvSO/p8W"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-67bc6098640so2091150a12.0
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 13:39:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778963980; cv=none;
        d=google.com; s=arc-20240605;
        b=izzeOfQOtp85bdo2qqDYUzIYOntfbjbkkXyVZiZ1XqWfVBV4HZ7uC0EagdOwewk4Hf
         p3eo8zx3GN9X22YGMQFMdsr+uXDHCSqMe3xLj9kHRuowvoudVKoeAyMcL8vsSocdmEWw
         2v7G6jXHSv5gq4+6DV/mGZT3uTA0DMYSTR5GNUclz4jpOIYVxrAry0w7ItpCMQTetB6Y
         xGxOwK62BoVLypCr/O5exvP7prevLd9obgcJzHxCltodnzpgXeMqLbaDcnaA7X7FVFh1
         ktqTGi33QKibO/hoD1oY+l1qGaXQfbVytjW4Zq2JS8HBdFaHqoFh6ObrNW/XCunwIbyY
         Oe0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K9E/Mw8hN/YOcZbEV0N8ExaCxTBWYWUJJ0rpQ46+P/s=;
        fh=xjCxTGxoUgFqxZhAjW39oAhpQssK+29btHgQSdvuQjk=;
        b=knZJ4dC3K02mB9TtcstlNLjhjBPzmlGyNLktbd1ep/Fgx+dbWY27A9NYiYW+mVmTxe
         x4RBaOq3tFjlyKUHrI4RJOpCSLYejP1zn643yFrwFf57LypRwq6avSsUODVCMwM2lweg
         /TuUIDTIUVrlhfTH+jPZx9j7X8HGOy+BiaaDuT2lQqhOEPbkBLJG9sTA10i3WVjboUZ2
         mb2CA8tL+x/i5sf4iTXkCWPQG9xeXq16lfBWZigdokGR+RBQhxM5yni6dt6zg7cxxyPI
         TIV9z8sUhDdiX8/E8oZc2bKgiBHTl1m5U8mcuPfaenjlvcZjSiAWRmfp7C7Ti00T/ZDK
         D86Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778963980; x=1779568780; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K9E/Mw8hN/YOcZbEV0N8ExaCxTBWYWUJJ0rpQ46+P/s=;
        b=PvSO/p8W3E/ha/n/c3Occm+aPOZ5ncNyXEq+db8fT73AAdbgC/Moci8l2pbxDAORWw
         qt0FVT0uMkpY7gteecnk6/mm1lmVYpLJUVCsKO13L9MDhJdFaX3kKLU0MORQi+i14h6p
         DEd5HDZUv/vMSJ4broh/MntJqn0P6SwMd6QeubWvne9PjTGf579Z8PSsHJ+UX9m8+Rve
         ViERL/3tGihcpyjDQI5gGQVOTn8AuWAjGij/QZnPS2UDZO7ETUqqJrs8XaPtCPObNso1
         DYNfiPPPz7nkFizUZ4gqfDHAVKpgt4xxSuWowUuE16JKGEBWhp3wiNZyXYqgSgv4UL73
         9Yww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778963980; x=1779568780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K9E/Mw8hN/YOcZbEV0N8ExaCxTBWYWUJJ0rpQ46+P/s=;
        b=SjwWCURDIuEz2ymReNhLInl3W20hBw+FzJck8MjpObWskOLMeNF+DFIwL0hRGptJy+
         MmYKUB8g6YyMAHDl9RNBa+0XeA+15cgJ5gBuJUkgpu0lCqigB8+YfUchP5QKg1QPqeux
         9DQXgKIO4YhhqZASOx3EpnBZE2t8t86RIehulI1eYHEK93m0XavKGo99OCaK636V6Vqv
         GV7ruqxJy7qL1rrHB8jhkLmWPsr37rR+ZwLPpaf7glzdjYl+a0+ioZEUOSKMiI+SEgkH
         IOR9xTlSyjLVBloph1hi/c54d+dqzI2Z8PU8eeb9Jc9Caz8w8MvN1O5y593/62vK2QkX
         aUjA==
X-Forwarded-Encrypted: i=1; AFNElJ8wRTCSH6okhW2Adc8myG/rv9HTFc2kqqvupayJ7SM2fwMzaqY1S0We25K0XX+7+/6nfftMGN2VEF3iWOkT@vger.kernel.org
X-Gm-Message-State: AOJu0YwBaL8jrORsLf/Z6C0mM0R8u4SjwhTBeAuu6y1N3fT/PNaweEYW
	0qMbqbFh92a9rA+bx5n8OTYZhYCzY9IU61Zqn0T533GXiIw2wMLP/72KVUDO3uevTUKK+iIkbl7
	6YbrvpL09pJr4qtfrY7izP4U2CmFWsC8=
X-Gm-Gg: Acq92OG05c2W4ozsYTW6pVu4yeJNEOGFN9cXtA84gGdzJvuCQbu0vog89IvdkbHWDQB
	lpU/u41GB5MM5ooWmur61yiRk77u2KFX0DxNqLRIUKhKa5JRTgf1btwczzIJHEV5AvZfqyWI8tR
	VyPTuAH9wmHcpNv0k93VAmSrwJMfAasy/k5Zos+wo3mo7N9zyaiSSkTu+sXLV6/yHR0umrL2ytZ
	DNg5XqZv6THPTGJ0qUtWCK818t4YNbKsoCg6NpsRDVifJtRl8YtdcTrLjREHufRb/Oki9HyzcOr
	9i4R1v52JoE0bE9Kr4Eh7YwKzqnXvjYoDsaMjbjY9KkRjHFA2IITltvXhF78M64=
X-Received: by 2002:a17:907:c06:b0:bd5:2ce2:8d0b with SMTP id
 a640c23a62f3a-bd52ce28d5amr332011466b.23.1778963979220; Sat, 16 May 2026
 13:39:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514200129.94862-1-amir73il@gmail.com> <20260515193010.056ef472@pumpkin>
 <CAOQ4uxjDeF3uDe=OTVZ3fK65dF148FRUvPx5fOqZpoFuGUsmJQ@mail.gmail.com>
 <20260516094242.77d20c92@pumpkin> <CAOQ4uxjX=C6WZvW1DdJ13tJj-XBWVxgE2Q9vVvHoYqiOhqW0wQ@mail.gmail.com>
 <20260516134219.30a30927@pumpkin>
In-Reply-To: <20260516134219.30a30927@pumpkin>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 16 May 2026 22:39:28 +0200
X-Gm-Features: AVHnY4JIVMPrcF1z1Raum5tdKskVMH3kvk4vrLEhP0KOwJSQHZRt97H60ncn43M
Message-ID: <CAOQ4uxh3ABUAN8Fwk02YAVtfsACEPgu3qX2LSBhhj-chGvi8tA@mail.gmail.com>
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
To: David Laight <david.laight.linux@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Nirmoy Das <nirmoyd@nvidia.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 2:42=E2=80=AFPM David Laight
<david.laight.linux@gmail.com> wrote:
>
> On Sat, 16 May 2026 13:39:11 +0200
> Amir Goldstein <amir73il@gmail.com> wrote:
>
> > On Sat, May 16, 2026 at 10:42=E2=80=AFAM David Laight
> > <david.laight.linux@gmail.com> wrote:
> > >
> > > On Fri, 15 May 2026 21:26:04 +0200
> > > Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > > On Fri, May 15, 2026 at 8:30=E2=80=AFPM David Laight
> > > > <david.laight.linux@gmail.com> wrote:
> > > > >
> > > > > On Thu, 14 May 2026 22:01:29 +0200
> > > > > Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > ...
> > > > >
> > > > > The object code bloat would be noticeable if this were used every=
where.
> > > > > But you could make it a bit simpler:
> > > > >         if (__builtin_constant_p(__e))
> > > > >                 BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));
> > > > >         else if WARN_ON(__e && !IS_ERR_VALUE(__e))
> > > > >                 __e =3D -MAX_ERRNO; // Or maybe -EINVAL to stop a=
nd other boundary errors
> > > > >         (void *)__e;
> > > >
> > > > Yeh that's nicer thanks.
> > >
> > > Actually this might be better still (or just more succinct):
> > >         void *__e =3D (void *)error;
> > >         BUILD_BUG_ON(!statically_true(IS_ERR_OR_NULL(__e));
> >
> > This condition is wrong but also my compiler does not evaluate
> > __builtin_constant_p(IS_ERR_OR_NULL(__e)) as true.
> >
> > This works
> > BUILD_BUG_ON(statically_true(!IS_ERR_VALUE(__e)));
>
> Yes, it is easy to get those wrong - especially when typing quickly.
>
> >
> > I think it is enough to statically assert on ERR_PTR(EINVAL)
> > and no need to bother with ERR_PTR(0)
>
> Then the tests don't match - which looks funny.
> IS_ERR_VALUE(val) should be: val +=3D 4095; jump_carry ...
> and IS_ERR_OR_NULL(val): val--; val +=3D 4096; jump_carry ...
> but I can't remember whether gcc manages to do that.
>
> >
> > >         if (WARN_ON(!IS_ERR_OR_NULL(__e))
> > >                 __e =3D (void *)-EINVAL;
> >
> > Oh, anything but EINVAL please - the most overloaded error value
> > My choice of meaningful error value would be EFAULT
> > because without the safe helper we would be returning an address
> > which is in most likelihood bad, so better be explicit about it.
>
> I'm not sure about EFAULT; it is only really used for user copy failures.
> IIRC at least one Unix (I've forgotten which) generates SIGSEGV when a
> system call return of EFAULT.
>
> There is also the 'problem' of PANIC_ON_WARN which is set by a lot
> of distributions.
> That (sort of) means than you might as well use BUG_ON() and get the
> associated slightly smaller code size.

Come on. For real?
I might as well use BUG_ON() which is strictly and rightfully
frowned upon instead of using WARN_ON() because some distros
choose to do PANIC_ON_WARN?
That logic is backwards.

> On x86-64 (and maybe a few others) both BUG_ON() and WARN_ON() just
> execute UD2 (an undefined instruction) and the trap handler finds the
> associated info and does the printk().
> That makes the code smaller than pr_warn().
> Someone needs to add a 'I_REALLY_MEAN_WARN_ON()' that never panics.
> (And maybe with an option to not dump all the stack.)
>

Well, the whole point is that I would want to get a stack dump
if my code was doing ERR_PTR(<positive_value>) because without
this stack dump it would have been really hard to understand
the conditions that caused the regression in the Link.

Thanks,
Amir.

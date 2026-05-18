Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF4C31E841
	for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 09:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779097943; cv=pass; b=m088kegMmzCJUYfGnmNHLFh1SeOL/DSK9+Z3yPGt0gnAfi7fI9fcUZAIpn2v64v2llZshssKIgjg25hKqzB64Iv6PLLVgt6xYOp0YuD2zsxan+9FmByxEpOW7AN+IKuNKYe8b4uHi7mQ9V3J2KtlmmrsDBRPTvFfXcuACFLONyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779097943; c=relaxed/simple;
	bh=KigKW26hzOXOk0DnB5iTtKWzFWSQ3TghZ6TRctLAp5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aOiTkMhn2awe+aPG0hkJ0llvaRVTh6T94ua0WAWE8MufaOqU0R9ihMrqrBV5QAE7GYNZKY41Nfko6K6EVW3YC4tYuIwakrvpuSiBWX/N2hQ11bXIR+kqMIa6Ig3ASlStqn074HQfXk+r6bErYRCxyJg2BgdhXdjNVGPxZsZ2Ydk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G+t4bJdH; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+t4bJdH"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-67da63ae541so4593470a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 02:52:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779097939; cv=none;
        d=google.com; s=arc-20240605;
        b=Ch0WISvSe3E66pNZmMtHfQXE0WAvsgqRQXaaRspAfwccDwkVgjPWF++tUeFDfOdPdF
         M+/i8Q/VPydr48mVJgx9Tlvdk8hqbbW+/y8t6AcMpj8AmLCP1jZChAT1C35aIF0BimX9
         vCiyKy9hoC+4tjUXFmmxTRP5Dqe1jKluiHRgFdREM3TZw4jAOmUYMdbqyuWmf0bVv3sw
         b2YaQlKYxUIEmFj0hjUn2OXPqsEHOSg44G44F3lBdfED5Vi73u58Zw1MTakY+kPU9A8x
         ORl67T6xeHGvHWyWYDcG7KeXhQPbqQ5Tf4kdRTWTa1vCJ37Aa2LjbBqTzdd6k2oZrGJT
         FUdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9r9CYEpqvhF152363w7YhgQ/z6cpm6LzbBUZimMW9FE=;
        fh=eXjnxF0s4GVs4afY/VPJkpnlx6bsHoaNeau+aeR6gW8=;
        b=ahSSXq0nD/FEvQamtP/hdghVQW5GrtkJAbWL1+Gq3hgV/FkEOBsbY2RPHWccgXx7Bb
         9bfXiwO+In/dyfoBBOyVtBKMKaHaGRFvUWZdd8xUTlzKB4J8SID86YU9Bsu3a0QwEwBc
         ppqpeCUf6jsTaLQ0YY5MVJuDjkhpTACxvAjlaXpO60sywLoITeOHf4/LIgTQ+QsEYRZ0
         86QPqQvsjUelQDvcddv1f1h7mGDRSk81I3H7A5r0QXwIb6aXom3lfRV+dLKSDn+3eCue
         h/1vWC/05826TffCIwFJcR9kFxhykwRI9bZtE1lYMaoschMKxlM4HHAB7Jp3vPYhWjDu
         YxZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779097939; x=1779702739; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9r9CYEpqvhF152363w7YhgQ/z6cpm6LzbBUZimMW9FE=;
        b=G+t4bJdHNIiNBmk3x6Oo2jyowWleK6jKauumuaT6c/BAMz7S7MLI2eNJj2BP7paU6d
         9wZGCjHDp5LJuqj+hmgcTydWGS7SgVjZLY1Zvajc+L8JeIUcCbHI1wqseInJWUPSpdPs
         +byd+1Lhic4sHk33DSSXv+eESIYu0IfLRslBQPeqMwIVXpt9c6qLUHqMb8lw29wqLbuo
         3vZphWg9H404y0b6OzINYfPPGy2SLY06+eS0XJepCKMuF0+k1KGcZfQh3dNo744UzH6s
         mbtfI481TZgLd8k+OY1i4wkIEvOPtJ4hUFHzQCF8mDqev+BfFgIn54rToossEBpQvWI3
         G+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779097939; x=1779702739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9r9CYEpqvhF152363w7YhgQ/z6cpm6LzbBUZimMW9FE=;
        b=LeHdmBwSlgeX2fI14yAJ9uSrnq7VtL6GdUOZjAy9Xoyd5MLbJRjhBeKUCjraXeiUa1
         vhyS2SqObirNHN6MYGcQivAHXFud1zfIQA4d787R57gysmu3D4xDMHhHXhjD2BA5XPg7
         3CdAna6gN4BO10cFm4qVJsdXZG+mFBL0ERPkUDB0ha5AZKJI2c+oNxGY2uTxMdQ/DnAB
         CDAD4DN1PzTYTbSCYwq8EefFbTFQ3U56rIIfhrIC+8cEpSEbcu799UMfQb/nqVQ1s1pc
         w+FxFxW8YBLEG2XUyBZf1lrMxCRZiz19sG2wAmFGa/0T0YPav8GXhHaQOL5NBg/hOoNU
         usPQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ZrgxW1bVSXZinaa8vQs2GcPj6g7clcytuAjE4T722Bgs31zWCAaKQnM/5oYcSozpeRa6gj1mF/2VNfVyk@vger.kernel.org
X-Gm-Message-State: AOJu0YzcKrMOoJDZUY1u16suduWh8mGOOZw9vBL6W1F/Kyu5qpm4aYOj
	x400achF49OTFIHsJUYlStNCvR/is4dD3Uxmp1INVhPfXDjyVZcASJhycSLG/nRFFVw1pHbHq8g
	N70vVjTNB1u7ZWWL8YBaVe6CGKwceErY=
X-Gm-Gg: Acq92OFeX10rVZeXKGAue1nlDnz5xaQjnY8E9gVqSmEm+lL7wBDbsqYCCFCZ9iY/Pet
	RwQyWKX+lUDNSCuQ1zzkqQa9EclDNAs7I7CgOWF+OAMPjWidnQjlaC7CGJqJzFLEBD1FEk5HAr0
	fxeSE+6FkoNg215TaCV5ZWY4q+s43dPgIz4xbmd3DZRujfCy2lm7lUicgmcWUR89xWBewQ2HyF1
	yf9q8rRmvdavbwsk7qygH9JXmfFcOxL3piZWwanELVhQut0bFA9KfMPFeoNCHdM5z54/xfrY+id
	p4hsKPfJ3LIasOyBrqok9mk8HCqAuW8Y5Dm5DWtUqg==
X-Received: by 2002:a05:6402:304b:b0:678:e6a9:c39 with SMTP id
 4fb4d7f45d1cf-683bcd9f43amr4810104a12.13.1779097938863; Mon, 18 May 2026
 02:52:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514200129.94862-1-amir73il@gmail.com> <20260515193010.056ef472@pumpkin>
 <CAOQ4uxjDeF3uDe=OTVZ3fK65dF148FRUvPx5fOqZpoFuGUsmJQ@mail.gmail.com>
 <20260516094242.77d20c92@pumpkin> <CAOQ4uxjX=C6WZvW1DdJ13tJj-XBWVxgE2Q9vVvHoYqiOhqW0wQ@mail.gmail.com>
 <87se7pdr7a.fsf@prevas.dk>
In-Reply-To: <87se7pdr7a.fsf@prevas.dk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 18 May 2026 11:52:06 +0200
X-Gm-Features: AVHnY4KWs2vUCH6jUzS1W7hr8zsGFJwgra5DKB_XQHV-YlVobPgAcA2P4f3-R7g
Message-ID: <CAOQ4uxj0sgB5B+1gzzq8fPuAPJxU=TfXMUaJtjB6vdfXUSOuqQ@mail.gmail.com>
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
To: Rasmus Villemoes <ravi@prevas.dk>
Cc: David Laight <david.laight.linux@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nirmoy Das <nirmoyd@nvidia.com>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 11:04=E2=80=AFAM Rasmus Villemoes <ravi@prevas.dk> =
wrote:
>
> On Sat, May 16 2026, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > On Sat, May 16, 2026 at 10:42=E2=80=AFAM David Laight
> > <david.laight.linux@gmail.com> wrote:
> >>
> >> On Fri, 15 May 2026 21:26:04 +0200
> >> Amir Goldstein <amir73il@gmail.com> wrote:
> >>
> >> > On Fri, May 15, 2026 at 8:30=E2=80=AFPM David Laight
> >> > <david.laight.linux@gmail.com> wrote:
> >> > >
> >> > > On Thu, 14 May 2026 22:01:29 +0200
> >> > > Amir Goldstein <amir73il@gmail.com> wrote:
> >> > >
> >> ...
> >> > >
> >> > > The object code bloat would be noticeable if this were used everyw=
here.
> >> > > But you could make it a bit simpler:
> >> > >         if (__builtin_constant_p(__e))
> >> > >                 BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));
> >> > >         else if WARN_ON(__e && !IS_ERR_VALUE(__e))
> >> > >                 __e =3D -MAX_ERRNO; // Or maybe -EINVAL to stop an=
d other boundary errors
> >> > >         (void *)__e;
> >> >
> >> > Yeh that's nicer thanks.
> >>
> >> Actually this might be better still (or just more succinct):
> >>         void *__e =3D (void *)error;
> >>         BUILD_BUG_ON(!statically_true(IS_ERR_OR_NULL(__e));
> >
> > This condition is wrong but also my compiler does not evaluate
> > __builtin_constant_p(IS_ERR_OR_NULL(__e)) as true.
> >
> > This works
> > BUILD_BUG_ON(statically_true(!IS_ERR_VALUE(__e)));
> >
> > I think it is enough to statically assert on ERR_PTR(EINVAL)
> > and no need to bother with ERR_PTR(0)
> >
> >>         if (WARN_ON(!IS_ERR_OR_NULL(__e))
> >>                 __e =3D (void *)-EINVAL;
> >
> > Oh, anything but EINVAL please - the most overloaded error value
> > My choice of meaningful error value would be EFAULT
>
> Could we have a dedicated "EBUG" that can be used to indicate "there's a
> bug somewhere in the kernel, we can handle it somewhat gracefully here
> by returning an error instead of BUG(). You can't do anything about it
> but report that you got -EBUG from $this_syscall", instead of
> overloading EIO, EFAULT, EINVAL or whatnot. Internally, EBUG could be a
> macro that did ({ WARN_ONCE(); -__EBUG; }) or something, so there would
> automatically be bread crumbs in dmesg if it is ever hit.

How exactly would you use this EBUG() to write the graceful handling?
A bit of overengineering if you ask me.

>
> Userspace code could also benefit from having EBUG to indicate that some
> internal inconsistency has been detected.

So what about

#define EBUG MAX_ERRNO

as per my suggested patch.

Thanks,
Amir.

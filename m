Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16199384CD5
	for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 19:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778873180; cv=pass; b=HSCKTfTP+J0dqpeG5G4GYTVRDypQq9xmyEnzhkb4A6sGZL2AhdOmx6uauk+vyEaY7bIkw8EkqYwMZ55L/eNU7skZJIPoJJ5asrz7/dhb8y9CYFD+wBRlFxfD+ss1bg2sHe2nGZyI2BAGdEizR7HJJTND1U0ML2O6q+ARVWNyd+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778873180; c=relaxed/simple;
	bh=Jtgk4bHY8pKuFBHiUXn1hiwti3fQNpoFd2aLiayn518=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pys1t+esIjp3IGbRnXcEz2liHDhemIurDRuwlWDHqpYwN9FSZ8d+d9k2Ww5L6lpN4x49vx5Zsx50qtmBmcIZeoSee8CPzihzkxu+/37CQvBovDMenUppGUeYMILuiu+/frLRaQk/kq+YQogHclZFWl3fjSbjNDeY5TAqDpOm41E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KNEOZhV3; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KNEOZhV3"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-67e9b3037dcso468907a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 12:26:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778873177; cv=none;
        d=google.com; s=arc-20240605;
        b=KfxHBv5AyNlbZnyDL4o3LRIMa+OE6AhzM38vSfyJ/A0VDuEp3WX9QqdQLS4OKDjhRH
         4IbumVc0/vaIB7hsUKsZj3pMIlKas5eOToMMnI2Jk2TXHMe3r4x8XMyWSem6fubJINaf
         sLRpqMPxFDY0zrnzofaepItSdgy8tOLQOWo9crF3aRAByNozCcSUftQXmwOY4/kYWvR0
         tIKOuLTVxW3SR8e4tHrRzGGAvTrasKdbO/zUjFND6FETpI43gTrs6Y3NkAGLrmsade9d
         ByoQY/VT62eJUoXbMZ5QREhcfhgydzkN8AFn+KnG/VB4WJ0owQqmaX0GqKNfikSh6SMz
         L62w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jiIo+3Wea/nIZVC1zA+sluKhGCgnPapnZDBPldsE1Bg=;
        fh=yOLuNjYXe9FCBV6K55wN2KkqP/GzMLAy/7/DiZuSeSQ=;
        b=SKK0wY+8NZfy25JwBpttELumq64HexDQ8HUfpUiZnVvvM2r503d58B2adIqZ+oVgtI
         YE5VUn+BWHAmRfSFMVLsieqwPxfzhg2T9qVzCcI7Tda9d3P3mKkA8QJPp6t4IvDYaoT2
         FGsCfpmmsaIJL1sVJSJRdOLSipH1GYBuyLwK3b6oj6+Ye/96WjP6fzgigiaI6La7OsXf
         QH6MXhUslJ/mwFINpTJw4MEAhtqtr+N+uSPm4DpC3BKs9/q4WqvEgbd5DS+urnvuoqvp
         JGJdNOZ1f5qLqQU1vnV2s7UY6U71RFod+B9IoRsU3LgANMCcWJzhx6yMamsPvcA/Vf7h
         roCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778873177; x=1779477977; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jiIo+3Wea/nIZVC1zA+sluKhGCgnPapnZDBPldsE1Bg=;
        b=KNEOZhV3vckTHGPSL3T0pkLMJmzkD4dwVdJjEGhZJXUiWmF/94ElGUFyWobYFZFy5E
         Qc3jh92SoocE5UJLywIeNzVcOoUsedHIVN0jGYzPi4aCgD1hZ934FIC7IY4bJqsDRhVj
         jHrgGhWnAyUoFqzYEDTPlg3FcKep4Zi8SGL7cczwtd4YgYWPQiApcqVscJxYCC8EkZkR
         Jn3DzLZXZFUITVBLdvgthrTNZtHC6qXWDUIxaE8azwPOzJze23NBJAji5rbjtgQsa9Nt
         UNbwz2wm3yFsDQqO60rc877ln7IyRkZ9BWaqL16Ezp/N8n+9US/zmkYZ6Bhcus3kCeaZ
         VsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778873177; x=1779477977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jiIo+3Wea/nIZVC1zA+sluKhGCgnPapnZDBPldsE1Bg=;
        b=DzhszMbgW0OUiA4HLEVCjVBg5+7/rZOENPlXjwEeCVo1UfE25DLHUO/zsmeYEDHRa6
         82hfIlW6owoatGHwHNCjcMcO2b6+jj/2NI9OMsIWHc0yuejWDA4QQ6ZcwUUT/CBfa14b
         XaaWr+BOksXvbXuh1cIj/umhrbEagCnh0nNkbH93ilDYe4ZcJV62vvDNhJ7MNXz9mWQH
         ZpbaIVB7hnIDI5zLRgbRUuDBsajm8PX7uQCdA+6Jv1h8jhPKfOPOF7OZ/L6U4PoDu6Ko
         wASvi5Z2c5fHBe/mL4V+iWO+jtZh0lFkHCU/TeGUptWYw1AgDa4nmgixCgZXifL5kaL9
         ++9Q==
X-Forwarded-Encrypted: i=1; AFNElJ/SrxTmchcN/vVKT/mSmxE6VHB2xlZSUQLZLiFhUSLOhCpcLB2yvOCsH3rgTsSSCjP0k/osShNA/UN35gIY@vger.kernel.org
X-Gm-Message-State: AOJu0YzjLWEsyNjqMCJJYZD669+2ll8MqqP/g6AD0fdENTsVvt/CCeoc
	OBFcvhIFkDmN+E2GNdo1CBduyoiWELUXsgd1hM9A+vfzVT92tlsa/+L9YMUxod7ciUyUG2bkG1e
	2GoETz2drMFLq6tKSgrQ03xeOJgQ/iCr3ux8O
X-Gm-Gg: Acq92OHaw19k986gw0tFd7g+iLUNMDN98Tren5+P+upMLjn38DkE/8FIr4vvsZT+LU5
	pRn0qxnl5Xz6l33NXIE9UmOKQkjy1f7hNQtYQwva1pTJHCCO3QGXpVS8DvtuWtWlzBXPHjDUUrI
	Q2GDTYQ73uPoekyMsFo8XyiCqOjv6IECZjtFhTggW08yyaPo97kEMO5XLiPIXPZ2fWx10w85DAl
	WI5GTSPy3Rh9OnDEBocyJCZ00jXlvEFc3iHidKhaVGoO9U+juO1yxSyvpxCH713I3Q7Opp4YtIA
	F7+kY2ozL+JoMhGFY8i2g50V50F08FDl+g04D0WOiq6jcVEOU9KL2DvKofkhZRY=
X-Received: by 2002:a05:6402:4307:b0:683:ac2c:c9d4 with SMTP id
 4fb4d7f45d1cf-683bc1baaffmr3088704a12.5.1778873177226; Fri, 15 May 2026
 12:26:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514200129.94862-1-amir73il@gmail.com> <20260515193010.056ef472@pumpkin>
In-Reply-To: <20260515193010.056ef472@pumpkin>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 May 2026 21:26:04 +0200
X-Gm-Features: AVHnY4KfupsRDCYO_GrvkrSFtkgr4LmPQOfCXSSMuhckYtDQtaSoNxEd8px8-G8
Message-ID: <CAOQ4uxjDeF3uDe=OTVZ3fK65dF148FRUvPx5fOqZpoFuGUsmJQ@mail.gmail.com>
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
To: David Laight <david.laight.linux@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Nirmoy Das <nirmoyd@nvidia.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 8:30=E2=80=AFPM David Laight
<david.laight.linux@gmail.com> wrote:
>
> On Thu, 14 May 2026 22:01:29 +0200
> Amir Goldstein <amir73il@gmail.com> wrote:
>
> > Code using ERR_PTR() is almost certainly intending to produce a value
> > which qualified as IS_ERR_OR_NULL(), but this is not the case when
> > code calls ERR_PTR(err) with positive or large negative err.
> >
> > Introduce a fortified variant of ERR_PTR() whose return value is
> > guaranteed to qualify as IS_ERR_OR_NULL().
> >
> > We add this in a new header file err_ptr.h which includes bug.h
> > for the build/run time assertions.
> >
> > Subsystems may opt-in for fortified ERR_PTR() for specific call sites
> > or by #define ERR_PTR(err) ERR_PTR_SAFE(err).
> >
> > Link: https://lore.kernel.org/r/CAOQ4uxg=3DgONUh5QEW5KJcyXLDF15HbLnc9Ea=
7RKPcgtyfPasTA@mail.gmail.com/
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Guys,
> >
> > Please follow the Link to see the sneaky bug that Nirmoy tracked down.
> > syzbot has complained about this a while ago, but neither me nor my AI
> > helpers were able to track it down from code analysis.
> >
> > Honestly, with AI review, this class of bugs (return a stale err value)
> > should not be happening anymore, but it annoyed me that ERR_PTR() can
> > return a value which is not an IS_ERR(). It messes with code flow
> > analysis.
> >
> > What do you think about this macro?
> >
> > I intend to #define ERR_PTR(err) ERR_PTR_SAFE(err) in overlayfs.h
> > to fortify all of the ERR_PTR() in overlayfs code.
> >
> > What do you think about this opt-in method?
> > Any reason to make this more widespread by default?
> >
> > Thanks,
> > Amir.
> >
> >
> >  include/linux/err_ptr.h | 29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >  create mode 100644 include/linux/err_ptr.h
> >
> > diff --git a/include/linux/err_ptr.h b/include/linux/err_ptr.h
> > new file mode 100644
> > index 0000000000000..829ec5f771528
> > --- /dev/null
> > +++ b/include/linux/err_ptr.h
> > @@ -0,0 +1,29 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _LINUX_ERR_PTR_H
> > +#define _LINUX_ERR_PTR_H
> > +
> > +#include <linux/err.h>
> > +#include <linux/bug.h>
> > +
> > +/**
> > + * ERR_PTR_SAFE - Create an error pointer, with validation.
> > + * @error: An error code to encode as an error pointer.
> > + *
> > + * Like ERR_PTR(), but validates @error:
> > + * - For constant @error: fails the build if the value is not a valid =
errno
> > + *   (zero is allowed, producing NULL).
> > + * - For variable @error: warns and clamps to -MAX_ERRNO if out of ran=
ge.
> > + *
> > + * Subsystems may opt in for all ERR_PTR() call sites by adding after =
includes:
> > + *   #undef ERR_PTR
> > + *   #define ERR_PTR(err) ERR_PTR_SAFE(err)
> > + */
> > +#define ERR_PTR_SAFE(error) ({                                        =
       \
> > +     long __e =3D (error);                                            =
 \
> > +     if (__builtin_constant_p(__e))                                  \
> > +             BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));                \
> > +     __builtin_constant_p(__e) ? (void *)__e :                       \
> > +             (void *)(WARN_ON(__e && !IS_ERR_VALUE(__e)) ? -MAX_ERRNO =
: __e);\
>
> The object code bloat would be noticeable if this were used everywhere.
> But you could make it a bit simpler:
>         if (__builtin_constant_p(__e))
>                 BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));
>         else if WARN_ON(__e && !IS_ERR_VALUE(__e))
>                 __e =3D -MAX_ERRNO; // Or maybe -EINVAL to stop and other=
 boundary errors
>         (void *)__e;

Yeh that's nicer thanks.

>
> The check for constants may be fairly pointless.
> One of the static checkers may already detect the obvious fubar ERR_PTR(E=
INVAL).

True, but I figured it didn't add much overhead if we are placing
the runtime assertions anyway?

Thanks,
Amir.

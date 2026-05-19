Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9214E3774
	for <linux-unionfs@vger.kernel.org>; Tue, 19 May 2026 14:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779200286; cv=pass; b=dxUmFGhr75fQG7xz4yzz+56O8kVnOjq0s7qhUuGNcP+MOgEjwYuGI9F8gQqN59n5hZXPfQ0Xq/b5hlYFw4tHqnmEbC7GEwmYC5bD7509PrwbEBCp/TyqZPF3PpYaUbD01zLTA6m6qZPd4fX9bUNpYXlZBfVxPBfrSG2qCXdMJW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779200286; c=relaxed/simple;
	bh=KcpyWR9ztcaYoVXnyA8OVvjUi1zJWAvkQ8opvq0mx7A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MNiEdye9lyQHI+orBcl1Z6Gs9CZ3ddGlZ+9meSPmpqs4H4fbMYdZzHwV+TabB/Cm/cRLeqBpswFNCMDvHY+HORHfFFY3YmIzKXkqurAbelVksDHOO1cgvmJkWOUv5b7P2CNAJCTEgTLcMsGXnnHYtaepkR7A+13JxWAUhwLkgEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K0vstjUE; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0vstjUE"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-672645dbfeaso4924349a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 19 May 2026 07:18:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779200283; cv=none;
        d=google.com; s=arc-20240605;
        b=BtR13Cggd8StPJoh+3/Fws0mTDqXQW4zlMvmU8EzS1yKqD2NPwQxXUvjcftDyup9ME
         rubzS7u6ungV4ljf7+kgRuQ4b7pdVlQ8jMYOPcKOO6P+lu1toHvnzBkZ9ZDACxYdEkjU
         eDAddPZBuun7qritTFPVJTzQy5VG9Odc5RhSBrtmNvptEx7icSXbjArthxdz8ZXY5/Bm
         8M68k6cdu1Si7jZaY9qPf09QgAxng+Sgatg3nLc+gKiCQgnyqC/ZA0e02ieiELvJyQiK
         hWd6QeiGA8Xm0v3dga/lR2v1zaj3WtEXGkL/tGUanzEqmi4J08+/3MQ2/PH3Vu/e/w1Q
         VGRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KcpyWR9ztcaYoVXnyA8OVvjUi1zJWAvkQ8opvq0mx7A=;
        fh=tTs5yo1LA44q6A7kifgAuuKKbQQmXV1JkOZgGstq91E=;
        b=hOZwtw4us0onkWzbboi8q4PlHRYkejU9yBwjgtzNLPISeeW9y1do6rvfFJ38HhzS9e
         sqvKm8uxbQD1kDSTVR5WWfVsAiB4+NLizUSwrwniG4Hyv3C5J/ekjOmtYk/1aQQxQ7pA
         HvYKeWCCqaZkZkJ2YRhsQoxB0QTjlCAeQUCFG3RrFwn2g7WKx7zhe+LBAT1HLVpqx1lZ
         oT6tj0hOEa5w9OT0qK7Tmf/yayQEqfO7F2uTK/wQfe8454GMdWvC3iKrcf208tJ+Ck+g
         g+/+WmRg20UGAEfMNaVIAmOzvB0FuUBNpbn/MH0zuUo6syVuy3SEpnQYhP+8pVFpjw2L
         38qQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779200283; x=1779805083; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KcpyWR9ztcaYoVXnyA8OVvjUi1zJWAvkQ8opvq0mx7A=;
        b=K0vstjUEfReZPOYJ2gyGAQ7x10BHykOP8rrN6sNb+qkvjXwzQrzO5NQ1sXMenRyaQK
         GgH96l4gy2eM1UWaWotUl/wJuBPWhDrgn2Fz8g2jbQ+wOCsEmDskuJp8qVQy1tqQ4iXX
         ozZ9KUu2zmjveYc/b+f0cPIuSNbTgJVFfEBQBYtBimym109O0o45+qTumPfqPNnfuERO
         xlBDFudgR72m7LODl0IBNl1YmjSHRt5UlNhmcP/YXfXvxzyqMHzD6YVANa3r+c4U9dg2
         NKH3WB5cY7sfyGBzfGMBhOOxAQXmD9dPJDgCsUK+dNHnCYc96lFw3R0SWHJlBLbGOA7P
         GQMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779200283; x=1779805083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KcpyWR9ztcaYoVXnyA8OVvjUi1zJWAvkQ8opvq0mx7A=;
        b=Ou4EWTzAdhahBZZSGjwUm1MYgGuJPO4xIOz2KYHbRTvZRgn4+CUyWaoiD9Rp2f2+km
         3LWjYgD/6KCHTG09rlGV/gS1Fdu/+ILR+AoRrZUZWvaGG+++TlflNfdTZtb28JV9inEF
         wXbGnk857x24z/6fNR21Y1JCEKktJ2bFBorbW76B5dFOJSgsC0awFa+Mv+mhgbETVwhr
         aNAARv3cU91oFd9KpUjTRUNhf6Ldaqanyg+CFuKGyBz2GgohBayqGqOi/puy/K9wC2pq
         5rvR1j0n1QT4OH52cN87t+YJEY40OspAyQwfRMfIyoTBMwdUSdlhM4PKzpgfZTufg9L/
         xq5w==
X-Forwarded-Encrypted: i=1; AFNElJ/4Tcou+0BqFHmXYYSunsvBc5HK4OiIByDma7e/jXZHrQHHok5ktAuBmEdQD0Li9rYT4QS8yQhnjh9IFCfT@vger.kernel.org
X-Gm-Message-State: AOJu0YycchH9f6yfi7Fvfezw+WjYippJ/DR2ySHETxwg8LYSJCcrYJEk
	FlXVzMmz/a9PmoQd0FT4Nr7wh/7wozNJX2QAqcbodFa/Yck6USUkidDtPCX5rwOiQskjVjA+Evh
	gGR8fgWA/UIlUh9uA+Y7lg+yHOcIXNoE2rVSN
X-Gm-Gg: Acq92OFunyb4lmKtpAr3uqYm9YcTs91VgpQ+dGAFcGiSxdDI55gZXFTnSDiwkBf91zz
	mmyg/koY0EckKlCivoPsYjLKSzk20VrFg3FuAG6juWfCl5HLPMzOhJRgnrjs5uhrcuV3vsXBrlJ
	tw5eGP164Hty5bD5pdfAVvxr5PXfYsqZxp6Rxu6Xyak18CBLsNqQmb0z94UrtpHmDftMuQAY/jM
	6Dujz/C+OqJARpN3xi7VbLGb4Quro8yMWcTty3mZxbWJQcKH0brOSmmlLhWZTYTTQf1crU6Vp0e
	TfZ5tt3VgrN/bk1SRWG97PrbMj37vXNVxGicKpcn5ESI2LIdupUz
X-Received: by 2002:a05:6402:5cd:b0:67d:9f52:a78b with SMTP id
 4fb4d7f45d1cf-683bd57fd40mr9672772a12.19.1779200282625; Tue, 19 May 2026
 07:18:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-13-joannelkoong@gmail.com> <CAOQ4uxjMPPp-R37yKoOs1kGUdAOmnp3keVWvfuxi1r8jrxAcTA@mail.gmail.com>
 <agjDGBQPG2WpDTWO@fedora.fritz.box> <CAJnrk1b_55hMTRxtV8QKBqdfEhT_LQK2byat+x-a8Xrj4nicnw@mail.gmail.com>
In-Reply-To: <CAJnrk1b_55hMTRxtV8QKBqdfEhT_LQK2byat+x-a8Xrj4nicnw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 19 May 2026 16:17:51 +0200
X-Gm-Features: AVHnY4LJ3qITr02ccj_9_VFQZZh950e9967B6nCn_Ei3xCEomL4fDgP18jZ8FDk
Message-ID: <CAOQ4uxj+ss82jZV6yq=LXag2s_ax9rVdtH9uc8W+RnRD+U5qpg@mail.gmail.com>
Subject: Re: Re: [PATCH v2 12/21] fuse: add struct fuse_entry2_out and helpers
 for extended entry replies
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Horst Birthelmer <horst@birthelmer.de>, miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 1:12=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Sat, May 16, 2026 at 12:29=E2=80=AFPM Horst Birthelmer <horst@birthelm=
er.de> wrote:
...
> > Hi Amir,
> >
> > I see there is a lot of talk about using the compounds in a couple of d=
ifferent contexts.
> > I really have to apologize for not having the latest patch ready by now=
, but I'm
> > a bit unsure how to do it.
> >
> > I'm not entirely sure if compounds will only be a thing for fusex or if=
 it will ever
> > be accepted for the classic FUSE.
>
> I'm not sure what the plan is either. I think this will get clarified
> on Thursday hopefully.
>

Wait, is there a FUSE call? I did not get an invite :-D

Thanks,
Amir.

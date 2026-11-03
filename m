Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793740770;
	b=K0ncaIH+iCLWlxHjQtapUXwE5Zoi/C6/pGRa43WiZdikFIJ81TE0ZYjkhXP/vPyeZ5AR
	 Aqo89bMlwtcFfLJRkQZGa3LUfzx/38UCj2ejaP7fVApycUPaHZnyuIFu83ymVux+FgFRx
	 dRAp2qdGwQbjj2ieFfXnGt4IvuAemlamqs7y1JbXSEZRbhleaMKsdwA8rQ1uSKGBiNO7z
	 4/c0m3j6lGekJIOtd1F3I5NpZDB+cymejLOOUoR/c4R2WeoufSwtkGypluaTHUuWkl6XS
	 dAeRb2KdMMN9nQOV/tftOYOoI2fJEGTs/uZNNPyBELyJoqNPE80/jE2hHPVoandwxLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793740770;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=E5djs837Oc0mgny3OGd4HuTw/22BWE5GoWMv7ehHmb0=;
	b=KbWsiUoLK2ROMfYyukjRbBihn41pk+agF999WwuVg9sQEhPaMwKXy499YLYMZPU8Ubc0
	 FWDtbCyPS9PM/7z0lxu5TGYKSLb24oneaDGlTTCOD70lrlpbR8C5jsaKtio3gbnLkOvqZ
	 o1i7zn+IJXDsMD0yA3QlguhR0ne73ClwpPLTEcb1EjlWW7bKohVzlVdIaONxA/8Esrs3R
	 JVWprgvuE1KiimC7tICigGtWFnXhUPqpCJpVDoQrYKK2l88rL2nWNaIElN2K0b/omyuhO
	 /EvT+u5bcqhRRuREr5BBJMZ6Oi3O9gO+pR440Yx6dwKLfdU/WLpODCukfRM8d1OB7Hg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BYxaItvH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EA1606A324
	for <linux-unionfs@vger.kernel.org>; Tue,  3 Nov 2026 21:19:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85EA1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BYxaItvH
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6acb9c018ffso1846573a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 03 Nov 2026 13:19:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793740769; cv=none;
        d=google.com; s=arc-20260327;
        b=kdOz9OaxrFCz1+Gz7BIG+3IaoTZBPIR82+BNbq+FdaPkr5yV6EqXJOvHVliVvR18BD
         KXr3oDo8sL31eP6IvNaxjI+e5DS3wQmgj9sV2wyQEn7UwI7WTTOAhsLAQ4IJki+LmJF5
         FLa3xRIa5fPPfi5Kdxx0+GGy7lF7u/l7QT5r3VxMhdp/ZMs2U5Gg0D+kFP/OzMC8J6z1
         UIW/oHGE4Bg89j7OzZvtmOPSxjW+3dEgbjFLsbpW19fueflDjP3SF43GJOSYyEieSTmU
         N8C1mwbplhE63S/UEd6ilkTk5JOEeUVUUe1GcO8CbP4tsy4xWvC6RqORJtxGvkyP7RI2
         +i8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E5djs837Oc0mgny3OGd4HuTw/22BWE5GoWMv7ehHmb0=;
        fh=jOTLZ5n0lxpCoOx8eLZxI6bVm+RdvGYsfjLxKXXBapk=;
        b=FA1+cfYzSdOQBi9DuPQDaQOQD4xzPPl9wjyBkYL0b1tnKA/BjXtk0PEMAZIR3ZOX2S
         3jA98dgDDTKzmIQkinLvAn4/4pd24v4mAdbc541liekYAZESUPrJJm1yL/mKAN0R6W9q
         UfUNSug+DjX/4600k1uinVGfpSz9nEY5dGpsNG1yCUwbj1jNQDsDRaiXFB5+a3WifIva
         bqcPROvntBww5SCv+Gue+m5MHb9Xr41GtfKhr4N4NNj5r1xvEnLQlFEntMJMIRaqV7cH
         4tkIvO/iH13G/cm/XSEeSj6PJqjcykS7eQx/9C3yYhWehGMz9we8zKkSZYLgUe/GGIj7
         XLxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793740769; x=1794345569; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E5djs837Oc0mgny3OGd4HuTw/22BWE5GoWMv7ehHmb0=;
        b=BYxaItvHI1gZItrW86V+E4vAwKZEiV3Jru97UJtiI4qR5NfUaldAMAoMNUpyl9x173
         F/5KhA9CmA0FEys3/Ton+U3I9Nhhm1REyRvR/CPLUyBs3EmMHj3Fu9M5MrMu2KNW76kU
         s0d1grVHKHvqBrCwKSaR9976nLpJRnfNLNeMroF8QIRmdIux/v3iZja/lgLcQtI6w9VD
         GQvyTBDtM6P8vqOjLXEpj1EuZV4PSdBe6i+Wulb4OkRdwH/oAcDEKEcJ/pxOwPf6yIJO
         /awfigc03vNy39OxYWjcazcLCEruRJjEhV/rV2B4JCUIexFY+PZDtp+TxUwOdmX0s5o7
         WCoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740769; x=1794345569;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E5djs837Oc0mgny3OGd4HuTw/22BWE5GoWMv7ehHmb0=;
        b=dupHBe0I4dXA3HOqmDRX4uQiiIEN7FM9paQp83MZtFcJMGa2H1rB+lGAA6jqqR1wfp
         oQGFtAvQj4uRDCqM4ukphdE0DJPgTGu5Rh/o28U1UaQ+Svel5xgAkeCGRKXwo7qm9Whk
         DcSpZ8O44iRHMtiY6DKmNKzNANy+bi0doWujanQZaHaVGl1Oabrl5xVRXR+olti+LBcS
         +J6H6jRo/Nrk+vJnmcKm81qMrCDc1NvZKw3vG1FWDV92F840IJdxONsNhp9ZBfPwKZSl
         HN8SyoMhqSTgAZRAusSqaoiuQRaV/l55bTFN6R1FUwipbg1D8jEPSaRE8HLrpn81Rw8c
         LK6w==
X-Forwarded-Encrypted: i=1; AKwUvBzkemGkyapQv6PtG72RwbW6UevkgS7m/LCredc3zX7Y26Een0nbPWheE/CWXPqXLZsNk+oUfl6zwL+D7uMf@vger.kernel.org
X-Gm-Message-State: APuU4Z/XG/WaC5iJ9NNmCCHMgGduwcaJ2ww7bfzWFV7dUCAUWlDvfiSy
	TIP9Pw4Bd5i3EjM/1uCqRuMnXAZJjWJg9N+fejoVBOptDGmgvt7vKgkF1QBKw+xs/LTF3KbEIn6
	EmENUg0zXIiqevUmzE3dvchfToIRsVp0=
X-Gm-Gg: AYBFou3x3hIKmGg+K7G2K7FUr62FYsi2bUb/gcpdKPIC33l7NN+NeeGseX1bqSD+QBC
	QFMyVD/PEfLaceP9hIOhz4rDa8KgQn/IUKkNY4JpoE6q5Tv3etqOJlwxdrNcKaLejwVMWfGrEEB
	fYB3RjW2oOg1Rk0RiEAMJKaX40vzL1OV1R2U1y7pXyKnUQt+fezI87eF31CVYsnmKBE5nmNv40u
	5anSKKO7jHMiwT9U/pCaIDaFaK9GnKH+Y960X1a0h1exZNTfCUDk1pM0+w8TUDosEGvOFC0McTg
	+PsIKMfhRefQ/m/+fAaf6mmpQYJQMzAwfBD2mRLAE3lttaGweJ8hlHUPdM33pCYI8SjKKrg0ZkJ
	ldPW/+2qmzngHFrHRcxQZnJTTSeoenjbBvM6FvtfAeOnUBNVrDbO5jC6Q8sN6m8qL69dHGw==
X-Received: by 2002:a05:6402:a6c1:20b0:6b4:1eed:b9f2 with SMTP id
 4fb4d7f45d1cf-6b4d5255a99mr6904980a12.10.1793740768783; Tue, 03 Nov 2026
 13:19:28 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261031095716.3030288-1-amir73il@gmail.com> <CAHk-=wiPhTLn1p0ZHx-7SMdk4_zazqDK1k7MMEn9scRfqeDgtw@mail.gmail.com>
 <CAOQ4uxjNrdxZdZZipsqnUNq+TswCKqp+30iKRKCqh2WOQ-zKGA@mail.gmail.com>
 <CAHk-=wiimdwWu0EVQdxGVjbVWdzNKGg0f6vZ1aR-GXxDvQa-Eg@mail.gmail.com> <CAHk-=wjz+Tg3iq_6uBqxm+egP_aRhodcz2Qu3pQaR8SQcvPt0A@mail.gmail.com>
In-Reply-To: <CAHk-=wjz+Tg3iq_6uBqxm+egP_aRhodcz2Qu3pQaR8SQcvPt0A@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 3 Nov 2026 22:19:16 +0100
X-Gm-Features: AclHuK9tonoGwvOBReDPDncd9ly3rSzJs7SEyhXaRkacdqBh5Cb5BYpyjNlp-9w
Message-ID: <CAOQ4uxjL9a6c=8u=eqrtkU=K1Es5ZdekAb-v16xNeD0-87Sr4g@mail.gmail.com>
Subject: Re: Return failure from take_dentry_name_snapshot() (Was: [GIT PULL]
 overlayfs fixes for 7.3)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 5:32=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, 1 Nov 2026 at 09:16, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I'd like to see an ack from Al / Christian, but
> > I think I'll also rewrite that function to use guards.
>
> I didn't get any acks, but I obviously did do the guard rewrite (and
> then some: I got a bit OCD about it).
>
> I've committed the end result.

Thanks for cleaning it up.
Amir.

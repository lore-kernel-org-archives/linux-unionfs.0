Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793976788;
	b=t79GBs/tLgUEJCgpctMfVIxduu2K11ScdWudeyE7zBdi0eLBnYJSmoKj5tQhQkEOeKUw
	 QJlJTtERsHnPSK71CcFNwsD5N8425Mru7RRjc4jyz5th4oiVJzgE1A3kpfGcCpRsl3BIr
	 2cGFFeM1+cKce6NKTpnTUSITa2NywPHvG28T7Yr4U17Cvg1rMZR3xWmAEbnx7iTKWPJzF
	 PMJzJPkDnrUKKbFwkre9iv2VAf1/IECxbrf2oopZfeImXWScMHjnhj8coCXvPMJOXP39S
	 Oqsjx0WdKEUM3mXKrHGYpWYp3h1cCvFgSQ8KCCZl54jqwIX7Vf0oCeKDZKIvMaPhlvA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793976788;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=SQCsNflCEfdZeHEEsqBCeoqTAr5oDn7fTb0mHy/Ye6Q=;
	b=vm+P60T/thmoEPj7jLt4+f01LLOS8uUjZ1lrf9tew18rlWYiWSDBIqXYb+FbQ/5RKZi3
	 ZzR7YjNUi9RbAyZgHktPYCoDyGahGxDNwFby97eJCOEqaEw1YBakHW/QxXH5RJPuaV1Yt
	 Dfv1yWBpRXtmi3DbK2+8WuRMDePuUmSu2xoXJMaVDIHSTDShWvOWR6rrjHdzkd4LMeX22
	 1SgfL44PfmEzrKKI/5zixCGb4h+CZq0P7KumfRQphqyR999IqMYHoe7gaXR2fSXVAdT9L
	 gt09hvzm/QuoKRN9Y4GQbxyIOpGEow9MTBd/g64Bz6Pi0U2psetEmUweSjpGCa7NLkQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LKEnndkh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07562606A326
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 14:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07562606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LKEnndkh
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4c9abc1824so105650666b.1
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 06:53:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793976786; cv=none;
        d=google.com; s=arc-20260327;
        b=p2ZuS+ooHFm8C1v7bXLlc7Wp61m4U/R52safe23asmw7Z2IVy5aD0ksLKBneGltlnt
         IWnHqJRkIz5f6ba72vGF1cdV0iiF+SngR8uUQ0DDxJTaT6hBehnrDfryaD+3twaeNZHM
         iKtNs1b/bkQ/eMFKxkE1T8Qul1CgcK5+nMtEazDlE8+iXJPOFC90uMHOHor2laqOEBBP
         XhFbxOJv+ZabCqXC2QYyutm9bdTvcMcFHMhu+kJITxevHvPOo4zDBzIRswHDCQpUs5tG
         b/0kqE9xhcMSk1g45bcHklvM2E6tDVhUi5nawGGXaUCmml0yNPF8cm3spMfaYQNsizE6
         gb+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SQCsNflCEfdZeHEEsqBCeoqTAr5oDn7fTb0mHy/Ye6Q=;
        fh=DMkBQGJUXeMV9Z2em878L5ubb4Im8GYqatxUyUq0FdU=;
        b=suFooWJ9RfzysX7LMoHSP4LM9+MyFa3g+cnri4UmeYtNy0N6lc5aAM7F9mnIt02Oq8
         BiHjqycGX3X0FvdaI25aAOuDSvhaCuXo31HyNJWqJrO2MnGKpRNtmCEqfhsNJejZR9f1
         Zs9CMvRPvojAhMXqns226AvN6O6eav+mM3uji32UPSZwE81VJBxSeYC1P7uNqMYdDV7V
         BAZj6O9pT0749dwC5QxeUaj8k1kUMQ0JYjbwy5DwhFGlGpZN4wn76hRvJfTVfKnpn4+e
         fT/72DBO+YXp42AROPq3R+zKGk0tQCkxkRTS+rauADitZT27YS+LPKKnguyp+D3Ik4oI
         69IA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793976786; x=1794581586; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SQCsNflCEfdZeHEEsqBCeoqTAr5oDn7fTb0mHy/Ye6Q=;
        b=LKEnndkhpm/0YEDFx4qly4mwOKGjQPoz/AaFMUYsN7BgJCi+qF/7O4QTVLInGhf3Fk
         p0iomBRLY5tG4YHNWPwJT3revg5jQhHs4CQy2IWbhfkFzUmI60IavohAOG2zoHPMrBy5
         FJMohGOYocPI658EI1rZsZyBsf+M/TCdSQMeeWDKxeBq7qmRnAGtK+NK/SDt6aNtZvEv
         UDbfcEwpcJ2L/a10z2DI8KCQ4k2n4V5s+apfYP6+IhrnH3rXQ/Cot4J16+oopNf36GdB
         ZHLfnfZCs82fNCF8AyN1o98QpORuxplTyYiClXBjpCXGQ3Qr/49iUbRgMvwP+dEiNHx7
         oRlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793976786; x=1794581586;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SQCsNflCEfdZeHEEsqBCeoqTAr5oDn7fTb0mHy/Ye6Q=;
        b=ffRoYiIe6/mIT/rqLlvNLRziwzRZdIEihGE18jYdcun5itaXZjll0/ONFR/wiUIt37
         J1Tux4ssl4y76GUiHrqpfJ3BKqnsq5SAiyGGl9tECKa3+RR/Wxdl4yYTxBbsnvVp1q1h
         P2/qnvGQ44v3+uBApnWlXUog25NW4OEK5F04gkIlwb7nA574J38Y4YQ21vcOPVbdi7Ev
         TYSaYzO71dXJ53Y6knfFX6Qtu/TS2nMMdEOV3VHNVaHf/uxkI+83ylqIaBG2Zs0+Abuy
         eu9pl6+Wc2NWJQj2O4qFDGyYs1/Wm1dFgi1/FiSHFYzogCj490RDiWK8QSKvN18zzZ/z
         Foew==
X-Gm-Message-State: APuU4Z//PeWkW1S34PNtO1X+SvYLiim6RVGRkQWGQZJDGhNCXNjhAHIz
	dp9zwxxtTSZBvb+GNkRxkTY+cn07SNSNB4qxykwY3DdsP2Zs5WQqCdLo6D90vHhPcW0Yv1Buulx
	jQvl+wFWRG0r4F5fas9zAqYyQwicS8WNBH5VS
X-Gm-Gg: AYBFou1qDZe3MPBOq29P2mhg0utrBKgNdX7Wi176jq8dyuOafjToG6/dEASDtsOrZr+
	wBIy1CpELw+Q28OLekHIbgagKVUvY8Y21SSEiGSf0NFD94TPBg2N46MWF0e9fz+o0ttAgVzK0c2
	Oo73FU/QYiVKiao8tLu/BhvGum501M7o+Hsq1CsZr9yIMMWpr1EBjfyRS2BijHIEq73O0iuULUk
	soZyZTQgZzAGkorCc6aXFxEBi4tlgxs2uEVxtT/tm/6WS3Snd7yPw8+rlaZAb32ibljy79tlE0i
	QJHdinHArm4zIaLPnvpnd9v/mjDg1/1maKclEmMOGrQwOq3Tkq2ZxpBbjz8c5GsP77I9ETEgb15
	7+GD4o0YF4Wi6IVddPiqTpX+GqcvA6dxYhj9nfvV/hUMauu80Eokv/GLUZQofsXUhAAh2cswRFU
	z6HjM4mCxeznwPj6pt
X-Received: by 2002:a17:906:d553:b0:c41:f29:72b1 with SMTP id
 a640c23a62f3a-c4d3543675bmr227137866b.47.1793976786038; Fri, 06 Nov 2026
 06:53:06 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261105143138.484820-1-giuseppe@scrivano.org>
 <CAOQ4uxhmh7OpoGnNacFedBPm+jUQfDzv1QD4H+jTvb2kAPK=4Q@mail.gmail.com>
 <87tslumh6i.fsf@redhat.com> <CAOQ4uxijrkvG7=0M2nwEXW6BBm312Ra1jhq4n5rw_XkcmMattw@mail.gmail.com>
 <87o6c2gk5k.fsf@redhat.com>
In-Reply-To: <87o6c2gk5k.fsf@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 6 Nov 2026 15:52:54 +0100
X-Gm-Features: AclHuK86ZhAgkyp_pc8IbFK0mKZTwu-emnJvEwC38us-8ThEVXmcStYShZR_Y04
Message-ID: <CAOQ4uxjr-vO4uPtDsYq8LuO4W0hyi4vRRzsNUPYupVRHG3mckQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] overlay: always follow metacopy into data-only layers
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 2:32=E2=80=AFPM Giuseppe Scrivano <giuseppe@scrivano=
.org> wrote:
>
> Amir Goldstein <amir73il@gmail.com> writes:
>
> > Giuseppe,
> >
> > FYI, Sashiko reported an existing bug in following redirects
> > to data-only layers:
> >
> > https://sashiko.dev/#/bug/linux-2cc24e0b-fbdc-4cf1-aded-cfd19c2918ee
> >
> > I assigned it to you because I figured since you are touching this code
> > anyway you may be able to reproduce and test the claim in the bug
> > and fix it (?).
>
> the fix is simple enough and doesn't create conflicts with what I am
> working on, so I will send it separately.

Perfect thanks, but when writing a test for your changes,
please try to also cover this case.

Thanks,
Amir.

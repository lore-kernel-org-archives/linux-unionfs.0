Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287EC367B69
	for <linux-unionfs@vger.kernel.org>; Tue, 19 May 2026 22:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779228446; cv=pass; b=GGe9H4pFKKiUAraMnmGL2AGjIoMjLapUqMPT6kLGlHCCWbIzgt/o1flfzdEspd7pG4g6IPYEc2LB1ieXKeAcHPWjdU4cLC9H56vp0P02peTfzI9TB6zFUKoAHwy3HvUJUiyE6k9lMUU+OktfHQk28hsPsx1VEuEGsSsDiMki/Tg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779228446; c=relaxed/simple;
	bh=piBDvQwyjk+bAfS1p9n7LLs3zJcyoa4Vky1yx0f3GWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r7CNJdVjzcaAS2IdsWPokfL5/yxrAKicMxP0jbQRTuBywKzBAc4E/ip405oNesSSXcmLHVybeLPqcuWiAsuZ/ufWjHaMX1eL7aqR2/Zl8F3B/PENeleTsN+Krc32wfPl3oOL6/2idbI+xD3E84pB8J5eT99xIJLdz4+eIz1gyCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XPVE0duC; arc=pass smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XPVE0duC"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49021532ebdso10869615e9.2
        for <linux-unionfs@vger.kernel.org>; Tue, 19 May 2026 15:07:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779228443; cv=none;
        d=google.com; s=arc-20240605;
        b=FVHNZrojyc/M0Go0OhjyfkEyfACciTlNdx1yBcYJeBi8wOHWjYmNDlnqP/p6eilgEn
         isU7JPdvicNJass0nmIe8pk4IZAZwt8bZqBVCdPgRwWe5b9lNGPWlwf6+sQ1tQiJ2F5j
         Kcvbly2EZ4nIDwl9PdxFt33W5TghpEXbnNLOh00ipjYm2gY4Z00YueXWWQu2SoA4ydNc
         r1Q9Btv0VKRsyXihCVWCkd+Z7/7ssNwBW3uwWL062lcj78QPW0o1NPwsjuCbSG/cu3Kc
         NgsKjGq0ZmOk2l27tu5Rb1rql4Za5SPpmeLhiaQnzi5TnMvVAUqFDUE+Upg6IjI7o5kV
         3j2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=syIH2X4lqZqn7fO1bqpamX7eCMAdo+GVXIdTu8K5pKs=;
        fh=37lpgyZqc8rPdxc4Q9Oj5xkiinAtgbv8AtA8Dm41VuY=;
        b=LC3IEobp3qldbSuQFkyKfXv4cz0dopi2oYBH+v+f6J+lK+xchK+4Hg35gixfhi7Ktx
         pr5ysBHFaIA1tXzLjUb31RRFnIU8FrBPu8WZSZ/2aeOhWdefzgldnzS7jb/td3kBrThf
         YLT4TSozdcVlGMKLMNziPPscquAjuHUGJePR92GJMyjyFflV2BH0T3fTZNm9se73GDt0
         Idmcu0oWlIW2k3XrLLtSxTudXHMyTfHhZpvDNQ15HlEawozeNvXXQFuAsnzspjj8W4hv
         MUV8N0OdY1uLR5HHRm5L5Q+LAenqZz2UE7U7OBsMCy1txVZdDnYa6Rxj2sNErwE+4cq7
         YcQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779228443; x=1779833243; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=syIH2X4lqZqn7fO1bqpamX7eCMAdo+GVXIdTu8K5pKs=;
        b=XPVE0duCVg9lQKZ8TcusFE+iZiZ6vkasg/Q0MbICM8DF75XLzE3k/3fgVRhbtS0BI0
         aMuH6KKcM13MNbgeFES8p3PkFVv7DfhKTFoBlMxGN7a8IMkah2SqmQSFLSennLnWrt/0
         BOqiyTP8djR97C3/IpL+7IOL8Prd8tdET3Iq6eYUQ8NnnSdGXXjpVh2YUOUpDobzsOR7
         gpYcdTbB/RI0Q6DyWQdS2dmhdZjrT9jaF/xvlby7vQOJZEEIRxluqiCHj9xb/RC++93G
         gaPcYzgz2yKeLizFlfExF+I1vJcBdVXt75o7lvgYDicn2UnA8gN9K4Z5OUyUV3vfsO06
         RzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779228443; x=1779833243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=syIH2X4lqZqn7fO1bqpamX7eCMAdo+GVXIdTu8K5pKs=;
        b=dZwDwLVxkZm0cwKBqenHMiHBDar33xPhRORP2KgQ2VuGmHAUpeUA552HhvCbG7ZLgP
         hEilkbO8VskqWFdGI+oo5EGwxwFBTEjjFPAJzsCswGRXpn19mNITgQSsow1brDfngcjk
         4xySUDL/Swi2huytV784hwaINLG9v7crCt/HQw7eab0SxC1IWRAN8oBkp5FIz73iz+VX
         9lpY4V6uX0bRBbC4lJWgXXcLrSQ/SCthfUwn5IbLf3ZGgCf5BENUvxRwRzrv0QALRWAq
         knd5cEtU1Aroiuljc5LMt8g6qIGR6x+SBrO+yMsGBIN6L+9DCopqZkf6mbVYm4X3ezHR
         u8QA==
X-Forwarded-Encrypted: i=1; AFNElJ8mj4vHMjaMog//fg3lfbRzDvFO/YsJPkjIpnQ7HBPbEC2TEM/Mwd9xqA3hrR+BwXZNCFMP/6asxhiFvuWC@vger.kernel.org
X-Gm-Message-State: AOJu0YwQPmnWLFnPAD+q5mB9rCnicEUcvJImDpt6vGjOti1c6F1U8k1N
	QFNhc4clovwZ8N1JcJsQSa+d67gZF9X1bqFrFAc14Uq0MpTLAive2w9v14EGAYlVDDTmr2JQQo0
	lnhDjgXHfPxHk4kvxfYIMN28sR16WH88=
X-Gm-Gg: Acq92OF/RvE61SUsePyMRVuB9U2FgfiC+vmNZiLlH1gnZD8mWS3+l8CAlaet1wZaDRn
	Aj/ApHYA15SuddGftLa+F6eKl9kFjc2/U5s27Z7mONziRGhKUVb1He+tQqQO89CvfS/1wqdsq7p
	iEDoLD0Cb7UXRkM33iOC9L4hcnpqToBgD8vzTkunmd+5F/ff2RdFnpt/MfrqrU2I94AgVe1T+hB
	l8efoftoRIAKyWfxT5T5S6PHerCtBH7R310ygl3grVZZbMdz2CA+kGOdU8K9RJqXixluwenSOC/
	1HcB0A==
X-Received: by 2002:a05:600c:310f:b0:48f:d346:e646 with SMTP id
 5b1f17b1804b1-48fe60d5693mr309554015e9.10.1779228443454; Tue, 19 May 2026
 15:07:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-13-joannelkoong@gmail.com> <CAOQ4uxjMPPp-R37yKoOs1kGUdAOmnp3keVWvfuxi1r8jrxAcTA@mail.gmail.com>
 <agjDGBQPG2WpDTWO@fedora.fritz.box> <CAJnrk1b_55hMTRxtV8QKBqdfEhT_LQK2byat+x-a8Xrj4nicnw@mail.gmail.com>
 <CAOQ4uxj+ss82jZV6yq=LXag2s_ax9rVdtH9uc8W+RnRD+U5qpg@mail.gmail.com> <87tss3ifob.fsf@igalia.com>
In-Reply-To: <87tss3ifob.fsf@igalia.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 19 May 2026 15:07:11 -0700
X-Gm-Features: AVHnY4KL6G7lDeu40R_EpbeFkCrgOhHUtUCFqEflHhtz-Ub85W9UjnDv-jTrKTk
Message-ID: <CAJnrk1b2KfRUTg10+Q6P7GsOYSur=hPFrh_uahmuKWZ3UHjDcQ@mail.gmail.com>
Subject: Re: [PATCH v2 12/21] fuse: add struct fuse_entry2_out and helpers for
 extended entry replies
To: Luis Henriques <luis@igalia.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Horst Birthelmer <horst@birthelmer.de>, miklos@szeredi.hu, 
	fuse-devel@lists.linux.dev, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 8:26=E2=80=AFAM Luis Henriques <luis@igalia.com> wr=
ote:
>
>
> (Sorry, I'm slow catching-up with email :-) )
>
> On Tue, May 19 2026, Amir Goldstein wrote:
>
> > On Tue, May 19, 2026 at 1:12=E2=80=AFAM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> >>
> >> On Sat, May 16, 2026 at 12:29=E2=80=AFPM Horst Birthelmer <horst@birth=
elmer.de> wrote:
> > ...
> >> > Hi Amir,
> >> >
> >> > I see there is a lot of talk about using the compounds in a couple o=
f different contexts.
> >> > I really have to apologize for not having the latest patch ready by =
now, but I'm
> >> > a bit unsure how to do it.
> >> >
> >> > I'm not entirely sure if compounds will only be a thing for fusex or=
 if it will ever
> >> > be accepted for the classic FUSE.
> >>
> >> I'm not sure what the plan is either. I think this will get clarified
> >> on Thursday hopefully.
>
> From Miklos' email "[post LSFMM summary] where is fuse going?"[1] I
> thought the plan was clear: both compound and file handles are going to b=
e
> in fusex.  Quoting:
>
> > COMPOUND REQS: let's add this to fusex.  uAPI is simple, kAPI needs ref=
ining.
> >
> > FILE HANDLES: same: let's add to fusex.
>

I think the part we're unclear about is whether the plan is to also
have this in fuse or just fusex.

>
> [1] https://lore.kernel.org/all/CAJfpegvXnA1QpmfM9V+3VB470xYDNWH8FV0mBV1R=
1-HqvjfJ8A@mail.gmail.com
>
> > Wait, is there a FUSE call? I did not get an invite :-D
>
> Don't worry, I think no one has yet received an invite ;-)

I haven't either. I think the only thing we nailed down was the time
(Thursday at 20:30 CEDT) but I think John is still setting up the
logistics for it.

Thanks,
Joanne
>
> Cheers,
> --
> Lu=C3=ADs

Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A133D13D52F;
	Fri,  6 Jun 2025 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749223281; cv=none; b=phG4Q7hAsBNaAFvrPIAV5Duu+QOh2o/EyUDOlJAGS5XbE6KRaMaC1zLxIt7VdGrgaTd/qjzGOKEYrHfKa7GCa4r7zVC5Dzhpd5p5t2yqT0KFGNNHci4QGeXv/dlfvZFs8vg1H0Dj3U7N/LPajSmZNARMBZp6g5skye2R1pcWi2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749223281; c=relaxed/simple;
	bh=Eo60iPlJ1+P8iDdJIwyPfRXW8PCg2JHJVB0bmhwR9Os=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oJAu9Tsfhwri/JXGBO90sFGiX/1LCbCz9D5JxsMRCDERylrgwAkYhiPd5kQfpVLTxy1w8R0GtA9kkOPJPtbTqxHQHY+RhyW358NcbYkluT+GAujUIIRsxHlpEtY7RUH2StWEZlk6aprL+p4KqTBJiVi6BQdFDUJc3e2O/slPrOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AFtmVzGu; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AFtmVzGu"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ad51ef2424bso441733166b.0;
        Fri, 06 Jun 2025 08:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749223278; x=1749828078; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eo60iPlJ1+P8iDdJIwyPfRXW8PCg2JHJVB0bmhwR9Os=;
        b=AFtmVzGu2VXDKdK9c0Y0Yy1sR0glz0bcXbJSGIA+eTiMWnk7qZjohEF5k0UIAgh2PT
         sBtcpcUMzJsWh/xx9//m9R+1u51SYDTIzFMARaXRTFxMr0CRuoOMJ59pHzvjVMvtRsfW
         +49JFIhBqB7x3e2hZYYedtgrjQmpiNcIAi6tEn4KZyTroIhcI7DU1k3iBlapPAV1+QG4
         YanVTaGXR9MM4NjGSAXNFdXmt10A6N+fyzveR089CUWEOJJbGKpI4XVBsIGdnoMRy+wu
         al0VMRGO1u665trMpjsazkhCKrYJ73C3LR1jWrJnCAAIqlRrq9/EswxiZiuAuvlkH9v6
         NQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749223278; x=1749828078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eo60iPlJ1+P8iDdJIwyPfRXW8PCg2JHJVB0bmhwR9Os=;
        b=XsbFMDqgbqDKbPuujJR26fi1NbF2oaXAFTvfKlEpWEqSB8sdeIAqvjX43ePCmoqzcl
         ltnngUCXJ3wL7Iqc/hFitUIwdRo8ktkTwpkrCsyN5i8jlGQt6kFv1aFASkkcjEFfv2Wn
         +cn4MBx7wZH0Ex6jSvwcrn0QtMxA/7O5tx0vUvOnDcY98j3BV8jkC4I75uuPhC9lOXdZ
         5bGjpwH07Rj7yfKBlJZ5h/dTRd1aLieoiPoD1gdhiuim735w9reTy6JjXONodCmZVQIp
         625HBBYMsz8p5/yxhPtjsMTDshlpqvT20wZIrMJO8xTJ5DaiWkuYwL4vwuwzsvuinFHl
         6HBg==
X-Forwarded-Encrypted: i=1; AJvYcCUC7EOcIck8nvKRPYmWRZdDe0bcOp2sG+Cl6wthWBsmQgADC5KAcNlR+W2mBUCVnyGGvAgQl2Ir@vger.kernel.org, AJvYcCWNuOVJLm5RfHrvp6ZQfgrG6exEctsxAlJ0d7qL4L94p0n1FyvIpyD1g1YS+6Xa2ak2NujbACJ5iWrJ0OtVSA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yye0jKm6MucTLMay8IpX5+NQ0Ces3Dp6ZeNF+ouPrPPIHdr2WEq
	F4YZVBXAYqcczHeYhycnHXixHL9fbX8fOvEl2+z7UvhSpQdQ0ildSn2Og2oDyA70MDqUQKKLgdQ
	Xtyzva9+mLwqYk4BCnOMOtaF1kgLqcyyF3dhD
X-Gm-Gg: ASbGncttXErogcTRdv9BbH7VYnk2l9V5Ebw8ozzE1e/FiBvE4+uIpuwQtVV1ls/Xct6
	HS7+cO2l8aKMUD7MH82VvOq7IDBpNHK8NdOnjHWFAT+1KBxnFrJZRlrONb+CF/XIv7JQSWW9TIi
	Di/kBYSfiym/d8N0q9FNewl211GvKYPcVKnWfu2wBHTDA=
X-Google-Smtp-Source: AGHT+IGTfsMUjZDtAo08Hv0b3VXPQQa2ORk6VZbTCKH1Scvdt0rSXpONrRYPUhMU1fe942bHXyTGPxbdOa5pycLZ0+E=
X-Received: by 2002:a17:907:97d6:b0:ad5:c463:8d42 with SMTP id
 a640c23a62f3a-ade1a9164acmr389040566b.12.1749223277531; Fri, 06 Jun 2025
 08:21:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250603100745.2022891-1-amir73il@gmail.com> <20250603100745.2022891-2-amir73il@gmail.com>
 <20250605175129.oqqzr5qluxv52m6b@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxg2D-ED3vy=jedEKbpEJvWBLD=QYtfp=DCU3pQGGCaGog@mail.gmail.com>
 <20250606011223.gx6xearyoqae5byp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxh9b285dnw+SO2h6HqtNC5Xog0TQSqhFAQaV1brBnVxVQ@mail.gmail.com> <bdd067c5-6115-4190-9e64-019607e9cc30@igalia.com>
In-Reply-To: <bdd067c5-6115-4190-9e64-019607e9cc30@igalia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 6 Jun 2025 17:21:06 +0200
X-Gm-Features: AX0GCFvSpr_S-9LvKVn-6cm7_FJlJnRw4mstzFf13W3j49wChPL7yJvUocIwLzo
Message-ID: <CAOQ4uxj1Xte5VoHK-XwqttbU17Ou82BJ+uP75UMCXFN0=h12vg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] overlay: workaround libmount failure to remount,ro
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, 
	Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 4:23=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@igal=
ia.com> wrote:
>
> Hi Amir,
>
> On 6/6/25 09:35, Amir Goldstein wrote:
> > On Fri, Jun 6, 2025 at 3:12=E2=80=AFAM Zorro Lang <zlang@redhat.com> wr=
ote:
> >> On Thu, Jun 05, 2025 at 08:30:53PM +0200, Amir Goldstein wrote:
> >>> On Thu, Jun 5, 2025 at 7:51=E2=80=AFPM Zorro Lang <zlang@redhat.com> =
wrote:
> >>>> On Tue, Jun 03, 2025 at 12:07:40PM +0200, Amir Goldstein wrote:
> >>>>> libmount >=3D v1.39 calls several unneeded fsconfig() calls to reco=
nfigure
> >>>>> lowerdir/upperdir when user requests only -o remount,ro.
> >>>>>
> >>>>> Those calls fail because overlayfs does not allow making any config
> >>>>> changes with new mount api, besides MS_RDONLY.
> >>>>>
> >>>>> We workaround this problem with --options-mode ignore.
> >>>>>
> >>>>> Reported-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> >>>>> Suggested-by: Karel Zak <kzak@redhat.com>
> >>>>> Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-23=
50b1493d94@igalia.com/
> >>>>> Link: https://lore.kernel.org/fstests/CAJfpegtJ3SDKmC80B4AfWiC3JmtW=
dW2+78fRZVtsuhe-wSRPvg@mail.gmail.com/
> >>>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >>>>> ---
> >>>>>
> >>>>> Changes since v1 [1]:
> >>>>> - Change workaround from LIBMOUNT_FORCE_MOUNT2 to --options-mode=3D=
ignore
> >>>>>
> >>>>> [1] https://lore.kernel.org/fstests/20250526143500.1520660-1-amir73=
il@gmail.com/
> >>>> I'm not sure if I understand clearly. Does overlay list are fixing t=
his issue
> >>>> on kernel side, then providing a workaround to fstests to avoid the =
issue be
> >>>> triggered too?
> >>>>
> >>> Noone agreed to fix it on the kernel side.
> >>> At least not yet.
> >> If so, I have two questions:)
> >> 1) Will overlay fix it on kernel or mount util side?
> > This is not known at this time.
>
> Do you know how calling fsconfig() in a "redundant" way behaves in other
> filesystems? Do they allow to call fsconfig() calls that doesn't change
> the state, like a noop?
>

I don't know. didn't do a survey.
"We did this until now"
Is not a good enough reason to keep doing the same workarounds
in the kernel IMO.

Thanks,
Amir.

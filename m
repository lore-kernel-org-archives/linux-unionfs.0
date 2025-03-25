Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474DD188A3A
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742910149; cv=none; b=W3Pyzqa01Re4vWG0+XvCQHUNtZNWBdp4t0QFln+B5WC+XJBzIbtkWXoX2XfP4GdUog0EXfpuPwp4/5UvICR220o1RThZr+l7mmDhlaPtDzAChwVwiEGl/H6GjrXMD89XA3rPRvTLQt0+t1uK+A9hinFlBVDzWD7Orm3RoUVZmCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742910149; c=relaxed/simple;
	bh=hpA/CRXb52LPSL7rr23mY9XTZ6x9+Dx1Iu0W3zA4vCM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DPc+3ZO/p31zsgRjCIXomUTrK4zKliBWntrApTb/7wnoREIJ/KJvj5OfeMXlZ8AjKyNVWtAu0bPab3QA1nA0qGZYB3Fg57l7XXunvaN/qFRniJTBNBL3ohP0Vu+085kALlYOmqnDVbLanJ3ClQWqX5RDXABf26Qujy715SSRxpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Zw6CK/7A; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Zw6CK/7A"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-476ab588f32so81272781cf.2
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 06:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1742910146; x=1743514946; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cUmjKAMgU1F0bXOEKYUEcJktWlivLvvPjvlPAmCFq0A=;
        b=Zw6CK/7AA2QUUKSMU1z4eLZsrVpixjNGfNCsUcPM+u+O5j8edIXXBd1FS/7NqbQOip
         wlQLk/+zYAfaufFZ4HzNn366UrS2SQP79OTPfV1XhvPETn2JFkNf/BmnkLjuV6hVqdex
         APoWqx4hm1u2QlkFuWP/4r/dhfJd6nzicYfwc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742910146; x=1743514946;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cUmjKAMgU1F0bXOEKYUEcJktWlivLvvPjvlPAmCFq0A=;
        b=WFeOvaVmfWEjzqDBPpncaA+nj/0vE/fYX9lxCiwaMt1TkHeHQ0jYF3jDwoHWt9YlRi
         SAZxvzskoWBE4Pw3HhFmzBY4FR3Pj9QoBJchrGDcMCdsSE+IPmc5cQREffPX2kuMPlG/
         O/9/EPMwmaMqrA3Vr2fSBKXkl7e5kfcmN7Ce8EI+hwXcLu3+Ucanddn8hZNucH/LSZmo
         pI0+CLluqF8rTH/hTFErmXLTmRLEp9+wEZUlqaW6u3v8UqSr2wkqRxz8sYfAZ0U5QvMj
         c7+lY4tEUh3kdKPQ+8HgmakHIcFFD06Tfv5JPGGHMURDHfJFDxGyW6zCNT1wwnTXeyfn
         /K9w==
X-Forwarded-Encrypted: i=1; AJvYcCUIMdNHG7z5G4Fn+QAKlSBzSohC4C4ubqtIWaeB5/hzRaEeEpGL0JerYo3KZbYQCeJkyeVNahyiyWwji1HW@vger.kernel.org
X-Gm-Message-State: AOJu0YwMa68PxCbVbcD1Hxj7c55Ta9jVILAhluBfMrhpeJ3SGZ0+JcY0
	ZZPF7+qc4b36ge4CDEBbU2hNVyD3Jgunw/lmyQr/i3Sah/gcHwoXR5OsoXIjINTfXjCtpiKHytZ
	IOc2zy0Jl8DmMgReZNYjg20nQMX4io+PHqIbQLA==
X-Gm-Gg: ASbGnctNug1uMpEd3m5p+kMeD6O+gTGJqXybVcHamZ4JTotBlE9P2Y0a37yer2ymx+2
	OOVHvCH6IGUA83jgdknEspUbfEsDujyhNH90+Pe0BXlTLscc3BJAfec1B6M2LN6sz/bWk2w3Ey1
	rD3MmPZYHqZyOJXKK6fkmuQt8l
X-Google-Smtp-Source: AGHT+IFebhz2tD4H/OxL2khsyI2/0i6TQPegRukkIN6hEa/XX4A90DNmWTNr4UCErJLnyN8ki6j5EAQTnc8rRcnULvk=
X-Received: by 2002:a05:622a:1c09:b0:476:6b20:2cef with SMTP id
 d75a77b69052e-4771de60f86mr298621481cf.41.1742910146022; Tue, 25 Mar 2025
 06:42:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250210194512.417339-1-mszeredi@redhat.com> <20250210194512.417339-3-mszeredi@redhat.com>
 <CAOQ4uxiqis6kawuv4pa6jxHYgpQPc18izFP8e0TORfA_mVu_-w@mail.gmail.com>
 <CAJfpegt=PWs8ZDF11p3nOCWHbWescE5nwVtUt82f=B6B+S0Miw@mail.gmail.com>
 <CAOQ4uxiQQV_O1MJgTksKycBjJ6Bneqc=CQbUoghvXc=8KEEsMg@mail.gmail.com>
 <CAJfpegs1hKDGne7c3q4zs+O5Z4p=X3PK8yFXhyCY2iAjs4orig@mail.gmail.com>
 <1b196080679851d7731c0f4662d07640d483be4e.camel@redhat.com> <87frj1fd3b.fsf@redhat.com>
In-Reply-To: <87frj1fd3b.fsf@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 25 Mar 2025 14:42:14 +0100
X-Gm-Features: AQ5f1JqTk3eMadH2E2UQWlRHTPxFLpzZRMll15gjiFDDvMeEypEM8P6IjXo4KgY
Message-ID: <CAJfpegtvPW6tTfGbOUtW3GMe8UxX2Laqjopb1oSoUNgBWNUe9g@mail.gmail.com>
Subject: Re: [PATCH 3/5] ovl: make redirect/metacopy rejection consistent
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Alexander Larsson <alexl@redhat.com>, Amir Goldstein <amir73il@gmail.com>, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Colin Walters <walters@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Mar 2025 at 14:34, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
> Alexander Larsson <alexl@redhat.com> writes:
>
> > On Tue, 2025-03-25 at 11:57 +0100, Miklos Szeredi wrote:
> >> On Tue, 11 Feb 2025 at 13:01, Amir Goldstein <amir73il@gmail.com>
> >> wrote:
> >> > Looking closer at ovl_maybe_validate_verity(), it's actually
> >> > worse - if you create an upper without metacopy above
> >> > a lower with metacopy, ovl_validate_verity() will only check
> >> > the metacopy xattr on metapath, which is the uppermost
> >> > and find no md5digest, so create an upper above a metacopy
> >> > lower is a way to avert verity check.
> >> >
> >> > So I think lookup code needs to disallow finding metacopy
> >> > in middle layer and need to enforce that also when upper is found
> >> > via index.
> >>
> >> So I think the next patch does this: only allow following a metacopy
> >> redirect from lower to data.
> >>
> >> It's confusing to call this metacopy, as no copy is performed.  We
> >> could call it data-redirect.  Mixing data-redirect with real meta-
> >> copy
> >> is of dubious value, and we might be better to disable it even in the
> >> privileged scenario.
> >>
> >> Giuseppe, Alexander, AFAICS the composefs use case employs
> >> data-redirect only and not metacopy, right?
> >
> > The most common usecase is to get a read-only image, say for
> > /usr. However, sometimes (for example with containers) we have a
> > writable upper layer too. I'm not sure how important metacopy is for
> > that though, it is more commonly used to avoid duplicating things
> > between e.g. the container image layers. Giuseppe?
>
> for the composefs use case we don't need metacopy, but if it is possible
> it would be nice to have metacopy since idmapped mounts do not work yet
> in a user namespace.  So each time we run a container in a different
> mapping we need a fully copy of the image which would be faster with
> metacopy.

Okay, so there is a usecase for compose + metacopy.

Problem seems to be that this negatively affects the security of the
setup, because the digest is now stored on the unverified upper layer.
Am I misunderstanding this?

Thanks,
Miklos

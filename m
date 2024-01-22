Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6593CF51
	for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 13:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705929721; cv=none; b=ZEWUgNQltAvRYtG2YkK7+C4JfSd09SO3yXKMrJxl2X8g8mZD6oFetWq4myUD2mCNV8ruuqlvrrRIN/3qx1lgx9zmqYLWx3C2L+AepxdbeEeXOeoE7SvkC6mXE2B8Bx+ocBYEdfdv+VoR7GzoG/Ll4PDmQ7Qim4GOUFGPYJ+P8vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705929721; c=relaxed/simple;
	bh=th2DBP4sjJ3gupIzx5acIrqzLPpcd7uSKpBUErroEJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cKSQX2O6RF6eXEfXVBB3ceXHNUMALoR7g/LrPqg8f01X362lpjbI1DLZEojZllULcP1BIa+kKJqnzKi6m6ZWTXD4sb73qNo0PAYZ6DmFH/iJmP+w1M/Vp49BWKkVIL63aEreZxVLQ8xu6qOMPun8d5qw5luXr1bztFG2TmN0KQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bNTDrs8S; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bNTDrs8S"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-783137d8049so281667085a.2
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 05:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705929719; x=1706534519; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=veBynpgezm06VNMLRWF/ul+9W9MbdW0PeuFyaqH1OwM=;
        b=bNTDrs8S2VtsLcoZVeRUhzwmvzNdQXZHbrrOjDlCmgBr/i6URzcTKobSwyU7Bj4/27
         px7NkUtF+j9S1Ja598iwzTODqYs8YyqetaFIzc2Ih+9hCdIarQUIoIMRRZFo6Ow/gR4g
         M0F/tBwvnPfpXVzBsdxrIMXmYp052WbiuRvA6PnA29VtD297rdsaFMSw/4AroeWctFI2
         CX5LPpIj2oGRZQO3pDCSkSiqvmJ7HkW11BW2a08lh9Nw5YOoITIBPSn1t1iRbe9eo2W6
         jrLUgSVktmnihUFyZyfB0GzMw+tnuGk8Q/qyYgBlKN1TDuO/3Z8paYfO5Nk5eN7i0OXC
         EbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705929719; x=1706534519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=veBynpgezm06VNMLRWF/ul+9W9MbdW0PeuFyaqH1OwM=;
        b=g5Yod2uciy5AzCn7JjoY7gjDWezWnfFOyCKWky9+3xEvg14+mpMYPCss/OU1+ILwFA
         TKmRrMViS7AVpLucxyoqeuZa+x64HfbgMU/UgGm0/bJlHY/IAjANn/PbJoJwnIayTHs+
         JzExK/N0moV18Bo498cYBlgMGbA4tt7XRGEQBxbA3qNK5hfjEQ5LqRgmT8G8klU4gjKm
         ru8jp+NPPipc7IcUSi9CIw0zcoiNqVUPcx6u8Rceha4q1kcHyoqBiT//NV3cnEMnc5Gm
         TYYnzNHr3xKInslIo2J1TraOkqZm4BLak2aXGlNMcrdZzznUDH+fpSGYcs2YOQFeaJc+
         kAYA==
X-Gm-Message-State: AOJu0Ywm0eS3jzdd/q2Ocm4g9c9akYsgtwNmC/KA3ZcA2/ZEyXzFAH8e
	7pnHtGAMdilqovKlsRmzlhkwb7I5PtxpufCvSjLfiDuGeU8ZHMGuFiHvHO8mMW85ObpeLaAmWmw
	oadHFMFG2dqLyrei4UnrTk/rpOEI=
X-Google-Smtp-Source: AGHT+IGPDo5Q2RW8YJYfW94Wri/cOlIt81dWzkreV1rueny/S6bkQ+f/c5TAA0KQIEPezzn0VKWXog/b2YOriDpgXOM=
X-Received: by 2002:ad4:5ce3:0:b0:681:12af:6309 with SMTP id
 iv3-20020ad45ce3000000b0068112af6309mr7612477qvb.71.1705929719316; Mon, 22
 Jan 2024 05:21:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121150532.313567-1-amir73il@gmail.com> <3679657b0589ee31d09fb9db140fe57121989a69.camel@redhat.com>
 <CAOQ4uxh5x_-1j8HViCutVkghA1Uh-va+kJshCuvB+ep7WjmOFg@mail.gmail.com>
 <e7e1a2268a696af96d8b7f14cbb20edcee032dfb.camel@redhat.com>
 <CAOQ4uxhu_p1OGh8aFEq6nEpWMzFjyXOvrirhYc-apAzc6Phq6g@mail.gmail.com> <8f8f35ec4ec03d747fedb245ce067926c398a43c.camel@redhat.com>
In-Reply-To: <8f8f35ec4ec03d747fedb245ce067926c398a43c.camel@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 22 Jan 2024 15:21:48 +0200
Message-ID: <CAOQ4uxh0ZnVPLwJptfagTOqoZnWM6Fp3EYYjtGZV56gt0BNyrg@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: mark xwhiteouts directory with overlay.opaque='x'
To: Alexander Larsson <alexl@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 3:17=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
...
> > I noticed you comment in composefs:
> >
> >  * 1 - Mark xwhitouts using the new opaque=3Dx format as needed by
> > Linux 6.8
> >
> > Note that this "fix" is aimed to be backported to v6.7.y, so there is
> > no kernel
> > version that is expected to retain support for the old format.
>
> Yes, but the composefs format needs to be bitwise reproducible, and
> this change in the image will cause a different digest for the produced
> image, so we can't just change what we generate, it has to be opt in to
> users and able to reproduce previous versions.
>

I understand. I just meant that the comment about Linux 6.8 is a bit
confusing.

I guess that composefs version 0 is a pre-release version, if we are
not counting v6.7 as a release that any distro is actually using...

Thanks,
Amir.

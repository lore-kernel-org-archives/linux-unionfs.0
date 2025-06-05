Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8631F1515
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Jun 2025 19:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749152081; cv=none; b=ON/6nSUbsCs6mO1yv/BGBLB5Ik4KtuYZHhdEjOyYYbc8mV0/1y/HAeYR01ly/Sxr5qGfQlEUuyg6qPagAqCKGp1y7RHU3fZy92KZcztgtIPYM+7QBPGoa5+rjTrT7/wUJ9EtoI6/oEllfucvef39R0yObAtYrMoTArx68Okgnd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749152081; c=relaxed/simple;
	bh=MLMRVT5KhSZX/zK3crana9aUgNm8mG8NxDX+aeJa4Q0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILVyHNawHWamieG2VJiVyI1Rnhd/U22OnCgpywD/y9CRhT0gpBrYA5HqGf9/IhB+6ceXGa99g6hswcTRCEy6xZdq47BDxbCju2QjVDkEcuiFQaTJHQ5dgQq71Nd3yUAtANgKJduQ2RwRfFbmTEbgtlxhvwBPvvXcIBvn7SLxzJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MqC43+xs; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MqC43+xs"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-60497d07279so2528261a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Jun 2025 12:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1749152077; x=1749756877; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=98kyb7DemcX1FyfLysJO1OG3WiC0g9CHbRupke5oLhw=;
        b=MqC43+xsf12tgStGS1mcZQxngmsvU2pTwWTAlwhNQ5Zv4PPhx1mU3ZGMHf+pWO1DvK
         N2mco9Sx+PNvdHEMPxFoqFtrbTWzA0NBj5q/E5wdo7Wh9DJrjUV+pAiRS2R6wJ0IOHNa
         +LEMpKz2uMtO9iuyc5mfbNDnqrrS15tXvXKrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749152077; x=1749756877;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=98kyb7DemcX1FyfLysJO1OG3WiC0g9CHbRupke5oLhw=;
        b=OZdz+ZaknoqtaRMpYB5AI61DZWgG2Cj8etZGVuVQgn3DGApvTLN/83Cdhf/cvo0vcb
         C5/09PAow4I+zwdsrtddWq0+viEpXdvOrAiPKMcLfsHBesKb1X6a0kwoLMnv8l1VYmna
         MJX7M3s+Ypdnq6iF83y9TwyW0finheN2KkG79sRAJ2zi+AdvmAdKtlaBu/LorR6dPlgO
         3qGst0QSyeqFaC/ARVP2M5+4hkOdN1nvd1+JG2ktwS+Zwq+F1flFu8mrr+eBUiPdI7Xn
         kQNEQoQ0VJOsvP74/NCiTNdoBNrdbhms6ELSgATeL4m0G7/1+YQa4xIpLA4maZ4ksLED
         O4ZA==
X-Gm-Message-State: AOJu0Yyuh+zhZmg/3i+mVG19GaqCOfiEp4ZVJBspMMpVekzwj6Z3zay4
	WieFD6r1dfpPDxrbNKZi6ht5CstFFiUFDRBHUNLmC1Zo0gfuOSb1/I01e32d2nFqnNmr4VDR1Z5
	O9DlcZIE=
X-Gm-Gg: ASbGnctoMrlfzJEYznX1tR/2+foGcVg8wczXeb1tZdJT2Kly6NV4Mzuh2iiC1AEIej6
	cvoHG2IArnAOhw5M0BHEK/s9EbvoXc8Q0vPnOniPe6S3WfEEyDFM92+OFxQPZQ++sQg5vqGN0jd
	CmIAjJf3MAxdN5e0TW+Nki92WHoZlx0NuGmSyRl0odpvtsWuh+dlRaD4Eq01uo+GvF0yzHbF9hn
	StFMqTI+C4/WaZaOF51yT6lPKjS5FH+o4mseP/hQbGNkIOmH2HlQKW1ARpgNCbvcBfiv79C78Sw
	uYm+ylWc9R0I3rQzs3ha+fp2N2n+W0d6oJKLgB4EsU35wpM5P2TGAUQX9fOlognFFyhDx/yIXQl
	PBSlVlGciO139e8sDpW8Rdl8fJg==
X-Google-Smtp-Source: AGHT+IETuy++oaBkRqO/y/UXaJz75LBWY89oZjX5LZYn1OtyjvkkpM8de3rdxZMszis+Kp4eF+FP6g==
X-Received: by 2002:a05:6402:27ca:b0:601:f3f1:f10e with SMTP id 4fb4d7f45d1cf-6077350d9a3mr376142a12.5.1749152077258;
        Thu, 05 Jun 2025 12:34:37 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6077836ff44sm46059a12.8.2025.06.05.12.34.36
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jun 2025 12:34:36 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-60497d07279so2528222a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Jun 2025 12:34:36 -0700 (PDT)
X-Received: by 2002:a05:6402:84d:b0:604:e85d:8bb4 with SMTP id
 4fb4d7f45d1cf-6077479a971mr360023a12.21.1749152075805; Thu, 05 Jun 2025
 12:34:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpegvB3At5Mm54eDuNVspuNtkhoJwPH+HcOCWm7j-CSQ1jbw@mail.gmail.com>
In-Reply-To: <CAJfpegvB3At5Mm54eDuNVspuNtkhoJwPH+HcOCWm7j-CSQ1jbw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jun 2025 12:34:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgH174aR4HnpmV7yVYVjS7VmSRC31md5di7_Cr_v0Afqg@mail.gmail.com>
X-Gm-Features: AX0GCFv9fwwJjQ-pdhMQFWakNA4mBQD7Vr_hXeTl3gorGhZitX74FYtkZ7ktqiE
Message-ID: <CAHk-=wgH174aR4HnpmV7yVYVjS7VmSRC31md5di7_Cr_v0Afqg@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs update for 6.16
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Jun 2025 at 07:51, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> - The above fix contains a cast to non-const, which is not actually
> needed.  So add the necessary helpers postfixed with _c that allow the
> cast to be removed (touches vfs files but only in trivial ways)

Grr.

I despise those "trivial ways".

In particular, I despise how this renames the backing_file_user_path()
helper to something actively *worse*.

The "_c()" makes no sense as a name. Yes, I realize that the "c"
stands for "const", but it still makes absolutely zero sense, since
everybody wants the const version.

The only user of the non-const version is the *ointernal*
implementation that is never exported to other modules, and that could
have the special name.

Although I suspect it doesn't even need it, it could just use the
backing_file(f) macro directly and that should just be moved to
internal.h, and then the 'const'ness would come from the argument as
required.

In fact, most of the _internal_ vfs users don't even want the
non-const version, ie as far as I can tell the user in
file_get_write_access() would be perfectly happy with the const
version too.

So you made the *normal* case have an odd name, and then kept the old
sane name for the case nobody else really wants to see.

If anything, the internal non-const version is the one that should be
renamed (and *not* using some crazy "_nc()" postfix nasty crud). Not
the one that gets exported and that everybody wants.

So I could fix up that last commit to not hate it, but honestly, I
don't want that broken state in the kernel in the first place.

Please do that thing properly. Not this hacky and bass-ackwards way.

             Linus

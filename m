Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B501AE861
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Aug 2024 12:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724935886; cv=none; b=opnYTQrC0iuMPl+sS8M/kJck0GCsKOcYAorcbWeHxdua1AXGTbvKeWrLwvqeHvHAkDxZUGtlJjjAsyJX6fFSvo/2cualDV75ibuWYbtGpUT3xNkaZhgv1vZmtXN+jQ840/G/c6SEAqZqsU4ahIXO/UylpIgp+YpZTJCH1BS+xNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724935886; c=relaxed/simple;
	bh=WvIh75HCo2tYMdsZFViH6VthgjnEOjnp14oyUQnCulE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EAj9VVL1rMaxhsIPPgNqoaCtgSwonEJeHTE9FISH8g6lTALgpWb/AQ8RLzsr+anUAqTcrxe6/RtCGahGevKpxq+JV3OJh2O1/3NrmFCoMD0n2zgOKQPiHFgE1eqWCMB2smvh8nBxEQH+M9hJ/Xl8eU9rXgI5/gsd07zW9vQvd50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=QwRunH3d; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="QwRunH3d"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a86933829dcso74284366b.3
        for <linux-unionfs@vger.kernel.org>; Thu, 29 Aug 2024 05:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1724935883; x=1725540683; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hsNGyCj5N2FtoYDe5eEGsZ02+EpjC129Fhp5l7VQCho=;
        b=QwRunH3diqjqc5nPit0TG6SmTlejWOpTWDVR0mT5U0bdC4SeQCJtaSjXmbQeSWkMN5
         nSgeESsKrn0bZjp8K44dd7FN9O6WLDS16W94M56Npm2yM5MK7wO8O4rGI3OggbcPSLEQ
         X1g98CH05dNO03VrLtHZC39sMGXkEo767A0y0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724935883; x=1725540683;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hsNGyCj5N2FtoYDe5eEGsZ02+EpjC129Fhp5l7VQCho=;
        b=khK6cJJlxh6LE8t6YltqUuQclZ9SBA8rEI30ScQ69CEoozEKVeCvsy0wjOaSQSpW5U
         D6iXZKheBODm48G+d/EfI2rqW0HaEqUMLa4GHwrHhTmf6h+PCeOT6nwjw9AGs9VBkpsc
         L84YfBPVOPLVM2Qyu6vuO8xhHR2u0JV8oG9LgAUxheLhjI+JP3f0b+ZVh17Mdl3e0WCR
         NHiRdZVpY35UzhhU7gLjderBExO2T3x3zKlQ4cjTyZYTgM+Fpwk1ONX5WA2pDi81zgq9
         PZKlahxQoAs47Ais1NQLKxMT5v7qxI9Qw3IwXI5Pbavqgc7/fErRcbkJV7PdWR1ZzdmM
         RQ1A==
X-Forwarded-Encrypted: i=1; AJvYcCUfApTRtYhnRoOA4f9FVssMvs4zOVbRZ1mnVsOqWTYCpvJ4ITecnPsRf07HdUU0rUwJd3yOxmopHKbRbGwU@vger.kernel.org
X-Gm-Message-State: AOJu0YxmpWPTjanCu0dYCsojqRajtWAGAGT9+C1tR8qQkUSJeRjuED4h
	RZ+6vfs//l8REryqlgWkGVMi4kqs1XaR2te0CW1hDzdnlae8HmyaVlZluyTAZUOULp1woe4M6Pl
	MKxfL6SgzhbrLRDLdRsNJSFtGYpWhOUxcTh0N1g==
X-Google-Smtp-Source: AGHT+IGNoEVJRggsb/Cm7mPyai2RQf0bn+sMsw8cB9ojaB5L7XqeyhlKde4HK2f09lC4D/OD0DaBtj+TtEPkJ3+Ct90=
X-Received: by 2002:a17:907:7f20:b0:a7a:9c1c:1890 with SMTP id
 a640c23a62f3a-a897fa63911mr202369466b.55.1724935883036; Thu, 29 Aug 2024
 05:51:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240722101443.10768-1-feilv@asrmicro.com> <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
 <CAJfpegtPOgowkK5EHxNZnuHDo9AZTbF2-zxMc99rvWL44rdMXQ@mail.gmail.com>
 <CAOQ4uxiYGsKzMZ73=WLZqseU=ibboFtPfqpeGtmFWYY3uxjMvw@mail.gmail.com> <CAOQ4uxi-BuKU-AbyydVB2c8z0DiPP-Ednu+bN3JB2Cqf7rZamA@mail.gmail.com>
In-Reply-To: <CAOQ4uxi-BuKU-AbyydVB2c8z0DiPP-Ednu+bN3JB2Cqf7rZamA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Aug 2024 14:51:11 +0200
Message-ID: <CAJfpegt=BLfdb5GRbsOHheStve8S57V9XRDN_cNKcxst2dKZzw@mail.gmail.com>
Subject: Re: [PATCH V2] ovl: fsync after metadata copy-up via mount option "fsync=strict"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Fei Lv <feilv@asrmicro.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lianghuxu@asrmicro.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 29 Aug 2024 at 12:29, Amir Goldstein <amir73il@gmail.com> wrote:

> But maybe we can ignore crash safety of metacopy on ubifs, because
> 1. the ubifs users may not be using this feature
> 2. ubifs may be nice and takes care of ordering O_TMPFILE
>     metadata updates before exposing the link
>
> Then we can do the following:
> IF (metacopy_enabled)
>     fsync only in ovl_copy_up_file()
> ELSE
>     fsync only in ovl_copy_up_metadata()
>
> Let me know what you think.

Sounds like a good compromise.

Thanks,
Miklos

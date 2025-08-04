Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A26243387
	for <linux-unionfs@vger.kernel.org>; Mon,  4 Aug 2025 08:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754297883; cv=none; b=mL8DGi5T5lQO0XLZqu3XC0jBVxwjB/MMaGmQ1CAIhLWSdGDZ9zXpPkf4/e6iIx84q6ETQAECSkmjS6uFP7xHgAbOKBZ29dU+Ogciwq0j9MuBhkFLOBIPu1Mk1GoZDF0A6jGHsfKr5YTOtZL36ZQu6Tz8GO3C5cCVoLTNS9kG4gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754297883; c=relaxed/simple;
	bh=rMKPsuA/LNZT53mtPZlD04+HXPrvqoubV0uJH3d9YlU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=syQzfpK7wdZIVJBsCxFCIuipCeAtiFgLf/At+UuF8QiyEUs8I7Ei9pHOf0OpKTPV6Ulc8EmBNiuNlaQn3AX9PNiuRQOffPeIwlKMxSrKfJ0zvXp/sOY+xfunsAoypf+USWhUNow6gm+7+AV4wzdtQT63tjkv+wcmZvAt5ELNwAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=e+1Igswe; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="e+1Igswe"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ab82eb3417so46869641cf.2
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Aug 2025 01:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1754297881; x=1754902681; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+moKtI3kFGQMjrA+sm5yIWFvqawtCi2ghq3vx7zop2c=;
        b=e+1IgsweUsXFbEYzXDk9zfnbX3OgEq82EjDkl91Oj+iQBqMch20Xj9Y95SdJTiU8R9
         kPJGHcN6a3bEneIpfFS+HMewhjQlThfdhL5IgtlqPbW3g03uKgYZw8sAaKOQcq2Swyd8
         kKlbRLVmlZHQqMAyKHDdYfbB94DdE4dlLfFPo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754297881; x=1754902681;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+moKtI3kFGQMjrA+sm5yIWFvqawtCi2ghq3vx7zop2c=;
        b=ix6cMKtpi/KiMLnZzMAYYpFLWXz6r5l4hWxsrB4pDRQ8jZwmHotBHBiW1ouDfd3w2V
         3AfPUG86VXO8iP94nGleIGzp57LNUArxNb3LpKFg4wnOAKKoyeFv82qoU/U+qKPtGG9E
         X8omJHjeIdf7dCR0/I5k4pbujTEQEOaAVF4LpQ8AC5luCWao+4UNHa8djZ7SMkRZ/oTS
         ZyKQBAAIy/hECLBfeazlR4LLdcgI2XZ/gD/3KbEac62gEBenG83b5dgy8JxF2iW4c0Yo
         Rd7zv8nROCrn2NQU/UhhzlPK7cqjNMH0J7G33ecKOkX+IGA41u92+jm/RfSX35cLxrvK
         rTzA==
X-Forwarded-Encrypted: i=1; AJvYcCU0lwjE0lcfyPTHVzKXXbIGHF0RhaNATgo7H9deGvt3713MCx4VUvn3p4dG6/jU0n0Dx0+h5F0ua0F+8mhW@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/GwBPWRq2B21UrEFdI6soTCyac8MIsMixLgtMAUmX0HPSvulD
	a3sZM/Jlf8L/3tcwWFiKSM+raoUhCZgWijfpAyt7TV6vQQAnJdO8Zbo1wXFF8+0or0JDxKZxIBr
	td0ZOoN9KLjEl72F6fH2orb5U6M47/fsp87McdXCCsQ==
X-Gm-Gg: ASbGncvgAg5S2WANSBltS9eTCRF9avNoDGsuiguhGcKtEbVbgxe9Hv7laz8C8W9SoQo
	/sW6oPuaBIFSkahH5ib2r6FAoOKoyVnuAsAMffR1A8pf9Ub5VCSIC57SyebyahHunah/iS6hQk2
	KrFZmkVdmBbvmGsug4c+HfSEot62gbEaq+FHUJNTQuj/ySW2jwI14re6VfDFmSgam3W7zVbk+bj
	Qg2K28=
X-Google-Smtp-Source: AGHT+IHycRW29eA0nQXsmFMyfTfL4MJXsfzlc1ljAhwo2MgMd8WlEH0JF9AUOTcj7AyVCgwSa4OnHnSiClGw4Pxdv2M=
X-Received: by 2002:a05:622a:5e12:b0:4ae:f4c0:b608 with SMTP id
 d75a77b69052e-4af10ac4dcemr141129441cf.29.1754297880770; Mon, 04 Aug 2025
 01:58:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250716004725.1206467-1-neil@brown.name> <20250716004725.1206467-2-neil@brown.name>
In-Reply-To: <20250716004725.1206467-2-neil@brown.name>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 4 Aug 2025 10:57:49 +0200
X-Gm-Features: Ac12FXzho2f3YnfQ7IGpNhTj4KTqbMXLYR9q6wts381BAVHf1PbdHtnZugBcR9w
Message-ID: <CAJfpeguRdP3zLiRNp=_D8PGS1VjZ-n+y1bPw4X6Wvd-W4uS32A@mail.gmail.com>
Subject: Re: [PATCH v3 01/21] ovl: simplify an error path in ovl_copy_up_workdir()
To: NeilBrown <neil@brown.name>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 16 Jul 2025 at 02:47, NeilBrown <neil@brown.name> wrote:

> +int ovl_cleanup_unlocked(struct ovl_fs *ofs, struct dentry *workdir,
> +                        struct dentry *wdentry)
> +{
> +       int err;
> +
> +       err = ovl_parent_lock(workdir, wdentry);
> +       if (err)
> +               return err;

We get a pr_err() if the cleanup failed for some reason.  But in this
case it's just an -EINVAL return, which  most callers of ovl_cleanup()
ignore.

I guess pr_err_ratelimited() in this case wouldn't hurt, since it
either indicates a bug in the code, which we want to know about, or
mischief, in which case the one making the mischief shouldn't be
surprised.

Thanks,
Miklos

Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793554162;
	b=t9MfRkfo3xJygUrCAk+JRY9BbePeLAIhOdQoTFFtzTkSHzWBdIH8PEjviKhQf9fnMAX4
	 DS5O+re9rHx7h6fNPt9VJAx9MqZE35zhOTGRfQcQYF5un/9xWRlK+5mLTQrPdUhzZ1kuG
	 4/5bMYyW+sKdH1qJC+vBw5JEVMi4B0bXmP4JljKhV9he5AKo5WpOSauHH+jkNq6ullf6m
	 P/YzpHrzWrE+pXTNQyFElUlCnP/BqRiOcNm1JWHJEQRNb+doac+rJ6GOEDhmotP+HUTVo
	 c81wFKUu1hlyDKwJ+reWLQ28ExYORHMS9jrIikaLu2PE/CS2eqeHoRon39HE76/vMvw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793554162;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=GvChd4JYy10u1btJ+yrRPy/YPHs86LB5NdY1elP5AlM=;
	b=4kCs9cvR5lAC/CVTwPsorcmkRzQw+n7eXGZvKzsO8XSBIt+3nEiJNUd03nf7EsoZfuDq
	 /GcAmLyC/MnO2Xc8VP8igJ1G7LtJ+9qbXfuG9VDYw3QZAzE1CaKFZQSf8jYKRac90/Wqy
	 YxuLN/UsP7oRbbT13Jyq5PRe7NjF+Ea3baCvLtN3dBwSYOHj99rp5i6E6BU/oYqLGn3W8
	 09mxB7vBnYEf/ilK8PJIFfdqeExNcYVAtA0Hifh0Qel6AGBEcEdDHs25Dnc62h+LKwSFe
	 YZrkeiIPJn3G+dfz7MXohfeWzw8qkv7q398Efmmd1l1yIjWNQK3G2dEfre4U7LERNgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sKv06dl4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E2A606A325
	for <linux-unionfs@vger.kernel.org>; Sun,  1 Nov 2026 17:29:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9E2A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sKv06dl4
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6afafc89b48so3668371a12.2
        for <linux-unionfs@vger.kernel.org>; Sun, 01 Nov 2026 09:29:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793554160; cv=none;
        d=google.com; s=arc-20260327;
        b=JcnlYbHFwYfWQW6advv7bH1NSWKE3SkAFNh40rge+r3iMVdWkeaUI3e6qdyK22gOVc
         5UYtR5aFArxbyi68Qu8u0B/R4zSZ2h8fXWMVtaNzEcyo0cP4brO2igJwzFn5N0mJeo6T
         hKFpdm7vuVoqmw9D+ikCZlElwUXBmsA75gp9f9nLzNXqMGxnGaCKbfbjeQA6Q0aoshLD
         PMK4ZIbZ9gjEGh3Y7vFLNwl++wOJwQd6KG7vZgPN3rlfY5oIVI+J5couNGDTwSijqEGy
         DJ3rucqOJSEUSQUvtCuZFUX44UwiFM7jsxJrrWfSVbdWPjDsX4roC67uSwcEtdOacqBH
         jeFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GvChd4JYy10u1btJ+yrRPy/YPHs86LB5NdY1elP5AlM=;
        fh=ImzQNiy775ANfFDZIicJHgnAQrRVpYj/nfhXH5bpUCQ=;
        b=MuWy/hol6Y9xQx5jJRFYYfdTbHcS6EM81xeCeDnodVW0ZJnGskhnTIr/FJqX0RWRVS
         K5bkYPGOWWX/utEh/7UF9XpnPU1eHEDuiGa07gGWyS+vNXGbl9eLofvc/SX3hIvp72cP
         GsBZSbz3TwEN3AElgav4OJBQts3Pvsh60WPdi53MN1Av8pQZjL4xSrBpgDJfPu0zPSKv
         581hFD/vVxXbidkeTlamATyQ8ozb2lLw6s6I9IX99jnEbNQTyT+ZLqUA5Ykc/YBGUaYW
         tTc4lg6q0KbWsi8ZytkNIroESrPOgxd3M/tVYjB/Gksno5O0cppyWE3ypm1yQIh4cVvm
         acAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793554160; x=1794158960; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GvChd4JYy10u1btJ+yrRPy/YPHs86LB5NdY1elP5AlM=;
        b=sKv06dl4odqaiU7BKf335nq5m5DKh3B+4gZ7v//6pb+I/cbZusHIf2IjSRSoSJN3/k
         PU3WmCMq/CSEGSo0Nx+6rvl+IU+XckVYdVdg9JEUl3xOHQtpF17jHIKC5pkDmqPXs+nF
         K9TkPj/YmDj6pqA+BDsApcRfPOSLM7q1s75XUFwOCtuWpuU0HAFhAAZ1mf8lUBiiYISi
         X8tfBcnQfUg8ligtyRwkleLPO9GHBdRMNO/HtQJHbaoKfsqikElhOKuPOUhKDoHaR2w9
         E75RVNEXUuwU3amCYW2obMMcxaqqjiCu2N2GxCHEp9aO8xFJ+1FtAWL6fftbT8jP8kte
         mv5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793554160; x=1794158960;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GvChd4JYy10u1btJ+yrRPy/YPHs86LB5NdY1elP5AlM=;
        b=OtZZj+m4XKvDTFjsZbSQzTiUmsu/nsBD5/T8Xb7DGsMHExCUHeYmA6eSYEEhKTiTJK
         jLDzBnLtbF857zR29pPg53AqTstrvFdOAnblmaiItjeK+2BRoUPC0n60j8HuWst0CYeP
         F1ju3DGvoDPzJ0HonTH1VmW/0BdeVIvdDf/qa5Zg9nA5ms51Fwg9tltxwWUg/zQsl7eU
         RR4a0xbm229pr3UkCATeWEqI8g6gr2nPT68SWmnXWqBiK28qwok+SkLogkCUBu98NiZS
         vBNJlKXjMl2rgzC6bgJ9gcYw3fngdPUE6/GBuAiZ37YzM+VFYZA8+smR9+qLeIB+0As4
         Cj6w==
X-Forwarded-Encrypted: i=1; AKwUvBx+vCADmS55LuR5ytx9+Hkss9HobgsF4OTjG6a4e/BOJFQ9291o6C9/nW0JKoTbhjcwTg3aeyPYkqrkoBdj@vger.kernel.org
X-Gm-Message-State: APuU4Z8u/0vsN4jmzavjijrULEkzYGtevS+fhyHPtTB34OY6Q6U+aFFA
	TvHhS4cDBoQzAr3SyuV6QrKjGABDT6aC3TJMr/tlhwrDclahAWvgV5pnk2jUgZ+1J2xskFEBPnD
	o94eWqaW+lLSIQrMsjYmAdzA4wzR6Nyw=
X-Gm-Gg: AYBFou0D44JDEJweM8JteCwSgFtkp000OSimyY6/z8DDIGotqrEtG/yXg0wRNYHzpEM
	TKXL7qLC6NyFg5TyLQBhk7anFWJApvg5cUiMH2CGQjbR+M2IyHhVEJQV9FP+BJqy3L1MtMXzZ07
	XJMIZ3wGCuKJ4BkoWtunDfGlJ07w/oMA4nyBBUImh6+IKctOL5+scG9zrCAtoCrMfm2Zv8AEpvF
	qe/flNdRiOrv1DogIcRB/Y9MKf1EA/CfhCr5E5kwC0oaZ/JhFtWUFHY3sfNNJ/09CwMc60uVtIk
	LbbVbnh7CfVguOddfzEEPojFvpg7WkgrIORzap4bAu6pMV8zv8fyVwUN1NJ2JRKal/N1KrZE0L/
	wDsMKICprjzu+bDUVSg707SmguxI3JBAgiIEQuwZpGnXdxKl2t7iKtuG5REaw00ygJo96vgw=
X-Received: by 2002:a05:6402:90c:b0:6b4:5a9c:4e44 with SMTP id
 4fb4d7f45d1cf-6b4d5256569mr5096964a12.37.1793554159089; Sun, 01 Nov 2026
 09:29:19 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAGEkeHcg06kHshHQ=9U6Yrs_wm8W9H28o9bcC2Qh3fw3tANbWA@mail.gmail.com>
In-Reply-To: <CAGEkeHcg06kHshHQ=9U6Yrs_wm8W9H28o9bcC2Qh3fw3tANbWA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 1 Nov 2026 18:29:07 +0100
X-Gm-Features: AclHuK-VCf9zGbrZt2QDekrQdgyRUMpGY8ViftLR3gMUBXwZf10WjO1d0UfPYwY
Message-ID: <CAOQ4uxifWJHKAa51cAzYOWe5W1TBV3jftrwvrCqCgZG16Df6iQ@mail.gmail.com>
Subject: Re: [BUG] overlayfs: inconsistent d_ino in overlay/077
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 1, 2026 at 10:53=E2=80=AFAM Hungyu Lin <dennylin0707@gmail.com>=
 wrote:
>
> Hi Amir, Miklos,
>
> While testing the casefold series on arm64/QEMU with ext4 backing
> filesystems, I hit the following overlay/077 failure:
>
>   entry o100 has inconsistent d_ino (131490 !=3D 131280)
>
> This also reproduces on ovl-fixes at 1d27da7de3f7 without the
> casefold series applied, so it is not introduced by that series.
>
> The failure depends on directory ordering. I reproduced it with
> the ext4 directory hash seed 00000000-0000-0000-0000-0000000088bf.
> The upstream overlay/077 test and its helper were unchanged.
>
> It appears that ext4 returns a buffered entry after the file has
> been unlinked between getdents64() calls. The rebuilt impure cache
> no longer contains the name, so overlayfs reports the physical
> upper inode number instead of the lower-origin number.
>
> The symptom looks similar to the merge dir case fixed by commit
> 9011c2791e63 ("ovl: skip stale entries in merge dir cache iteration"),
> but this one is in the impure dir path.
>
> I don't have time to pursue this further at the moment, but wanted
> to report it here in case someone can take a look.
>

Thanks for the report!

I wasn't able to reproduce this with minimal attempts,
so I will put this on hold until you or someone else has time
to work on this and provide a reliable reproducer.

Thanks,
Amir.

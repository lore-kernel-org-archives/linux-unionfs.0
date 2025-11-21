Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20042223324
	for <linux-unionfs@vger.kernel.org>; Fri, 21 Nov 2025 08:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713080; cv=none; b=VFf4K+OmjGa8m2s4OzQwfOL6VKUr8QOC3h9Q1sO8zPoTE0mFfjjY7XCvOS9kJpzfXcvY9Y1aNVnQ4F2nPXsBsMEPdxEfSAMj0FA22jiaYb5vl6UZ+pALdsWQAb0v953hplN5WiSbaZMcWPhD3y4l2gqB/EtUrv4ZPCRxX2/aNok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713080; c=relaxed/simple;
	bh=RSjpKYvP5XZacsWdhCEZNjyHGUuUyCaLb6tyXs45Wd8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SxCe5FCKi/0JVKCWPF5m3IgxI4gJ9Px22IF19liLap29TCbnxklLlr56c5QGoUs+vTH1hXDvXXXWjo0vH0s94/gvbaK6fovW6p2sxlwt9Whfuu+xKlr5qJvigA1M1sXzFqjjNeX+xO65ChOuESnD9LL3nENWz6mRR1kEx+2priM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CSY4YVbz; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CSY4YVbz"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so2828937a12.1
        for <linux-unionfs@vger.kernel.org>; Fri, 21 Nov 2025 00:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713077; x=1764317877; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DMdJzy0yBT+yS5rbnh/xvLAmp3Uwaq/OcT4B9FgbfQA=;
        b=CSY4YVbzx4XQuS/zbQbCiYZrjoU1GIOpp/J1nH/ypdwWP4WE6z8OIajds81jQZxSgW
         tSQnVHFl59bICVuwoHilOy/Ls2S/g1pwRmsAAI5q/CsYsNte0P16IlZPFU7lVhy+SXxR
         gZ0Tfh2ZLVjqzkRkDWGTo5YwQwJ2BM1in2BRYO0QkdfGLWBHZFctfO0CKqQScNXm1Luw
         oR8FezAVzl/c8B2G0MOOBqwxAZjYdrwE7j3bKWfSrHTWcewYim4WanigkC6+/kAuxMvm
         HZsQws3mnDaE655JfjT+VDAUdaJ+iHpM493Uy3ckC3tbXhfQj9+xecPevEiPRcK6sGo/
         m+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713077; x=1764317877;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DMdJzy0yBT+yS5rbnh/xvLAmp3Uwaq/OcT4B9FgbfQA=;
        b=tieDHpAmtws8SkGa3PpOic1MN3tZmKvW6hsjBMPsKfPWHyNz4mUpPjlKiFOIJPqagZ
         0PtHtNKRVv9aBksww4OgrUAEYh9j4cou18g6OYEo8ku/fYcdK9BQScvabmp8iorLDXNA
         YZEZLZ0/sdcHkScvqC+W5Y6DDJgFfRsIum2epAluPDsFZkWUcYqfCar/1ThMbCzGwfHF
         oCocFglYQiTvnBh6B0u4KnjOj77IMPOXQY5decO3YSRMjTRf/gsrJ4pVEhhZYnBfOB3L
         KP7PDh2x62awo+A4C1E6LZ5OEKtvkXIrmUs7XBnXn7p3ln5NT/NCZdmpaUcxJSsx/DTf
         OYrw==
X-Forwarded-Encrypted: i=1; AJvYcCVguS83yPcnKZDQYSs03SO5v6iz+iYUzYZc/fx3pHQ7aZO2Dt4KRlFJQUQX3idUobCuzFo8P2ms2wWlGAjx@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9TE0FzKA+eXviZwNV8G7P15lW/C8L38om4JG+0Vc3EY3jsfrU
	PyEMo5J3wVjLINPYPnUtfgIcvCCHxSX7ELgNFQCJ48vh2rMNYnX7pNORj8qEx3Apft4ODIIuRMW
	7glYbKAjB1YisN1hs38rYkW9YYgGOaMQ=
X-Gm-Gg: ASbGnctswf7249yLYloC+73Zw0EyUBzhHIck5s3bHt1MBhqn7bWnXdbIDUvphdgZqB/
	BnV70cu1MyPAHqPOla5elljc7F1x4oCi7eJnnwzkgU6u9LqYWNSMV4dTg6KBm8rtSJEdgc63Qd0
	IK6m2cwOBUs6IvsxN4YMef7U/AVqg1xUCim1DwWIo3QZipGeTPvc2KlULOMNa3eDlvHJJZTx5kv
	kO8/chnGy9Yg9N6YTjQQseWYaxw/BvhrUIP4ob4UbUlMUuEegGHfVygn1GLPUw/JSPiHo2uhMiR
	3lucPGk+34f4xP/2ms1ZnH5a9eViZQaMbEfBu/WA
X-Google-Smtp-Source: AGHT+IEn953KmVKGC+Dhj5rmuqvxtcSL0cebHV3x2EbISUAQS4nHDbOa+uHX42F4abn55/xbnE/k5i0yFTQWBbRmSJY=
X-Received: by 2002:a05:6402:5213:b0:643:8183:7912 with SMTP id
 4fb4d7f45d1cf-64555b9a93emr889723a12.9.1763713077292; Fri, 21 Nov 2025
 00:17:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121-aheev-uninitialized-free-attr-overlayfs-v3-1-346f631a9c37@gmail.com>
In-Reply-To: <20251121-aheev-uninitialized-free-attr-overlayfs-v3-1-346f631a9c37@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 21 Nov 2025 09:17:46 +0100
X-Gm-Features: AWmQ_bnL6v7bnxIvsES25vWuzDx4G1ClQds5bfqQD0OtfgzNHo49xd7gNpV8ids
Message-ID: <CAOQ4uxhg-B6BnygENmC3Y-mWCy+B1j8Eb=9hXu34whUdTAz+JQ@mail.gmail.com>
Subject: Re: [PATCH v3] overlayfs: fix uninitialized pointers with free attribute
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>, 
	Ally Heev <allyheev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 8:51=E2=80=AFAM Ally Heev <allyheev@gmail.com> wrot=
e:
>
> Uninitialized pointers with `__free` attribute can cause undefined
> behavior as the memory assigned randomly to the pointer is freed
> automatically when the pointer goes out of scope.
>
> overlayfs doesn't have any bugs related to this as of now, but
> it is better to initialize and assign pointers with `__free` attribute
> in one statement to ensure proper scope-based cleanup
>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/all/aPiG_F5EBQUjZqsl@stanley.mountain/
> Acked-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Ally Heev <allyheev@gmail.com>
> ---

Christian,

If you agree with this fix, please apply to vfs-6.19.ovl.

Please note that the fix patch at the tip of vfs-6.19.ovl is missing your S=
-O-B.

Thanks,
Amir.

> Changes in v3:
> - reverted to v1
> - Link to v2: https://lore.kernel.org/r/20251115-aheev-uninitialized-free=
-attr-overlayfs-v2-1-815a48767340@gmail.com
>
> Changes in v2:
> - moved the variable initialization to the top
> - Link to v1: https://lore.kernel.org/r/20251105-aheev-uninitialized-free=
-attr-overlayfs-v1-1-6ae4624655db@gmail.com
> ---
>  fs/overlayfs/params.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 63b7346c5ee1c127a9c33b12c3704aa035ff88cf..59445b53b5b88893ef7923128=
da99cd1934bdc6c 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -448,10 +448,10 @@ static int ovl_parse_layer(struct fs_context *fc, s=
truct fs_parameter *param,
>                 err =3D ovl_do_parse_layer(fc, param->string, &layer_path=
, layer);
>                 break;
>         case fs_value_is_file: {
> -               char *buf __free(kfree);
>                 char *layer_name;
>
> -               buf =3D kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
> +               char *buf __free(kfree) =3D kmalloc(PATH_MAX, GFP_KERNEL_=
ACCOUNT);
> +
>                 if (!buf)
>                         return -ENOMEM;
>
>
> ---
> base-commit: c9cfc122f03711a5124b4aafab3211cf4d35a2ac
> change-id: 20251105-aheev-uninitialized-free-attr-overlayfs-6873964429e0
>
> Best regards,
> --
> Ally Heev <allyheev@gmail.com>
>

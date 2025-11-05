Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF4434D3A7
	for <linux-unionfs@vger.kernel.org>; Wed,  5 Nov 2025 15:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762357070; cv=none; b=ZZiVxsK1I8FRHpoZJ+ZlzNq7HPXBTbBOZLTnJ57f/J5UhibrhXkGYB1vyiPqdZJDZbKVmspx3H5WyL+k7fAYy0iFnyceGY/52/HFNl9CLaDVc8zHMUrTtkL1XBoOVTsg5MaGL1IUBJXpjwATLfM/F4Amp47NROSc6SCnXsOYnh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762357070; c=relaxed/simple;
	bh=CXhaVTF0dUHKkqatGhyt0lR3+Ud/OKXy/N8gbTLq8uo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mDmd+khAN5tzDH6GR7aY95P8GkI4j+xUjTpSNWcx8dE0CTFNO26CDsBKLHyFbi6vWd/l9J0ymsV8oJG0qdap3LbmAA05LNdHCCE8OH6QC2QXhxcZfbH/b69z8i7zQL7XYCdka1ZIIJeJ6kHeawvi20HhiMOqXCuu5LhGaB9VX6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qmv28Zko; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qmv28Zko"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so6304978a12.3
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Nov 2025 07:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762357067; x=1762961867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/XZB/jPhn/siD8SGVJfI9EapUMgV6PkgsNvUj8ZEvXI=;
        b=Qmv28ZkoaStSO6N64niW74oeWSBuwdXZtKwg1cKwk7DLzD6dJOGj5+P2omuY50Tnmo
         YKjqaYkW/3Tf95QJWtTQK2/isYoRiQ7/rcowKYBtcNoRoNOLo14et36mppIZhH4mRjyJ
         8lL4SnUHxXtq1b55m1F4J/9UhDfBc22rxHxECcpuRjhXls4e/LjhxAcpZNJG8jGR6JbK
         4VfOo/vVhI/T806FIwNNuPGVuzla4aQETJS9mO/qIcPQfF0CMi1JERIibdAvE1BdDUiv
         6zUpPrhSmZ2xiJPdjCDl/oGGIdZcjAfK3qbVkKBkHjmiTE8t3L8ZcuyXu0geAW4PpZkt
         bfIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762357067; x=1762961867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/XZB/jPhn/siD8SGVJfI9EapUMgV6PkgsNvUj8ZEvXI=;
        b=H2sgQokWIklmeLsZKirM9QE2wusT5iw8/hnWMCBTuR3TedYbG9e8wp0AIN/p/PQszk
         2minAMaHeF3WpjmOlcjW892mGCSUm/iui+Gs5qMCOscYqM66dQcJVu2H8k3jlvIwBB7a
         /6kXtPdwHLaYie+OPGt97mSzDitmcF8AzCtYobZtWiK0RUNVA2tcWm+XQe7X1SFHsNsg
         fLV53M3Z9tQByyoGhYZpWd+P2DZRoY99MHPxziPoB0yRj7KI/kgVgZ0RVELyAsSFbz5G
         IuvBUUPR/r+rBn5H7z+yDqUCG9GuV8pWpbZjRzxhUDnWm6lb6yXUUwKnPbUsEZ28EfHz
         s6Ew==
X-Forwarded-Encrypted: i=1; AJvYcCVcD46MAxFhgixPSdInq+KfPzbGypSxXTATuEgOYGsN6koxryH1MfXLy1vGShkQFLbMpWDeF/oQguJr6L1h@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1gOX8OC2+ZEWIiUQn0k5Nbj4hrgQ3/WJh0MF77BApYfVkh4HX
	hbqw0TrU0n4MpWvek8JqoHoZUXRSa6ds6UBcq+8Gm00tvFLPwHLbFx/B+tHmRVbz8hl2jkYDwX9
	Bl6o9BFvgoh8MPs1mcThd+tqA1zONPTc=
X-Gm-Gg: ASbGncvHKXPlYhkS0r0tq77Z6EnNiW3p1NOJE5zhniyG9/vtLqWmVS8GkVQweWlGrDu
	RwEkD7OkQAx26PoIUQ8866XUBD5utFmhQQUmQAHPazh4qsrySjycBfT38yj61xL3W4j0VJjVOrU
	oRkDqHe5nqYCC0zBgoQebeL1Ht9y8esEbytYQwhpOLn1Q4Oexu8XowtvHIdLsl4Ku+dcLFSsjys
	oDRRbt6v4tdqS9DqUippdQ/Ggpg7s4sRWU1hoI4ED6G5BM4PNm6Pb8S1XKHoyEVa2i6GiC4ChoZ
	G83DzaL0FIiFDdXRyRk=
X-Google-Smtp-Source: AGHT+IGFvg64iJ3o0M4+tOffkilkbvzs1SJ2vHC8r6yqg3/3Ymps7cseQ5kdZ+/naG/NXdxjfwB9eLvN8fIvRNHTzZA=
X-Received: by 2002:a05:6402:51d1:b0:63c:2d72:56e3 with SMTP id
 4fb4d7f45d1cf-64105a5d549mr3208989a12.23.1762357067158; Wed, 05 Nov 2025
 07:37:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251105-aheev-uninitialized-free-attr-overlayfs-v1-1-6ae4624655db@gmail.com>
In-Reply-To: <20251105-aheev-uninitialized-free-attr-overlayfs-v1-1-6ae4624655db@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 5 Nov 2025 16:37:36 +0100
X-Gm-Features: AWmQ_bkJcX4CFGUWjjNBr7DeMH_3xhazSTStZKzFSqAuVB-zRtc3S2mv5dhIXQA
Message-ID: <CAOQ4uxjFombc5SQDRxGFn3we-rJ8nbd4KrTfECG3AzSNwcQHuQ@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: fix uninitialized pointers with free attr
To: Ally Heev <allyheev@gmail.com>, Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 5, 2025 at 3:33=E2=80=AFPM Ally Heev <allyheev@gmail.com> wrote=
:
>
> Uninitialized pointers with `__free` attribute can cause undefined
> behaviour as the memory assigned(randomly) to the pointer is freed
> automatically when the pointer goes out of scope
>
> overlayfs doesn't have any bugs related to this as of now, but
> it is better to initialize and assign pointers with `__free` attr
> in one statement to ensure proper scope-based cleanup
>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/all/aPiG_F5EBQUjZqsl@stanley.mountain/
> Signed-off-by: Ally Heev <allyheev@gmail.com>
> ---

Christian,

Would you mind picking this patch?

Feel free to add:
Acked-by: Amir Goldstein <amir73il@gmail.com>


Thanks,
Amir.

>  fs/overlayfs/params.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 63b7346c5ee1c127a9c33b12c3704aa035ff88cf..56d5906e1e41ae6581911cbd2=
69d0fb085db4516 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -448,10 +448,9 @@ static int ovl_parse_layer(struct fs_context *fc, st=
ruct fs_parameter *param,
>                 err =3D ovl_do_parse_layer(fc, param->string, &layer_path=
, layer);
>                 break;
>         case fs_value_is_file: {
> -               char *buf __free(kfree);
>                 char *layer_name;
> +               char *buf __free(kfree) =3D kmalloc(PATH_MAX, GFP_KERNEL_=
ACCOUNT);
>
> -               buf =3D kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
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

Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23CB6E5ED
	for <linux-unionfs@vger.kernel.org>; Wed,  3 Jul 2024 11:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006563; cv=none; b=Kh7smYlcGj0NVUol3wKW7XXYiFsd6KASW0q8hUKQAeKNTL1iU80pa6XRZF8//Sa/xTEYAWGKXK6Z+3ns/OJKEVhdc5L1dAd7IdXzbmSB+eGuVXb7KJYJHXwxm0R9eq3m7BE6D3sb3+MB/avnARuht47CqaXtpym3NWUnPGmaVmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006563; c=relaxed/simple;
	bh=Pc2SJQw9E6Xt5iggtIbMTOqQ9GsbfjlZ2/gYKvQE/XQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nCPgAxXEAOzeL17gMNuexgWjPdh18t/CHGwUL/dCFG84ermHdo/9DfHJibKZRuRrET0jRNwbHXyM2O2YpQj9RTaLV1X0UkITMHeCYCCyabNwOTLhBskVNrOBmx1HsZOAyQDVTQsJNLR+qIxtxKNNj2gMAItfxIUkqrKUZ/OlXWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J90tM0YD; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J90tM0YD"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-79c10f03a5dso342766485a.0
        for <linux-unionfs@vger.kernel.org>; Wed, 03 Jul 2024 04:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720006561; x=1720611361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R4g+Q71UUC/cP/Yk8LLPp0Vvk5Oot4RSXz6Jm+pZwoU=;
        b=J90tM0YDnFpuuv0x9ZF5TvCrY2Sm+2/ayIFDUrNMnbjxvV+QcRNT5PLcGss9emj+lF
         mz+QVZqLIJgrGhsuQgo5Te5T1qQ2fUymVPADt5VMHWpOX5o/uTXy8jnKJDBwHnXJ+Ty+
         VKcSw6Q7rR8+44px5lNVn8ppKCWsVomGypiGchXM9P05E+e8RWq9SzorMZlyW2Bam04v
         MSmsKg8m89Htyi61EE24MtE7Jrv11ElUnW8dIGJgt7cKdPZ+bkQAiEh3uy0SpSmqjdH4
         Gdt3GdFg1PY2tXpbjGDvab/nwDMcVJSxVp6tlXnihafDx531FLnjWFH1bG4aZxf9fDEC
         R3hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720006561; x=1720611361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R4g+Q71UUC/cP/Yk8LLPp0Vvk5Oot4RSXz6Jm+pZwoU=;
        b=glW0Jj51QZPoo9HGye5+4FazoQOA0RZrW31PYohx2mRmN4X4VUl91Lj0qneFxAfIja
         N7eWxZvg0k8OfNah3IQz3Wm4q9E2YKNxvUjsVPIwXhPM12f9YJYVy+gsVmSanApMTorc
         TNMqR9WPRqZG7HsQb9ehQdH8JRwUTdqz8TxyerMsONHT1afgQjAkLUCpEjGnKPoy/6RI
         aOJSZbsYtjjjI5cXMVbAiJaiLRUHGQ2npUXd4blUySxduVaG2Eo5gsZjp3IzlWVkwISb
         g6jjk/Nj5P80vQECM8++wzhP2TvQuuS6q0oQrA2euxvzygH/j9AwyssUXh78dr8diBJN
         cFdA==
X-Forwarded-Encrypted: i=1; AJvYcCWv2v/8NncCKA4x2CC3VnEP7NtdYw3Db/hkf8dLf7dqA/6rHANA1M4MdTe/ausqQ6xEAHxQjvAe31bWyDcZtW5V7ixHRr5BATPiydm1fA==
X-Gm-Message-State: AOJu0Yy+V7ljrzzgvta/NuqJTTtG2cyoaPBo/MQouQk6kDnS8ruMU11D
	H42uHsnO9bSn17o5Sdz/q1iXGc4cQxWofRvsAeZ9huHX/9odnqdOxmdujCO2wgkaYxWSEc3fFnn
	Y+nDNEnphoKvUnMxF6p/zg0i9rlI=
X-Google-Smtp-Source: AGHT+IHsjbJ4PbZza+W3aQcTxSOoATC3SKX/ECIej6uPVnGR3jsA9nvYqQUvNJ40Y8HQSR9s0RAEzzJgX6ceUkxzA2w=
X-Received: by 2002:a05:620a:5a68:b0:79c:1340:8f9f with SMTP id
 af79cd13be357-79d7ba823fcmr1368836885a.49.1720006560820; Wed, 03 Jul 2024
 04:36:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240703044631.4089465-1-chengzhihao1@huawei.com>
In-Reply-To: <20240703044631.4089465-1-chengzhihao1@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 3 Jul 2024 14:35:49 +0300
Message-ID: <CAOQ4uxg8YvWYobbx5ztjkw6ZnUVgv1JDWFYq71HQ5O22=jYTKw@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix wrong lowerdir number check for parameter Opt_lowerdir
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 3, 2024 at 7:48=E2=80=AFAM Zhihao Cheng <chengzhihao1@huawei.co=
m> wrote:
>
> The max count of lowerdir is OVL_MAX_STACK[500], which is broken by
> commit 37f32f526438("ovl: fix memory leak in ovl_parse_param()") for
> parameter Opt_lowerdir. Since commit 819829f0319a("ovl: refactor layer
> parsing helpers") and commit 24e16e385f22("ovl: add support for
> appending lowerdirs one by one") added check ovl_mount_dir_check() in
> function ovl_parse_param_lowerdir(), the 'ctx->nr' should be smaller
> than OVL_MAX_STACK, after commit 37f32f526438("ovl: fix memory leak in
> ovl_parse_param()") is applied, the 'ctx->nr' is updated before the
> check ovl_mount_dir_check(), which leads the max count of lowerdir
> to become 499 for parameter Opt_lowerdir.
> Fix it by updating 'ctx->nr' after the check ovl_mount_dir_check().
>
> Fixes: 37f32f526438 ("ovl: fix memory leak in ovl_parse_param()")
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
>  fs/overlayfs/params.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 4860fcc4611b..0d8c456aa8fa 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -486,7 +486,6 @@ static int ovl_parse_param_lowerdir(const char *name,=
 struct fs_context *fc)
>         iter =3D dup;
>         l =3D ctx->lower;
>         for (nr =3D 0; nr < nr_lower; nr++, l++) {
> -               ctx->nr++;
>                 memset(l, 0, sizeof(*l));
>
>                 err =3D ovl_mount_dir(iter, &l->path);
> @@ -494,9 +493,12 @@ static int ovl_parse_param_lowerdir(const char *name=
, struct fs_context *fc)
>                         goto out_put;
>
>                 err =3D ovl_mount_dir_check(fc, &l->path, Opt_lowerdir, i=
ter, false);
> -               if (err)
> +               if (err) {
> +                       path_put(&l->path);
>                         goto out_put;
> +               }
>
> +               ctx->nr++;
>                 err =3D -ENOMEM;
>                 l->name =3D kstrdup(iter, GFP_KERNEL_ACCOUNT);
>                 if (!l->name)
> --
> 2.39.2
>

This fix looks correct, but it is not pretty IMO.
The cleanup on error is much cleaner in ovl_parse_layer() -> ovl_add_layer(=
)
I wonder if we can reuse some of those helpers instead of the current code.

Christian, what do you think?

Thanks,
Amir.

Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B450B2F6560
	for <linux-unionfs@vger.kernel.org>; Sat, 15 Nov 2025 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763215208; cv=none; b=YmtLc67FOJxx/RhhTY5KofqCyFjZwPki2msoMlEzu+v67NJ5MIv7eBW2WuSmuoBfQw5O/VS8tDazZ4HE6feMNbFG53atcSBrfykxYTJ4c6m1PowbRPB44lxtQSUN/v74KSOxrcTfW9xZb2rosUwI+AO4RTqpA+2zA3aFmUwvpOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763215208; c=relaxed/simple;
	bh=wjT4cPxw9n+CRZ5gG1OsJRuSB1fVM9ZvVkwoAk0bn3o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bgN7K4LxvD3oY3W14BgoXhHovBCcJ8dgWMTK0i6FlDAMT7T7TsDAXKUcHmnPGlhwj2mTpBXtLtcKkQu2XboNKqFdoIxc4+e1zwc1tdyo45d4BEs3xVFeE5lgdvdR4LMxd8r649NAr3k8kn86AsQJISGMAFS/cqBgdygSCKeqNIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j56cqykQ; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j56cqykQ"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b725ead5800so352239266b.1
        for <linux-unionfs@vger.kernel.org>; Sat, 15 Nov 2025 06:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763215205; x=1763820005; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J43h/1x5aKFa5ODt/fuxF1QWDhQgw3hMaLHuRT5a54Y=;
        b=j56cqykQI8Htkw8DMfR3nLAJhk0rhgCnBubaROeqWu/0GH5GAO22WAa2pUZYloxTF3
         llY6p/eygXh7k5JInR/MLoVyE29b/WDAVBucOO0a88dI7VkmFq5HrTlDPyySw941SEhV
         W/qiWImtzmqGuzNkz2n9Lve8K2xccjtKNDxp5ewRODoLKhIIj7YVvW7oD/NdYR8dYlgV
         HtoPF6QdKrc5zE7k8D1HLuk3XKY8+PCXAsIaFq/LM9aScNZzFZxHmYx9KsTj948EyY9Q
         f3V04MtwgdNgIAYxDhKsmkO6mv9XcydGtXnmgRyQCtwag4b5pXdb9H3RvhYgtLVqLlU/
         QLNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763215205; x=1763820005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J43h/1x5aKFa5ODt/fuxF1QWDhQgw3hMaLHuRT5a54Y=;
        b=f1R9LVkdUMjzYSdkcC/wqOxAMRE2uhx+70gv5FplyQ9t4v8B76Oc4Z3yuLT2OL/0Hw
         09ZyBuw0/N7H1ZDQow9xp3OAWh3b16+Mow16wcb5cBcjZZjpuRoDQKa0JTJM2dsgYJl3
         0gXd1xdQhXltE5KK7uY+rOZEdMt8Fyhl3AFj59yfXJEPjhDeHHkOPTSxaXww+TjXrUEK
         oCNtb08Wrd+g7RkS8KhEC3v6Yf29EBsVTIG9IWCNi6mPCqEe96Mc5Knd8ry3uxez4v02
         +9OuiVc/goNMcEmwJBkTWluZA3i7t3lSjpkJwnnW60MJbVeR0sVgUuYTZsqBL2Ov9H4h
         ABTQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7LMO27E36+C2Vln+UFbqoxhOaEVRIgFSqygRXWWrbkv67Wk+pGLdYdnFcAMRiyfhhPX5K741wvRN40Rta@vger.kernel.org
X-Gm-Message-State: AOJu0YyY0hz7dFirpnwHQpo5iA5E9YoOW3VU/DzsKKk6u0PVNweYalPs
	ta2etgY1DiKL1dxIrGj48yqiGsYbsDkQYOk4bNxtoAiHllGdStyvSLHUKewkO4g1WArktl3sPzz
	YI2w0zOpYeqyTaYLX00wmIepUUC2MJ0ZCdf4UozQ=
X-Gm-Gg: ASbGncs5esU4Eouvkxs4wGZWB9JMaDoFGLfPEICNTSAHLA9bdVd40TgM37b968NoRkc
	uKVKhN0fLAmamD+fyhipwuQOJ4uxjwb3N9sYAFFtrDGElBHrchH/Aeetw3RPtSzuNYJURRflt1L
	Y0Yckm59i0gxuhfKQv//m1asgqotH1uQKkkXCgdBiEadVcFodTPnsyz5L6jvqtE+qUe7/G+mFTB
	44fJ5k91aOhBw2ZHCJ3Z2gxmoLAiXXO4H8R0XZwX3ppDBiqPJNHDK1/CzsOTzVVQLH1VAEJ+wQ6
	1UrFMFjxLCPGjJg8jVM=
X-Google-Smtp-Source: AGHT+IHjbUcrFy1ldrBhWAEPrQ0poNVrH2TowQ0pqVXf+Apxrt9uWuY6zRojPvZOzHga/0hsSarrTfeb3k4Yh+CW+Tw=
X-Received: by 2002:a17:906:7305:b0:b72:c103:88db with SMTP id
 a640c23a62f3a-b736780a895mr622128166b.9.1763215204424; Sat, 15 Nov 2025
 06:00:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251115-aheev-uninitialized-free-attr-overlayfs-v2-1-815a48767340@gmail.com>
In-Reply-To: <20251115-aheev-uninitialized-free-attr-overlayfs-v2-1-815a48767340@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 15 Nov 2025 14:59:53 +0100
X-Gm-Features: AWmQ_blwwZpIsbPVgY6ZYj-L3GniCx_BIt85HbnRyVt-rQbmg0zG1y3FixVIRl0
Message-ID: <CAOQ4uxgLYwpwyoecazZovz490i3bPYSGRsi74NZQE4N4NT5q_A@mail.gmail.com>
Subject: Re: [PATCH v2] overlayfs: fix uninitialized pointers with free attribute
To: Ally Heev <allyheev@gmail.com>, Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 15, 2025 at 2:41=E2=80=AFPM Ally Heev <allyheev@gmail.com> wrot=
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
> Changes in v2:
> - moved the variable initialization to the top
> - Link to v1: https://lore.kernel.org/r/20251105-aheev-uninitialized-free=
-attr-overlayfs-v1-1-6ae4624655db@gmail.com
> ---

Christian,

Mind picking this one?

Thanks,
Amir.

>  fs/overlayfs/params.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 63b7346c5ee1c127a9c33b12c3704aa035ff88cf..37086f73ac3ecfcd1c09ae6ec=
cbb69723006e031 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -448,7 +448,7 @@ static int ovl_parse_layer(struct fs_context *fc, str=
uct fs_parameter *param,
>                 err =3D ovl_do_parse_layer(fc, param->string, &layer_path=
, layer);
>                 break;
>         case fs_value_is_file: {
> -               char *buf __free(kfree);
> +               char *buf __free(kfree) =3D NULL;
>                 char *layer_name;
>
>                 buf =3D kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
>
> ---
> base-commit: c9cfc122f03711a5124b4aafab3211cf4d35a2ac
> change-id: 20251105-aheev-uninitialized-free-attr-overlayfs-6873964429e0
>
> Best regards,
> --
> Ally Heev <allyheev@gmail.com>
>

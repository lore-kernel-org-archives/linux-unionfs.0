Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4956B1AC243
	for <linux-unionfs@vger.kernel.org>; Thu,  4 Jul 2024 11:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720093519; cv=none; b=HbgUKGXEmSAaqUBtneXVPi6qenUBVYArOYzt/vD5vMAB69kyFzGmza9sZNZ7pJYL0ik7EZExIqAE8pvjxfW8MdPOX6yiLjsYjKm6I5AAq6YhlpoG6Is8EvtgU9QxC5WJbLeDKnMEx5hK9cEBIWi4dXWwjTgOpqs0lJXDOvhRswY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720093519; c=relaxed/simple;
	bh=BRyiF2gav0fv7XCs7zygVMK1IqNX9SARt7VxNefvbfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o2hmWrsi1qkZ1hJmmZIBoUUuxruIcXHNJeI+WG2DLnCbTX/yjKLp8fwRs9bMBFANwi4nPbco/qBiK7sFMv645xF2ITE/KCVxzCe2YfIIJQbyY+JLY/YL+UazvpxZ8EGXXSvyuFUPmYuarRf+kboDD+rn/JVnKY5s6dw78A1EjM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cOw2XsWm; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cOw2XsWm"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-48c2d353b01so233902137.2
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jul 2024 04:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720093517; x=1720698317; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wi+ApdDUenswkaDCWrPBxsM1B6bY8/TMsPouCDV66bw=;
        b=cOw2XsWm84xBhdKCB6HS65TG0uWSt3Besdo5fyLZzunGQG7namvlhh205fu3vHEHzF
         xCqUmKX+VJAw+jG6h8c1Zos4ZoA/Dx0kAt9MNPAw+o/z1y32xJOtKScMN3rTYCPp/ZwU
         3QRuOrfCAZ9xQmcauMfHmBCjGxScVVxo7fRgC78LvwL6EDvAsmodl6uOIel1z9wNZ0p7
         ZW9bAcPWVxf+rC5HHATYicd5IKq+POmIgLbTwB31vJ4gXj4bMmpFC6PdhMgjl2BjsveQ
         ER0QK5Uoxq1OxomHYSAgKiVHMnA1a63zKM/TrZ1nG8PXaEQDXZXKXd9HfQSQ6kL8mZRG
         RnJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720093517; x=1720698317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wi+ApdDUenswkaDCWrPBxsM1B6bY8/TMsPouCDV66bw=;
        b=k57nyghDEUDixbEicSbiNxe7W0vRuRSwMbqTkoCgnxoM239DBMitwL7rkJPYe+Sxwv
         Y4cqdZTUgRonlV89/gcePw38wYqlj8nOkgow1RPBfASTelDBt/Zmg001oLYd+SDmZQDJ
         QjRMwLbOFGMIP1BtJb3qGk/BYyR+eEd3LuYLlxiXSdZ0n2BNBNsjn4AFd3ZQgmE82ySD
         XNhnNs50q0gSgCKn25nwfPTPTCbYQpbpFkx0kzKLENHed6JmdHRNOqydCTAziN2BPjSC
         rGxoBAC4WPa7oIep0o4cz2DnT+ktOW08i3EZvcg2p9+U8JrP5pmd31DXNtAprF8ncDVi
         dj4w==
X-Forwarded-Encrypted: i=1; AJvYcCWx4Lij4L9gB5zcHyHt8IufvgXxv2h1Iqn42FwuB7//bMHx7FpKMiG5OkzYGDM7V0MCQhho78BUxJdY79Ti3KQ18zPrpMlr7mxo4tHMxw==
X-Gm-Message-State: AOJu0YwQ7YmfsoANqo8ugYn8W2AcZQmKcQuaDq2xgsm3yZehkm5ld/0Q
	5uAXgy5Ezn2ut22z/EqTuGQDxmbsB+XnneDzfE70+J7VZoEJGq7AJsrk1GGA+SdtYj7iKwFviv0
	0w7/9SQZ48Xj//A+TABVHFllQqm0=
X-Google-Smtp-Source: AGHT+IGt0UoH7lNg8dvPa44FWmnGuD6qRZuEIkwhIOajXOXd6TbkJ+9kgGicdc/hxi3kM7fioB7wpmtaLRv5fKm9iUE=
X-Received: by 2002:a67:fe16:0:b0:48f:92e4:f295 with SMTP id
 ada2fe7eead31-48fee66ef57mr1472972137.18.1720093516955; Thu, 04 Jul 2024
 04:45:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240704070323.3365042-1-chengzhihao1@huawei.com> <20240704070323.3365042-3-chengzhihao1@huawei.com>
In-Reply-To: <20240704070323.3365042-3-chengzhihao1@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 4 Jul 2024 14:45:04 +0300
Message-ID: <CAOQ4uxhxsZqk8AgMd+0jk-t3zzHXO87zWPbHxmGeFqw2vbFDRA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ovl: fix wrong lowerdir number check for parameter Opt_lowerdir
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 10:05=E2=80=AFAM Zhihao Cheng <chengzhihao1@huawei.c=
om> wrote:
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
> Fix it by replacing lower layers parsing code with the existing helper
> function ovl_parse_layer().
>
> Fixes: 37f32f526438 ("ovl: fix memory leak in ovl_parse_param()")
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---

Looks good.

You may add

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

>  fs/overlayfs/params.c | 40 +++++++---------------------------------
>  1 file changed, 7 insertions(+), 33 deletions(-)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 52e3860973b7..8dd834c7f291 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -353,6 +353,8 @@ static void ovl_add_layer(struct fs_context *fc, enum=
 ovl_opt layer,
>         case Opt_datadir_add:
>                 ctx->nr_data++;
>                 fallthrough;
> +       case Opt_lowerdir:
> +               fallthrough;
>         case Opt_lowerdir_add:
>                 WARN_ON(ctx->nr >=3D ctx->capacity);
>                 l =3D &ctx->lower[ctx->nr++];
> @@ -375,7 +377,7 @@ static int ovl_parse_layer(struct fs_context *fc, con=
st char *layer_name, enum o
>         if (!name)
>                 return -ENOMEM;
>
> -       if (upper)
> +       if (upper || layer =3D=3D Opt_lowerdir)
>                 err =3D ovl_mount_dir(name, &path);
>         else
>                 err =3D ovl_mount_dir_noesc(name, &path);
> @@ -431,7 +433,6 @@ static int ovl_parse_param_lowerdir(const char *name,=
 struct fs_context *fc)
>  {
>         int err;
>         struct ovl_fs_context *ctx =3D fc->fs_private;
> -       struct ovl_fs_context_layer *l;
>         char *dup =3D NULL, *iter;
>         ssize_t nr_lower, nr;
>         bool data_layer =3D false;
> @@ -471,35 +472,11 @@ static int ovl_parse_param_lowerdir(const char *nam=
e, struct fs_context *fc)
>                 goto out_err;
>         }
>
> -       if (nr_lower > ctx->capacity) {
> -               err =3D -ENOMEM;
> -               l =3D krealloc_array(ctx->lower, nr_lower, sizeof(*ctx->l=
ower),
> -                                  GFP_KERNEL_ACCOUNT);
> -               if (!l)
> -                       goto out_err;
> -
> -               ctx->lower =3D l;
> -               ctx->capacity =3D nr_lower;
> -       }
> -
>         iter =3D dup;
> -       l =3D ctx->lower;
> -       for (nr =3D 0; nr < nr_lower; nr++, l++) {
> -               ctx->nr++;
> -               memset(l, 0, sizeof(*l));
> -
> -               err =3D ovl_mount_dir(iter, &l->path);
> +       for (nr =3D 0; nr < nr_lower; nr++) {
> +               err =3D ovl_parse_layer(fc, iter, Opt_lowerdir);
>                 if (err)
> -                       goto out_put;
> -
> -               err =3D ovl_mount_dir_check(fc, &l->path, Opt_lowerdir, i=
ter, false);
> -               if (err)
> -                       goto out_put;
> -
> -               err =3D -ENOMEM;
> -               l->name =3D kstrdup(iter, GFP_KERNEL_ACCOUNT);
> -               if (!l->name)
> -                       goto out_put;
> +                       goto out_err;
>
>                 if (data_layer)
>                         ctx->nr_data++;
> @@ -517,7 +494,7 @@ static int ovl_parse_param_lowerdir(const char *name,=
 struct fs_context *fc)
>                          */
>                         if (ctx->nr_data > 0) {
>                                 pr_err("regular lower layers cannot follo=
w data lower layers");
> -                               goto out_put;
> +                               goto out_err;
>                         }
>
>                         data_layer =3D false;
> @@ -531,9 +508,6 @@ static int ovl_parse_param_lowerdir(const char *name,=
 struct fs_context *fc)
>         kfree(dup);
>         return 0;
>
> -out_put:
> -       ovl_reset_lowerdirs(ctx);
> -
>  out_err:
>         kfree(dup);
>
> --
> 2.39.2
>

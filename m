Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC9F15EFCA
	for <linux-unionfs@vger.kernel.org>; Thu, 11 Jul 2024 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720704927; cv=none; b=k7GIH9vc0eg+oIB2Pe61yVhLlpTJA8+C12Q4nJAtCAo4jdqZCOKH5JyTHoJNTmcL7rZOXL9L0jyctw4ZECWqecvIU74NPFk3TVc9Zm06NzmyLy75UIll8iZp4dLGCrwaVg0ma8OzNfBjPcChRi8fwjrNE169FFpv9UYqF536dWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720704927; c=relaxed/simple;
	bh=Ygfr52KuMhXzV+sPAuLDfAuTDmDpA/aVDE9z1CdvpRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ktPFu+gaK5J7axXHoK8iTAQvNtTHVFPXnNfEEe5L9oU9S+FxahVvSrewHWh/weBNxIrp/h1pcoq21u7Nfi1vrQxjRMhB4dmKmMaHuUNIdBqw4Q1TFyalT4nc/923YmbBNkAVaWJtLXIiJ4X/W5UbaI8JsW6WdMOZ2Uub+P09AME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cyIzd2iA; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cyIzd2iA"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-79f18509e76so52014885a.1
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Jul 2024 06:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720704925; x=1721309725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i2gdkU3AMmHyFSOSxvOqxc57V901sky92W/TOxXkAXs=;
        b=cyIzd2iAE54DKPo9rXHBWKRH48noem7JvGRBnSwBHPKyNiK2ShhO4m58fW/N0sZBLY
         W+JGYfFqqOnz6rC1FQ3Q7LTyk8oIWoGTiEsHCPGLl4yKxtB61hqyuH0y2XXrGIHOQl0l
         ZzVFTYgqhDb1H04ThhafpVUNwDjYSkwr66lGRR5aDmr0r3EyMsYdhO/MDqTq4FL/k9C0
         FvjYSzvXgigWTDkvDviDpnFBt/HejKde6/W8GEdqZZuI0dJUP6jcp0tanXOTbR4O6ePg
         0svLmBXuo621suFPsTxf3EtH4CJYx8tpUle6vt/E0/0+Y6k+PNYBOn1GZfakvUiHK1Hg
         FKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720704925; x=1721309725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i2gdkU3AMmHyFSOSxvOqxc57V901sky92W/TOxXkAXs=;
        b=kcziS6qPKQaoeApCicJ+Y2ZLwGGvEKzYioQriMChgsJ1sKGIw+FtCNWYfi8riljnEh
         5Xpu9yKtDtlih8cNKTdYt6gxsNRTnCD2A5LFVCcj2qCtMYRRMg7T/zUdfnAM93Cbo8V0
         /QMpJXl1E8cfkh8CikDAKRbuuN/t2fQ9pB00VLtP1Wd9oRWZjITiEIzvVXDG7noCoygw
         KFhijjJu+c0vBpOYnKNtWVwlblbJAFlBI8KgbL9G6mAoIfwECkc4NIkOoWCBWbJQKNsE
         Qw8H2wMe7zgeZc8LwLZ24Zhy2edN7huS6HUXE6anIgZd/JszSfYKnNSEZUSBgHPgMuBu
         Maxg==
X-Gm-Message-State: AOJu0Yy5CCNzZshz6FdWzDqcv8NeLXRC1h5YWXNqZ1tJZK1W9MllJj98
	y0y14wF+jzq7hl5qcfAQKj26iFe3n8x+pX5CQdRe+aQHgcATFJFOivherCyrRQnxODK0c1SBmZH
	Bp1KfNutrn13ONsecggV9d1jypD0=
X-Google-Smtp-Source: AGHT+IGZ/EdVRyDAIyRRJo8vFmIRE06MNoy/SqTthQTKsnjEwFZYtWBQkohUT3TkSHi8Mh9Zby3qD4b6Yf+ZRiCgQwg=
X-Received: by 2002:a05:620a:2186:b0:79d:6dd6:5a66 with SMTP id
 af79cd13be357-79f19a51e5dmr923234885a.36.1720704924828; Thu, 11 Jul 2024
 06:35:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2e8c4e8b-3292-4ccf-bb63-12d7c0009ae9@mbaynton.com> <20240711035203.3367360-1-mike@mbaynton.com>
In-Reply-To: <20240711035203.3367360-1-mike@mbaynton.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Jul 2024 16:35:13 +0300
Message-ID: <CAOQ4uxgxpnj1r-p9Y=OkP=Qk2YM9jZ37Pm0NBN1R=NagZuhioA@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: Fail if trusted xattrs are needed but caller
 lacks permission
To: Mike Baynton <mike@mbaynton.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, 
	Alexander Larsson <alexl@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 11, 2024 at 7:05=E2=80=AFAM Mike Baynton <mike@mbaynton.com> wr=
ote:
>
> Some overlayfs features require permission to read/write trusted.*
> xattrs. These include redirect_dir, verity, metacopy, and data-only
> layers. This patch adds additional validations at mount time to stop
> overlays from mounting in certain cases where the resulting mount would
> not function according to the user's expectations because they lack
> permission to access trusted.* xattrs (for example, not global root.)
>
> Similar checks in ovl_make_workdir() that disable features instead of
> failing are still relevant and used in cases where the resulting mount
> can still work "reasonably well." Generally, if the feature was enabled
> through kernel config or module option, any mount that worked before
> will still work the same; this applies to redirect_dir and metacopy. The
> user must explicitly request these features in order to generate a mount
> failure. Verity and data-only layers on the other hand must be explictly
> requested and have no "reasonable" disabled or degraded alternative, so
> mounts attempting either always fail.
>
> "lower data-only dirs require metacopy support" moved down in case
> userxattr is set, which disables metacopy.
>
> Signed-off-by: Mike Baynton <mike@mbaynton.com>

Looks nice

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>
>  v1 -> v2 not specific to data-only layers, punt on metacopy disable
>           due to xattr write errors creating a conflicting configuration
>           when data-only layers are present.
>
>  fs/overlayfs/params.c | 39 +++++++++++++++++++++++++++++++++------
>  1 file changed, 33 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 4860fcc4611b..107c43e5e4cb 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -782,11 +782,6 @@ int ovl_fs_params_verify(const struct ovl_fs_context=
 *ctx,
>  {
>         struct ovl_opt_set set =3D ctx->set;
>
> -       if (ctx->nr_data > 0 && !config->metacopy) {
> -               pr_err("lower data-only dirs require metacopy support.\n"=
);
> -               return -EINVAL;
> -       }
> -
>         /* Workdir/index are useless in non-upper mount */
>         if (!config->upperdir) {
>                 if (config->workdir) {
> @@ -910,7 +905,6 @@ int ovl_fs_params_verify(const struct ovl_fs_context =
*ctx,
>                 }
>         }
>
> -
>         /* Resolve userxattr -> !redirect && !metacopy && !verity depende=
ncy */
>         if (config->userxattr) {
>                 if (set.redirect &&
> @@ -938,6 +932,39 @@ int ovl_fs_params_verify(const struct ovl_fs_context=
 *ctx,
>                 config->metacopy =3D false;
>         }
>
> +       /*
> +        * Fail if we don't have trusted xattr capability and a feature w=
as
> +        * explicitly requested that requires them.
> +        */
> +       if (!config->userxattr && !capable(CAP_SYS_ADMIN)) {
> +               if (set.redirect &&
> +                   config->redirect_mode !=3D OVL_REDIRECT_NOFOLLOW) {
> +                       pr_err("redirect_dir requires permission to acces=
s trusted xattrs\n");
> +                       return -EPERM;
> +               }
> +               if (config->metacopy && set.metacopy) {
> +                       pr_err("metacopy requires permission to access tr=
usted xattrs\n");
> +                       return -EPERM;
> +               }
> +               if (config->verity_mode) {
> +                       pr_err("verity requires permission to access trus=
ted xattrs\n");
> +                       return -EPERM;
> +               }
> +               if (ctx->nr_data > 0) {
> +                       pr_err("lower data-only dirs require permission t=
o access trusted xattrs\n");
> +                       return -EPERM;
> +               }
> +               /*
> +                * Other xattr-dependent features should be disabled with=
out
> +                * great disturbance to the user in ovl_make_workdir().
> +                */
> +       }
> +
> +       if (ctx->nr_data > 0 && !config->metacopy) {
> +               pr_err("lower data-only dirs require metacopy support.\n"=
);
> +               return -EINVAL;
> +       }
> +
>         return 0;
>  }
>
> --
> 2.34.1
>
>

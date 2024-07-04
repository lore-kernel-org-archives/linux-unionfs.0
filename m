Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAB61A4F39
	for <linux-unionfs@vger.kernel.org>; Thu,  4 Jul 2024 11:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720093193; cv=none; b=rQM8BR8M6Y5amRhmBGo690LKkfYyES6LcZx58Hsm7Yf8Bg34mlUNJaDDYL7+ZuFGpoETuyXnZxE8cwuDCvD5wKv6fj2RVMWp+FzjPM8TtcqzZ3uFfxudQlK5Qb/qx8IX/rdtnHApr6Su+5t9+5wkGG5GqcV7u8sDh+UZcuUVJGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720093193; c=relaxed/simple;
	bh=Zv26siiUJVCyvgxTQ/tXZQ2Io+dxA0Ipt94SUd1dRiQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CX38WdRXQYFGlOs6jRLVM2rTbM/9Wtn8JGl19PpTYUpRjTLJZ9CheMzF4i/ZZZJNjWNYPIBizCjw0EMa/skDbppEAStEi2wich9J/eWPoqT7MMNODfKvmrW/KZbhCqbFxFCr7cETPt6mVfUVw+OIS1K+P+s1JVgUjTbJI3uJYCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nEvTl8a1; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nEvTl8a1"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-79c0f8d6ec5so38321485a.0
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jul 2024 04:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720093191; x=1720697991; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WBfTlNc+lvxq5szW7R1BZOoJoTUIxfZ9TYHK4aUHVkE=;
        b=nEvTl8a1Nz0LNByPjfS/wRALGegbkK6nIYMqJX/JbQnKvLEgT/+7tzdzRy+Y65BkU2
         Gj8joYqFuGfNIczR95vudEZhAc6sTTontbywlFuRx5ohJCtGMY9R/taBTlDt+soWyDwa
         DNzcxPXrUgdxQY9rcb8oIbL5nBocBCjhoERwiLEl6FftNPV+h0frWr/rFMxjiafbp2cW
         FOz1nIMbZoKYbZ6a1VegFMHlUglTFX2Gos229/uBsmH5Q7b5SMddcEaDARQBoii7vo3C
         KHa2K2F2p44b0lJA/i6L71Y+R3ogFyGHDL2wUTa/7UGfb9uD6xgugAKlDdScCRixj/yd
         7nEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720093191; x=1720697991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WBfTlNc+lvxq5szW7R1BZOoJoTUIxfZ9TYHK4aUHVkE=;
        b=jLyweoc8/jqVtuYESzOgHMPEIZ8V8NXi8GF6Wxp+nl9bHj2IroaLjTGhAqB1IaCGl1
         9E8YGBpl+QrHKvRndJleuXMqtp2KnwL5L9ni23Ejg/4plNGxnYE7cOdYMlVcQWZhRYCl
         GVQpxt/3UXkhOHcdvYrICm/pXPgc/WfoetGEiPYFYJSSwfiKLNiuctizJrRLmz1n9tFb
         JkthNKs44ZFZ1qXenFfpntjyBCf3qb135ozeHCHFkyTSwuNmoqhwpoN/Ym5sHOesYKp1
         aER4BWglpzfXxg9fUx3Jgk8qjXEwwwFQuzBTPj+IeViiD/tLDqR8LfYLWhQswQYNFyvN
         pB9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXalKmze2jCp+npLazvuVRjAAFQQnRWBx3viLsVtSx80KTHLOI1tVnRxFfQiJe/t7KdKu241VYSxWTm9ziqG//4H4eRL+IgmsKjPTM2+A==
X-Gm-Message-State: AOJu0YyPAp9I/7MffljhwH3C+Acv7OXDm0R6tr9K7lelzNaHzKhWb7/L
	3jNs11B+PA5yy5wACVRCFGxQ+zNDzDRIeXPhCSmVWPEY3hcnK4sU7UshIH7ggNYiMpWVVcAO8je
	N86H2n85kVT3Vc0pqG85NajN2zLk=
X-Google-Smtp-Source: AGHT+IG/g1IdVvpzH8RA4nI7cPNrv65q/zhHIx8VWR6FIoBGDjhjp3ctDb4PEMhVwUBVsSftnQQTOT7+aejWr/UsW2I=
X-Received: by 2002:a05:620a:136f:b0:79e:e3b0:436d with SMTP id
 af79cd13be357-79eee29b1e4mr148335385a.52.1720093190983; Thu, 04 Jul 2024
 04:39:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240704070323.3365042-1-chengzhihao1@huawei.com> <20240704070323.3365042-4-chengzhihao1@huawei.com>
In-Reply-To: <20240704070323.3365042-4-chengzhihao1@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 4 Jul 2024 14:39:40 +0300
Message-ID: <CAOQ4uxgfkjKD-XqFSMghZNubvKNErcU=KS9+mKax+R=MBwfi4g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: ovl_parse_param_lowerdir: Add missed '\n' for pr_err
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 10:05=E2=80=AFAM Zhihao Cheng <chengzhihao1@huawei.c=
om> wrote:
>
> Add '\n' for pr_err in function ovl_parse_param_lowerdir(), which
> ensures that error message is displayed at once.
>

Best have Fixes: for this one as well

> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
>  fs/overlayfs/params.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 8dd834c7f291..657da705db25 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -493,7 +493,7 @@ static int ovl_parse_param_lowerdir(const char *name,=
 struct fs_context *fc)
>                          * there are no data layers.
>                          */
>                         if (ctx->nr_data > 0) {
> -                               pr_err("regular lower layers cannot follo=
w data lower layers");
> +                               pr_err("regular lower layers cannot follo=
w data lower layers\n");
>                                 goto out_err;
>                         }
>
> --
> 2.39.2
>

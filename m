Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3818A19F42C;
	Fri, 17 Jan 2025 17:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737133215; cv=none; b=U8cCLhb6FAvnSPWlalBViG5D1laurGHSVji3meBTOscFKAZbJokWpuoAY40DYnpfznkXu05Y0Z4ZhRHT7gaw0pUvHJWZlwUF/A2XHhzaV28yqXYaifQ9R/y9zSPgvduegeGJbRDMganS2/K2CmFC+/0bG9lauueTFreZQvEmaxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737133215; c=relaxed/simple;
	bh=Q3vbN079vU5oqdrL/sZcyq6Khm3/odwk61hyjwIOwkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OF3TMmV0UJnGoPMb72b11qZoIwiOvpFGP83jHfKxtb/R06iWUmhSRk5QGvyLQfXfc/X3PjzTMV67pj4Mu6mqoU4YKoKqn3IokjEDO2PC988rKgwfy6xBhVhEFMLNO7rQtuelR1W5J0QYowFVa+bkoUYZNE0SVQnezUTQ8pyP/f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZURs2zzY; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZURs2zzY"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aab925654d9so413074766b.2;
        Fri, 17 Jan 2025 09:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737133211; x=1737738011; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dE2F3JdfF0ga1Jk7ZXKHjELoEtT1VQLe+mXRnLdiGks=;
        b=ZURs2zzY/ce8zN6p5dYwogrBGaRGb5gQgIjg+1JlodeNdOyAey1QuvrAjy4BnWiFhG
         SnHqY/BsPhpl79p2fBGLUHFvWx2ZA3ZUBdLFZbadIW9yeEV3XmhVjczJtIWvWXhFhyXz
         OUJZr3A3uTeQXBeaj5taFeiZMRuujiwXSRxp9XePAWlUUH7WwizAdqosGE7JzOLdS6HK
         Mrf96BACM+QNZXqxdvlGMArUDyLnDBvPIS4Gdy1oIVeTnl8OLCSs5dz3AqeoZhECRGNR
         a9x7mzro4WblQkO2GA7ArcAXWk/z+p6Xn9Lb4Ves99CRDHxBPnbh9KwLUL2o3JN6Vkpe
         sgNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737133211; x=1737738011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dE2F3JdfF0ga1Jk7ZXKHjELoEtT1VQLe+mXRnLdiGks=;
        b=ReuyJiNIi/lRWJXpqUFG/LY9yjwmIfxza7xCLaH3JShgpyG6CZsVgsZfdkfPZdwM1M
         /rtpch+d4K9o/vcQLtWQWz5kgfuaP11hfpbIeLwXoubeS/8j2Rs6jQDZJOEsp01CFc+5
         p2KYg06ocKngtbF8bjL/Tpeg0w95SGSkJllfl5KfQ6rVzDhat4dUIcxEYzdrB9oLWB/l
         LEAKzLGPX9305yc99YAtWuS58xrS9/McSbSPZn+d97Qspwl7FG/dskdCB+S9PTMTcxPt
         RyuilU50f3F1//Y82S4m0/7Rbat2bSOs+O74x7D094aLbcq6+c0CLhdhSmDkMHVhPNRy
         FrRg==
X-Forwarded-Encrypted: i=1; AJvYcCU/JkGTENDTyjvDTBjJE9TvKwdLVSkzLX2L3tvoUVp1X0nUivYX6wbvOybTXEvT6rGweMUTp99s6/UEyis=@vger.kernel.org, AJvYcCVObPu6rzAdDerB4+5ssy9nGtHOfnS2ZAVE9/J0400xbuzl+36JRijZAS9Fh2qNIynUCSsJ5NIA5eHAsBaavQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzwI/3Oksm5CMC8gRj862ljVSCf1iOXPYNdkDkxQMmEEWy4CyRk
	rtEw4s+46ZTx7NaC2w/Ce1jDgwV5vU21+CUw95FGd3cXXFAWc7C6UShNkTapiK5GnyMhrdYgckG
	X0wAC5uf/iWhtF1OqmaEb6pgfR8U=
X-Gm-Gg: ASbGncuHIvKSL4IOaQSfWQrKrWL7GwKoeCemjlRXKLTnAFOmxBewzJ/eZci1WV5n7OL
	UdUYayL00WabdWuETEgK1CmCMMd+mtP4lxhqf+A==
X-Google-Smtp-Source: AGHT+IGPiPie5uiKLMhaRg3WOO49py68gmuSSsfkWTGg7oXTRNi+rCJDbE7meMS9eY6bXJToXrMMW7urMPyBonQot8I=
X-Received: by 2002:a17:906:7953:b0:aa6:6885:e2fa with SMTP id
 a640c23a62f3a-ab38b26f4acmr275298966b.14.1737133210803; Fri, 17 Jan 2025
 09:00:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117145155.171969-3-thorsten.blum@linux.dev>
In-Reply-To: <20250117145155.171969-3-thorsten.blum@linux.dev>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 17 Jan 2025 17:59:59 +0100
X-Gm-Features: AbW1kvaXchbNLHjKn09beAlJ0u4oW9rHhASZrs4rbxnzZJ3Mmi8TfHTuN0S3bok
Message-ID: <CAOQ4uxgqXEXfXHwAFakgT1-rSjORDjC3t0q9bY9Km3LD5K1HLg@mail.gmail.com>
Subject: Re: [RESEND PATCH] ovl: Use str_on_off() helper in ovl_show_options()
To: Thorsten Blum <thorsten.blum@linux.dev>, Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025 at 3:52=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Remove hard-coded strings by using the str_on_off() helper function.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---

Fine by me.
I do not have any patch queued for the next merge window,
but if Christian wants to pick this up via his vfs tree, I wouldn't mind.

Acked-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

>  fs/overlayfs/params.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 1115c22deca0..8a8bb336b40f 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -1053,17 +1053,16 @@ int ovl_show_options(struct seq_file *m, struct d=
entry *dentry)
>                 seq_printf(m, ",redirect_dir=3D%s",
>                            ovl_redirect_mode(&ofs->config));
>         if (ofs->config.index !=3D ovl_index_def)
> -               seq_printf(m, ",index=3D%s", ofs->config.index ? "on" : "=
off");
> +               seq_printf(m, ",index=3D%s", str_on_off(ofs->config.index=
));
>         if (ofs->config.uuid !=3D ovl_uuid_def())
>                 seq_printf(m, ",uuid=3D%s", ovl_uuid_mode(&ofs->config));
>         if (ofs->config.nfs_export !=3D ovl_nfs_export_def)
> -               seq_printf(m, ",nfs_export=3D%s", ofs->config.nfs_export =
?
> -                                               "on" : "off");
> +               seq_printf(m, ",nfs_export=3D%s",
> +                          str_on_off(ofs->config.nfs_export));
>         if (ofs->config.xino !=3D ovl_xino_def() && !ovl_same_fs(ofs))
>                 seq_printf(m, ",xino=3D%s", ovl_xino_mode(&ofs->config));
>         if (ofs->config.metacopy !=3D ovl_metacopy_def)
> -               seq_printf(m, ",metacopy=3D%s",
> -                          ofs->config.metacopy ? "on" : "off");
> +               seq_printf(m, ",metacopy=3D%s", str_on_off(ofs->config.me=
tacopy));
>         if (ofs->config.ovl_volatile)
>                 seq_puts(m, ",volatile");
>         if (ofs->config.userxattr)
> --
> 2.48.0
>

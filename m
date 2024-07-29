Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192C284052;
	Mon, 29 Jul 2024 06:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722235448; cv=none; b=gYCxZhhQwMYeVPNQuOs/nIKJraYH1/qcbUkTqlIQvDMJKvm/2em9rNkQQjpiGMCclZ16m4J0Rpg+AfWguHklH+HeT+/6txQPWIXZl3vR8+YLvU1eGIO6fpDEM1BOi5SZZeUcb2TPC5OoDYma8uRKwRL8uKpyZOmRLcauIl6C/CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722235448; c=relaxed/simple;
	bh=nfZFHQsuPpII2CMYTDR/XbTt1dybrlIDSqbwDvoHSnE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nFO5rDgCzQRJ/viEnxFWtewvW3ark+VAta4kDr5LSY9BmDeciDtWD9vfrAANs/oLQeM6azP9fthSQNbTOn4jelWPuPxgRqgJKkihtJcA9bOhCehXrQSVEZlVoxg24O+BPk8DlfXZdYaFNJuNGge/V/Cr2cRlomej8ZOpXq/0DRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=goIIPy+T; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="goIIPy+T"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7a1d6f4714bso212016685a.1;
        Sun, 28 Jul 2024 23:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722235446; x=1722840246; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HwbgBKukoclBXA9WyOb5l4iDdLNe3EoU9Xh9fHVo2QY=;
        b=goIIPy+TkfVOicKnNgweS8Wv5LwsioHpmGSAV5Xh8XpU8Fsnyyo9aN7B6ZbBWbxXhA
         FmR+RUf6MwWfX1GHjC+BMhKReq4RI+6301EfidAIbtpSiRHbMxkpkQbf0tufVRaXP8n1
         K1aMaa4EAeQHXtbXclUA8P2PuiKIS/NbWYsh+NI1odrGsBVob7iyypcWnZ3+nAwPT9ro
         U7S7u22BiNiWLl5YbZVgkqOzWH9DGBTdebgRD2nUsENfQfsRsedXFwmHM3IZGzgzU6Ar
         NZ9wUkiQXqJ4kjdiKbnfSq7DdQzmrnGzB/yg7bDBiydYWTReYR/NZ8Z040j5H2M5DZJY
         3tkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722235446; x=1722840246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HwbgBKukoclBXA9WyOb5l4iDdLNe3EoU9Xh9fHVo2QY=;
        b=YHUzp6oOh46AmXK/KdNToOO0+42YzeVbwaWyo9SapuLqsGGzeSWVC7XE3lduiiql0w
         jgc67+KwzAi5UzkcqOH0vdLuvx22ShmYcPtseIOzzPws58XJO7myfgbFX3gEHEpAdZ4V
         fiQAX9iTS0bpeMFGJAlyBKAa2Ov8GBlTeBaIooTFjH3JtyH9VGJbtn1zqMgTBhTdJCrx
         zkh6Zv95RINWOV3hYMXv5O83DzmzatSeYrOziAImojNwl58HTyEt3N+Z/eCxOfsUPRmH
         R9aOeIqxvDmUBm48VGuH4bs6ViQHxQz/T+66CZqrHEYj65jBUm4t4brXKskNRFHymFLd
         s4Ug==
X-Forwarded-Encrypted: i=1; AJvYcCXkLIvNvzFfF6InPoGI27JA25oBUFaYiO4tqlNGRuS5RH427sjMHU1d6s1PRNGN5jT4StNnleRVAi5ybf5KHOzJKZccAOpE2t2LRo6dF7Gy09f6FxbgkKI6Tjk8FcrlF/21zICWj0KMOwtGKA==
X-Gm-Message-State: AOJu0Yyl67/abSpVwcHFONC8V2k9mzb/hX95uQ3s230PHHM8OztVcyTO
	F73uKR4OPvstj8hV9IXLguo5yxcyBTCTow2iJXkOTBj2yPJWjJ345v3O6qxfZnyYxTGjTiJI4/Z
	5/deTxpbMATXyrOWBY/LunoTg+qM=
X-Google-Smtp-Source: AGHT+IFmvsdi/z9/ZLozcv1MG4GRT/Jreb5Y/MsK0RO45WV+X6e0LsDpdj7sCrXgQ4LSfonW0K5zRBqZ9d+bEZ6tIXc=
X-Received: by 2002:a05:620a:1a12:b0:795:5f15:f9e8 with SMTP id
 af79cd13be357-7a1e57a7708mr1115233885a.31.1722235445868; Sun, 28 Jul 2024
 23:44:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240729034324.366148-1-haifeng.xu@shopee.com>
In-Reply-To: <20240729034324.366148-1-haifeng.xu@shopee.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 29 Jul 2024 09:43:54 +0300
Message-ID: <CAOQ4uxi4B8JHYHF=yn6OrRZCdkoPUj3-+PuZTZy6iJR7RNWcbA@mail.gmail.com>
Subject: Re: [PATCH] ovl: don't set the superblock's errseq_t manually
To: Haifeng Xu <haifeng.xu@shopee.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 6:43=E2=80=AFAM Haifeng Xu <haifeng.xu@shopee.com> =
wrote:
>
> Since commit 5679897eb104 ("vfs: make sync_filesystem return errors from
> ->sync_fs"), the return value from sync_fs callback can be seen in
> sync_filesystem(). Thus the errseq_set opreation can be removed here.
>
> Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>

I would add either Fixes: or Depends-on: to prevent accidental
backporting without the dependency.

Otherwise you may add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

> ---
>  fs/overlayfs/super.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 06a231970cb5..fe511192f83c 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -202,15 +202,9 @@ static int ovl_sync_fs(struct super_block *sb, int w=
ait)
>         int ret;
>
>         ret =3D ovl_sync_status(ofs);
> -       /*
> -        * We have to always set the err, because the return value isn't
> -        * checked in syncfs, and instead indirectly return an error via
> -        * the sb's writeback errseq, which VFS inspects after this call.
> -        */
> -       if (ret < 0) {
> -               errseq_set(&sb->s_wb_err, -EIO);
> +
> +       if (ret < 0)
>                 return -EIO;
> -       }
>
>         if (!ret)
>                 return ret;
> --
> 2.25.1
>

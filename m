Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E15314D06
	for <linux-unionfs@vger.kernel.org>; Mon, 27 Oct 2025 17:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761584892; cv=none; b=cZxNR2YR36KC+5xs694Q5b9RHgGYcc8gg474tUQNxuNpUuPudTYJ4AzuiNq/F5bNZx6exdFtgPDhZAIaeR7DCjo0XWzpq+SokAUIPOfbgM2mE+Gu6zXBwWsZ2YvefaISvYJQ2ieBYTl/JigPC8UHbTQ/v2m1rdndz+IgDoT3j+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761584892; c=relaxed/simple;
	bh=Ka53cxpwq6TDd0s/BJwOxT5nR+b4eomfy9aOxOy90KE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lq+unnVHorQ9Du2X9C6npewxHD6zonVtaAA/jVxQ/nIvD9NxSdFdWrK98CnFqdfi8k9E4k+O0CLKQb2xC2lWxBPckuMeQ8qcV9KogWOA8/WcvgfvMil4Lz4bSIy6cyWbGwVVkMTKBowvLO48cjBbT+JaMzVZO5rIAAOq6o8Sq2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MaWNK4M0; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MaWNK4M0"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-63d6ee383bdso10673857a12.2
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Oct 2025 10:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761584889; x=1762189689; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/aJpcx16wEq6iLWJmAYoLVa/ENBxlXQoVj8lw6qVT8=;
        b=MaWNK4M0VwrMlIeg+emRdp+Yc3CgJXlujVmJlwYeB4KQfxVYau8U3wU4S77HunSsNZ
         4llDjCufs5l5ZFx7Uu5lLsJ80ghrj3+CRV3hQVHbFlBTtXzFyyYrWEOZLo4VI9/+54T8
         EHlZbgCN04cwzKo3/mJQBvEgpZ6jZlObjKBvuChXJrWEFeQuk0ga7bLZrhssW9bQhTMQ
         L5F8pC1LzRWtbCt3S2K17ctY4LX2DihuzTACdyS/Es2CGqMVraI9+7eaZUyQzte/ttAH
         REF6PVo6i6Z429rNfCfBfVrWQGqmRN4mgrRQLkOlyCAC1dlHYzEFBSNk+eEJXoYwFu7X
         M2Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761584889; x=1762189689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5/aJpcx16wEq6iLWJmAYoLVa/ENBxlXQoVj8lw6qVT8=;
        b=vQy0V7pLuUdovxnJodYixQJ0H6sS5KxH7Ib3l24W4ZPkdpw9ZT1axyD5mQduFiWcoA
         9gHLIHOAJW/EyZp2sXqqz4aQ+Bb0KFCbeEi3c8Ejb1Sb6N89So4UCgGkJW0VXdZvkebY
         jxnahruWa1fgVOzzHHKPJIhkgg87r19v6a0C1DbQ3xUECLVC3qHwlpET7rMI9X7m1GgM
         OeuUp/O3ks/233/93jWwlak7lUAB1S82AerwrZnOIdZgP0YqF7V3k4gDVLzUK1fxonE2
         d7VECzlEVabNY8x5HUjOz/Tu0rnu0Uvptm3V9OcSCa8AtoyFdcBPvaEt8jmABjKdSQ+O
         6+qA==
X-Forwarded-Encrypted: i=1; AJvYcCVr98bi3zoKksXAvVxUYCiHf3tKecYEDZSMusOSXYVyfvREBqp8WRQZnju4qdXClI+SgGPiLMIGF6EUKTjr@vger.kernel.org
X-Gm-Message-State: AOJu0Yywe1GagBi4qtUJOaJtfhDgv/eHsumuqNp+D4+emf84DcoLlJoh
	S5YFuxTuR8eHf6nZof4o8KHbRzp8MEAMjM4dwcpOP+q6vzHqOZF9Hx/nO5h3yYeRGOltvqUH/Bm
	Ftxhyh73Fw9Thjk11gr8/RftAgaWFCjU=
X-Gm-Gg: ASbGncuCrNxXnuE3YkHY8fm/dgrHAXYdcnfpBNI0NMdVJrh4i/xdvqslyZCavM7xLDA
	9CabnFXKgrWYB+JXwiwBf5i+TVz9i7CpX5Ts4BXzwLPDfe6Sy+6fbEsugXRqLBBbEzA3T12+VxR
	D/mJVoCHnr80NWoX1M7PiiyanZKWIyIAYRDnmhXr+5fg/zJZP0yLIRpvCU//DvtV4wrDJAdo5xF
	LZEJhD6GHoQ1HPAYGU6H1jcIhn35RdN2hKY3tyTU0RMbskd9AXaapW73PEA+O1ejxtSYZHKyfAk
	bsCshbHdpgwYy9tkfII=
X-Google-Smtp-Source: AGHT+IFy5AYcGQeUuouCXeNIv8SgQPkJp09VTLiHUl6FymkxDtypIcL8Uz3yiNnyD8ogxqz/W/ESkTd2N56oPCfboSY=
X-Received: by 2002:a05:6402:f0c:b0:63c:4d42:993b with SMTP id
 4fb4d7f45d1cf-63ed84a220dmr459934a12.34.1761584888538; Mon, 27 Oct 2025
 10:08:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027141230.657732-1-dmantipov@yandex.ru>
In-Reply-To: <20251027141230.657732-1-dmantipov@yandex.ru>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Oct 2025 18:07:56 +0100
X-Gm-Features: AWmQ_bkOPVPx7i9KVsHLAuWjNBZCtTcFrq31FkzfAc9RdwQf2GB8K76XFIVl6Lc
Message-ID: <CAOQ4uxgRBO9bAi-p_L+Svc13+DiLB_Sh8JVqhUBy80mtFiOKrw@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: avoid redundant call to strlen() in ovl_lookup_temp()
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	NeilBrown <neil@brown.name>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 3:13=E2=80=AFPM Dmitry Antipov <dmantipov@yandex.ru=
> wrote:
>
> Since 'snprintf()' returns the number of characters emitted
> and an overflow is impossible, an extra call to 'strlen()'
> in 'ovl_lookup_temp()' may be dropped. Compile tested only.
>
> To whom it still concerns, this also reduces .text a bit.
>
> Before:
>    text    data     bss     dec     hex filename
>  162522   10954      22  173498   2a5ba fs/overlayfs/overlay.ko
>
> After:
>    text    data     bss     dec     hex filename
>  162430   10954      22  173406   2a55e fs/overlayfs/overlay.ko
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/overlayfs/dir.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index a5e9ddf3023b..c5b2553ef6f1 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -66,9 +66,9 @@ struct dentry *ovl_lookup_temp(struct ovl_fs *ofs, stru=
ct dentry *workdir)
>         static atomic_t temp_id =3D ATOMIC_INIT(0);
>
>         /* counter is allowed to wrap, since temp dentries are ephemeral =
*/
> -       snprintf(name, sizeof(name), "#%x", atomic_inc_return(&temp_id));
> +       int len =3D snprintf(name, sizeof(name), "#%x", atomic_inc_return=
(&temp_id));
>
> -       temp =3D ovl_lookup_upper(ofs, name, workdir, strlen(name));
> +       temp =3D ovl_lookup_upper(ofs, name, workdir, len);
>         if (!IS_ERR(temp) && temp->d_inode) {
>                 pr_err("workdir/%s already exists\n", name);
>                 dput(temp);
> --
> 2.51.0
>

Makes sense, but this patch by Neil is going to remove this helper, so I th=
ink
there is no use in fixing it now?

https://lore.kernel.org/linux-fsdevel/20251022044545.893630-11-neilb@ownmai=
l.net/

Thanks,
Amir.

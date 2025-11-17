Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CC93164BB
	for <linux-unionfs@vger.kernel.org>; Mon, 17 Nov 2025 09:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763373295; cv=none; b=S4ukg6/8V1bqye3RXxvZsnoziLI2RD83ks/o/FJ0wv8MyVsXCdTfrYdHQgEIvLaFmUYSFhdgZJstOHUwPQez0+CNhIU+9YSszSip5hHHxrDnIn+J1wWVPvRgHBe5TJCr3eEWMmD2i4Zsj19o8KWcZgzALKWOm/a+qm0akLKVKs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763373295; c=relaxed/simple;
	bh=Sq6XqvBZkB8fha8KTcX4NhCd+BWInkkAfhiFpYhrrmo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g5AGjJmB88volVWTTtuzmGN0J642uRIfWGW50xRp+Bba3XwfhDjejauqxPYOve8tMqUr2+ZRKgslNnBMK0AMUDFqWDOguahV8Uim2nGixJaiQFTvhtg/aWsTLF1I5LdNYxM+rxkw76wlRqvORw3p8210XKgYZK/56yOl2GrHRfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RiJjkxxy; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RiJjkxxy"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so7318902a12.3
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Nov 2025 01:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763373291; x=1763978091; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTg1Eio4X3VqSUi2eoOlE7s1YeLwP1vF9ryfZs49llc=;
        b=RiJjkxxyz7HRuModnWCWhXcWElUW5jv8faunhkPXsf/bKHJso0bgmh96BCyOV1Vbd3
         PLvYj4A7U0IkyykbZGqF8Izu7MiT+nkrXWacipu38idmJ9+4fPjs7BSziwo+KGtXy0wa
         QVg93GvfV6moEidbVDHEUi1ohAuakdLfr6LXMq9/HbFKygF9N2Qq6uv3Z1O8tV+6SUAl
         u9cO5v4zmaMsKbEGdkRIp0eCpsZ2Zp1VJ6WZnQmOG3sdndE/h5EhMQlc4PZl3o3v4E89
         SL9/E0oNSGANf0uB3m4awWhlsP6RneAXHzuzRcLG/FsWGuOjABXOinsgme9tdtzq6GaZ
         eBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763373291; x=1763978091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MTg1Eio4X3VqSUi2eoOlE7s1YeLwP1vF9ryfZs49llc=;
        b=f0/pza/tsvryWEoMgbC4AlQZHe8BjhxQCLGVHNHuzXYCS2p9s90blL2ugje2RwJReF
         /FCcS+/p5VjA+ZFgSObZvkVWFGpN930H53Comqrursb3+rwWSJceJTwaoLsvxZy+xExm
         YfKdwf8/Ijsb/NnA4FoWV/vB9ZYeoTteza9PxWsY5UbfeKLbOHuQJaPJNzWSuGzDx2pX
         mY/q1vLaVk7a2tDaPLoQbCT42l7RiCD+oaQMzDS5Yh2Zsx3ZtvbxB6C/nIXsdb66+QiM
         wxx+EFsHM8J6XKo3emwVGULpDDjKtA3yt9m5AnTlGgcWGgyGDh2AMEaHjemUPU4Mh05S
         GdWA==
X-Forwarded-Encrypted: i=1; AJvYcCXPC0iYGEwSIULXm2LE20qVv1yrTOx9dSvx7zxkBl6dDNkbbmRdMKHzmkBauC5cJJVGFqeMH2gOywvZNf45@vger.kernel.org
X-Gm-Message-State: AOJu0YzKW8BVVfTTbhMBq6EJ/kPCV3FUZYa0uAJ8o6+GJjQnjIGBeOVS
	GGUF2+GGo/g/pJTf03vpgaZ8Ezt+Km2NUG+MnOTvHIMF/tfnPVIT8fZZ26ZWSbSDxxEhPaxy5Cz
	2tZaj+53KZQ64HIOxr8wo8qvXKQTRAKI=
X-Gm-Gg: ASbGncumZ/RYVtR8s3DTV492EZM0g4NtyZ4VUuQShGZ9iPuOV1aq3kUPLtwgrIxnXf6
	B/3SXlYguvkAKv/KSWJwr+LEpEtCWy+00DzYoOmXv9dxnSHfj+2fYQPOaaahouqINh591DzBO/M
	6SjW2chTLfBdq8Nz2TmwBog0ul6y6LwDz2lxAxiO+WX8DttX7kfgbhYpp1iaZj9SjoGMKoAvjRw
	C0k/7HOLXlRBNQsResW+50MRvRN0Enjqf1yo3h37RRtr6TTMr3ign/u3PdYvq3zvfczg7380g2X
	ZlkvVTlSKRHcGRfYatyrjwxDVzhK
X-Google-Smtp-Source: AGHT+IGy9DWFWr+RXtz0d8ABvdTZRXDdE0uEFw3LKJbf6mZCjHyTyTh/Kdh2a0a0Mi9SZ22Y72lQbelNwFVMMQRASg8=
X-Received: by 2002:a05:6402:40cd:b0:63e:7149:5155 with SMTP id
 4fb4d7f45d1cf-64350e0357amr10715041a12.2.1763373291081; Mon, 17 Nov 2025
 01:54:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117-work-ovl-cred-guard-prepare-v2-0-bd1c97a36d7b@kernel.org>
 <20251117-work-ovl-cred-guard-prepare-v2-3-bd1c97a36d7b@kernel.org>
In-Reply-To: <20251117-work-ovl-cred-guard-prepare-v2-3-bd1c97a36d7b@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 17 Nov 2025 10:54:39 +0100
X-Gm-Features: AWmQ_bmBoEsDLSNwYFYj7-aDSXZBuBOn8-m887mVkUu_WsT_rXo-drDLD3oyBmk
Message-ID: <CAOQ4uxh_T8uJf389O1Hx42SMCPDhdwfNCXzo5qSD2XUVAyFyCA@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] ovl: reflow ovl_create_or_link()
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 10:35=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> Reflow the creation routine in preparation of porting it to a guard.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/dir.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index dad818de4386..150d2ae8e571 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -644,6 +644,15 @@ static const struct cred *ovl_setup_cred_for_create(=
struct dentry *dentry,
>         return override_cred;
>  }
>
> +static int do_ovl_create_or_link(struct dentry *dentry, struct inode *in=
ode,
> +                                struct ovl_cattr *attr)
> +{
> +       if (!ovl_dentry_is_whiteout(dentry))
> +               return ovl_create_upper(dentry, inode, attr);
> +
> +       return ovl_create_over_whiteout(dentry, inode, attr);
> +}
> +
>  static int ovl_create_or_link(struct dentry *dentry, struct inode *inode=
,
>                               struct ovl_cattr *attr, bool origin)
>  {
> @@ -662,7 +671,6 @@ static int ovl_create_or_link(struct dentry *dentry, =
struct inode *inode,
>                                 return err;
>                 }
>
> -               if (!attr->hardlink) {
>                 /*
>                  * In the creation cases(create, mkdir, mknod, symlink),
>                  * ovl should transfer current's fs{u,g}id to underlying
> @@ -676,16 +684,15 @@ static int ovl_create_or_link(struct dentry *dentry=
, struct inode *inode,
>                  * create a new inode, so just use the ovl mounter's
>                  * fs{u,g}id.
>                  */
> +
> +               if (attr->hardlink)
> +                       return do_ovl_create_or_link(dentry, inode, attr)=
;
> +
>                 new_cred =3D ovl_setup_cred_for_create(dentry, inode, att=
r->mode, old_cred);
>                 if (IS_ERR(new_cred))
>                         return PTR_ERR(new_cred);
> -               }
> -
> -               if (!ovl_dentry_is_whiteout(dentry))
> -                       return ovl_create_upper(dentry, inode, attr);
> -
> -               return ovl_create_over_whiteout(dentry, inode, attr);
>
> +               return do_ovl_create_or_link(dentry, inode, attr);
>         }
>         return err;
>  }
>
> --
> 2.47.3
>

Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3700634250D
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 15:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778945747; cv=pass; b=aozvHQ54CdjQrsgehefPxD4CccBqp+kuPRYuHXT+/y2xp0h/60nB0Ni7I9MteRDzm1mURW9Y6a3dZzW7yzq+D5YLADURbWqTPDqAScD7jIohJ2fmo9NcAIX4uubxpSoAVTvBcl22jEI43gJDNW8kDVsfGh9YJDtScwDDhsYuUDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778945747; c=relaxed/simple;
	bh=fpwS1NISlMl4eRyrN9kTF1MNlwgsDu4mXgeWlhdxKrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FuHtl8PVTwVtXNNpuBQRV5IUfIBVDJXZAe/FaNL5w7k6UBwcQjmBPV5+NJQTCRveY6vALhytKD9LGOz787RZHE2M0ek93l5ydcYFGz7XBT4mrgoa6pfsGzq6cbWjNFbpfhyinLpmbgFu/CV0u4PCvuzkU21kEGIYySg+ah3x1Ls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUGybiO+; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUGybiO+"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b9d9971d059so124850566b.2
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 08:35:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778945742; cv=none;
        d=google.com; s=arc-20240605;
        b=g0Wwao6kJ02BMygZV0LujdhJb4tIvWiUPNdiDeYGeTO6XEAG+aADIOb5H4KggXeV6z
         dOXX8Re4GpwK7TkXCeZrqx8fhjkZhMEZQhyZmuPwcQZi56VSn3IYQ2meD3IfSHIUZTLq
         hwvL689ok5wycClULEmz2dvrll1Rcr3i/vYIUoVN4nV5PYEtiSZj+Xlk8lZyz/NvvTDs
         orA83i6PLRvW/lpI34tw6WyXL802Yp4M+QKM/zPDz7YYB8VSaCIztfSxgP+oXqzgYg0i
         1VskTDi+ICJlu8E7VjGD53tIHZ5IIV/OXdBOuw55fIF3nnccgnGovwBI1IYAyIKad6WU
         KTWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zA9VjGoCdws4GITccriUwfqMhrSo1TzaklLYoRAlCIQ=;
        fh=4JSuOsI1PkPVPyOc7Rjh3EIdeH3aZbM39t7btfCLiDs=;
        b=lRFY4hfLx+LX8JcsDCLQSxEwFMiqYksDyVDRBGM2L1a3hfFFQmWQbu8s+IDrFNvzyJ
         8cSzOKoexMbpqP2vfQnXCUA5Gc5NeqJ6OikQ2rBXnHf83TYXZlCr5Optzqmd7X3W0MNQ
         BBCQqVaP6QBa7cb5EgAGGyIESLke64zv8yQxdLlWuoXDvymU34BQKoyBj3Zay21nSvx1
         NlMAMYDfok2J2FlXpSfuhA1vksXOsvAD7Jewbve/sELarDjE1HrOBfyFMxscs3JgTAYr
         JvG7rEoYippCyijwWpCfMq1UDqd1Mf9MxzaZ3IESZndu4slCxMBV41tDFmjP5qew32p6
         Uw9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778945742; x=1779550542; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zA9VjGoCdws4GITccriUwfqMhrSo1TzaklLYoRAlCIQ=;
        b=aUGybiO+Fe2OWYzFeLoqT5eZb+3WxTaJMvH+UaXR1XdiSWz6kkO0fH/VG78Nfo8Kvy
         bCepGxx6VaALpWC4SnC6m1dunn5oeSFeW9L1NKuNr91u6rcYo88ZngkObSgqS4CgTk4c
         rWm+U6KnyboYphIy48zeydEOif1ViAD6lJ6Lk1IKETc+5IFZL9lOzrN+HTOtimEs4fL7
         k+KjDd8pVdt8h0J8keOA2+em7sqeLudKQDWkw+bfnRGxu+OG8EL41aS0dgM9Ztkl2hMI
         vX5ePaTzv+fA69bEZayJYRTohdsnIaIjfaxp8FWI/0ivmw6a/RP074bZfjdAvV2ESdUi
         bkIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778945742; x=1779550542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zA9VjGoCdws4GITccriUwfqMhrSo1TzaklLYoRAlCIQ=;
        b=Mc2N7K1ME87NQPr6uCs1+swXhTKlx6WoJVYW8nX2T5dzG9aKtXwd4VJ2B9s/boK8Z0
         bUksc2GZN8QcK+BvOe9rsvRoAfQiR9scnD/QbUZ3PDpfZqFKQrv55LHss0U0n/k8SVCt
         tZaYwfRoOVs/6bQBiQVV8LV6us4akQQ2xjVV1NGwWOiYTQv0wWG9Fb8ARnO25y4CcS0t
         YSqHX1ZliaLcd7V3KAyccpmhjUqDdE1A9OUtFrmgoxFL+VPPSSW2NBCVe+79XGRl79OS
         HYsIMye1XUHvz8X8Om4mPyXiZiBYbNTOt/2DxR8+gUj0+1TR8kXuY+dRA5gGlslXM1JK
         qrfw==
X-Forwarded-Encrypted: i=1; AFNElJ8EKs9e0NwLqyyH/o8k+2du6jTtKpNO0sS+1dEE/l4zEKSnGW2W2Jwy9gPK0NW3ssfm9PhBdLErydjW7QiB@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9sTyaNYlH/Ch2b/Jixt2bvkYBLQPJNhtCfZvj08Zx38uGa9Ij
	tIJnJJXubIYawZEtr4Dho8oU5kMuQjdpZfCi0XCEGf7IR2s+/Pruz/p/q0RJDBlYOdVAqTnw4Bs
	EkZSPb1Or2iM6CPWG4RMDXsAju63EDPw=
X-Gm-Gg: Acq92OFpcubxTTDg+hrief1NbcQQj/xH15zOLlM/8i2aJZ+7G/ONr2EoPtkdObjypfl
	ndcXdRV+z/jjo38CJuNrnBcqApHeX7pMrR/WJlyFejROUe3U7lynZ15q1VsadiUoKoMAADg7Oph
	bGisC1ERzpq5Y3MXphwEIeGCyJUUq8MvllesrziUTAXLXfsUOL40PphmX5olDZc5tBc4hejGFup
	yEVEVml6Wzwz7iYbT/rNOzRl8/UA3ZxBrx7qVSmTZ5bA4030AYs8IQrWAfMvzKPqKyGcqXVfgbs
	e7Wf4VRZ0o7mBjwRow8N+CZYjP9QdA0omIq2K5RWLw==
X-Received: by 2002:a17:907:c80e:b0:bd4:f814:dbbe with SMTP id
 a640c23a62f3a-bd517814c55mr466886666b.19.1778945741468; Sat, 16 May 2026
 08:35:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com> <20260516004004.1455526-9-joannelkoong@gmail.com>
In-Reply-To: <20260516004004.1455526-9-joannelkoong@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 16 May 2026 17:35:30 +0200
X-Gm-Features: AVHnY4Lv_tfty6tyl73Y0An7au81a6zgjoX6IM4U97tOfr4AKz4REFsBPKZvBnw
Message-ID: <CAOQ4uxhUvy_+AEF10H7C1mH8ue9uDQuvcaPJqsMGssWawJZc4Q@mail.gmail.com>
Subject: Re: [PATCH v2 08/21] fuse: handle zero ops_mask in FUSE_DEV_IOC_BACKING_OPEN
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 2:52=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Servers that pre-date the ops_mask field will pass a zero ops_mask in
> FUSE_DEV_IOC_BACKING_OPEN. Default this to FUSE_PASSTHROUGH_RW_OPS to
> maintain backwards compatibility.
>
> For FUSE_PASSTHROUGH_INO servers, an ops_mask must be set.
> FUSE_PASSTHROUGH_INO is a new feature with no backwards compatibliity
> requirements.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/fuse/backing.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 2234ab47406a..b499860e1185 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -119,9 +119,23 @@ int fuse_backing_open(struct fuse_conn *fc, struct f=
use_backing_map *map)
>         if (map->flags || map->ops_mask & ~FUSE_BACKING_MAP_VALID_OPS)
>                 goto out;
>
> -       /* For now passthrough inode operations requires FUSE_PASSTHROUGH=
_INO */
> -       if (!fc->passthrough_ino && map->ops_mask & FUSE_PASSTHROUGH_INOD=
E_OPS)
> -               goto out;
> +       if (!fc->passthrough_ino) {
> +               /*
> +                * For now passthrough inode operations requires
> +                * FUSE_PASSTHROUGH_INO
> +                */
> +               if (map->ops_mask & FUSE_PASSTHROUGH_INODE_OPS)
> +                       goto out;
> +               /*
> +                * To maintain backwards compatibility with servers that
> +                * pre-date the ops_mask field, a zero ops_mask defaults
> +                * to passing through both reads and writes
> +                */
> +               if (!map->ops_mask)
> +                       map->ops_mask |=3D FUSE_PASSTHROUGH_RW_OPS;
> +       } else if (!map->ops_mask) {
> +               return -EINVAL;
> +       }
>
>         file =3D fget_raw(map->fd);
>         res =3D -EBADF;
> --
> 2.52.0
>
>

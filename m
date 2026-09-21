Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC963C1998
	for <linux-unionfs@vger.kernel.org>; Mon, 21 Sep 2026 08:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978244; cv=pass; b=kZ8y9E1bhDZDVBTXUF7Cop2JHNyl8vT+xQ5A+9LsxRDJJe4TvJgUMNOkoObAVbmSOHlq76Vu1A2fabdET+s7fYNU5BaLYCMfzzK+Ilb7IP37/LGt1WvQelkHazskCBNZkB9lk2gKp5XbnHjlO5J8N4Mpu/jYXSVX3RA/WCa4GL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978244; c=relaxed/simple;
	bh=GrKy9WwMNLslOJEUstVTtMo1GdzH7qTLXIWYKkj1gyQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=scNtXLiFRZPKizzOXQfLqIm7MlsUZSTDxqmkdT9DigFNsJGHiBtYDksjBPGoch83Hs1mFKEI3TENyN6qTCBAx0tznI20DlV9hgOzzMQ/Hb/aVij3bjAEyOG+6HifQlOz3UFjLelFPexD6BmbqDZLZXVV0fO7WtSnaUmd4PlOZos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TpYP1yW3; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpYP1yW3"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a60591bb18so1788533a12.1
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Sep 2026 01:10:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789978238; cv=none;
        d=google.com; s=arc-20260327;
        b=Cew/rlbr7RsRrOSzPbuJthdyefqMZRqxsiI7GF3ey2PhXMeQTlqtIfUgRDLtYsLXzs
         4VR+HdTqPf623xoQFgBuaqEZMEkFXCTmFDRukpGBG4Y0ABjPkynOFlsIMl1vf8AVVzhN
         rnBf6ucuniY0rOxVXaFUKPaDcSfG8wXQ0+Qt9QGEyjRY7iqVm5AUPTPZcAxv5Ts6PRxf
         ARTWUEW3GV+n8xtYTCsVc7atA8JrvHgvLV3fcSGX3jOAybZuCKWo5Q8bfrcxG4uVqdRa
         LPNfDF4uigNa1AH9+TsZHIZON6ZtANzT3nAwg/IrnIb+6v4bNR3s2Wc8W+Dd2yoEEEgH
         tWYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5425NbyyvwcL8Aen4hOIQPTRFTRLy6ZvU/J9JceGQDE=;
        fh=ZlpoB8s9+G1mSADZCyBsErg1zDoQJtUjROz/AKmPj5U=;
        b=CaYiPnSFxT7zYKg42rBJANb+f96i1Y6jMocD39SuvbvzTDrLeFT6ysNVqptdyZQ54v
         5qVOSDMR4nq5xOOgrvtEEAu/5imgPaLFe4ApAjHYCpt4vDQu7o62hCCmnbxZjw7AUnV4
         f4R02n/PuQbehNhf1fy42xdjTfHpLZbJ1DOSJ0n9uhhtGkkemCvqktaYYU+kIEfVspuk
         3iMx6oG3JFI2uzZiZhKHnW8EdeSall41X1npxVOEwCT/DNuqz1rjkxmLUtxbuIDje/2f
         5/R0sue8dFYvsUMGAfLSl6xoKadcrCYGE73KODZP7JoYSqWTzuXBvJA1UvqTf8qdXzRI
         ImgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789978238; x=1790583038; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5425NbyyvwcL8Aen4hOIQPTRFTRLy6ZvU/J9JceGQDE=;
        b=TpYP1yW3/azBqraOlSfGaePZRKtYcaf9/fuH8rp0FfQFkG2G97O8b/zlg/9GKPReK/
         hO9aPsrp4nKcYnGjlJiai9OUh6qPrfZ0OLDLaEnVkb3BrbZMBPuqLu2386ySrLvKGV//
         qhYBcni/5dQFrT3Opwyk3yyov1QiYTeIvtpN+gRrdy++MiP7aiZpNDsumCsHDigb7YoP
         jkABm2bi3oeK1sK4UR3wglcB3+t5eiTp27K0Hauu6afljgEjssHTmGj23WZVaXuzfd4V
         GdSnCd2MRVPgjS7R8ZPexSfTUimZdsz/P6b6zKhHvA1lzzf0PGyGiQYz6euFZvPM8Oh0
         0+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789978238; x=1790583038;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5425NbyyvwcL8Aen4hOIQPTRFTRLy6ZvU/J9JceGQDE=;
        b=VWQ12Mc2sl4Bx3gNZbObpAXOIj9P2Dbpz4NbP4FKOXRU8kPYO+KEOJZqtqsb7N9yET
         FRefvwVePh5/fZ8EKDHJPoi9IfBOG0dFQCDvWtNt/aRsWbaJI3DKGjRi1oDvKDir4RAi
         z0y7ir2zTRXOSLVeCNhW4aQG0klhDfrff7lmY+rrJg8C7ekBfbxd2tXd0L5Bt2NAEEYA
         qqkkGdcrVwH2h7vkwtVltIgVkoTeP7yj+stWCU6J+jGiUsfo1tlgVYKnHsgRpO3bwbbL
         74zZQ207lczzzFAMspR4gsEW700S9SCpcnTn5INU95z22rRx5NdO5AEzlN49T1NJGWI9
         e2pg==
X-Forwarded-Encrypted: i=1; AKwUvBybcfMeptgba7ThPJMZQJR93CuAYtcMUYuj7pnWprwekE3uoURRtqTpBNuxwHaXWf4CrMXQxEHmbWifHcJa@vger.kernel.org
X-Gm-Message-State: AFuF++k89ven/AIpZVKNs22hAFjyMlVyZNQ0jQbLVIMvt1TV0tabNo9q
	81QBIVt4sIwDo+/VYvTxCu4VHiPNexGq4AhW2S6ZLargXG8QuXuINUajX2tO7cHnj8EIENIg5u4
	5eGBI+toplEG5bnjMjjRnl2dRLfJVMeo=
X-Gm-Gg: AYBFou0ujtWll0GCb7BcuPCaXe1xeovKieAxzxDMWwqMBGmlS7ZXpJBwUW+AwuB6RqU
	6kE11d2Mj3QOidR3QV3txsnTqkml0v5LxVHX72VnLk7TugMCLezwoTBEKkI/FT9B+bc5WteEJ9o
	Ee/tXHfP9exS7qwykNrkiLhyZXrTeOWY8fEURC7+X5fd5iInZXeWJlzlSHdL6zajB0lf9SJy2iG
	33Df3TXaoUjmlH2tWbevm6WgNEO3C4z8zQ7bSTBJwvH7c5I7JmQMDvCvpVqYtbEJAzq1z8dW5xi
	ifGq9aQCMja/Kw7LbJU/BkCgHFQ7ftjEDe60ju75p7fGXRe/SHNd8K49cg==
X-Received: by 2002:a17:907:d503:b0:c25:f7db:4bec with SMTP id
 a640c23a62f3a-c2a16597a38mr814104066b.18.1789978238544; Mon, 21 Sep 2026
 01:10:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr> <20260920203239.2876221-3-Jeremy.Jean@oss.cyber.gouv.fr>
In-Reply-To: <20260920203239.2876221-3-Jeremy.Jean@oss.cyber.gouv.fr>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 21 Sep 2026 10:10:28 +0200
X-Gm-Features: AcwNN1Wtxobkh7V_D0j59vslX0xGhWJeUOKiXy3M6bEivWFDogkmGjxGJI0M6sQ
Message-ID: <CAOQ4uxhyc5x3LDzbJtRhQJ+JNQ-hES2k45jcxeGsfEWPB24TKA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ovl: disable nfs_export for same-sb lower layers
 with different idmaps
To: =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 20, 2026 at 10:33=E2=80=AFPM J=C3=A9r=C3=A9my Jean
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>
> Overlay file handles identify a backing filesystem, but not the lower
> mount used to decode it. If lower layers share a superblock and use
> different idmaps, a file handle can decode through the wrong layer and
> initialize the overlay inode with the wrong owner.
>
> Track the first lower idmap seen for each ovl_sb and disable nfs_export
> when another lower layer on the same backing superblock uses a different
> idmap. Keep index enabled: copy up starts from the overlay dentry selecte=
d
> by lookup and does not need to decode a lower file handle through another
> layer.
>
> Fixes: bc70682a497c ("ovl: support idmapped layers")
> Assisted-by: Codex:gpt-5
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  fs/overlayfs/ovl_entry.h |  2 ++
>  fs/overlayfs/super.c     | 28 +++++++++++++++++++++++++++-
>  2 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 80cad4ea96a3..2a6e12a0d4dd 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -24,6 +24,8 @@ struct ovl_config {
>  struct ovl_sb {
>         struct super_block *sb;
>         dev_t pseudo_dev;
> +       /* Idmap of the first lower layer on this fs */
> +       struct mnt_idmap *lower_idmap;
>         /* Unusable (conflicting) uuid */
>         bool bad_uuid;
>         /* Used as a lower layer (but maybe also as upper) */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index bd0a3f9039d2..8e78da420b75 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -944,6 +944,24 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, co=
nst uuid_t *uuid)
>         return true;
>  }
>
> +/*
> + * Lower file handles identify a lower fs, but not the mount whose idmap=
 was
> + * used to decode them.  Remember the first lower idmap seen for each fs=
 so
> + * decodable export handles can be disabled if another one appears.
> + */
> +static bool ovl_lower_mnt_idmap_mismatch(struct ovl_sb *fs,
> +                                        const struct path *path)
> +{
> +       struct mnt_idmap *idmap =3D mnt_idmap(path->mnt);
> +
> +       if (!fs->lower_idmap) {
> +               fs->lower_idmap =3D idmap;
> +               return false;
> +       }
> +
> +       return fs->lower_idmap !=3D idmap;
> +}
> +
>  /* Get a unique fsid for the layer */
>  static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
>  {
> @@ -956,8 +974,15 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const st=
ruct path *path)
>         bool warn =3D false;
>
>         for (i =3D 0; i < ofs->numfs; i++) {
> -               if (ofs->fs[i].sb =3D=3D sb)
> +               if (ofs->fs[i].sb =3D=3D sb) {
> +                       if (ofs->config.nfs_export &&
> +                           ovl_lower_mnt_idmap_mismatch(&ofs->fs[i], pat=
h)) {
> +                               ofs->config.nfs_export =3D false;
> +                               pr_warn("different idmaps in same lower f=
s '%pd2', falling back to nfs_export=3Doff.\n",
> +                                       path->dentry);
> +                       }
>                         return i;
> +               }
>         }
>
>         if (!ovl_lower_uuid_ok(ofs, uuid)) {
> @@ -987,6 +1012,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const st=
ruct path *path)
>         ofs->fs[ofs->numfs].sb =3D sb;
>         ofs->fs[ofs->numfs].pseudo_dev =3D dev;
>         ofs->fs[ofs->numfs].bad_uuid =3D bad_uuid;
> +       ovl_lower_mnt_idmap_mismatch(&ofs->fs[ofs->numfs], path);

This helper name spells weird here.
Better just assign lower_idmap directly.

With that fixed, you may add:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

>
>         return ofs->numfs++;
>  }
> --
> 2.47.3
>

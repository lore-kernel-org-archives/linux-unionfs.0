Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794754079;
	b=pBj+yydzEi4TADbbbNMw6fbAXp5QXEaCz/+pywoIVuc4pVtaRKalL1GSzOgrIq7XGXn6
	 ejeNUcHWGM/8bpzjhoAs2cRfKoAQmJxz7Odoo4ochpIc0GL5p7ABiUNiSNn79/Up93uuE
	 2hjljE63WQhtUxZHlMvdm5j+Up4F+2ZVuEBEu2P5ZV0TDPLj+th3qOPaR5ztvg9C9M0rI
	 rD6x6+tRexQndMqVH3jj7XU77LSb9PPJxhatWbZeamqgm5XM69tqKX03OwVUh3Xa9a/w2
	 4GpuFIcYl1H9MLBvXCY1XUn1AcwSHebhIdFt6IBY5dF9rXv7kd7dMpbuW1dobr6tgFA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754079;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=x7HykaAJlgnOpmpM8XJHQMzZjK2dm2wSOUdGIuC/Jng=;
	b=ChWdUSfp7VfM3FPbndaVT2LGWOLvMJW+fWKKWfzsMn71f1aVgpjuke+OPkz4qnWYHzSt
	 kPRdXksmzfcClrcnw/E28lynKZ9/2wU3PHEht4BxHHTGrhW2MUUiMoqPfalYdIQR/brbZ
	 V63QbYczwt52iPXp3aWnHeTqRzBSG5o0xiWy7efFjcvAR99RWpW+ILyLO2L5zXyxxT9I1
	 BUZlVuEidotfhqKQQCBlggTtupiabCEsNL22CNTmPefLsF9GLkdzNz+9exqdlL/tiwFdr
	 h9g0i+Wi6hiPphEUNwRYcBhnvpLs6y7AlS9QQQOThAk2Ur7rG26d8l/lb4uWBvcAmGw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vdeJy6VC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D03606A31E
	for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2026 14:47:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79D03606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vdeJy6VC
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso5977795a12.0
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2026 06:47:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794754076; cv=none;
        d=google.com; s=arc-20260327;
        b=SNeaTp3R+NKJgOSAmTUt6JOG57JpLuuLWCDXiu4sQwSbqTQ4fqxuKlULIi4vLinKSy
         i6kve9z0OFXaqDVS2kE4RfPRxd5nGGOteI6fWdg4YNT/0PtwLTAPCM8ZAhRjRBYq07Os
         ivnGF/Zfr0FFMObf7dt0V7HvA/KBaNRiA8ptSamB2MQD0sXZSTNz9EXsBn9bYa0tCYeK
         h+eEDJsdSibVsaedhc6HhLFXtIASYwmp6HESnBfUvrWWcPG/8QNKkLhRfpfkwbwGVwlt
         qaAStDwJfvHu9RF8bsQF2pSHXGOeMkaoVEY7489EzZVotABdgRc1PoibRswkbbGHERV9
         MYIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x7HykaAJlgnOpmpM8XJHQMzZjK2dm2wSOUdGIuC/Jng=;
        fh=yEbe0fAs1L+QrlSmsJ7x70hl45+Ry/J0atlZihXZ4lw=;
        b=A5/N+F5w84njuWzfznwLVM6Qsp3ErP9fjzLugXKv0fD0yhlOAYyaNMi5tXUprB8Dby
         TrsaHoWNBHJhGWsfNFhMI8kWoU5LWWN+jsAG6EbSI3BZwMRi/IgJWNaCmpy62NNgsChZ
         9ra2XFNPSnmdVtq4TJriLNnhYR8sH1uxwWUMWafv63Dwv6IejfP0Vi0Z2oGcMrbU5g1J
         +/V/5S0s1/QbolFNPs+aMylfzh8hD2XOXAjmm/YwBXgzcpjxiy4ZtdRZlLCctAdVkCIC
         SUPgZnIgf1NVo4U2fFswwo8v9bK5BHdWlbG0zQyMxCRGUoL1z6x8P/SS1EpVsa12Zv3p
         ZpiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794754076; x=1795358876; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x7HykaAJlgnOpmpM8XJHQMzZjK2dm2wSOUdGIuC/Jng=;
        b=vdeJy6VCk2IGRpnrLWlGo4pWLhKneS7IPoBk81bLTW0iD2g50lPI0We72sIkSM0SV6
         cyTbNZB4O3d6VzvDDG9DPV5xAXhxmw4YkAyPQvdWI1M8aVPLRajltXh2AQAOKJY1EPeA
         J/3fQzDOEdKdl4Og0NnAs1e+UKlTuJcD65e+vWcNglfpyVM0bRYj3j545Ccvj/p07kIf
         RJxqw4iAkOZDz6lvhqxGAdC4rSJXKnOPRkFB2PlSiergeTKJSozBYsIqbEfROUxsRiwA
         +nC6LR2BKa2t52tGscFSOG6fqqncSzV6SKT9uOygWHxo9fsmCNg/KFWBsER32dA/LqAU
         Q4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794754076; x=1795358876;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x7HykaAJlgnOpmpM8XJHQMzZjK2dm2wSOUdGIuC/Jng=;
        b=Tb+ZBmn4LQcTrHE42KnDNMhJLJcupvxFkexZz9ZeuDKWBVeNVvPeb8wDJiu4Wfh3Mx
         hEPmZTV3Pl/fbp04Lbxcz8kwnIzKahd2BnJFaqxqSma9bKGAym6+Dpren/PJB6ydf2mR
         HnBbugDViNwx7i8URq/iY/fm2pFS38Y1RjjPEWxiaozpuz6tGEXOMczS/fM+ZCCKOn2G
         aC/z/tfhej562X8KisOHPvUC+DpNJUcVd5QM3bj3xPxvEbAEq7ukRmg6/UalbFXKPAgE
         dYeoG3YECSojjvKLEEOKyToSeQITKJfDuZvTO/T9RA2lkJ84Qc52xfBq2QVG0vZIl566
         HT4A==
X-Forwarded-Encrypted: i=1; AL+hErHSEet5MDWUnoTy9GLyCLkXUlm5+qafMGNK0Li9m81CebEM4s6peDHN8JlyBdD/jSSwOJK48ica+Iz7If8/@vger.kernel.org
X-Gm-Message-State: APuU4Z8/4RsuszTmTG3ebxsC1OL9Lc8aZDgmo7j1bUEvHvvLzpxK9qjA
	Z3fSAfzeXVsN7BZDaquOAmo+oBPa2b5lcIOXiU3oiE6J/WvwA5EGPlCa9rG30Bx3xdpXDxyXHZw
	8D8ioowu1520v7caU6rfG3HHBb4c1jcw=
X-Gm-Gg: AYBFou3hTe4bzKc1ifnhqY2fNw/8NmrC84wwu94GtX/xHgCI5ZQUceCoUi28zAaZkOB
	ds0gOFhmStJCJU4Wsf9iF1S7EC7WVq4HtQvcMHoO0y8poYhX0S6gpDRtVwiJnPCTVZn+3AOkJoB
	wWvMyxcDiQkvj95ECfsHWKezwKHnWSAh2RAbbc5gGb934o9yY3ucDmqjRsyHz5e0ie0TDlA6Jqy
	kNXP+9gmJTkZJMfxRIW6eSBNd/L4LLpQP3tmh27A33Mrbn1izF6EJEfbLdtW/VmMwm7DZDZ9QZ7
	iTSN5eveFxxr8RQKLtAhd3/fLrc1mQ7Xb1DQUJLUxe/87pWMktknbz4/q6pqORr81NPItFkEI1l
	Lte9/3h/HNnxwQXxC+kB2nSPc3Awfj8W0+mxsA4KSYGbaS4o063bU1ftxmn9Mv6XbOC52yQ==
X-Received: by 2002:a05:6402:1d4c:b0:6b7:e12e:7f1f with SMTP id
 4fb4d7f45d1cf-6b7e12e824fmr3426650a12.10.1794754076394; Sun, 15 Nov 2026
 06:47:56 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org> <20261115-work-ovl-d_real-v1-10-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-10-ca155efbcb2e@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 15:47:45 +0100
X-Gm-Features: AclHuK_at8qVhKBNN0WXPGQ7F2lmyjSQgMjlfNE9nQtuQriTEXeBZE7dwGmSTD8
Message-ID: <CAOQ4uxggW+UifxBJDY8fAb+g5EWrsD+rELwXa1ngZ_5X_OZx0g@mail.gmail.com>
Subject: Re: [PATCH 10/13] ovl: return the error from the lazy lowerdata
 lookup in ovl_d_real()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 3:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> All callers have been converted to d_real_data_inode() and handle an
> error now. So return the error from ovl_verify_lowerdata() just like
> ovl_open() does. The lowerdata dentry missing after a successful
> ovl_verify_lowerdata() would be an overlayfs bug, so keep warning about
> that but return -EIO like ovl_open() does when it has no real path.
> D_REAL_METADATA never looks anything up and still can't fail.
>
> Update the comment in ovl_d_real() and the documentation of d_real() in
> dcache.h and vfs.rst accordingly.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo=
91QjJHH9T_Yw@mail.gmail.com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Nice!
Thanks for cleaning up this mess.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  Documentation/filesystems/vfs.rst |  6 ++++++
>  fs/overlayfs/super.c              | 17 +++++++++--------
>  include/linux/dcache.h            |  6 ++++++
>  3 files changed, 21 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystem=
s/vfs.rst
> index 1824462a43711..6953f399672f3 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -1374,6 +1374,12 @@ defined:
>         for returning the real underlying dentry that refers to the inode
>         hosting the file's data or metadata respectively.
>
> +       For D_REAL_DATA the filesystem may have to look up the data first=
,
> +       e.g., for a file that was never opened.  If that fails an ERR_PTR=
()
> +       is returned and callers must handle it.  D_REAL_METADATA must not
> +       fail.  Most callers should use d_real_data_inode() or
> +       d_real_metadata_inode() instead of calling d_real() directly.
> +
>         For non-regular files, the 'dentry' argument is returned.
>
>  ``d_unalias_trylock``
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 1985b553a47b7..39d4d57dec230 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -42,7 +42,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry,=
 enum d_real_type type)
>         }
>
>         if (!d_is_reg(dentry)) {
> -               /* d_real_inode() is only relevant for regular files */
> +               /* d_real() is only relevant for regular files */
>                 return dentry;
>         }
>
> @@ -57,17 +57,18 @@ static struct dentry *ovl_d_real(struct dentry *dentr=
y, enum d_real_type type)
>         }
>
>         /*
> -        * Best effort lazy lookup of lowerdata for D_REAL_DATA case to r=
eturn
> -        * the real lowerdata dentry. Callers may ask for files that were=
 never
> -        * opened, e.g. for uprobes or O_PATH files, so the lookup can fa=
il
> -        * here. Return the overlayfs dentry then.
> +        * Lazy lookup of lowerdata for the D_REAL_DATA case to return th=
e real
> +        * lowerdata dentry. Callers may ask for files that were never op=
ened,
> +        * e.g., for uprobes or O_PATH files, and the lookup or the verit=
y
> +        * validation can fail. Return the error then, just like ovl_open=
()
> +        * would. Callers of d_real() have to deal with that.
>          */
>         err =3D ovl_verify_lowerdata(dentry);
>         if (err)
> -               return dentry;
> +               return ERR_PTR(err);
>         lower =3D ovl_dentry_lowerdata(dentry);
> -       if (!lower)
> -               goto bug;
> +       if (WARN_ON_ONCE(!lower))
> +               return ERR_PTR(-EIO);
>
>  real_lower:
>         /* Handle recursion into stacked lower fs */
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 674bc50b81827..5b3b34d271bd0 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -638,7 +638,13 @@ static inline struct inode *d_backing_inode(const st=
ruct dentry *upper)
>   * If dentry is on a union/overlay, then return the underlying, real den=
try.
>   * Otherwise return the dentry itself.
>   *
> + * For D_REAL_DATA the union/overlay may have to look up the data first.=
 This
> + * can sleep and it can fail. D_REAL_METADATA never fails.
> + *
>   * See also: Documentation/filesystems/vfs.rst
> + *
> + * Return: The real dentry, or an ERR_PTR() for D_REAL_DATA if the data =
can't
> + * be resolved.
>   */
>  static inline struct dentry *d_real(struct dentry *dentry, enum d_real_t=
ype type)
>  {
>
> --
> 2.53.0
>

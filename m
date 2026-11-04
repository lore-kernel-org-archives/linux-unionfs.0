Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793821674;
	b=0oNXWLhD01krbFqPd39lAeWi/VGuCvumaIc6gvP9a7yQ9ZemUfmIGcw6zoz4en6CET4O
	 qz3MtRYasL5XIs5eIXG2+1yy7OIQoPCI+jV3BflVR/Nf8xjVMJ5Bl985lslrRl4DzWTFr
	 RoNFaBgA83sGpszZnJ63RkezEjNJXDUhk7sq/uzandgehTTgQZN5I2849o0V8rALhsXlL
	 GecFrm/11BTpZgjfTU8wHQYBLiYHfdb3y69WXP6L6fCN9JjlWSopZXRzFV2Kj1fekEmBE
	 3YTAJML7hW+PfIZ+aP+tcsW2+SO6zBbmA9tCSsHSJsKjjXl/nlq/o3EDtIwWb8w8PJQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821674;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Jrd32+YJEVParF9gDYjq1VptNJioJAFlM7MtJqO7Iqw=;
	b=RpYLu0UFlB56cockOS/UOq5y2466SPx5ux6CeSSVCBKUy3Emg7n3nKRr3DkDYVfJM6o9
	 96oTkvL7/1bq/pffcUyqDFVrhmahYvgLgMY6sCNvIB4GgJrBcwXdhhtbQ4g8RkEJaJ5wR
	 ChA9QIqs578/A3alY8JYW0GUmUcrpAj0OHujokhE6MMsqHKXy3QnFGyJqdS43fXbjnXhj
	 Nym/lRMFHEFnkUy0A0eVG/azoEd+4Lthwd9N3SEQUqnfwve8qcAN6DNG7VVvathwHLc6p
	 RHWvJcAP5lDg9D1fVy4CSMLQCKyg0BHEy2DsXemA3FOLSfxn0mb/aNxtpH06gAcE9bw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P2nVfXQS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A20608F3D2
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 19:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05A20608F3D2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P2nVfXQS
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b566cf56c1so837227a12.2
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 11:47:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793821672; cv=none;
        d=google.com; s=arc-20260327;
        b=aZ2eJkaRWnklG636d33+Vh3enFAbFKKJeplixqpF9kQmOj3WjGAmnUt+UxgVNZdO0Q
         9yl787r3iDHQgEsCZNzlksuWBxOr8TjZ0961AFcyyTgvmmiOMj2d9Rz4+2LQzcPSwtCg
         Y3c6EefkxjWrg0rDpD3ccyLhGhsp17bohiRm+MHxCaBQ/MBnEa8KcIvBjTjB1oS8Yb7m
         BxYNGcIylzhcEvepxud6F0fV4l4cAUJfw1oVTaVgQSNAViP0Arrm6cc0IZFi7C1Jzaa+
         D5lQXxp7kODTfliSdHIxh9YyQN9qBRDQiu+xCVwyozY6Dd4BScTK7ZIertNnrz644jbx
         FAVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Jrd32+YJEVParF9gDYjq1VptNJioJAFlM7MtJqO7Iqw=;
        fh=tBj/6WnyX170jxQ7Rvi/+bH4aU+RsznvCWDMhvlrZKE=;
        b=buPe3Z8D8Q0DGXBieIojo9pSbO9aZNVMleLsKfYxBCs33QqrVMvNI1q3uXOQCmvFR5
         g+Av1AbM/j6p9QXT81V44pIB9XI19cvdzRMRCEx9rPbgYRkJLzRxBRmZaQGN82WXLm+O
         Q0EfREf79TK0xXGCfGLlVx0terk5MUORHy9TekzssXyFNXec+5YOpIZidAwrwOTY1Yu+
         vw9Yg6YSbAzG0VrZqacgobIyw7PM8euSIQxh20AgEUoiO8FHlEDSQmv0rV0/wpkPbMNU
         BKaaryT8AP69GH2Zp982mDW/wN+o7q0treciAC+CDu/JKFBNr2JiYehvlHrJF+9Vnovx
         n4bw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793821672; x=1794426472; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Jrd32+YJEVParF9gDYjq1VptNJioJAFlM7MtJqO7Iqw=;
        b=P2nVfXQSoEWDSx+ehrVF2CrwruKgd6BRzwSUsBTyRf+Q4jqPVn147nDPJwF+wf6i5n
         PVEVgKQcNUC1G0iClbLZ0uOPeBo5Wvy30G5Q0KY0Cz+zwTTgBTdPW4VsqUQMkRueRNiC
         JgmMB05I2CSg5RqRT+i8WjqqB5MDVcLcv1+28C7/x5vYMqN3Pqjy7JCIJfWvS2NGNAFP
         rGzICRf7g7x/wcJi4A24Hd8tZLxK7IjrH0N9w7djtu//3UtIV045oNmcCosFNmbhLNad
         edesHS1IOw9tK8qO8AwNrAMP4mA2wJi9fWcVRejnsdBewx3aYmdS5hvLS5SJcz+Jx1zr
         GCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793821672; x=1794426472;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jrd32+YJEVParF9gDYjq1VptNJioJAFlM7MtJqO7Iqw=;
        b=zTRMu0LXGEWYh0Em0o/zKCQItpmBu7YBJeST6TmGKMSubJYbvOEK+je9VyaZVDW0ZD
         OEOlZOPQ8v/1LjU4PXRZuP5SewdSjO72eLDuFrdNQI4n+DTWSEkaU5Mh5goxr3M5iIR+
         krtqfToOzPQ/A8O4uevdhFcKfZH7p7NgwJTxSTpOVrLGM6hEEYEzi1l/7Muk/33G8Cuo
         VuKvXc9GpNfj8Xjo9Des6PrcHoeknTtXFBkZrdsmC8EaKO1z1vDai2WvqOc+DQtUJepI
         GYcqiWPbpwA17dkSV4+j30WUoh1GQbRLMmYC6DD2LCZP1xLjPXlYL3FjQBSe15Fi3KXl
         Bzww==
X-Forwarded-Encrypted: i=1; AKwUvBxJuBjhx2AH6z1PuRX7Ow+R67jRRY2UJFdXQS10+SccH5DHVQWOTqEOULuwe8E3YzMeKkDzPpNJbIt+APk4@vger.kernel.org
X-Gm-Message-State: APuU4Z+dyP7td8LWvxaIFT/ezAdG4C1sAvRjttlGAx5ZP2YH5lVaiw3N
	qV+H+0FRG6fYkFZ5USZrM9FVuUSEasTwfg2ZGU6vv9IxeXlaZo4Wtv43j43Y/lpSz+tExw3UHhV
	bp0sZvdv5JowwFoq0RAA1Aliox0t+ep4=
X-Gm-Gg: AYBFou1oG+ISFLdYt45TBDsPoelLUkEiAyZoFzLBrOPLEe1J0M5fB6evC1Wks06eJhA
	hXzQthVm88r/6+Mb4ezrOXyoriHlwmpDXXEunyWayhmQT4toII9U3W539KmyPnZYxuA0C6QaelU
	jtK9VGTyBdIv+UaYPHh5Es6jXVFKYHVxvL6VxNXn/1jvig1tVe9aZPEegQj82WLGioU76SHpuHD
	IdnCs6WoYlfBs95zjFS6kkqsurjLNP4fRqNRL0WHPP2O3GEs3YTBv3SRG/pTTFOx728bCQxq233
	eR/WPy2ag1S4W6uQELFK73nLP7bWkeAWjDSesDcalXGrcQS4TqFTOnVnzDMt/iVxUWy7spuDba2
	gJfFJycoUArl2I60Kj7bKpFNOkHBfe3+580T6NnK3amAIdlLZy5Nz4jpN3+JfCGfFUWdGktDcXY
	ZRlzo2dxBihVDn7HQ=
X-Received: by 2002:a05:6402:4008:b0:6b4:208d:21f2 with SMTP id
 4fb4d7f45d1cf-6b4d3392226mr12668210a12.2.1793821672207; Wed, 04 Nov 2026
 11:47:52 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104185536.3631167-1-amir73il@gmail.com>
In-Reply-To: <20261104185536.3631167-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 4 Nov 2026 20:47:40 +0100
X-Gm-Features: AclHuK_IaB2NZ5LjJ5ygkT3wi1DynfRtq14s9J0eq9PWgeIQdcdCkasqWVkNTxI
Message-ID: <CAOQ4uxhi3aM57BrXmM238TO3baeN75JduY4fQ8km8bLOx_SXyQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 2/3] ovl: skip copy up of empty security.capability
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, stable@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 7:55=E2=80=AFPM Amir Goldstein <amir73il@gmail.com> =
wrote:
>
> commit 50912a1715b8a7c614b654011a0db750e372b43e upstream.
>
> ovl_copy_xattr() gives up if it can't read an attribute that
> listxattr() has named.  An empty security.capability, which anybody has
> been able to store on any file for a long time, is such a case: it is
> listed, and getxattr() has nothing to return for it.  A file in a lower
> layer that carries one can't be copied up: it can't be written to,
> renamed or have its mode changed.
>
> There is nothing to copy if there are no data.  Go on with the next
> one.
>
> Fixes: 8db6c34f1dbc ("Introduce v3 namespaced file capabilities")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [amir: treat -EINVAL as no capability too, and do the same in
>  ovl_copy_up_meta_inode_data()]
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> [ backport: context: no blank line before the ovl_getxattr_value() call;
>   depends on e6b9117076fb ("ovl: fortify ovl_copy_xattr() against
>   underlying layer modifications") ]

Greg,

Sorry for messing up the send of this series.

This one depends on patch 1/3 from Message-ID
<20261104185356.3631002-1-amir73il@gmail.com>

Thanks,
Amir.

>
>  fs/overlayfs/copy_up.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -47,6 +47,15 @@ static bool ovl_must_copy_xattr(const char *name)
>  static ssize_t ovl_getxattr_value(const struct path *path, char *name,
>                                   char **value, ssize_t *value_size);
>
> +/*
> + * Any user can store an empty security.capability, which fails to read =
with
> + * -EINVAL.  It grants no capability, so treat it as none, like no xattr=
.
> + */
> +static bool ovl_no_fscap(ssize_t err)
> +{
> +       return err =3D=3D -ENODATA || err =3D=3D -EOPNOTSUPP || err =3D=
=3D -EINVAL;
> +}
> +
>  int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, s=
truct dentry *new)
>  {
>         struct dentry *old =3D oldpath->dentry;
> @@ -98,6 +107,10 @@ int ovl_copy_xattr(struct super_block *sb, const stru=
ct path *oldpath, struct de
>                 }
>                 size =3D ovl_getxattr_value(oldpath, name, &value, &value=
_size);
>                 if (size < 0) {
> +                       if (!strcmp(name, XATTR_NAME_CAPS) && ovl_no_fsca=
p(size)) {
> +                               error =3D 0;
> +                               continue;
> +                       }
>                         error =3D size;
>                         break;
>                 }
> @@ -947,9 +960,9 @@ static int ovl_copy_up_meta_inode_data(struct ovl_cop=
y_up_ctx *c)
>         if (c->stat.size) {
>                 err =3D cap_size =3D ovl_getxattr_value(&upperpath, XATTR=
_NAME_CAPS,
>                                                     &capability, &cap_siz=
e);
> -               if (cap_size =3D=3D -ENODATA || cap_size =3D=3D -EOPNOTSU=
PP)
> +               if (ovl_no_fscap(cap_size))
>                         cap_size =3D 0;
> -               if (cap_size < 0)
> +               else if (cap_size < 0)
>                         goto out;
>         }
>
> --
> backport

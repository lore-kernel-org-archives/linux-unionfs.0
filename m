Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792960223;
	b=rjiDVYpFN8b4j3JuFVZfZoAcfPVo+/WytjvIbVuTfSU0GJMdEDueP0NFRmvT++grimwP
	 ZI4L+bCebUgWXT804GSVNd7I9dlCsjbXaiCz9PSmoJS1dIDFlwCZY/o6V6gHA1pJMyUfP
	 ir0C//RdOrtNkdIme+nS2oa9Swe1vJjjxt7cmQRlmB+N1gliwUVr1DEzaU93V7EXFNfiM
	 1bP/+IIzNVGDVSwS7ME+y0Z7UyCzbqMO2gLCSfliOaiXUFhHeBMOTfugmz6kKiDrcsdtI
	 m9lFJOLL/aCSdg/GJFIeKNv1hwdDpTqUaLIWwk19AlwCrN050hC+d//mkXaxj77RvuA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792960223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SnxUHRjoVYyks0WRSGwEHiGHDW6d1lV4rjEkpWbA8dc=;
	b=1AkaEcweI54e/UO3qHHoA/XgV/AtllE9LiLii90BOQu/nIkVGUYMGeiy1DYOE6vk+0BX
	 ycH7mRFN/EftKJxDio0nGwEjwbmLgCjgV2AR4aL4jQIOU/i9SejZ+qETntYjEJV14DLMv
	 g1Pju9ckzP7lexlQOBHWRy88lQi5CGYfNbHQoM08frAK19tfNabGq3JDVxmbSB126ji5b
	 Ivbai2FOkVQnB34cOXnxfSDBxirZnE5jkO9izbpLgBXCZjMGlWaMqNbb2G/ALNuIyg6mL
	 2J6aTrg8uYINQF+yVzamut8MBWzMOW3MnnzljGbr85Pqbczx32A5CZG6RXZo35DTLIQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BJwEzZeU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475ED606A31E
	for <linux-unionfs@vger.kernel.org>; Sun, 25 Oct 2026 20:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 475ED606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BJwEzZeU
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c413dea9ca6so373127166b.2
        for <linux-unionfs@vger.kernel.org>; Sun, 25 Oct 2026 13:30:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792960222; cv=none;
        d=google.com; s=arc-20260327;
        b=dc5u6qSUjVlpMGbFDOJVG94Sou/qubaBIGyqRGrlhg7ld7/nJICYCnGykmwzkMwUo2
         MExX12+V8UE90mKJ/a4/plM4BAHTuX2TRUKYOR7VrhYt9wNjrooNZdz+zCkH5kRqYema
         f7bTjcnbgnKZ8JWTD6SoBPgkARS6G2jHqccHEEqRYvMoLZGxskYWQkuB2M1DiHfC+knu
         rBHnF2yvZ364ovurlt9qPXIqcwLwESpI2J113K8RdtFsY2bPYYhY+ft0TNz5Q2Sn5D46
         OqjbZ8iaj3N4K2h79Dbco+YDzS/Xa8bO/xuQY9U4Pen8nXnAAIoaStQ8BgQ6Ob/Gm+jF
         4B9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SnxUHRjoVYyks0WRSGwEHiGHDW6d1lV4rjEkpWbA8dc=;
        fh=LFQk9dzBxCjPikv/KQShdvKT2K4IPB8fjp6gidOnmvg=;
        b=X+ALFrWdmwQ+/qv1lfLZYK20TvsDXikhKvm4tjyP4u0frO8ZaG3OCe1IWWafjrpesr
         NVtzewyRrx6ILHpP5AM7991/e+WLQQT9m3pGvb1hjcwGDbdHsXcLvH4Hv/yaTpT3gTv6
         Wjgkrg2Mu6Qgszoep1OZEITWYsPOFY2bwY+lvx7nRQEiEZjAcwLIzX8upaPIwXVn+ezY
         MZDF2goeW/obHihRTvM7quCqzxlrkuLRbg+mxfGUWkP7DWS4dn6gSqQTt/HpTfZ0sr/Z
         rKLheGPEdaxZPNUbYx2WvYkgIjicZjqJ/3MTAo66mvYKIrnl/cj1x7zEbJtjM3Vl9V9g
         MFTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792960222; x=1793565022; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SnxUHRjoVYyks0WRSGwEHiGHDW6d1lV4rjEkpWbA8dc=;
        b=BJwEzZeU+3M3JBvlvMaYtZ6ACtVLTb0o/qGcUb0ZCzQCY1lRn9QreCBV4WNl5jvozq
         ssqFV9gv3LpKsFeXGKcyyjZauChus10JHUgICucTBN8VL0wllBRLOqMfh2IAlsdeRRK8
         GyCIVtilUVg4IOISA3MERCbmxfKpSzKI3TAEBbxaNAvyZjnNXUFb+mgbL1mRTWwELHjm
         QYrDkc1SD9kpSrbKeZJSDkFomPUuDcMnAFtiiNd2pgugeNXKw33us3WYZUBAOqe/EaqJ
         1P6UBjCGyClswqiJp6y6sEcqkx2wSJ4p81x4eQT6Y5aIpNTKjQClaR/umJpTPUGG4mDy
         qWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792960222; x=1793565022;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SnxUHRjoVYyks0WRSGwEHiGHDW6d1lV4rjEkpWbA8dc=;
        b=0+skd0HVQKUNz/kuIqnGyqAwYGpAbu1oRb+PGYR84qatDJalFUv6RrZd2xq676hpXj
         61LqklXEe6W8zhPZ1x7hSf6TM1ni25v0KFjPuvTe8l0bZbg24aeFsVilTk+XBuOqCjQ1
         OyAmkrtwh2j/gqnsXDot1b7r9+Jhmm7WKhTEGjE9Sx5SYsFtR3i48cOrEpxGbxaJ0wnz
         yCQzESZ8RfpjlkZKrCjsEMOI7kKj358WzbWoxNGtvhvRhVwGBKiHghdWLCYVDb9fLO2/
         1Wb4ygL2S0GhWjW4pG1BSzOE9/Hq3YrjAVhM4UrEjC7xOiKu6s5Fnkz4EPiDNtRINWXh
         h/jg==
X-Forwarded-Encrypted: i=1; AKwUvBzWEXZT0HprjgeX/BpslAasyfFnlc2eh4NPNqxKoh09/HvYpPmh5Qp1NOhRSUPGx/dQo2zG+PPlki7nSYo2@vger.kernel.org
X-Gm-Message-State: AFq9FYJhv+yLRp+ahQ/ecFnnWKvCbulG9EYigDj3FY0/zaMYzsuiIlX6
	LQgy/zTc7Rr5yzecynkoGktp2M2zZqiXeIHh+/HaASgsGTDxgVyMmIF+/dmIlYIvIdA0g1OMrYA
	cB4+5TsS2beQ6Sv/ToAHFwJPJQ948feg=
X-Gm-Gg: AYBFou08pM+Dvi0QJLrRs3PNLfMmMUhMGoK7dmC+Plkp9FcjXyNESm2+TVDSNUWNTbE
	ZqqW+rczWGuht+qU9YG+yG+PfI0Ibz+fUW83tLUQfTekLFM/wi0mAsrMhbsj1ZMPzW35LZYmN34
	+wrCxTluuYfD8NPCnBjMkYLcZxqD9YXngmLrWhEkYwaJvnj/9ozBkMrkmaMV0D69b9V/KPjCQMa
	pTcDQlCkyrhLI+o4PXaiC/3DpKVCmn1+iOJUsmh+LUVLYsSQCqCz2LqYAvasXuImzIqVsaRfvZk
	kC2d87R9XC6iJ1tx7MGxdF7v4B34zYYJ1uDckQ4N3vl6deNluaf2f18k5jeqQUrPTKP+cb1ClC1
	oKkDoVywGhbaPGuQMIcKqb9syOY+6ue95dVbiThPFF2ZG3hWfzsN6wvb2A9wUGfI8dm6jA8Y/Hl
	cHUMBrhHn74UWAGmascyRP01SNBYg=
X-Received: by 2002:a17:907:e93:b0:c46:ca2b:84bd with SMTP id
 a640c23a62f3a-c46ca2b8958mr437657566b.30.1792960221334; Sun, 25 Oct 2026
 13:30:21 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261017165125.2450059-1-amir73il@gmail.com>
In-Reply-To: <20261017165125.2450059-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 25 Oct 2026 22:30:10 +0200
X-Gm-Features: AclHuK80xTSaZ7UMyzLVVcvdzci2HUVT8XZYJ1-ejqxEYesoleURHNE9cYXHQSI
Message-ID: <CAOQ4uxhqQgv=WquPEtJcj5_LzOmfJ5mJagWN0H0UEQ1tjhL3aA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix mount setup failing when override_creds drops CAP_SYS_ADMIN
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Disha Goel <disgoel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 17, 2026 at 7:51=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> When a process drops CAP_SYS_ADMIN and calls fsconfig(FSCONFIG_SET_FLAG,
> "override_creds"), overlayfs saves those restricted credentials in
> ofs->creator_cred. ovl_fill_super() then wraps the entire mount setup in
> with_ovl_creds(), switching to those restricted credentials for the
> duration.
>
> Mount setup calls clone_private_mount(), which checks CAP_SYS_ADMIN
> against current credentials. With restricted credentials active, this
> check fails with -EPERM even though the task issuing
> FSCONFIG_CMD_CREATE is fully privileged.
>
> Use the mounter's real credentials only for cloning the private layer
> mounts. Keep all other backing filesystem operations during mount setup
> under the stashed credentials.
>
> Reported-by: Disha Goel <disgoel@linux.ibm.com>
> Closes: https://lore.kernel.org/linux-unionfs/20260924112858.51392-1-disg=
oel@linux.ibm.com
> Fixes: c28f922c9dcee ("clone_private_mnt(): make sure that caller has CAP=
_SYS_ADMIN in the right userns")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/super.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index bd0a3f9039d25..c8145b62ea99d 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -497,6 +497,20 @@ static int ovl_report_in_use(struct ovl_fs *ofs, con=
st char *name)
>         }
>  }
>
> +/*
> + * clone_private_mount() checks CAP_SYS_ADMIN in current->cred.
> + * ovl_fill_super_creds() runs under the stashed creator cred, which
> + * override_creds may have dropped.
> + * The task that issued FSCONFIG_CMD_CREATE is still current->real_cred,=
 so
> + * use that only for the clone. creator_cred stays in effect for every o=
ther
> + * backing-fs operation.
> + */
> +static struct vfsmount *ovl_clone_private_mount(const struct path *path)
> +{
> +       scoped_with_creds(current_real_cred())
> +               return clone_private_mount(path);
> +}
> +
>  static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
>                          struct ovl_layer *upper_layer,
>                          const struct path *upperpath)
> @@ -520,7 +534,7 @@ static int ovl_get_upper(struct super_block *sb, stru=
ct ovl_fs *ofs,
>         if (err)
>                 goto out;
>
> -       upper_mnt =3D clone_private_mount(upperpath);
> +       upper_mnt =3D ovl_clone_private_mount(upperpath);
>         err =3D PTR_ERR(upper_mnt);
>         if (IS_ERR(upper_mnt)) {
>                 pr_err("failed to clone upperpath\n");
> @@ -1093,7 +1107,7 @@ static int ovl_get_layers(struct super_block *sb, s=
truct ovl_fs *ofs,
>                         }
>                 }
>
> -               mnt =3D clone_private_mount(&l->path);
> +               mnt =3D ovl_clone_private_mount(&l->path);
>                 err =3D PTR_ERR(mnt);
>                 if (IS_ERR(mnt)) {
>                         pr_err("failed to clone lowerpath\n");
> --
> 2.55.0
>

Christian,

Could you say if you agree with this solution.

Thanks,
Amir.

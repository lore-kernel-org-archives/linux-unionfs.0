Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794045879;
	b=2uTxoKT3YhE/Y96qr5fE1RpZa/WYCWn8bRLuigLqh968JooxpkABnOlwilqQds9AxXoB
	 xs9T6MJjykXyg9H6wBNa67pYV9ICwButWokfSUbHgiP8vru/+/MDcqyJCXamUG5KhBsbl
	 2ZAyk7GpzZiAusuRQlZb0Q6KOGf7gMOAI7wCTiJvjEeF8K+epTCD2qUSKQ97z4Z9Lu+AK
	 sH3ZxK814c+K+YlpTP0iSqkr6pd86XLf4zzcKhosyqwMSsyceW2k+o/y6RBPdgL41Fktk
	 JjmqK0Me5BJHr6xyedluySic6gb8bMI2Qo5sOX+tb9dEejpazFgFDsgEjveq1TjMVlA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794045879;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=y5nrBCZaniqp2/d1thUKRR6ml/QllNGD/yqfuQVCeMg=;
	b=bqME74qvnkMRUw33DzXdTdrUQeJoscBELowuZy2zBklNg0u6dzXMYmnC3+tFITKxAgfF
	 VYHitpEGN16XyKWGn4lXaEUZQD5QCl22AZ+07jXd55LZW/Rj9FdQQ5Tsxo+LUzrAKKixz
	 FeGiZIOGbPPyun2yCu3nvoSf0BmryR9Cd/rNl9sxB8w8/2/IBFB5EEe1nIKg1uSxVISU2
	 zPNAoaDXjlsqZp9i57u4u2vw6mz0yanSLOkdtuVv7em4JSJQho7HTwCFcsgid84LDgXxL
	 M8e/rrbVTiWXIGz1/OsYag0IPKzCP/aifmdJtHlExOXIC9JpbJjtYIQC775GaU2RXtA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wwQ7oWNA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882E3606A32C
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 10:04:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 882E3606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wwQ7oWNA
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so2356351a12.2
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 02:04:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794045878; cv=none;
        d=google.com; s=arc-20260327;
        b=dkbpN9BfkNAgSornJyJXk6lAgU4XAsR7aeOXJl+ZY0RaTnDTNgAjJMETRB5xAUJ0Vz
         ka4eRYcC4ieHi+JM4L5YAepXwtj94Q+vZCly492lrMPsalBgy12Be6IHiXsy95rkczOV
         43YUmPOvIDfrPXzZoS/m/b6MpJ/7j0uvyWkydMO9DRmW48ATA6skYxFuqXUDUvJJtPPr
         sduCAD4rbcbmvcIdNT7KrOehEHWVt9de/AsVA6q5pu/rtR3S5+2Zrm7tzf1nnHsdHnAA
         mRw/xsIdrInI8HwiVz+00mtFum1meL+LYW8/qKqU4PGgLXDD88LEl9qW/f4GBmY7DMao
         lESw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y5nrBCZaniqp2/d1thUKRR6ml/QllNGD/yqfuQVCeMg=;
        fh=MFGww5WWwMbVBAGzYlobFNpyX4w0AV158eWpczIR550=;
        b=GKI3vIgJLJEZUdkGuSqllzhHectYevvbWNBj2c5u2UpbKf2h/syPqwsRw+DJ5ks0ck
         Lwdjb8Dv4GoM0doY28hafOYIlS06GgRB9/0xqhBden+jznDSgHcN7hdCTmggWSyHp0el
         nqXStlusD6bLC5IVP4PGVvrneHT5CjLMH9lomx2CDlD95jU7MKVWQmDGJ++yB0hludnZ
         vMc26hhm/6rZSOBPM0A9RvW+1+mSzrkTyUYPriNH0iULfOL6v9USBm4Tlc36GCvynhHK
         prva44VZKbbxB6/k3odABYKSYw0ctEDupcvkJQDsVVFgZ6mNAyS0nBxwtxxG06JWaq/n
         0eXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794045878; x=1794650678; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y5nrBCZaniqp2/d1thUKRR6ml/QllNGD/yqfuQVCeMg=;
        b=wwQ7oWNAA5AZ2QewWyjzkMrz/XHF4ZSC+0dd/azI4kEWTiaDJpAzS7YP9nkxdumv1u
         RD9E9GZmHbDkl/9aAmrJd2LHhmE0H+pMbDjdjSglzPfLpROmzMdfT4dlwgCFQnd4YLGL
         +TmaC/Wjjt+QaFXqapiNTeVQ7ti9bGG9ET3RzI1zcOgPRt+QAoz4WiESNvxMcorDaPcL
         /iy9dMBjvLFGoEPVGfW2wfzRBXKy5s4Lxd5NzBkzEg9yCUXWVjf+UX6Oh19A4+dYff5U
         OLDE0DeVFQ1zDcSRD6jHWDvxnu6xvg1W82WN66STlXs4ubr9Yq8fWPkIFdaQJWxAL8wD
         YuiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794045878; x=1794650678;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y5nrBCZaniqp2/d1thUKRR6ml/QllNGD/yqfuQVCeMg=;
        b=xu9BVqfaoAJ3bDCOuR0E+6ixg3KLxhcas46TatJIguj7X4gre4Mg9hZCmvAqAzfeOg
         fseN1m3rcQPMroTsJKhELYK52SB7BR3fs+3ypkZ6wWEvwu3VUutUAZZ9R5uuDoOMKa3r
         eVM85A+a2fjrRU0EuO3IKdCvwaRwO/ljIOjsGzDL9lcsvoIX5h6pX+86/vk9bFG328aA
         G1/lvgdVgh0FyitCXC9ts65Ky0L0JNt2E7FMKEl/AwNSeh47plQokc5HmoiM+xbXUPTH
         9GOJGROedU11qAKuGHTecP+3EjFKuRWtD2dq8QfofV3b/qZFffMx8Ukdm9CUJrtpcmg8
         BWfg==
X-Gm-Message-State: APuU4Z9Y/gXjXslnx3CN/wJawCe87b0diLGFesTBk9dNqnDVLgPmj62t
	RV6hH3H3zwLxbe1/w0MhkaXBEUfX1Dh8Tv4bgfZ+R5YJyV8I3x46zRtJeDbPnCrJ+cAjYI8yPG1
	fO2xnAPbCO6KwG1kjFE6Guqd2apuyUW38deqg
X-Gm-Gg: AYBFou2VmvE3O85szjeSrmt+nMEdxLDUZ3rSgAYtM88Kv7ZCi5xBQGarhG/ythH9PlV
	+3/ghO7aN8AjgFfB5aS4oYeQ/79hEv4NTwVtWsTt9N0mgMAgDgrqWOrL/t40Dmou4NHOR3V1oio
	5i1mezu7cb3gcwH24pAa32wEVoG5O0NnRMoRRxbMPDlZgbxu7yyBDwx75UwrtyZwz2gJpIxV7xu
	RlXIAszWpL5o4JmJVqmGnPtyt+KXuofFYRCwZMhRiVNL9dpQo1pUbcSi3WdVuSZqEKY1NWLDe1e
	wj/LO7HQZ1GF42aFFTxOY60A7MGRKGOAy1pwWJHRlhFUqa/TsVSzZd3YcidzEqiNzDD13y69JUi
	J11mqV6tAS6jvMs1TJu4QI2A0KLZ4sNFIugsjilE+iVm7eZQYcNqYlEji0gjFpb+ABCxZ4Q==
X-Received: by 2002:aa7:d49a:0:b0:6b6:e8cb:643e with SMTP id
 4fb4d7f45d1cf-6b6e8cb6595mr1993395a12.23.1794045877499; Sat, 07 Nov 2026
 02:04:37 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106133823.1087531-1-giuseppe@scrivano.org>
In-Reply-To: <20261106133823.1087531-1-giuseppe@scrivano.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 7 Nov 2026 11:04:26 +0100
X-Gm-Features: AclHuK-_61v9L4CK2NwE1JtEwebCFhcqZ4Tth7D-CcCN_Yq4hwkgoRXoq8UhuVU
Message-ID: <CAOQ4uxjaW+xQ2xCLzK9uHSU6GrSjndpHiS0ORWv858eZk7kbpQ@mail.gmail.com>
Subject: Re: [PATCH] overlay: do not always clear absolute_redirect
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 2:38=E2=80=AFPM Giuseppe Scrivano <giuseppe@scrivano=
.org> wrote:
>
> ovl_check_redirect() clears d->absolute_redirect before it checks that
> the path element has a redirect xattr.  An element without one, such as
> an intermediate directory in a lower layer, then clears the flag set by
> the absolute redirect of a metacopy file found in a higher layer.  The
> lookup of the data in the data-only layers is not deferred any more and
> the lookup fails with -EIO:
>
>   # l2/f: metacopy, redirect "/dir/file"; l1/dir/ exists, no "file"
>   mount -t overlay none -o metacopy=3Don,redirect_dir=3Don,\
>         lowerdir+=3Dl2,lowerdir+=3Dl1,datadir+=3Ddata m
>   cat m/f   # Input/output error
>
> Set d->absolute_redirect only when a redirect xattr was read.
>
> Fixes: 5436ab0a864e ("ovl: implement lookup in data-only layers")
> Link: https://sashiko.dev/#/bug/linux-2cc24e0b-fbdc-4cf1-aded-cfd19c2918e=
e
> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
> ---
>  fs/overlayfs/namei.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ca899fdfaafd..096e342f7e9f 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -39,13 +39,12 @@ static int ovl_check_redirect(const struct path *path=
, struct ovl_lookup_data *d
>         char *buf;
>         struct ovl_fs *ofs =3D OVL_FS(d->sb);
>
> -       d->absolute_redirect =3D false;
>         buf =3D ovl_get_redirect_xattr(ofs, path, prelen + strlen(post));
>         if (IS_ERR_OR_NULL(buf))
>                 return PTR_ERR(buf);
>
> -       if (buf[0] =3D=3D '/') {
> -               d->absolute_redirect =3D true;
> +       d->absolute_redirect =3D buf[0] =3D=3D '/';
> +       if (d->absolute_redirect) {
>                 /*
>                  * One of the ancestor path elements in an absolute path
>                  * lookup in ovl_lookup_layer() could have been opaque an=
d
> --
> 2.56.0
>

Applied with cc stable to ovl-fixes.

Thanks!
Amir.

Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3EB18B03;
	Wed,  8 Jan 2025 00:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736297541; cv=none; b=gWrr6IOE5Tw+zsGqMQh3Vt+eJuh4kdKD865IE0ESnEla3d/dDEQiuE3PURlUmSYYFZwmm2OPpra2jbW0kcZjhoQuHj4w5cXDzwiNMC1TGjZz+u6vMtr5tbykR5sL1WFtBAXUeZlpIJY53kN797rfg+UY/+tCj5XQEfRnIuvYd0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736297541; c=relaxed/simple;
	bh=1hx0HDoca09glfJvvZptYA4vHPtCyl6rM3asrb5Q9xw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHAdSfORXzEgEQy3u58Dc4un+7OYILTo8qK51eGuePYlFXZSMJbuSaZcSLY98du2VqjCfLI25n0850wv0fqECfFobVOlk+aNqppJ0JZFL6ks8xn/NUtyvO6QvaYffK5QPAkIo0/edxC4a3pURxb5YHXhOx6GIflIEMnH8uM9vC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lJqvgQKc; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lJqvgQKc"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21619108a6bso223421205ad.3;
        Tue, 07 Jan 2025 16:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736297538; x=1736902338; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1dfx2gHGrXCO/ACBZjbBp33mO0W09QUa07tyODs/ZN4=;
        b=lJqvgQKcGHghdZxuUBui6QCnE5jdIveo2IE2n6zAuanwyDz32cMk5zUhsi9hR9FmL5
         bLYJuuzt6QflGMc3jiTxpr26XJKFYbnDYZWuVB0Iav2u7E2Gf1MK6WxOpvtDA0X4Nt67
         vPEeaF1qj1a+dDpBdiq4JDRqIH4bJKRmaNJKSVuE5x1o+oxKPYTkT8EwVwDn8Ceih5xT
         x6Dpv917EGVT/xwZQeUCsqFx6kzedyUNiKGrjFXNMMLtWsOtXa939/P+wnxzXD8G3Ppa
         Gm5O0M0zTnjRIKqwu4h7rzDJ4swzFjBaJLmh4W1qx4MlVgG9xv7EnCxvm1OK/KLUNcUg
         NeIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736297538; x=1736902338;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1dfx2gHGrXCO/ACBZjbBp33mO0W09QUa07tyODs/ZN4=;
        b=sID+woxmgIQ9is8wJ4Fm/IZhCOWrjCPJ6KsOBgY9i9xlquM3cF/sAqg59mujaVn95A
         uE9NbccFXkdW+3RYK6ojB1sPtEdLvriiW3Juz01ILOJVvZIpAWCxC6M7j4zz1XJyRHif
         AtbbRTrRXj7z6Tp0NtXLHIHbU1bn4zJ0JgtqDeJkqg41IdX5VGCY9lmd8+N+uhHAWNbH
         v4nfJvPJck1upJsw4IlPrZN5lOdMNdsdyiRGDORQs5DvNSePDiWN51SXsIKGSCqBlAhU
         DimtV50+FLwiNQnX/TO5ElU1JUVa8V2hqJUedIuErzPs/FJ2iAqDZYRFaC/QJxjdw/87
         d0mQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbCHozQzat6PVdnQHsYg8V+UZakz45kA5BkMZuDhJQf8+N4IVPJxP9NlKUMfsvHrmI9+clwNhdYVQ=@vger.kernel.org, AJvYcCXh7dkKBLv/jVO/gma/GocTnSfo/JbVtgF3ZlxE5NE6r+/ZW9ccfYByq3G2U840Ytz0TVb+t28OIrMKflNT@vger.kernel.org
X-Gm-Message-State: AOJu0YyJTT1hJrnSE/6wi2SjeAdIC7kMa6kDSw3yR06Fznu4VNq/G+at
	IH52+B/vD5QI4QdBzo2ycIi7U+CNgWLHnDCmMaVQQaMVG16Tws/h
X-Gm-Gg: ASbGncvskFJlcsLAElly+xEBv+JxvAHXRlYiOnCi8/CjnU+WA4HDVfxuvMsYKtU2zda
	jxb1gcg7xEtn8VbZR+8f64Z5FZCxzT8g+pkmrNtbOODC9BBAWSigHpqzk3xOiN+H2ci13AoxpDJ
	MgSaniuOk02JjahDKedPW7xqsec0iTvRlrt15bkcWfsPn412eYbyoNWqo0csNkMszWXwTXPL8A8
	J/FMrciMNecYEbZD1bzeFcr3FFx2PvrGIx8hFWGRvu7Qp/w/D5JS/7Q
X-Google-Smtp-Source: AGHT+IG7mpfIG46AVyEADl19kYJFxv9ku3b84PmnXvPjHnvu0Yysxj1YqbKGV51yeLhxo+VRS7uf6Q==
X-Received: by 2002:a17:902:da88:b0:216:1543:195d with SMTP id d9443c01a7336-21a83f64026mr15288275ad.25.1736297536788;
        Tue, 07 Jan 2025 16:52:16 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f54a2efcb5sm155526a91.47.2025.01.07.16.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 16:52:15 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 13555420B892; Wed, 08 Jan 2025 07:52:12 +0700 (WIB)
Date: Wed, 8 Jan 2025 07:52:12 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] overlayfs.rst: Fix and improve grammar
Message-ID: <Z33MPLsHoqmniFUE@archie.me>
References: <cf07f705d63f04ebf7ba4ecafdc9ab6f63960e3d.1736239148.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QWsARqyR9kJYqaWU"
Content-Disposition: inline
In-Reply-To: <cf07f705d63f04ebf7ba4ecafdc9ab6f63960e3d.1736239148.git.geert+renesas@glider.be>


--QWsARqyR9kJYqaWU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07, 2025 at 09:44:28AM +0100, Geert Uytterhoeven wrote:
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 4c8387e1c88068fa..a93dddeae199491a 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -266,7 +266,7 @@ Non-directories
>  Objects that are not directories (files, symlinks, device-special
>  files etc.) are presented either from the upper or lower filesystem as
>  appropriate.  When a file in the lower filesystem is accessed in a way
> -the requires write-access, such as opening for write access, changing
> +that requires write-access, such as opening for write access, changing
>  some metadata etc., the file is first copied from the lower filesystem
>  to the upper filesystem (copy_up).  Note that creating a hard-link
>  also requires copy_up, though of course creation of a symlink does
> @@ -549,8 +549,8 @@ Nesting overlayfs mounts
> =20
>  It is possible to use a lower directory that is stored on an overlayfs
>  mount. For regular files this does not need any special care. However, f=
iles
> -that have overlayfs attributes, such as whiteouts or "overlay.*" xattrs =
will be
> -interpreted by the underlying overlayfs mount and stripped out. In order=
 to
> +that have overlayfs attributes, such as whiteouts or "overlay.*" xattrs,=
 will
> +be interpreted by the underlying overlayfs mount and stripped out. In or=
der to
>  allow the second overlayfs mount to see the attributes they must be esca=
ped.
> =20
>  Overlayfs specific xattrs are escaped by using a special prefix of

Looks good, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--QWsARqyR9kJYqaWU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZ33MMgAKCRD2uYlJVVFO
owfZAQDsWmD/+nhm1RaatemFWcRM11H7FTHTht0jdK6WdFtDwAD8Ds3LMo7qfMlE
n8SXLrJJ2x8efIu9x0YF6/fkx3Km0wc=
=64/5
-----END PGP SIGNATURE-----

--QWsARqyR9kJYqaWU--

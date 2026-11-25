Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795610996;
	b=5G37NKdxjhCaod83uziUR3luhiTi3zrL3xOZ112oJWNG7zBprwgj2JNQWKOMPaZ0u7v0
	 /2SmDO2TESnlvbNFOv2TqY53i6gxsrFH/w3+5ld7vSEdCJ/rxcjyMZVwzepHgfITSCFEu
	 FgsUbN3oj1FYOwfXEycarOhlQNUqHavxbbgWCLD5gi47JNcLVcvxaqXP2aDXBdfRujqkp
	 8WzrWifSqJAc9FC1lm17WJmu9PLC4IuWPZx6mcySftiR/N5IYTolchLmxbBMxtxxhuYsf
	 zBI3s7Rxcmibl9fsTy1DtfZRSJAtz56U0//g1GSoCUyWNm9CWVHz2WZ/GiYk0XNyc4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795610996;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Le4AwFe0WXouABp9DXzuQtZ3ZnCfLcbkB8kE/IdX7wA=;
	b=AX9wth/JE1ANVcbAdu3iVvQzV/lKwrc+1bpr5tcTWgXZRUZiKp/GaS8zte3FCjrT1jF5
	 sHSqAHNAT9m502id4hCK4n/XtkVvEShs/ISO/HQLjSZXaIgjd3z4uLYOYd8eup/RWZVEk
	 j7Gz8bUHaC+EErGcv2oaE9Jm+5leh9zWIsftLyS24Qzdkz493UIAEB5TQfhmPplE3i2SZ
	 eP5xoOTnojAXxgrLC1BNNycqrWoPtzJqHQPLDZPl7c6y313hGG+Y4nAkxMHf3ikw0XT2b
	 J8pcEbfcvpo7udBuuIZhfBoRaqXCFR95DMeZMeIf2wBPIftDHXd1PflyeygbxwbeZNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ijrvPjrs;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF2D606A326
	for <linux-unionfs@vger.kernel.org>; Wed, 25 Nov 2026 12:49:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CF2D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ijrvPjrs
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb72b44a97so49436585e9.0
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Nov 2026 04:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795610993; x=1796215793; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Le4AwFe0WXouABp9DXzuQtZ3ZnCfLcbkB8kE/IdX7wA=;
        b=ijrvPjrs4XPMGxLv2/cLDzYf1DTkp26koBrs+YwuqX5elYJruc4hClaOIjF62Q3+YN
         LRHIUBC22PWGF/rAGALu7SoOt5zqUHESVTCa5vHMQJoFy4B5gkLHeV5hugIirMLPKc1z
         lwkIjSkykztPQpKhyKTDraxT5P3oaH7NzwApTcr02ARr2hT5KerzhwRvxghSP1A3P/Bp
         EtgDED95aoU7Ek6mxljMaLWO6Bx5amJKRdXl3ABZkqxCYsSCC5SlDmTZNR4DGfcavrRk
         HtSpSZ/UepV+pwNgpwEHfsqbflJPpiVU5KOF/FpJhp5lP9+HVdK4ulKpQ0NMqA1E55T/
         7WHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795610993; x=1796215793;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Le4AwFe0WXouABp9DXzuQtZ3ZnCfLcbkB8kE/IdX7wA=;
        b=C8SvpDipX42stwLK7z4huG9gQh3aJJTcdqjFQOZNNOkgY7X6t17PikAvAEVqZxvFzv
         mTwFMgrihfBn9Y/qD3NAB/uBsZi8HAAJ8/FFKLJOe10ZW0dbux9YYU+/PD+PCUrWV9y1
         +s/Mu+zL8rpSbdE5bJ1qyTv06HpS7KAlbCtrCNxTDIphsRYPZ4CGPyVliX3yoHGYDsZK
         1Ic/gr4Q/v5CBENjmvzNLRDVK6UhS58z/Tx3GZEcdkI4ygQ12GO2am+iL7sATogRkHMD
         lrUfpxSV8E7hbWHcfOcfK+5gCvH0fls2cDEVBkt58ANLTcZNTrh7h2uG7xeNyVKl1Xtf
         xDIw==
X-Forwarded-Encrypted: i=1; AL+hErGR/bJkUniXBs9GZjiFN9e/mv3nQ6bPLbUE9jGsvqhmLeMkgE/xj6YdLxms888Yc/BaqPHf6tYk+JoQruQv@vger.kernel.org
X-Gm-Message-State: APuU4Z+3UVUfXEX/ti6MjYLPlhUB/ucwTnBEiJ3C3IWbPEIfZS99nExz
	bFPvnBZJjr9qTKCUoO4VXjSoS9yk6zkQJiC3gC5IUq3RxfKSCYhrx6A/v2up7WwnwXyA
X-Gm-Gg: AZFdTZeGQt59KbUMbrF50rqkr1HJLq8BB61v/yScCBdcOtZC/EKiiwkqbMa8bn1SmZD
	PmIHzcLQ1MX2JRKERXy5LXmXc/ggolra1bFhTanmYm7Hw2cOHs13yoXNyavNPQde+UvE59vOFm8
	WGKZf9oLm5EuVaPpmCBbU9lGUqddr5zAlWPfaXgF/BfRhLREkg8b76ClZy2hv1TbzIhe03pnEmB
	DDUqh9mvIu9lJBzGRrP4iEWgfRKI3AWzF06znibZzAsWbA4EO5QUFCiadPF6Dw6s/qjYAwGQdVI
	HzAAH4DiT+wj9jMNBfOrSxVuOp8+6G6oSPhhDvoCdwc9zBsca50h0JQs94TP9spkRHHjer8VdNv
	NEKrbTZowvhcef2F/TzSlfNFaKDtnI9GfsV1Uk6S9VphFjCQMylvlutkG/KtilIyBshkeW30c0x
	GS09sy8qkdan1WeN2QnPgZmnwRe3fxyRIZiC2f8k164m1YMIOnhUupsTlL0v7RA10sE9PTVGPa7
	wcM6DH39UixDP1FMELrCynZFjUMLzU33o3leWL4fIBwuPRcfqDdAjIOkLVckgolX+hw0QBdHkoP
	T8nW/yBaFCI3hN5tbbev/RoURhd/E2ESAPv66JR4q9+geN/CZoENVwRTKlsFaFbgbUQX5wPQLEU
	EapZ+2gWHizE6vgX2ry2h/x895ZQbWdVQ4UWmXvX7LuTvEVUrcQJ6FQ==
X-Received: by 2002:a05:600c:a11:b0:4a2:e0c:2b0a with SMTP id 5b1f17b1804b1-4bb888120famr364999585e9.16.1795610993400;
        Wed, 25 Nov 2026 04:49:53 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:c235:97b:8b16:8928? (p200300cf572c2800c235097b8b168928.dip0.t-ipconnect.de. [2003:cf:572c:2800:c235:97b:8b16:8928])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b7515sm710678895e9.13.2026.11.25.04.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 04:49:53 -0800 (PST)
Message-ID: <34297f66e07c1a64d81205c7669801738676f356.camel@amutable.com>
Subject: Re: [PATCH v2 11/13] fs: remove d_real_inode()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, Amir Goldstein
 <amir73il@gmail.com>, 	linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>,
 	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 linux-integrity@vger.kernel.org, 	linux-security-module@vger.kernel.org,
 linux-mm@kvack.org
Date: Wed, 25 Nov 2026 13:49:52 +0100
In-Reply-To: <20261116-work-ovl-d_real-v2-11-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
	 <20261116-work-ovl-d_real-v2-11-90564c4ae347@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-11-16 at 10:44 +0100, Christian Brauner wrote:
> All callers have been converted to d_real_data_inode() or
> d_real_metadata_inode(). Remove d_real_inode() so that any user we
> missed, or one that gets added in another tree, fails to build
> instead
> of passing an ERR_PTR() from d_real() to d_inode().
>=20
> Add a porting.rst entry.
>=20
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0Documentation/filesystems/porting.rst | 10 ++++++++++
> =C2=A0include/linux/dcache.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 13 -------------
> =C2=A02 files changed, 10 insertions(+), 13 deletions(-)
>=20
> diff --git a/Documentation/filesystems/porting.rst
> b/Documentation/filesystems/porting.rst
> index c38f5df755bb5..aa0fc43907017 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -1422,3 +1422,13 @@ helpers take a const struct mnt_idmap *.
> mnt_idmap() and file_mnt_idmap()
> =C2=A0return one. The idmapping is immutable so nothing should have
> modified it
> =C2=A0anyway. References are taken and dropped via mnt_idmap_get() and
> =C2=A0mnt_idmap_put() as before, both accept a const pointer.
> +
> +---
> +
> +**mandatory**
> +
> +d_real_inode() is gone. d_real() can fail for D_REAL_DATA now and
> returns an
> +ERR_PTR() then, e.g., when overlayfs can't look up the data of a
> metacopy file
> +in a data-only layer. Use d_real_data_inode(), which returns the
> inode hosting
> +the data or an ERR_PTR(), and handle the error. Use
> d_real_metadata_inode() for
> +the inode hosting the metadata and handle its errors as well.
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index fd8853622f250..fe1aa8fea0c7a 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -654,19 +654,6 @@ static inline struct dentry *d_real(struct
> dentry *dentry, enum d_real_type type
> =C2=A0		return dentry;
> =C2=A0}
> =C2=A0
> -/**
> - * d_real_inode - Return the real inode hosting the data
> - * @dentry: The dentry to query
> - *
> - * If dentry is on a union/overlay, then return the underlying, real
> inode.
> - * Otherwise return d_inode().
> - */
> -static inline struct inode *d_real_inode(const struct dentry
> *dentry)
> -{
> -	/* This usage of d_real() results in const dentry */
> -	return d_inode(d_real((struct dentry *) dentry,
> D_REAL_DATA));
> -}
> -
> =C2=A0/**
> =C2=A0 * d_real_data_inode - Return the real inode hosting the data
> =C2=A0 * @dentry: The dentry to query

Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nplUyg3L"
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DADCCD;
	Tue, 12 Dec 2023 21:16:41 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6ce939ecfc2so5919040b3a.2;
        Tue, 12 Dec 2023 21:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702444601; x=1703049401; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LRr44WEMSXOTi5UdO7XfFiUfq3ncu6za7AytVC7IChw=;
        b=nplUyg3Lm7jhyG3NA0DB899gFb4Oz/ops170AIbd6sT5AqkMiClIK6Bz3zxKoFtyaG
         qFwfmX8WV0ay7lnfG/t6c8hzJRS/ccCcibLppDZC04QSkz3lcnLJMDCRen0GBy4W6SGO
         8151RvyRCE4TBrhwb8mzj+64KcLEKXOY0DENkg4XX5/5uVhygooVKMQcqtcFpRpiDYHT
         nxAbGoL6djnau/o7Bb711HxTMSUkBJn9AdgiUtB8O/UXKWau2XDsfHnbGtLFwveW1GKK
         +ziHoWSK6QSwvghkS8hFevw8lGSgt1eVfLFOzJOhnnP4MsDCNIJuZ4fj5y38a20TWcl/
         iryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702444601; x=1703049401;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LRr44WEMSXOTi5UdO7XfFiUfq3ncu6za7AytVC7IChw=;
        b=moKnHltynTy0u/3xwAEN2l+fxOhU9UxRSyrfmgeSv1KCJ1J3RXWG2+XbvygSmjmY2e
         raKU0mr90+MaUm32Toa/fzP1GOudJcscE4sgqVsbOC6NH32ghq1L+I+7jDomW0NtUhpd
         aPWx8vJsREu/iqqIEMr4XyNvl3g9TZxgc9hOf+lHbPh/baeWQXCPB7rHG89cagWvhBUZ
         JyWCZLuCDM8LFdRwHf+HJdIdfKf2u7UA7pKJ0woW4q9VBs9HEhyK9jUVQmrWeNcViND5
         zAgp4mVohIgdn94rOqLsygua9eImkUPIqmmfCzvLrVO/N69FVrfJGb8+1dFVbU7KDe2y
         IB8g==
X-Gm-Message-State: AOJu0YyU39VpkqRr6YgCYOr4XpkXy71p98NDPHLr9+oIt7UBXZJ54YRU
	Yrvb0TJttAYvezGemyeFrCU=
X-Google-Smtp-Source: AGHT+IHMgoOLueyJ4jGuoXnKD1Q/bSXL2KX2jtf9N9Q0IfGiCx0SAHYFVC989l8V+q8J13bd27EEYQ==
X-Received: by 2002:a05:6a20:9151:b0:190:46c8:a3e1 with SMTP id x17-20020a056a20915100b0019046c8a3e1mr7927874pzc.97.1702444600965;
        Tue, 12 Dec 2023 21:16:40 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id p1-20020a056a000a0100b006c06779e593sm9399506pfh.16.2023.12.12.21.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 21:16:40 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id BCB8311AB0467; Wed, 13 Dec 2023 12:16:36 +0700 (WIB)
Date: Wed, 13 Dec 2023 12:16:36 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] overlayfs.rst: fix ReST formatting
Message-ID: <ZXk-NPhtH1g57HWt@archie.me>
References: <20231212073324.245541-1-amir73il@gmail.com>
 <20231212073324.245541-3-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vSL+kmlKkzmtPjfX"
Content-Disposition: inline
In-Reply-To: <20231212073324.245541-3-amir73il@gmail.com>


--vSL+kmlKkzmtPjfX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2023 at 09:33:24AM +0200, Amir Goldstein wrote:
> Fix some indentation issues and missing newlines in quoted text.
>=20
> Unindent a) b) enumerated list to workaround github displaying it
> as numbered list.
>=20
> Reported-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  Documentation/filesystems/overlayfs.rst | 69 +++++++++++++------------
>  1 file changed, 35 insertions(+), 34 deletions(-)
>=20
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 926396fdc5eb..37467ad5cff4 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -174,10 +174,10 @@ programs.
>  seek offsets are assigned sequentially when the directories are read.
>  Thus if
> =20
> -  - read part of a directory
> -  - remember an offset, and close the directory
> -  - re-open the directory some time later
> -  - seek to the remembered offset
> +- read part of a directory
> +- remember an offset, and close the directory
> +- re-open the directory some time later
> +- seek to the remembered offset

Looks OK.

> =20
>  there may be little correlation between the old and new locations in
>  the list of filenames, particularly if anything has changed in the
> @@ -285,21 +285,21 @@ Permission model
> =20
>  Permission checking in the overlay filesystem follows these principles:
> =20
> - 1) permission check SHOULD return the same result before and after copy=
 up
> +1) permission check SHOULD return the same result before and after copy =
up
> =20
> - 2) task creating the overlay mount MUST NOT gain additional privileges
> +2) task creating the overlay mount MUST NOT gain additional privileges
> =20
> - 3) non-mounting task MAY gain additional privileges through the overlay,
> - compared to direct access on underlying lower or upper filesystems
> +3) non-mounting task MAY gain additional privileges through the overlay,
> +   compared to direct access on underlying lower or upper filesystems
> =20
> -This is achieved by performing two permission checks on each access
> +This is achieved by performing two permission checks on each access:
> =20
> - a) check if current task is allowed access based on local DAC (owner,
> -    group, mode and posix acl), as well as MAC checks
> +a) check if current task is allowed access based on local DAC (owner,
> +group, mode and posix acl), as well as MAC checks
> =20
> - b) check if mounting task would be allowed real operation on lower or
> -    upper layer based on underlying filesystem permissions, again includ=
ing
> -    MAC checks
> +b) check if mounting task would be allowed real operation on lower or
> +upper layer based on underlying filesystem permissions, again including
> +MAC checks

Shouldn't the numbered list be `1.` and `a.`?

> @@ -421,15 +421,15 @@ Since kernel version v6.8, "data-only" lower layers=
 can also be added using
>  the "datadir+" mount options and the fsconfig syscall from new mount api.
>  For example:
> =20
> -  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l1", 0);
> -  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l2", 0);
> -  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l3", 0);
> -  fsconfig(fs_fd, FSCONFIG_SET_STRING, "datadir+", "/do1", 0);
> -  fsconfig(fs_fd, FSCONFIG_SET_STRING, "datadir+", "/do2", 0);
> + |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l1", 0);
> + |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l2", 0);
> + |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l3", 0);
> + |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "datadir+", "/do1", 0);
> + |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "datadir+", "/do2", 0);

What about using code block syntax (e.g. `For example::`)?

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--vSL+kmlKkzmtPjfX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZXk+NAAKCRD2uYlJVVFO
o0p4AQCZZvR2aWqf1mkdwsbtJagAcODwt7KdO9o1fc99tDa9rgD9Gn5zOl1ZDaDB
p0UMqUnkDDLoMmA7P6EyMZ+/L/9iSwQ=
=j+hl
-----END PGP SIGNATURE-----

--vSL+kmlKkzmtPjfX--

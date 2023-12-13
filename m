Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8t5Pjpz"
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11406B7;
	Tue, 12 Dec 2023 21:00:47 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id 5614622812f47-3ba00fe4e98so2842624b6e.2;
        Tue, 12 Dec 2023 21:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702443646; x=1703048446; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OnHr3zz5oe16bFdKJp/3TpS27wFTuz14+HDiKum6VyE=;
        b=e8t5PjpzLTJPmsuLdQgMCBTlpY8EDsXhDWhVx+PsAdRyzhmJrQacMRQeY2IB4rJ+r8
         1V6LHa/6kiddjLl6yQ3WpaBQOBUrBDFMPz2kY2j+jLxRE6CM73jnWgx+ugsIlMx9cXBD
         06BVkwqHzkXCDcBAE1ltPOI4+yn5MILlcC3SAESJ2rJZDRixVF7srdj3bRwnAQ6ZNUAA
         tYj+hS98b2EAqsKGV1IFzUAAPld+YG4a5LzG2Edtd9C53vYS0LZ3m431XMez4xMXxyZN
         ZARu5pDvdth3Xqv3RD3woQb1MxY7JWZdck9t2opThLQshbZLUfC89LksPR8HU8Oa0Qyr
         Bydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702443646; x=1703048446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OnHr3zz5oe16bFdKJp/3TpS27wFTuz14+HDiKum6VyE=;
        b=UhGIMYx7DNZwJVM+zHx/HcCufQY8ffRXI6jURni12tPn8hVXmlLDIJUs7YGx5bYICP
         hGRsVnQtll2K3ZbbStu/woBHEuGg4eXKYEfhcnhIAIIDFtXGBNqQ9PjlTXtQ3u16BNFz
         xZ1qQ25ns77ruhZZO5g1xrt90jtyVkuUdWnY0m8fklRPhHDGng1NMQcIVl8z47kyCCMX
         Y1M8AqREdIYbTF48E+LUXOP68C0Ggyp17sAw7l3ycn/QkN50aFEH5DTXmdpc4/vESJDe
         ySlTX6LWU5d5OqNLUIZhNMujHKULwAJw05YtMEGfin8LBQf9YwpxOzEpLJVHN9UZIyND
         Om+w==
X-Gm-Message-State: AOJu0Yx9N6EYrb4wpQJCX94z3LkWXjgjHo1Cyt3WPXutCe5LC/3hDALF
	FySPky8whzAN3SlP5ZncpHkUYVhdYXITEg==
X-Google-Smtp-Source: AGHT+IE0l9iMQZYUh5JmGa/Xmo+w5wSzmtVTAlhbAoDtLTIoBYps8LQZfJEG8vZaaL5QmkcBm7Npsg==
X-Received: by 2002:a05:6808:d51:b0:3b8:6057:b08a with SMTP id w17-20020a0568080d5100b003b86057b08amr9313785oik.6.1702443646327;
        Tue, 12 Dec 2023 21:00:46 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id c23-20020aa78817000000b006ce358d5d9asm9321092pfo.141.2023.12.12.21.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 21:00:45 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id BB2A61006E92A; Wed, 13 Dec 2023 12:00:40 +0700 (WIB)
Date: Wed, 13 Dec 2023 12:00:40 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>,
	Linux unionfs <linux-unionfs@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/2] overlayfs.rst: use consistent terminology
Message-ID: <ZXk6eNa8n0n1Uerb@archie.me>
References: <20231212073324.245541-1-amir73il@gmail.com>
 <20231212073324.245541-2-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gDsvBZp3hiuElDa3"
Content-Disposition: inline
In-Reply-To: <20231212073324.245541-2-amir73il@gmail.com>


--gDsvBZp3hiuElDa3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2023 at 09:33:23AM +0200, Amir Goldstein wrote:
> -1) "redirect_dir"
> +redirect_dir
> +````````````
> =20
>  Enabled with the mount option or module option: "redirect_dir=3Don" or w=
ith
>  the kernel config option CONFIG_OVERLAY_FS_REDIRECT_DIR=3Dy.
> @@ -568,7 +569,8 @@ the kernel config option CONFIG_OVERLAY_FS_REDIRECT_D=
IR=3Dy.
>  If this feature is disabled, then rename(2) on a lower or merged directo=
ry
>  will fail with EXDEV ("Invalid cross-device link").
> =20
> -2) "inode index"
> +index
> +`````
> =20
>  Enabled with the mount option or module option "index=3Don" or with the
>  kernel config option CONFIG_OVERLAY_FS_INDEX=3Dy.
> @@ -577,7 +579,8 @@ If this feature is disabled and a file with multiple =
hard links is copied
>  up, then this will "break" the link.  Changes will not be propagated to
>  other names referring to the same inode.
> =20
> -3) "xino"
> +xino
> +````

Why is there section heading conversion above (not mentioned in the patch
description)?

--=20
An old man doll... just what I always wanted! - Clara

--gDsvBZp3hiuElDa3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZXk6dQAKCRD2uYlJVVFO
oyHsAPwOm0P5j5GpMmGREXYQvbgRKm9z+vIVakBY7KYx2VigLAEAwGcSrPwydvo3
xZXdkPzwjl6nN7Y1rWJAqGQ2yLNMBgI=
=EKBf
-----END PGP SIGNATURE-----

--gDsvBZp3hiuElDa3--

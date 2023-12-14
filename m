Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZMQOgzOs"
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC17100;
	Wed, 13 Dec 2023 20:52:55 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-35f519f3ea9so18671175ab.3;
        Wed, 13 Dec 2023 20:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702529574; x=1703134374; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xBL//dFno50dH3+bnTUnWJiljaw2TEHf89kkza+G3wQ=;
        b=ZMQOgzOsSp6G7AtgF3psvJYeISeK/zNcXnpVazHgmOUBCWsgO6bq6sT4/SCu11E4Py
         bMxC7ErJCFfqF+JL4Y9xQBvg+dn9gLf9ew6mZY+eFM7XOIVqV/5VkHq9vh049ikw9TBl
         kV2mqilzoTvGX/Zx3PVkCTDbMytOUqwiQx9JmCJjcABxusueXLujG4wFdYF6+IVtQDcu
         M16LGfcn5aVwGPkn2JkX804DlzLEAcG39K2CALNvFFoRKrsCC7gHgsp7f6wg2X6LPAD4
         ubZYmxzB4aRtSiQoCLNqpamuO0JTG3LvRTj0MmFFm2e6W95pYMWffVrE+8NjwL4xKdCR
         GB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702529574; x=1703134374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xBL//dFno50dH3+bnTUnWJiljaw2TEHf89kkza+G3wQ=;
        b=H7ks6s0BPOW9IYZh4DPtjRFAeQf0lwTSy75hBQCnPn2SfpBTGeerm4GqQyHe2P/ZTc
         o485xLJU8K8Q7HbrAe+ZSmgrqjzAsEwlKc+H2qFptk7B64iADRQnPfkdRZTDDwt7f61Q
         EGJjGcuDxDdIGLdHF+EZiaj8s6cF0IojTKbHYGDcICncpRwEtMHIPaTtt8hqH+A8hKUx
         oMKL4uLhsLtTRgnyUCg2gYk1E7fH8c3aUWui5KZ3zZ60f+mOW0wPwwHCkyX9T5pscvIU
         zUL8piuQtLkb60giS0/QBtPQ6glNGbPsZH+K00lFJPFG41YD7rEBO5S4xhPfaN+mnF13
         7fjQ==
X-Gm-Message-State: AOJu0YxxfUuBzK6YTcbvpHFxYBP1cJ/Cnwj/uHZTvB9uufTY7Y5hN18E
	MuotdYVUMGZteM4TCl/s9IM=
X-Google-Smtp-Source: AGHT+IFKNTXiZ77OTHIhHsmCLF2BFCeJ3mpNOa+2Y9F1F91rG38ptjtc7AO21ayFpO8le1cOzNnUZQ==
X-Received: by 2002:a05:6e02:1522:b0:35f:77c5:5e6c with SMTP id i2-20020a056e02152200b0035f77c55e6cmr1465999ilu.118.1702529574395;
        Wed, 13 Dec 2023 20:52:54 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id k189-20020a6324c6000000b005bcea1bf43bsm10483411pgk.12.2023.12.13.20.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 20:52:53 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 7A9E7114F75F3; Thu, 14 Dec 2023 11:52:48 +0700 (WIB)
Date: Thu, 14 Dec 2023 11:52:48 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] overlayfs.rst: use consistent feature names
Message-ID: <ZXqKIBilWjYj8X93@archie.me>
References: <20231213123422.344600-1-amir73il@gmail.com>
 <20231213123422.344600-2-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="31sZhyVSKfZYntyY"
Content-Disposition: inline
In-Reply-To: <20231213123422.344600-2-amir73il@gmail.com>


--31sZhyVSKfZYntyY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 02:34:21PM +0200, Amir Goldstein wrote:
> Use the feature names "metacopy" and "index" consistently throughout
> the document.
>=20
> Covert the numbered list of features "redirect_dir", "index", "xino"
> to section headings, so that those features could be referenced in the
> document by their name.
>=20
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  Documentation/filesystems/overlayfs.rst | 27 ++++++++++++++-----------
>  1 file changed, 15 insertions(+), 12 deletions(-)
>=20
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 0407f361f32a..926396fdc5eb 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -39,7 +39,7 @@ objects in the original filesystem.
>  On 64bit systems, even if all overlay layers are not on the same
>  underlying filesystem, the same compliant behavior could be achieved
>  with the "xino" feature.  The "xino" feature composes a unique object
> -identifier from the real object st_ino and an underlying fsid index.
> +identifier from the real object st_ino and an underlying fsid number.
>  The "xino" feature uses the high inode number bits for fsid, because the
>  underlying filesystems rarely use the high inode number bits.  In case
>  the underlying inode number does overflow into the high xino bits, overl=
ay
> @@ -356,7 +356,7 @@ as an octal characters (\072) when displayed in /proc=
/self/mountinfo.
>  Metadata only copy up
>  ---------------------
> =20
> -When metadata only copy up feature is enabled, overlayfs will only copy
> +When the "metacopy" feature is enabled, overlayfs will only copy
>  up metadata (as opposed to whole file), when a metadata specific operati=
on
>  like chown/chmod is performed. Full file will be copied up later when
>  file is opened for WRITE operation.
> @@ -492,27 +492,27 @@ though it will not result in a crash or deadlock.
> =20
>  Mounting an overlay using an upper layer path, where the upper layer path
>  was previously used by another mounted overlay in combination with a
> -different lower layer path, is allowed, unless the "inodes index" feature
> -or "metadata only copy up" feature is enabled.
> +different lower layer path, is allowed, unless the "index" or "metacopy"
> +features are enabled.
> =20
> -With the "inodes index" feature, on the first time mount, an NFS file
> +With the "index" feature, on the first time mount, an NFS file
>  handle of the lower layer root directory, along with the UUID of the low=
er
>  filesystem, are encoded and stored in the "trusted.overlay.origin" exten=
ded
>  attribute on the upper layer root directory.  On subsequent mount attemp=
ts,
>  the lower root directory file handle and lower filesystem UUID are compa=
red
>  to the stored origin in upper root directory.  On failure to verify the
>  lower root origin, mount will fail with ESTALE.  An overlayfs mount with
> -"inodes index" enabled will fail with EOPNOTSUPP if the lower filesystem
> +"index" enabled will fail with EOPNOTSUPP if the lower filesystem
>  does not support NFS export, lower filesystem does not have a valid UUID=
 or
>  if the upper filesystem does not support extended attributes.
> =20
> -For "metadata only copy up" feature there is no verification mechanism at
> +For the "metacopy" feature, there is no verification mechanism at
>  mount time. So if same upper is mounted with different set of lower, mou=
nt
>  probably will succeed but expect the unexpected later on. So don't do it.
> =20
>  It is quite a common practice to copy overlay layers to a different
>  directory tree on the same or different underlying filesystem, and even
> -to a different machine.  With the "inodes index" feature, trying to mount
> +to a different machine.  With the "index" feature, trying to mount
>  the copied layers will fail the verification of the lower root file hand=
le.
> =20
>  Nesting overlayfs mounts
> @@ -560,7 +560,8 @@ file for write or truncating the file will not be den=
ied with ETXTBSY.
>  The following options allow overlayfs to act more like a standards
>  compliant filesystem:
> =20
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
> =20
>  Enabled with the mount option "xino=3Dauto" or "xino=3Don", with the mod=
ule
>  option "xino_auto=3Don" or with the kernel config option
> @@ -604,7 +607,7 @@ a crash or deadlock.
> =20
>  Offline changes, when the overlay is not mounted, are allowed to the
>  upper tree.  Offline changes to the lower tree are only allowed if the
> -"metadata only copy up", "inode index", "xino" and "redirect_dir" featur=
es
> +"metacopy", "index", "xino" and "redirect_dir" features
>  have not been used.  If the lower tree is modified and any of these
>  features has been used, the behavior of the overlay is undefined,
>  though it will not result in a crash or deadlock.

LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--31sZhyVSKfZYntyY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZXqKGwAKCRD2uYlJVVFO
o6vSAQC9NznGsTGPcl5y6bO/FAHgDhRXjaK4ie4FAraFodE77AD/bcbiUgzzRiih
0mCmbI4Pq3PzTLS9asSJwpb9wUujMgQ=
=efUf
-----END PGP SIGNATURE-----

--31sZhyVSKfZYntyY--

Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMvdZfFB"
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D47F7;
	Wed, 13 Dec 2023 20:53:31 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1d336760e72so25134995ad.3;
        Wed, 13 Dec 2023 20:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702529611; x=1703134411; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4p0JqWlRVWER244oAYMvSvdAagyaTbFx+ZsxdGp8c8M=;
        b=QMvdZfFBa2pGPhZC+ka1DxMZG3p0KmP02Dg9iXXhh8kAeVCsWeHBphw+F7QW/5Dg5f
         TMGVTdabs9ZaK9ek5cucsyfD3sZ8/AmuheO95IacKu1K4A/hmqL6lX90PjFg7nLPGvfh
         oaUUOsggfDaAyyGMHiewWcSKYlEt/OHABYotY6Qkk6d5k3omp04LHsaPsvVy+BqZbu8C
         +0kPONzWCHvtWKIyTDhiB35RLa2lPbE0TUvm5Bchyh9TsG61iSWJQRVsjUKiojKw4M4v
         FDYblX/mMJ1CwQCZcAszX3xAs41D6C8/yDQ59YuBm/PyKMz7bLYZDc3Q/w1UqxqKT2BN
         md1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702529611; x=1703134411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4p0JqWlRVWER244oAYMvSvdAagyaTbFx+ZsxdGp8c8M=;
        b=UBjESvzNHUwzfjZuubxLJASY4T8+fSVRLqTZ9Y111KkFpNaQpmhF8ZFznqIuW2GtPE
         O+7euVtzt1EMs4Fvnac44l1g0H5VxTdIiOgk+c8ppYOvcE9C7PAmXGQuwnKVVFrlBUg0
         VBdaxH+PeB8MtGSw0i5oLiUV3OiC8kNyxXm3+pWNCkScNRYqE9m8zrqhsLCma5aTiaAG
         vRZlHkdbGA4D/1YS8wTTVQcfETo3K9FusNh2QqzPHr2SB99mj5d47Rl65ZmE9AFAFca2
         0a8Xz7F7vAsEXu6h+kLO9u/DAExQ7Iq8QcBeg+7sk7jNi+pFU/w1N6EJwn9yk71IWIEs
         Rq8w==
X-Gm-Message-State: AOJu0YzCQSSqdgtebqaDFosVvSOjeuSsfwpLzO6HAW3YpC5eVMOaIsqf
	AZui4JONSRxP7aw77zSFiYk=
X-Google-Smtp-Source: AGHT+IHAqa8+Nqzgnl1SThnXZLfEgHcjKaUcsvdJRH7qqzuRRzk8bk9ia9EeE0DvDVQ02wHsuKBBHg==
X-Received: by 2002:a17:902:8696:b0:1d2:ec9b:92a with SMTP id g22-20020a170902869600b001d2ec9b092amr8059975plo.73.1702529610501;
        Wed, 13 Dec 2023 20:53:30 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id g13-20020a170902d5cd00b001d1d6f6b67dsm11422784plh.147.2023.12.13.20.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 20:53:30 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id D1340114F75F3; Thu, 14 Dec 2023 11:53:26 +0700 (WIB)
Date: Thu, 14 Dec 2023 11:53:26 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] overlayfs.rst: fix ReST formatting
Message-ID: <ZXqKRv0eqBiDFqvi@archie.me>
References: <20231213123422.344600-1-amir73il@gmail.com>
 <20231213123422.344600-3-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QN94/mCG3tiHzC20"
Content-Disposition: inline
In-Reply-To: <20231213123422.344600-3-amir73il@gmail.com>


--QN94/mCG3tiHzC20
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 13, 2023 at 02:34:22PM +0200, Amir Goldstein wrote:
> Fix some indentation issues and fix missing newlines in quoted text
> by converting quoted text to code blocks.
>=20
> Unindent a) b) enumerated list to workaround github displaying it
> as numbered list.
>=20
> Reported-by: Christian Brauner <brauner@kernel.org>
> Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  Documentation/filesystems/overlayfs.rst | 63 +++++++++++++------------
>  1 file changed, 32 insertions(+), 31 deletions(-)
>=20
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 926396fdc5eb..a36f3a2a2d4b 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -118,7 +118,7 @@ Where both upper and lower objects are directories, a=
 merged directory
>  is formed.
> =20
>  At mount time, the two directories given as mount options "lowerdir" and
> -"upperdir" are combined into a merged directory:
> +"upperdir" are combined into a merged directory::
> =20
>    mount -t overlay overlay -olowerdir=3D/lower,upperdir=3D/upper,\
>    workdir=3D/work /merged
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
> =20
>  Check (a) ensures consistency (1) since owner, group, mode and posix acls
>  are copied up.  On the other hand it can result in server enforced
> @@ -311,11 +311,11 @@ to create setups where the consistency rule (1) doe=
s not hold; normally,
>  however, the mounting task will have sufficient privileges to perform all
>  operations.
> =20
> -Another way to demonstrate this model is drawing parallels between
> +Another way to demonstrate this model is drawing parallels between::
> =20
>    mount -t overlay overlay -olowerdir=3D/lower,upperdir=3D/upper,... /me=
rged
> =20
> -and
> +and::
> =20
>    cp -a /lower /upper
>    mount --bind /upper /merged
> @@ -328,7 +328,7 @@ Multiple lower layers
>  ---------------------
> =20
>  Multiple lower layers can now be given using the colon (":") as a
> -separator character between the directory names.  For example:
> +separator character between the directory names.  For example::
> =20
>    mount -t overlay overlay -olowerdir=3D/lower1:/lower2:/lower3 /merged
> =20
> @@ -340,13 +340,13 @@ rightmost one and going left.  In the above example=
 lower1 will be the
>  top, lower2 the middle and lower3 the bottom layer.
> =20
>  Note: directory names containing colons can be provided as lower layer by
> -escaping the colons with a single backslash.  For example:
> +escaping the colons with a single backslash.  For example::
> =20
>    mount -t overlay overlay -olowerdir=3D/a\:lower\:\:dir /merged
> =20
>  Since kernel version v6.8, directory names containing colons can also
>  be configured as lower layer using the "lowerdir+" mount options and the
> -fsconfig syscall from new mount api.  For example:
> +fsconfig syscall from new mount api.  For example::
> =20
>    fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/a:lower::dir", 0);
> =20
> @@ -390,11 +390,11 @@ Data-only lower layers
>  With "metacopy" feature enabled, an overlayfs regular file may be a comp=
osition
>  of information from up to three different layers:
> =20
> - 1) metadata from a file in the upper layer
> +1) metadata from a file in the upper layer
> =20
> - 2) st_ino and st_dev object identifier from a file in a lower layer
> +2) st_ino and st_dev object identifier from a file in a lower layer
> =20
> - 3) data from a file in another lower layer (further below)
> +3) data from a file in another lower layer (further below)
> =20
>  The "lower data" file can be on any lower layer, except from the top most
>  lower layer.
> @@ -405,7 +405,7 @@ A normal lower layer is not allowed to be below a dat=
a-only layer, so single
>  colon separators are not allowed to the right of double colon ("::") sep=
arators.
> =20
> =20
> -For example:
> +For example::
> =20
>    mount -t overlay overlay -olowerdir=3D/l1:/l2:/l3::/do1::/do2 /merged
> =20
> @@ -419,7 +419,7 @@ to the absolute path of the "lower data" file in the =
"data-only" lower layer.
> =20
>  Since kernel version v6.8, "data-only" lower layers can also be added us=
ing
>  the "datadir+" mount options and the fsconfig syscall from new mount api.
> -For example:
> +For example::
> =20
>    fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l1", 0);
>    fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l2", 0);
> @@ -429,7 +429,7 @@ For example:
> =20
> =20
>  fs-verity support
> -----------------------
> +-----------------
> =20
>  During metadata copy up of a lower file, if the source file has
>  fs-verity enabled and overlay verity support is enabled, then the
> @@ -653,9 +653,10 @@ following rules apply:
>     encode an upper file handle from upper inode
> =20
>  The encoded overlay file handle includes:
> - - Header including path type information (e.g. lower/upper)
> - - UUID of the underlying filesystem
> - - Underlying filesystem encoding of underlying inode
> +
> +- Header including path type information (e.g. lower/upper)
> +- UUID of the underlying filesystem
> +- Underlying filesystem encoding of underlying inode
> =20
>  This encoding format is identical to the encoding format file handles th=
at
>  are stored in extended attribute "trusted.overlay.origin".
> @@ -773,9 +774,9 @@ Testsuite
>  There's a testsuite originally developed by David Howells and currently
>  maintained by Amir Goldstein at:
> =20
> -  https://github.com/amir73il/unionmount-testsuite.git
> +https://github.com/amir73il/unionmount-testsuite.git
> =20
> -Run as root:
> +Run as root::
> =20
>    # cd unionmount-testsuite
>    # ./run --ov --verify

LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--QN94/mCG3tiHzC20
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZXqKRgAKCRD2uYlJVVFO
ox7rAP9GmjFmHd4pwrcch09X3eeh6E9U4bZBPxWrvTE+yuf0eAEA1dtRezsFR8Xn
YHtAaL4TGBC9LmhUK68BNfa1y6lhhwA=
=eBfG
-----END PGP SIGNATURE-----

--QN94/mCG3tiHzC20--

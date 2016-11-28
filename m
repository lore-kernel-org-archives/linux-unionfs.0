From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Subject: Re: [PATCH] ovl: tentative fix for broken vfs_open() on stacked
 overlayfs.
Date: Mon, 28 Nov 2016 12:06:09 +0100
Message-ID: <20161128110609.GB27319@chrystal.oracle.com>
References: <20161125145604.GG6842@chrystal.oracle.com>
 <20161125170923.21674-1-quentin.casasnovas@oracle.com>
 <20161125192847.GH6842@chrystal.oracle.com>
 <20161128094518.GC2622@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47385 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932523AbcK1LBc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 28 Nov 2016 06:01:32 -0500
Content-Disposition: inline
In-Reply-To: <20161128094518.GC2622@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 28, 2016 at 10:45:18AM +0100, Miklos Szeredi wrote:
> On Fri, Nov 25, 2016 at 08:28:47PM +0100, Quentin Casasnovas wrote:
> > On Fri, Nov 25, 2016 at 06:09:23PM +0100, Quentin Casasnovas wrote:
> > > If two overlayfs filesystems are stacked on top of each other, then w=
e need
> > > to recurse when opening a file.  This used to work and was first brok=
en by:
> > >=20
> > >   4bacc9c9234c ("overlayfs: Make f_path always point to the overlay..=
=2E")
> > >=20
> > > and fixed by:
> > >=20
> > >   1c8a47df36d7 ("ovl: fix open in stacked overlay")
> > >=20
> > > But it looks like it was re-introduced in:
> > >=20
> > >   2d902671ce1c ("vfs: merge .d_select_inode() into .d_real()")
>=20
>=20
> Following patch should fix it (it's there in your patch, so you weren't t=
oo far
> off).  It needs more testing and review, but I think it fixes the basic p=
roblem.
>=20
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index edd46a0e951d..f4d2f63fa53a 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -328,7 +328,7 @@ static struct dentry *ovl_d_real(struct dentry *dentr=
y,
>  	if (!real)
>  		goto bug;
> =20
> -	if (!inode || inode =3D=3D d_inode(real))
> +	if (inode && inode =3D=3D d_inode(real))
>  		return real;
> =20
>  	/* Handle recursion */

The above patch works for me, thanks!

Tested-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>

Q

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJYPA+bAAoJEB5Tt01po9cNhUgP/3NRt05husypwFon18SOPxx0
TK7O7Gjhkf6ps+w5sYB3p49lU3avh7F/KEVli2tBWEOBD48ggTmPLxkfyj3fgz83
nIgTf8JnJabbD6LVBl81xy7rshaZ8dTD6d1H6ovBuxh3OEaxmB9iDqBRRXbzy2pX
jaT4pYkSBI9Xumub4rZ2pbaoZONcTBcAIFoRE0sz8zEPZadeaJXeka66cOisvvn7
5SrrnG2P8LqFz/vb89ioZSzLjSSZf8g0BI57bWjp0mU331qdtTGAOH+8K0a170uK
MdoR3NDLFzZFCZ4X9wip/q9L9NfJTEKnZrwc+6jAmFhgjAje2vMW8PKgeiHEa8By
KRm3+B7Lv9Qk0uauD4oCRHOqHoybj4ezXeSfb0zM++Pv72/RLl8Buwb1m812dqkk
eGjNHdepK4jF9wGVsN+uSNFXu5ST2WvL8QUebDIXud8UbuV34fzsdXl93jXbpQo5
A/bLsQFoSzQ6uGJkDqdGvH/MM3G9F+1nKjsqqyLzhAAyZS+OC7NqilpmeprecxGL
WssLV1wy+sd/WcQaOjcfgq94jaqfLlRJAW9nz7NBB6ijB1YQ7nbIJ7+/dilW2QjL
9bGwsfL/3qUIj7sS5AO5iAEGA7Pjws+iubeXaiulsVKjvSTPJVx37Dk5d2wbbuX8
1lS6xikL46y3j8WTTwRl
=5xRD
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--

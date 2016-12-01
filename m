From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Subject: Re: [PATCH] ovl: tentative fix for broken vfs_open() on stacked
 overlayfs.
Date: Thu, 1 Dec 2016 17:20:44 +0100
Message-ID: <20161201162044.GI25293@chrystal.oracle.com>
References: <20161129093229.GD2622@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FUFe+yI/t+r3nyH4"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28441 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933966AbcLAQQN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Dec 2016 11:16:13 -0500
Content-Disposition: inline
In-Reply-To: <20161129093229.GD2622@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>


--FUFe+yI/t+r3nyH4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2016 at 10:32:29AM +0100, Miklos Szeredi wrote:
> On Mon, Nov 28, 2016 at 12:06:09PM +0100, Quentin Casasnovas wrote:
>=20
> > > > > But it looks like it was re-introduced in:
> > > > >=20
> > > > >   2d902671ce1c ("vfs: merge .d_select_inode() into .d_real()")
>=20
> Here's a slightly different patch.  It should work exactly the same, but =
the
> error handling is hopefully less broken.
>=20

Tested-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>

Thanks Miklos!

--FUFe+yI/t+r3nyH4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJYQE3cAAoJEB5Tt01po9cNVfIQAKTIqqkfuV9jqt2dyZml6i5k
YH1QHsgEhqEz5TeFiZEI026pVY9R3cHUCvBoZlRUnQv2+b4lnySyjxWtZEPQMfkn
DaU2HI5t1hW48rtH4VUU8kT6CWGfXRRJktdgtYI15tlNG7oPjTeVm+8mrguiP3Yv
jBF6ZUAhmzUC5U/lYPQIYkmCU+ALqn+caMiQzOkkkyjywa9W6cSC/CPdcjVsIgVr
K6Sp4iIasXBbvuIROD0Fflkq2pypQ3/ZgK7D6xDOKYP+zx8xcAMkVQ8rueexO6Vm
N6avnZUjbN5/+PjrQ4mkm0NTY/M3PozRobS/kcrwKZW24T6UrjvYoS0HDMnTsXsv
mWIGz4ykJPLdmm8YoziMbmsNA8HBXlD20pjq3MBl/RDpPrYrIPq/h/RQqX954dPB
lZ9RDDxAiIm8dQe7RmQ+O9F2hbtBwGplEC06NdRO3470046GUVZt1iSDC4KFo40D
HDJtjXHPpRhq63EwXCWXCzFOjm6WvaUHkeKYHfrbhBUBV7xlIHW01FUTyd/AEY82
CHT0lX2yl5s35c6nsvf1u6smwTouei7vsq4OWFOGUkPYlwG1K54j5J1e9dkTbW25
7KLc/DeHjDmJxzcG6oMXFU4gfmwRjGS6vwHFV0dgB/I0hes8rckpwu42toRuVmzw
epNhxosCCYuj3VKaQdsw
=fD48
-----END PGP SIGNATURE-----

--FUFe+yI/t+r3nyH4--

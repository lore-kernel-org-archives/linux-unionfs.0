From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: unionfs-next branch
Date: Fri, 14 Nov 2014 10:12:31 +1100
Message-ID: <20141114101231.0ec5d954@canb.auug.org.au>
References: <CAJfpegvmrSTMYdfp=Bg7ZeCX_aTDyvD57MLA67HecmLAYuFBDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ueEC_sIdXhGv_OMY8q7Z1Ac"; protocol="application/pgp-signature"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:57842 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933920AbaKMXMi (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 13 Nov 2014 18:12:38 -0500
In-Reply-To: <CAJfpegvmrSTMYdfp=Bg7ZeCX_aTDyvD57MLA67HecmLAYuFBDw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

--Sig_/ueEC_sIdXhGv_OMY8q7Z1Ac
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Miklos,

On Thu, 13 Nov 2014 10:20:19 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Could you please add the following branch to -next:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayf=
s-next

Added from today with just you as the contact.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/ueEC_sIdXhGv_OMY8q7Z1Ac
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUZTrjAAoJEMDTa8Ir7ZwVZIcP/A7u6OlLeMPOP18wv/WTfpD0
nZo/flhU4L2BVGtNFpwqsaPqk1t8vDMruteCB9/IlbWlKnapx0i+YANfvlFYQHWg
UThzeamR9HLD7qAfYOvRoOy3RnrJ5svLPXdFJp+l3Iwv2gHK2Y7cAx09OiBx4RgC
Am8EPGB8bEnFxNgyCmyHEwpt+PkKMfdMrO80EeYAfUCMtWT6IXNyUmnpg6ETPcw1
68vINgx3VFQQKj/H1ymFWwSM4/iOOde3P4BDIyLqvc2uLABdzFgj1seosksm1JqT
Vs/I+h+6csisoYmMBrn3yF8hJA3k3Dlo4xeI7mHwHWdthpaG1xI/zze2ZnHL48Iv
wvr543ARiU/gjNPSdMt3QQnaTxk/bTNlgw+kNx2QmVw0p9JRlUoAOXbK+ObugZFW
VzWr6tywmegH0m7FQct3DECfjBs/CtpnlA9Enwtw/vC6dDNqEBfTve6QUSGmCJZ5
okQEnpU6nGUSLmAD5ADyG84WupVrKaLCBC1+wlF1tFViN5t2xP99B5pvlmRUzlC2
rTIyRfyCsxlawSohAeLWZBFIxaZ1mSYAwgWQ6oR8oUPBgqofuiRoi43o6Y4bBVfq
ZG5duJicKnGvbf4wQydkKiR8x2NO3MhTtt6gx0D7sEL/yjxEQhpnr5YoDYzr5ycF
PfM0M9y0sWYmXSemHXaF
=x1r9
-----END PGP SIGNATURE-----

--Sig_/ueEC_sIdXhGv_OMY8q7Z1Ac--

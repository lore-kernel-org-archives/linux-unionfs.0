From: Matthew Cengia <mattcen@cyber.com.au>
Subject: Re: Fwd: overlayfs+selinux error: OPNOTSUPP
Date: Tue, 22 Sep 2015 09:50:36 +1000
Message-ID: <20150921235035.GK22582@cyber.com.au>
References: <20150921074335.GI22582@cyber.com.au>
 <19636.1442846044@jrobl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="z4D23EFnZpzTzcHd"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from stomp.cyber.com.au ([203.7.155.6]:59248 "EHLO
	stomp.cyber.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471AbbIUXuk (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 21 Sep 2015 19:50:40 -0400
Content-Disposition: inline
In-Reply-To: <19636.1442846044@jrobl>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: linux-unionfs@vger.kernel.org


--z4D23EFnZpzTzcHd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2015-09-21 23:34, J. R. Okajima wrote:
[...]
> (from the quoted post)
> ----------------------------------------------------------------------
> aufs doesn't support SELinux, so I had to switch to overlayfs.
> So now my target is Debian 8 / Linux 4.1 / systemd / overlayfs / SELinux.
> ----------------------------------------------------------------------
>=20
> I know aufs is not your main concern, but would you tell me why do you
> think that aufs doesn't support SELinux? If I remember correctly, aufs
> can live with SELinux. It might be due to your (or your distribution's)
> configuration, especially CONFIG_AUFS_XATTR.

If I recall correctly, there are two problems here. The main problem is
that we upgraded to Linux 4.1 to support newer hardware, and given that
has overlayfs in mainline, the Debian kernel maintainers, I believe,
completely removed support for aufs in the kernel, leaving us with
little choice unless we wanted to apply our own patches, which we'd very
much rather avoid.

The other problem seems to be that I can't find that CONFIG_AUFS_XATTR
option in the kernel config I'm using. It may be that the aufs version
I'm using doesn't support xattrs at all, but a newer version does. The
kernel that I just checked this on was
https://packages.debian.org/jessie/linux-image-3.16.0-4-amd64.

Additionally, I've not chased this up yet, but I've received a response
=66rom the SELinux list indicating that the problem is related to me not
having the policy loaded yet:
http://thread.gmane.org/gmane.comp.security.selinux/23045/focus=3D23053. I
think this will be the next thing I investigate.

--=20
Regards,
Matthew Cengia

--z4D23EFnZpzTzcHd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQJ8BAEBCgBmBQJWAJfLXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRDMTlFRDFDRTdERThBODYxMjhGOEQwNEI5
RDBCNTY1NTlCRjZBNTYyAAoJEJ0LVlWb9qVi2A0P/AwxiVEWtMUGNewl/EZzMI+Q
lKIg2GNlkC+5yxAM/P3p3Y0ZdRvdZMbCbP+8d5kJSCaLIH4248JvB/mDA9cu5Ne3
8Tk8mb0ZY0FjlOFxN725RRbxFXiqg8L63TwwC9QlTiIgPpfiUcJGjuf/SVVvf9J4
+j+SCveM4HOkv2TkKogiRmPWJdVbNpcTc7Z/r9s/vyAO/u07fBEsm5cLw0OLV3o1
SdnczU0Ir6G2dabk7hU/xiuk6LwXjOjifaoIgUYY9ruwclI1btidicuzh/40eNbE
W+TxJCNcWOO14XExExSL9xXG4spM0Xg82TMOKuge9Y0rvZ4j8CrNG1eyPx83ng5p
cbnRLUUfWaGolSwO9arA3hQ8TDZvTadT4nd2enJMVRBOfrLnbBp6V1fgDvZZt6wN
4gJT9M62KsKpO6s6+1SwjxDIes1WYPtr6BM5xQHO9FM9T/xYQPyyzFUeZ6zbNcey
m39IB6Uiw+LOKnjCXitbwbNeGzuFw9njSDSjWSQra1OEq7talzx+awTZov5lf1Pe
2x7M0KN9DMA1L0BPNKO6MMeIhnEE/cThTG69LndRo6X43i75nyE17dMXGDS9jyDb
2GncVzIxuzpYTa12GWwNBZPy76/2ayG+kt0t5cr9dqMf2f+qqVXeiOFqz46NvJPj
RWTrEzOzPvZWSgMczXBG
=E/S/
-----END PGP SIGNATURE-----

--z4D23EFnZpzTzcHd--

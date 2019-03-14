Return-Path: <aszlig@nix.build>
Date: Thu, 14 Mar 2019 11:37:58 +0100
From: aszlig <aszlig@nix.build>
Subject: Re: Failure to execute file on overlayfs during switch_root/chroot
Message-ID: <20190314103757.GA4654@dnyarri>
References: <20181207121027.GA5996@dnyarri>
 <CAJfpegsu6DUHVVac2PSyGoFW4pAKm3UH0XLg5+SMvN5XZmNzFw@mail.gmail.com>
 <20190202172914.GA17406@dnyarri>
 <CAOQ4uxh0L_u-UzJAcQ=QO+D-9VkoSy2HHofXig4=AqDo0vWTmg@mail.gmail.com>
 <20190203101340.GA6934@dnyarri>
 <CAOQ4uxhBbAX5QizTAaBaSeUUmtOewzFcqb+RpxDxaz_5P5d7fQ@mail.gmail.com>
 <20190314010928.GA748@dnyarri>
 <CAOQ4uxg_zS8XBTaDqdUKxRvzntF-_Pq=vqk1sYJGfhaPKsJRLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg_zS8XBTaDqdUKxRvzntF-_Pq=vqk1sYJGfhaPKsJRLA@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Graham Christensen <graham@grahamc.com>, Samuel Dionne-Riel <samuel@dionne-riel.com>, cleverca22@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2019 at 09:47:23AM +0200, Amir Goldstein wrote:
> Overlayfs is not expected to modify the lower layer.

That is pretty clear, I mean that's the whole point of overlayfs, right? :-)

> OTOH, I can't really think anything that should break horribly if
> we allow overlayfs to update atime on a writable lower layer??

It wasn't using O_NOATIME prior to Linux 4.19 (which is where this was star=
ting
to break our tooling), but the bisected commit I mentioned initially
(a6518f73e60e5044656d1ba587e7463479a9381a) was (implicitly) introducing
O_NOATIME, so to the contrary I'd say it would actually un-break networking
file systems with overlayfs.

a!
--=20
aszlig
Universal dilettante

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTdUmvHdn26KBbAleVoQInOZ+u2kQUCXIovBAAKCRBoQInOZ+u2
kXENAPwPFcjmqyJzzX0fokrXkilqLyzI3++QEIRo4nLIiFB3hAD9EuddUXTTlJ1s
2JVxMfMmDMvtb5D86VCZmbN9Du/ymQg=
=qULp
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--

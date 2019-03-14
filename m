Return-Path: <aszlig@nix.build>
Date: Thu, 14 Mar 2019 20:45:07 +0100
From: aszlig <aszlig@nix.build>
Subject: Re: Failure to execute file on overlayfs during switch_root/chroot
Message-ID: <20190314194507.GA27112@dnyarri>
References: <20181207121027.GA5996@dnyarri>
 <CAJfpegsu6DUHVVac2PSyGoFW4pAKm3UH0XLg5+SMvN5XZmNzFw@mail.gmail.com>
 <20190202172914.GA17406@dnyarri>
 <CAOQ4uxh0L_u-UzJAcQ=QO+D-9VkoSy2HHofXig4=AqDo0vWTmg@mail.gmail.com>
 <20190203101340.GA6934@dnyarri>
 <CAOQ4uxhBbAX5QizTAaBaSeUUmtOewzFcqb+RpxDxaz_5P5d7fQ@mail.gmail.com>
 <20190314010928.GA748@dnyarri>
 <CAOQ4uxg_zS8XBTaDqdUKxRvzntF-_Pq=vqk1sYJGfhaPKsJRLA@mail.gmail.com>
 <20190314103757.GA4654@dnyarri>
 <CAOQ4uxipOHT+OzPtFE1ZoSFEJSrEr-MErwp5KX+tBwXq39sx8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <CAOQ4uxipOHT+OzPtFE1ZoSFEJSrEr-MErwp5KX+tBwXq39sx8g@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Graham Christensen <graham@grahamc.com>, Samuel Dionne-Riel <samuel@dionne-riel.com>, michael bishop <cleverca22@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2019 at 09:38:05PM +0200, Amir Goldstein wrote:
> OTOH, ovl_path_open() from ovl_copy_up_data() does open lower
> file with O_NOATIME, so I am a bit surprised you did not see the
> same issue there.

Good point actually, I did forget about that. The reason we did not run into
this issue is because Nix store paths are *never* changed (only new ones are
added) and the store is mounted read-only (new paths are crated using a mou=
nt
namespace where the store path is writable).

So yes, actually the O_NOATIME should also be removed from ovl_copy_up_data=
().

a!
--=20
aszlig
Universal dilettante

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTdUmvHdn26KBbAleVoQInOZ+u2kQUCXIqvQQAKCRBoQInOZ+u2
kZzSAP4sH05kJZEOmBFTTWtXeo9l5ytgjH5Ko7WTofkT8omsHwEAt/9q93kNCH/O
cVjq8S8WaE7bbQArjXMUoKinuTm07A4=
=QD4F
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--

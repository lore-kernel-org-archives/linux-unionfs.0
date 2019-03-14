Return-Path: <aszlig@nix.build>
Date: Thu, 14 Mar 2019 02:20:12 +0100
From: aszlig <aszlig@nix.build>
Subject: Re: Failure to execute file on overlayfs during switch_root/chroot
Message-ID: <20190314012012.GA2126@dnyarri>
References: <20181207121027.GA5996@dnyarri>
 <CAJfpegsu6DUHVVac2PSyGoFW4pAKm3UH0XLg5+SMvN5XZmNzFw@mail.gmail.com>
 <20190202172914.GA17406@dnyarri>
 <CAOQ4uxh0L_u-UzJAcQ=QO+D-9VkoSy2HHofXig4=AqDo0vWTmg@mail.gmail.com>
 <20190203101340.GA6934@dnyarri>
 <CAOQ4uxhBbAX5QizTAaBaSeUUmtOewzFcqb+RpxDxaz_5P5d7fQ@mail.gmail.com>
 <20190314010928.GA748@dnyarri>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20190314010928.GA748@dnyarri>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, graham@grahamc.com, samuel@dionne-riel.com, cleverca22@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2019 at 02:09:28AM +0100, aszlig wrote:
>   * Using inode_owner_or_capable() to check whether to add O_NOATIME, whi=
ch has
>     the downside that it will not work with networked file systems where =
you
>     map different users (I've tested this already with a different patch[=
1]).

Actually forgot the reference to [1]:

https://gist.github.com/aszlig/f3679a5fec5a3b94b74a1fe62c651174

a!
--=20
aszlig
Universal dilettante

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTdUmvHdn26KBbAleVoQInOZ+u2kQUCXImsSgAKCRBoQInOZ+u2
kVRcAQDVDJpTMO+caM2PYLK0ET8ooBcBB7YJCTES10EhmDJczAD+K3ELVqU/M2J3
tlEHX/GfdXkNFSgfBf/4AX+u87WWRAE=
=3iGW
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--

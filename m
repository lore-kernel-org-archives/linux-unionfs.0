Return-Path: <aszlig@nix.build>
Date: Sun, 3 Feb 2019 11:13:41 +0100
From: aszlig <aszlig@nix.build>
Subject: Re: Failure to execute file on overlayfs during switch_root/chroot
Message-ID: <20190203101340.GA6934@dnyarri>
References: <20181207121027.GA5996@dnyarri>
 <CAJfpegsu6DUHVVac2PSyGoFW4pAKm3UH0XLg5+SMvN5XZmNzFw@mail.gmail.com>
 <20190202172914.GA17406@dnyarri>
 <CAOQ4uxh0L_u-UzJAcQ=QO+D-9VkoSy2HHofXig4=AqDo0vWTmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh0L_u-UzJAcQ=QO+D-9VkoSy2HHofXig4=AqDo0vWTmg@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, graham@grahamc.com, samuel@dionne-riel.com
List-ID: <linux-unionfs@vger.kernel.org>


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 03, 2019 at 07:37:55AM +0200, Amir Goldstein wrote:
> Any access? or just execute? Can you share pr_debug output of access
> to file that is not execute?

Sure, same result (EPERM) there, here is the output and the changed Nix
expression (in case you want to reproduce it):

https://gist.github.com/aszlig/0b5ae4b03208a117b6f737772ff0eed8

I also added a stat on these files to check whether it happens there as wel=
l,
but it only occurs when reading them.

Here is the relevant pr_debug output:

open(000000007ee735e6[/regular_top/l], 0100000) -> (0000000080f3d7f9, 00)
open(00000000f7778f73[somesubdir/regular_sub/l], 0100000) -> (0000000080f3d=
7f9, 00)

> FWIW, I ran unionmount-testsuite (tweaked) with 9p as lower as it passed,
> so no obvious regressions with 9p as lower.

Okay, one other thing that I can think of is that might be triggering the i=
ssue
is that the Nix build process (on the host side) runs in a chroot with a few
separate namespaces[1], including a mount namespace.

a!

[1]: https://github.com/NixOS/nix/blob/92d08c02c84be34ec0df56ed718526c38284=
5d1a/src/libstore/build.cc#L2216-L2218
--=20
aszlig
Universal dilettante

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTdUmvHdn26KBbAleVoQInOZ+u2kQUCXFa+0gAKCRBoQInOZ+u2
kW2gAQCz37gAaJA3NE/2tMMxjowq4WwTFFaRK7YrR1gFxZBqXwD+NavWWYSjy3pD
vgOxZtg3I6jfEHsR/3HUaHyC6TTG1gE=
=kBKJ
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--

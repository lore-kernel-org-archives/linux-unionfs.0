Return-Path: <aszlig@nix.build>
Date: Sat, 2 Feb 2019 18:29:15 +0100
From: aszlig <aszlig@nix.build>
Subject: Re: Failure to execute file on overlayfs during switch_root/chroot
Message-ID: <20190202172914.GA17406@dnyarri>
References: <20181207121027.GA5996@dnyarri>
 <CAJfpegsu6DUHVVac2PSyGoFW4pAKm3UH0XLg5+SMvN5XZmNzFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <CAJfpegsu6DUHVVac2PSyGoFW4pAKm3UH0XLg5+SMvN5XZmNzFw@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, graham@grahamc.com, samuel@dionne-riel.com
List-ID: <linux-unionfs@vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good morning,

Apparently this mail (sent on 2019-01-29) didn't end up on the list, even
though the MTA has accepted it, so I'm resending the mail without attachmen=
ts.

To get list readers on page, this is the description of the problem I've se=
nt
to Miklos a while ago:

> Since kernel 4.19 our NixOS test suites are failing[1] with EPERM while
> trying to switch_root from the initrd to a new overlayfs-mounted file sys=
tem.
>
> The tests are running using a 9p[2] filesystem as the lowerdir[3].
>
> After bisecting I found a6518f73e60e5044656d1ba587e7463479a9381a to be the
> culprit. I also tested by reverting said commit on top of the latest 4.19=
=2E7
> stable kernel and the issue doesn't occur there.
>
> To reproduce this with Nix[4], the following command can be used:
>
> nix-build -I nixpkgs=3Dchannel:nixos-unstable '<nixpkgs/nixos/tests/lates=
t-kernel.nix>'

Unfortunately I have only been able to reproduce this with NixOS VM tests, =
so I
still have no clue what could be wrong here. However, the problem turns out=
 to
not be related to switch_root, initrd and execve but generally seems to be =
an
issue with our test scenario.

The scenario with NixOS VM tests is as follows:

  * It uses QEMU in conjunction with 9p to share /nix/store with the guest.
  * The guest VM mounts that share in $targetRoot/nix/.ro-store during init=
rd.
  * Still in initrd, an overlayfs is mounted on $targetRoot/nix/store with =
the
    following options:

     lowerdir=3D$targetRoot/nix/.ro-store
     upperdir=3D$targetRoot/nix/.rw-store/store
     workdir=3D$targetRoot/nix/.rw-store/work

  * Since the aforementioned change however, file access to any of the file=
s on
    $targetRoot/nix/store and /nix/store (after the switch_root) fails with
    EPERM.

I haven't yet been able to pin down which part of this exactly causes the
error, but running overlayfs without 9p works so I *think* it might be rela=
ted
to 9p or possibly remote file systems in general (don't remember exactly, b=
ut I
think I tried it with sshfs as well)?

Right now, we're shortly before our next stable release and while reverting
a6518f73e60e5044656d1ba587e7463479a9381a fixes the issue above, it breaks
overlayfs elsewhere[5].

On Fri, Dec 07, 2018 at 01:59:59PM +0100, Miklos Szeredi wrote:
> Not sure what debug options are available; would you be able to strace
> the switch_root process?  Enable pr_debug for overlayfs ( echo "file
> fs/overlayfs/* +p" > <debugfs>/dynamic_debug/control)?

The full log, the output of strace -f and the Nix expression file I was usi=
ng
for the test, along with the kernel config can be found here:

https://gist.github.com/aszlig/2eb6be1d1af38313c6b0584ea6a8d0c8

As mentioned, I could only reproduce this with our NixOS VM tests, so in or=
der
to reproduce it, you need to have Nix[4] installed and run the Nix expressi=
on
file reproducing the issue with:

  nix-build overlayfs-linux-4.19-regression.nix

All of my machines are running NixOS, so I gave that expressions to one Arch
Linux user running kernel 4.19.12 and an Ubuntu user with kernel 4.15 just =
to
be sure it is reproducible on non NixOS hosts.

> Would you mind moving this to a public mailing list for more eyeballs?

Sure, I just added the linux-unionfs list to CC, along with a few Nixers.

a!

PS: I also tested this with the latest mainline (5.0-rc4) and the issue sti=
ll
    exists.

[1]: https://nix-cache.s3.amazonaws.com/log/6dps3pkw19q9vr9xfhm0npddnykxkj6=
m-vm-test-run-kernel-latest.drv
[2]: https://github.com/NixOS/nixpkgs/blob/e1b7493cfedba7e715070faa64b77c39=
d0cf4bff/nixos/modules/virtualisation/qemu-vm.nix#L494
[3]: https://github.com/NixOS/nixpkgs/blob/e1b7493cfedba7e715070faa64b77c39=
d0cf4bff/nixos/modules/virtualisation/qemu-vm.nix#L449-L450
[4]: https://nixos.org/nix/
[5]: https://github.com/NixOS/nixpkgs/issues/54509
--=20
aszlig
Universal dilettante

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTdUmvHdn26KBbAleVoQInOZ+u2kQUCXFXTYQAKCRBoQInOZ+u2
kdTxAQC5O+2BiVS/iAc4K5UdXOj6uVaKKABw0pduxHpSWcAnkQD/W37N/7UGsOap
R9xET4f4Vwl7ywc8ebcbOHJtbdZK9gM=
=rzbJ
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--

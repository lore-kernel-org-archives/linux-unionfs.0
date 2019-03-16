Return-Path: <aszlig@nix.build>
Date: Sat, 16 Mar 2019 12:17:28 +0100
From: aszlig <aszlig@nix.build>
Subject: Re: [PATCH] ovl: Don't open files with O_NOATIME in lowerdir
Message-ID: <20190316111728.GA25189@dnyarri>
References: <CAOQ4uxipOHT+OzPtFE1ZoSFEJSrEr-MErwp5KX+tBwXq39sx8g@mail.gmail.com>
 <20190316032135.GA9179@dnyarri>
 <CAOQ4uxgW6AcBBwys-RE=6=F=rsaVk1qSgRZOEGRGfJe08XCnuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgW6AcBBwys-RE=6=F=rsaVk1qSgRZOEGRGfJe08XCnuA@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Graham Christensen <graham@grahamc.com>, Samuel Dionne-Riel <samuel@dionne-riel.com>, michael bishop <cleverca22@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 16, 2019 at 11:09:56AM +0200, Amir Goldstein wrote:
> Have a client of network fs pass O_NOATIME flag to server seems strange
> in the first place. Is that what other network filesystems do?
> man page for open(2) says "This flag may not be effective on all filesyst=
ems.
> One example is NFS, where the server maintains the access time."

For 9p there is P9_DOTL_NOATIME, which is passed along to the server, so 9p
implementations out there (including the QEMU one, see below) might actually
have the same issue. I haven't checked it with other implementations or even
stuff like NFS in userspace implementations.

Given that the manpage says "This flag may not be effective on all
filesystems", maybe it's even a better idea to actually ignore the flag in =
VFS
altogether if the owner doesn't match or the user isn't the superuser inste=
ad
of returning EPERM?

> What about ovl_dir_open() and ovl_dir_read() that also call
> ovl_path_open() why aren't you seeing the problem there?

Okay, just looked into the QEMU source + fs/9p and it seems to abstract away
directory listing, so when it comes to that on the host side, it essentially
ignores all flags and instead does a readdir() C library call.

So you're correct, the patch is still incomplete.

> > -       old_file =3D ovl_path_open(old, O_LARGEFILE | O_RDONLY);
> > +       /*
> > +        * Note that this is not using ovl_path_open() because it will =
use
> > +        * O_NOATIME, which in turn could cause issues for networked fi=
le
> > +        * systems.
> > +        */
> > +       old_file =3D dentry_open(old, O_LARGEFILE | O_RDONLY, current_c=
red());
>
> Not like this.
> I think you could check for (path->mnt & MNT_NOATIME) in ovl_path_open()
> and not add the O_NOATIME flag in that case for the plain reason that it =
is
> redundant.

Good point, but if a file system isn't mounted with noatime, that would sti=
ll
mean that we're passing along O_NOATIME, which then subsequently fails with
EPERM.

> Or pass is_upper argument to ovl_path_open() to determine if flag should =
be
> set, so you won't change behavior for upper.

That sounds like a better idea, however, I haven't checked what the behavio=
ur
was for upperdir in pre-4.19, maybe this has changed behaviour as well?

> >         old_cred =3D ovl_override_creds(inode->i_sb);
> > -       realfile =3D open_with_fake_path(&file->f_path, file->f_flags |=
 O_NOATIME,
> > +       realfile =3D open_with_fake_path(&file->f_path, file->f_flags,
> >                                        realinode, current_cred());
>
> Not what I meant.
> I meant that if you pass realpath to open_with_fake_path() and if realpath
> is lower, I see no need to add the O_NOATIME flag.
> For upper path there could be other implications, so I am not sure this is
> the right thing to do, but for lower path, I don't see any obvious proble=
m.

I was under the impression that O_NOATIME wasn't passed at all in pre-4.19,=
 but
will need to check whether that's really the case.

> I would need Miklos to weight in on this, but I am guessing his first que=
tion
> would be "Why?" referring to why should 9p server respect O_NOATIME,
> so you'd better have an answer for that first.

As mentioned above, it seems that O_NOATIME is part of the 9p protocol, how=
ever
the versions of the 9p specs I found on the net were pretty incomplete with=
 no
details on open flags. They are however passed along in the Linux
implementation.

Now I'm not sure where to go from here, because on one side you could say i=
t's
a kernel regression, because the O_NOATIME flag gets passed since 4.19, whe=
reas
it wasn't passed in pre-4.19.

On the other side, we could simply patch QEMU to just ignore O_NOATIME
altogether, but I bet once I submit a patch to upstream QEMU they'll probab=
ly
point me back here.

a!
--=20
aszlig
Universal dilettante

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTdUmvHdn26KBbAleVoQInOZ+u2kQUCXIzbQwAKCRBoQInOZ+u2
kS3BAP9jyXJptqWZZmaR+qqW46Q3iAKT9ty4bq2dK2o02y43rwEA7cz7877a0G5r
pNz1TpXMwUIseVthVr7Wouc8e/UK/wM=
=AIS6
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--

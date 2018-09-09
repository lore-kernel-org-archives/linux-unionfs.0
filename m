From: Christian Brauner <christian@brauner.io>
Subject: Re: Overlayfs @ Containers and checkpoint/restart micro-conference
 at LPC2018
Date: Sun, 9 Sep 2018 11:18:54 +0200
Message-ID: <20180909091549.yekfuds633afhrgw@mailbox.org>
References: <CAOQ4uxih7rPPLquJZFL9HtSbUFi-cCOR21qH4_-ORxxLKGsLXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cim7sjy3gi6q4ywl"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxih7rPPLquJZFL9HtSbUFi-cCOR21qH4_-ORxxLKGsLXg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Stephane Graber <stgraber@ubuntu.com>, containers@lists.linuxfoundation.org, Miklos Szeredi <miklos@szeredi.hu>, Netdev <netdev@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, lxc-users@lists.linuxcontainers.org, LSM List <linux-security-module@vger.kernel.org>, lxc-devel@lists.linuxcontainers.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "zhangyi (F)" <yi.zhang@huawei.com>
List-Id: linux-unionfs@vger.kernel.org


--cim7sjy3gi6q4ywl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 09, 2018 at 09:31:02AM +0300, Amir Goldstein wrote:
> On Sun, Sep 9, 2018 at 4:31 AM Christian Brauner <christian@brauner.io> w=
rote:
> >
> ...
> > > [cc: overlayfs developers]
> > >
> > > Hi St=C3=A9phane!
> >
> > Hey Amir,
> >
> > I'm one of the co-organizers of the microconf.
> >
> > >
> > > I am not planing to travel to LPC this year, so this is more of an FY=
I than
> > > a CFP, but maybe another overlayfs developer can pick up this glove??
> >
> > Sure, that would be great.
> >
> > >
> > > For the past two years I have participated in the effort to fix overl=
ayfs
> > > "non-standard" behavior:
> > > https://github.com/amir73il/overlayfs/wiki/Overlayfs-non-standard-beh=
avior
> >
> > Yes, this is an issue that we were aware of for a long time and it
> > something that has made overlayfs somewhat more difficult to use than it
> > should be.
> >
> > >
> > > Allegedly, this effort went underway to improve the experience of ove=
rlayfs
> > > users, who are mostly applications running inside containers. For bac=
kward
> > > compatibility reasons, container runtimes will need to opt-in for fix=
ing some
> > > of the legacy behavior.
> > >
> > > In reality, I have seen very little cross list interaction between li=
nux-unionfs
> > > and containers mailing lists. The only interaction I recall in the
> > > past two years
> > > ended up in a fix in overlayfs to require opt-in for fixing yet anoth=
er backward
> > > compatible bad behavior, although docker did follow up shortly after =
to fix
> > > bad practice in container runtime:
> > > https://github.com/moby/moby/issues/34672
> > >
> > > So the questions I would like to relay to the micro-conf participants=
 w.r.t the
> > > new opt-in overlayfs behavior:
> > > 1. Did you know?
> >
> > I personally did not know about the new opt-in behavior. More reason to
> > give a talk! :)
> >
> > > 2. Do you care?
> >
> > Yes, we do care. However - speaking as LXC upstream now - we have
> > recently focused on getting shiftfs to work rather than overlayfs.
> >
>=20
> IMO, as I expressed it in the past, the fact that shiftfs development is =
not
> collaborated with overlayfs developers is a pitty.
> Yes shiftfs has a different purpose than overlayfs, but they have common
> use cases and common problems as well.

My team hast just started to be more involved with shifts development a
few months back. Overlayfs is definitely an inspiration and we even once
thought about making shifts an extension of overlayfs.
Seth Forshee on my team is currently actively working on shifts and
getting a POC ready.
When he has a POC based on James' patchset there will be an RFC that
will go to fsdevel and all parties of interest.
There will also be an update on shifts development during the microconf.
So even more reason for developers from overlayfs to stop by.

>=20
> > We are more than happy to have a overlayfs talk at the microconf. If
> > someone were to talk about:
> > - What non-standard behavior has already been fixed?
> > - How has it been fixed?
>=20
> IMO, those questions are covered quite well by the wiki and overlayfs.txt
> documentation in kernel tree.

It's still worth bringing this in front of other developers in the form
of a talk.

>=20
> > - What non-standard behavior still needs to be fixed?
>=20
> There's the mmap MAP_SHARED case covered in the wiki
> and there may be other small stuff, but not sure if anyone cares
> about them, so the question should really be directed back to the audienc=
e...

The audience that cares enough to send patches for it will likely be at
the microconf so it's a good place to discuss it.

>=20
> > - Outstanding problems that either still need a solution or
> >   are solved but one would like feedback on the implementation. This way
> >   we can have a good discussion.
> >
>=20
> I think one of the chsallange that distros and container runtime will nee=
d to
> deal with is managing format versions of overlay "images".
> The reason the new features require user or distro to opt-in is because
> the new features create overlayfs images that are not fully compatible wi=
th old
> kernels and existing container image tools (i.e. export/migrate image).

As I said we will be very thankful for any talk about such problems.

Thanks!
Christian

>=20
> The new overlayfs-progs project by Zhangyi is going to help in that respe=
ct:
> https://github.com/hisilicon/overlayfs-progs
> As well as Zhangyi's work on overlayfs feature set support:
> https://marc.info/?l=3Dlinux-unionfs&m=3D153302911328159&w=3D2
>=20
> Thanks,
> Amir.

--cim7sjy3gi6q4ywl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE7btrcuORLb1XUhEwjrBW1T7ssS0FAluU5X0ACgkQjrBW1T7s
sS0FCw//asOq0MHjAZER95SeDW4LuLCJshDu7xEkW7ktN/ol/DMSn2jwcgorCvyL
Lz0my5XKyU6PzARCisTmyeYepoj1NEBeuDsZ2gEjn6o8MjpXhUsp8pghA2h6HQAc
x/asT8KZpRe1rl4sJRRnauSfJZdHUWCN/h3zKv5Rf/V9X22deI8QUN/wj2U5FXy9
lIJ3PN6BkQ56xf+jdxwWbnSFzRm3c8L4PC1t6nubpwld6n/UOllnqLBNvQ1f2saW
aB5uO4zIePkUZhSPLrXvXJCxcdFDqAqtEsfGDuYnQusAbvzas1V2EK5KaDz1+9+O
Q5BVFNC1OueY9rkt/aJFtqvLuFk2uHSzLhAbU9uiFYj+2DZ5QSrd54f36G2ou1ls
B0Yr6ODCcMnfhlSzQKzdpyGo4W6VxpayeAr7IPj40q4uCtHyv/uiLGJFzKVe91Q0
DFsM7PfJzFq47dQQSeNpmGyQKAV4U2nL3BrUc1E61cn80GkXEoRh6UPP4aWovvJk
I/uaxc0tX3cjsXU4hRNmlkcWUkcgOkyO/m7bKEuHamzTYU6GFiKIVrriXtS/um95
7fsaL0snj/+uDUjynMmPWfh1cwflCIoxp1P4rqlXx9xc6C8vIyAHuOuvBf9iAu5a
SroX7ZQTJCcTRey+c37BzQvUB0gD88QVJzCvkBIcfMamn08nSxo=
=I/kG
-----END PGP SIGNATURE-----

--cim7sjy3gi6q4ywl--

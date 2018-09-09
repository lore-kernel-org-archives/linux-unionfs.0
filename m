From: Christian Brauner <christian@brauner.io>
Subject: Re: Containers and checkpoint/restart micro-conference at LPC2018
Date: Sun, 9 Sep 2018 03:31:08 +0200
Message-ID: <20180909013108.6wjlx75ztqjipepg@mailbox.org>
References: <20180813161015.GD18492@castiana>
 <20180908045935.GA9201@castiana>
 <CAOQ4uxiQEpofdS97kxnii8LtVW2QiKAGvjjaH0Px-Bj3eHVCFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c3exq3raqqdh7jx4"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiQEpofdS97kxnii8LtVW2QiKAGvjjaH0Px-Bj3eHVCFA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Stephane Graber <stgraber@ubuntu.com>, containers@lists.linuxfoundation.org, Miklos Szeredi <miklos@szeredi.hu>, Netdev <netdev@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, lxc-users@lists.linuxcontainers.org, LSM List <linux-security-module@vger.kernel.org>, lxc-devel@lists.linuxcontainers.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org


--c3exq3raqqdh7jx4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 08, 2018 at 10:41:41AM +0300, Amir Goldstein wrote:
> On Sat, Sep 8, 2018 at 8:00 AM St=C3=A9phane Graber <stgraber@ubuntu.com>=
 wrote:
> >
> > On Mon, Aug 13, 2018 at 12:10:15PM -0400, St=C3=A9phane Graber wrote:
> > > Hello,
> > >
> > > This year's edition of the Linux Plumbers Conference will once again
> > > have a containers micro-conference but this time around we'll have tw=
ice
> > > the usual amount of time and will include the content that would
> > > traditionally go into the checkpoint/restore micro-conference.
> > >
> > > LPC2018 will be held in Vancouver, Canada from the 13th to the 15th of
> > > November, co-located with the Linux Kernel Summit.
> > >
> > >
> > > We're looking for discussion topics around kernel work related to
> > > containers and namespacing, resource control, access control,
> > > checkpoint/restore of kernel structures, filesystem/mount handling for
> > > containers and any related userspace work.
> > >
> > >
> > > The format of the event will mostly be discussions where someone
> > > introduces a given topic/problem and it then gets discussed for 20-30=
min
> > > before moving on to something else. There will also be limited room f=
or
> > > short demos of recent work with shorter 15min slots.
> > >
> > >
> > > Details can be found here:
> > >
> > >   https://discuss.linuxcontainers.org/t/containers-micro-conference-a=
t-linux-plumbers-2018/2417
> > >
> > >
> > > Looking forward to seeing you in Vancouver!
> >
> > Hello,
> >
> > We've added an extra week to the CFP, new deadline is Friday 14th of Se=
ptember.
> >
> > If you were thinking about sending something bug then forgot or just
> > missed the deadline, now is your chance to send it!
> >
>=20
> [cc: overlayfs developers]
>=20
> Hi St=C3=A9phane!

Hey Amir,

I'm one of the co-organizers of the microconf.

>=20
> I am not planing to travel to LPC this year, so this is more of an FYI th=
an
> a CFP, but maybe another overlayfs developer can pick up this glove??

Sure, that would be great.

>=20
> For the past two years I have participated in the effort to fix overlayfs
> "non-standard" behavior:
> https://github.com/amir73il/overlayfs/wiki/Overlayfs-non-standard-behavior

Yes, this is an issue that we were aware of for a long time and it
something that has made overlayfs somewhat more difficult to use than it
should be.

>=20
> Allegedly, this effort went underway to improve the experience of overlay=
fs
> users, who are mostly applications running inside containers. For backward
> compatibility reasons, container runtimes will need to opt-in for fixing =
some
> of the legacy behavior.
>=20
> In reality, I have seen very little cross list interaction between linux-=
unionfs
> and containers mailing lists. The only interaction I recall in the
> past two years
> ended up in a fix in overlayfs to require opt-in for fixing yet another b=
ackward
> compatible bad behavior, although docker did follow up shortly after to f=
ix
> bad practice in container runtime:
> https://github.com/moby/moby/issues/34672
>=20
> So the questions I would like to relay to the micro-conf participants w.r=
=2Et the
> new opt-in overlayfs behavior:
> 1. Did you know?

I personally did not know about the new opt-in behavior. More reason to
give a talk! :)

> 2. Do you care?

Yes, we do care. However - speaking as LXC upstream now - we have
recently focused on getting shiftfs to work rather than overlayfs.

We are more than happy to have a overlayfs talk at the microconf. If
someone were to talk about:
- What non-standard behavior has already been fixed?
- How has it been fixed?
- What non-standard behavior still needs to be fixed?
- Outstanding problems that either still need a solution or
  are solved but one would like feedback on the implementation. This way
  we can have a good discussion.

Thanks!
Christian

--c3exq3raqqdh7jx4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE7btrcuORLb1XUhEwjrBW1T7ssS0FAluUd9sACgkQjrBW1T7s
sS2r+g//X0yy30Pu0weSi/KJplt4rgzyT1BmvsZJa+P+2lQoadk86fYhSh2CsM95
ieh7h+L3ChgHYX0UisXkWGZ42Ylg0SM+SAYO4KSX4shIpHfudDzExLzEVk6pONRB
bxwBWEW1/7VD83thG72C5Xe+xv16VLCRcRq58RhgzJ3y97rbU1FRTKzxAAZ64ESg
yegEl4GR3BvkNlONkC4oSL0nC0Vyhx+LitVmwVE3I8jQI8uTdbFIF79zKQz7tGNz
A+HlHK9XawdWXsqEMnofE6IeZi5kUsm4j1jvahlcR0f3xhXJSM1KVDmboYkTMHec
lQ56Gfetjq7iAna4J7pja68uirQAF3H6T+G+H9lObZYYa5tlbRGKhTnxLo2sQGVr
ImPEDhKfGpXmx107Tzs9ZHfsokikqyBlI9NR+CfmcS3Yc3sMl0n+e9oC0NSWRGhr
zHYYmdS4SDnYOQjGdbZuZyBUgEgG5rkZNRtTFC6yndDAD3sXx4EqwWVIQ2tBXcFz
cd95Dqe4JRPkyEcfvV8hpd37Bc4CKhDQThhTpcKj5KUBEIaGTp0Kh0eQS+8rJx3D
EqWr7D7qQYRR6BNXnmm9fyclWIWk1gotyjK/GQJPlhOVGdqWer1F9eU/zc3iFYOI
wHIhSeZ2N5tDhmNhPbhCrjiKYH8uPzoSMIc0xEILjBEl1p6I/gM=
=YlFe
-----END PGP SIGNATURE-----

--c3exq3raqqdh7jx4--

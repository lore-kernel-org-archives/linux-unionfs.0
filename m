Return-Path: <VincentGuerard@eaton.com>
From: "Guerard, Vincent" <VincentGuerard@eaton.com>
Subject: RE: [EXTERNAL] Re: Copy_up function fail with ubifs on upper layer
Date: Tue, 11 Dec 2018 15:32:25 +0000
Message-ID: <D10F1B1F86300941BC976D07C04B3AA0016E5EC6@LOUTCSMB11.napa.ad.etn.com>
References: <D10F1B1F86300941BC976D07C04B3AA0016E4CC7@LOUTCSMB11.napa.ad.etn.com>
 <D10F1B1F86300941BC976D07C04B3AA0016E5E59@LOUTCSMB11.napa.ad.etn.com>
 <CAOQ4uxip5zOUWwg4j3kWuQMPe83F=bwrtHQK0BfmQE=AGm8=5w@mail.gmail.com>
 <18631278.YDA9SCgu4D@blindfold>
In-Reply-To: <18631278.YDA9SCgu4D@blindfold>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Indeed the patch didn't solve the problem.

I trigger this every times.
No power cuts is involved.

Every time I try to do an operation on a file that hasn't already been copi=
ed on the upper layer, it fail when overlayfs try to set xattr.=20
I tried removing the patch in ubifs which cause the fail (https://lore.kern=
el.org/patchwork/patch/960502/) and everything work now.
I also just found this patch: https://lore.kernel.org/patchwork/patch/98656=
3/ , so I guess its safe to remove it.

Thanks,
Vincent

-----Original Message-----
From: Richard Weinberger [mailto:richard@nod.at]=20
Sent: December 11, 2018 4:54 AM
To: Amir Goldstein
Cc: Guerard, Vincent; Miklos Szeredi; overlayfs
Subject: Re: [EXTERNAL] Re: Copy_up function fail with ubifs on upper layer

Am Montag, 10. Dezember 2018, 21:37:46 CET schrieb Amir Goldstein:
> On Mon, Dec 10, 2018 at 10:02 PM Guerard, Vincent=20
> <VincentGuerard@eaton.com> wrote:
> >
> > Here's the output when overlayfs try to do a copy up with the original =
function calls order and with debug enabled:
> >
> > root@io2200:/etc# mv machine-id machine-id1
> > mv: cannot move 'machine-id' to 'machine-id1': No such file or=20
> > directory root@io2200:/etc# dmesg [ 2999.275275]=20
> > tmpfile(upper.work/work, 0100644) =3D 0 [ 2999.278789]=20
> > setxattr(work/#232, "trusted.overlay.origin", "(null)", 0x0) =3D -2
> >
> > And here's with inverted function calls:
> > root@io2200:/etc# mv securetty securetty1 root@io2200:/etc# dmesg [ =20
> > 659.515200] tmpfile(upper.work/work, 0100400) =3D 0 [  659.515422]=20
> > link(work/#164, etc/securetty) =3D 0 [  659.518577]=20
> > setxattr(work/#164, "trusted.overlay.origin", "(null)", 0x0) =3D 0 [ =20
> > 659.522153] rename(etc/securetty, etc/securetty1, 0x4)
> >
>=20
> Maybe this is the patch you need:
> https://marc.info/?l=3Dlinux-unionfs&m=3D154070087430992&w=3D2

Hmm, this fixes something different.
Vincent, do you trigger this every time or just once?
Is a power-cut involved?

Long story short, I need more info.

Thanks,
//richard

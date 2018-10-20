Return-Path: <richard@nod.at>
From: Richard Weinberger <richard@nod.at>
Subject: Re: Regression in handling power cuts since 3a1e819b4e80 ("ovl: store file handle of lower inode on copy up")
Date: Sat, 20 Oct 2018 08:58:49 +0200
Message-ID: <1818049.3sKzV5Nla8@blindfold>
In-Reply-To: <CACna6rzvf3+rL9x1uY2NrSd-OD_p08mhzY9hT6dpTOYseja_-g@mail.gmail.com>
References: <CACna6rx3YBNYKGu7T-J2J-S_3yr-oafJf3pL5TbGDFRzU6dihg@mail.gmail.com> <11759557.52cTf2r1oB@blindfold> <CACna6rzvf3+rL9x1uY2NrSd-OD_p08mhzY9hT6dpTOYseja_-g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org, Russell Senior <russell@personaltelco.net>, OpenWrt Development List <openwrt-devel@lists.openwrt.org>
List-ID: <linux-unionfs@vger.kernel.org>

Am Freitag, 19. Oktober 2018, 23:28:33 CEST schrieb Rafa=C5=82 Mi=C5=82ecki:
> On Fri, 19 Oct 2018 at 16:59, Richard Weinberger <richard@nod.at> wrote:
> > Am Freitag, 19. Oktober 2018, 16:45:53 CEST schrieb Richard Weinberger:
> > > Well, I fear it uncovers a problem in UBIFS. We had already problems =
with overlayfs.
> > > Did you bisect the problem and you are sure that the said commit is t=
he first bad commit?
> >
> > Another thing, UBIFS has no export operations, so overlayfs will fall b=
ack to xattrs,
> > if I read the commit correctly.
> > Maybe this is the root of the problem.
> >
> > I'm currently traveling, so I cannot test much. Please make sure whether
> > 3a1e819b4e80 is really the first bad commit.
> > Then I can go for a bug hunt. :-)
>=20
> I did another test and everything keeps pointing to the 3a1e819b4e80.
>=20
> 1) I switched to the 4.12.14
> 2) I confirmed problem exists there
> 3) I added "return 0;" at the beginning of ovl_set_origin()
> 4) I confirmed problem disappeared

Okay. But I still think we're facing some UBIFS problem.

To double check, on Linux 4.12.14 the problem exists and by reverting 3a1e8=
19b4e80 (or making it a nop)
it goes away?
Do you see the warning regarding the double orphan only in the bad case?

Thanks,
//richard

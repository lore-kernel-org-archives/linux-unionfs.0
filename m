Return-Path: <zajec5@gmail.com>
MIME-Version: 1.0
References: <CACna6rx3YBNYKGu7T-J2J-S_3yr-oafJf3pL5TbGDFRzU6dihg@mail.gmail.com>
 <1457198086.5374.1539960353710.JavaMail.zimbra@nod.at> <11759557.52cTf2r1oB@blindfold>
In-Reply-To: <11759557.52cTf2r1oB@blindfold>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 19 Oct 2018 23:28:33 +0200
Message-ID: <CACna6rzvf3+rL9x1uY2NrSd-OD_p08mhzY9hT6dpTOYseja_-g@mail.gmail.com>
Subject: Re: Regression in handling power cuts since 3a1e819b4e80 ("ovl: store
 file handle of lower inode on copy up")
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Richard Weinberger <richard@nod.at>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org, Russell Senior <russell@personaltelco.net>, OpenWrt Development List <openwrt-devel@lists.openwrt.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, 19 Oct 2018 at 16:59, Richard Weinberger <richard@nod.at> wrote:
> Am Freitag, 19. Oktober 2018, 16:45:53 CEST schrieb Richard Weinberger:
> > Well, I fear it uncovers a problem in UBIFS. We had already problems wi=
th overlayfs.
> > Did you bisect the problem and you are sure that the said commit is the=
 first bad commit?
>
> Another thing, UBIFS has no export operations, so overlayfs will fall bac=
k to xattrs,
> if I read the commit correctly.
> Maybe this is the root of the problem.
>
> I'm currently traveling, so I cannot test much. Please make sure whether
> 3a1e819b4e80 is really the first bad commit.
> Then I can go for a bug hunt. :-)

I did another test and everything keeps pointing to the 3a1e819b4e80.

1) I switched to the 4.12.14
2) I confirmed problem exists there
3) I added "return 0;" at the beginning of ovl_set_origin()
4) I confirmed problem disappeared

--=20
Rafa=C5=82

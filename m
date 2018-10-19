Return-Path: <richard@nod.at>
From: Richard Weinberger <richard@nod.at>
Subject: Re: Regression in handling power cuts since 3a1e819b4e80 ("ovl: store file handle of lower inode on copy up")
Date: Fri, 19 Oct 2018 16:59:47 +0200
Message-ID: <11759557.52cTf2r1oB@blindfold>
In-Reply-To: <1457198086.5374.1539960353710.JavaMail.zimbra@nod.at>
References: <CACna6rx3YBNYKGu7T-J2J-S_3yr-oafJf3pL5TbGDFRzU6dihg@mail.gmail.com> <1457198086.5374.1539960353710.JavaMail.zimbra@nod.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org, Russell Senior <russell@personaltelco.net>, OpenWrt Development List <openwrt-devel@lists.openwrt.org>
List-ID: <linux-unionfs@vger.kernel.org>

Am Freitag, 19. Oktober 2018, 16:45:53 CEST schrieb Richard Weinberger:
> Well, I fear it uncovers a problem in UBIFS. We had already problems with overlayfs.
> Did you bisect the problem and you are sure that the said commit is the first bad commit?

Another thing, UBIFS has no export operations, so overlayfs will fall back to xattrs,
if I read the commit correctly.
Maybe this is the root of the problem.

I'm currently traveling, so I cannot test much. Please make sure whether
3a1e819b4e80 is really the first bad commit.
Then I can go for a bug hunt. :-)

Thanks,
//richard

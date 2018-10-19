Return-Path: <zajec5@gmail.com>
MIME-Version: 1.0
References: <CACna6rx3YBNYKGu7T-J2J-S_3yr-oafJf3pL5TbGDFRzU6dihg@mail.gmail.com>
 <1457198086.5374.1539960353710.JavaMail.zimbra@nod.at>
In-Reply-To: <1457198086.5374.1539960353710.JavaMail.zimbra@nod.at>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 19 Oct 2018 18:18:05 +0200
Message-ID: <CACna6rw+dFq+V6QWakOs77P5_3f75M6x7n06hDCCXGBE=GKHxg@mail.gmail.com>
Subject: Re: Regression in handling power cuts since 3a1e819b4e80 ("ovl: store
 file handle of lower inode on copy up")
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Richard Weinberger <richard@nod.at>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org, Russell Senior <russell@personaltelco.net>, OpenWrt Development List <openwrt-devel@lists.openwrt.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, 19 Oct 2018 at 16:45, Richard Weinberger <richard@nod.at> wrote:
> ----- Urspr=C3=BCngliche Mail -----
> > Von: "Rafa=C5=82 Mi=C5=82ecki" <zajec5@gmail.com>
> > An: "Amir Goldstein" <amir73il@gmail.com>, "Miklos Szeredi" <miklos@sze=
redi.hu>, linux-unionfs@vger.kernel.org,
> > linux-fsdevel@vger.kernel.org, "richard" <richard@nod.at>, "Artem Bityu=
tskiy" <dedekind1@gmail.com>, "Adrian Hunter"
> > <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org, "Russell Seni=
or" <russell@personaltelco.net>, "OpenWrt
> > Development List" <openwrt-devel@lists.openwrt.org>
> > Gesendet: Freitag, 19. Oktober 2018 14:31:29
> > Betreff: Regression in handling power cuts since 3a1e819b4e80 ("ovl: st=
ore file handle of lower inode on copy up")
>
> > Hi,
> >
> > Since OpenWrt switch from kernel 4.9 to 4.14 users started randomly
> > reporting file system corruptions. OpenWrt uses overlay(fs) with
> > squashfs as lowerdir and ubifs as upperdir. Russell managed to isolate
> > & describe test case for reproducing corruption when doing a power cut
> > after first boot.
> >
> > Interestingly it cannot be reproduced on all devices (NAND dependant?
> > arch dependant?!). I couldn't reproduce that problem on none of my
> > Broadcom devices (ARM=3Dy ARCH_BCM_5301X=3Dy) so I had to buy Ubiquiti
> > EdgeRouter X (ER-X) (MIPS=3Dy RALINK=3Dy). I reproduced it then and
> > bisected down to the commit 3a1e819b4e80 ("ovl: store file handle of
> > lower inode on copy up").
> >
> > FWIW I was told it also affects:
> > Asus RT-AC58U (ARCH_IPQ40XX=3Dy)
> > powerpc
> > RB493G, DIR-860L (ATH79=3Dy)
> >
> > Steps to reproduce the problem:
> > 1) Flash firmware
> > 2) Boot (for the first time)
> > 3) Let the init script copy config files from lowerdir to the upperdir
> > 4) Wait for boot to finish
> > 5) Verify content of some unmodified config on overlay, using either:
> > hexdump -C /etc/config/dropbear
> > hexdump -C /overlay/upper/etc/config/dropbear
> > 6) Power cut & boot again
> > 7) Check the content of the same file
>
> Do you have something also I can test?
> A C reproducer? An xfstest case?

I don't. I may try writing one with info provided my Amir, but I'm not
experienced with such things, won't be trivial for me.


> > After above regressing commit the later check confirms the file size
> > looks correct but it's filled with all 00-es only.
> >
> > Can I ask you to check if there is something possibly wrong with the
> > above ovl commit? Or does it expose some problem with the ubifs? Or
> > maybe the whole UBI?
>
> Well, I fear it uncovers a problem in UBIFS. We had already problems with=
 overlayfs.
> Did you bisect the problem and you are sure that the said commit is the f=
irst bad commit?

Yes, I did git bisect and then double verified that.


> > FWIW testing above commit (and one before it) always results in single
> > error in the kernel log:
> > [   14.250184] UBIFS error (ubi0:1 pid 637): ubifs_add_orphan: orphaned=
 twice
>
> Please show the full log.
> The orphan thing rings a bell, we had such a bug already.

I will get a full log later. Please note I wrote this error appears
*with* ovl commit and also with one commit earlier. So it's very
unlikely to be caused by ovl change. Most likely it was some error
present in 4.11.0-rc1 and fixed later (not related to ovl).

--=20
Rafa=C5=82

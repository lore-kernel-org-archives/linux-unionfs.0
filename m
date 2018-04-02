Return-Path: <cgxu519@gmx.com>
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH 2/2] ovl: return error when specifying unchangeable
 options in remount
From: "cgxu519@gmx.com" <cgxu519@gmx.com>
In-Reply-To: <CAOQ4uxhQ6exzwNTzTo01Tby7pk0ONWgqZyHOBnB31Yr5vPtPjg@mail.gmail.com>
Date: Mon, 2 Apr 2018 20:32:08 +0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <0A20195D-8A68-4955-AAE2-992A926B7333@gmx.com>
References: <1522558675-70756-1-git-send-email-cgxu519@gmx.com>
 <1522558675-70756-2-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxhyT5V4+8OBgDk3aVHcXtmvN62ZYiHppoAGMbNNCSmDYw@mail.gmail.com>
 <8935A82A-6C2B-46B8-9E88-D1FD987C4542@gmx.com>
 <CAOQ4uxioPwtEBZyYps-hnyAXoH_zVr2pdP-Rkc4Xb_ZMicw16w@mail.gmail.com>
 <C2127448-4F45-43F9-AF2E-2CF51BC980A4@gmx.com>
 <CAOQ4uxhc9ceXeS-WJYc8MPh73ipVUxEO7iK5uCVikfrpq2bG7A@mail.gmail.com>
 <5FEFAF00-D681-4FD2-AF4A-CDEB8A2B3CC6@gmx.com>
 <CAOQ4uxhQ6exzwNTzTo01Tby7pk0ONWgqZyHOBnB31Yr5vPtPjg@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "cgxu519@gmx.com" <cgxu519@gmx.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

=D4=DA 2018=C4=EA4=D4=C21=C8=D5=A3=AC=CF=C2=CE=E79:31=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Sun, Apr 1, 2018 at 3:16 PM, cgxu519@gmx.com <cgxu519@gmx.com> =
wrote:
>> =D4=DA 2018=C4=EA4=D4=C21=C8=D5=A3=AC=CF=C2=CE=E77:33=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>=20
> [...]
>>>=20
>>> Not much logic. Only 3 classifications that can be encoded in 3 =
different
>>> parsing helpers:
>>> 1. disallow change
>>> 2. allow change NULL->non-NULL
>>> 3. allow change non-NULL->non-NULL
>>>=20
>>> The parsing code doesn't do anything except setting the new
>>> values in config struct and applying one of the limitations above
>>> while parsing.
>>=20
>> For example,
>> In ro->rw case, We need check a condition that from mount flags(rw)
>> to consider if workdir/upperdir change to non-NULL from NULL is
>> reasonable. So we have to pass mount flag to option parsing, right?
>>=20
>> If we specify index=3Don with ro->rw, then in the index case, at =
least
>> we should check if workdir/upperdir mount option and rw mount flags =
have
>> already set and based on that to consider index=3Don is reasonable.
>>=20
>=20
> The idea is to encode the limitations that are always enforced in
> parsing code (i.e. options that can never change or that can only
> changed from NULL) and do the rest of the dependency checks
> in outer (remount) code.
>=20
> What you gain is shorter and more generic code to print the error:
> "overlayfs: option %s cannot be changed on remount"
> AND
> "overlayfs: option %s cannot be added on remount=A1=B1

I=A1=AFm wondering how we deal with the case which is specifying same =
option
several times in a remount. More specifically current lowerdir=3Daaa and
specify options -o remount,lowerdir=3Dbbb,lowerdir=3Daaa,ro then if we =
fail
at first different value, it seems we will break compatibility with =
mount
in parsing options.

Thanks,
Chengguang.

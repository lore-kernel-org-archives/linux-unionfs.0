Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5FEFAF00-D681-4FD2-AF4A-CDEB8A2B3CC6@gmx.com>
References: <1522558675-70756-1-git-send-email-cgxu519@gmx.com>
 <1522558675-70756-2-git-send-email-cgxu519@gmx.com> <CAOQ4uxhyT5V4+8OBgDk3aVHcXtmvN62ZYiHppoAGMbNNCSmDYw@mail.gmail.com>
 <8935A82A-6C2B-46B8-9E88-D1FD987C4542@gmx.com> <CAOQ4uxioPwtEBZyYps-hnyAXoH_zVr2pdP-Rkc4Xb_ZMicw16w@mail.gmail.com>
 <C2127448-4F45-43F9-AF2E-2CF51BC980A4@gmx.com> <CAOQ4uxhc9ceXeS-WJYc8MPh73ipVUxEO7iK5uCVikfrpq2bG7A@mail.gmail.com>
 <5FEFAF00-D681-4FD2-AF4A-CDEB8A2B3CC6@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 1 Apr 2018 16:31:43 +0300
Message-ID: <CAOQ4uxhQ6exzwNTzTo01Tby7pk0ONWgqZyHOBnB31Yr5vPtPjg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ovl: return error when specifying unchangeable
 options in remount
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "cgxu519@gmx.com" <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Apr 1, 2018 at 3:16 PM, cgxu519@gmx.com <cgxu519@gmx.com> wrote:
> =E5=9C=A8 2018=E5=B9=B44=E6=9C=881=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=887:3=
3=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
[...]
>>
>> Not much logic. Only 3 classifications that can be encoded in 3 differen=
t
>> parsing helpers:
>> 1. disallow change
>> 2. allow change NULL->non-NULL
>> 3. allow change non-NULL->non-NULL
>>
>> The parsing code doesn't do anything except setting the new
>> values in config struct and applying one of the limitations above
>> while parsing.
>
> For example,
> In ro->rw case, We need check a condition that from mount flags(rw)
> to consider if workdir/upperdir change to non-NULL from NULL is
> reasonable. So we have to pass mount flag to option parsing, right?
>
> If we specify index=3Don with ro->rw, then in the index case, at least
> we should check if workdir/upperdir mount option and rw mount flags have
> already set and based on that to consider index=3Don is reasonable.
>

The idea is to encode the limitations that are always enforced in
parsing code (i.e. options that can never change or that can only
changed from NULL) and do the rest of the dependency checks
in outer (remount) code.

What you gain is shorter and more generic code to print the error:
"overlayfs: option %s cannot be changed on remount"
AND
"overlayfs: option %s cannot be added on remount"

Thanks,
Amir.
